#= require jquery
#= require jquery_ujs
#= require selectize
#= require bootstrap/dropdown
#= require bootstrap/tab
#= require_tree ./components
#= require_self

$ ->
  $('body > .alert').delay(5000).slideUp(500)
  $('#subscriber_tag_ids, #delivery_tagged_with, #delivery_not_tagged_with')
    .selectize()

  Analytics.init()
  Analytics.track 'Page viewed',
    'page name' : document.title,
    'url' : window.location.pathname
