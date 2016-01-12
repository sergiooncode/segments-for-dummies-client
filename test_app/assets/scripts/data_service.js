import angular from 'angular';

angular.module('app').
    factory('DataService', 
	    ['$http', '$q',
	    function($http, $q) {

		return {
			getData: function() {
				var defer = $q.defer();
				$http.get('http://127.0.0.1:4000/api/shoppers')
				.success(function(data) {
					defer.resolve(data);
				});

				return defer.promise;
			}
		};
}]);

