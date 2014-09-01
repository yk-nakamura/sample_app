require 'rails_helper'

describe User do

	before {@user = User.new(name: "Eample User", email: "user@example.com")}

	subject {@user}

	it {should respond_to(:name)}
	it {should respond_to(:email)}

	it {should be_valid}

	describe "when name is not present" do
		before {@user.name = "\s"}
		it {should_not be_valid}
	end

	describe "when email is not present" do
		before {@user.email = "\s"}
		it {should_not be_valid}
	end
end
