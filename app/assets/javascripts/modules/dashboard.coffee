class App.Dashboard.Show
  constructor: ->
    @el = $('.panel-body')
    @metrics = @el.data('metrics')
    @deliveries = []
    @bounces = []
    @complaints = []
    @rejects = []

    $.each @el.data('metrics'), (_, item) =>
      timestamp = Date.parse(item.Timestamp)
      @deliveries.push [timestamp, item.DeliveryAttempts || null]
      @bounces.push [timestamp, item.Bounces || null]
      @complaints.push [timestamp, item.Complaints || null]
      @rejects.push [timestamp, item.Rejects || null]

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
      }, {
        name: 'Rejects'
        data: @rejects
        color: '#ffbbbb'
      }]
