class GroupEventsController < ApplicationController
  POST_ATTRIBUTES = %i(
    name
    status
    description
    description_format
    location
    start_time
    end_time
    duration
  )

  # Fetch all group events for certain user
  def index
    user = User.find params[:user_id]
    events = GroupEvent.where(user_id: user.id)

    render json: {
      data: events.map { |e| e.as_json(only: %i(id name status)) }
    }
  end

  def create
    user = User.find params[:user_id]
    permitted_attributes = params.permit(POST_ATTRIBUTES)

    event = GroupEvent.create({ user: user, status: :draft }.merge(permitted_attributes))

    render json: {
      data: event.as_json(only: POST_ATTRIBUTES)
    }
  end

  def update
    user = User.find params[:user_id]
    permitted_attributes = params.permit(POST_ATTRIBUTES)


    event = GroupEvent.find(params[:id])
    event.update!(permitted_attributes)

    render json: {
      data: event.as_json(only: POST_ATTRIBUTES)
    }
  end
end
