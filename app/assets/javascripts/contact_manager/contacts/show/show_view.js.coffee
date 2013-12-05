window.ContactManager.module "ContactsApp.Show",
(Show, ContactManager, Backbone, Marionette, $, _) ->

  Show.MissingContact = Marionette.ItemView.extend
    template: "templates/missing_contact"

  Show.Contact = Marionette.ItemView.extend
    template: "templates/contact"

    events:
      "click a.x-edit": "editClicked"

    editClicked: (e) ->
      e.preventDefault()
      @trigger "contact:edit", @model
