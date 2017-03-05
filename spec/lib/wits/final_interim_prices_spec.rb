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

      let(:date) { Date.today - 5 }

      subject(:response) { Wits::FinalInterimPrices.prices('BEN2201', date) }
      subject(:price)    { response[:prices].first }

      it 'is able to make a live request' do
        expect(response).to be_a Hash
      end

      it 'returns price information formatted correctly' do
        expect(response[:node_code]).to       eq 'BEN2201'
        expect(response[:node_short_code]).to eq 'BEN'
        expect(response[:node_name]).to       eq 'Benmore'
        expect(response[:price_type]).to      eq 'Final'
        expect(response[:date]).to            eq date
        expect(response[:prices].length).to   be_within(2).of(48)

        expect(price[:time]).to           eq parse_nz_time(Time.parse(date.to_s))
        expect(price[:trading_period]).to eq 1
        expect(price[:price]).to          be_a(Float)
      end
    end

    context 'stubbed request' do
      before :all do
        Timecop.freeze(Date.parse('25/02/2017'))
      end

      after :all do
        Timecop.return
      end

      context 'final prices' do
        it 'returns price information formatted correctly' do
          VCR.use_cassette('BEN2201_22-02-2017') do
            date     = Date.parse('22/02/2017')
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
            expected_prices = [46.74, 45.77, 46, 45.48, 39.46, 43.68, 40.2, 40.31, 42.74, 42.42,
              44.93, 53.46, 45.45, 53.99, 52.26, 53.99, 56.33, 55.88, 51.86, 51.77, 51.49, 51.67,
              50.39, 50.38, 39.01, 37.43, 35.4, 37.59, 37.95, 39.71, 52.63, 51.71, 52.49, 50.76,
              50.69, 48.63, 42.39, 33.98, 33.97, 34.4, 36.74, 45.96, 36.9, 36.69, 37.05, 40.37,
              39.03, 40.53]
            expected_times = (1..48).map do |period|
              parse_nz_time(Time.parse('22/02/2017')) + 60 * 30 * (period - 1)
            end

            expect(prices.map { |price| price[:trading_period] }).to eq expected_trading_periods
            expect(prices.map { |price| price[:price] }).to          eq expected_prices
            expect(prices.map { |price| price[:time] }).to           eq expected_times
          end
        end
      end

      context 'interim prices' do
        it 'returns price information formatted correctly' do
          VCR.use_cassette('BEN2201_interim_28-02-2017') do
            date     = Date.parse('28/02/2017')
            response = Wits::FinalInterimPrices.interim_prices('BEN', date)
            prices   = response[:prices]
            price    = prices.first

            expect(response[:node_code]).to       eq 'BEN2201'
            expect(response[:node_short_code]).to eq 'BEN'
            expect(response[:node_name]).to       eq 'Benmore'
            expect(response[:price_type]).to      eq 'Interim'
            expect(response[:date]).to            eq date
            expect(response[:prices].length).to   eq 48

            expected_trading_periods = (1..48).to_a
            # Extracted from VCR Cassette
            expected_prices = [49.31, 51.28, 51.13, 49.43, 49.22, 49.14, 51.68, 51.67, 51.78,
              51.64, 50.88, 52.6, 53.27, 65.19, 59.75, 70.73, 75.26, 74.85, 68.17, 56.49, 55.04,
              53.55, 48.29, 50.81, 51.2, 48.49, 53.47, 53.79, 49.69, 51.77, 55.65, 55.6, 55.26,
              57.32, 62.66, 61.34, 52.25, 60.14, 59.45, 54.94, 58.34, 62.25, 64.78, 53.66, 53.39,
              56.16, 51.93, 55.48]
            expected_times = (1..48).map do |period|
              parse_nz_time(Time.parse('28/02/2017')) + 60 * 30 * (period - 1)
            end

            expect(prices.map { |price| price[:trading_period] }).to eq expected_trading_periods
            expect(prices.map { |price| price[:price] }).to          eq expected_prices
            expect(prices.map { |price| price[:time] }).to           eq expected_times
          end
        end
      end

      # TODO: We don't have a data sample of a daylight savings day
      # for the new website (next transitions occurs at April 2, 2017)
      # it 'handles daylight savings transitions' do
      #   VCR.use_cassette("BEN2201_05-04-2015") do
      #     date     = Date.parse('05/04/2015')
      #     response = Wits::FinalInterimPrices.prices('BEN', date)
      #     prices   = response[:prices]
      #     price    = prices.first

      #     expect(response[:node_code]).to       eq 'BEN2201'
      #     expect(response[:node_short_code]).to eq 'BEN'
      #     expect(response[:node_name]).to       eq 'Benmore'
      #     expect(response[:price_type]).to      eq 'Final'
      #     expect(response[:date]).to            eq date
      #     expect(response[:prices].length).to   eq 50

      #     expected_trading_periods = (1..50).to_a
      #     # Extracted from VCR Cassette
      #     expected_prices = [85.0, 84.33, 88.74, 99.83, 88.97, 85.0, 82.89, 81.73, 85.0, 85.0,
      #       85.0, 73.12, 80.3, 84.18, 81.88, 85.0, 96.67, 91.13, 93.84, 97.16, 98.99, 80.0, 62.03,
      #       77.29, 60.44, 63.27, 63.1, 63.31, 64.16, 64.72, 60.0, 60.0, 60.0, 60.0, 60.3, 64.6,
      #       66.0, 77.24, 91.12, 101.65, 85.69, 66.26, 66.0, 70.69, 70.17, 66.0, 66.0, 66.0, 66.0, 60.0]
      #     expected_times = (1..50).map do |period|
      #       parse_nz_time(Time.parse('05/04/2015')) + 60 * 30 * (period - 1)
      #     end

      #     expect(prices.map{ |price| price[:trading_period] }).to eq expected_trading_periods
      #     expect(prices.map{ |price| price[:price] }).to          eq expected_prices
      #     expect(prices.map{ |price| price[:time] }).to           eq expected_times
      #   end
      # end

      context 'when no date parameter is provided' do
        it 'requests the prices for the day before yesterday' do
          VCR.use_cassette('BEN2201_22-02-2017') do
            Wits::FinalInterimPrices.prices('BEN')
          end
        end
      end

      it 'accepts known node short codes' do
        VCR.use_cassette('BEN2201_22-02-2017') do
          Wits::FinalInterimPrices.prices('BEN')
        end
      end

      it 'accepts lower-cased node codes' do
        VCR.use_cassette('BEN2201_22-02-2017') do
          Wits::FinalInterimPrices.prices('ben')
        end
      end

      it 'accepts node codes as symbols' do
        VCR.use_cassette('BEN2201_22-02-2017', allow_playback_repeats: true) do
          Wits::FinalInterimPrices.prices(:ben)
          Wits::FinalInterimPrices.prices(:BEN)
          Wits::FinalInterimPrices.prices(:BEN2201)
          Wits::FinalInterimPrices.prices(:ben2201)
        end
      end

      it 'accepts a date String object' do
        VCR.use_cassette('BEN2201_25-02-2017') do
          date = '25/02/2017'
          Wits::FinalInterimPrices.prices('ben2201', date)
        end
      end

      it 'accepts a Date-like object' do
        VCR.use_cassette('BEN2201_25-02-2017') do
          date = Date.parse('25/02/2017')
          Wits::FinalInterimPrices.prices('ben2201', date)
        end
      end

      it 'accepts a Time-like object' do
        VCR.use_cassette('BEN2201_25-02-2017') do
          time = Time.parse('25/02/2017')
          Wits::FinalInterimPrices.prices('BEN', time)
        end
      end
    end

    describe 'error' do
      it 'Wits::Error::ParsingError is raised for unexpected CSV formats' do
        response = double('reponse', body: "a,b,c\n" * 300)
        allow(Wits::Client).to receive(:get).and_return(response)

        expect do
          Wits::FinalInterimPrices.prices('ben')
        end.to raise_error(Wits::Error::ParsingError)
      end

      it 'Wits::Error::ResourceNotFound is raised when no data is returned', :vcr do
        expect do
          Wits::FinalInterimPrices.prices('ben', Date.parse('25/02/2016'))
        end.to raise_error(Wits::Error::ResourceNotFound)
      end

      errors = %w(
        ConnectionFailed ResourceNotFound TimeoutError ClientError
      )

      errors.each do |error|
        it "Wits::Error::#{error} is raised on Faraday::#{error} error" do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday.const_get(error), 'message')

          expect do
            Wits::FinalInterimPrices.prices('ben')
          end.to raise_error(Wits::Error.const_get(error))
        end
      end
    end
  end

  # Final Price Methods
  expected_node_methods = Hash[
    Wits::Nodes.nodes.map do |node, name|
      methods = [
        node.downcase,
        node.downcase.slice(0, 3),
        name.tr(' ', '_').downcase
      ]
      methods.concat methods.map { |method| "#{method}_prices".to_sym }

      [node, methods]
    end
  ]

  # Interim Price Methods
  expected_interim_node_methods = Hash[
    Wits::Nodes.nodes.map do |node, name|
      methods = [
        node.downcase,
        node.downcase.slice(0, 3),
        name.tr(' ', '_').downcase
      ]
      interim_methods = methods.map { |method| "#{method}_interim_prices".to_sym }

      [node, interim_methods]
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
            date = Date.parse('25/02/2017')

            expect(Wits::FinalInterimPrices).to receive(:prices).with(node, date)

            Wits::FinalInterimPrices.send(method, date)
          end
        end
      end
    end

    expected_interim_node_methods.each do |node, methods|
      methods.each do |method|
        describe ".#{method}" do
          it 'calls .interim_prices with the correct parameters (no date parameter)' do
            expect(Wits::FinalInterimPrices).to receive(:interim_prices).with(node)

            Wits::FinalInterimPrices.send(method)
          end

          it 'calls .interim_prices with the correct parameters (with date parameter)' do
            date = Date.parse('25/02/2017')

            expect(Wits::FinalInterimPrices).to receive(:interim_prices).with(node, date)

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

      Timecop.freeze(Date.parse('27/02/2017'))
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

    it 'makes the .interim_prices available on the extending Class or Module', :vcr do
      expect(MyClass.interim_prices('BEN')).to eq Wits::FinalInterimPrices.interim_prices('BEN')
    end
  end
end
