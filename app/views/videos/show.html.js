$('#current_video').html("<%= escape_javascript( render :partial => 'modal_entry', :locals => {:entry => @entry} ) %>");
$('#video_popup').modal();


if ($('.voting-link').length > 0) {
  $('.voting-link').bind("ajax:success", function(evt, data, status, xhr) {
    $(this).html("")
    return $('#current-ranking').html(data.ranking).addClass("highlight");
  }).bind("ajax:error", function(evt, data, status, xhr) {
    return console.log("something went wrong");
  });
}

$("video").each(function(i, item) {
  new VideoHelper().resizeWhenLoaded(item);
});
var pop = Popcorn("#the_video");
pop.loop(true);
pop.play();


