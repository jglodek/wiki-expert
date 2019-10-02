# encoding: utf-8
require 'rubygems'
require './configuration.rb'

def get_scrapped_data_from_mongo
  db = get_mongo
  col = db[$mongo_wiki_scrap_collection_name]
  col
end

# Expert tags should be text inserted in wiki page text
# their format is: <!-- Expert | Name of the other page | 1.0 -->
# where "<!-- Expert |" is prefix keyword, can vary in whitespace
# where "Name of the other page" is name of correlated wiki page
# where next " | " is separator, can vary in whitespace
# where next "1.0" is correlation of two pages, can be asymetric
# where next "-->" is suffix
def process_expert_tags_and_save_to_mongo
  wiki_pages = get_scrapped_data_from_mongo
  expert_tag_regex = /<!--\s*Expert\s*\|\s*(.+)\s*\|\s*(-?\d+\.\d+|-?\d+)\s*-->/

  # Learn to translate page title to page id
  title_id_hash = {}
  wiki_pages.find.each do |wiki_page|
    title =  wiki_page["title"].downcase.gsub("_", " ")
    title_id_hash[title] = wiki_page["_id"]
  end

  # prepare db connection to push data to
  db = get_mongo
  expert_tags_correlations_col = db[$mongo_expert_tags_correlation]
  expert_tags_correlations_col.remove

  wiki_pages.find.each do |wiki_page|
    correlations = []
    scan = wiki_page["text"].scan expert_tag_regex

    if scan.size>0
      scan.each do |match|
        other_page_title = match[0].downcase.gsub("_", " ")
        correlation = match[1].to_f
        other_page_id = title_id_hash[other_page_title]
        correlations.push({p: other_page_id, v: correlation}) if other_page_id
      end
    end
    expert_tags_correlations_col.insert({_id:wiki_page["_id"], correlations: correlations})
  end
end
