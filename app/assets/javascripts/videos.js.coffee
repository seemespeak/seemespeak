#= require MediaStreamRecorder

VIDEO_OPTIONS =
  mimeType: 'video/webm'
  width: 640
  height: 480
  defaultDuration: 5000

class Recorder
  setBlob: (blob) =>
    @blob = blob

  assertSourceSet: ->
    throw new Error("Recorder's source isn't set. Call captureFrom first.") unless @mediaRecorder?

  captureFrom: (stream) ->
    @mediaRecorder = new MediaStreamRecorder(stream)
    @mediaRecorder.mimeType = VIDEO_OPTIONS.mimeType
    @mediaRecorder.videoWidth = VIDEO_OPTIONS.width
    @mediaRecorder.videoHeight = VIDEO_OPTIONS.height

    # mediaRecorder.frameRate = 300;
    # mediaRecorder.quality = 15;
    @mediaRecorder.ondataavailable = @setBlob

  start: ->
    @assertSourceSet()
    @mediaRecorder.start()

  stop: ->
    @assertSourceSet()
    @mediaRecorder.stop()

  captureSpan: (milliSeconds, cb) ->
    @assertSourceSet()
    @mediaRecorder.ondataavailable = (blob) =>
      @stop()
      @setBlob blob
      @mediaRecorder.ondataavailable = @setBlob
      cb()

    @mediaRecorder.start(milliSeconds)

class RecordVideoView
  constructor: (recorder) ->
    @recorder = recorder

  turnOnCamera: (e) =>
    e.target.disabled = true
    $("#record-me").disabled = false
    video = $("video#live")
    video.attr "controls", false

    navigator.getUserMedia
      video: true
      audio: false
    , (stream) =>
      @recorder.captureFrom stream
      video.attr "src", window.URL.createObjectURL(stream)

  toggleActivateRecordButton: ->
    b = $("#record-me")
    b.text if b.attr("disabled") then b.data("record-label") else b.data("recording-label")
    b.toggleClass "recording"
    b.attr "disabled", !b.attr("disabled")

  bind: =>
    $("#camera-me").on "click", @turnOnCamera
    $("#record-me").on "click", @record
    #$("#stop-me").on "click", @stop

  record: =>
    @toggleActivateRecordButton()
    @recorder.captureSpan VIDEO_OPTIONS.defaultDuration, =>
      @toggleActivateRecordButton()
      alert "Success!"
    #$("#stop-me").attr "disabled", false

  #stop: =>
    #$("#stop-me").attr "disabled", true
    #@recorder.stop()
    #document.title = ORIGINAL_DOC_TITLE
    #@toggleActivateRecordButton()

window.URL = window.URL or window.webkitURL
window.requestAnimationFrame = window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.msRequestAnimationFrame or window.oRequestAnimationFrame
window.cancelAnimationFrame = window.cancelAnimationFrame or window.webkitCancelAnimationFrame or window.mozCancelAnimationFrame or window.msCancelAnimationFrame or window.oCancelAnimationFrame
navigator.getUserMedia = navigator.getUserMedia or navigator.webkitGetUserMedia or navigator.mozGetUserMedia or navigator.msGetUserMedia

ORIGINAL_DOC_TITLE = document.title

view = new RecordVideoView(new Recorder())
$ ->
  view.bind()
