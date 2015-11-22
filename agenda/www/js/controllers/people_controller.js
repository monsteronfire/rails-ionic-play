(function() {
  var app = angular.module('PeopleController ', []);

  app.controller('PeopleController', 
    function($scope, $http) {
      var url = 'http://localhost:3000/api/people';

      $http.get(url)
      .success(function(people) {
        $scope.people = people;
      })
      .error(function(data) {
        console.log('Server side error occurred');
      });
    }
  );

})();