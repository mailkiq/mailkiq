require 'securerandom'
require 'active_support/concern'
require 'active_support/notifications'

# Instrumentable is a module you can include in your classes to help with
# setting up instrumention with ActiveSupport::Notifications.instrument
# Commoningly you would use ActiveSupport::Notifications.instrument and
# wrap it around the code you want you care about in order to fire off
# the approiate event. This allows you to do the same thing but without
# having to modify your existing method definitions.
#
#  ==== Example
#
#   class Person
#     include Instrumentable
#     attr_reader :phone
#
#     def call
#       puts "Calling at #{@phone} number"
#     end
#
#     def self.find(id)
#       PersonStore.find(id)
#     end
#
#     instrument_method :call, 'person.call', :phone => :phone
#     class_instrument_method :find, 'person.find'
#   end
#
#   person = Person.find(5)
#   person.call
#
# Result:
#   An event with name 'person.find' would fire when `Person.find` is called
#   with a payload of { :_method_args => 5 }
#
#   An event with name 'person.call' would fire when person.call is called
#   with a payload of { :phone => (555)555-555 }
module Instrumentable
  extend ActiveSupport::Concern

  module ClassMethods
    # Wraps method_to_instrument in an AS:N:instrument with event_name as
    # the name and passes the payload given to it.
    #
    # Payload is a hash of payload_name to payload_value
    #
    #   payload_value supported types:
    #
    #     String::  Passes the string straight to the payload_name
    #               and does nothing else with it
    #     Symbol::  A method to call on the class being instrumented
    #     Proc::    A proc to call with the object
    #
    #   All of these have their value then calculated (if needed) and set
    #   as the value for the given key
    def instrument_method(method_to_instrument, event_name, payload = {})
      Instrumentality.begin(self, method_to_instrument, event_name, payload)
    end

    # Class implementation of +instrument_method+
    def class_instrument_method(klass, method_to_instrument, event_name, payload = {})
      class << klass; self; end.class_eval do
        Instrumentality.begin(self, method_to_instrument, event_name, payload)
      end
    end
  end

  class Instrumentality
    def self.begin(klass, method, event, payload)
      instrumentality = self
      instrumented_method = :"_instrument_for_#{method}"
      klass.send :alias_method, instrumented_method, method

      klass.send(:define_method, method) do |*args, &block|
        event_payload = payload.inject({}) do |result, (payload_key, payload_value)|
          value = instrumentality.invoke_value(self, payload_value)
          result.tap { |r| r[payload_key] = value }
        end
        event_payload[:_method_args] = args
        ActiveSupport::Notifications.instrument event, event_payload do
          __send__(instrumented_method, *args, &block)
        end
      end
    end

    def self.invoke_value(klass, obj)
      case obj
      when Symbol
        klass.__send__ obj
      when Proc
        obj.call
      when String
        obj
      end
    end
  end
end
