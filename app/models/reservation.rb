# frozen_string_literal: true

Reservation = Struct.new(:id, :status, :covers, :walk_in, :start_time, :duration, :notes, :guest, :restaurant,
                         :tables) do
  def id
    @id ||= self[:id] || SecureRandom.uuid
  end

  def created_at
    Time.now
  end

  def updated_at
    Time.now
  end
end
