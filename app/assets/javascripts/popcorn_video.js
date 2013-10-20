document.addEventListener("DOMContentLoaded", function () {

  if ($("#the_video").length > 0) {
    // Create a popcorn instance by calling Popcorn("#id-of-my-video")
    var pop = Popcorn("#the_video");

    pop.loop(true);
     
    // play the video right away
    pop.play();
  }
 
}, false);
