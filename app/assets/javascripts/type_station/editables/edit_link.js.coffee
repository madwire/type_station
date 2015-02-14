buildUploader = (element, data)->
  $element = $(element)
  elementId = $element.attr('id')
  $title = $('<h4/>')
  $save = $('<button/>')
  $container = $('<div/>')
  $fields = []
  model = window.TS.getModel $element.data('ts-url')
  values = $element.data('ts-data')['ts_values']

  $title
    .addClass('ts-edit-link-title')
    .text('Edit Link')
  $container
    .append($title)
    .addClass('ts-edit-link-container')

  for key, value of values
    $input = $('<input/>')
    $label = $('<label/>')
    $label.text(window.titleize key)
    $input
      .attr({type: "text", name: key, class: 'ts-edit-link-input ts-link-finder', 'data-form-data': JSON.stringify(data), 'data-element-id': elementId})
      .val(value)

    $container
      .append $label
      .append $input
    $fields.push $input

  $save
    .addClass 'ts-save-url'
    .text 'Save'
    .on 'click', () ->
      for $field in $fields
        model.set($($field).attr('name'), { field: $($field).attr('name'), value: $($field).val(), type: 'text' })
      model.save ->
        window.location.reload()
  $container
    .append $save


updateGlobalValue = ($el, value) ->
  match = "[data-ts-key=#{$el.data('ts-key')}][data-ts-id=#{$el.data('ts-id')}]"
  $("input#{match}").not($el).val(value)
  $("#{match}").not(':input').not($el).html(value)

setUpDrops = (elements)->
  drops = []

  for element in elements
    tsData = $(element).data('tsData')
    drop = new Drop
      target: $('.ts-editable-button', element)[0]
      content: buildUploader(element, tsData)[0]
      position: 'top left'
      openOn: 'click'
      classes: 'drop-theme-arrows-bounce-dark'
    $(element).data('drop', drop)
    drops.push drop
  
  drops

class window.TS.EditLink
  constructor: (@elements) ->
    @drops = []
    for element in @elements
      $(element).append($('<div>').addClass('ts-editable-button').addClass('ts-button').html("<i class='ion-link'></i>"))

  enable: ->
    @disable()
    @drops = setUpDrops(@elements)

  disable: ->
    for drop in @drops
      drop.close()
      drop.remove()
      drop.destroy()
    @drops = []