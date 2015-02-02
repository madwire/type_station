class window.TS.EditableText
  constructor: (@elements) ->
    @editor = new MediumEditor @elements,
      disableReturn: true
      buttons: ['bold', 'italic', 'underline', 'anchor']
      buttonLabels: 'fontawesome'
    @editor.deactivate()

  enable: ->
    @editor.activate()
    @elements.on 'input', ->
      model = window.TS.getModel $(@).data('ts-edit-url')
      if $(@).is(':input')
        model.set($(@).data('ts-field'), { field: $(@).data('ts-field'), value: $(@).val(), type: 'text' })
      else
        model.set($(@).data('ts-field'), { field: $(@).data('ts-field'), value: $(@).html(), type: 'text' })

  disable: ->
    @editor.deactivate()
    @elements.off 'input'


class window.TS.EditableHtml
  constructor: (@elements) ->
    @editor = new MediumEditor @elements,
      buttons: ['bold', 'italic', 'underline', 'anchor', 'header1', 'header2', 'unorderedlist', 'orderedlist', 'justifyLeft', 'justifyFull', 'justifyCenter', 'justifyRight']
      buttonLabels: 'fontawesome'
    @editor.deactivate()

  enable: ->
    @editor.activate()
    @elements.on 'input', ->
      model = window.TS.getModel $(@).data('ts-edit-url')
      if $(@).is(':input')
        model.set($(@).data('ts-field'), { field: $(@).data('ts-field'), value: $(@).val(), type: 'html' })
      else
        model.set($(@).data('ts-field'), { field: $(@).data('ts-field'), value: $(@).html(), type: 'html' })
  disable: ->
    @editor.deactivate()
    @elements.off 'input'
