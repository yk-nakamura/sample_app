require 'rails_helper'

describe "Static pages" do
	describe "Home page" do # RSpecは""で囲まれた文字列を解釈しないので、わかりやすい説明をかく
		it "should have the content 'Sample App'" do	# shold have～と書くことでitと整合性がとれる
			visit '/static_pages/home'
			expect(page).to have_content('Sample App')
		end
	end

	describe "Help page" do
		it "should have the content 'Help'" do
			visit '/static_pages/help'
			expect(page).to have_content('Help')
		end
	end
end
