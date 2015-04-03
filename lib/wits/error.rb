module Wits
  class Error < StandardError
    # Generic Client Error
    ClientError = Class.new(Error)

    # ConnectionFailed from Faraday
    ConnectionFailed = Class.new(ClientError)

    # TimeoutError from Faraday
    TimeoutError = Class.new(ClientError)

    # No data available from Wits
    ResourceNotFound = Class.new(ClientError)

    # Unexpected error when parsing data
    ParsingError = Class.new(ClientError)
  end
end
