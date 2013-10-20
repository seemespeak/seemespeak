#= require MediaStreamRecorder

VIDEO_OPTIONS =
  mimeType: 'video/webm'
  width: 640
  height: 480
  defaultDuration: 5000

@Recorder = class Recorder
  setBlob: (blob) =>
    @blob = blob
  getBlob: =>
    @blob

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

