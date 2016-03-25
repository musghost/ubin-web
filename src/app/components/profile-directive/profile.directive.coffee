angular.module 'ubinWeb'
  .directive 'profile', ($cookies, Crud, base) ->
    {
      restrict: 'E'
      link: (scope) ->
        scope.photo = $cookies.get('photo')
        scope.name = $cookies.get 'name'
        scope.$on 'login', (e, data) ->
          Crud.user.get({userId: $cookies.get 'id'}).$promise.then (user) ->
            if user.photo != ''
              scope.photo = "#{base}media/#{user.photo}"
            else
              scope.photo = 'assets/images/position/profile.png'
            $cookies.put 'name', user.name
            $cookies.put 'photo', scope.photo
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