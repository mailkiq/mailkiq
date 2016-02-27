#= require jquery
#= require jquery_ujs
#= require selectize
#= require_self
#= require_tree ./modules

window.App = {}

$ ->
  App.Analytics.init()
  App.Analytics.pageview()
