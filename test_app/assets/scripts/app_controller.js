angular.module('app').
    controller('AppController',
              ['$scope','DataService',
              function($scope, DataService) {

    DataService.getData().then(function(data) {
	    $scope.data = data.data;
    });
    /**$scope.shoppers = ['one shopper', 'another shopper'];**/

}]);
