/* global app */

app.controller("stateCtrl", ["$scope", "State", function($scope, State) {
    $scope.left = "Der er";
    $scope.left_size = 3;
    $scope.right_size = 3;
    
    $scope.start = function() {
      State.get({id: $scope.left, left_size: $scope.left_size, right_size: $scope.right_size}, function(data) {
        $scope.result = data.result;
      });
    };
}]);