String::capitalize = ->
  @charAt(0).toUpperCase() + @slice(1)

$.fn.animationend = (fn) ->
  @one('animationend webkitAnimationEnd MSAnimationEnd oAnimationEnd', fn)

$.fn.transitionend = (fn) ->
  @one('webkitTransitionEnd oTransitionEnd transitionend msTransitionEnd', fn)
