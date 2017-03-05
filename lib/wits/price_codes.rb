module Wits
  module PriceCodes
    FINAL = :final
    INTERIM = :interim
    AVERAGE = :average
    FIVE_MINUTE = :five_minute

    PRICE_TYPES = {
      FINAL => 'F',
      INTERIM => 'T',
      AVERAGE => '5',
      FIVE_MINUTE => 'I'
    }.freeze

    PRICE_DESCRIPTION = {
      FINAL => 'Final',
      INTERIM => 'Interim',
      AVERAGE => 'Average Five Minute',
      FIVE_MINUTE => 'Five Minute'
    }.freeze
  end
end
