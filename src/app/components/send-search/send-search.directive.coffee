angular.module 'ubinWeb'
  .directive 'sendSearch', ($state) ->
    restrict: 'A'
    link: (scope, element) ->
      element.on 'submit', (e) ->
        e.preventDefault()
        $state.go 'search', {q: element.find('input')[0].value}