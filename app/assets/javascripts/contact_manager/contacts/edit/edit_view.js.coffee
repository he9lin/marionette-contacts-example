window.ContactManager.module "ContactsApp.Edit",
(Edit, ContactManager, Backbone, Marionette, $, _) ->

  Edit.Contact = ContactManager.ContactsApp.Common.Views.Form.extend(
    initialize: ->
      @title = "Edit #{@model.get "firstName"}"
      @title += " #{@model.get "lastName"}"

    onRender: ->
      if @options.generateTitle
        $title = $("<h1>", text: @title)
        @$el.prepend $title

      @$(".x-submit").text("Update contact")
  )
