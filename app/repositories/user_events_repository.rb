class UserEventsRepository
  attr_accessor :user_memberships_repository

  def initialize(user_memberships_repository)
    self.user_memberships_repository = user_memberships_repository
  end

  def all
    @events ||= user_memberships_repository.all.map { |m| build_event(m) }.compact
  end

  private

  def build_event(membership)
    return if membership.project.nil?
    event = { text: membership.project.name, startDate: membership.starts_at.to_date }
    event[:endDate] = membership.ends_at.to_date if membership.ends_at.present?
    event[:user_id] = membership.user.id.to_s
    event[:billable] = membership.billable
    event[:project_potential] = membership.project_potential
    event[:id] = membership.project.id.to_s
    event
  end
end
