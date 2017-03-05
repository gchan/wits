require 'spec_helper'

describe Wits do
  it 'has a version number' do
    expect(Wits::VERSION).not_to be nil
  end

  describe 'extended Modules' do
    subject { Wits.singleton_class.included_modules }

    it 'extends Wits::Nodes' do
      expect(subject).to include Wits::Nodes
    end

    it 'extends Wits::FinalInterimPrices' do
      expect(subject).to include Wits::FinalInterimPrices
    end

    it 'extends Wits::FiveMinutePrices' do
      expect(subject).to include Wits::FiveMinutePrices
    end
  end

  describe 'extended methods' do
    before :all do
      Timecop.freeze(Date.parse('26/02/2017'))
    end

    after :all do
      Timecop.return
    end

    it 'from Wits::Nodes are available' do
      expect(Wits.nodes).to eq Wits::Nodes.nodes
      expect(Wits.node_names).to eq Wits::Nodes.node_names
      expect(Wits.node_short_codes).to eq Wits::Nodes.node_short_codes
    end

    it 'from Wits::FinalInterimPrices are available', :vcr do
      expect(Wits.prices('ben')).to eq Wits::FinalInterimPrices.prices('ben')

      expect(Wits.hly2201).to eq Wits::FinalInterimPrices.hly2201
      expect(Wits.hay).to eq Wits::FinalInterimPrices.hay
      expect(Wits.halfway_bush).to eq Wits::FinalInterimPrices.halfway_bush

      expect(Wits.hly2201_prices).to eq Wits::FinalInterimPrices.hly2201_prices
      expect(Wits.hay_prices).to eq Wits::FinalInterimPrices.hay_prices
      expect(Wits.halfway_bush_prices).to eq Wits::FinalInterimPrices.halfway_bush_prices
    end

    it 'from Wits::FiveMinutePrices are available', :vcr do
      expect(Wits.average_five_minute_prices('ben')).to eq Wits::FiveMinutePrices.average_five_minute_prices('ben')
      expect(Wits.five_minute_prices('ben')).to eq Wits::FiveMinutePrices.five_minute_prices('ben')

      expect(Wits.hly2201_five_minute_prices).to eq Wits::FiveMinutePrices.hly2201_five_minute_prices
      expect(Wits.hay_five_minute_prices).to eq Wits::FiveMinutePrices.hay_five_minute_prices
      expect(Wits.halfway_bush_five_minute_prices).to eq Wits::FiveMinutePrices.halfway_bush_five_minute_prices

      expect(Wits.hly2201_average_five_minute_prices).to eq Wits::FiveMinutePrices.hly2201_average_five_minute_prices
      expect(Wits.hay_average_five_minute_prices).to eq Wits::FiveMinutePrices.hay_average_five_minute_prices
      expect(Wits.halfway_bush_average_five_minute_prices).to eq Wits::FiveMinutePrices.halfway_bush_average_five_minute_prices
    end
  end
end
