require "sqs_serializable"
require "json"

module SqsExtractor
  class EmailMessage
    include SqsSerializable

    attr_accessor :id

    def self.by_sqs(text)
      json = JSON.parse(text) rescue {}

      new.tap do |obj|
        obj.id = json["id"]
      end
    end
  end
end
