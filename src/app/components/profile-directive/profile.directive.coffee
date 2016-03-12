angular.module 'ubinWeb'
  .directive 'profile', ($cookies) ->
    {
      restrict: 'E'
      link: (scope) ->
        scope.$on 'login', (e, data) ->
          scope.name = data.user.name
        scope.name = $cookies.get 'name'
      template: """
<div class="profile">
  <div class="image-profile">
    <img src="assets/images/position/profile.png">
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