angular.module 'ubinWeb'
  .controller 'LoginController', (Crud, $cookies, $http, $state, api, alerts, $rootScope) ->
    vm = @
    vm.data =
      device_os: 'web'

    vm.alerts = alerts

    vm.login = (e) ->
      e.preventDefault()
      $http({
        url: " #{api}/api-token-auth/"
        method: 'POST'
        data: vm.data
      })
      .then (response) ->
        if response.data.token?
          $cookies.put 'token', response.data.token
          $cookies.put 'id', response.data.user.id
          $cookies.put 'name', "#{response.data.user.name}"
          $cookies.put 'photo', response.data.user.photo
          $state.go 'home', {}, {reload: true}
          $rootScope.$broadcast 'login', response.data
        return
      .catch (res) ->
        if res.status == 400
          vm.alerts.add 'danger', 'El nombre de usuario o contraseña son inválidos.'
        else
          vm.alerts.add 'danger', 'Hubo un error con el servidor. Inténtelo más tarde.'

      return
    return