angular.module 'ubinWeb'
  .factory 'Crud', ($resource, api) ->
    typePublication: $resource "#{api}/typePublication/", {}, {query: {method: 'GET', isArray: false}}
    typeProperty: $resource "#{api}/typeProperty/", {}, {query: {method: 'GET', isArray: false}}
    municipality: $resource "#{api}/town/", {}, {query: {method: 'GET', isArray: false}}
    state: $resource "#{api}/state/", {}, {query: {method: 'GET', isArray: false}}
    country: $resource "#{api}/country/", {}, {query: {method: 'GET', isArray: false}}
    neighborhood: $resource "#{api}/neighborhood/", {}, {query: {method: 'GET', isArray: false}}
    publicationsFilter: $resource "#{api}/publicationsFilter/", {}, {query: {method: 'GET', isArray: false}}
    townFilter: $resource "#{api}/townFilter/", {}, {query: {method: 'GET', isArray: false}}
    neighborhoodFilter: $resource "#{api}/neighborhoodFilter/", {}, {query: {method: 'GET', isArray: false}}
    currencies: $resource "#{api}/currencies/"