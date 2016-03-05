class App.Controllers.Common
  constructor: ->
    @closeSelector = '.flash-close'
    @chosenSelector = [
      '#subscriber_tag_ids',
      '#delivery_tagged_with',
      '#delivery_not_tagged_with'
    ].join(', ')

  closeClick: (ev) ->
    $(this).parents('.flash').remove()
    ev.preventDefault()

  render: ->
    $(@chosenSelector).chosen()
    $(@closeSelector).click @closeClick
