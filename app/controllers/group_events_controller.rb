class GroupEventsController < ApplicationController
  EVENT_ATTRIBUTES = %i(
    name
    status
    description
    description_format
    location
    start
    end
    duration
  )

  # Fetch all group events for certain user
  def index
    user = User.find params[:user_id]
    events = GroupEvent.where(user_id: user.id)

    render json: {
      data: events.map { |e| e.as_json(as: :list) }
    }
  end

  def show
    user = User.find params[:user_id]
    event = GroupEvent.find_by!(user: user, id: params[:id])

    render json: {
      data: event.as_json(as: :member)
    }
  end

  def create
    user = User.find params[:user_id]
    permitted_attributes = params.permit(EVENT_ATTRIBUTES)

    event = GroupEvent.form_create(user, permitted_attributes)

    render json: {
      data: event.as_json(as: :member)
    }
  end

  def update
    user = User.find params[:user_id]
    permitted_attributes = params.permit(EVENT_ATTRIBUTES)

    event = GroupEvent.form_update(user, params[:id], permitted_attributes)

    render json: {
      data: event.as_json(as: :member)
    }
  end
end
