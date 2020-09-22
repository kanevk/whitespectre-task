class GroupEvent < ApplicationRecord
  DATETIME_FORMAT = :short

  include ActiveModel::Serialization

  enum status: { draft: 0, published: 1 }

  belongs_to :user

  def serializable_hash(options = {})
    result = super(options)

    if result.key?('start_time')
      result = result.merge('start_time' => start_time&.to_s(DATETIME_FORMAT))
    end

    if result.key?('end_time')
      result = result.merge('end_time' => end_time&.to_s(DATETIME_FORMAT))
    end

    result
  end
end
