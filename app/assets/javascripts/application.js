//= require flight/index
//= require almond/almond
//= require jquery/dist/jquery
//= require jquery-ujs/src/rails
//= require redactor
//= require bootstrap/dropdown
//= require bootstrap/tab
//= require_tree ./components
//= require_self

var $ = require('jquery');
var Common = require('components/common');

$(function(){
  Common.attachTo(document);
});
