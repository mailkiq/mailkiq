class App.Subscribers.Index
  initializeElements: ->
    @overlay = $('.overlay')
    @box = @overlay.find('.box')
    @link = $('.open-form')

  initializeEvents: ->
    @link.click @openModal
    @overlay.click @closeModal

  openModal: (ev) =>
    @overlay.css('visibility', 'visible').addClass('active')

  closeModal: (ev) =>
    return unless $(ev.target).hasClass('overlay')

    @overlay.removeClass('active')

    setTimeout =>
      @overlay.css('visibility', 'hidden')
    , 250

  render: ->
    @initializeElements()
    @initializeEvents()
