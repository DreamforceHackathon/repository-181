APP.controller("SignupController", ['$scope', 'Restangular', 'CurrentUser', function($scope, Restangular, CurrentUser) {
  $scope.details = {
    name: "Steve - For Testing",
    organization: "SalesLoft",
    sfdc: true
  };

  $scope.submit = function(details) {
    Restangular.all("user").post(details).then(function(user) {
      CurrentUser.login();
    });
  };
}]);
