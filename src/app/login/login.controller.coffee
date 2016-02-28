angular.module 'ubinWeb'
  .controller 'LoginController', (Crud, $cookies, $http) ->
    vm = @
    vm.login = {}

    vm.login = () ->
      $http({
        url: " #{api}/api-token-auth/"
        method: 'POST'
        data: vm.login
      }).then (response) ->
        if response.data.token?
          $cookies.put 'token', response.data.token
          $cookies.put 'id', response.data.user.id
        return
      return
    return