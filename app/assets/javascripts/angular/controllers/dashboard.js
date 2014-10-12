APP.controller("DashboardController", ['$scope', 'CurrentUser', 'Restangular', function($scope, CurrentUser, Restangular) {
  Restangular.all("sequences").getList().then(function(sequences) {
    $scope.sequences = sequences;
  });
}]);
