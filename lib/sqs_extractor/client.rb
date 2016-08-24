require "active_support/all"
require "pathname"
require "fileutils"
require "sqs_extractor/fetcher"
require "sqs_extractor/email_message"

module SqsExtractor
  class Client
    attr_accessor :queue_name

    ArgumentError = Class.new(::ArgumentError)

    def initialize(queue_name)
      self.queue_name = queue_name.to_s
      raise ArgumentError, "Empty queue name" if queue_name.blank?
    end

    def write_report
      File.write(report_path, email_messages_ids.inspect)
    end

    private

    def email_messages_ids
      Fetcher.new(queue_name)
        .fetch_all
        .lazy
        .map { |message| EmailMessage.from_sqs(message) }
        .map(&:id)
        .to_a
        .compact
        .collect
        .to_a
    end

    def report_path
      Pathname.new(Dir.pwd).join("report.txt")
    end
  end
end
