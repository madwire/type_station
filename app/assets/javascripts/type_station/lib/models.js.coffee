class @TypeStation.Store
  constructor: (@id = null) ->
    @STORE = {}
  get: (key) -> @STORE[key]
  set: (key, value) -> @STORE[key] = value

  each: (callback) ->
    for key, value of @STORE
      callback?(key, value)

class @TypeStation.Model extends @TypeStation.Store

  constructor: (@id = null) ->
    super
    @DIRTY = {}

  set: (key, value) ->
    super key, value
    @DIRTY[key] = 1

  changedKeys: -> Object.keys(@DIRTY)
  isChanged: -> @changedKeys().length > 0

  _reset: ->
    @STORE = {}
    @DIRTY = {}

  save: (callback = ->) ->
    self = @
    data = []

    for key, value of @STORE
      data.push(value)

    $.ajax
      type: "PATCH"
      url: self.id
      dataType: 'json'
      contentType: 'application/json'
      data: JSON.stringify({contents: data})
      success: (data) ->
        self._reset() #reset model to a clean state
        callback(data)
      error: (jqxhr, status, err) ->
        vex.dialog.alert
          message: "#{window.titleize status}: #{jqxhr.responseJSON.message}"
          buttons: [
            $.extend({}, vex.dialog.buttons.YES, text: 'Close')
          ]
