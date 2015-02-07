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
      false

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

    drop.on 'open', ->
      $('#ts-page-settings').off 'click'
      $('#ts-page-settings').on 'click', ->
        vex.dialog.buttons.YES.text = 'Save'
        vex.dialog.open 
          message: 'Manage page settings'
          input: """
            <style>
                .vex-custom-field-wrapper {
                  margin: 1em 0;
                }
                .vex-custom-field-wrapper > label {
                  display: inline-block;
                  margin-bottom: .2em;
                }
                .vex-custom-input-wrapper > select {
                  -webkit-border-radius: 3px;
                  -moz-border-radius: 3px;
                  -ms-border-radius: 3px;
                  -o-border-radius: 3px;
                  border-radius: 3px;
                  background: white;
                  width: 100%;
                  height: 40px;
                  padding: 0.25em 0.67em;
                  border: 0;
                  font-family: inherit;
                  font-weight: inherit;
                  font-size: inherit;
                  min-height: 2.5em;
                  margin: 0 0 0.25em;
                }
            </style>
            #{$('#ts-admin-bar-settings').html()}
          """
          callback: (data) ->
            if data
              model = window.TS.getModel $('#ts-admin-bar-settings').data('ts-url')
              vex.dialog.confirm
                message: 'Are you sure you want to save changes?'
                callback: (value) ->
                  if value
                    for k,v of data
                      model.set(k, { field: k, value: v, type: 'text' })
                    window.TS.save()
                    model.save ->
                      window.location.reload()

  enable: ->
    $('body').addClass('ts-edit-mode');
    $('#ts-admin-bar').removeClass('ts-hidden')
    $('#ts-admin-bar-edit').addClass('ts-hidden')

  disable: ->
    $('body').removeClass('ts-edit-mode');
    $('#ts-admin-bar').addClass('ts-hidden').removeClass 'insert-open'
    $('#ts-admin-bar-edit').removeClass('ts-hidden')