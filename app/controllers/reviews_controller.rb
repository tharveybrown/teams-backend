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

end
