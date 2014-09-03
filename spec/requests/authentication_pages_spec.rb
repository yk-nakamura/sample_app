require 'rails_helper'

describe "Authentication", :type => :request do

	subject {page}

	describe "signin page" do
		before {visit signin_path}

		it {is_expected.to have_content('Sign in')}
		it {is_expected.to have_title('Sign in')}
	end

	describe "signin" do
		before {visit signin_path}
		
		describe "with invalid information" do
			before {click_button "Sign in"}

			it {is_expected.to have_title('Sign in')}
			it {is_expected.to have_error_message('Invalid')}
			# it {should have_selector('div.alert.alert-error', text: 'Invalid')}

			describe "after visiting another page" do
				before {click_link "Home"}
				it {is_expected.not_to have_error_message}
				# it {should_not have_selector('div.alert.alert-error')}
			end
		end

		describe "with valid information" do
			let(:user) {FactoryGirl.create(:user)}
			before do
				valid_signin(user)
			end

			it {is_expected.to have_title(user.name)}
			it {is_expected.to have_link('Profile', href: user_path(user))}
			it {is_expected.to have_link('Settings', href: edit_user_path(user))}
			it {is_expected.to have_link('Sign out', href: signout_path)}
			it {is_expected.not_to have_link('Sign in', href: signin_path)}

			describe "followed by signout" do
				before {click_link "Sign out"}
				it {is_expected.to have_link('Sign in')}
			end
		end
	end

	describe "authorization" do
		describe "for non-signed-in users" do
			let(:user) {FactoryGirl.create(:user)}

			describe "in the Users controller" do
				describe "visiting the edit page" do
					before {visit edit_user_path(user)}
					it {is_expected.to have_title('Sign in')}
				end

				describe "submitting to the update action" do
					before {patch user_path(user)}
					specify {expect(response).to redirect_to(signin_path)}
				end
			end
		end
	end

end
