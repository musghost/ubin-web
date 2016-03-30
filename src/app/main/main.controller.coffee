angular.module 'ubinWeb'
  .controller 'MainController', (Crud, LoginUser, $state) ->
    'ngInject'
    vm = this
    vm.location = {}

    Crud.country.query({page_size: 100}).$promise.then (result) ->
      vm.countries = result.results
      if LoginUser.getLocation()?
        vm.location = LoginUser.getLocation()

    Crud.typePublication.query({page_size: 100}).$promise.then (result) ->
      vm.publication = result.results

    vm.setLocation = ->
      console.log vm.location.state
      LoginUser.setLocation vm.location
      $state.go 'posts'

    vm.modelSelected = ->
      Crud.stateFilter.query({page_size: 100, country__id: vm.location.country}).$promise.then (result) ->
        vm.states = result.results

    return
