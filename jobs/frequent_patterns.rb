# encoding: utf-8
require 'rubygems'
require './configuration.rb'

def process_frequent_patterns
  FrequentPatternsAnalysis.new.run
end

class FrequentPatternsAnalysis
  def process_doc_ids(doc_ids, seconds_ago)
    correlation_value = 1/(Math.log(seconds_ago/60+1))
    for i in 0..(doc_ids.length-2)
      for j in i...doc_ids.length
        correlate(doc_ids[i], doc_ids[j], correlation_value)
      end
    end
  end

  def correlate(id1, id2, correlation_value)
    return if id1==id2
    @hash_of_ids[id1] ||= {}
    @hash_of_ids[id2] ||= {}
    @hash_of_ids[id1][id2]||=0
    @hash_of_ids[id2][id1]||=0
    @hash_of_ids[id1][id2]+=correlation_value
    @hash_of_ids[id2][id1]+=correlation_value
  end

  def run
    db = get_mongo
    @hist_col = db[$mongo_query_history]
    @corr_col = db[$mongo_query_correlation]
    @hash_of_ids = {}

    @corr_col.remove

    time_now = Time.now

    @hist_col.find.each do |query|
      doc_ids = query["q"]["doc_ids"]

      generation_time = query["_id"].generation_time

      process_doc_ids(doc_ids, time_now - generation_time) if doc_ids
    end

    @hash_of_ids.each do |hash_key, hash_value|
      string_hash = {}
      hash_value.each do |k,v|
        string_hash[k.to_s] = v
      end
      @corr_col.insert({p: hash_key.to_s, pages: string_hash})
    end
    puts @corr_col.find.to_a
  end
end
