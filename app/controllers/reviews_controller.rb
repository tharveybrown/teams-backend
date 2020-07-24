class ReviewsController < ApplicationController

  def create
    reviewed_employee = Employee.find(params['targetEmployee']['id'])
    reviewer_employee = session_user
    
    review = session_user.given_reviews.create(reviewed_id: params['targetEmployee']['id'], rating: params['rating'], description: params['feedback'], skill: params['skill'], pending: false)
    if review
      render json: review
    else
      render json: {errors: ['Unable to create review']}, status: 401
    end
  end

  def request_feedback
    slack_users = session_user.slack_team.users(session_user.slack_team.bot_token)
    params['targetEmployees'].each do |email|
      slack_id = slack_users.find{|u| u['profile']['email'] == email}['id']
      if(slack_id)
        notify(slack_id)
      end
    end
    pending_reviewer_ids = params['targetEmployees'].map{|emp| Employee.find_by(email: emp).id}
    pending_reviews = pending_reviewer_ids.map{|emp| session_user.received_reviews.create(reviewer_id: emp, pending: params['pending'], skill: params['skill'])}
    if !pending_reviews.empty?
      render json: pending_reviews.to_json(:except => ['updated_at', 'rating', 'description'])
    else
      render json: {errors: ['Unable to create feedback requests']}, status: 401
    end

  end

  def received
    received_reviews = session_user.received_reviews.select{|r| r.reviewer_id}
    if received_reviews.length != 0

      reviews = received_reviews.map{|r| {id: r['id'], description: r['description'], created_at: r['created_at'], skill: r['skill'], rating: r['rating'], pending: r['pending'], reviewer_employee: Employee.find(r['reviewer_id'])}}
      render json: reviews.to_json(:except => ['updated_at', 'access_token', 'password_digest'])
    else 
      render json: {errors: ['Unable to find any reviews']}, status: 401
    end
  end

  def given
    given_reviews = session_user.given_reviews
    if given_reviews.length != 0
      
      reviews = given_reviews.map{|r| {id: r['id'], description: r['description'], created_at: r['created_at'], skill: r['skill'], rating: r['rating'], pending: r['pending'], reviewed_employee: Employee.find(r['reviewed_id'])}}
      render json: reviews.to_json(:except => ['updated_at', 'access_token', 'password_digest'])
    else 
      render json: {errors: ['Unable to find any reviews']}, status: 401
    end
  end

  def notify(slack_id) 
    origin = request.headers['origin']
    bot_access_token = session_user.slack_team.bot_token
    con = Faraday.new
    resp = con.post('https://slack.com/api/chat.postMessage', {channel: slack_id, text: ":wave: Hi there! #{session_user.first_name} is requesting feedback! \n<#{origin}/new|Follow the link to provide feedback.>"  }, { 'X-Accept'=> 'application/json', 'Authorization'=> "Bearer #{bot_access_token}"})
  end
  


end
