angular.module 'ubinWeb'
  .controller 'UserController', (Crud, $stateParams, base, Fav) ->
    'ngInject'
    vm = this

    vm.base = base

    Crud.publicationsFilter
      .query({user__id: $stateParams.id})
      .$promise
      .then (result) ->
        vm.posts = result.results

    vm.fav = Fav.fav
    return