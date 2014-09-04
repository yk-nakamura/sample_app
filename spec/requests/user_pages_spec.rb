require 'rails_helper'

describe "User pages", :type => :request do

	subject {page}

	describe "index" do
		before do 
			sign_in FactoryGirl.create(:user)
			FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
			FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
			visit users_path
		end

		it {is_expected.to have_title('All users')}
		it {is_expected.to have_content('All users')}

		it "should list each user" do
			User.all.each do |user|
				expect(page).to have_selector('li', text: user.name)
			end
		end
	end

	describe "signup" do
		before {visit signup_path}

		let(:submit) {"Create my account"}

		describe "with invalid information" do
			it "should not create a user" do
				expect {click_button submit}.not_to change(User, :count)
			end
		end

		describe "with valid information" do
			before do
				fill_in "Name", with: "Example User"
				fill_in "Email", with: "user@example.com"
				fill_in "Password", with: "foobar"
				fill_in "Confirmation", with: "foobar"
			end
			
			it "should create a user" do
				expect {click_button submit}.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before {click_button submit}
				let(:user) {User.find_by(email: 'user@example.com')}

				it {is_expected.to have_link('Sign out')}
				it {is_expected.to have_title(user.name)}
				it {is_expected.to have_selector('div.alert.alert-success', text: 'Welcome')}
			end
		end
	end

	describe "signup page" do
		before {visit signup_path}

		it {is_expected.to have_content('Sign up')}
		it {is_expected.to have_title(full_title('Sign up'))}
	end

	describe "profile page" do
		let(:user) {FactoryGirl.create(:user)}
		before {visit user_path(user)}

		it {is_expected.to have_content(user.name)}
		it {is_expected.to have_title(user.name)}
	end

	describe "edit" do
		let(:user) {FactoryGirl.create(:user)}
		before do
			sign_in user
			visit edit_user_path(user)
		end

		describe "page" do
			it {is_expected.to have_content("Update your profile")}
			it {is_expected.to have_title("Edit user")}
			it {is_expected.to have_link('change', href: 'http://gravatar.com/emails')}
		end

		describe "with invalid information" do
			before {click_button "Save changes"}

			it {is_expected.to have_content('error')}
		end

		describe "with valid information" do
			let(:new_name) {"New Name"}
			let(:new_email) {"new@example.com"}
			before do
				fill_in "Name", with: new_name
				fill_in "Email", with: new_email
				fill_in "Password", with: user.password
				fill_in "Confirm Password", with: user.password
				click_button "Save changes"
			end

			it {is_expected.to have_title(new_name)}
			it {is_expected.to have_selector('div.alert.alert-success')}
			it {is_expected.to have_link('Sign out', href: signout_path)}
			specify {expect(user.reload.name).to eq new_name}
			specify {expect(user.reload.email).to eq new_email}
		end
	end
end
