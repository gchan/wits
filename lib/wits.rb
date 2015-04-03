require 'faraday'

require 'wits/version'
require 'wits/nodes'
require 'wits/final_interim_prices'
require 'wits/five_minute_prices'

module Wits
  extend Wits::Nodes
  extend Wits::FinalInterimPrices
  extend Wits::FiveMinutePrices
end
