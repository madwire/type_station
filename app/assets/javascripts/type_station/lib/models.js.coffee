class window.TS.Store
  constructor: (@id = null) ->
    @STORE = {}
  get: (key) -> @STORE[key]
  set: (key, value) -> @STORE[key] = value

  each: (callback) -> 
    for key, value of @STORE
      callback?(key, value)

class window.TS.Model extends window.TS.Store
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
      success: (data) -> callback(data)