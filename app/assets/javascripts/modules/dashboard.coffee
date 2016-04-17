class App.Dashboard.Show
  constructor: ->
    @el = $('.panel-body')
    @metrics = @el.data('metrics')
    @deliveries = []
    @bounces = []
    @complaints = []

    $.each @el.data('metrics'), (_, item) =>
      timestamp = Date.parse(item.Timestamp)
      @deliveries.push [timestamp, item.DeliveryAttempts]
      @bounces.push [timestamp, item.Bounces]
      @complaints.push [timestamp, item.Complaints]

  render: ->
    @el.highcharts
      chart:
        height: 300
      series: [{
        name: 'Deliveries'
        data: @deliveries
        color: '#85c0ff'
      }, {
        name: 'Bounces'
        data: @bounces
        color: '#ffbbbb'
      }, {
        name: 'Complaints'
        data: @complaints
        color: '#ffd785'
      }]
