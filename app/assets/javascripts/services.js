angular.module('services', ['ngResource']).
factory('State', ["$resource", function($resource){
  return $resource('/state/:id', {}, {
    update: {method:'PUT'}
  });
}]);