module Wits
  module PriceCodes
    FINAL = :final
    INTERIM = :interim
    AVERAGE = :average
    FIVE_MINUTE = :five_minute
    FORECAST = :forecast

    PRICE_TYPES = {
      FINAL => 'F',
      INTERIM => 'T',
      AVERAGE => '5',
      FIVE_MINUTE => 'I',
      FORECAST => 'A'
    }.freeze

    PRICE_DESCRIPTION = {
      FINAL => 'Final',
      INTERIM => 'Interim',
      AVERAGE => 'Average Five Minute',
      FIVE_MINUTE => 'Five Minute',
      FORECAST => 'Forecast'
    }.freeze
  end
end
