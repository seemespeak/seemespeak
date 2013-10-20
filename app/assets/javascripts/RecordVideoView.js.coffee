@RecordVideoView = class RecordVideoView
  constructor: (recorder) ->
    @recorder = recorder

  turnOnCamera: () =>
    video = $("video#live")
    video.attr "controls", false

    navigator.getUserMedia
      video: true
      audio: false
    , (stream) =>
      @recorder.captureFrom stream
      @stream = stream
      video.attr "src", window.URL.createObjectURL(stream)
      @toStateRecordingReady()
    , (error) ->
      throw new Error("getUserMedia failed: "+error)

  toggleActivateRecordButton: ->
    b = $("#record-me")
    b.text if b.attr("disabled") then b.data("record-label") else b.data("recording-label")
    b.addClass "recording"
    b.attr "disabled", !b.attr("disabled")

  toStateRecordingReady: ->
    b = $("#record-me")
    b.attr "disabled", false
    b.removeClass "disabled"
    b.removeClass "recording"
    b.text b.data("label-record")

  toStateRecordingProgress: ->
    b = $("#record-me")
    b.attr "disabled", true
    b.removeClass "disabled"
    b.addClass "recording"
    b.text b.data("label-recording")
    $('#submits').fadeOut()

  toStateRecordingDone: ->
    b = $("#record-me")
    b.attr "disabled", false
    b.removeClass "disabled"
    b.removeClass "recording"
    b.text b.data("label-record-again")
    video = $("video#live")
    video.attr "src", window.URL.createObjectURL(window.recorder.getBlob())
    video.attr "loop", "loop"
    $('#submits').fadeIn()

  enterStateTransferring: ->
    $("#action-controls button").attr "disabled", true

  leaveStateTransferring: ->
    $("#action-controls button").attr "disabled", false

  bind: =>
    $("#record-me").on "click", @record
    $("form#new_entry #upload_video").click (e) =>
      e.preventDefault()
      @submitVideo()

  record: =>
    captureDuration = parseInt($("select[name='entry[video][length]']").val(), 0) * 1000
    $("video#live").attr "src", window.URL.createObjectURL(@stream)
    @recorder.captureSpan captureDuration, =>
      @toStateRecordingDone()
    @toStateRecordingProgress()

  submitVideo: =>
    # Wrap video blob in FormData and post via $.ajax
    # Challenge: Rails expects multipart/form+authenticity_token, we want to send Blob (requires XHR2)
    # This is best of both worlds afaik.

    newEntryForm = $("form#new_entry")
    form = new FormData(newEntryForm[0]) # Appends to form as if submitted via HTML
    form.append "entry[video]", window.recorder.getBlob()
    setTimeout @enterStateTransferring, 1
    $.ajax
      url: newEntryForm.attr "action"
      type: newEntryForm.attr "method"
      processData: false
      contentType: false
      data: form
      success: =>
        # TODO transfer to search
        #@leaveStateTransferring()
      error:
        @leaveStateTransferring()
        # TODO flash message / errors
