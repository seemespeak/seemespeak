$('#current_video').html("<%= escape_javascript( render :partial => 'entry', :locals => {:entry => @entry} ) %>");
$('#video_popup').modal();