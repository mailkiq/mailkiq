#= require jquery
#= require jquery_ujs
#= require selectize
#= require bootstrap/dropdown
#= require bootstrap/tab
#= require_self

$ ->
  $('body > .alert').delay(5000).slideUp(500)
  $('#subscriber_tag_ids').selectize()
