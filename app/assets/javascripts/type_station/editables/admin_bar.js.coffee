class window.TS.AdminBar
  constructor: (@element) ->
    template = @element.html()
    $('body').append(template)
    vex.defaultOptions.className = 'vex-theme-os'

    $('#ts-admin-bar-edit').on 'click', ->
      window.TS.enable()
      false

    $('#ts-admin-bar-cancel').on 'click', ->
      window.TS.disable()
      false
    
    $('#ts-admin-bar-save').on 'click', ->
      vex.dialog.confirm
        message: 'Are you sure you want to save changes?'
        callback: (value) ->
          if value
            window.TS.save()

    $('#ts-admin-bar input').on 'change', ->
      model = window.TS.getModel $(@).data('ts-url')
      model.set($(@).data('ts-key'), { field: $(@).data('ts-key'), value: $(@).val(), type: 'text' })

    # $('.ts-brand').on 'click', ->
    #   $("#ts-admin-bar").toggleClass 'insert-open'

    drop = new Drop
      target: $('#ts-admin-bar .ts-options i')[0]
      content: $('#ts-admin-bar-options')[0]
      position: 'bottom center'
      openOn: 'click'
      classes: 'drop-theme-arrows-bounce-dark'

  enable: ->
    $('body').addClass('ts-edit-mode');
    $('#ts-admin-bar').removeClass('ts-hidden')
    $('#ts-admin-bar-edit').addClass('ts-hidden')

  disable: ->
    $('body').removeClass('ts-edit-mode');
    $('#ts-admin-bar').addClass('ts-hidden').removeClass 'insert-open'
    $('#ts-admin-bar-edit').removeClass('ts-hidden')