# encoding: utf-8
require 'rubygems'
require './configuration.rb'

def get_selected_features
  db = get_mongo
  col = db[$mongo_selected_terms]
end

def get_page_term_map
  db = get_mongo
  col = db[$mongo_page_term_collection_name]
end

#LSA
def correlate_pages_and_save_to_mongo
  features = get_selected_features.find.to_a
  pages = get_page_term_map

  db = get_mongo
  col = db[$mongo_wiki_correlation]
  col.remove
  pages.find.each do |page|
    terms = page["terms_idf"]
    correlations = []
    pages.find.each do |other_page|
      similarity = 0
      if(other_page["_id"]==page["_id"])
        similarity = 1
      else
        other_page_terms = other_page["terms_idf"]
        a_times_b_sum = 0.0
        a_square_sum = 0.0
        b_square_sum = 0.0
        features.each do |feature|
          term = feature["_id"]
          a = terms[term] || 0
          b = other_page_terms[term] || 0
          a_times_b_sum+= a*b
          a_square_sum+= a*a
          b_square_sum+= b*b
        end
        numerator = a_times_b_sum
        denominator = (Math.sqrt(a_square_sum)*Math.sqrt(b_square_sum))
      similarity = numerator/denominator if denominator>0.0001
      end
      correlations.push({p:other_page["_id"], v: similarity})
    end
    col.insert([{:_id => page["_id"], :correlations=>correlations}])
  end
end
