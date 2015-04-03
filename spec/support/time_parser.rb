module TimeParser
  def parse_nz_time(time)
    TZInfo::Timezone.get('Pacific/Auckland').local_to_utc(time)
  end
end
