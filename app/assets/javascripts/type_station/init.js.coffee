window.TS.models = new window.TS.Store
window.TS.editors = new window.TS.Store

window.TS.getModel = (url) ->
  model = @models.get url
  unless model
    model = new window.TS.Model url
    @models.set url, model
  model

window.TS.enable = ->
  @editors.each (id, editor) -> editor.enable()

window.TS.disable = ->
  @editors.each (id, editor) -> editor.disable()

window.TS.save = ->
  @models.each (id, model) -> model.save()

window.TS.init = ->
  @editors.set 'ts-admin-bar', new window.TS.AdminBar $('#ts-admin-bar-template')
  @editors.set 'ts-editable-text', new window.TS.EditableText $('span.ts-editable-text')
  @editors.set 'ts-editable-html', new window.TS.EditableHtml $('.ts-editable-html')
  @editors.set 'ts-editable-image', new window.TS.EditableImage $('.ts-editable-image')
  @editors.set 'ts-editable-file', new window.TS.EditableFile $('.ts-editable-file')