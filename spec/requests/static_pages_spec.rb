require 'rails_helper'

describe "Static pages" do
	describe "Home page" do # RSpecは""で囲まれた文字列を解釈しないので、わかりやすい説明をかく
		it "should have the content 'Sample App'" do	# shold have～と書くことでitと整合性がとれる
			visit '/static_pages/home'
			expect(page).to have_content('Sample App')
		end

		it "should have the right title" do
			visit '/static_pages/home'
			expect(page).to have_title("Ruby on Rails Tutorial Sample App | Home")
			# expect(page).to have_title("Home")でも良い
		end
	end

	describe "Help page" do
		it "should have the content 'Help'" do
			visit '/static_pages/help'
			expect(page).to have_content('Help')
		end

		it "should have the right title" do
			visit '/static_pages/help'
			expect(page).to have_title("Ruby on Rails Tutorial Sample App | Help")
		end
	end

	describe "About page" do
		it "should have the content 'About Us'" do
			visit '/static_pages/about'
			expect(page).to have_content('About Us')
		end

		it "should have the right title" do
			visit '/static_pages/about'
			expect(page).to have_title("Ruby on Rails Tutorial Sample App | About Us")
		end
	end
end
