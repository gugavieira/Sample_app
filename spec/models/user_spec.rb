require 'spec_helper'

describe User do
	
	before(:each) do
		@attr = { :name => "Example Name", :email => "example@mail.com" }
		
	end
	
	it "should create a new instance given valid attributes" do
		User.create!(@attr)
	end
	
	it "should require a name" do
		user_no_name = User.new(@attr.merge(:name => ""))
		user_no_name.should_not be_valid
	end
	
	it "should require an email" do
		user_no_email = User.new(@attr.merge(:email => ""))
		user_no_email.should_not be_valid
	end
	
	it "should not allow names longer than 50" do
		long_name = "a" * 51
		user_long_name = User.new(@attr.merge(:name => long_name))
		user_long_name.should_not be_valid
	end
	
	it "should accept valid emails" do
		addresses = %w[users@foo.com THE_USER@foo.bar.org first.last@foo.jp]
		addresses.each do |address|
			user_valid_email = User.new(@attr.merge(:email => address))
			user_valid_email.should be_valid
		end
	end
	
	it "should reject invalid emails" do
		addresses = %w[users@foo,com user_at_foo.org example@user.foo.]
		addresses.each do |address|
			user_valid_email = User.new(@attr.merge(:email => address))
			user_valid_email.should_not be_valid
		end
	end
	
	it "should reject duplicated emails" do
		email_upper = @attr[:email].upcase
		User.create!(@attr.merge(:email => email_upper))
		user_with_duplicate_email = User.new(@attr)
		user_with_duplicate_email.should_not be_valid
	end
		
end

# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

