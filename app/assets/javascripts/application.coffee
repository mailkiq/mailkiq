#= require jquery
#= require jquery_ujs
#= require chosen/abstract-chosen
#= require chosen/select-parser
#= require chosen.jquery
#= require_self
#= require_tree ./modules

window.App = {}

$ ->
  App.Analytics.init()
  App.Analytics.pageview()

  $('body > .alert').delay(5000).slideUp(500)
  $('#subscriber_tag_ids, #delivery_tagged_with, #delivery_not_tagged_with')
    .chosen()
