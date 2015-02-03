buildUploader = (element, data)->
  elementId = $(element).attr('id')
  $input = $('<input/>')
  $input
    .attr({type: "file", name: "file", class: 'ts-editable-image-input', 'data-form-data': JSON.stringify(data), 'data-element-id': elementId})
    .cloudinary_fileupload()
    .bind 'cloudinaryprogress', (e, data) ->
      $('.ts-progress-bar').css('width', Math.round((data.loaded * 100.0) / data.total) + '%')
    .bind 'cloudinarystart', (e, data) ->
      $(this).prop('disabled', true)
      $('body').append($('<div>').addClass('ts-progress-bar'))
    .bind 'cloudinarydone', (e, data) ->
      $element = $("##{$(this).data('elementId')}")
      for imageTag in $('.ts-editable-image-tag', $element)
        $(imageTag).attr('src', $.cloudinary.url(data.result.public_id, $(imageTag).data()))
      $element.data('drop').close()
      $(this).prop('disabled', false)
      $('.ts-progress-bar').remove()

      model = window.TS.getModel $element.data('ts-url')
      model.set($element.data('ts-key'), { field: $element.data('ts-key'), value: {identifier: data.result.public_id}, type: 'image' })

  $input

setUpDrops = (elements)->
  drops = []

  for element in elements
    tsData = $(element).data('tsData')
    drop = new Drop
      target: $('.ts-editable-button', element)[0]
      content: buildUploader(element, tsData)[0]
      position: 'bottom center'
      openOn: 'click'
      classes: 'drop-theme-arrows-bounce-dark'
    $(element).data('drop', drop)
    drops.push drop

  drops

class window.TS.EditableImage
  constructor: (@elements) ->
    @drops = []
    for element in @elements
      $(element).append($('<div>').addClass('ts-editable-button').addClass('ts-button').html("<i class='ion-ios-compose-outline'></i>"))

  enable: ->
    @disable()
    @drops = setUpDrops(@elements)

  disable: ->
    for drop in @drops
      drop.close()
      drop.remove()
      drop.destroy()
    @drops = []