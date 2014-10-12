APP.directive("outOfControl", function() {
  return {
    restrict: 'E',
    scope: {
      points: '=',
      sequence: '='
    },
    replace: true,
    templateUrl: "out_of_control.html",
    controller: ['$scope', 'Notify', function($scope, Notify) {
      $scope.ignore = function(time) {
        $scope.sequence.customPOST({time: time}, "entries/ignore").then(function(entries) {
          delete $scope.points[time];
          Notify.success("Success", "This point will not longer appear in charts or reports. Refresh to update the charts.");
        });
      }
    }]
  };
});
