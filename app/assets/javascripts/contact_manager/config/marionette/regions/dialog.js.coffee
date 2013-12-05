Marionette.Region.Dialog = Marionette.Region.extend(
  onShow: (view) ->
    @listenTo view, "dialog:close", @closeDialog

    @$el.dialog
      modal: true
      title: view.title
      width: "auto"
      close: (e, ui) => @closeDialog()

  closeDialog: ->
    @stopListening()
    @close()
    @$el.dialog("destroy")
)

