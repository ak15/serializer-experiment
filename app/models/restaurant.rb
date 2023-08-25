# frozen_string_literal: true

Restaurant = Struct.new(:id, :name, :address) do
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
