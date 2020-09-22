require 'rails_helper'

RSpec.describe "PublishedGroupEvents", type: :request do
  describe "POST users/:user_id/group_events/publish" do
    it 'publishes group event successfully' do
      user = create :user
      event = create :group_event, user: user,
                                   name: 'name',
                                   start_date: Date.new(2020, 1, 1),
                                   end_date: Date.new(2020, 1, 1),
                                   duration: 1,
                                   description: 'description',
                                   description_format: 'description_format',
                                   location: 'location',
                                   status: :draft

      post "/users/#{user.id}/group_events/#{event.id}/publish"

      expect(response.status).to eq(200)
      expect(parsed_body).to eq('success' => true, 'errors' => [])
      expect(event.reload.status).to eq('published')
    end

    it 'returns error when the publishing fails due to blank fields' do
      user = create :user
      event = create :group_event, user: user,
                                   name: 'name',
                                   description: 'description',
                                   description_format: 'description_format',
                                   location: 'location',
                                   status: :draft

      post "/users/#{user.id}/group_events/#{event.id}/publish"

      expect(response.status).to eq(200)
      expect(parsed_body).to eq(
        'success' => false,
        'errors' => [
          "Start date can't be blank",
          "End date can't be blank",
          "Duration can't be blank"
        ],
      )
      expect(event.reload.status).to eq('draft')
    end

    it 'returns error when the publishing fails due to event duration invalid' do
      user = create :user
      event = create :group_event, user: user,
                                   name: 'name',
                                   start_date: Date.new(2020, 1, 3),
                                   end_date: Date.new(2020, 1, 2),
                                   duration: -1,
                                   description: 'description',
                                   description_format: 'description_format',
                                   location: 'location',
                                   status: :draft

      post "/users/#{user.id}/group_events/#{event.id}/publish"

      expect(response.status).to eq(200)
      expect(parsed_body).to eq(
        'success' => false,
        'errors' => [
          "Start date cannot be after 'end date'",
          "End date cannot be before 'start date'",
        ],
      )
      expect(event.reload.status).to eq('draft')
    end
  end

  describe "DELETE users/:user_id/group_events/publish" do
    it 'unpublishes group event successfully' do
      user = create :user
      event = create :group_event, user: user,
                                   name: 'name',
                                   start_date: Date.new(2020, 1, 1),
                                   end_date: Date.new(2020, 1, 1),
                                   duration: 1,
                                   description: 'description',
                                   description_format: 'description_format',
                                   location: 'location',
                                   status: :published

      delete "/users/#{user.id}/group_events/#{event.id}/publish"

      expect(response.status).to eq(200)
      expect(parsed_body).to eq(
        'success' => true,
      )
      expect(event.reload.status).to eq('draft')
    end
  end

  def parsed_body
    JSON.parse(response.body)
  end
end
