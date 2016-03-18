angular.module 'ubinWeb'
  .controller 'EditController', (Crud, LoginUser) ->
    vm = @

    Crud.user.query({userId: 10}).$promise.then (user) ->
      vm.user = user
      vm.user.type_advisor = user.type_advisor.id
      delete vm.user.password

    Crud.typesAdvisors.query().$promise.then (advisors) ->
      vm.types = advisors.results

    vm.saveUser = ->
      if !!vm.password
        vm.user.password = vm.password
      vm.user.$update().then () ->
        alert('Usuario actualizado')
      return

    return