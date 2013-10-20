#= require_relative ./Recorder
#= require_relative ./RecordVideoView

window.URL = window.URL or window.webkitURL
window.requestAnimationFrame = window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.msRequestAnimationFrame or window.oRequestAnimationFrame
window.cancelAnimationFrame = window.cancelAnimationFrame or window.webkitCancelAnimationFrame or window.mozCancelAnimationFrame or window.msCancelAnimationFrame or window.oCancelAnimationFrame
navigator.getUserMedia = navigator.getUserMedia or navigator.webkitGetUserMedia or navigator.mozGetUserMedia or navigator.msGetUserMedia

ORIGINAL_DOC_TITLE = document.title

window.recorder = new Recorder()
view = new RecordVideoView(window.recorder)

$ ->
  if ($(document.body).hasClass("videos_new"))
    view.bind()
    view.turnOnCamera()
