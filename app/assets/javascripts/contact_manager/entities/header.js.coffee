window.ContactManager.module "Entities",
(Entities, ContactManager, Backbone, Marionette, $, _) ->

  Entities.Header = Backbone.Model.extend(
    initialize: ->
      selectable = new Backbone.Picky.Selectable(@)
      _.extend @, selectable
  )

  Entities.HeaderCollection = Backbone.Collection.extend(
    model: Entities.Header
    initialize: ->
      singleSelect = new Backbone.Picky.SingleSelect(@)
      _.extend @, singleSelect
  )

  initializeHeaders = ->
    Entities.headers = new Entities.HeaderCollection([
      name: "Contacts"
      url: "contacts"
      navigationTrigger: "contacts:list"
    ,
      name: "About"
      url: "about"
      navigationTrigger: "about:show"
    ])

  API = getHeaders: ->
    initializeHeaders() if Entities.headers is undefined
    Entities.headers

  ContactManager.reqres.setHandler "header:entities", ->
    API.getHeaders()
