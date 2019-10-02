# encoding: utf-8
require './configuration.rb'
require 'json'
require 'sinatra'
require './apis/docs.rb'

#THIS SHOULD BE RUN FROM REPO ROOT DIRECTORY

use Rack::Logger
set :public_folder, 'apis/public'
set :static, true

configure do
  LOGGER = Logger.new("ks-api.log")
end


get '/query/' do
  content_type :json
  query = {}
  result = {}
  begin
    begin
      query = parse_parameters params
      validate_query(query)
    rescue
      status 400
      LOGGER.warn("Invalid query: " + query.inspect + " - #{$!}")
      raise "Query parsing/validation error: #{$!}"
    end
    begin
      result = perform_query query
    rescue
      status 500
      LOGGER.error("Error performing query: " + query.inspect + " - #{$!}")
      raise "Error while performing query!"
    end
    begin
      save_to_history query
    rescue
      LOGGER.error("error saving to history " + query.inspect + " - #{$!}")
    end
    return {query: query,result: result}.to_json
  rescue
    query = params
    LOGGER.warn("Query failed: " + {query: query,error: $! }.to_json)
    return {query: query,error: $! }.to_json
  end
end

def parse_parameters(params)
    begin
      query = {}
      if params[:categories]
        query[:categories] = params[:categories].split(',')
      end
      if params[:doc_ids]
        query[:doc_ids] = parse_unique_int_array params[:doc_ids]
      end
      if params[:query_string]
        query[:query_string] = params[:query_string]
      end
      return query
    rescue
      raise "Error parsing query parameters: #{$!}"
    end
end

def parse_unique_int_array(string)
  a = string.split ","
  a.each_index do |i|
    a[i] = Integer(a[i])
  end
  return a.uniq
end


def validate_query(query)
  raise "Too many docs ids in the query(#{query[:doc_ids].length})" if query[:doc_ids] && query[:doc_ids].length>10
  if query[:categories]
    raise "Invalid categories" if query[:categories].length >70
  end
  raise "Query string too long('#{query[:query_string].length}')" if query[:query_string] && query[:query_string].length >255
end

def perform_query(query)
  categories = $app_categories
  categories = query[:categories]
  docs = Docs.from(categories)
  if query[:doc_ids]
    docs.from_doc_ids(query[:doc_ids])
  end
  if query[:query_string]
    query_string_terms = compute_terms(query[:query_string])
    docs.from_terms(query_string_terms)
  end
  docs.from_frequent_patterns(query)
  docs.form_result
end

def compute_terms(query_string)
    words = query_string.downcase.gsub(/\P{L}/,' ').split(' ')
    words -= polish_wiki_stopwords
    terms = words.collect do |word| word.stem end
    return terms
end

def save_to_history(query)
    db = get_mongo
    col = db[$mongo_query_history]
    col.insert({:q=> query})
end
