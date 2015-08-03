class AvailableUsersController < ApplicationController
  include ContextFreeRepos

  before_filter :authenticate_admin!

  expose(:juniors_and_interns) do
    AvailableUserDecorator.decorate_collection(available_users_repository.juniors,
      context: { category: 'juniors-interns' })
  end
  expose(:users_to_rotate) do
    AvailableUserDecorator.decorate_collection(available_users_repository.to_rotate,
      context: { category: 'to-rotate' })
  end
  expose(:users_in_internals) do
    AvailableUserDecorator.decorate_collection(available_users_repository.in_internals,
      context: { category: 'internals' })
  end
  expose(:users_with_rotations_in_progress) do
    AvailableUserDecorator.decorate_collection(
      available_users_repository.with_rotations_in_progress,
      context: { category: 'in-progress' })
  end
  expose(:roles) { roles_repository.all }
  expose(:abilities) { abilities_repository.all }

  def index
    gon.juniors_and_interns = Rabl.render(juniors_and_interns, 'available_users/index',
      view_path: 'app/views', format: :hash, locals: { cache_key: 'juniors_and_interns' })
    gon.users_to_rotate = Rabl.render(users_to_rotate, 'available_users/index',
      view_path: 'app/views', format: :hash, locals: { cache_key: 'to-rotate' })
    gon.users_in_internals = Rabl.render(users_in_internals, 'available_users/index',
      view_path: 'app/views', format: :hash, locals: { cache_key: 'internals' })
    gon.users_with_rotations_in_progress = Rabl.render(users_with_rotations_in_progress,
      'available_users/index', view_path: 'app/views', format: :hash,
      locals: { cache_key: 'in-progress' })
    gon.roles = roles
    gon.abilities = abilities
  end
end
