class App.Tabs
  constructor: ->
    @tabContainer = $('.tabs')
    @tabs = @tabContainer.find('.tab')
    @labels = $('.tabs-labels label')
    @initializeEvents()

  initializeEvents: ->
    @labels.click @tabClick

  tabClick: (ev) =>
    label = $(ev.target)
    label.addClass('active')

    tab = label.attr('for').replace('campaign_', '')

    if label.is('[for=campaign_html_text]')
      @tabContainer.removeClass('second').addClass('first')
    else
      @tabContainer.removeClass('first').addClass('second')

    @labels.not(label).removeClass('active')
    @tabs.removeClass('active')
    @tabs.filter("[data-tab=#{tab}]").addClass('active')
