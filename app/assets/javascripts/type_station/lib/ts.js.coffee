setCookie = (cname, cvalue, exdays) ->
  d = new Date
  d.setTime d.getTime() + exdays * 24 * 60 * 60 * 1000
  expires = 'expires=' + d.toUTCString()
  document.cookie = cname + '=' + cvalue + '; ' + expires
  return

getCookie = (cname) ->
  name = cname + '='
  ca = document.cookie.split(';')
  i = 0
  while i < ca.length
    c = ca[i]
    while c.charAt(0) == ' '
      c = c.substring(1)
    if c.indexOf(name) == 0
      return c.substring(name.length, c.length)
    i++
  ''

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

    @enable() if getCookie("ts-enabled") == '1'

  enable: ->
    setCookie('ts-enabled', 1, 1)
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
    setCookie('ts-enabled', 0, 1)
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
