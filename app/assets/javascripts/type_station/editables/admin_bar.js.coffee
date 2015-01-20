class window.TS.AdminBar
  constructor: (@element) ->
    template = @element.html()
    $('body').append(template)

    $('#ts-admin-bar-edit').on 'click', ->
      $('#ts-admin-bar').removeClass('ts-hidden')
      $('#ts-admin-bar-edit').addClass('ts-hidden')
      window.TS.enable()

    $('#ts-admin-bar-cancel').on 'click', ->
      $('#ts-admin-bar').addClass('ts-hidden')
      $('#ts-admin-bar-edit').removeClass('ts-hidden')
      window.TS.disable()
    
    $('#ts-admin-bar-save').on 'click', ->
      window.TS.save()

    drop = new Drop
      target: $('#ts-admin-bar .ts-options i')[0]
      content: $('#ts-admin-bar-options')[0]
      position: 'bottom center'
      openOn: 'click'
      classes: 'drop-theme-arrows-bounce-dark'

  enable: ->

  disable: ->