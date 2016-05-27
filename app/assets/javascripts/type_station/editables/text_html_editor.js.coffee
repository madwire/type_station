updateGlobalValue = ($el, value) ->
  match = "[data-ts-field=#{$el.data('ts-field')}][data-ts-id=#{$el.data('ts-id')}]"
  $("input#{match}").not($el).val(value)
  $("#{match}").not(':input').not($el).html(value)

isIE = -> !!(navigator.userAgent.indexOf('MSIE') != -1 || navigator.appVersion.indexOf('Trident/') > 0)


class @TypeStation.TextHtmlEditor
  constructor: (@ts, @$el, @data) ->

    if @data.type == 'text'
      @$el.addClass('ts-block-text')

      editorOptions =
        disableReturn: true
        toolbar: false
        imageDragging: false
    else
      @$el.addClass('ts-block')

      editorOptions =
        toolbar:
          buttons: ['bold', 'italic', 'underline', 'anchor', 'h1', 'h2', 'h3', 'unorderedlist', 'orderedlist', 'removeFormat']
        imageDragging: false

    @editor = new MediumEditor @$el, editorOptions
    @editor.destroy()
    @$el.attr('data-ts-id', @data.id).attr('data-ts-field', @data.field)

  enable: ->
    @editor.setup()
    self = @
    eventName = if isIE() then 'keyup' else 'input'
    @$el.on eventName, ->
      model = self.ts.getModel self.data.url
      if $(@).is(':input')
        model.set(self.data.field, { field: self.data.field, value: $(@).val(), type: self.data.type })
        updateGlobalValue($(@), $(@).val())
      else
        model.set(self.data.field, { field: self.data.field, value: $(@).html(), type: self.data.type })
        updateGlobalValue($(@), $(@).html())

  disable: ->
    @editor.destroy()
    @$el.off 'input'
