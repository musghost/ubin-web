angular.module 'ubinWeb'
  .config ($httpProvider, $resourceProvider) ->
    'ngInject'
    $resourceProvider.defaults.stripTrailingSlashes = false
    $httpProvider.interceptors.push ($q, $location, $cookies) ->
      responseError: (rejection) ->
        if rejection.status == 403
          $cookies.remove 'token'
          $cookies.remove 'id'
          $cookies.remove 'name'
          $cookies.remove 'photo'
          $location.path '/login'
        $q.reject rejection

      request: (config) ->
        if $cookies.get('token')
          config.headers['Authorization'] = "JWT #{$cookies.get('token')}"
        config