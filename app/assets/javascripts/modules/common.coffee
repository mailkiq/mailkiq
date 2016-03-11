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

  hideDropdown: ->
    $('.dropdown')
      .removeClass('fadeInDown')
      .addClass('fadeOutUp')

    setTimeout ->
      $('.dropdown').removeClass('active')
    , 300

  toggleDropdown: (ev) =>
    $toggle = $(ev.target)
    $toggle.toggleClass('active')

    if $toggle.hasClass('active')
      $('.dropdown')
        .addClass('active')
        .addClass('fadeInDown')
        .removeClass('fadeOutUp')
    else
      @hideDropdown()

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
      @hideDropdown()
