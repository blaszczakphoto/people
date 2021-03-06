class Hrguru.Models.Project extends Backbone.AssociatedModel

  relations: [
    {
      type: Backbone.Many,
      key: 'notes',
      collectionType: 'Hrguru.Collections.Notes'
    },
    {
      type: Backbone.Many,
      key: 'memberships',
      collectionType: 'Hrguru.Collections.Memberships'
    }
  ]

  defaults:
    memberships: []

  isActive: ->
    !(@isPotential() || @isArchived())

  isPotential: ->
    @get('potential')

  isArchived: ->
    @get('archived')

  isInternal: ->
    @get('internal')

  type: ->
    return 'archived' if @isArchived()
    return 'potential' if @isPotential()
    'active'

  daysToEnd: ->
    return null unless @get('end_at')?
    moment(@get('end_at')).diff(H.currentTime(), 'days')

class Hrguru.Collections.Projects extends Backbone.Collection
  model: Hrguru.Models.Project
  url: Routes.projects_path()
