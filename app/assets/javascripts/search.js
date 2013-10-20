$(document).on("ready page:load", function() {
  $("#search_form").submit(function (e) {
    if ($("#transcription").val().length == 0) {
      e.preventDefault();
    }
  });

  $("#search_form .more-options").click(function() {
    $(this).hide();
    $(".expert-search").show();
  });

});
