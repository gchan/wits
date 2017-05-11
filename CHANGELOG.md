1.1.1 / 2017-05-011
------
* Change URL from www2.electricityinfo.co.nz to electricityinfo.co.nz
* Update runtime and development dependencies

1.1.0 / 2017-03-05
------
* Dropping official support for Ruby versions 2.1 and below.
* Use the new site (currently available on www2.electricityinfo.co.nz)
* Interim prices is supported in the new site

1.0.2 / 2016-09-23
------
* Use HTTPS on electricityinfo.co.nz - Andrew Pett

1.0.1 / 2015-12-18
------
* Fix issue with 400..600 responses not resulting in an Error being raised by Faraday. Resolved by using the `Faraday::Response::RaiseError` middleware.

1.0.0 / 2015-04-19
------
Official 1.0.0 release (no changes)

0.3.0 / 2015-04-09
------
* Changed the default date to be NZ's current date for five minute prices and averaged five minute prices.
* Updated the data format to handle NZ daylight savings.
* Updated the default dates to be agnostic of local/server time zones.

0.2.0 / 2015-04-03
------
No changes

0.1.0 / 2015-04-03
------
First release