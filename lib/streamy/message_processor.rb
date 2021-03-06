module Streamy
  class MessageProcessor
    def initialize(message)
      @message = message
    end

    def run
      ignoring_duplicates do
        event_handler.new(attributes).process
      end
    end

    private

      attr_reader :message

      def ignoring_duplicates(&block)
        return yield if cache.nil?

        cache.fetch("streamy/events/#{key}") do
          yield
        end
      end

      def cache
        Streamy.cache
      end

      def key
        message[:key]
      end

      def event_handler
        handler_class_name.safe_constantize || raise(handler_not_found_error)
      end

      def handler_class_name
        "EventHandlers::#{message_type.camelize}"
      end

      def message_type
        message[:type] || raise(TypeNotFoundError)
      end

      def handler_not_found_error
        EventHandlerNotFoundError.new(handler_class_name)
      end

      def attributes
        {
          body: body,
          event_time: message[:event_time]
        }
      end

      def body
        (message[:body] || {})
      end
  end
end
