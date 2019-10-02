require 'mongo'
require 'bson'

def connect_to_mongo(mongo_host, mongo_port, mongo_db_name)
  @mongo_client = Mongo::MongoClient.new(mongo_host, mongo_port) if !@mongo_db
  @mongo_db = @mongo_client[mongo_db_name] if !@mongo_db
  return @mongo_db
end

def get_mongo
  connect_to_mongo($mongo_host, $mongo_port, $mongo_db_name)
end
