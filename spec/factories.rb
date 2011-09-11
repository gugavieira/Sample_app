#By using the symbol :user, we ge Factory Girl to simulate the User Model

Factory.define :user do |user|
	user.name					"Gustavo Vieira"
	user.email					"guga@guga.com"
	user.password 				"foobar"
	user.password_confirmation	"foobar"
end