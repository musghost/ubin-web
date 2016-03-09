angular.module 'ubinWeb'
  .controller 'LoginController', (Crud, $cookies, $http, $state, api, alerts) ->
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
          $cookies.put 'name', "#{response.data.user.name} #{response.data.user.last_name}"
          $cookies.put 'photo', response.data.user.photo
          $state.go 'home', {}, {reload: true}
        return
      .catch (res) ->
        if res.status == 400
          vm.alerts.add 'danger', res.data.non_field_errors

      return
    return