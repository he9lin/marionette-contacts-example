window.ContactManager.module "ContactsApp.List",
(List, ContactManager, Backbone, Marionette, $, _) ->

  List.Layout = Marionette.Layout.extend(
    template: "templates/contact_list_layout"

    regions:
      panelRegion: "#panel-region"
      contactsRegion: "#contacts-region"
  )

  List.Panel = Marionette.ItemView.extend(
    template: "templates/contact_list_panel"

    # To trigger an event directly
    triggers:
      "click button.x-new": "contact:new"

    events:
      "submit .x-filter-form": "filterContacts"

    ui:
      criterion: "input.x-filter-criterion"

    filterContacts: (e) ->
      e.preventDefault()
      criterion = @$(".x-filter-criterion").val()
      @trigger "contacts:filter", criterion

    onSetFilterCriterion: (criterion) ->
      @ui.criterion.val criterion
  )

  List.Contact = Marionette.ItemView.extend(
    tagName: "tr"
    template: "templates/contact_list_item"

    events:
      "click": "highlightName"
      "click a.x-show": "showClicked"
      "click a.x-edit": "editClicked"
      "click button.x-delete": "deleteClicked"

    flash: (cssClass) ->
      $view = @$el
      $view.hide().toggleClass(cssClass).fadeIn(800, ->
        setTimeout (->
          $view.toggleClass cssClass
        ), 500
      )

    highlightName: (e) ->
      e.preventDefault()
      @$el.toggleClass("warning")

    showClicked: (e) ->
      e.preventDefault()
      e.stopPropagation()
      @trigger("contact:show", @model)

    editClicked: (e) ->
      e.preventDefault()
      e.stopPropagation()
      @trigger("contact:edit", @model)

    deleteClicked: (e) ->
      e.stopPropagation()
      @trigger("contact:delete", @model)

    # Animate the remove
    remove: ->
      self = @
      @$el.fadeOut ->
        # Like calling super
        Marionette.ItemView.prototype.remove.call(self)
  )

  NoContactsView = Marionette.ItemView.extend(
    template: "templates/contact_list_none"
    tagName: "tr"
    className: "alert alert-warning"
  )

  List.Contacts = Marionette.CompositeView.extend(
    tagName: "table"
    className: "table table-hover"
    template: "templates/contact_list"
    emptyView: NoContactsView
    itemView: List.Contact
    itemViewContainer: "tbody"

    # onItemviewContactDelete callback is called when "contact:delete" event
    # is triggered in List.Contact item view

    initialize: ->
      @listenTo @collection, "reset", ->
        @appendHtml = (collectionView, itemView, index) ->
          collectionView.$el.append itemView.el

    onCompositeCollectionRendered: ->
      @appendHtml = (collectionView, itemView, index) ->
        collectionView.$el.prepend itemView.el
  )
