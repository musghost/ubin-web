angular.module 'ubinWeb'
  .factory 'Fav', (LoginUser, Crud) ->
    'ngInject'
    fav: (event, selectedPost) ->
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