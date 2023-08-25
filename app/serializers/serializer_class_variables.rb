# frozen_string_literal: true

# This module includes class variables that are used by all child classes
# of the Serializer class.

# The `accessors` class variable is used to store the names of all the
# attributes that should be serialized.

# The `iso8601_timestamps` class variable is used to store the names of all
# the attributes that should be serialized as ISO 8601 timestamps.

# The `associations` class variable is used to store the names of all
# the associations that should be serialized.

# The `inherited` method is called when a new class inherits from the
# `SerializerClassVariables` module. The `inherited` method adds the
# `accessors`, `iso8601_timestamps`, and `associations` class variables to
# the subclass.
module SerializerClassVariables
  def inherited(subclass)
    subclass.class_eval do
      super
      cattr_accessor :accessors, :iso8601_timestamps, :associations, default: []
    end
  end
end
