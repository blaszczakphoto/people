class Hrguru.Views.AvailableUsersFilters extends Marionette.View
  el: '#filters'

  initialize: (@availability_time, @abilities) ->
    @initializeVariables()

  initializeVariables: ->
    @selectize =
      availability_time: []
      abilities: []

  render: ->
    @initializeAvailabilityTimeFilter()
    @initializeAbilitiesFilter()

  initializeAvailabilityTimeFilter: ->
    availability_time_selectize = @$('select[name=availability_time]').selectize
      create: false
      valueField: 'value'
      sortField: 'value'
      labelField: 'text'
      options: @availability_time
    availability_time_selectize.change @, @updateSelectizeAvailability
    @selectize.availability_time = availability_time_selectize[0].selectize.items[0]

  initializeAbilitiesFilter: ->
    abilities_selectize = @$('input[name=abilities]').selectize
      plugins: ['remove_button']
      valueField: '_id'
      labelField: 'name'
      searchField: 'name'
      sortField: 'name'
      options: @abilities
      onItemAdd: @filterUsers
      onItemRemove: @filterUsers
    @selectize.abilities = abilities_selectize[0].selectize.items

  updateSelectizeAvailability: (e) =>
    @selectize.availability_time = $(e.target).first().val()
    @filterUsers()

  filterUsers: =>
    EventAggregator.trigger('users:updateVisibility', @selectize)
    H.addUserIndex()
