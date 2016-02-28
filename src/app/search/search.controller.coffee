angular.module 'ubinWeb'
  .controller 'SearchController', (Crud) ->
    vm = @
    vm.search = {}
    console.log 'search'
    Crud.typePublication.query().$promise.then (result)->
      console.log result
      result
    return