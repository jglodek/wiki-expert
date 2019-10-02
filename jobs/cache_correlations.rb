# encoding: utf-8
require 'rubygems'
require './configuration.rb'

class Correlations
  attr_accessor :cols

  def initialize(col)
    if col.class == Array
      @cols = col
    else
      @cols = [{:col => col, :weight=> 1}]
    end
  end

  def *(weight)
    c = Correlations.new([])
    @cols.each do |col|
      c.cols.push({ :col => col[:col], :weight => (col[:weight]*weight)})
    end
    c
  end

  def +(other_correlations)
    Correlations.new( @cols + other_correlations.cols )
  end

  def count
    sum =0
    @cols.each do |col|
      sum+=col[:col].count
    end
    sum
  end

  def each_doc(&block)
    docs = {}
    @cols.each do |col|
      col[:col].find.each do |doc|
        id = doc["_id"]
        docs[id] ||= {}
        doc["correlations"].each do |c|
          p = c["p"]
          v = c["v"]
          if docs[id][p]
            docs[id][p] = [docs[id][p], v].max
          else
            docs[id][p] = v
          end
        end
      end
    end
    docs.each(&block)
  end

end

def get_expert_tag_correlations
  db = get_mongo
  col = db[$mongo_expert_tags_correlation]
  Correlations.new col
end

def get_wiki_page_correlations
  db = get_mongo
  col = db[$mongo_wiki_correlation]
  Correlations.new col
end

def cache_correlations
  etc = get_expert_tag_correlations
  wpc = get_wiki_page_correlations

  correlations = etc*0.5
  correlations += wpc*0.5

  db = get_mongo
  page_term_col = db[$mongo_page_term_collection_name]
  cache_col = db[$mongo_page_correlation_cache]

  cache_col.remove
  count = 0
  correlations.each_doc do |id, correlations|
    correlations.each do |k, v|
      count+=1
      doc_page_term_data = page_term_col.find(_id: k).first
      new_row = {
        _id: count,
        a: id,
        p: k,
        nam: doc_page_term_data["title"],
        cat: doc_page_term_data["categories"],
        cor: v
      }
      cache_col.insert new_row if v>0 && doc_page_term_data["categories"].length>0
    end
  end
end
