window.ContactManager.module "HeaderApp.List",
(List, ContactManager, Backbone, Marionette, $, _) ->

  List.Header = Marionette.ItemView.extend(
    template: "templates/header_link"
    tagName: "li"
    events:
      "click a": "navigate"

    navigate: (e) ->
      e.preventDefault()
      @trigger "navigate", @model

    onRender: ->
      # Add class so Bootstrap will highlight the active entry in the navbar
      @$el.addClass "active" if @model.selected
  )

  List.Headers = Marionette.CompositeView.extend(
    template: "templates/header"
    tagName: "nav"
    className: "navbar navbar-inverse navbar-fixed-top"
    itemView: List.Header
    itemViewContainer: "ul"
    events:
      "click a.x-brand": "brandClicked"

    brandClicked: (e) ->
      e.preventDefault()
      @trigger "brand:clicked"
  )
