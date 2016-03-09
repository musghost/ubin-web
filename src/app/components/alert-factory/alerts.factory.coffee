angular.module 'ubinWeb'
  .factory 'alerts', ->
    'ngInject'

    alertService =
      alerts: []
      deleteAlerts: false
      add: (type, msg) ->
        @.alerts.push(
          'type': type
          'msg': msg
          )
      get: ->
        @.alerts
      closeAlert: (index) ->
        @.alerts.splice index, 1
      clear: ->
        @.alerts = []