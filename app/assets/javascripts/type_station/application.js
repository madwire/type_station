// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery-fileupload/basic
//= require jquery.cloudinary
//= require classList
//= require medium-editor
//= require drop
//= require vex.combined.min
//= require type_station/lib/ts
//= require type_station/lib/models
//= require type_station/lib/helpers
//= require_tree ./editables
//= require type_station/init
//= require_self

jQuery(function(){
  window.TS.init();
});
