class window.TS.MovePage
  constructor: (@elements) ->
    @movement_buttons = @elements.find('')

  enable: ->
    @elements.find()

    
  disable: ->

  update: (id, direction) ->
    $.ajax
      method: 'GET'
      url: window.TS.ADMIN_MOVE_PAGES_URL
      dataType: 'json'
      contentType: 'application/json'
      data: {id: id, direction: direction}
      success: (data, status) -> 
        console.log data, status