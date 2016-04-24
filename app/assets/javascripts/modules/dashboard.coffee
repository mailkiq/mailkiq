class App.Dashboard.Show
  constructor: ->
    @el = $('.panel-body')
    @metrics = @el.data('metrics')
    @deliveries = []
    @bounces = []
    @complaints = []

    $.each @el.data('metrics'), (_, item) =>
      timestamp = Date.parse(item.timestamp)
      @deliveries.push [timestamp, item.delivery_attempts]
      @bounces.push [timestamp, item.bounces]
      @complaints.push [timestamp, item.complaints]

  render: ->
    @el.highcharts
      chart:
        height: 300
      series: [{
        name: 'Deliveries'
        data: @deliveries
        color: '#85c0ff'
      }, {
        name: 'Hard Bounces'
        data: @bounces
        color: '#ffbbbb'
      }, {
        name: 'Complaints'
        data: @complaints
        color: '#ffd785'
      }]
