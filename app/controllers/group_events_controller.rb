class GroupEventsController < ApplicationController
  EVENT_PERMITTED_ATTRIBUTES = %i(
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
    event = GroupEventForm.create(user, permitted_params)

    render json: {
      data: event.as_json(as: :member)
    }
  end

  def update
    user = User.find params[:user_id]
    event = GroupEvent.find_by!(user: user, id: params[:id])

    updated_event = GroupEventForm.update(event, permitted_params)

    render json: {
      data: updated_event.as_json(as: :member)
    }
  end

  def destroy
    user = User.find params[:user_id]
    event = GroupEvent.find_by!(user: user, id: params[:id])

    event.update!(deleted_at: Time.current)

    render json: {
      data: event.as_json(as: :delete)
    }
  end

  private

  def permitted_params
    params.permit(EVENT_PERMITTED_ATTRIBUTES)
  end
end
