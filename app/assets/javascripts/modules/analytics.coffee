App.Analytics =
  init: ->
    mixpanel.init '30cfb1aa3e9a5253a479242388d15667'
    mixpanel.register '$ignore': true if location.hostname.match('localhost')
    mixpanel.identify @account.id
    mixpanel.people.set
      '$first_name': @account.first_name,
      '$last_name': @account.last_name,
      '$created': @account.created_at,
      '$email': @account.email

  identify: (account) ->
    @account = account

  track: (name, properties) ->
    mixpanel.track name, properties

  pageview: ->
    @track 'Page viewed',
      'page name' : document.title,
      'url' : window.location.pathname

  source: ->
    if document.referrer.search('https?://(.*)google.([^/?]*)') == 0
      'Google'
    else if document.referrer.search('https?://(.*)bing.([^/?]*)') == 0
      'Bing'
    else if document.referrer.search('https?://(.*)yahoo.([^/?]*)') == 0
      'Yahoo'
    else if document.referrer.search('https?://(.*)facebook.([^/?]*)') == 0
      'Facebook'
    else if document.referrer.search('https?://(.*)twitter.([^/?]*)') == 0
      'Twitter'
    else
      'Other'
