require "spec_helper"

describe "Users page", js: true do
  let(:role) { create(:role) }
  let(:user) { create(:user) }
  let!(:developer) { create(:user) }
  let!(:position) { create(:position, user: developer, role: role, primary: true) }

  before(:each) do
    page.set_rack_session 'warden.user.user.key' => User.serialize_into_session(user).unshift('User')
    visit '/users'
  end

  xit "shows user role" do
    names = developer.primary_roles.pluck(:name).join(', ')
    expect(page).to have_content(names)
  end

  context 'role names' do
    let!(:previous_position) { create(:position, user: developer, primary: false) }

    it 'shows only current role name' do
      expect(page).not_to have_content(previous_position.role.name)
    end
  end

  context 'internal project' do
    let!(:project) { create(:project, :internal) }
    let!(:membership) { create(:membership, project: project, user: developer) }

    xit 'doesnt show nonbillable sign' do
      visit '/users'
      within '.projects-region', match: :first do
        nonbillable_signs = all('.glyphicon.glyphicon-exclamation-sign.notbillable')
        expect(nonbillable_signs.size).to eq 0
      end
    end
  end
end
