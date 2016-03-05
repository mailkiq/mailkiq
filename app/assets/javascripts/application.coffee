#= require jquery
#= require jquery_ujs
#= require chosen/abstract-chosen
#= require chosen/select-parser
#= require chosen.jquery
#= require_self
#= require_tree ./modules

@App =
  Controllers: {}

  init: ->
    [controller_name, action_name] = $('body').data('route').split('#')

    App.Analytics.init()
    App.Analytics.pageview()

    new App.Controllers.Common().render()

    if App.Controllers.hasOwnProperty controller_name
      (new App.Controllers[controller_name])[action_name]()

$ ->
  App.init()
