require "hutch"

module Streamy
  module Consumer
    def self.included(base)
      base.include Hutch::Consumer
      base.consume "#{Streamy::DEFAULT_TOPIC_PREFIX}.#"

      configure_hutch
    end

    def process(message)
      MessageProcessor.new(message).run
    end

    def self.configure_hutch
      Hutch::Config.set(
        :error_acknowledgements,
        [MessageBuses::RabbitMessageBus::Resquer.new, MessageBuses::RabbitMessageBus::Aborter.new]
      )
    end
  end
end
