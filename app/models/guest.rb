# frozen_string_literal: true

Guest = Struct.new(:id, :first_name, :last_name) do
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
