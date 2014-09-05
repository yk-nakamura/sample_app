require 'rails_helper'

describe User, :type => :model do

	before do
		@user = User.new(name: "Eample User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
	end

	subject {@user}

	it {is_expected.to respond_to(:name)}
	it {is_expected.to respond_to(:email)}
	it {is_expected.to respond_to(:password_digest)}
	it {is_expected.to respond_to(:password)}
	it {is_expected.to respond_to(:password_confirmation)}
	it {is_expected.to respond_to(:authenticate)}
	it {is_expected.to respond_to(:remember_token)}
	it {is_expected.to respond_to(:admin)}
	it {is_expected.to respond_to(:microposts)}

	it {is_expected.to be_valid}
	it {is_expected.not_to be_admin}

	describe "when name is not present" do
		before {@user.name = "\s"}
		it {is_expected.not_to be_valid}
	end

	describe "when email is not present" do
		before {@user.email = "\s"}
		it {is_expected.not_to be_valid}
	end

	describe "when name is too lang" do
		before {@user.name = "a" * 51}
		it {is_expected.not_to be_valid}
	end

	describe "when email format is invalid" do
		it "should be invalid" do
			address = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
			address.each do |invalid_address|
				@user.email = invalid_address
				expect(@user).not_to be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			address = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			address.each do |valid_address|
				@user.email = valid_address
				expect(@user).to be_valid
			end
		end
	end	

	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it {is_expected.not_to be_valid}
	end

	describe "when password is not present" do
		before do
			@user = User.new(name: "Example User", email: "user@example.com", password: "\s", password_confirmation: "\s")
		end

		it {is_expected.not_to be_valid}
	end

	describe "when password doesn't match confirmation" do
		before {@user.password_confirmation = "mismatch"}
		it {is_expected.not_to be_valid}
	end

	describe "with a password that's too short" do
		before {@user.password = @user.password_confirmation = "a" * 5}
		it {is_expected.to be_invalid}
	end

	describe "return value of authenticate method" do
		before {@user.save}
		let(:found_user) {User.find_by(email: @user.email)}

		describe "with valid password" do
			it {is_expected.to eq found_user.authenticate(@user.password)}
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) {found_user.authenticate("invalid")}

			it {is_expected.not_to eq user_for_invalid_password}
			specify {expect(user_for_invalid_password).to be_falsey}
		end
	end

	describe "remember token" do
		before {@user.save}
		its(:remember_token) {should_not be_blank}
	end

	describe "micropost associations" do
		before {@user.save}
		let!(:older_micropost) do
			FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
		end
		let!(:newer_micropost) do
			FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
		end

		it "should have the right microposts in the right order" do
			expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
		end

		it "should destroy associated microposts" do
			microposts = @user.microposts.to_a
			@user.destroy
			expect(microposts).not_to be_empty
			microposts.each do |micropost|
				expect(Micropost.where(id: micropost.id)).to be_empty
			end
		end
	end
end
