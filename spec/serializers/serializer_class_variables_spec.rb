# frozen_string_literal: true

require 'spec_helper'
class MainSerializer
  extend SerializerClassVariables
end

class DummySerializer < MainSerializer
end

class NewSubclass < MainSerializer
end

describe SerializerClassVariables do
  describe '.inherited' do
    let(:subclass) { Class.new(DummySerializer) }
    let(:new_subclass) { Class.new(NewSubclass) }

    it 'sets default values for class variables' do
      expect(subclass.accessors).to eq([])
      expect(subclass.iso8601_timestamps).to eq([])
      expect(subclass.associations).to eq([])
    end

    context 'when overridden class variables' do
      before do
        subclass.accessors = %i[name age]
        subclass.iso8601_timestamps = %i[created_at]
        subclass.associations = %i[posts comments]
      end

      it 'sets overridden values for class variables' do
        expect(subclass.accessors).to eq(%i[name age])
        expect(subclass.iso8601_timestamps).to eq(%i[created_at])
        expect(subclass.associations).to eq(%i[posts comments])
      end

      it 'does not change other child class variables' do
        expect(new_subclass.accessors).to eq([])
        expect(new_subclass.iso8601_timestamps).to eq([])
      end
    end
  end
end
