class EmployeesController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def index
    
    coworkers = session_user.organization.employees.select{|e| e != session_user}
    team = session_user.subordinates
    manager = session_user.manager
    
    if coworkers
      render json: {coworkers: coworkers, manager: manager, team: team}.to_json(:include => {:skills => {:only => [:id, :description]}}, :except => [:updated_at, :created_at, :password_digest, :access_token])
    else 
      render json: {errors: ['no employees found']}, status: 401
    end
  end

  def create
    employee = Employee.create(first_name: params[:first_name], email: params[:email], last_name: params[:last_name], job_type: params[:role], password: params[:password])
    organization = Organization.find_or_create_by(name: params[:organization])
    employee.organization = organization
    skills = params[:skills].map{|skill| Skill.find_or_create_by(description: skill)}
    employee.skills = skills
    if employee.valid? && employee.save
        payload = {employee_id: employee.id}
        token = encode_token(payload)
        puts token
        render json: {id: employee.id, first_name: employee.first_name, last_name: employee.last_name, job_type: employee.job_type, organization_id: employee.organization_id, email: employee.email, slack_team: employee.slack_team, organization: employee.organization, skills: employee.skills, jwt: token, success: "Welcome back, #{employee.first_name}"}
        
    else
        render json: {errors: employee.errors.full_messages}, status: :not_acceptable
    end
  end


  def remove_subordinate
    session_user.subordinates.delete(Employee.find(params[:id]))
    index
  end


  def add_employee
    if !params[:employee]
      return index
    end
    unless session_user.subordinates.include?(params[:employee])
      session_user.subordinates << Employee.find(params[:id])
      
    end
    index
  end

  def add_manager
    if !params[:employee]
      return index
    end
    unless session_user.subordinates.include?(params[:employee])
      Employee.find(params[:id]).subordinates << session_user
    end
    index
  end
  

  private 

  def employee_params
    params.permit(:first_name, :last_name, :email, :password)
  end
end
