class App.Common
  chosenSelector: [
    '#subscriber_tag_ids',
    '#campaign_tagged_with',
    '#campaign_not_tagged_with'
  ].join(', ')

  closeClick: (ev) ->
    $(this).parents('.flash').remove()
    ev.preventDefault()

  initializeElements: ->
    @flashCloseButton = $('.flash-close')
    @selects = $(@chosenSelector)

  initializeEvents: ->
    @selects.chosen(placeholder_text_multiple: ' ')
    @flashCloseButton.click @closeClick

  render: ->
    @initializeElements()
    @initializeEvents()
