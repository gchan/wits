require 'spec_helper'

describe Wits::FinalInterimPrices do

  describe '.prices' do
    context 'live request' do
      before :all do
        allow_live_requests
      end

      after :all do
        disable_live_requests
      end

      let(:date) { Date.today - 3 }

      subject(:response) { Wits::FinalInterimPrices.prices('BEN2201', date) }
      subject(:price)    { response[:prices].first }

      it 'is able to make a live request' do
        expect(response).to be_a Hash
      end

      it 'returns price information formatted correctly' do
        expect(response[:node_code]).to       eq 'BEN2201'
        expect(response[:node_short_code]).to eq 'BEN'
        expect(response[:node_name]).to       eq 'Benmore'
        expect(response[:price_type]).to      match /Interim|Final/
        expect(response[:date]).to            eq date
        expect(response[:prices].length).to   be_within(2).of(48)

        expect(price[:time]).to           eq parse_nz_time(Time.parse("#{date}"))
        expect(price[:trading_period]).to eq 1
        expect(price[:price]).to          be_a(Float)
      end
    end

    context 'stubbed request' do
      before :all do
        Timecop.freeze(Date.parse('26/03/2015'))
      end

      after :all do
        Timecop.return
      end

      it 'returns price information formatted correctly' do
        VCR.use_cassette("BEN2201_24-03-2015") do
          date     = Date.parse('24/03/2015')
          response = Wits::FinalInterimPrices.prices('BEN', date)
          prices   = response[:prices]
          price    = prices.first

          expect(response[:node_code]).to       eq 'BEN2201'
          expect(response[:node_short_code]).to eq 'BEN'
          expect(response[:node_name]).to       eq 'Benmore'
          expect(response[:price_type]).to      eq 'Final'
          expect(response[:date]).to            eq date
          expect(response[:prices].length).to   eq 48

          expected_trading_periods = (1..48).to_a
          # Extracted from VCR Cassette
          expected_prices = [79.57, 68.46, 68.35, 72.96, 68.57, 68.59, 68.61, 68.65,
            68.65, 82.69, 77.65, 84.02, 83.86, 101.49, 82.3, 82.18, 81.33,
            69.05, 69.28, 77.82, 77.81, 85.98, 82.37, 79.55, 79.55, 67.58, 84.94,
            82.87, 77.67, 85.34, 79.7, 82.67, 81.5, 81.84, 76.88, 86.66, 83.23,
            74.71, 85.11, 96.46, 97.95, 95.79, 86.76, 84.67, 84.69, 97.09, 99.01, 96.6]
          expected_times = (1..48).map do |period|
            parse_nz_time(Time.parse("24/03/2015")) + 60 * 30 * (period - 1)
          end

          expect(prices.map{ |price| price[:trading_period] }).to eq expected_trading_periods
          expect(prices.map{ |price| price[:price] }).to          eq expected_prices
          expect(prices.map{ |price| price[:time] }).to           eq expected_times
        end
      end

      it 'handles daylight savings transitions' do
        VCR.use_cassette("BEN2201_05-04-2015") do
          date     = Date.parse('05/04/2015')
          response = Wits::FinalInterimPrices.prices('BEN', date)
          prices   = response[:prices]
          price    = prices.first

          expect(response[:node_code]).to       eq 'BEN2201'
          expect(response[:node_short_code]).to eq 'BEN'
          expect(response[:node_name]).to       eq 'Benmore'
          expect(response[:price_type]).to      eq 'Final'
          expect(response[:date]).to            eq date
          expect(response[:prices].length).to   eq 50

          expected_trading_periods = (1..50).to_a
          # Extracted from VCR Cassette
          expected_prices = [85.0, 84.33, 88.74, 99.83, 88.97, 85.0, 82.89, 81.73, 85.0, 85.0,
            85.0, 73.12, 80.3, 84.18, 81.88, 85.0, 96.67, 91.13, 93.84, 97.16, 98.99, 80.0, 62.03,
            77.29, 60.44, 63.27, 63.1, 63.31, 64.16, 64.72, 60.0, 60.0, 60.0, 60.0, 60.3, 64.6,
            66.0, 77.24, 91.12, 101.65, 85.69, 66.26, 66.0, 70.69, 70.17, 66.0, 66.0, 66.0, 66.0, 60.0]
          expected_times = (1..50).map do |period|
            parse_nz_time(Time.parse('05/04/2015')) + 60 * 30 * (period - 1)
          end

          expect(prices.map{ |price| price[:trading_period] }).to eq expected_trading_periods
          expect(prices.map{ |price| price[:price] }).to          eq expected_prices
          expect(prices.map{ |price| price[:time] }).to           eq expected_times
        end
      end

      context 'when no date parameter is provided' do
        it "requests the prices for the day before yesterday" do
          VCR.use_cassette("BEN2201_24-03-2015") do
            Wits::FinalInterimPrices.prices('BEN')
          end
        end
      end

      it 'accepts known node short codes' do
        VCR.use_cassette("BEN2201_24-03-2015") do
          Wits::FinalInterimPrices.prices('BEN')
        end
      end

      it 'accepts lower-cased node codes' do
        VCR.use_cassette("BEN2201_24-03-2015") do
          Wits::FinalInterimPrices.prices('ben')
        end
      end

      it 'accepts node codes as symbols' do
        VCR.use_cassette("BEN2201_24-03-2015", allow_playback_repeats: true) do
          Wits::FinalInterimPrices.prices(:ben)
          Wits::FinalInterimPrices.prices(:BEN)
          Wits::FinalInterimPrices.prices(:BEN2201)
          Wits::FinalInterimPrices.prices(:ben2201)
        end
      end

      it 'accepts a date String object' do
        VCR.use_cassette("BEN2201_25-03-2015") do
          date = '25/03/2015'
          Wits::FinalInterimPrices.prices('ben2201', date)
        end
      end

      it 'accepts a Date-like object' do
        VCR.use_cassette("BEN2201_25-03-2015") do
          date = Date.parse('25/03/2015')
          Wits::FinalInterimPrices.prices('ben2201', date)
        end
      end

      it 'accepts a Time-like object' do
        VCR.use_cassette("BEN2201_25-03-2015") do
          time = Time.parse('25/03/2015')
          Wits::FinalInterimPrices.prices('BEN', time)
        end
      end
    end

    describe 'error' do
      it 'Wits::Error::ParsingError is raised for unexpected CSV formats' do
        response = double('reponse', body: 'a' * 300)
        allow(Wits::Client).to receive(:get).and_return(response)

        expect {
          Wits::FinalInterimPrices.prices('ben')
        }.to raise_error(Wits::Error::ParsingError)
      end

      it 'Wits::Error::ResourceNotFound is raised when no data is returned', :vcr do
        expect {
          Wits::FinalInterimPrices.prices('ben', Date.parse('1/1/2000'))
        }.to raise_error(Wits::Error::ResourceNotFound)
      end

      errors = %w(
        ConnectionFailed ResourceNotFound TimeoutError ClientError
      )

      errors.each do |error|
        it "Wits::Error::#{error} is raised on Faraday::#{error} error" do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday.const_get(error), 'message')

          expect {
            Wits::FinalInterimPrices.prices('ben')
          }.to raise_error(Wits::Error.const_get(error))
        end
      end
    end
  end

  expected_node_methods = Hash[
    Wits::Nodes.nodes.map do |node, name|
      methods = [
        node.downcase,
        node.downcase.slice(0, 3),
        name.gsub(' ', '_').downcase
      ]
      methods.concat methods.map{ |method| "#{method}_prices".to_sym }

      [node, methods]
    end
  ]

  describe 'convenience methods' do
    expected_node_methods.each do |node, methods|
      methods.each do |method|
        describe ".#{method}" do
          it 'calls .prices with the correct parameters (no date parameter)' do
            expect(Wits::FinalInterimPrices).to receive(:prices).with(node)

            Wits::FinalInterimPrices.send(method)
          end

          it 'calls .prices with the correct parameters (with date parameter)' do
            date = Date.parse('1/1/2015')

            expect(Wits::FinalInterimPrices).to receive(:prices).with(node, date)

            Wits::FinalInterimPrices.send(method, date)
          end
        end
      end
    end
  end

  context 'when extended' do
    before :all do
      class MyClass
        extend Wits::FinalInterimPrices
      end

      Timecop.freeze(Date.parse('27/03/2015'))
    end

    after :all do
      Timecop.return
    end

    expected_node_methods.values.flatten.each do |method|
      it "makes the .#{method} available on the extending Class or Module", :vcr do
        expect(MyClass.send(method)).to eq Wits::FinalInterimPrices.send(method)
      end
    end

    it 'makes the .prices available on the extending Class or Module', :vcr do
      expect(MyClass.prices('BEN')).to eq Wits::FinalInterimPrices.prices('BEN')
    end
  end
end
