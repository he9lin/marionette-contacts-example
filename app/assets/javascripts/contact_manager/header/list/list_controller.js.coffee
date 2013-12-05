window.ContactManager.module "HeaderApp.List",
(List, ContactManager, Backbone, Marionette, $, _) ->

  List.Controller =
    listHeader: ->
      links = ContactManager.request("header:entities")
      headers = new List.Headers(collection: links)

      headers.on "brand:clicked", ->
        ContactManager.trigger "contacts:list"

      headers.on "itemview:navigate", (childView, model) ->
        trigger = model.get("navigationTrigger")
        ContactManager.trigger trigger

      ContactManager.headerRegion.show headers

    setActiveHeader: (headerUrl) ->
      links = ContactManager.request("header:entities")
      headerToSelect = links.find((header) ->
        header.get("url") is headerUrl
      )
      headerToSelect.select()
      links.trigger "reset"

