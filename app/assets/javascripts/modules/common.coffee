class App.Common
  constructor: ->
    @dropdownSelector = '.nav-dropdown-toggle'
    @closeSelector = '.flash-close'
    @chosenSelector = [
      '#subscriber_tag_ids',
      '#delivery_tagged_with',
      '#delivery_not_tagged_with'
    ].join(', ')

  closeClick: (ev) ->
    $(this).parents('.flash').remove()
    ev.preventDefault()

  toggleDropdown: (ev) ->
    $(this).toggleClass('active')
    $('.nav-dropdown').toggleClass('active')
    ev.preventDefault()

  onDropdown: ($target) ->
    $target.hasClass('nav-dropdown') ||
      $target.hasClass('nav-dropdown-toggle') ||
      $target.parents('.nav-dropdown').length > 0 ||
      $target.parents('.nav-dropdown-toggle').length > 0

  render: ->
    $(@chosenSelector).chosen()
    $(@closeSelector).click @closeClick
    $(@dropdownSelector).click @toggleDropdown

    $(document.body).click (ev) =>
      return if @onDropdown $(ev.target)

      $('.nav-dropdown-toggle').removeClass('active')
      $('.nav-dropdown').removeClass('active')
