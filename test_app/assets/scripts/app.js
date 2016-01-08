angular.module('app', []);

angular.module('app').config(['$interpolateProvider', function($interpolateProvider) {
    $interpolateProvider.startSymbol('{[');
    $interpolateProvider.endSymbol(']}');
}]);

/**angular.module('app').config(['$urlRouterProvider'], function($urlRouterProvider) {
    $urlRouterProvider.otherwise("/");

});
**/
