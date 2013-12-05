ContactManager.module "ContactsApp.New",
(New, ContactManager, Backbone, Marionette, $, _) ->
  New.Contact = ContactManager.ContactsApp.Common.Views.Form.extend
    title: "New Contact"

    onRender: ->
      @$(".x-submit").text("Create contact")
