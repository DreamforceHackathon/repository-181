APP.directive("highchart", function() {
  return {
    restrict: 'E',
    scope: {
      config: '=',
      sequence: '='
    },
    link: function (scope, element, attrs) {
      var config = JSON.parse(scope.config);
      config["chart"] = {
        renderTo: element[0],
        backgroundColor:'rgba(255, 255, 255, 0.75)',
        width: element.parent().width(),
        height: Math.min(element.parent().width() / 1.5, 300)
      };
      config.series[0].name = scope.sequence.title;

      chart = new Highcharts.Chart(config);

      chart.yAxis[0].update({
        labels: {
          enabled: true
        },
        title: {
          text: null
        }
      });
      console.log(config);
    }
  }
});
