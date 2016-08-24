lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bundler/setup"
Bundler.require(:default)
require "sqs_extractor"

begin
  client = SqsExtractor::Client.new(ARGV[0].to_s)
  client.write_report
rescue SqsExtractor::Client::ArgumentError => error
  puts "Invalid arguments: #{error}"
end
