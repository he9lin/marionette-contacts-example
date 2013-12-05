# Manages contact entities
#
window.ContactManager.module "Entities", (Entities, ContactManager, Backbone, Marionette, $, _) ->

  Entities.Contact = Backbone.Model.extend
    urlRoot: "contacts"

    defaults:
      firstName: ""
      lastName: ""
      phoneNumber: ""

    validate: (attrs, options) ->
      errors = {}
      errors.firstName = "can't be blank" unless attrs.firstName
      if attrs.lastName
        errors.lastName = "is too short" if attrs.lastName.length < 2
      else
        errors.lastName = "can't be blank"
      return errors unless _.isEmpty(errors)

  Entities.configureStorage Entities.Contact


  Entities.ContactCollection = Backbone.Collection.extend
    url: "contacts"
    model: Entities.Contact
    comparator: "firstName"

  Entities.configureStorage Entities.ContactCollection

  # Initialize contacts
  #
  initializeContacts = ->
    contacts = new Entities.ContactCollection([
      { id: 1, firstName: "Alice",   lastName: "Arten",    phoneNumber: "555-0184" },
      { id: 2, firstName: "Bob",     lastName: "Brigham",  phoneNumber: "555-0163" },
      { id: 3, firstName: "Charlie", lastName: "Campbell", phoneNumber: "555-0129" }
    ])

    contacts.forEach (contact) ->
      contact.save()

    contacts.models

  API =
    getContactsEntities: ->
      contacts = new Entities.ContactCollection()
      defer = $.Deferred()

      contacts.fetch
        success: (data) -> defer.resolve(data)

      promise = defer.promise()

      $.when(promise).done (contacts) ->
        if contacts.length is 0
          models = initializeContacts()
          contacts.reset(models)

      promise

    getContactsEntity: (contactId) ->
      contact = new Entities.Contact id: contactId
      defer = $.Deferred()
      setTimeout (
        ->
          contact.fetch
            success: (data) -> defer.resolve data
            error: (data) -> defer.resolve undefined
      ), 1000
      defer.promise()

  ContactManager.reqres.setHandler "contact:entities", ->
    API.getContactsEntities()

  ContactManager.reqres.setHandler "contact:entity", (id) ->
    API.getContactsEntity(id)

