class UserMedia
  recording: () ->
    if (navigator.getUserMedia)
      if (navigator.mozGetUserMedia)
        false
      else
        true
    else
      false

  replay: () ->
    if (navigator.getUserMedia)
      true
    else
      false

$ ->
  u = new UserMedia()
  unless u.recording()
    $('.recording_only').hide()
    $('.no_recording').show()
  unless u.replay()
    $('.replay_only').hide()
    $('.no_replay').show()
