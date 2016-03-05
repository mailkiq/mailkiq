class App.Controllers.Dashboard
  constructor: ->
    @el = $('.panel-body')
    @points = []

    $.each @el.data('metrics'), (date, value) =>
      @points.push [Date.parse(date), value]

  show: ->
    @el.highcharts
      chart:
        height: 120
        style:
          fontFamily: 'Montserrat, sans-serif'
      credits:
        enabled: false
      title:
        text: null
      legend:
        enabled: false
      tooltip:
        backgroundColor: '#b8ddff'
        borderWidth: 0
        borderRadius: 0
        hideDelay: 350
        shadow: false
        headerFormat: '<span style="font-size: 12px; color: #808080">{point.key}</span><br/>'
        pointFormat: '<span style="font-size: 20px; color: #4f4f4f; font-weight: bold">{point.y}</span><br/>'
        shape: 'square'
        style:
          padding: '17px 20px'
      yAxis:
        labels:
          enabled: false
        title:
          text: null
        gridLineColor: 'transparent'
        minPadding: 0
      xAxis:
        type: 'datetime'
        labels:
          style:
            color: '#b3b3b3'
        lineColor: '#e1e1e1'
        lineWidth: 1
        tickLength: 5
        tickColor: '#e1e1e1'
      series: [{
        type: 'line'
        data: @points
        lineWidth: 2
        color: '#819bb3'
        zIndex: 10
        marker:
          lineWidth: 2
          radius: 5
      }]
