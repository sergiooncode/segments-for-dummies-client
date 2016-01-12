import angular from 'angular';

angular.module('app', []).
    config(['$interpolateProvider', '$httpProvider', function($interpolateProvider, $httpProvider) {
    $interpolateProvider.startSymbol('{[');
    $interpolateProvider.endSymbol(']}');
}]);

/**angular.module('app').config(['$urlRouterProvider'], function($urlRouterProvider) {
    $urlRouterProvider.otherwise("/");

});
**/
