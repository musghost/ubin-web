angular.module 'ubinWeb'
  .controller 'NotificationController', (Crud, LoginUser) ->
    'ngInject'
    vm = @

    Crud.notificationsFilter.query({user__id: LoginUser.getId(), order: '-date'}).$promise.then (result) ->
      vm.notifications = result.results
    return