class AuthController < ApplicationController
  skip_before_action :require_login, only: [:login, :auto_login]
  def login
    
    employee = Employee.find_by(email: params[:email])
    if employee && employee.authenticate(params[:password])
        login!(employee)
        payload = {employee_id: employee.id}
        token = encode_token(payload)
        session[:employee] = employee
        render json: {employee: employee, jwt: token, success: "Welcome back, #{employee.first_name}"}
    else
      render json: {errors: ['no such user', 'verify credentials and try again or signup']}, status: 401
      
    end
  end

  def auto_login
    if session_user
      
      session[:employee_id] = session_user[:id]
      render json: session_user
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