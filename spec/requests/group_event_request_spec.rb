require 'rails_helper'

RSpec.describe "GroupEvents", type: :request do

  describe "GET users/:user_id/group_events" do
    it 'fetches all group events for the user' do
      user = create :user
      event = create :group_event, user: user, name: 'name', status: :published
      get "/users/#{user.id}/group_events"

      expect(response.status).to eq(200)
      expect(parsed_body).to match({
        'data' => a_collection_containing_exactly({ 'id' => event.id, 'name' => 'name', 'status' => 'published' })
      })
    end
  end

  describe 'POST users/:user_id/group_events' do
    it 'creates an event' do
      start_date = Date.current
      end_date = Date.current + 2.days

      user = create :user
      post "/users/#{user.id}/group_events", params: {
        user_id: user.id,
        name: 'name',
        description: 'description',
        description_format: 'description_format',
        location: 'location',
        start: start_date.to_s,
        end: end_date.to_s,
        duration: 2,
      }

      expect(response.status).to eq(200)
      expect(parsed_body).to match({
        'data' => a_hash_including(
          'name' => 'name',
          'description' => 'description',
          'description_format' => 'description_format',
          'location' => 'location',
          'start' => start_date.to_s,
          'end' => end_date.to_s,
          'duration' => 3,
        )
      })
    end

    it 'creates an event that is always draft' do
      user = create :user
      post "/users/#{user.id}/group_events"

      expect(response.status).to eq(200)
      expect(parsed_body).to match({
        'data' => hash_including({ 'status' => 'draft' })
      })
    end

    it 'fails creating an event when providing not existent user_id' do
      post "/users/missing_id/group_events"

      expect(response.status).to eq(404)
    end
  end

  describe "GET users/:user_id/group_events/:id" do
    it 'fetches the event' do
      user = create :user
      event = create :group_event, user: user,
                                   name: 'name',
                                   description: 'description',
                                   description_format: 'description_format',
                                   status: :draft,
                                   location: 'location',
                                   start_date: Date.new(2020, 1, 1),
                                   end_date: Date.new(2020, 1, 1),
                                   duration: 1

      get "/users/#{user.id}/group_events/#{event.id}"

      expect(response.status).to eq(200)
      expect(parsed_body).to match({
        'data' => {
          'name' => 'name',
          'description' => 'description',
          'description_format' => 'description_format',
          'location' => 'location',
          'start' => Date.new(2020, 1, 1).to_s,
          'end' => Date.new(2020, 1, 1).to_s,
          'duration' => 1,
          'status' => 'draft'
        }
      })
    end
  end

  describe "PATCH /users/:user_id/group_events/:id" do
    it 'fetches all group events for the user' do
      start_date = Date.current
      end_date = Date.current

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
        'start' => (start_date + 1.day).to_s,
        'end' => (end_date + 1.day).to_s,
        'duration' => 1,
      }

      patch "/users/#{user.id}/group_events/#{event.id}", params: updated_attributes

      expect(response.status).to eq(200)
      expect(parsed_body).to match({
        'data' => { 'status' => 'draft' , **updated_attributes }
      })
    end

    it 'fails updating an event when providing not existent event_id' do
      user = create :user
      patch "/users/#{user.id}/group_events/missing_id"

      expect(response.status).to eq(404)
    end
  end

  describe 'DELETE /users/:user_id/group_events/:id' do
    it 'deletes the group_event' do
      travel_to DateTime.current do
        user = create :user
        event = create :group_event, user: user

        delete "/users/#{user.id}/group_events/#{event.id}"

        expect(response.status).to eq(200)
        expect(event.reload.deleted_at).to eq(DateTime.current)
      end
    end

    it 'returns the deleted group_event id' do
      user = create :user
      event = create :group_event, user: user

      delete "/users/#{user.id}/group_events/#{event.id}"

      expect(response.status).to eq(200)
      expect(parsed_body).to eq({
        'data' => { 'id' => event.id }
      })
    end
  end

  def parsed_body
    JSON.parse(response.body)
  end
end
