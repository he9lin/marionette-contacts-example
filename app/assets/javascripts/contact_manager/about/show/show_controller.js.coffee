window.ContactManager.module "AboutApp.Show",
(Show, ContactManager, Backbone, Marionette, $, _) ->
  Show.Controller =
    showAbout: ->
      view = new Show.Message()
      ContactManager.mainRegion.show view
