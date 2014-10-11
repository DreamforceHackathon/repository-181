APP.service("CurrentUser", ['Restangular', '$state', function(Restangular, $state) {
  var CurrentUser = {
    user: null,
    load: function() {
      Restangular.one("user").get().then(function(user) {
        CurrentUser.user = user;
        $state.go('dashboard');
      }, function(error) {
        if (error.status == 404) {
          CurrentUser.user = null;
          $state.go('home');
        }
      });
    }
  };

  return CurrentUser;
}]);
