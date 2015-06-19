window.TS = {}
window.TS.onSave = -> null unless window.TS['onSave']
window.TS.onSaved = -> null unless window.TS['onSaved']

window.TS.onEnable = -> null unless window.TS['onEnable']
window.TS.onEnabled = -> null unless window.TS['onEnabled']

window.TS.onDisable = -> null unless window.TS['onDisable']
window.TS.onDisabled = -> null unless window.TS['onDisabled']

window.TS.init = ->
  window.typeStation = new TypeStation $('[data-ts]'),
    onSave: window.TS.onSave
    onSaved: window.TS.onSaved
    onEnable: window.TS.onEnable
    onEnabled: window.TS.onEnabled
    onDisable: window.TS.onDisable
    onDisabled: window.TS.onDisabled
