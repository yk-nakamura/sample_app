require 'rails_helper'

describe "Static pages", :type => :request do

	subject {page}

	describe "Home page" do # RSpecは""で囲まれた文字列を解釈しないので、わかりやすい説明をかく
		before {visit root_path}
		
		it {is_expected.to have_content('Sample App')}
		it {is_expected.to have_title(full_title(''))}
		it {is_expected.not_to have_title('| Home')}
	end

	describe "Help page" do
		before {visit help_path}
		
		it {is_expected.to have_content('Help')}
		it {is_expected.to have_title(full_title('Help'))}
	end

	describe "About page" do
		before {visit about_path}
		
		it {is_expected.to have_content('About')}
		it {is_expected.to have_title(full_title('About Us'))}
	end
	
	describe "Contact page" do
		before {visit contact_path}
		
		it {is_expected.to have_content('Contact')}
		it {is_expected.to have_title(full_title('Contact'))}
	end
end
