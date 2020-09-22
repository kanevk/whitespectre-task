class PublishedGroupEventsController < ApplicationController
  def create
    user = User.find params[:user_id]
    event = GroupEvent.find_by! user: user, id: params[:group_event_id]

    event.status = :published
    success = event.save(context: :publishing)

    render json: {
      success: success,
      errors: event.errors.full_messages,
    }
  end

  def destroy
    user = User.find params[:user_id]
    event = GroupEvent.find_by! user: user, id: params[:group_event_id]

    success = event.update(status: :draft)

    render json: {
      success: success,
      errors: publish_result.errors,
    }
  end
end
