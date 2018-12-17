class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
 
 #def is_admin?
   # unless current_user.admin?
     # flash[:danger] = "Oops!! You don't have privilege to to this action"
    #  redirect_to root_path
    #end
  #end
end
