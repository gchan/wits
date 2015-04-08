# wits
[![Gem Version](https://badge.fury.io/rb/wits.svg)](http://badge.fury.io/rb/wits) [![Dependency Status](https://gemnasium.com/gchan/wits.svg?branch=master)](https://gemnasium.com/gchan/wits) ![License](https://img.shields.io/badge/license-MIT-blue.svg)

[![Build Status](https://travis-ci.org/gchan/wits.svg?branch=master)](https://travis-ci.org/gchan/wits) [![Coverage Status](https://coveralls.io/repos/gchan/wits/badge.svg?branch=master)](https://coveralls.io/r/gchan/wits?branch=master) [![Code Climate](https://codeclimate.com/github/gchan/wits/badges/gpa.svg)](https://codeclimate.com/github/gchan/wits)

Retrieve electricity data from [WITS Free to air](http://electricityinfo.co.nz/) via a friendly Ruby interface.

WITS (Wholesale and information trading system) currently does not provide a public API but data can be retrieved through web forms and file downloads.

This client library interfaces with WITS to make data retrieval and formatting a breeze.

#### Quick Example

```ruby
Wits.benmore

=> {:node_code=>"BEN2201",
 :node_short_code=>"BEN",
 :node_name=>"Benmore",
 :price_type=>"Final",
 :date=>#<Date: 2015-04-01 ((2457114j,0s,0n),+0s,2299161j)>,
 :prices=>
  [{:time=>2015-04-01 00:00:00 +1300, :trading_period=>1, :price=>95.82},
   {:time=>2015-04-01 00:30:00 +1300, :trading_period=>2, :price=>90.24},
   ...
  ]
 }
```

See the 'Usage' section for more examples.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wits'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wits


## Supported Ruby versions
wits supports MRI Ruby 1.9+ and the JRuby and Rubinius equivalent. The specific Ruby versions we build and test on can be found at [TravisCI](https://travis-ci.org/gchan/wits).

## Usage

wits can retrieve [Final/Interim Prices](http://electricityinfo.co.nz/comitFta/ftaPage.pricesMain) and [5 Minute Prices](http://electricityinfo.co.nz/comitFta/five_min_prices.main) for a given node and date.

#### Final/Interim Prices
Half-hourly final/interim prices can be retrieved in the following ways:

```ruby
Wits.prices('ben2201') # Defaults to the day before yesterday
Wits.prices('BEN', '29/03/2015')
Wits.prices('ben', Time.parse('29/03/2015 13:37'))
Wits.prices('BEN2201', Date.parse('29/03/2015'))
```

If no date-like argument is provided, data for the day before yesterday will be retrieved.

There are convenient methods for known nodes. Use `Wits::Nodes.nodes` to see a list of nodes this library is aware of.

```ruby
Wits.ben_prices
Wits.benmore_prices('29/03/2015')
Wits.ben2201_prices(Time.parse('29/03/2015 13:37'))
```

For Final/Interim prices, there are shorter methods without the `_prices` suffix.

```ruby
Wits.ben
Wits.benmore
Wits.ben2201
```

All of the above methods can be called on `Wits::FinalInterimPrices`.

```ruby
Wits::FinalInterimPrices.benmore_prices
```

#### 5 Minute Prices
Five minute electricity prices can be retrieved in a similar fashion:

```ruby
Wits.five_minute_prices('hay2201') # Defaults to the day before yesterday
Wits.five_minute_prices('HAY', '29/03/2015')
Wits.five_minute_prices('hay', Time.parse('29/03/2015 13:37'))
Wits.five_minute_prices('HAY2201', Date.parse('29/03/2015'))
```

If no date-like argument is provided, data for today's date will be retrieved.

There are convenient methods for known nodes. Use `Wits::Nodes.nodes` to see a list of nodes this library is aware of.

```ruby
Wits.hay_five_minute_prices
Wits.haywards_five_minute_prices('29/03/2015')
Wits.hay2201_five_minute_prices(Time.parse('29/03/2015 13:37'))
```

All of the above methods can be called on `Wits::FiveMinutePrices`.

```ruby
Wits::FiveMinutePrices.hay_five_minute_prices
```

#### Average 5 Minute Prices
Average 5 Minute Prices can be retrieved by passing the `:average` argument (in conjunction with a date argument) to the above 5 Minute Prices methods:

```ruby
Wits.five_minute_prices('HAY', '29/03/2015', :average)
Wits.haywards_five_minute_prices('29/03/2015', :average)
Wits.hay2201_five_minute_prices(Date.parse('29/03/2015'), :average)
```

There is also a method to retrieve average prices without passing through an `:average` argument.

```ruby
Wits.average_five_minute_prices('hay2201')
Wits.average_five_minute_prices('HAY', '29/03/2015')
```

If no date-like argument is provided, data for today's date will be retrieved.

Again there are convenient methods for known nodes. The `:average` argument is not required.

```ruby
Wits.hay_average_five_minute_prices
Wits.haywards_average_five_minute_prices('29/03/2015')
Wits.hay2201_average_five_minute_prices(Date.parse('29/03/2015'))
```

All of the above methods can be called on `Wits::FiveMinutePrices`.

```ruby
Wits::FiveMinutePrices.hay_average_five_minute_prices
Wits::FiveMinutePrices.average_five_minute_prices('hay2201')
```

#### Errors

In addition to the usual Ruby errors and exceptions, wits can raise the following errors:

* `Wits::Error::ClientError`
* `Wits::Error::ConnectionFailed`
* `Wits::Error::TimeoutError`
* `Wits::Error::ResourceNotFound`
* `Wits::Error::ParsingError`

All of the above error classes inherit `Wits::Error::ClientError`, `Wits::Error`, and `StandardError`.

#### Time Zones

wits will respect the local (server) time zone and correctly return Time instances in the local time zone. Daylight savings adjustments are accounted for.

For instance, if the NZT time for the first trading period is `2015-03-29 00:00:00 +1300`, wits will return `2015-03-28 07:00:00 -0400` for an 'America/New_York' local time zone.

`Date` instances are always in the context of New Zealand.

#### Known Issues

There is no reliable method (without web scraping) of distinguishing interim half-hourly prices from final prices. Until the WITS CSV file correctly reports the price type, the half-hourly prices are always reported as 'Final'

The CSV files for five minute prices and average five minute prices are missing some data rows on days when daylight savings ends. As a result, wits will return incomplete (and possibly invalid) data for dates when daylight savings ends (e.g. 5 April 2015).

## Possible Enhancements

WITS also provides [Price Index](http://electricityinfo.co.nz/comitFta/price_index.summary) and [Demand](http://electricityinfo.co.nz/comitFta/ftaPage.demand) information which could be retrieved and delivered through a client library. Pull Requests are welcome!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

Run `bin/guard` to automatically launch specs when files are modified.

Run `bundle exec rake spec` to manually launch specs.

## Contributing

1. Fork it ( https://github.com/gchan/wits/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

wits is Copyright (c) 2015 Gordon Chan and is released under the MIT License. It is free software, and may be redistributed under the terms specified in the LICENSE file.