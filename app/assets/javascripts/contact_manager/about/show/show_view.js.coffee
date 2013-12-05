window.ContactManager.module "AboutApp.Show",
(Show, ContactManager, Backbone, Marionette, $, _) ->
  Show.Message = Marionette.ItemView.extend
    template: "templates/about_message"
