window.TS.models = new window.TS.Store
window.TS.editors = new window.TS.Store

window.TS.onSave = -> null
window.TS.onSaved = -> null

window.TS.onEnable = -> null
window.TS.onEnabled = -> null

window.TS.onDisable = -> null
window.TS.onDisabled = -> null

window.TS.getModel = (url) ->
  model = @models.get url
  unless model
    model = new window.TS.Model url
    @models.set url, model
  model

window.TS.enable = ->
  @onEnable()
  @editors.each (id, editor) -> editor.enable()
  @onEnabled()

window.TS.disable = ->
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