window.ContactManager.module "ContactsApp.List",
(List, ContactManager, Backbone, Marionette, $, _) ->

  List.Controller =

    listContacts: (criterion) ->
      # Display loading spin
      loadingView = new ContactManager.Common.Views.Loading()
      ContactManager.mainRegion.show(loadingView)

      contactsListLayout = new List.Layout()
      contactsListPanel = new List.Panel()

      fetchingContacts = ContactManager.request("contact:entities")

      $.when(fetchingContacts).done (contacts) ->

        filteredContacts = ContactManager.Entities.FilteredCollection(
          collection: contacts
          filterFunction: (filterCriterion) ->
            criterion = filterCriterion.toLowerCase()
            (contact) ->
              criterionRegx = new RegExp(criterion, "i")
              matched = _.some(["firstName", "lastName", "phoneNumber"], (field) ->
                criterionRegx.test(contact.get(field))
              )
              return contact if matched
        )

        if criterion
          filteredContacts.filter(criterion)
          contactsListPanel.once("show", ->
            contactsListPanel.triggerMethod "set:filter:criterion", criterion
          )

        contactsListView = new List.Contacts(collection: filteredContacts)

        contactsListLayout.on("show", ->
          contactsListLayout.panelRegion.show(contactsListPanel)
          contactsListLayout.contactsRegion.show(contactsListView)
        )

        contactsListPanel.on("contacts:filter", (filterCriterion) ->
          filteredContacts.filter filterCriterion
          ContactManager.trigger "contacts:filter", filterCriterion
        )

        contactsListPanel.on("contact:new", ->
          newContact = new ContactManager.Entities.Contact()
          view = new ContactManager.ContactsApp.New.Contact(
            model: newContact
          )

          view.on("form:submit", (data) ->
            highestId = contacts.max((c) -> c.id).get("id")
            data.id = highestId + 1
            if newContact.save(data)
              contacts.add newContact
              view.trigger "dialog:close"
              newContactView = contactsListView.children.findByModel(newContact)
              newContactView?.flash("success")
            else
              view.triggerMethod "form:data:invalid", newContact.validationError
          )

          ContactManager.dialogRegion.show view
        )

        # When an item view within a collection view triggers an event, that event
        # will bubble up through the parent collection view with "itemview:"
        # prepended to the event name.
        contactsListView.on "itemview:contact:delete", (childView, model) ->
          model.destroy()

        contactsListView.on "itemview:contact:show", (childView, model) ->
          ContactManager.trigger("contact:show", model.get("id"))

        contactsListView.on("itemview:contact:edit", (childView, model) ->
          view = new ContactManager.ContactsApp.Edit.Contact(
            model: model
          )

          view.on("form:submit", (data) ->
            if model.save(data)
              childView.render()
              view.trigger "dialog:close"
              childView.flash "success"
            else
              view.triggerMethod("form:data:invalid", model.validationError)
          )

          ContactManager.dialogRegion.show view
        )

        ContactManager.mainRegion.show contactsListLayout
