// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// <input class="klax-js-snapshot" type="radio" 
// name="before" data-index="<%= index %>" 
// data-type="before" value="<%= snapshot.id %>">


$(document).ready(function() {
	$(".klax-js-snapshot-before[data-index='0']").attr("disabled","");
	$(".klax-js-snapshot-before[data-index='1']").click();
	$(".klax-js-snapshot-after[data-index='0']").show().click();
	$(".klax-js-snapshot-before").click(function(){
		var index = $(this).data("index");
		$(".klax-js-snapshot-after").each(function(){
			var thisIndex = $(this).data("index");
			if (index <= thisIndex) {
				$(this).attr("disabled","");
				$(this).css("display","none");
			} else {
				$(this).css("display","block");
				$(this).removeAttr("disabled","");
				if (thisIndex == (index - 1)) {
					$(this).click();
				}
			}
		});
	});
});
