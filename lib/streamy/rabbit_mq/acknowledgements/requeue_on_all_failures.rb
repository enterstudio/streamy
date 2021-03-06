require "hutch"

module Streamy
  module RabbitMq
    module Acknowledgements
      class RequeueOnAllFailures < Hutch::Acknowledgements::Base
        include Hutch::Logging

        def handle(delivery_info, properties, broker, ex)
          broker.requeue(delivery_info.delivery_tag)
          logger.debug "[*] requeued message(#{properties.message_id || '-'})"

          false
        end
      end
    end
  end
end
