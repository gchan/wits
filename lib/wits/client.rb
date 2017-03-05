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
      @client ||= Faraday.new(url: 'https://www2.electricityinfo.co.nz') do |connection|
        connection.adapter Faraday.default_adapter
        connection.use Faraday::Response::RaiseError
      end
    end

    private

    # Check if the CSV contains more than just the header
    # or if the there is no CSV (i.e we received an HTML file)
    def self.check_for_data(response)
      raise Wits::Error::ResourceNotFound if response.body.include?('html') ||
                                             CSV.parse(response.body).size <= 1
    end

    def self.handle_error(error)
      case error
      when Faraday::ConnectionFailed
        raise Wits::Error::ConnectionFailed, error
      when Faraday::ResourceNotFound
        raise Wits::Error::ResourceNotFound, error
      when Faraday::TimeoutError
        raise Wits::Error::TimeoutError, error
      else # Faraday::ClientError
        raise Wits::Error::ClientError, error
      end
    end
  end
end
