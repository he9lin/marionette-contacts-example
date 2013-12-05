window.ContactManager.module "ContactsApp",
(ContactsApp, ContactManager, Backbone, Marionette, $, _) ->

  ContactsApp.Router = Marionette.AppRouter.extend
    appRoutes:
      "contacts(/filter/criterion::criterion)": "listContacts"
      "contacts/:id": "showContact"
      "contacts/:id/edit": "editContact"

  API =
    listContacts: (criterion) ->
      ContactsApp.List.Controller.listContacts(criterion)
      ContactManager.execute "set:active:header", "contacts"

    showContact: (id) ->
      ContactsApp.Show.Controller.showContact(id)
      ContactManager.execute "set:active:header", "contacts"

    editContact: (id) ->
      ContactsApp.Edit.Controller.editContact(id)
      ContactManager.execute "set:active:header", "contacts"

  ContactManager.on "contacts:list", ->
    ContactManager.navigate("contacts")
    API.listContacts()

  ContactManager.on "contact:show", (id) ->
    ContactManager.navigate("contacts/#{id}")
    API.showContact(id)

  ContactManager.on "contact:edit", (id) ->
    ContactManager.navigate("contacts/#{id}/edit")
    API.editContact(id)

  ContactManager.on "contacts:filter", (criterion) ->
    if criterion
      ContactManager.navigate("contacts/filter/criterion:#{criterion}")
    else
      ContactManager.navigate("contacts")

  # The difference between listening for the "initialize:after" event and calling
  # the addInitializer method (as discussed above) has important implications for
  # our application: we can only start Backbone's routing (via the history
  # attribute) once all initializers have been run, to ensure the routing
  # controllers are ready to respond to routing events. Otherwise (if we simply
  # used addInitializer), Backbone's routing would be started, triggering routing
  # events according to the URL fragments, but these routing events wouldn't be
  # acted on by the application because the routing controllers haven't been
  # defined yet!
  ContactManager.addInitializer ->
    new ContactsApp.Router(controller: API)
