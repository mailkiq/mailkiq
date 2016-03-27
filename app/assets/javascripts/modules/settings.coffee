class App.Settings.Domains
  showRows: (ev) =>
    value = @domainSelect.find('option:selected').text()
    @domains.find('.last').removeClass('last')
    @domains.find('tbody tr').hide()
    @domains.find('tbody tr')
      .filter(-> $(this).data('name') == value)
      .show()
      .filter(':last')
      .addClass('last')

  openModal: (ev) =>
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
    @dnsButton = $('.domains .btn')
    @overlay = $('.overlay')
    @domains = $('.overlay table')
    @domainSelect = $('.overlay select')

  initializeEvents: ->
    @dnsButton.click @openModal
    @overlay.click @closeModal
    @domainSelect.change @showRows
    @domainSelect.trigger 'change'

  render: ->
    @initializeElements()
    @initializeEvents()
    @initializeClipboard()
