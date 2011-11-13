class PagesController < ApplicationController

	before_filter :not_signed_in, :only => [:home]

  def home
  	@title = "Home"
  end

  def contact
   	@title = "Contact"
  end
  
  def about
	@title = "About"
  end
  
   def help
	@title = "Help"
  end
  
  private 
  
    def not_signed_in
	  	 if signed_in?
  		   redirect_to current_user
	  	 end
	end

end
