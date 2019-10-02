
makeQuery = function(query, success){
  var url = "/query/?categories="+query.categories;
  if(query.docIds)
    url+="&doc_ids="+query.docIds;
  if(query.queryString)
    url+="&query_string="+encodeURI(query.queryString);
  $.ajax({
    url: url,
    success: success
  });
};

