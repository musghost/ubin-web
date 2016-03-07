angular.module 'ubinWeb'
  .controller 'SingleController', ($state, Crud, $stateParams, base, LoginUser) ->
    'ngInject'
    vm = this
    vm.base = base
    vm.comments = []
    vm.comment =
      date: new Date()
      user: LoginUser.getId()
    
    Crud.publicationsFilter.query({id: $stateParams.id}).$promise.then (response) ->
      vm.post = response.results[0]
      vm.comment.publication = response.results[0].id

    Crud.commentsFilter.query({publication__id: $stateParams.id}).$promise.then (response) ->
      vm.comments = response.results

    vm.pushComment = ->
      comment = new Crud.comment(vm.comment)
      comment.$save().then () ->
        Crud.commentsFilter.query({publication__id: $stateParams.id}).$promise.then (response) ->
          vm.comments = response.results
          vm.comment.comment = ''
    return
