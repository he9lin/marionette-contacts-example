#= require jquery
#= require jquery-ui-1.10.3
#= require jquery_ujs
#= require turbolinks

#= require json2
#= require underscore
#= require backbone
#= require backbone.localstorage
#= require backbone.syphon
#= require backbone.picky
#= require backbone.marionette
#= require handlebars.runtime
#= require spin
#= require spin.jquery

#= require_tree ./templates

#= require welcome

Backbone.Marionette.Renderer.render = (template, data) ->
  throw "Template '" + template + "' not found!"  unless JST[template]
  JST[template] data

