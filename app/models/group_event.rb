class GroupEvent < ApplicationRecord
  DATETIME_FORMAT = :short

  include ActiveModel::Serialization

  enum status: { draft: 0, published: 1 }

  default_scope { where(deleted_at: nil) }

  belongs_to :user

  with_options on: :publishing do
    validates :name,
              :description,
              :description_format,
              :location,
              :start_date,
              :end_date,
              :duration,
              :status,
              presence: true

    validate :start_date_before_end_date
  end

  SERALIZATION_ATTRIBUTES = {
    list: %i(id name status),
    member: %i(name status description description_format location start end duration),
    delete: %i(id)
  }

  def attributes
    hash = super

    hash.merge({'start' => hash['start_date'], 'end' => hash['end_date']})
        .except('start_date', 'end_date')
  end

  def serializable_hash(options = {})
    options = options.dup
    as = options.delete(:as)
    options[:only] = SERALIZATION_ATTRIBUTES.fetch(as) if as

    super(options)
  end

  def read_attribute_for_serialization(attribute)
    case attribute
    when 'start' then self['start_date']
    when 'end' then self['end_date']
    else
      super
    end
  end

  private

  def start_date_before_end_date
    if (start_date && end_date) && start_date > end_date
      errors.add(:start_date, "cannot be after 'end date'")
      errors.add(:end_date, "cannot be before 'start date'")
    end
  end
end
