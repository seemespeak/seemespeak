$('#current_video').html("<%= escape_javascript( render :partial => 'modal_entry', :locals => {:entry => @entry} ) %>");
$('#video_popup').modal();
var pop = Popcorn("#the_video");
pop.loop(true);
pop.play();
