$('#current_video').html("<%= escape_javascript( render :partial => 'modal_entry', :locals => {:entry => @entry} ) %>");
$('#video_popup').modal();
$("video").each(function(i, item) {
  new VideoHelper().resizeWhenLoaded(item);
});
var pop = Popcorn("#the_video");
pop.loop(true);
pop.play();
