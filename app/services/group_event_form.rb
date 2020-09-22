module GroupEventForm
  extend self

  def create(user, attributes = {})
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

    GroupEvent.create!(attributes.slice(*db_columns))
  end

  def update(event, attributes)
    attributes = attributes.to_h.symbolize_keys.compact
    attributes[:start_date] = attributes[:start] if attributes[:start]
    attributes[:end_date] = attributes[:end] if attributes[:end]

    event.assign_attributes(attributes.slice(*db_columns))

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

  # Events from the same day are with duration of 1 (day).
  # For more info check out the specs.
  def calculate_duration_fields(**duration_fields)
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

  def db_columns
    GroupEvent.column_names.map(&:to_sym)
  end

end
