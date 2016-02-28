angular.module 'ubinWeb'
  .factory 'Crud', ($resource, api) ->
    typePublication: $resource "#{api}/typePublication"
    typeProperty: $resource "#{api}/typeProperty"
    publicationsFilter: $resource "#{api}/publicationsFilter"
    