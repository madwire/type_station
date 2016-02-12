moveEntityCall = (url, direction) ->
  $.ajax
    type: "PATCH"
    url: url
    dataType: 'json'
    contentType: 'application/json'
    data: JSON.stringify({direction: direction})
    success: (data, status) -> window.location.reload()

deleteEntityCall = (url) ->
  $.ajax
    type: "DELETE"
    url: url
    dataType: 'json'
    contentType: 'application/json'
    data: {}
    success: (data, status) -> window.location.reload()

createEntityCall = (url, data) ->
  $.ajax
    type: "POST"
    url: url
    dataType: 'json'
    contentType: 'application/json'
    data: JSON.stringify(data)
    success: (data, status) ->
      window.location.reload()


buildFields = (editor) ->
  fields = editor.data.fields
  inputs = ''

  defaultValues = {}
  for field in fields
    if field.default
      defaultValues[field.name] = field.default

  modelValues = if editor.data.action == 'edit' then editor.data.values else defaultValues

  for field in fields
    if field.label
      label = "<label for='#{field.name}'>#{if field.required then '*' else ''}#{field.label}</label>"
      input = switch field.type
        when "text" then "<input type='text' name='#{field.name}' id='#{field.name}' value='#{if modelValues[field.name] then modelValues[field.name] else ''}' #{if field.required then 'required' else ''} />"
        when "textarea" then "<textarea name='#{field.name}' id='#{field.name}' rows='5' #{if field.required then 'required' else ''}>#{if modelValues[field.name] then modelValues[field.name] else ''}</textarea>"
        when "html" then "<textarea name='#{field.name}' id='#{field.name}' rows='5' #{if field.required then 'required' else ''}>#{if modelValues[field.name] then modelValues[field.name] else ''}</textarea>"
        when "select"
          select = "<select name='#{field.name}' id='#{field.name}' #{if field.required then 'required' else ''}>"
          for o in field.options
            select += "<option value='#{o[1]}' #{if modelValues[field.name] == o[1] then 'selected'}>#{o[0]}</option>"
          select += "</select>"
          select
        when "multiple_select"
          select = "<select name='#{field.name}' id='#{field.name}' class='multiple_select' multiple #{if field.required then 'required' else ''}>"
          for o in field.options
            select += "<option value='#{o[1]}' #{if modelValues[field.name] && modelValues[field.name].indexOf(o[1]) > -1 then 'selected' else ''}>#{o[0]}</option>"
          select += "</select>"
          select
      inputs += "<div class'vex-custom-field-wrapper'>#{label}<div class='vex-custom-input-wrapper'>#{input}</div></div>"
    else
      inputs += "<input type='hidden' name='#{field.name}' id='#{field.name}' value='#{if modelValues[field.name] then modelValues[field.name] else ''}' />"
  inputs

handleDeleteEntity = (editor) ->
  vex.dialog.confirm
    message: 'Are you sure you want to delete this?'
    callback: (value) ->
      if value
        deleteEntityCall(editor.data.url)


handleMoveEntity = (editor) ->
  moveEntityCall(editor.data.url, editor.data.options.direction)

handleCreateEditEntity = (editor) ->
  self = editor
  vex.dialog.buttons.YES.text = if self.data.action == 'edit' then 'Save' else 'Create'

  vex_message_type = if self.data.type == 'TypeStation::Page' then 'Page' else self.data.type
  vex_message = "#{if self.data.action == 'edit' then 'Edit' else 'Create'} #{vex_message_type || 'Page'}"

  vex.dialog.open
    message: vex_message
    input: buildFields(self)
    afterOpen: ($vexContent) ->
      $("select.multiple_select", $vexContent).chosen()
    callback: (data) ->
      if data
        if self.data.action == 'edit'
          model = self.ts.getModel self.data.url
          valid = true
          for k,v of data
            field = self.fields[k]
            if valid
              switch field.type
                when 'html'
                  valid = true
                else
                  check_value = v.replace(/[\{\}\.\,\:\;\/\&\?\!\(\)]/g, '')
                  if check_value.length > 0
                    if check_value.length > 1 # seems to be an issue when the text length is around 1 ? :confused:
                      try
                        valid = !$(check_value).is('*')
                      catch
                        valid = false
            else
              break

          if valid
            vex.dialog.confirm
              message: 'Are you sure you want to save changes?'
              callback: (value) ->
                if value
                  self.ts.save()
                  for k,v of data
                    model.set(k, { field: k, value: v, type: self.fields[k].type })
                  model.save ->
                    window.location.reload()
          else
            vex.dialog.buttons.YES.text = 'Ok'
            vex.dialog.alert
              message: 'Unable to save: Please make sure all required fields are completed'
              callback: ->
                self.$el.click()

        else
          json = {}
          contents = []
          valid = true
          for k,v of data
            field = self.fields[k]
            if valid
              switch field.type
                when 'html'
                  valid = true
                else
                  check_value = v.replace(/[\{\}\.\,\:\;\/\&\?\!\(\)]/g, '')
                  if check_value.length > 0
                    if check_value.length > 1 # seems to be an issue when the text length is around 1 ? :confused:
                      try
                        valid = !$(check_value).is('*')
                      catch
                        valid = false
            else
              break
            contents.push({ field: k, value: v, type: field.type })
          json['contents'] = contents
          json['parent_id'] = self.data.parent_id if self.data.parent_id
          json['_type'] = self.data.type if self.data.type

          if valid
            if self.ts.isChanged()
              vex.dialog.buttons.YES.text = 'Save'
              vex.dialog.confirm
                message: 'You have unsaved changes, Do you want to save them before creating this?'
                callback: (value) ->
                  if value
                    self.ts.save()
                    createEntityCall(self.data.create_url, json)
            else
              createEntityCall(self.data.create_url, json)
          else
            vex.dialog.buttons.YES.text = 'Ok'
            vex.dialog.alert
              message: 'Unable to save: Please make sure all required fields are completed'
              callback: ->
                self.$el.click()



class @TypeStation.EntityEditor
  constructor: (@ts, @$el, @data) ->
    vex.defaultOptions.className = 'vex-theme-os'
    @fields = {}
    for field in @data.fields
      @fields[field.name] = field

  enable: ->
    @disable()
    self = @
    @$el.on 'click', ->
      switch self.data.action
        when 'edit', 'create' then handleCreateEditEntity(self)
        when 'move' then handleMoveEntity(self)
        when 'delete' then handleDeleteEntity(self)

  disable: ->
    @$el.off 'click'
