class App.Settings.Domains
  openModal: (ev) =>
    value = $(ev.target).parents('tr').find('td:first').text()
    @domains.find('.last').removeClass('last')
    @domains.find('tbody tr').hide()
    @domains.find('tbody tr')
      .filter(-> $(this).data('name') == value)
      .show()
      .filter(':last')
      .addClass('last')

    @overlay
      .css('visibility', 'visible')
      .addClass('active')

    ev.preventDefault()

  closeModal: (ev) =>
    return unless $(ev.target).hasClass('overlay')

    @overlay.removeClass('active')

    setTimeout =>
      @overlay.css('visibility', 'hidden')
    , 250

  initializeClipboard: ->
    new Clipboard '.overlay td',
      text: (trigger) ->
        trigger.textContent

  initializeElements: ->
    @infoButton = $('.open-modal')
    @overlay = $('.overlay')
    @domains = $('.overlay table')

  initializeEvents: ->
    @infoButton.click @openModal
    @overlay.click @closeModal

  render: ->
    @initializeElements()
    @initializeEvents()
    @initializeClipboard()
