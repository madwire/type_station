updateGlobalValue = ($el, value) ->
  match = "[data-ts-key=#{$el.data('ts-key')}][data-ts-id=#{$el.data('ts-id')}]"
  $("input#{match}").val(value)
  $("#{match}").not(':input').html(value)

class window.TS.EditableText
  constructor: (@elements) ->
    @editor = new MediumEditor @elements,
      disableReturn: true
      buttons: ['bold', 'italic', 'underline', 'anchor']
    @editor.deactivate()

  enable: ->
    @editor.activate()
    @elements.on 'input', ->
      model = window.TS.getModel $(@).data('ts-url')
      if $(@).is(':input')
        model.set($(@).data('ts-key'), { field: $(@).data('ts-key'), value: $(@).val(), type: 'text' })
        updateGlobalValue($(@), $(@).val())
      else
        model.set($(@).data('ts-key'), { field: $(@).data('ts-key'), value: $(@).html(), type: 'text' })
        updateGlobalValue($(@), $(@).html())

  disable: ->
    @editor.deactivate()
    @elements.off 'input'


class window.TS.EditableHtml
  constructor: (@elements) ->
    @editor = new MediumEditor @elements,
      #buttons: ['bold', 'italic', 'underline', 'anchor', 'header1', 'header2', 'unorderedlist', 'orderedlist', 'justifyLeft', 'justifyFull', 'justifyCenter', 'justifyRight']
      buttons: ['bold', 'italic', 'underline', 'anchor', 'header1', 'header2', 'unorderedlist', 'orderedlist']
    @editor.deactivate()

  enable: ->
    @editor.activate()
    @elements.on 'input', ->
      model = window.TS.getModel $(@).data('ts-url')
      if $(@).is(':input')
        model.set($(@).data('ts-key'), { field: $(@).data('ts-key'), value: $(@).val(), type: 'html' })
        updateGlobalValue($(@), $(@).val())
      else
        model.set($(@).data('ts-key'), { field: $(@).data('ts-key'), value: $(@).html(), type: 'html' })
        updateGlobalValue($(@), $(@).html())

  disable: ->
    @editor.deactivate()
    @elements.off 'input'
