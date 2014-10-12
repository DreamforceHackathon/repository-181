APP.controller("DashboardController", ['$scope', 'CurrentUser', 'Restangular', function($scope, CurrentUser, Restangular) {
  Restangular.all("sequences").getList().then(function(sequences) {
    _.each(sequences, function(sequence) {
      sequence.out_of_control = angular.extend(sequence.charts.mamr.out_of_control, sequence.charts.range_mamr.out_of_control)
    });
    $scope.sequences = sequences;
  });
}]);
