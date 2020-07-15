class AuthController < ApplicationController
  skip_before_action :require_login, only: [:login, :auto_login]
  def login
    employee = Employee.find_by(email: params[:email])
    if employee && employee.authenticate(params[:password])
        payload = {employee_id: employee.id}
        token = encode_token(payload)
        render json: {employee: employee, jwt: token, success: "Welcome back, #{employee.first_name}"}
    else
        render json: {failure: "Log in failed! Username or password invalid!"}
    end
  end

  def auto_login
    if session_user
      render json: session_user
    else
      render json: {errors: "No User Logged In"}
    end
  end

  def user_is_authed
    render json: {message: "You are authorized"}
  end
end