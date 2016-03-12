angular.module 'ubinWeb'
  .controller 'MainController', (Crud, LoginUser, $state) ->
    'ngInject'
    vm = this
    vm.location = {}

    Crud.country.query({page_size: 1000}).$promise.then (result) ->
      vm.countries = result.results
      if LoginUser.getLocation()?
        vm.location = LoginUser.getLocation()
        console.log vm.location

    Crud.typePublication.query().$promise.then (result) ->
      vm.publication = result.results

    Crud.stateFilter.query().$promise.then (result) ->
      vm.states = result.results

    vm.setLocation = ->
      LoginUser.setLocation vm.location
      $state.go 'post'

    return
