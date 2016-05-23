angular.module 'ubinWeb'
  .controller 'LoginController', (Crud, $cookies, $http, $state, api, alerts, $rootScope, base) ->
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
          if response.data.user.photo != ''
            photo = "#{base}media/#{response.data.user.photo}"
          else
            photo = 'assets/images/position/profile.png'
          $cookies.put 'token', response.data.token
          $cookies.put 'id', response.data.user.id
          $cookies.put 'name', response.data.user.name
          $cookies.put 'photo', photo
          $cookies.put 'special', response.data.user.allow_past_due_portfolio
          $state.go 'home', {}, {reload: true}
          window.location.href = '/'
          $rootScope.$broadcast 'login', response.data
        return
      .catch (res) ->
        console.log res
        if res.status == 400
          vm.alerts.add 'danger', 'El nombre de usuario o contraseña son inválidos.'
        else
          vm.alerts.add 'danger', 'Hubo un error con el servidor. Inténtelo más tarde.'

      return
    return