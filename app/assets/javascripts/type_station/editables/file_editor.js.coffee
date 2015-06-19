buildUploader = (editor) ->
  $input = $('<input/>')
  $label = $('<label/>')

  $labelIcon = $('<i/>').addClass "ts-file-style-icon #{if editor.data.type == 'image' then 'ion-image' else 'ion-android-attach'}"
  # $labelText = $('<span/>').addClass('ts-file-style-text').text('Upload image')

  $label
    .addClass 'ts-file-editor'
    .addClass('ts-editable-button')
    .addClass('ts-button')

  $input
    .attr({type: "file", name: "file", class: 'ts-editable-file-input', style: 'display: none', 'data-form-data': JSON.stringify(editor.data.options.cloudinary), 'data-element-id': editor.$el.attr('id')})
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
      for linkTag in $('.ts-editable-link-tag', $element)
        $(linkTag).attr('href', $.cloudinary.url(data.result.public_id, {resource_type: 'raw'}))
      $(this).prop('disabled', false)
      $('.ts-progress-bar').remove()

      model = editor.ts.getModel editor.data.url
      model.set(editor.data.field, { field: editor.data.field, value: {identifier: data.result.public_id}, type: editor.data.type })

  $label
    # .append $labelText
    .append $labelIcon
    .append $input


class @TypeStation.FileEditor
  constructor: (@ts, @$el, @data) ->
    @$el.addClass('ts-block')
  enable: ->
    @$el.append(buildUploader(@))

  disable: ->
    @$el.find('.ts-file-editor').remove()
