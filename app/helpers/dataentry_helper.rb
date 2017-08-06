
module DataentryHelper

=begin
	Description: Retreives the current number of seconds
               Which have transpired since the unix
               epoch

	parameters:
    (none)

=end
  def currentUnixTime()
    return DateTime::now.to_i
  end

=begin
	Description: Gets the amount of time the user must
               wait before entering an data point
               after having entered a previous point

	parameters:
		(none)

=end
  def neccessaryEntryDelay()
    return 10800  #TODO: Uncomment (3 hours)
    #return 1
  end

end
