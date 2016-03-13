#= require jquery
#= require jquery_ujs
#= require chosen/abstract-chosen
#= require chosen/select-parser
#= require chosen.jquery
#= require clipboard
#= require_self
#= require_tree ./modules

@App =
  Dashboard: {}
  Settings: {}

  init: ->
    [controller_name, action_name] = $('body').data('route').split('#')
    action_name = action_name.capitalize()

    new App.Common().render()

    if App[controller_name] and App[controller_name][action_name]
      (new App[controller_name][action_name]).render()

$ ->
  App.init()
