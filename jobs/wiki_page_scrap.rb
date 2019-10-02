# encoding: utf-8
require 'rubygems'
require 'open-uri'
require 'json'
require './configuration.rb'

def get_wiki_pages_for_category(category, wiki_api_uri)
  category_uri = wiki_api_uri + "?action=query&list=categorymembers&format=json&cmtitle=Category:"+category
  category_uri = URI.escape(category_uri)
  json = JSON.parse(open(category_uri).read)
  pages = []
  json["query"]["categorymembers"].each do |page_info|
    pages.push page_info["pageid"]
  end
  pages
end

def get_wiki_pages_for_categories(categories, wiki_api_uri)
  page_ids = categories.collect do |category|
    get_wiki_pages_for_category(category, wiki_api_uri)
  end
  page_ids.uniq
end



#Gets page_id, page text and page categories
def wiki_page_scrap
  ### GET IDS OF PAGES IN CATEGORIES
  category_page_ids = {}
  $app_categories.each do |category|
    page_ids = get_wiki_pages_for_category(category, $wiki_api_uri)
    category_page_ids[category] = page_ids
  end

  # GET PAGE_ID, TITLE, TEXT from Wiki DB
  db = get_mysql
  text_result = db.query "SELECT page.page_id, page.page_title, text.old_text FROM text JOIN page ON (text.old_id = page.page_latest);"

  #COLLECT PAGE_ID, TITLE, TEXT and CATEGORIES
  grouped_results = []

  text_result.each_hash do |a|
    cats = []
    id = a["page_id"].to_i
    $app_categories.each do |cat|
      cats.push cat if category_page_ids[cat].include? id
    end
    #monkey patch encoding
    a["old_text"].force_encoding("UTF-8")
    a["page_title"].force_encoding("UTF-8")
    grouped_results.push({_id: id, categories: cats, title: a["page_title"],  text: a["old_text"]})
  end
  grouped_results
end

#preforms scraping and leaves data in mongodb
def wiki_page_scrap_and_save_to_mongo
  page_infos = wiki_page_scrap

  #PUT THE COLLECTED TEXT INTO A MONGO_DB
  mongo = get_mongo
  collection = mongo[$mongo_wiki_scrap_collection_name]

  #REMOVE OLD CACHE DATA
  collection.remove
  #PUT NEW SCRAP DATA TO MONGO
  collection.insert page_infos
end


