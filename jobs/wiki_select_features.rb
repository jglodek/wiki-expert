# encoding: utf-8
require 'rubygems'
require './configuration.rb'

def get_pages_with_extracted_features
  db = get_mongo
  page_term_map = db[$mongo_page_term_collection_name]
  term_page_map = db[$mongo_term_page_collection_name]
  return {page_term_map: page_term_map, term_page_map:term_page_map}
end

def select_features
  data = get_pages_with_extracted_features
  page_term_map = data[:page_term_map]
  term_page_map = data[:term_page_map]

  num_of_pages = page_term_map.count
  num_of_terms = term_page_map.count
  space_size = num_of_pages*num_of_terms
  num_pages_in_term_map = 0
  # GET TERMS SORTED BY ADJACENT PAGE COUNT AND TERM LENGTH
  terms = term_page_map.find({},:sort=>[["pages_count",:desc], ["length",:asc]])
  selected_terms = []

  count = 0

  #COLLECT BEST TERMS - heuristic
  #collection is sorted so best terms are on the top
  terms.each do |term|
    count+=1
    if(term["length"]>1)
      # We want only terms with length>1
      num_pages_in_term_map += term["pages_count"]
      selected_terms.push term
    end
    scarcity = num_pages_in_term_map.to_f/(num_of_pages*count)
    if(scarcity<0.1)
      #scarcity of 0.1 is enough for us, we ignore rest of the terms
      break
    end
  end
  selected_terms
end


def wiki_select_features_and_save_to_mongo
  selected_terms = select_features
  db = get_mongo
  col = db[$mongo_selected_terms]
  col.remove
  col.insert selected_terms
end
