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

  $('#subscriber_tag_ids, #delivery_tagged_with, #delivery_not_tagged_with')
    .chosen()

  $('.flash-close').click (ev) ->
    $(this).parents('.flash').remove()
    ev.preventDefault()
