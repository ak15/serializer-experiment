# frozen_string_literal: true

Table = Struct.new(:id, :number, :max_covers) do
  def id
    self[:id] || SecureRandom.uuid
  end

  def created_at
    Time.now
  end

  def updated_at
    Time.now
  end
end
