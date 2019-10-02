# encoding: utf-8
require 'rubygems'
require './configuration.rb'


def get_scrapped_data_from_mongo
  db = get_mongo
  col = db[$mongo_wiki_scrap_collection_name]
  col.find
end

def wiki_extract_features(scrapped_data)
  page_term_map = {}
  term_page_map = {}

  scrapped_data.each do |wiki_page|
    words = wiki_page["title"].downcase.split("_")
    words += wiki_page["text"].downcase.gsub(/\P{L}/,' ').split(' ')
    words -= polish_wiki_stopwords
    words_number = words.length

    this_page_id = wiki_page["_id"]
    this_page_terms = {}

    max_term_frequnecy = 0

    words.each do |word|
      term = word.stem
      # PAGE TERMS
      this_page_terms[term]||= 0
      this_page_terms[term]+=1

      if(this_page_terms[term]>max_term_frequnecy)
        max_term_frequnecy = this_page_terms[term]
      end

      # DOCUMENT - TERM RELATION
      term_page_map[term]||={}
      term_page_map[term]["pages"]||=[]
      term_page_map[term]["length"]||=term.length
      term_page_map[term]["count"]||=1

      term_page_map[term]["count"]+=1
      term_page_map[term]["pages"].push this_page_id if !term_page_map[term]["pages"].include? this_page_id
    end
    page_term_map[this_page_id]||= {}
    page_term_map[this_page_id][:categories] = wiki_page["categories"]
    page_term_map[this_page_id][:title] = wiki_page["title"]
    page_term_map[this_page_id][:f]=this_page_terms
    page_term_map[this_page_id][:idf] = this_page_terms
    page_term_map[this_page_id][:idf].each do |k,v|
    page_term_map[this_page_id][:idf][k] = v.to_f/max_term_frequnecy
    end
  end
  {page_term_map: page_term_map, term_page_map: term_page_map}
end

def wiki_extract_features_and_save_to_mongo

  #extract features
  data = wiki_extract_features(get_scrapped_data_from_mongo)

  page_term_map = data[:page_term_map]
  term_page_map = data[:term_page_map]
  term_count_map = data[:term_count_map]

  #prepare data for mongodb
  page_term_map_array = page_term_map.collect do |k, v|
    {_id: k, categories: v[:categories], title: v[:title], terms: v[:f], terms_idf: v[:idf], terms_count: v.length}
  end

  term_page_map_array = term_page_map.collect do |k, v|
    {_id: k, pages: v["pages"], pages_count: v["pages"].length, corpus_count: v["count"], length: v["length"]}
  end

  #open mongo db connection
  db = get_mongo

  #get collection to store features
  term_page_col = db[$mongo_term_page_collection_name]
  page_term_col = db[$mongo_page_term_collection_name]

  #remove old data
  term_page_col.remove
  page_term_col.remove

  #insert data into mongo
  term_page_col.insert term_page_map_array
  page_term_col.insert page_term_map_array
end

