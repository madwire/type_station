class window.TS.Store
  constructor: (@id = null) ->
    @STORE = {}
  get: (key) -> @STORE[key]
  set: (key, value) -> @STORE[key] = value

  each: (callback) -> 
    for key, value of @STORE
      callback?(key, value)

class window.TS.Model extends window.TS.Store
  save: ->
    console.log 'Save!'