angular.module 'ubinWeb'
  .directive 'file', ($parse) ->
    fn_link = (scope, element, attrs) ->
      element.bind 'change', (event) ->
        file = event.target.files[0]
        scope.file = file ? file : undefined
        scope.$apply()
        console.log 'apply'
    {
      link: fn_link
      scope:
        file: '='
    }
  .controller 'PostController', ($state, Crud, $http, LoginUser) ->
    'ngInject'
    vm = this

    vm.type = {}

    vm.posts = []

    Crud.typePublication.query().$promise.then (result) ->
      vm.type.publication = result.results
    Crud.typeProperty.query().$promise.then (result) ->
      vm.type.property = result.results
    Crud.townFilter.query({state__id: 9, page_size: 1000}).$promise.then (result) ->
      vm.minucipalities = result.results.reverse()
    Crud.currencies.query().$promise.then (result) ->
      vm.currencies = result

    Crud.publicationsFilter.query({user__id: LoginUser.getId()}).$promise.then (result) ->
      vm.posts = result.results
    
    vm.post =
      file: []

    vm.setNeighborhood = ->
      Crud.neighborhoodFilter.query({town__id: vm.post.town__id, page_size: 1000}).$promise.then (result) ->
        vm.neighborhood = result.results.sort (a, b) ->
          if a.name < b.name
            return -1
          if a.firstname > b.firstname
            return 1
          0
      return

    vm.savePost = ->
      formatDate = () ->
        date = new Date()
        yyyy = date.getFullYear().toString()
        mm = (date.getMonth()+1).toString()
        month = if mm[1] then mm else '0' + mm[0]
        dd  = date.getDate().toString()
        day = if dd[1] then dd else '0' + dd[0]
        hour = date.getHours().toString()
        hour = if hour[1] then hour else '0' + hour[0]
        minutes = date.getMinutes().toString()
        day = if minutes[1] then minutes else '0' + minutes[0]
        "#{yyyy}-#{month}-#{day} #{hour}:#{minutes}"
      formData = new FormData()
      formData.append 'user', LoginUser.getId()
      formData.append 'date', formatDate()
      formData.append 'status', 'true'
      angular.forEach vm.post, (value, key) ->
        if typeof value != 'object'
          formData.append key, value
        else
          formData.append 'photos[]', value[0]
      $.ajax({
        url: "http://45.55.170.108/api/v1/publication/"
        type: 'POST'
        data: formData
        async: false
        success: () ->
          $state.go 'post'
        error: () ->
          console.log 'kjdfjfjfjj'
        cache: false
        contentType: false
        processData: false
      })
      .success () ->
        console.log 'ok'
      .error () ->
        console.log 'bad'
      return

    return
