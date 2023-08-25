# frozen_string_literal: true

class RestaurantSerializer < SimpleSerializer
  attributes :id,
             :name,
             :address

  def address
    object.address.presence
  end
end
