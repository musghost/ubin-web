angular.module 'ubinWeb'
  .directive 'file', ($parse) ->
    fn_link = (scope, element, attrs) ->
      element.bind 'change', (event) ->
        file = event.target.files[0]
        scope.file = file ? file : undefined
        scope.$apply()
    {
      link: fn_link
      scope:
        file: '='
    }
  .controller 'PostsController', ($state, Crud, $http, LoginUser, base, Fav) ->
    'ngInject'
    vm = @
    vm.base = base
    Crud.publicationsFilter.query({page_size: 100, ordering: '-date', state__id: LoginUser.getLocation().state}).$promise.then (result) ->
      vm.posts = result.results
    vm.fav = Fav.fav
    return
  .controller 'FavsController', ($state, Crud, $http, LoginUser, base, Fav) ->
    'ngInject'
    vm = @
    vm.base = base
    Crud
      .favoritesFilter
      .query({page_size: 100, ordering: '-publication__date', user__id: LoginUser.getId(), status: true})
      .$promise.then (result) ->
        vm.posts = result.results.map (current) ->
          current.publication
    vm.fav = Fav.fav
    return
  .controller 'PostController', ($scope, $state, Crud, $http, LoginUser, base, api) ->
    'ngInject'
    vm = @

    vm.base = base

    vm.disabled = false
    vm.showDelete = true

    vm.type = {}

    vm.posts = []

    Crud.typePublication.query({page_size: 100}).$promise.then (result) ->
      vm.type.publication = result.results
    Crud.typeProperty.query({page_size: 100}).$promise.then (result) ->
      vm.type.property = result.results
    Crud.townFilter.query({state__id: LoginUser.getLocation().state, page_size: 100, ordering: 'name'}).$promise.then (result) ->
      vm.minucipalities = result.results
    Crud.currencies.query().$promise.then (result) ->
      vm.currencies = result

    Crud.publicationsFilter.query({user__id: LoginUser.getId()}).$promise.then (result) ->
      vm.posts = result.results

    vm.post =
      file: []

    vm.setNeighborhood = ->
      Crud.neighborhoodFilter.query({town__id: vm.post.town__id, page_size: 1000, ordering: 'name'}).$promise.then (result) ->
        vm.neighborhood = result.results
      return

    vm.savePost = ->
      vm.disabled = true
      formatDate = () ->
        date = new Date()
        date.toISOString()
      formData = new FormData()
      formData.append 'user', LoginUser.getId()
      formData.append 'date', formatDate()
      formData.append 'status', 'true'
      if LoginUser.getLocation()?
        formData.append 'country', LoginUser.getLocation().country
        formData.append 'state', LoginUser.getLocation().state
      angular.forEach vm.post, (value, key) ->
        if key == "photos"
          if value?
            size = 0
            for key, val of value
              formData.append 'photos[]', val
              size += val.size
            console.log size
            if size > 10000000
              window.alert 'El tamaño de las fotos no debe exceder los 10 megabytes'
              return
        if typeof value != 'object'
          formData.append key, value
      $.ajax({
        url: "#{api}/publication/"
        type: 'POST'
        data: formData
        async: false
        headers:
          'Authorization': "JWT #{LoginUser.getToken()}"
        success: () ->
          $state.go 'post', {}, {reload: true}
          vm.disabled = false
        error: (e) ->
          console.log e
          vm.disabled = false
          window.alert 'Hubo un error al guardar la publicación. Inténtelo más tarde.'
        cache: false
        contentType: false
        processData: false
      })
      .success () ->
        console.log 'ok'
        vm.disabled = false
      .error () ->
        console.log 'bad'
        vm.disabled = false
      return

    vm.fav = (event, selectedPost) ->
      event.preventDefault()
      favParams =
        publication: selectedPost.id
        user: LoginUser.getId()

      if selectedPost.isfavorite
        fav = new Crud.unFavorite(favParams)
      else
        fav = new Crud.favorite(favParams)

      fav.$save().then () ->
        selectedPost.isfavorite = !selectedPost.isfavorite

    vm.deletePub = (event, post) ->
      event.preventDefault()
      $http.delete("#{api}/publication/#{post.id}/").then ->
        $state.go $state.current, {}, {reload: true}

    $scope.arrFiles = [0,0,0,0,0]
    $scope.fileNameChanged = (element, i) ->
      if element.files.length > 0
        $scope.arrFiles[i] = 1
      else
        $scope.arrFiles[i] = 0
      return
    return
  .controller 'EditPostController', () ->
    return
