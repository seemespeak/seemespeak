BASE_PATH_ATTR = "base-src"

@Counter = class Counter
  constructor: ($container) ->
    @$container = $($container)

  downFrom: (seconds, success) =>
    @onStart()
    @cycle(seconds, success, (second) -> second - 1)

  cycle: (steps, success, getNextStep) =>
    if steps > 0
      @onStep(steps)
      setTimeout =>
        @cycle(getNextStep(steps), success, getNextStep)
      , 1000
    else
      @onEnd()
      success()

  onStep: (step) =>
    image_url = @$container.data(BASE_PATH_ATTR).replace('X', step)
    @$container.css 'background-image', "url('#{image_url}')"

  onStart: ->
    @$container.show()

  onEnd: ->
    @$container.css('background-image', '').hide()
