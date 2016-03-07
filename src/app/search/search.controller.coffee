angular.module 'ubinWeb'
  .controller 'SearchController', (Crud, LoginUser) ->
    vm = @
    vm.search = {}
    vm.type = {}

    Crud.typePublication.query().$promise.then (result) ->
      vm.type.publication = result.results
    Crud.typeProperty.query().$promise.then (result) ->
      vm.type.property = result.results
    Crud.townFilter.query({state__id: LoginUser.getLocation().state, page_size: 1000}).$promise.then (result) ->
      vm.minucipalities = result.results.reverse()

    vm.setNeighborhood = () ->
      Crud.neighborhoodFilter.query({town__id: vm.search.town__id, page_size: 1000}).$promise.then (result) ->
        vm.neighborhood = result.results.sort (a, b) ->
          if a.name < b.name
            return -1
          if a.firstname > b.firstname
            return 1
          0
      return

    vm.performSearch = () ->
      Crud.publicationsFilter.query(vm.search).$promise.then (result) ->
        console.log result
      return
    return