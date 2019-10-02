# encoding: utf-8
Dir["./lib/*.rb"].each {|file| require file}

# MYSQL_CONF
# STORE IT IN ENV VARIABLE!!!
$mysql_user = 'root'
$mysql_password = 'dupa123'
$mysql_db_name = 'my_wiki'

# MONGO_CONF
$mongo_host = 'localhost'
$mongo_port = 27017
$mongo_db_name = 'wiki_expert'

$mongo_wiki_scrap_collection_name = "wiki-scrap"

$mongo_term_page_collection_name = "wiki-term-page"
$mongo_page_term_collection_name = "wiki-page-term"
$mongo_selected_terms = "wiki-selected-terms"

$mongo_wiki_correlation = "correlation-wiki"
$mongo_expert_tags_correlation = "correlation-expert-tags"

#search
$mongo_page_correlation_cache = "cache-pages"
$mongo_term_search_cache = "cache-terms"

#usage history
$mongo_query_history = "query-history"
$mongo_query_correlation = "query-corr"
$mongo_query_cache = "query-cache"


#APP CATEGORIES
$app_categories = ["Apps", "Threats", "Fixes"]

#APP WIKI API URL
$wiki_api_uri = "http://localhost/~jglodek/wiki/api.php"
