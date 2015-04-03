module RequestHelpers
  def allow_live_requests
    VCR.turn_off!
    WebMock.allow_net_connect!
  end

  def disable_live_requests
    WebMock.disable_net_connect!
    VCR.turn_on!
  end
end
