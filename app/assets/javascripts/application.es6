//= require jquery
//= require jquery_ujs
//= require bootstrap/dropdown
//= require bootstrap/tab
//= require redactor
//= require_tree .

$(function(){
  $('body > .alert').delay(5000).slideUp(500);

  $('#campaign_html_text').redactor({
    minHeight: 370
  });
});
