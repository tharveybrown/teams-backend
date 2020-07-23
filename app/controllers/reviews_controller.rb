class ReviewsController < ApplicationController

  def create
    reviewed_employee = Employee.find(params['targetEmployee']['id'])
    reviewer_employee = session_user
    review = session_user.given_reviews.create(reviewed_id: params['targetEmployee']['id'], description: params[:feedback], pending: false)
    if review
      render json: review
    else
      render json: {errors: ['Unable to create review']}, status: 401
    end
  end

  def request_feedback
    pending_reviewer_ids = params['targetEmployees'].map{|emp| Employee.find_by(email: emp).id}
    pending_reviews = pending_reviewer_ids.map{|emp| session_user.received_reviews.create(reviewer_id: emp, pending: params['pending'], skill: params['skill'])}
    if !pending_reviews.empty?
      render json: pending_reviews.to_json(:except => ['updated_at', 'rating', 'description'])
    else
      render json: {errors: ['Unable to create feedback requests']}, status: 401
    end

  end

  def received
    received_reviews = session_user.received_reviews
    if received_reviews.length != 0
      reviews = received_reviews.map{|r| {description: r['description'], created_at: r['created_at'], rating: r['rating'], pending: r['pending'], reviewer_employee: Employee.find(r['reviewer_id'])}}
      render json: reviews.to_json(:except => ['updated_at', 'access_token', 'password_digest'])
    else 
      render json: {errors: ['Unable to find any reviews']}, status: 401
    end
  end

  def given
    given_reviews = session_user.given_reviews
    if given_reviews.length != 0
      reviews = given_reviews.map{|r| {description: r['description'], created_at: r['created_at'], rating: r['rating'], pending: r['pending'], reviewed_employee: Employee.find(r['reviewed_id'])}}
      render json: reviews.to_json(:except => ['updated_at', 'access_token', 'password_digest'])
    else 
      render json: {errors: ['Unable to find any reviews']}, status: 401
    end
  end
  



end
