class UserMembershipsRepository
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def all
    clear_search
    items
  end

  def build(attrs)
    Membership.new({ user: user }.merge(attrs))
  end

  def create(attrs)
    build(attrs).save
  end

  %w(potential archived booked with_end_date).each do |m|
    define_method m do
      search(m.to_sym => true)
    end
    define_method ['not', m].join('_') do
      search(m.to_sym => false)
    end
  end

  def without_end_date
    not_with_end_date
  end

  def not_ended
    search(ends_later_than: Date.today)
  end

  def started
    search(starts_earlier_than: Date.today)
  end

  def not_started
    search(starts_later_than: Date.today)
  end

  def not_ended_project
    search(project_end_time: Date.today)
  end

  def current
    not_potential.not_archived.not_booked.started.not_ended
  end

  def currently_booked
    search(ends_later_than: Date.today).booked
  end

  def items
    # CHECKQUERY: this could also be problematic, projects are loaded here as well
    search = MembershipSearch.new(search_params)
    clear_search
    search.results
  end

  def next
    not_started.not_ended.not_potential.not_booked
  end

  def all_grouped_by_slug
    all.group_by { |m| m.project.api_slug }
  end

  private

  def search(params)
    @search_params = search_params.merge(params)
    self
  end

  def search_params
    @search_params ||= { user: user }
  end

  def clear_search
    @search_params = nil
  end
end
