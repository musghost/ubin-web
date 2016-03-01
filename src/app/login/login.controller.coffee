angular.module 'ubinWeb'
  .controller 'LoginController', (Crud, $cookies, $http, $state, api) ->
    vm = @
    vm.data =
      device_os: 'web'

    vm.login = (e) ->
      console.log 'vim'
      e.preventDefault()
      $http({
        url: " #{api}/api-token-auth/"
        method: 'POST'
        data: vm.data
      }).then (response) ->
        if response.data.token?
          $cookies.put 'token', response.data.token
          $cookies.put 'id', response.data.user.id
          $state.go 'home'
        return
      return
    return