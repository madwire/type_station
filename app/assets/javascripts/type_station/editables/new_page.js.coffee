buildFields = (element) ->
  tsFields = element.data('tsFields')
  inputs = ''
  
  for field in tsFields
    label = "<label for='#{field.name}'>#{field.label}</label>"
    input = switch field.type
      when "text" then "<input type='text' name='#{field.name}' id='#{field.name}' />"
      when "textarea" then "<textarea name='#{field.name}' id='#{field.name}' rows='5
      '></textarea>"
      when "select"
        select = "<select name='#{field.name}' id='#{field.name}'>"
        for o in field.options
          select += "<option value='#{o[1]}'>#{o[0]}</option>"
        select += "</select>"
        select 
    inputs += "<div class'vex-custom-field-wrapper'>#{label}<div class='vex-custom-input-wrapper'>#{input}</div></div>"

  inputs

class window.TS.NewPage
  constructor: (@elements) ->

  enable: ->
    @disable()
    @elements.show().on 'click', ->
      $element = $(@)
      tsData = $element.data('tsData')
      vex.dialog.buttons.YES.text = 'Create'
      vex.dialog.open 
        message: "New #{tsData.name || 'Page'}"
        input: buildFields($element)
        $element: $element
        callback: (data) ->
          console.log data
          if data
            $el = @$element
            if data.title.length > 0 #must have a title
              model = window.TS.getModel $el.data('ts-url')
              data = $.extend({}, data, $el.data('tsData').default) if $el.data('tsData').default
              
              contents = []
              for k,v of data
                if k != 'title'
                  contents.push({ field: k, value: v, type: 'text' })

              json = {}
              json['title'] = data.title
              json['parent_id'] = $el.data('ts-parent-id') if $el.data('ts-parent-id') 
              json['contents'] = contents

              vex.dialog.confirm
                message: 'Are you sure you want to create this?'
                callback: (value) ->
                  if value
                    $.ajax
                      type: "POST"
                      url: $el.data('ts-url')
                      dataType: 'json'
                      contentType: 'application/json'
                      data: JSON.stringify(json)
                      success: (data, status) -> window.location.reload()
            else
              vex.dialog.alert
                message: 'Please fill in all required fields'
                callback: ->
                  $el.click()


  disable: ->
    @elements.hide().off 'click'