class window.TS.MovePage
  constructor: (@elements) ->
    

  enable: ->
    setTimeout(->
      $('.ts-link-finder, .medium-editor-toolbar-input').textcomplete [
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
          replace: (page) -> page.path.substring(1)
          template: (page) -> "#{page.title} (#{page.path})"
        }
      ], 
        zIndex: 10000
    , 500)
    
  disable: ->