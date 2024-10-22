# frozen_string_literal: true

module RouterOS
  # adds async support if async gem is present
  module Async
    @enabled = false

    def self.included(base)
      base.extend(ClassMethods)
    end

    def self.enabled?
      @enabled
    end

    # class methods to be added when this module is included
    module ClassMethods
      def async_enabled?
        RouterOS::Async.enabled?
      end
    end

    begin
      require 'async'

      def async_command(cmd, args = [])
        Async do
          command(cmd, args)
        end
      end

      @enabled = true
    rescue LoadError
      # async gem is not available, so no-op
    end
  end
end
