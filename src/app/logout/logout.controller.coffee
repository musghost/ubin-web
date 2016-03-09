angular.module 'ubinWeb'
  .controller 'LogoutController', ($state, LoginUser) ->
    'ngInject'
    vm = this
    LoginUser.logout()
    $state.go 'login'