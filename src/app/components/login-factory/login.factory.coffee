angular.module 'ubinWeb'
  .factory 'LoginUser', ($http, $q, $cookies, api) ->
    'ngInject'
    login: (data) ->
      deferred = $q.defer()
      data.device_os = 'CMS'
      self = @
      res = {}

      $http({
        url: "#{api}/api-token-auth/"
        method: 'POST'
        data: data
      }).then ((response) ->
        if response.data.token?
          $cookies.put 'token', response.data.token
          $cookies.put 'id', response.data.user.id
          $cookies.put 'special', response.data.user.allow_past_due_portfolio
          res.status = true
          deferred.resolve res
        else
          res.status = false
          res.message = 'Hubo un error con el servicio, inténtelo más tarde.'
          deferred.reject res
      ), (response) ->
        if response.data.non_field_errors?
          res.status = false
          res.message = 'El nombre de usuario o contraseña son inválidos.'
          deferred.reject res
        else
          res.status = false
          res.message = 'Hubo un error con el servicio, inténtelo más tarde.'
          deferred.reject res
      deferred.promise
    logout: ->
      $cookies.remove 'token'
      $cookies.remove 'id'
      $cookies.remove 'name'
      $cookies.remove 'photo'
    getToken: ->
      $cookies.get 'token'
    getId: ->
      $cookies.get 'id'
    delete: ->
      $cookies.remove 'id'
      $cookies.remove 'token'
    setLocation: (location) ->
      $cookies.put 'country', location.country
      $cookies.put 'state', location.state
    getLocation: ->
      location =
        country: $cookies.get 'country'
        state: $cookies.get 'state'