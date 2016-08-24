require "aws-sdk"

module SqsExtractor
  class Fetcher
    attr_accessor :queue_name

    def initialize(queue_name)
      self.queue_name = queue_name.to_s
    end

    def fetch_all
      prepare
      download_all_messages
    end

    def queue_url
      @queue_url ||= sqs.get_queue_url(queue_name: queue_name).queue_url
    end

    private

    def download_all_messages
      messages = []

      puts "Begin downloading messages"
      loop do
        response_messages = get_messages
        break if response_messages.empty?
        messages << response_messages.map(&:body)
        puts "Downloaded #{response_messages.size} messages, #{Time.current}"
        break
      end
      puts "Finished downloading messages"

      messages.flatten
    end

    def get_messages
      response = sqs.receive_message({
        queue_url:               queue_url,
        attribute_names:         [],
        message_attribute_names: [],
        max_number_of_messages:  10,
        visibility_timeout:      1.second,
        wait_time_seconds:       15.seconds
      })
      response.try(:messages) rescue []
    end

    def prepare
      @queue_url = nil
    end

    def sqs
      @sqs ||= Aws::SQS::Client.new
    end
  end
end
