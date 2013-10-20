#= require_relative ./Recorder
#= require_relative ./RecordVideoView

window.URL = window.URL or window.webkitURL
window.requestAnimationFrame = window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.msRequestAnimationFrame or window.oRequestAnimationFrame
window.cancelAnimationFrame = window.cancelAnimationFrame or window.webkitCancelAnimationFrame or window.mozCancelAnimationFrame or window.msCancelAnimationFrame or window.oCancelAnimationFrame
navigator.getUserMedia = navigator.getUserMedia or navigator.webkitGetUserMedia or navigator.mozGetUserMedia or navigator.msGetUserMedia

ORIGINAL_DOC_TITLE = document.title

window.recorder = new Recorder()
view = new RecordVideoView(window.recorder)

@VideoHelper = class VideoHelper
  # set height and width to native values
  resizeHeight: (video) ->
    ratio = video.videoWidth / video.videoHeight
    $(video).css("height", ($(video).width() / ratio) + "px")

  resizeWhenLoaded: (video) ->
     if video.videoWith > 0
       @resizeHeight(video)
     else
       $(video).css("height", ($(video).width() / (4/3)) + "px")
       $(video).on 'loadedmetadata', (event) =>
         @resizeHeight(video)

$(document).on "ready page:load", ->
  if ($(document.body).hasClass("videos_new"))
    view.bind()
    view.turnOnCamera()

  $("video").each (i, item) ->
    new VideoHelper().resizeWhenLoaded(item)
