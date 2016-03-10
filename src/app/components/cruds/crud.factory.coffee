angular.module 'ubinWeb'
  .factory 'Crud', ($resource, api) ->
    typePublication: $resource "#{api}/typePublication/", {}, {query: {method: 'GET', isArray: false}}
    typeProperty: $resource "#{api}/typeProperty/", {}, {query: {method: 'GET', isArray: false}}
    typesAdvisors: $resource "#{api}/typesAdvisors/", {}, {query: {method: 'GET', isArray: false}}
    municipality: $resource "#{api}/town/", {}, {query: {method: 'GET', isArray: false}}
    state: $resource "#{api}/state/", {}, {query: {method: 'GET', isArray: false}}
    country: $resource "#{api}/country/", {}, {query: {method: 'GET', isArray: false}}
    neighborhood: $resource "#{api}/neighborhood/", {}, {query: {method: 'GET', isArray: false}}
    publicationsFilter: $resource "#{api}/publicationsFilter/", {}, {query: {method: 'GET', isArray: false}}
    townFilter: $resource "#{api}/townFilter/", {}, {query: {method: 'GET', isArray: false}}
    neighborhoodFilter: $resource "#{api}/neighborhoodFilter/", {}, {query: {method: 'GET', isArray: false}}
    currencies: $resource "#{api}/currencies/"
    stateFilter: $resource "#{api}/stateFilter/", {}, {query: {method: 'GET', isArray: false}}
    favorite: $resource "#{api}/favorite/", {}, {query: {method: 'GET', isArray: false}}
    unFavorite: $resource "#{api}/unfavorite/", {}, {query: {method: 'GET', isArray: false}}
    comment: $resource "#{api}/comment/", {}, {query: {method: 'GET', isArray: false}}
    commentsFilter: $resource "#{api}/commentsFilter/", {}, {query: {method: 'GET', isArray: false}}
    favoritesFilter: $resource "#{api}/favoritesFilter/", {}, {query: {method: 'GET', isArray: false}}
    notificationsFilter: $resource "#{api}/notificationsFilter/", {}, {query: {method: 'GET', isArray: false}}
    myUser: $resource "#{api}/users/:userId/", {userId: '@id'}, {query: {method: 'GET', isArray: false}}
    user: $resource "#{api}/user/:userId/", {userId: '@id'}, {query: {method: 'GET', isArray: false}, update: {method: 'PATCH'}}