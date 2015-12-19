require 'wits/error'

#
# A wrapper for the chosen HTTP library that can be easily replaced
# while keeping the Wits API and error classes consistent
#
module Wits
  module Client
    def self.get_csv(*args, &block)
      response = get(*args, &block)

      check_for_data(response)

      response
    end

    def self.get(*args, &block)
      client.get(*args, &block)
    rescue Faraday::ClientError => error
      handle_error(error)
    end

    def self.client
      @client ||= Faraday.new(url: 'http://www.electricityinfo.co.nz') do |connection|
        connection.adapter Faraday.default_adapter
        connection.use Faraday::Response::RaiseError
      end
    end

    private

    # WITS is buggy and doesn't use status codes.
    # This is the most reliable method of determining whether
    # we actually have a meaningful CSV file
    def self.check_for_data(response)
      return unless response.body =~ /html/i ||
                    response.body.length < 300

      fail Wits::Error::ResourceNotFound
    end

    def self.handle_error(error)
      case error
      when Faraday::ConnectionFailed
        raise Wits::Error::ConnectionFailed.new error
      when Faraday::ResourceNotFound
        raise Wits::Error::ResourceNotFound.new error
      when Faraday::TimeoutError
        raise Wits::Error::TimeoutError.new error
      else # Faraday::ClientError
        raise Wits::Error::ClientError.new error
      end
    end
  end
end
