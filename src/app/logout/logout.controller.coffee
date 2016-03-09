angular.module 'ubinWeb'
  .controller 'LogoutController', ($state, LoginUser) ->
    'ngInject'
    vm = this
    LoginUser.logout()
      .then () ->
        $state.go 'login'
      .catch (object) ->
        console.log object