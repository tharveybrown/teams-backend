class EmployeesController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def create
    # byebug
    @employee = Employee.create(first_name: params[:first_name], email: params[:email], last_name: params[:last_name], password: params[:password])
    organization = Organization.find_or_create_by(name: params[:organization])
    @employee.organization = organization
    skills = params[:skills].map{|skill| Skill.find_or_create_by(description: skill)}
    @employee.skills = skills
    if @employee.valid? && @employee.save
        # login!(@employee)
        session[:employee_id] = employee.id
        # byebug
        payload = {employee_id: @employee.id}
        token = encode_token(payload)
        session[:employee] = @employee

        puts token
        render json: {employee: @employee, organization: @employee.organization, skills: @employee.skills, jwt: token}
    else
        render json: {errors: @employee.errors.full_messages}, status: :not_acceptable
    end
  end

  private 

  def employee_params
    params.permit(:first_name, :last_name, :email, :password)
  end
end
