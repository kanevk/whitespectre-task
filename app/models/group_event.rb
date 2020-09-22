class GroupEvent < ApplicationRecord
  DATETIME_FORMAT = :short

  include ActiveModel::Serialization

  enum status: { draft: 0, published: 1 }

  belongs_to :user

  SERALIZATION_ATTRIBUTES = {
    list: %i(id name status),
    member: %i(name status description description_format location start end duration),
  }

  # Events from the same day are with duration of 1 (day).
  # For more info check out the specs.
  def self.calculate_duration_fields(**duration_fields)
    result = duration_fields.dup

    case duration_fields.compact
    in { start_date: start_date, end_date: end_date }
      result.merge(duration: (end_date.to_date - start_date.to_date + 1).to_i)
    in { start_date: start_date, duration: duration }
      result.merge(end_date: start_date.to_date + (duration.to_i - 1).days)
    in { end_date: end_date, duration: duration }
      result.merge(start_date: end_date.to_date - (duration.to_i - 1).days)
    else
      result
    end
  end

  def self.form_create(user, attributes = {})
    attributes = attributes.to_h.symbolize_keys.compact
    attributes[:start_date] = attributes[:start] if attributes[:start]
    attributes[:end_date] = attributes[:end] if attributes[:end]

    attributes.merge!(user_id: user.id, status: :draft)

    attributes.merge!(
      calculate_duration_fields(
        start_date: attributes[:start],
        end_date: attributes[:end],
        duration: attributes[:duration],
      )
    )

    create!(attributes.slice(*column_names.map(&:to_sym)))
  end

  def self.form_update(user, event_id, attributes)
    event = find(event_id)

    attributes = attributes.to_h.symbolize_keys.compact
    attributes[:start_date] = attributes[:start] if attributes[:start]
    attributes[:end_date] = attributes[:end] if attributes[:end]

    event.assign_attributes(attributes.slice(*column_names.map(&:to_sym)))

    event.assign_attributes(
      calculate_duration_fields(
        start_date: event.start_date,
        end_date: event.end_date,
        duration: event.duration,
      )
    )

    event.save!
    event
  end

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
end
