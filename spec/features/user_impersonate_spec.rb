require 'rails_helper'

describe Account::Admin::AdminController, type: :feature do
  let!(:user) { create(:user, role: 'member') }
  let!(:lead_user) { create(:user, role: 'lead') }
  let!(:admin_user) { create(:user, role: 'admin') }

  it 'visits users page and impersonate user' do
    login_as admin_user
    visit account_admin_users_path
    expect(page).to have_content(admin_user.full_name)
    expect(page).to have_css('.imp', text: 'Impersonate')
    page.first('.imp', text: 'Impersonate').click
    expect(page).to have_css(
      '.impersonated',
      text: "You (#{admin_user.full_name}) are signed in as #{user.full_name}"
    )
    expect(page).to have_css('h1', text: 'Association of co-owners of an apartment building')
    find('.btn-outline-warning', text: 'Back to admin').click
    visit account_admin_stop_impersonate_path
    expect(page).not_to have_css(
      '.impersonated',
      text: "You (#{admin_user.full_name}) are signed in as #{user.full_name}"
    )
    expect(page).to have_css('h1', text: 'All Users')
    expect(page).not_to have_css('.btn-outline-warning', text: 'Back to admin')
  end

  it 'can\'t impersonate users' do
    login_as lead_user
    visit account_admin_users_path
    expect(page).to have_content(lead_user.full_name)
    expect(page).not_to have_css('.imp', text: 'Impersonate')
  end
end
