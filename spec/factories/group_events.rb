FactoryBot.define do
  factory :group_event do
    user
    status { :draft }
  end
end
