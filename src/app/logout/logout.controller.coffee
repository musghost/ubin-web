angular.module 'ubinWeb'
  .controller 'LogoutController', ($state, LoginUser, web) ->
    'ngInject'
    vm = this
    LoginUser.logout()
    window.location.href = web

  .controller 'TokenController', ($stateParams, $rootScope, $state, $cookies) ->
    'ngInject'
    vm = this
    $cookies.put 'token', $stateParams.token
    $cookies.put 'id', $stateParams.id
    $cookies.put 'name', $stateParams.name
    $state.go 'home', {}, {reload: true}
    data =
      user:
        name: $stateParams.name
    $rootScope.$broadcast 'login', data