buildUploader = (element, data)->
  $element = $(element)
  elementId = $element.attr('id')
  $title = $('<h4/>')
  $save = $('<button/>').attr({'data-element-id': elementId})
  $container = $('<div/>')
  $fields = []

  $title
    .addClass('ts-edit-link-title')
    .text('Edit Link')
  $container
    .append($title)
    .addClass('ts-edit-link-container')

  $input = $('<input/>')
  $input
    .attr({type: "text", name: 'link', class: 'ts-edit-link-input ts-link-finder', 'data-element-id': elementId})
    .val($element.attr('href'))
    .textcomplete [
      {
        match: /^\/(\w*)$/
        index: 1
        search: (term, callback) ->
          $.ajax
            method: 'GET'
            url: window.TS.ADMIN_PAGES_URL
            dataType: 'json'
            contentType: 'application/json'
            data: {path: term}
            success: (data, status) -> 
              callback(data.pages)
        replace: (page) -> page.path
        template: (page) -> "#{page.title} (#{page.path})"
      }
    ], 
      zIndex: 10000

    $container
      .append $input

  $save
    .addClass 'ts-save-url'
    .text 'Ok'
    .on 'click', () ->
      $element = $("##{$(this).data('elementId')}")
      $element.data('drop').close()
      model = window.TS.getModel $element.data('ts-url')
      model.set($element.data('ts-key'), { field: $element.data('ts-key'), value: $input.val(), type: 'text' })
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
      target: $('.ts-editable-link-button', element)[0]
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
      $(element).append($('<div>').addClass('ts-editable-button').addClass('ts-button').addClass('ts-editable-link-button').html("<i class='ion-link'></i>"))

  enable: ->
    @disable()
    @drops = setUpDrops(@elements)

  disable: ->
    for drop in @drops
      drop.close()
      drop.remove()
      drop.destroy()
    @drops = []