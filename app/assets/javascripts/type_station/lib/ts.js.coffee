buildEditor = (ts, $el, data) ->
  if data.action
    switch data.action
      when 'create', 'edit', 'delete', 'move'
        new TypeStation.EntityEditor(ts, $el, data)
  else
    switch data.type
      when 'text', 'html' then new TypeStation.TextHtmlEditor(ts, $el, data)
      when 'image', 'file' then new TypeStation.FileEditor(ts, $el, data)

class @TypeStation
  constructor: (@elements, @callbacks = {}) ->
    @models = new TypeStation.Store
    @editors = new TypeStation.Store

    if $adminBar = $('#ts-admin-bar-template')
      @editors.set 'ts-admin-bar', new TypeStation.AdminBarEditor(@, $adminBar, {})

    self = @
    @elements.each ->
      $el = $(@)
      data = $el.data('ts')
      self.editors.set $el.attr('id'), buildEditor(self, $el, data)

  enable: ->
    $('body').addClass('ts-enable')

    @callbacks['onEnable']() if @callbacks['onEnable']
    @editors.each (id, editor) -> editor?.enable?()
    @callbacks['onEnabled']() if @callbacks['onEnabled']
    $(window).on 'beforeunload', =>
      if @isChanged()
        return 'You have unsaved changes. Are you sure you want to leave?'
      else
        return

  disable: ->
    $('body').removeClass('ts-enable')

    @callbacks['onDisable']() if @callbacks['onDisable']
    @editors.each (id, editor) -> editor?.disable?()
    @callbacks['onDisabled']() if @callbacks['onDisabled']
    $(window).off 'beforeunload'

  getModel: (url) ->
    model = @models.get url
    unless model
      model = new TypeStation.Model url
      @models.set url, model
    model

  isChanged: ->
    dirtyArray = []
    @models.each (id, model) -> dirtyArray.push model.isChanged()
    $.grep(dirtyArray, (a) ->  a == true ).length > 0

  save: ->
    @callbacks['onSave']() if @callbacks['onSave']
    @models.each (id, model) -> model.save()
    @callbacks['onSaved']() if @callbacks['onSaved']
