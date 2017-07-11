class DataentryController < ApplicationController

  def index

    if (!logged_in?)
      render_error(422)
      return
    end

    ext = Userext.find(current_user.id);

    if (ext == nil)
      render_error(500)
    end

    @nextAvailableTime = ext.lastEntryTime + neccessaryEntryDelay

    if (@nextAvailableTime > currentUnixTime)
      @remainingTimeToInput = @nextAvailableTime - currentUnixTime
    else
      @remainingTimeToInput = 0
    end

    @defaultCity = ext.defaultCity
    @sleep = ext.defaultSleep
    @exercise = ext.defaultExercise;

    @startMood = Random::rand(3) + 1

  end


  # Intended for post only
  def add_data

    if (!logged_in?)
      render_error(422)
      return
    end

    ext = Userext.find(current_user.id)
    if (ext == nil)
      render_error(500)
    end

    if (ext.lastEntryTime + neccessaryEntryDelay > currentUnixTime)
      render_error(403)
      return
    end

    mood = Mood::new

    begin
      mood.userid = current_user.id;
      mood.city = params[:city]
      mood.mood = Integer(params[:mood])
      mood.sleep = Float(params[:sleep]) * 60
      mood.exercise = Float(params[:exercise]) * 60
      mood.overcast = Random::rand(100)            #TODO: must get data from API

      keep_city = params[:keep_city] == "1";
      keep_sleep = params[:keep_sleep] == "1";
      keep_exercise = params[:keep_exercise] == "1";

    rescue Exception => e
      puts(e)
      render_error(500)
      return
    end

    if (keep_city)
      ext.defaultCity = mood.city;
    end
    if (keep_sleep)
      ext.defaultSleep = mood.sleep;
    end
    if (keep_exercise)
      ext.defaultExercise = mood.exercise;
    end

    ext.lastEntryTime = currentUnixTime()
    ext.save()

    mood.save()

    redirect_to("/dataentry/index/?message_banner=Thank you for entering your data!")

  end

end
