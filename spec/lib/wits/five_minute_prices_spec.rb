require 'spec_helper'

describe Wits::FiveMinutePrices do

  describe '.five_minute_prices' do
    context 'live request' do
      before :all do
        allow_live_requests
      end

      after :all do
        disable_live_requests
      end

      let(:date) { Date.today - 3 }

      context 'non-averaged prices' do
        subject(:response) { Wits::FiveMinutePrices.five_minute_prices('BEN2201', date) }
        subject(:price)    { response[:prices][7] }

        it 'is able to make a live request' do
          expect(response).to be_a Hash
        end

        it 'returns price information formatted correctly' do
          expect(response[:node_code]).to       eq 'BEN2201'
          expect(response[:node_short_code]).to eq 'BEN'
          expect(response[:node_name]).to       eq 'Benmore'
          expect(response[:price_type]).to      eq 'Five Minute'
          expect(response[:date]).to            eq date
          expect(response[:prices].length).to   be_within(2*6).of(48*6)

          expect(price[:time]).to           eq parse_nz_time(Time.parse("#{date} 00:35"))
          expect(price[:trading_period]).to eq 2
          expect(price[:price]).to          be_a(Float)
        end
      end

      context 'averaged prices' do
        subject(:response) { Wits::FiveMinutePrices.five_minute_prices('BEN2201', date, :average) }
        subject(:price)    { response[:prices][3] }

        it 'is able to make a live request' do
          expect(response).to be_a Hash
        end

        it 'returns price information formatted correctly' do
          expect(response[:node_code]).to       eq 'BEN2201'
          expect(response[:node_short_code]).to eq 'BEN'
          expect(response[:node_name]).to       eq 'Benmore'
          expect(response[:price_type]).to      eq 'Average Five Minute'
          expect(response[:date]).to            eq date
          expect(response[:prices].length).to   be_within(2).of(48)

          expect(price[:time]).to           eq parse_nz_time(Time.parse("#{date} 01:30"))
          expect(price[:trading_period]).to eq 4
          expect(price[:price]).to          be_a(Float)
        end
      end
    end

    context 'stubbed request' do
      before :all do
        Timecop.freeze(Date.parse('24/03/2015'))
      end

      after :all do
        Timecop.return
      end

      context 'non-averaged prices' do
        it 'returns price information formatted correctly' do
          VCR.use_cassette("BEN2201_5min_24-03-2015") do
            date     = Date.parse('24/03/2015')
            response = Wits::FiveMinutePrices.five_minute_prices('BEN', date)
            prices   = response[:prices]
            price    = prices.first

            expect(response[:node_code]).to       eq 'BEN2201'
            expect(response[:node_short_code]).to eq 'BEN'
            expect(response[:node_name]).to       eq 'Benmore'
            expect(response[:price_type]).to      eq 'Five Minute'
            expect(response[:date]).to            eq date
            expect(response[:prices].length).to   eq 48 * 6

            expected_trading_periods = ((1..48).to_a * 6).sort
            expected_times = (1..48*6).map do |period|
              parse_nz_time(Time.parse("24/03/2015")) + 60 * 5 * (period - 1)
            end
            # Extracted from VCR Cassette
            expected_prices = [86.12, 90.4, 96.7, 96.81, 96.79, 101.06, 97.07, 99.18, 127.82, 127.82,
              135.05, 128.27, 86.31, 97.15, 97.15, 97.17, 98.48, 98.7, 83.52, 83.7, 83.91, 83.71, 98.54,
              100.19, 69.59, 69.62, 79.81, 84.67, 84.69, 86.91, 84.22, 84.22, 86.6, 86.69, 86.83, 88.1,
              86.19, 86.22, 90.55, 90.55, 102.35, 102.35, 86.22, 86.28, 90.61, 103.05, 100.13, 103.56,
              95.38, 91.19, 91.19, 96.46, 91.19, 86.22, 86.22, 86.22, 85.12, 83.51, 84.98, 84.98, 102.35,
              83.23, 90.18, 62.51, 83.42, 83.23, 83.23, 83.42, 86.66, 83.23, 77.33, 82.03, 86.25, 86.66,
              86.25, 91.66, 86.66, 86.66, 79.52, 76.88, 76.67, 73.33, 78.22, 76.13, 87.39, 87.39, 81.54,
              77.32, 81.51, 81.51, 81.99, 83.63, 81.51, 81.51, 81.52, 81.5, 83.63, 83.63, 83.63, 81.99,
              81.12, 81.06, 80.27, 81.22, 80.99, 79.7, 79.7, 81.29, 86.69, 85.34, 85.34, 87.23, 85.34,
              85.34, 81.37, 85.39, 77.9, 77.67, 77.67, 77.98, 79.6, 82.59, 82.87, 84.98, 85.12, 85.12,
              88.93, 88.93, 88.93, 88.93, 84.94, 83.85, 67.58, 67.58, 67.58, 67.58, 67.58, 67.54, 69.39,
              79.55, 79.55, 79.55, 79.55, 79.55, 79.55, 79.55, 79.55, 79.55, 79.55, 79.55, 79.55, 82.24,
              96.55, 88.37, 88.41, 90.45, 85.98, 85.98, 86.12, 86.12, 86.12, 85.98, 76.66, 78.04, 77.81,
              77.81, 86, 77.81, 67.63, 67.71, 77.82, 85.95, 86, 86, 67.92, 68.99, 69.27, 76.86, 69.39,
              80.95, 67.59, 67.59, 67.73, 67.74, 69.06, 80.99, 81.08, 80.99, 81.18, 81.09, 81.09, 81.15,
              82.12, 82.12, 82.12, 82.02, 82.02, 81.98, 105.71, 100.82, 100.2, 81.9, 66.83, 60.44, 149.52,
              132.18, 101.43, 94.1, 82.44, 73.6, 104.51, 92.39, 83.87, 82.84, 77.6, 67.89, 101.05, 85.45,
              83.99, 83.86, 77.78, 73.34, 83.73, 83.24, 80.16, 64, 77.77, 65.79, 83.04, 82.69, 82.69, 79.21,
              79.89, 79.21, 68.74, 68.67, 68.67, 68.69, 68.69, 68.73, 68.73, 68.62, 68.69, 68.62, 68.69, 74.76,
              68.6, 68.56, 68.61, 68.61, 68.68, 68.73, 68.52, 68.46, 68.5, 65.66, 68.64, 71.98, 65.66, 65.38,
              68.6, 68.62, 68.65, 68.66, 68.69, 72.17, 72.13, 75.27, 75.36, 75.36, 65.82, 65.82, 67.36, 67.36,
              68.32, 71.9, 67.48, 68.44, 68.44, 68.44, 68.53, 74.54, 68.43, 68.52, 79, 85.83, 90.49, 90.08].reverse

            expect(prices.map{ |price| price[:trading_period] }).to eq expected_trading_periods
            expect(prices.map{ |price| price[:price] }).to          eq expected_prices
            expect(prices.map{ |price| price[:time] }).to           eq expected_times
          end
        end
      end

      context 'averaged prices' do
        it 'returns price information formatted correctly' do
          VCR.use_cassette("BEN2201_average_5min_24-03-2015") do
            date     = Date.parse('24/03/2015')
            response = Wits::FiveMinutePrices.five_minute_prices('BEN', date, :average)
            prices   = response[:prices]
            price    = prices.first

            expect(response[:node_code]).to       eq 'BEN2201'
            expect(response[:node_short_code]).to eq 'BEN'
            expect(response[:node_name]).to       eq 'Benmore'
            expect(response[:price_type]).to      eq 'Average Five Minute'
            expect(response[:date]).to            eq date
            expect(response[:prices].length).to   eq 48

            expected_trading_periods = (1..48).to_a
            expected_times = (1..48).map do |period|
              parse_nz_time(Time.parse("24/03/2015")) + 60 * 30 * (period - 1)
            end
            # Extracted from VCR Cassette
            expected_prices = [94.65, 119.2, 95.83, 88.93, 79.22, 86.11, 93.04, 94.98, 91.94,
              85.17, 84.15, 82.65, 87.36, 76.79, 82.78, 81.94, 82.51, 80.53, 85.88, 79.66,
              83.38, 87.42, 67.57, 77.86, 79.55, 87.6, 86.05, 79.02, 78.52, 72.23, 70.12,
              81.1, 82.06, 85.98, 105.55, 84.85, 84.25, 75.78, 81.12, 68.7, 69.69, 68.63,
              68.63, 67.6, 73.16, 67.76, 69.31, 80.39].reverse

            expect(prices.map{ |price| price[:trading_period] }).to eq expected_trading_periods
            expect(prices.map{ |price| price[:price] }).to          eq expected_prices
            expect(prices.map{ |price| price[:time] }).to           eq expected_times
          end
        end
      end

      context 'when no date parameter is provided' do
        it "requests the prices for the day before yesterday" do
          VCR.use_cassette("BEN2201_5min_24-03-2015") do
            Wits::FiveMinutePrices.five_minute_prices('BEN')
          end
        end
      end

      it 'accepts known node short codes' do
        VCR.use_cassette("BEN2201_5min_24-03-2015") do
          Wits::FiveMinutePrices.five_minute_prices('BEN')
        end
      end

      it 'accepts lower-cased node codes' do
        VCR.use_cassette("BEN2201_5min_24-03-2015") do
          Wits::FiveMinutePrices.five_minute_prices('ben')
        end
      end

      it 'accepts node codes as symbols' do
        VCR.use_cassette("BEN2201_5min_24-03-2015", allow_playback_repeats: true) do
          Wits::FiveMinutePrices.five_minute_prices(:ben)
          Wits::FiveMinutePrices.five_minute_prices(:BEN)
          Wits::FiveMinutePrices.five_minute_prices(:BEN2201)
          Wits::FiveMinutePrices.five_minute_prices(:ben2201)
        end
      end

      it 'accepts a date String object' do
        VCR.use_cassette('BEN2201_5min_25-03-2015') do
          date = '25/03/2015'
          Wits::FiveMinutePrices.five_minute_prices('ben2201', date)
        end
      end

      it 'accepts a Date-like object' do
        VCR.use_cassette('BEN2201_5min_25-03-2015') do
          date = Date.parse('25/03/2015')
          Wits::FiveMinutePrices.five_minute_prices('ben2201', date)
        end
      end

      it 'accepts a Time-like object' do
        VCR.use_cassette('BEN2201_5min_25-03-2015') do
          time = Time.parse('25/03/2015')
          Wits::FiveMinutePrices.five_minute_prices('BEN', time)
        end
      end
    end

    describe 'error' do
      it 'Wits::Error::ParsingError is raised for unexpected CSV formats' do
        response = double('reponse', body: 'a' * 300)
        allow(Wits::Client).to receive(:get).and_return(response)

        expect {
          Wits::FiveMinutePrices.five_minute_prices('ben')
        }.to raise_error(Wits::Error::ParsingError)
      end

      it 'Wits::Error::ResourceNotFound is raised when no data is returned', :vcr do
        expect {
          Wits::FiveMinutePrices.five_minute_prices('ben', Date.parse('1/1/2000'))
        }.to raise_error(Wits::Error::ResourceNotFound)

        expect {
          Wits::FiveMinutePrices.five_minute_prices('ben', Date.parse('1/1/2000'), :average)
        }.to raise_error(Wits::Error::ResourceNotFound)
      end

      errors = %w(
        ConnectionFailed ResourceNotFound TimeoutError ClientError
      )

      errors.each do |error|
        it "Wits::Error::#{error} is raised on Faraday::#{error} error" do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday.const_get(error), 'message')

          expect {
            Wits::FiveMinutePrices.five_minute_prices('ben')
          }.to raise_error(Wits::Error.const_get(error))
        end
      end
    end
  end

  describe '.average_five_minute_prices' do
    before :all do
      Timecop.freeze(Date.parse('26/03/2015'))
    end

    after :all do
      Timecop.return
    end

    it 'calls .five_minute_prices with the :average parameter' do
      expected_date = Date.today - 5
      expect(Wits::FiveMinutePrices).to receive(:five_minute_prices).with('BEN', expected_date, :average)

      Wits::FiveMinutePrices.average_five_minute_prices('BEN', expected_date)
    end

    context 'when no date parameter is provided' do
      it 'requests the prices for the day before yesterday' do
        expected_date = Date.today
        expect(Wits::FiveMinutePrices).to receive(:five_minute_prices).with('HAY', expected_date, :average)

        Wits::FiveMinutePrices.average_five_minute_prices('HAY')
      end
    end
  end

  # Five Minute Price Methods
  expected_node_methods = Hash[
    Wits::Nodes.nodes.map do |node, name|
      prefixes = [
        node.downcase,
        node.downcase.slice(0, 3),
        name.gsub(' ', '_').downcase
      ]

      methods = prefixes.map do |method|
        "#{method}_five_minute_prices".to_sym
      end

      [node, methods]
    end
  ]

  # Average Five Minute Price Methods
  expected_average_node_methods = Hash[
    Wits::Nodes.nodes.map do |node, name|
      prefixes = [
        node.downcase,
        node.downcase.slice(0, 3),
        name.gsub(' ', '_').downcase
      ]

      methods = prefixes.map do |method|
        "#{method}_average_five_minute_prices".to_sym
      end

      [node, methods]
    end
  ]

  describe 'convenience methods' do
    context 'five_minute_prices' do
      expected_node_methods.each do |node, methods|
        methods.each do |method|
          describe ".#{method}" do
            it 'calls .prices with the correct parameters (no date parameter)' do
              expect(Wits::FiveMinutePrices).to receive(:five_minute_prices).with(node)

              Wits::FiveMinutePrices.send(method)
            end

            it 'calls .prices with the correct parameters (with date parameter)' do
              date = Date.parse('1/1/2015')

              expect(Wits::FiveMinutePrices).to receive(:five_minute_prices).with(node, date)

              Wits::FiveMinutePrices.send(method, date)
            end
          end
        end
      end
    end

    context 'average_five_minute_prices' do
      before :all do
        Timecop.freeze(Date.parse('26/03/2015'))
      end

      after :all do
        Timecop.return
      end

      expected_average_node_methods.each do |node, methods|
        methods.each do |method|
          describe ".#{method}" do
            it 'calls .five_minute_prices with the correct parameters (no date parameter)' do
              expected_date = Date.parse('26/03/2015')
              expect(Wits::FiveMinutePrices).to receive(:five_minute_prices).with(node, expected_date, :average)

              Wits::FiveMinutePrices.send(method)
            end

            it 'calls .five_minute_prices with the correct parameters (with date parameter)' do
              date = Date.parse('1/1/2015')

              expect(Wits::FiveMinutePrices).to receive(:five_minute_prices).with(node, date, :average)

              Wits::FiveMinutePrices.send(method, date)
            end
          end
        end
      end
    end
  end

  context 'when extended' do
    before :all do
      class MyClass
        extend Wits::FiveMinutePrices
      end

      Timecop.freeze(Date.parse('25/03/2015'))
    end

    after :all do
      Timecop.return
    end

    all_node_methods = expected_node_methods.values.flatten +
      expected_average_node_methods.values.flatten

    all_node_methods.each do |method|
      it "makes the .#{method} available on the extending Class or Module", :vcr do
        expect(MyClass.send(method)).to eq Wits::FiveMinutePrices.send(method)
      end
    end

    it 'makes the .five_minute_prices available on the extending Class or Module', :vcr do
      expect(MyClass.five_minute_prices('BEN')).to eq Wits::FiveMinutePrices.five_minute_prices('BEN')
    end

    it 'makes the .average_five_min_prices available on the extending Class or Module', :vcr do
      expect(MyClass.average_five_minute_prices('BEN')).to eq Wits::FiveMinutePrices.average_five_minute_prices('BEN')
    end
  end
end
