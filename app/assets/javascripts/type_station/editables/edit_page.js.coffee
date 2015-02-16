move = (element, direction) ->
  $.ajax
    type: "PATCH"
    url: element.data('ts-url')
    dataType: 'json'
    contentType: 'application/json'
    data: JSON.stringify({direction: direction})
    success: (data, status) -> window.location.reload()

deletePage = (element) ->
  $.ajax
    type: "DELETE"
    url: element.data('ts-url')
    dataType: 'json'
    contentType: 'application/json'
    data: {}
    success: (data, status) -> window.location.reload()

buildFields = (element) ->
  tsFields = element.data('tsFields')
  inputs = ''
  model = window.TS.getModel element.data('ts-url')
  modelValues = element.data('ts-data')['ts_values']

  for field in tsFields
    label = "<label for='#{field.name}'>#{field.label}</label>"
    input = switch field.type
      when "text" then "<input type='text' name='#{field.name}' id='#{field.name}' value='#{modelValues[field.name]}' />"
      when "textarea" then "<textarea name='#{field.name}' id='#{field.name}' rows='5'>#{modelValues[field.name]}</textarea>"
      when "select"
        select = "<select name='#{field.name}' id='#{field.name}'>"
        for o in field.options
          select += "<option value='#{o[1]}' #{if modelValues[field.name] == o[1] then 'selected'}>#{o[0]}</option>"
        select += "</select>"
        select 
      when "multiple_select"
        select = "<select name='#{field.name}' id='#{field.name}' class='multiple_select' multiple>"
        for o in field.options
          select += "<option value='#{o[1]}' #{if modelValues[field.name] && modelValues[field.name].indexOf(o[1]) > -1 then 'selected' else ''}>#{o[0]}</option>"
        select += "</select>"
        select 
    inputs += "<div class'vex-custom-field-wrapper'>#{label}<div class='vex-custom-input-wrapper'>#{input}</div></div>"

  inputs

class window.TS.EditPage
  constructor: (@elements) ->
    for element in @elements
      $(element).append($('<span>').addClass('ts-editable-button').addClass('ts-edit-page-button').addClass('ts-button').html("<i class='ion-compose'></i>"))
      $(element).append($('<span>').addClass('ts-editable-button').addClass('ts-delete-page-button').addClass('ts-button').html("<i class='ion-trash-b'></i>"))
      if $(element).data('tsData')['moveable']
        switch $(element).data('tsData')['moveable']
          when 'left_to_right'
            $(element).append($('<span>').addClass('ts-editable-button').addClass('ts-move-up-button').addClass('ts-button').html("<i class='ion-arrow-left-b'></i>"))
            $(element).append($('<span>').addClass('ts-editable-button').addClass('ts-move-down-button').addClass('ts-button').html("<i class='ion-arrow-right-b'></i>"))
          else
            $(element).append($('<span>').addClass('ts-editable-button').addClass('ts-move-up-button').addClass('ts-button').html("<i class='ion-arrow-up-b'></i>"))
            $(element).append($('<span>').addClass('ts-editable-button').addClass('ts-move-down-button').addClass('ts-button').html("<i class='ion-arrow-down-b'></i>"))

  enable: ->
    @disable()
    $('.ts-edit-page-button', @elements).on 'click', ->
      $element = $(@).parent()
      tsData = $element.data('tsData')
      vex.dialog.buttons.YES.text = 'Save'
      vex.dialog.open 
        message: "Edit #{tsData.name || 'Page'}"
        input: buildFields($element)
        $element: $element
        afterOpen: ($vexContent) ->
          $("select.multiple_select", $vexContent).chosen()
        callback: (data) ->
          if data
            $el = @$element
            model = window.TS.getModel $el.data('ts-url')
          
            vex.dialog.confirm
              message: 'Are you sure you want to save changes?'
              callback: (value) ->
                if value
                  for k,v of data
                    model.set(k, { field: k, value: v, type: if $.isArray(v) then 'multiple_select' else 'text' })
                  model.save ->
                    window.location.reload()

    $('.ts-move-up-button', @elements).on 'click', ->
      move $(@).parent(), 'move_up'
    $('.ts-move-down-button', @elements).on 'click', ->
      move $(@).parent(), 'move_down'

    $('.ts-delete-page-button', @elements).on 'click', ->
      $element = $(@).parent()
      vex.dialog.confirm
        message: 'Are you sure you want to delete this?'
        callback: (value) ->
          if value
            deletePage($element)



  disable: ->
    $('.ts-edit-page-button', @elements).off 'click'
    $('.ts-move-up-button', @elements).off 'click'
    $('.ts-move-down-button', @elements).off 'click'

