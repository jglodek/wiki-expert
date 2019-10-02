namespace :wiki do
  desc "Scraps wikipedia MYSQL and saves scrapped info in mongo-db"
  task :page_scrap do
    require './jobs/wiki_page_scrap'
    print "Scrapping wiki pages..."
    t1 = Time.now
    wiki_page_scrap_and_save_to_mongo
    puts "ok!\t(#{Time.now-t1} s)"
  end

  desc "Takes scraped content from mongo and extracts features, saves again in mongodb"
  task :extract_features => [:page_scrap]do
    require './jobs/wiki_extract_features'
    print "Extracting features..."
    t1 = Time.now
    wiki_extract_features_and_save_to_mongo
    puts "ok!\t(#{Time.now-t1} s)"
  end

  desc "Takes extracted features and selects best set of features for data mining. Should reduce page-term matrix scarcity to ~10%."
  task :select_features => [:extract_features]do
    require './jobs/wiki_select_features'
    print "Selecting features..."
    t1 = Time.now
    wiki_select_features_and_save_to_mongo
    puts "ok!\t(#{Time.now-t1} s)"
  end

  desc "Correlates pages using selected feature set"
  task :correlate_pages => [:select_features] do
    require './jobs/wiki_correlate_pages'
    print "Correlating wiki pages..."
    t1 = Time.now
    correlate_pages_and_save_to_mongo
    puts "ok!\t(#{Time.now-t1} s)"
  end

  desc "Runs all tasks for wiki pages correlation"
  task :all => [:correlate_pages]do
    puts "Done processing MediaWiki data!"
  end
end

namespace :expert_tags do
  desc "Parses scrapped pages for expert knowledge correlation tags. Requires wiki:page_scrap to be performed earlier."
  task :all do
    require './jobs/expert_tags_process.rb'
    print "Processing expert wiki tags..."
    t1 = Time.now
    process_expert_tags_and_save_to_mongo
    puts "ok!\t(#{Time.now-t1} s)"
    puts "Done processing expert knowledge data!"
  end
end

namespace :frequent_patterns do
  desc "Performs user queries frequent pattern analysis"
  task :all do
    require './jobs/frequent_patterns.rb'
    print "Processing user history..."
    t1 = Time.now
    process_frequent_patterns
    puts "ok!\t(#{Time.now-t1} s)"
    puts "Done processing frequent usage patterns analysis!"
  end
end

namespace :cache do
  desc "Merges correlation data to cache"
  task :correlations do
    require './jobs/cache_correlations.rb'
    print "Preparing correlations cache..."
    t1 = Time.now
    cache_correlations
    puts "ok!\t(#{Time.now-t1} s)"
  end

  desc "Collects terms from pages into cache for text search"
  task :terms do
    require './jobs/cache_terms.rb'
    print "Preparing term cache..."
    t1 = Time.now
    cache_terms
    puts "ok!\t(#{Time.now-t1} s)"
  end

  desc "Collects history data into usage frequency data cache for recommendation"
  task :usage do
    require './jobs/cache_frequent_patterns.rb'
    print "Preparing frequent patterns cache..."
    t1 = Time.now
    cache_frequent_patterns
    puts "ok!\t(#{Time.now-t1} s)"
  end

  desc "Merges all data into caches, available for knowledge system api"
  task :all => ["correlations","terms","usage"]do
    puts "Done creating cache data!"
  end

end

task :all => ["wiki:all", "expert_tags:all", "cache:all"]do
  puts "Done all!"
end
