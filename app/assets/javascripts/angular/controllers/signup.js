APP.controller("SignupController", ['$scope', 'Restangular', function($scope, Restangular) {
  $scope.details = {
    name: "Steve",
    organization: "SalesLoft",
    sfdc: true
  };

  $scope.submit = function(details) {
    Restangular.all("user").post(details).then(function(user) {
      console.log(user);
    });
  };
}]);
