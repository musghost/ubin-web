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
          $cookies.put 'name', "#{response.data.user.name} #{response.data.user.last_name}"
          $cookies.put 'photo', response.data.user.photo
          $state.go 'home', {}, {reload: true}
        return
      return
    return