buildUploader = (element, data)->
  elementId = $(element).attr('id')
  $input = $('<input/>')
  $input
    .attr({type: "file", name: "file", class: 'ts-editable-file-input', 'data-form-data': JSON.stringify(data), 'data-element-id': elementId})
    .cloudinary_fileupload()
    .bind 'cloudinaryprogress', (e, data) ->
      $('.ts-progress-bar').css('width', Math.round((data.loaded * 100.0) / data.total) + '%')
    .bind 'cloudinarystart', (e, data) ->
      $(this).prop('disabled', true)
      $('body').append($('<div>').addClass('ts-progress-bar'))
    .bind 'cloudinarydone', (e, data) ->
      $element = $("##{$(this).data('elementId')}")
      for imageTag in $('.ts-editable-link-tag', $element)
        $(imageTag).attr('href', $.cloudinary.url(data.result.public_id, {}))
      $element.data('drop').close()
      $(this).prop('disabled', false)
      $('.ts-progress-bar').remove()
  $input

setUpDrops = (elements)->
  drops = []

  for element in elements
    tsData = $(element).data('tsData')
    drop = new Drop
      target: element
      content: buildUploader(element, tsData)[0]
      position: 'bottom center'
      openOn: 'click'
      classes: 'drop-theme-arrows-bounce-dark'
    $(element).data('drop', drop)
    drops.push drop

  drops

class window.TS.EditableFile
  constructor: (@elements) ->
    @drops = []

  enable: ->
    @disable()
    @drops = setUpDrops(@elements)

  disable: ->
    for drop in @drops
      drop.close()
      drop.remove()
      drop.destroy()
    @drops = []