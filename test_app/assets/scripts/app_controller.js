angular.module('app').
    controller('AppController',
              ['$scope', '$http',
              function($scope, $http) {
    return $http.jsonp('http://localhost:4000/api/shoppers', {
    }).then(
     response => {
         return response.data
     },
     response => {
         return response
     }
    );
}]);
