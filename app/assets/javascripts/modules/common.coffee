class App.Common
  constructor: ->
    @dropdownSelector = '.dropdown-toggle'
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
    $('.dropdown').toggleClass('active')
    ev.preventDefault()

  onDropdown: ($target) ->
    $target.hasClass('nav-dropdown') ||
      $target.hasClass('dropdown-toggle') ||
      $target.parents('.dropdown').length > 0 ||
      $target.parents('.dropdown-toggle').length > 0

  render: ->
    $(@chosenSelector).chosen()
    $(@closeSelector).click @closeClick
    $(@dropdownSelector).click @toggleDropdown

    $(document.body).click (ev) =>
      return if @onDropdown $(ev.target)

      $('.dropdown-toggle').removeClass('active')
      $('.dropdown').removeClass('active')
