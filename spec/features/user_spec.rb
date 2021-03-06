require 'capybara/rails'

RSpec.feature "Users", type: :feature do
  context 'create new user' do
    scenario "should be succesful" do
      visit new_user_registration_path
      within('form') do
        fill_in "Email", with: "new_user@gmail.com"
        fill_in "Name", with: "User name"
        fill_in "Password", with: "12345678"
        fill_in "Password confirmation", with: "12345678"
        click_on('Sign up')
      end
      expect(current_path).to eq arrows_path
    end

    scenario "should fail if password is invalid" do
      visit new_user_registration_path
      within('form') do
        fill_in "Email", with: "new_user@gmail.com"
        fill_in "Password", with: "12345"
        fill_in "Password confirmation", with: "12345"
        click_on('Sign up')
      end
      expect(page).to have_content('Password is too short')
    end

    scenario "should fail if email is invalid" do
      visit new_user_registration_path
      within('form') do
        fill_in "Email", with: "new_user@@gmail.com"
        fill_in "Password", with: "123456"
        fill_in "Password confirmation", with: "123456"
        click_on('Sign up')
      end
      expect(page).to have_content('Email is invalid')
    end
  end

  context 'log in' do
    scenario "should be succesful" do
      user = FactoryBot.create(:user)
      visit new_user_session_path
      within('form') do
        fill_in "Email", with: user.email
        fill_in "Password", with: "12345678"
        click_on('Log in')
      end
      expect(current_path).to eq arrows_path
    end

    scenario "should fail" do
      user = FactoryBot.create(:user)
      visit new_user_session_path
      within('form') do
        fill_in "Email", with: user.email
        fill_in "Password", with: "12345679"
        click_on('Log in')
      end
      expect(page).to have_content('Log in')
    end
  end

  context 'edit profile' do
    scenario "should be succesful" do

      user = FactoryBot.create(:user)
      visit new_user_session_path
      within('form') do
        fill_in "Email", with: user.email
        fill_in "Password", with: "12345678"
        click_on('Log in')
      end

      visit edit_user_registration_path
      within('form.edit_user') do
        fill_in "Email", with: user.email
        fill_in "Name", with: 'New name'
        click_on('Update')
      end

      expect(page).to have_content('Your account has been updated successfully.')
    end

    scenario "should fail" do
      user = FactoryBot.create(:user)
      visit new_user_session_path
      within('form') do
        fill_in "Email", with: user.email
        fill_in "Password", with: "12345679"
        click_on('Log in')
      end
      expect(page).to have_content('Log in')
    end
  end
end
