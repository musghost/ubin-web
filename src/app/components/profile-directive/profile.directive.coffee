angular.module 'ubinWeb'
  .directive 'profile', ($cookies, Crud, base) ->
    {
      restrict: 'E'
      link: (scope) ->
        photoCookie=$cookies.get('photo')
        genderCookie=$cookies.get('gender')
        if photoCookie == ''
          if genderCookie != ''
            if genderCookie=="Mujer"
              scope.photo = "#{base}media/mujer.png"
            else
              scope.photo = "#{base}media/hombre.png"
          else
            scope.photo = "#{base}media/hombre.png"
        else
          scope.photo = "#{base}media/#{photoCookie}"

        scope.name = $cookies.get 'name'
        scope.$on 'login', (e, data) ->
          Crud.user.get({userId: $cookies.get 'id'}).$promise.then (user) ->
            console.log "foto" + user.photo
            console.log "gender" + user.gender
            if user.photo == ''
              if user.gender != ''
                if user.gender=="Mujer"
                  scope.photo = "#{base}media/mujer.png"
                else
                  scope.photo = "#{base}media/hombre.png"
              else
                scope.photo = "#{base}media/hombre.png"
            else
              scope.photo = "#{base}media/#{user.photo}"
            $cookies.put 'name', user.name

            $cookies.put 'gender', user.gender
            $cookies.put 'photo', scope.photo
            $cookies.put 'special', user.allow_past_due_portfolio
            scope.name = user.name
          return
      template: """
<div class="profile">
  <div class="image-profile">
    <div style="background-image:url('{{photo}}');"></div>
  </div>
  <h4>{{name}}</h4>
</div>
"""
    }
  .directive 'showsidebar', ($rootScope) ->
    {
      restrict: 'EA'
      link: (scope, elem) ->
        $rootScope.$on '$stateChangeSuccess', (event, toState) ->
          if toState.name == 'login'
            elem.addClass 'hide'
          else
            elem.removeClass 'hide'
        return
    }
