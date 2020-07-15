class EmployeesController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def create
    # byebug
    employee = Employee.create(employee_params) 
    if employee.valid?
        payload = {employee_id: employee.id}
        token = encode_token(payload)
        puts token
        render json: {employee: employee, jwt: token}
    else
        render json: {errors: employee.errors.full_messages}, status: :not_acceptable
    end
  end

  private 

  def employee_params
    params.permit(:first_name, :last_name, :email, :password)
  end
end
