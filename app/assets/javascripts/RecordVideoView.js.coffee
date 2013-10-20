class RecordVideoView
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
      video.attr "src", window.URL.createObjectURL(stream)
      @toggleActivateRecordButton()
    , (error) ->
      throw new Error("getUserMedia failed: "+error)

  toggleActivateRecordButton: ->
    b = $("#record-me")
    b.text if b.attr("disabled") then b.data("record-label") else b.data("recording-label")
    b.toggleClass "recording"
    b.attr "disabled", !b.attr("disabled")

  bind: =>
    $("#record-me").on "click", @record
    #$("#stop-me").on "click", @stop
    $("form#new_entry #upload_video").click (e) =>
      e.preventDefault()
      @submitVideo()

  record: =>
    captureDuration = parseInt($("select[name='entry[video][length]']").val(), 0) * 1000
    @recorder.captureSpan captureDuration, =>
      @toggleActivateRecordButton()
      alert "Success!"
    @toggleActivateRecordButton()

  submitVideo: ->
    # Wrap video blob in FormData and post via $.ajax
    # Challenge: Rails expects multipart/form+authenticity_token, we want to send Blob (requires XHR2)
    # This is best of both worlds afaik.

    newEntryForm = $("form#new_entry")
    form = new FormData(newEntryForm[0]) # Appends to form as if submitted via HTML
    form.append "entry[video]", window.recorder.getBlob()
    $.ajax
      url: newEntryForm.attr "action"
      type: newEntryForm.attr "method"
      processData: false
      contentType: false
      data: form
