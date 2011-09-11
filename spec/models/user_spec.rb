require 'spec_helper'

describe User do
	
	before(:each) do
		@attr = {
			:name => "Gustavo Vieira",
			:email => "guga@guga.com",
			:password => "foobar",
			:password_validation => "foobar"
		}
		
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
		
	describe "password validations" do
		
		it "should require password" do 
			User.new(@attr.merge(:password => "", :password_confirmation => ""))
			should_not be_valid
		end
		
		it "should require a matching password confirmation" do
			User.new(@attr.merge(:password_confirmation => "invalid"))
			should_not be_valid
		end
		
		it "should reject short passwords" do
			short = "a" * 5
			User.new(@attr.merge(:password => short, :password_confirmation => short))
			should_not be_valid
		end
		
		it "should reject long passwords" do
			long = "a" * 41
			User.new(@attr.merge(:password => long, :password_confirmation => long))
			should_not be_valid
		end					
	
	end	
	
	describe "password encryption" do
		before(:each) do
			@user = User.create!(@attr)
		end	
			
		it "should have an encrypted password attribute" do 
			@user.should respond_to(:encrypted_password)
		end

		it "encrypted password should not be blank" do 
			@user.encrypted_password.should_not be_blank
		end
		
		
		describe "has_password? method" do
			it "should be true if passwords match" do
				@user.has_password?(@attr[:password]).should be_true
			end
			
			it "should be false if passwords don't match" do
				@user.has_password?("invalid").should be_false
			end
		end
		
		
		describe "authentication method" do 
			it "should return nil on email/password mismatch" do
				wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
				wrong_password_user.should be_nil
			end

			it "should return nil for an email address with no user" do
				nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
				nonexistent_user.should be_nil
			end

			it "should return the user on email/password match" do
				matching_user = User.authenticate(@attr[:email], @attr[:password])
				matching_user.should == @user
			end
		end
				
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

