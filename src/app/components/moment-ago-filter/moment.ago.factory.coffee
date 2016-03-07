angular.module 'ubinWeb'
  .filter 'Ago', () ->
    (date) ->
      moment(date).fromNow()