$(".recommender-similar").click(function(){
	makeQuery({docIds:[wgArticleId]}, function(data){
		fillRecommendations("Recommendation for: " + wgPageName,data);
		$(".recommender-content").show();
	});

});

var fillRecommendations = function(data){
	var sortedData = sortResults(data.results)
	showResults(sortedData);
}

var sortResults = function(data){
    data.sort(function(a, b){
        return a.correlation < b.correlation ? 1 : (a.correlation > b.correlation ? -1 : 0);
    });
    return data;
}

var showResults = function(data){
	var rc = $(".recommender-content");
	var ul = $("<ul>");
	rc.html("");
	data.result.forEach(function(r){
		var li = $("<li>")
		var a = $("<a>")
			.text("" + r.correlation + " : " + r.title)
			.attr("href",wgScript+"/"+r.title);
		li.append(a);
		ul.append(li);
	});
	rc.append(ul);
}

$(".mw-body").mouseup(function(){
	var text = getSelection.toString();
	makeQuery({queryString:text}, function(data){
		$(".recommender-content").show();
		fillRecommendations("Recommendation for: " + text,data);
	});

});


$(".recommender-toggle").click(function(){
	$(".recommender-content").toggle();
});
