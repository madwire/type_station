class @TypeStation.AdminBarEditor
  constructor: (@ts, @$el, @data) ->
    template = @$el.html()
    $('body').append(template)
    vex.defaultOptions.className = 'vex-theme-os'

    $('#ts-admin-bar-edit').on 'click', =>
      @ts.enable()
      false

    $('#ts-admin-bar-cancel').on 'click', =>
      @ts.disable()
      if @ts.isChanged()
        vex.dialog.confirm
          message: 'You have unsaved changes, Do you want to discard them?'
          callback: (value) ->
            if value
              window.location.reload()
      false

    $('#ts-admin-bar-save').on 'click', =>
      vex.dialog.confirm
        message: 'Are you sure you want to save changes?'
        callback: (value) =>
          if value
            @ts.save()
      false


    $titleEditor = $('#ts-admin-bar-title')
    editor = new TypeStation.TextHtmlEditor(@ts, $titleEditor, $titleEditor.data('ts'))
    @ts.editors.set $titleEditor.attr('id'), editor

    $editEditor = $('#ts-admin-bar-settings')
    console.log $editEditor.data('ts')
    editor = new TypeStation.EntityEditor(@ts, $editEditor, $editEditor.data('ts'))
    @ts.editors.set $editEditor.attr('id'), editor

  enable: ->
    $('#ts-admin-bar').removeClass('ts-hidden')
    $('#ts-admin-bar-edit').addClass('ts-hidden')

  disable: ->
    $('#ts-admin-bar').addClass('ts-hidden').removeClass 'insert-open'
    $('#ts-admin-bar-edit').removeClass('ts-hidden')
