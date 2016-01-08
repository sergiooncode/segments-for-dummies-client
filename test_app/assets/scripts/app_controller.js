angular.module('app').
    controller('AppController',
              ['$scope', '$http',
              function($scope, $http) {

    /**$scope.shoppers = function() {
        return $http.jsonp('http://localhost:4000/api/shoppers', {
        }).then(
          response => {
              return response.data;
          },
          response => {
              return response;
          }
        );
    };**/

    $scope.shoppers = ['one shopper', 'another shopper'];

}]);
