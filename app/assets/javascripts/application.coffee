#= require jquery
#= require jquery_ujs
#= require selectize
#= require_tree ./components
#= require_self

$ ->
  Analytics.init()
  Analytics.track 'Page viewed',
    'page name' : document.title,
    'url' : window.location.pathname
