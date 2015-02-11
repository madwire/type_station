class window.TS.MovePage
  constructor: (@elements) ->
    self = @
    self.parent_distance = parseInt(@elements.first().data('ts-moveable-distance')) or 1

    $left_arrow = $('<i/>').addClass('fa fa-left-arrow fa-fw ts-move').data({'ts-direction': 'up'})
    $right_arrow = $('<i/>').addClass('fa fa-right-arrow fa-fw ts-move').data({'ts-direction': 'down'})

    self.elements.each () ->
      $(@).append($left_arrow.clone(true)).append($right_arrow.clone(true))


  enable: ->
    self = @
    self.elements.find('ts-move-down').on 'click', () ->
      $button = $(@)
      id = $button.parent().date('ts-id')
      direction = $button.data('ts-direction')
      parent = $button.parents().eq(self.parent_distance)
      self.update id, direction, parent

    
  disable: ->

  update: (id, direction, parent) ->
    $.ajax
      method: 'GET'
      url: window.TS.ADMIN_MOVE_PAGES_URL
      dataType: 'json'
      contentType: 'application/json'
      data: {id: id, direction: direction}
      success: (data, status) -> 
        console.log data, status
        # MOVE ELEMENT