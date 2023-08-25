# frozen_string_literal: true

require 'spec_helper'

describe ReservationSerializer do
  include_context 'reservation_serializer'
  subject { serializer.as_json }

  let(:serializer) { described_class.new(reservation) }

  it 'allows attributes to be defined for serialization' do
    expect(subject.keys).to contain_exactly(
      *%w[
        id
        status
        covers
        walk_in
        start_time
        duration
        notes
        created_at
        updated_at
        restaurant
        guest
        tables
      ]
    )
  end

  describe 'relationships' do
    it 'returns single restaurant' do
      data = RestaurantSerializer.new(reservation.restaurant).as_json
      expect(subject['restaurant']).to eq(data)
    end

    it 'returns single guest' do
      data = GuestSerializer.new(reservation.guest).as_json
      expect(subject['guest']).to eq(data)
    end

    it 'returns array of tables' do
      data = reservation.tables.map { TableSerializer.new(_1).as_json }
      expect(subject['tables']).to match_array(data)
    end
  end

  describe 'notes' do
    it 'is nil if an empty string' do
      reservation.notes = ''
      expect(subject['notes']).to eq(nil)
    end
  end

  describe '#as_json' do
    it 'returns correct payload' do
      expect(subject.except('guest', 'restaurant', 'tables')).to eq(
        'id' => reservation.id,
        'status' => 'not_confirmed',
        'covers' => 2,
        'walk_in' => false,
        'start_time' => reservation.start_time.iso8601,
        'duration' => 5400,
        'notes' => nil,
        'created_at' => reservation.created_at.iso8601,
        'updated_at' => reservation.updated_at.iso8601
      )
    end
  end
end
