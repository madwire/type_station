jQuery ->

  elements = document.querySelectorAll('.ts-editable-text')
  window.t = editor = new MediumEditor elements,
    disableReturn: true
    buttons: ['bold', 'italic', 'underline', 'anchor']


  elements = document.querySelectorAll('.ts-editable-html')
  window.t = editor = new MediumEditor elements,
    buttons: ['bold', 'italic', 'underline', 'anchor', 'header1', 'header2', 'unorderedlist', 'orderedlist', 'justifyLeft', 'justifyFull', 'justifyCenter', 'justifyRight']

  $('.ts-editable-text').on 'input', ->
    console.log this

#   textParserRules =
#     tags:
#       strong: {}
#       b: {}
#       i: {}
#       em: {}
#       br: {}
#       p:
#         unwrap: 1
#       div:
#         unwrap: 1
#       span:
#         unwrap: 1
#       ul:
#         unwrap: 1
#       ol:
#         unwrap: 1
#       li:
#         unwrap: 1
#       a:
#         check_attributes:
#           href:   "url" # important to avoid XSS
  
#   $('.ts-editable-text').each (i)->
#     $this = $(@)
#     data = $this.data()
#     offset = $this.offset()
#     console.log data
#     #Set up ID
#     toolbarId = "#{data.tsId}-#{i}-toolbar"
#     $($('#ts-editable-text-toolbar').html())
#       .attr('id', toolbarId)
#       .css({ position: 'absolute', top: (offset.top - 20), left: offset.left})
#       .appendTo('body')

#     window.t = editor = new wysihtml5.Editor @,
#       toolbar:  toolbarId
#       parserRules: textParserRules
#       contentEditableMode: true