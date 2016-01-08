angular.module('app').
    controller('AppController',
              ['$scope',
              function($scope) {
var ele = document.getElementById('hello');
ele.innerHTML = 'Hello (with javascript)';
}]);
