angular.module 'ubinWeb'
  .controller 'EditController', (Crud, LoginUser) ->
    vm = @

    Crud.user.query({userId: LoginUser.getId()}).$promise.then (user) ->
      vm.user = user
      delete vm.user.type_advisor
      delete vm.user.password

    vm.saveUser = ->
      vm.user.$update().then () ->
        alert('Usuario actualizado')
      return

    return