
class Docs
  attr_reader :list

  def initialize(categories)
    puts "categories = #{categories}"
    @categories = categories || []
    @list = []
  end

  def self.from(categories)
    Docs.new(categories)
  end

  def from_doc_ids(doc_ids)
    db = get_mongo
    col = db[$mongo_page_correlation_cache]
    @list += col.find({"a"=>{"$in"=> doc_ids}}).to_a
    self
  end

  def from_terms(terms)
    db = get_mongo
    col = db[$mongo_term_search_cache]
    @list += col.find({"t"=>{"$in"=> terms}}).to_a
    self
  end

  def from_frequent_patterns(query)
    db = get_mongo
    col2 = db[$mongo_page_term_collection_name]

    #TODO
    result = []

    col2.find.each do |doc|
      result.push({"p"=> doc["_id"], "nam"=> doc["title"], "cat"=> doc["categories"], "cor"=> 0.0})
    end
    @list += result
  end

  def form_result
    hash = {}
    @list.each do |doc|
      if !hash[doc["p"]]
        hash[doc["p"]] = {id: doc["p"], title: doc["nam"], categories: doc["cat"], correlation: doc["cor"]}
      else
        #retarded max
        hash[doc["p"]][:correlation] += doc["cor"]
      end
    end

    result = []
    hash.each do |k,v|
      v[:correlation] += @categories.length - ( @categories - v[:categories]).length
      result.push v
    end
    result
  end
end
