# encoding: utf-8
require 'rubygems'
require './configuration.rb'

def cache_terms
  db = get_mongo
  page_term_col = db[$mongo_page_term_collection_name]

  term_page_col = db[$mongo_term_page_collection_name]
  term_cache = db[$mongo_term_search_cache]
  term_cache.remove

  count = 0
  term_page_col.find().each do |term_page|
    term_page["pages"].each do |page_id|
      count+=1
      doc_page_term_data = page_term_col.find(_id: page_id).first
      new_row = {
        _id: count,
        t: term_page["_id"],
        p: page_id,
        nam: doc_page_term_data["title"],
        cat: doc_page_term_data["categories"],
        cor: 1.0/term_page["pages_count"]
      }
      term_cache.insert new_row
    end
  end
end
