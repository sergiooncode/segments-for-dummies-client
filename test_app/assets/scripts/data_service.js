angular.module('app').
    factory('DataService', 
	    ['$http', '$q',
	    function($http, $q) {

		return {
			getData: function() {
				var defer = $q.defer();
				$http.get('http://127.0.0.1:4000/api/shoppers')
				/**$http({
					method: 'JSONP',
					url: 'http://127.0.0.1:4000/api/shoppers',
					params: {
						format: 'jsonp',
						callback: 'JSON_CALLBACK'
					}
				})**/
				.success(function() {
					defer.resolve(data);
				});

				return defer.promise;
			}
		};
}]);

