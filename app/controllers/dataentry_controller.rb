class DataentryController < ApplicationController

  require "./api-wrapper/open_weather.rb"
  OpenWeather::init("0c5e74401870eaa1f6872f30f3d329d3", "http://api.openweathermap.org/data/2.5/weather")

  def index

    if (!logged_in?)
      render_error(422)
      return
    end

    ext = current_user

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

    ext = current_user
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
      mood.overcast = OpenWeather::get_weather_data_for_city(mood.city).clouds

      keep_city = params[:keep_city] == "1";
      keep_sleep = params[:keep_sleep] == "1";
      keep_exercise = params[:keep_exercise] == "1";

    rescue Exception => e
      puts(e)
      render_error(500)
      return
    end

    ext.defaultCity = mood.city;
    if (keep_city)
      ext.update_attribute(:defaultCity, mood.city);
    end
    if (keep_sleep)
      ext.update_attribute(:defaultSleep, mood.sleep);
    end
    if (keep_exercise)
      ext.update_attribute(:defaultExercise, mood.exercise);
    end

    ext.update_attribute(:lastEntryTime, currentUnixTime());

    mood.save()

    redirect_to("/dataentry/index/?message_banner=Thank you for entering your data!")

  end

end
