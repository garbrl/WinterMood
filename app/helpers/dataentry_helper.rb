
module DataentryHelper

  def currentUnixTime()
    return DateTime::now.to_i
  end

  def neccessaryEntryDelay()
    #return 10800  #TODO: Uncomment (3 hours)
    return 60
  end

end
