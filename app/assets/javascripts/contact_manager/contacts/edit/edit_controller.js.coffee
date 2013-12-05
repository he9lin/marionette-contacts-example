window.ContactManager.module "ContactsApp.Edit",
(Edit, ContactManager, Backbone, Marionette, $, _) ->

  Edit.Controller =
    editContact: (id) ->
      loadingView = new ContactManager.Common.Views.Loading()
      ContactManager.mainRegion.show loadingView

      fetchingContact = ContactManager.request("contact:entity", id)
      $.when(fetchingContact).done (contact) ->
        view = undefined
        if contact isnt undefined
          view = new Edit.Contact
            model: contact
            generateTitle: true

          view.on "form:submit", (data) ->
            if contact.save(data)
              ContactManager.trigger "contact:show", contact.get("id")
            else
              view.triggerMethod("form:data:invalid", contact.validationError)
        else
          view = new ContactManager.ContactsApp.Show.MissingContact()

        ContactManager.mainRegion.show view
