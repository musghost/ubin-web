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
  .controller 'PostController', ($scope, $state, Crud, $http, LoginUser, base, api, toastr, $cookies, inmuebles) ->
    'ngInject'
    vm = @

    vm.inmuebles = inmuebles

    vm.base = base

    vm.disabled = false
    vm.showDelete = true

    vm.type = {}
    vm.bath = (num for num in [1..20] by 0.5)
    vm.posts = []

    vm.special = false
    vm.special = true if $cookies.get('special') == 'true'

    vm.location = LoginUser.getLocation()
    vm.state = LoginUser.getLocation().state?

    Crud.typePublication.query({page_size: 100}).$promise.then (result) ->
      vm.type.publication = result.results
    Crud.typeProperty.query({page_size: 100}).$promise.then (result) ->
      vm.type.property = result.results
    Crud.townFilter.query({state__id: LoginUser.getLocation().state, page_size: 100, ordering: 'name'}).$promise.then (result) ->
      vm.minucipalities = result.results
    Crud.currencies.query().$promise.then (result) ->
      vm.currencies = result
    Crud.pastDue.query({page_size: 100}).$promise.then (result) ->
      vm.type.past = result.results
    Crud.legalStatus.query({page_size: 100}).$promise.then (result) ->
      vm.type.legal = result.results

    Crud.publicationsFilter.query({page_size: 100, user__id: LoginUser.getId()}).$promise.then (result) ->
      vm.posts = result.results

    vm.post =
      file: []

    vm.setNeighborhood = ->
      Crud.neighborhoodFilter.query({town__id: vm.post.town, page_size: 1000, ordering: 'name'}).$promise.then (result) ->
        vm.neighborhood = result.results
      return

    vm.setRequired = (type, publication) ->
      if publication
        for prop in vm.type.publication
          if prop.id == type
            vm.type_property = prop.name.toUpperCase()
      else
        for prop in vm.type.property
          if prop.id == type
            vm.type_property = prop.name.toUpperCase()

    vm.savePost = ->
      vm.disabled = true
      formatDate = () ->
        date = new Date()
        date.toISOString()
      formData = new FormData()
      formData.append 'user', LoginUser.getId()
      formData.append 'date', formatDate()
      formData.append 'status', 'true'
      if vm.special
        formData.append 'mortgage', 1
      if LoginUser.getLocation()?
        formData.append 'country', LoginUser.getLocation().country
        formData.append 'state', LoginUser.getLocation().state
      angular.forEach vm.post, (value, key) ->
        if key == "photos"
          if value?
            num = 0
            for key, val of value
              formData.append "#{num}", val
              num++
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
          toastr.success 'Se ha guardado la publicación con éxito'
          $state.go 'post', {}, {reload: true}
          vm.disabled = false
        error: (e) ->
          if e.responseJSON?
            if e.responseJSON.area?
              toastr.error 'El campo Metros (terreno) es requerido'
            if e.responseJSON.construction_area?
              toastr.error 'El campo Metros (construcción) es requerido'
            if e.responseJSON.country?
              toastr.error 'El campo País es requerido'
            if e.responseJSON.currency?
              toastr.error 'Debe elegir un tipo de moneda'
            if e.responseJSON.description?
              toastr.error 'El campo Descripción es requerido'
            if e.responseJSON.price_first?
              toastr.error 'El campo Precio es requerido'
            if e.responseJSON.state?
              toastr.error 'El campo Estado es requerido'
            if e.responseJSON.title?
              toastr.error 'El campo Título es requerido'
          vm.disabled = false
          toastr.error 'Hubo un error al guardar la publicación.'
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
  .controller 'EditPostController', ($stateParams, Crud, LoginUser, api, $state) ->
    'ngInject'
    vm = @
    vm.type = {}

    vm.bath = (num for num in [1..20] by 0.5)

    Crud.typePublication.query({page_size: 100}).$promise.then (result) ->
      vm.type.publication = result.results
    Crud.typeProperty.query({page_size: 100}).$promise.then (result) ->
      vm.type.property = result.results
    Crud.currencies.query().$promise.then (result) ->
      vm.currencies = result
    Crud.publicationsFilter.query({id: $stateParams.id}).$promise.then (post) ->
      vm.post = post.results[0]
      vm.post.currency = vm.post.currency.id

      ###vm.post.town = vm.post.town.id
      vm.post.state = vm.post.state.id
      vm.post.neighborhood = vm.post.neighborhood.id###

      Crud.townFilter.query({state__id: vm.post.state.id, page_size: 100, ordering: 'name'}).$promise.then (result) ->
        vm.minucipalities = result.results.map (town) -> {id: town.id, name: town.name}

      Crud.neighborhoodFilter.query({town__id: vm.post.town.id, page_size: 1000, ordering: 'name'}).$promise.then (result) ->
        vm.neighborhood = result.results

    vm.setNeighborhood = ->
      Crud.neighborhoodFilter.query({town__id: vm.post.town.id, page_size: 1000, ordering: 'name'}).$promise.then (result) ->
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

      post = {}
      angular.copy vm.post, post

      delete post.user
      delete post.country
      delete post.state
      post.type_publications = post.type_publications.id
      post.type_property = post.type_property.id
      post.town = post.town.id
      post.neighborhood = post.neighborhood.id

      angular.forEach post, (value, key) ->
        if key == "photos"
          if value?
            num = 0
            for key, val of value
              formData.append "photo_#{num}", val
              num++
        if typeof value != 'object'
          formData.append key, value
      $.ajax({
        url: "#{api}/publication/#{post.id}/"
        type: 'PATCH'
        data: formData
        async: false
        headers:
          'Authorization': "JWT #{LoginUser.getToken()}"
        success: () ->
          $state.go 'posts', {}, {reload: true}
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
    return
