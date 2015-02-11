class window.TS.MovePage
  constructor: (@elements) ->
    self = @
    self.parent_distance = parseInt(@elements.first().data('ts-moveable-distance')) or 1

    $left_arrow = $('<i/>').addClass('fa fa-arrow-left fa-fw ts-move ts-move-left').data({'ts-direction': 'up'}).hide()
    $right_arrow = $('<i/>').addClass('fa fa-arrow-right fa-fw ts-move ts-move-right').data({'ts-direction': 'down'}).hide()

    self.elements.each () ->
      $(@).append($left_arrow.clone(true)).append($right_arrow.clone(true))


  enable: ->
    self = @
    # Need to ignore invalid movements (First up and last down)
    # Mongoid Tree handles this fine, but better to avoid uneccessary requests.
    self.elements.find('.ts-move').show().on 'click', () ->
      $button = $(@)
      id = $button.parent().data('ts-id')
      direction = $button.data('ts-direction')
      parent = $button.parents().eq(self.parent_distance)
      self.update id, direction, parent
    
  disable: ->
    @elements.find('.ts-move').off 'click'

  update: (id, direction, parent) ->
    $.ajax
      method: 'GET'
      url: window.TS.ADMIN_MOVE_PAGES_URL
      dataType: 'json'
      contentType: 'application/json'
      data: {id: id, direction: direction}
      success: (data, status) -> 
        if data.success
          if direction is 'up'
            parent.insertBefore parent.prev()
          else
            parent.insertAfter parent.next()