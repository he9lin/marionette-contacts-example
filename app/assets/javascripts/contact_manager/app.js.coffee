ContactManager.addRegions
  headerRegion: "#header-region"
  mainRegion: "#main-region"
  dialogRegion: Marionette.Region.Dialog.extend(el: "#dialog-region")

ContactManager.navigate = (route, options) ->
  options ?= {}
  Backbone.history.navigate route, options

ContactManager.getCurrentRoute = ->
  Backbone.history.fragment

# app initialization
ContactManager.on "initialize:after", () ->
  if Backbone.history
    Backbone.history.start()

    if @getCurrentRoute() is ""
      # You can achieve the same result by putting
      # Backbone.history.navigate("contacts", {trigger: true}); You will
      # sometimes see this done in various places on the web, but it encourages
      # bad app design and it is strongly recommended you don’t pass
      # trigger:true to Backbone.history.navigate.
      ContactManager.trigger("contacts:list")
