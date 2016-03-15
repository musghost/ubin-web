angular.module 'ubinWeb'
  .directive 'profile', ($cookies, Crud) ->
    {
      restrict: 'E'
      link: (scope) ->
        Crud.user.get({userId: $cookies.get 'id'}).$promise.then (user) ->
          if user.photo?
            scope.photo = user.photo
          else
            scope.photo = 'assets/images/position/profile.png'

        scope.$on 'login', (e, data) ->
          scope.name = data.user.name
        scope.name = $cookies.get 'name'
      template: """
<div class="profile">
  <div class="image-profile">
    <img ng-src="{{photo}}">
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