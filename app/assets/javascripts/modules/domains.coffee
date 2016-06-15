class App.Domains.Show
  initializeEvents: ->
    $('.dkim a').each ->
      $(this).click -> false

      new Clipboard this,
        target: (trigger) ->
          trigger.nextElementSibling

  render: ->
    @initializeEvents()
