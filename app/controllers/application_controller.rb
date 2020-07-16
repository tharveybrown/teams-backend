require 'pry'
class ApplicationController < ActionController::API
  def current_user
    pry
    # return unless session[:employee_id]
    #   @current_user ||= Employee.find(session[:employee_id])
    # end
  end
end
