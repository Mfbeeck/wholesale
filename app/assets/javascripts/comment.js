// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function ready() {
  console.log('document ready');

  $('#new_comment').on("ajax:success", function(evt, data) {
    console.log("ajax");
    // window.location.reload();
    $('#comment_body').val('');
    console.log(data);
    $('.comments_list').append(data);
  }).on('ajax:error', function() {
    alert('Oops!');
  });

}

$(document).ready(function(){

	$('.delete_comment_link').click(function(){
		var parent = $(this).parent();
		parent.remove();
    // THIS ISNT WORKING WITHOUT A REFRESH WHEN YOU CREATE AN ITEM, I BELIEVE BECAUSE OF THE DELETE ERROR
	})

});

$(document).on('ready page:load', ready);
