window.TS.models = new window.TS.Store
window.TS.editors = new window.TS.Store

window.TS.onSave = -> null unless window.TS['onSave']
window.TS.onSaved = -> null unless window.TS['onSaved']

window.TS.onEnable = -> null unless window.TS['onEnable']
window.TS.onEnabled = -> null unless window.TS['onEnabled']

window.TS.onDisable = -> null unless window.TS['onDisable']
window.TS.onDisabled = -> null unless window.TS['onDisabled']

window.TS.getModel = (url) ->
  model = @models.get url
  unless model
    model = new window.TS.Model url
    @models.set url, model
  model

window.TS.enable = ->
  window.location.hash = '#!ts-edit-enable'
  @onEnable()
  @editors.each (id, editor) -> editor.enable()
  @onEnabled()

window.TS.disable = ->
  window.location.hash = '#!ts-edit-disable'
  @onDisable()
  @editors.each (id, editor) -> editor.disable()
  @onDisabled()

window.TS.save = ->
  @onSave()
  @models.each (id, model) -> model.save()
  @onSaved()

window.TS.init = ->
  @editors.set 'ts-admin-bar', new window.TS.AdminBar $('#ts-admin-bar-template')
  @editors.set 'ts-editable-text', new window.TS.EditableText $('span.ts-editable-text')
  @editors.set 'ts-editable-html', new window.TS.EditableHtml $('.ts-editable-html')
  @editors.set 'ts-editable-image', new window.TS.EditableImage $('.ts-editable-image')
  @editors.set 'ts-editable-file', new window.TS.EditableFile $('.ts-editable-file')
  @editors.set 'ts-new-page', new window.TS.NewPage $('.ts-new-page')
  @editors.set 'ts-link-finder', new window.TS.LinkFinder null

  if window.location.hash.replace(/^#!/, '') == 'ts-edit-enable'
    window.TS.enable()