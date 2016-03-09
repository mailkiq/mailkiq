#= require jquery
#= require jquery_ujs
#= require chosen/abstract-chosen
#= require chosen/select-parser
#= require chosen.jquery
#= require_self
#= require_tree ./modules

@App =
  Dashboard: {}

  init: ->
    [controller_name, action_name] = $('body').data('route').split('#')

    new App.Common().render()

    if App.hasOwnProperty(controller_name)
      (new App[controller_name][action_name.capitalize()]).render()

$ ->
  App.init()
