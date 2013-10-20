$(function() {
  $("#search_form").submit(function (e) {
    if ($("#transcription").val().length == 0) {
      e.preventDefault();
    }
  });
});
