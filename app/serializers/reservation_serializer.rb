# frozen_string_literal: true

class ReservationSerializer < SimpleSerializer
  iso_timestamp_columns %i[created_at updated_at start_time]

  attributes :id,
             :status,
             :covers,
             :walk_in,
             :start_time,
             :duration,
             :notes,
             :created_at,
             :updated_at

  belongs_to :restaurant
  has_one    :guest
  has_many   :tables, serializer: TableSerializer

  def notes
    object.notes.presence
  end
end
