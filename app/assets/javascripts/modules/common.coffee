class App.Common
  chosenSelector: [
    '#subscriber_tag_ids',
    '#delivery_tagged_with',
    '#delivery_not_tagged_with'
  ].join(', ')

  closeClick: (ev) ->
    $(this).parents('.flash').remove()
    ev.preventDefault()

  hideDropdown: ->
    @dropdown
      .removeClass('fadeInDown')
      .addClass('fadeOutUp')
      .animationend (e) ->
        if e.originalEvent.animationName == 'fadeOutUp'
          $(this).removeClass('active')

  toggleDropdown: (ev) =>
    @dropdownToggleButton = $(ev.target)
    @dropdownToggleButton.toggleClass('active')

    if @dropdownToggleButton.hasClass('active')
      @dropdown
        .addClass('active')
        .addClass('fadeInDown')
        .removeClass('fadeOutUp')
    else
      @hideDropdown()

    ev.preventDefault()

  onDropdown: (el) ->
    el.hasClass('nav-dropdown') ||
      el.hasClass('dropdown-toggle') ||
      el.parents('.dropdown').length > 0 ||
      el.parents('.dropdown-toggle').length > 0

  bodyClick: (ev) =>
    return if @onDropdown $(ev.target)
    @dropdownToggleButton.removeClass('active')
    @hideDropdown()

  initializeElements: ->
    @dropdown = $('.dropdown')
    @dropdownToggleButton = $('.dropdown-toggle')
    @flashCloseButton = $('.flash-close')
    @selects = $(@chosenSelector)

  initializeEvents: ->
    @selects.chosen(placeholder_text_multiple: ' ')
    @flashCloseButton.click @closeClick
    @dropdownToggleButton.click @toggleDropdown
    $(document.body).click @bodyClick

  render: ->
    @initializeElements()
    @initializeEvents()
