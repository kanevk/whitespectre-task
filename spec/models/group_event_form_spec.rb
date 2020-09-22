require 'rails_helper'

RSpec.describe GroupEventForm, type: :model do
  describe '#create' do
    it 'calculates duration based on start and end dates given' do
      start_date = Date.new(2020, 1, 1)
      end_date = Date.new(2020, 1, 1)
      user = create :user

      event = GroupEventForm.create(user, { 'start' =>  start_date.to_s, 'end' => end_date.to_s })

      expect(event).to be_persisted
      expect(event.duration).to eq(1)
    end

    it 'calculates start date based on end date and duration given' do
      end_date = Date.new(2020, 1, 3)
      user = create :user

      event = GroupEventForm.create(user, { 'end' => end_date.to_s, 'duration' => '3' })

      expect(event).to be_persisted
      expect(event.start_date).to eq(Date.new(2020, 1, 1))
    end

    it 'calculates end date based on start date and duration given' do
      start_date = Date.new(2020, 1, 1)
      user = create :user

      event = GroupEventForm.create(user, { 'start' => start_date.to_s, 'duration' => '1' })

      expect(event).to be_persisted
      expect(event.end_date).to eq(Date.new(2020, 1, 1))
    end

  end

  describe '#update' do
    it 'calculates duration based on start and end dates given' do
      end_date = Date.new(2020, 1, 1)
      user = create :user
      event = create :group_event, user: user, start_date: Date.new(2020, 1, 1), duration: nil

      updated_event = GroupEventForm.update(event, { 'end' => end_date.to_s })

      expect(updated_event.errors).to be_empty
      expect(updated_event.duration).to eq(1)
    end

    it 'calculates start date based on end date and duration given' do
      user = create :user
      event = create :group_event, user: user, end_date: Date.new(2020, 1, 3), start_date: nil

      updated_event = GroupEventForm.update(event, { 'duration' => '3' })

      expect(updated_event.errors).to be_empty
      expect(updated_event.start_date).to eq(Date.new(2020, 1, 1))
    end

    it 'calculates end date based on start date and duration given' do
      user = create :user
      event = create :group_event, user: user, start_date: Date.new(2020, 1, 1), end_date: nil

      updated_event = GroupEventForm.update(event, { 'duration' => '1' })

      expect(updated_event.errors).to be_empty
      expect(updated_event.end_date).to eq(Date.new(2020, 1, 1))
    end

  end
end
