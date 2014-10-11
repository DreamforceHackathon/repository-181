/*
 ==== Standard ====
 = require jquery
 = require bootstrap
 = require pnotify

 ==== Angular ====
 = require angular

 ==== Angular Plugins ====
 = require lodash
 = require restangular
 = require angular-ui-router
 = require angular-animate
 = require mobile-angular-ui/dist/js/mobile-angular-ui.min.js

 = require_self
 = require_tree ./angular/templates
 = require_tree ./angular
 */

var APP = angular.module('Incontrol', [
  'ui.router',
  'templates',
  'restangular',
  'mobile-angular-ui',
  'ngAnimate'
]);

APP.config(function($stateProvider, $urlRouterProvider, $locationProvider, RestangularProvider) {
  RestangularProvider.setRequestSuffix(".json");

  $urlRouterProvider.otherwise("/");

  $stateProvider
    .state("home", {
      url: '/',
      templateUrl: "index.html"
    })
    .state("signup", {
      url: '/signup',
      templateUrl: "signup/index.html",
      controller: "SignupController"
    })
    .state("dashboard", {
      url: '/dash',
      templateUrl: "dashboard.html",
      controller: "DashboardController"
    });

  // This allows the user to have a proper history / browsing stack
  $locationProvider.html5Mode(true);
}).

run(['CurrentUser', '$rootScope', function(CurrentUser, $rootScope) {
  CurrentUser.load();
  $rootScope.CurrentUser = CurrentUser;
}]);
