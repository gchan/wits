require 'spec_helper'

describe Wits::Error do
  it 'has a superclass of StandardError' do
    expect(Wits::Error.superclass).to eq StandardError
  end

  describe Wits::Error::ClientError do
    it 'has a superclass of Wits::Error' do
      expect(Wits::Error::ClientError.superclass).to eq Wits::Error
    end

    it 'is a descendent of StandardError' do
      expect(Wits::Error::ClientError.ancestors).to include StandardError
    end
  end

  client_errors = %w(
    ConnectionFailed TimeoutError ResourceNotFound ParsingError
  )

  client_errors.each do |client_error|
    klass = Wits::Error.const_get(client_error)
    describe klass do
      it 'has a superclass of Wits::Error::ClientError' do
        expect(klass.superclass).to eq Wits::Error::ClientError
      end

      it 'is a descendent of StandardError' do
        expect(klass.ancestors).to include StandardError
      end
    end
  end
end
