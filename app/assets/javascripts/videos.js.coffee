toggleActivateRecordButton = ->
  b = $("#record-me")
  b.textContent = (if b.attr("disabled") then "Record" else "Recording...")
  b.toggleClass "recording"
  b.attr "disabled", !b.attr("disabled")

turnOnCamera = (e) ->
  e.target.disabled = true
  $("#record-me").disabled = false
  video = $("video#live")
  video.attr "controls", false

  navigator.getUserMedia
    video: true
    audio: false
  , (stream) ->
    video.attr "src", window.URL.createObjectURL(stream)

record = ->
  elapsedTime = $("#elasped-time")
  startTime = Date.now()
  toggleActivateRecordButton()
  $("#stop-me").attr "disabled", false

stop = ->
  endTime = Date.now()
  $("#stop-me").attr "disabled", true
  document.title = ORIGINAL_DOC_TITLE
  toggleActivateRecordButton()
  embedVideoPreview()

embedVideoPreview = ->
  video = $("video#play")

initEvents = ->
  $("#camera-me").on "click", turnOnCamera
  $("#record-me").on "click", record
  $("#stop-me").on "click", stop

window.URL = window.URL or window.webkitURL
window.requestAnimationFrame = window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.msRequestAnimationFrame or window.oRequestAnimationFrame
window.cancelAnimationFrame = window.cancelAnimationFrame or window.webkitCancelAnimationFrame or window.mozCancelAnimationFrame or window.msCancelAnimationFrame or window.oCancelAnimationFrame
navigator.getUserMedia = navigator.getUserMedia or navigator.webkitGetUserMedia or navigator.mozGetUserMedia or navigator.msGetUserMedia

ORIGINAL_DOC_TITLE = document.title

$ ->
  initEvents()
