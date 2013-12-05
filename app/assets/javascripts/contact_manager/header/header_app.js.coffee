window.ContactManager.module "HeaderApp",
(Header, ContactManager, Backbone, Marionette, $, _) ->

  API =
    listHeader: ->
      Header.List.Controller.listHeader()

  ContactManager.commands.setHandler "set:active:header", (name) ->
    ContactManager.HeaderApp.List.Controller.setActiveHeader name

  Header.on "start", ->
    API.listHeader()
