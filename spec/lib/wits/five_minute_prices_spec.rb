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
          expect(response[:prices].length).to   be_within(2 * 6).of(48 * 6)

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
        Timecop.freeze(Date.parse('28/02/2017'))
      end

      after :all do
        Timecop.return
      end

      context 'non-averaged prices' do
        it 'returns price information formatted correctly' do
          VCR.use_cassette('BEN2201_5min_27-02-2017') do
            date     = Date.parse('27/02/2017')
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
            expected_times = (1..48 * 6).map do |period|
              parse_nz_time(Time.parse('27/02/2017')) + 60 * 5 * (period - 1)
            end
            # Extracted from VCR Cassette
            expected_prices = [49.63, 49.62, 37.77, 26.7, 26.28, 16.61, 49.8, 38.7, 38.7, 38.63, 38.62, 18.45,
              50.2, 50.19, 49.91, 49.8, 38.7, 38.63, 49.81, 49.81, 49.8, 49.79, 48.66, 38.7, 38.61, 38.62, 38.61,
              18.16, 17.62, 17.61, 17.6, 17.61, 17.61, 17.6, 17.61, 17.6, 17.61, 17.6, 17.62, 17.61, 17.34, 17.29,
              17.32, 17.53, 17.61, 17.61, 17.62, 17.63, 15.81, 15.83, 15.83, 15.83, 15.93, 16.18, 13.04, 14.93,
              15.52, 15.78, 15.92, 17.33, 17.94, 39.7, 49, 49.87, 50.26, 51.75, 17.02, 24.62, 24.64, 45.29, 47.7,
              51.91, 10.27, 16.64, 23.6, 39.85, 45.55, 51.83, 16.65, 23.83, 44.53, 45.38, 53.82, 58.6, 22.03, 22.41,
              41.81, 43.78, 51.98, 53.18, 39.95, 42.34, 44.02, 44.06, 44.08, 48.4, 54.03, 55.85, 54.1, 53.26, 52.57,
              61.87, 68.28, 61.93, 58.91, 58.87, 58.88, 57.97, 56.72, 48.42, 47.36, 56.65, 57.02, 56.77, 48.46, 48.39,
              48.39, 48.46, 48.46, 48.39, 49.32, 48.48, 48.46, 48.48, 48.48, 48.53, 50.08, 50.11, 50.16, 50.16, 50.16,
              43.13, 47.18, 61.5, 61.5, 62.05, 61.5, 61.53, 61.37, 61.37, 61.37, 61.5, 61.36, 61.37, 61.37, 46.58,
              43.08, 46.17, 41.29, 60.99, 59.09, 59.74, 59.76, 61.53, 62.73, 61.53, 61.51, 61.53, 62.72, 61.53, 39.94,
              39.07, 61.51, 60.96, 60.15, 60.14, 59.91, 60.14, 59.9, 60.98, 61.66, 61.66, 61.66, 60.56, 54.21, 61.48,
              61.51, 61.51, 61.51, 61.5, 61.5, 61.5, 61.5, 61.47, 63.77, 67.31, 66.63, 71.41, 72.64, 72.39, 72.75,
              72.75, 72.8, 72.8, 72.37, 72.37, 72.38, 56.25, 58.35, 72.73, 72.8, 72.8, 72.8, 72.8, 67.52, 65.5, 65.51,
              67.56, 70.62, 71.38, 66.3, 65.52, 65.52, 64.42, 64.42, 59.09, 56.87, 53.89, 53.89, 53.33, 53.33, 53.26,
              55.57, 54.63, 54.63, 52.25, 52.25, 53.78, 58.67, 58.05, 55.92, 55.18, 54.79, 53.91, 53.84, 53.65, 53.59,
              53.59, 53.59, 53.59, 54.64, 54.64, 54.09, 54.99, 58.33, 59.13, 63.04, 63.04, 62.93, 63, 61, 57.91, 59.12,
              55.29, 54.37, 52.48, 51.77, 51.76, 53.77, 53.79, 52.91, 51.73, 50.58, 49.31, 53.89, 46.57, 43.84, 39.21,
              38.5, 24.47, 47.6, 47.6, 44.78, 39.02, 27.45, 24.91, 47.33, 47.8, 46.11, 44.42, 43.41, 25.54, 46.08, 44.12,
              42.74, 25.16, 25.07, 24.27]

            expect(prices.map { |price| price[:trading_period] }).to eq expected_trading_periods
            expect(prices.map { |price| price[:price] }).to          eq expected_prices
            expect(prices.map { |price| price[:time] }).to           eq expected_times
          end
        end
      end

      context 'averaged prices' do
        it 'returns price information formatted correctly' do
          VCR.use_cassette('BEN2201_average_5min_28-02-2017') do
            date     = Date.parse('28/02/2017')
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
              parse_nz_time(Time.parse('28/02/2017')) + 60 * 30 * (period - 1)
            end
            # Extracted from VCR Cassette
            expected_prices = [48.18, 48.76, 50.75, 49.39, 49.19, 48.74, 50.84, 49.79, 50.98,
              50.83, 53.46, 50.52, 54.31, 62.01, 60.64, 70.89, 74.11, 70.65, 67.27, 61.26,
              56.1, 65.05, 77.77, 79.42, 80.29, 76.77, 80.98, 57.32, 53.46, 52.35, 55.42,
              55.8, 54.44, 63.77, 71.94, 68.55, 58.35, 58.85, 58.5, 57.77, 58.43, 63.4,
              67.95, 54.94, 53.08, 55.26, 52.45, 55.41]

            expect(prices.map { |price| price[:trading_period] }).to eq expected_trading_periods
            expect(prices.map { |price| price[:price] }).to          eq expected_prices
            expect(prices.map { |price| price[:time] }).to           eq expected_times
          end
        end
      end

      context 'when no date parameter is provided' do
        it 'requests the prices for the day before yesterday' do
          VCR.use_cassette('BEN2201_5min_28-02-2017') do
            Wits::FiveMinutePrices.five_minute_prices('BEN')
          end
        end
      end

      it 'accepts known node short codes' do
        VCR.use_cassette('BEN2201_5min_28-02-2017') do
          Wits::FiveMinutePrices.five_minute_prices('BEN')
        end
      end

      it 'accepts lower-cased node codes' do
        VCR.use_cassette('BEN2201_5min_28-02-2017') do
          Wits::FiveMinutePrices.five_minute_prices('ben')
        end
      end

      it 'accepts node codes as symbols' do
        VCR.use_cassette('BEN2201_5min_28-02-2017', allow_playback_repeats: true) do
          Wits::FiveMinutePrices.five_minute_prices(:ben)
          Wits::FiveMinutePrices.five_minute_prices(:BEN)
          Wits::FiveMinutePrices.five_minute_prices(:BEN2201)
          Wits::FiveMinutePrices.five_minute_prices(:ben2201)
        end
      end

      it 'accepts a date String object' do
        VCR.use_cassette('BEN2201_5min_28-02-2017') do
          date = '28/02/2017'
          Wits::FiveMinutePrices.five_minute_prices('ben2201', date)
        end
      end

      it 'accepts a Date-like object' do
        VCR.use_cassette('BEN2201_5min_28-02-2017') do
          date = Date.parse('28/02/2017')
          Wits::FiveMinutePrices.five_minute_prices('ben2201', date)
        end
      end

      it 'accepts a Time-like object' do
        VCR.use_cassette('BEN2201_5min_28-02-2017') do
          time = Time.parse('28/02/2017')
          Wits::FiveMinutePrices.five_minute_prices('BEN', time)
        end
      end
    end

    describe 'error' do
      it 'Wits::Error::ParsingError is raised for unexpected CSV formats' do
        response = double('reponse', body: "a,b,c\n" * 300)
        allow(Wits::Client).to receive(:get).and_return(response)

        expect do
          Wits::FiveMinutePrices.five_minute_prices('ben')
        end.to raise_error(Wits::Error::ParsingError)
      end

      it 'Wits::Error::ResourceNotFound is raised when no data is returned', :vcr do
        expect do
          Wits::FiveMinutePrices.five_minute_prices('ben', Date.parse('28/02/2015'))
        end.to raise_error(Wits::Error::ResourceNotFound)

        expect do
          Wits::FiveMinutePrices.five_minute_prices('ben', Date.parse('28/02/2015'), :average)
        end.to raise_error(Wits::Error::ResourceNotFound)
      end

      errors = %w(
        ConnectionFailed ResourceNotFound TimeoutError ClientError
      )

      errors.each do |error|
        it "Wits::Error::#{error} is raised on Faraday::#{error} error" do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday.const_get(error), 'message')

          expect do
            Wits::FiveMinutePrices.five_minute_prices('ben')
          end.to raise_error(Wits::Error.const_get(error))
        end
      end
    end
  end

  describe '.average_five_minute_prices' do
    before :all do
      Timecop.freeze(Date.parse('28/02/2017'))
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
        name.tr(' ', '_').downcase
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
        name.tr(' ', '_').downcase
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
              date = Date.parse('28/02/2017')

              expect(Wits::FiveMinutePrices).to receive(:five_minute_prices).with(node, date)

              Wits::FiveMinutePrices.send(method, date)
            end
          end
        end
      end
    end

    context 'average_five_minute_prices' do
      before :all do
        Timecop.freeze(Date.parse('28/02/2017'))
      end

      after :all do
        Timecop.return
      end

      expected_average_node_methods.each do |node, methods|
        methods.each do |method|
          describe ".#{method}" do
            it 'calls .five_minute_prices with the correct parameters (no date parameter)' do
              expected_date = Date.parse('28/02/2017')
              expect(Wits::FiveMinutePrices).to receive(:five_minute_prices).with(node, expected_date, :average)

              Wits::FiveMinutePrices.send(method)
            end

            it 'calls .five_minute_prices with the correct parameters (with date parameter)' do
              date = Date.parse('28/02/2017')

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

      Timecop.freeze(Date.parse('28/02/2017'))
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
