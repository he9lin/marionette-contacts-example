window.ContactManager.module "ContactsApp.Common.Views",
(Views, ContactManager, Backbone, Marionette, $, _) ->

  Views.Form = Marionette.ItemView.extend(
    template: "templates/contact_form"

    events:
      "click button.x-submit": "submitClicked"

    submitClicked: (e) ->
      e.preventDefault()
      data = Backbone.Syphon.serialize(@)
      @trigger "form:submit", data

    onFormDataInvalid: (errors) ->
      $view = @$el

      clearFormErrors = ->
        $form = $view.find("form")
        $form.find(".help-inline.text-danger").each ->
          $(this).remove()

        $form.find(".form-group.has-error").each ->
          $(this).removeClass "error"

      markErrors = (value, key) ->
        $controlGroup = $view.find("#contact-" + key).parent()
        $errorEl = $("<span>",
          class: "help-inline text-danger"
          text: value
        )
        $controlGroup.append($errorEl).addClass "has-error"

      clearFormErrors()
      _.each errors, markErrors
  )
