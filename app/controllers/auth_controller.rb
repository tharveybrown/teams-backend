class AuthController < ApplicationController
  skip_before_action :require_login, only: [:login, :auto_login]
  def login
    
    employee = Employee.find_by(email: params[:email])
    if employee && employee.authenticate(params[:password])
        login!(employee)
        payload = {employee_id: employee.id}
        token = encode_token(payload)
        render json: {id: employee.id, job_type: employee.job_type, first_name: employee.first_name, last_name: employee.last_name, organization_id: employee.organization_id, email: employee.email, slack_team: employee.slack_team, organization: employee.organization, skills: employee.skills, jwt: token, success: "Welcome back, #{employee.first_name}"}
      else
        render json: {errors: ['no such user', 'verify credentials and try again or signup']}, status: 401
      end
    end
    
    def auto_login
      if session_user
        
        render json: session_user.to_json(:include => 
          {:slack_team =>  {:only=> [:id, :slack_id, :name]}, 
          :organization => {:only => [:name]},
          :skills => {:only => [:description]}})
    else
      render json: {
        logged_in: false,
        message: 'no such user'
      }
    end
  end

  def destroy
    logout!
    render json: {
      status: 200,
      logged_out: true
    }
  end

  def user_is_authed
    render json: {message: "You are authorized"}
  end
end