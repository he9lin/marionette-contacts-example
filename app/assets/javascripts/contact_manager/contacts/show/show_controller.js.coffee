window.ContactManager.module "ContactsApp.Show", (Show, ContactManager, Backbone, Marionette, $, _) ->
  Show.Controller =
    showContact: (id) ->
      loadingView = new ContactManager.Common.Views.Loading()
      ContactManager.mainRegion.show(loadingView)

      fetchingContact = ContactManager.request("contact:entity", id)
      $.when(fetchingContact).done (contact) ->
        contactView = if contact isnt undefined
          view = new Show.Contact model: contact
          view.on "contact:edit", (contact) ->
            ContactManager.trigger "contact:edit", contact.get("id")
          view
        else
          new Show.MissingContact()
        ContactManager.mainRegion.show contactView
