angular.module 'ubinWeb'
  .config ($httpProvider) ->
    'ngInject'
    $httpProvider.interceptors.push ($q, $location) ->
      responseError: (rejection) ->
        if rejection.status == 403
          $location.path '/login'
        $q.reject rejection