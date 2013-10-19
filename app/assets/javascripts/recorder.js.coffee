WORKER_PATH = "js/recorderWorker.js"
Recorder = (source, cfg) ->
  config = cfg or {}
  bufferLen = config.bufferLen or 4096
  @context = source.context
  @node = @context.createScriptProcessor(bufferLen, 2, 2)
  worker = new Worker(config.workerPath or WORKER_PATH)
  worker.postMessage
    command: "init"
    config:
      sampleRate: @context.sampleRate

  recording = false
  currCallback = undefined
  @node.onaudioprocess = (e) ->
    return  unless recording
    worker.postMessage
      command: "record"
      buffer: [e.inputBuffer.getChannelData(0)]


  @configure = (cfg) ->
    for prop of cfg
      config[prop] = cfg[prop]  if cfg.hasOwnProperty(prop)

  @record = ->
    recording = true

  @stop = ->
    recording = false

  @clear = ->
    worker.postMessage command: "clear"

  @getBuffer = (cb) ->
    currCallback = cb or config.callback
    worker.postMessage command: "getBuffer"

  @exportWAV = (cb, type) ->
    currCallback = cb or config.callback
    type = type or config.type or "audio/wav"
    throw new Error("Callback not set")  unless currCallback
    worker.postMessage
      command: "exportWAV"
      type: type


  worker.onmessage = (e) ->
    blob = e.data
    currCallback blob

  source.connect @node
  @node.connect @context.destination #this should not be necessary

Recorder.forceDownload = (blob, filename) ->
  url = (window.URL or window.webkitURL).createObjectURL(blob)
  link = window.document.createElement("a")
  link.href = url
  link.download = filename or "output.wav"
  click = document.createEvent("Event")
  click.initEvent "click", true, true
  link.dispatchEvent click

window.Recorder = Recorder
