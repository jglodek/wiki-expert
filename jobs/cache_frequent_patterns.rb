# encoding: utf-8
require 'rubygems'
require './configuration.rb'

def cache_frequent_patterns
  db = get_mongo
  corr_col = db[$mongo_query_correlation]
  query_cache = db[$mongo_query_cache]
  query_cache.remove
  term_page_col = db[$mongo_term_page_collection_name]
  corr_col.find.each do |hash|
    puts hash
  end
end
