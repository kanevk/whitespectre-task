require 'rails_helper'

RSpec.describe "GroupEvents", type: :request do
  describe 'POST /group_events' do
    it 'creates an event' do
      start_time = DateTime.current
      end_time = DateTime.current + 2.days

      user = create :user
      post "/users/#{user.id}/group_events", params: {
        user_id: user.id,
        name: 'name',
        description: 'description',
        description_format: 'description_format',
        location: 'location',
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        duration: 2,
      }

      expect(response.status).to eq(200)
      expect(parsed_response).to match({
        'data' => a_hash_including(
          'name' => 'name',
          'description' => 'description',
          'description_format' => 'description_format',
          'location' => 'location',
          'start_time' => start_time.to_s(:short),
          'end_time' => end_time.to_s(:short),
          'duration' => 2,
        )
      })
    end

    it 'creates an event that is always draft' do
      user = create :user
      post "/users/#{user.id}/group_events", params: { user_id: user.id }

      expect(response.status).to eq(200)
      expect(parsed_response).to match({
        'data' => hash_including({ 'status' => 'draft' })
      })
    end

    it 'fails creating an event when providing not existent user_id' do
      post "/users/-1/group_events"

      expect(response.status).to eq(404)
    end
  end

  describe "GET /group_events" do
    it 'fetches all group events for the user' do
      user = create :user
      event = create :group_event, user: user, name: 'name', status: :published
      get "/users/#{user.id}/group_events", params: { user_id: user.id }

      expect(response.status).to eq(200)
      expect(parsed_response).to match({
        'data' => a_collection_containing_exactly({ 'id' => event.id, 'name' => 'name', 'status' => 'published' })
      })
    end
  end

  describe "PATCH /group_events/:id" do
    it 'fetches all group events for the user' do
      start_time = DateTime.current
      end_time = DateTime.current + 2.days

      user = create :user
      event = create :group_event, user: user,
                                   name: 'name',
                                   description: 'description',
                                   description_format: 'description_format',
                                   location: 'location',
                                   status: :draft

      updated_attributes = {
        'name' => 'new_name',
        'description' => 'new_description',
        'description_format' => 'new_description_format',
        'location' => 'new_location',
        'start_time' => (start_time + 1.hour).to_s(:short),
        'end_time' => (end_time + 1.hour).to_s(:short),
        'duration' => 2,
      }.freeze

      patch "/users/#{user.id}/group_events/#{event.id}", params: updated_attributes

      expect(response.status).to eq(200)
      expect(parsed_response).to match({
        'data' => { 'status' => 'draft' , **updated_attributes }
      })
    end
  end

  def parsed_response
    JSON.parse(response.body)
  end
end
