# frozen_string_literal: true

require 'time'
require 'active_support/inflector'
require_relative 'serializer_class_variables'
# This class provides a basic serializer framework for converting objects into
# serialized data using a predefined list of attributes and associations.
class SimpleSerializer
  extend SerializerClassVariables

  attr_accessor :object, :keys

  def initialize(object)
    @object = object
    @keys = accessors
    initialize_attributes
    initialize_associations
  end

  # class methods
  class << self
    # list of attributes to be serialized based on args
    # returns an array of attributes/columns
    def attributes(*args)
      self.accessors = args
      send(:attr_accessor, *args)
    end

    # timestamp_columns to show iso8601 format value
    # returns an array of columns/date
    def iso_timestamp_columns(args)
      self.iso8601_timestamps = args
    end

    # configure associations based on (struct, serializer) hash
    # struct is the name of struct references inside parent struct
    # serializer is the serializer class to be used for serializing the struct in method
    # returns an array of hashes with keys as struct name and serializer class
    %w[belongs_to has_one has_many].each do |method|
      define_method(method) do |method_name, serializer_hash = {}|
        send(:attr_accessor, method_name)
        assoc_method =  serializer_hash[:serializer] || "#{method_name.to_s.singularize}Serializer".camelize.constantize
        associations << { method: method_name, serializer: assoc_method }
      end
    end
  end
  # end class methods
  # instance methods
  def as_json
    keys.each_with_object({}) do |key, hash|
      hash[key.to_s] = if send(key).is_a?(Array)
                         send(key).map(&:as_json)
                       elsif send(key).respond_to?(:as_json)
                         send(key).as_json
                       else
                         send(key)
                       end
      hash
    end
  end
  # end instance methods

  # private methods
  private

  # rubocop:disable Metrics/MethodLength
  def initialize_associations
    associations.each do |association|
      attribute_name = association[:method]
      serializer = association[:serializer]
      child = object.send(attribute_name)
      keys.push(attribute_name)
      value = if child.is_a?(Array)
                child.map { |c| serializer.new(c) }
              else
                serializer.new(child)
              end
      send("#{attribute_name}=", value)
    end
  end
  # rubocop:enable Metrics/MethodLength

  def initialize_attributes
    accessors.each do |accessor|
      value = if iso8601_timestamps.include?(accessor)
                object.send(accessor).iso8601
              else
                object.send(accessor)
              end
      next if value.nil?

      send("#{accessor}=", value)
    end
  end
  # end of private methods
end
