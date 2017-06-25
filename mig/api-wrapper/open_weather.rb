# File:     open_weather.rb
# Module:   OpenWeather
# Author:   Mitchell Larson
# Purpose:  Wrapper module for the Open Weather Map web-API

require "net/http"
require "json"

module OpenWeather


  #######################
  #       Fields        #
  #######################

  @@api_key = nil
  @@target_address = nil
  @@initalized = false




  #######################
  #       Methods       #
  #######################


  # init (api_key, target_address)
  #
  # param:   api_key,         type: String
  # param:   target_address,  type: String
  #
  # Initializes the OpenWeather module with
  # the provided API key, and target address.
  #
  # This must be called before any other
  # module method
  #
  def self.init(api_key, target_address)
    if (!api_key.is_a?(String))
      raise ArgumentError::new("Invalid argument: 'api_key' must be a string")
    elsif (!target_address.is_a?(String))
      raise ArgumentError::new("Invalid argument: 'target_address' must be a string")
    end

    @@api_key = api_key
    @@target_address = target_address
    @@initalized = true
  end


  # get_weather_data_for_city (city)
  #
  # param:   city,          type: String
  #
  # Gets the weather data for the provided
  # city. This method makes a call to the
  # API
  #
  def self.get_weather_data_for_city(city)
    check()
    if (!city.is_a?(String))
      raise ArgumentError::new("Invalid argument: 'city' must be a string")
    end

    response_string = read_api(format_city(city))
    return Data.parse_from_response(response_string)
  end


  # get_weather_data_for_coordinates (lon, lat)
  #
  # param:      lon,         type: Integer | Float
  # param:      lat,         type: Integer | Float
  #
  # Gets the weather data for the provided
  # longitude (param 'lon') and latitude (param 'lat').
  # This method makes a call to the API
  #
  def self.get_weather_data_for_coordinates(lon, lat)
    check()
    if (
      (!lon.is_a?(Integer) && !lon.is_a?(Float)) ||
      (!lat.is_a?(Integer) && !lat.is_a?(Float))
      )
      raise ArgumentError::new("Invalid argument(s): 'lon' and 'lat' must be numbers")
    end

    response_string = read_api(format_coordinates(lon, lat))
    return Data.parse_from_response(response_string)
  end


  def self.check()
    if (!@@initalized)
      raise RuntimeError::new("Must initialize OpenWeather module")
    end
  end
  private_class_method :check


  def self.format_city(city)
    return sprintf("%s?q=%s&APPID=%s", @@target_address, city, @@api_key)
  end
  private_class_method :format_city


  def self.format_coordinates(lon, lat)
    return sprintf("%s?lon=%s&lat=%s&APPID=%s", @@target_address, lon, lat, @@api_key)
  end
  private_class_method :format_coordinates



  def self.read_api(call_string)

    begin
      uri = URI(call_string)
      response_string = Net::HTTP::get(uri)
      return response_string
    rescue Exception
      raise OpenWeatherException::new("Failed to connect with API")
    end
  end
  private_class_method :read_api






  #######################
  #       Classes       #
  #######################


  # OpenWeatherException
  #
  # A class which extends the Exception
  # class within the base Ruby library.
  # Errors related to calling the API
  # will be thrown as this class
  #
  class OpenWeatherException < Exception
    def initialize(message)
      super(message)
    end
  end


  # Data
  #
  # A class representing the data set
  # received from the API after querying
  # if for the weather at some position.
  #
  class Data


    # parse_from_response (response)
    #
    # param:  response, type: String
    #
    # Parses the provided string as a JSON
    # object to create a OpenWeather data set
    #
    def self.parse_from_response(response)

      begin
        root = JSON::parse(response)
      rescue JSON::ParserError => e
        raise OpenWeatherException::new("Failed to parse JSON data");
      end

      begin

        # coord
        lon = root["coord"]["lon"]
        lat = root["coord"]["lat"]

        # weather
        weather_specs = WeatherSpec::parse_weather_spec_array_from_json(root["weather"])

        base = root["base"]

        # main
        temp = root["main"]["temp"]
        pressure = root["main"]["pressure"]
        humidity = root["main"]["humidity"]
        temp_min = root["main"]["temp_min"]
        temp_max = root["main"]["temp_max"]

        visibility = root["visibility"]

        # wind
        wind_speed = root["wind"]["speed"]
        wind_degrees = root["wind"]["deg"]

        # clouds
        clouds = root["clouds"]["all"]

        # rain
        if (root["rain"])
          rain = root["rain"]["3h"]
        else
          rain = 0.0
        end

        # snow
        if (root["snow"])
          snow = root["snow"]["3h"]
        else
          snow = 0.0
        end

        dt = root["dt"]

        # sys
        sunrise = root["sys"]["sunrise"]
        sunset = root["sys"]["sunset"]

      rescue Excetion
        raise OpenWeatherException::new("Unexpected JSON structure")
      end


      return Data::new(
        lon,
        lat,
        weather_specs,
        base,
        temp,
        pressure,
        humidity,
        temp_min,
        temp_max,
        visibility,
        wind_speed,
        wind_degrees,
        clouds,
        rain,
        snow,
        dt,
        sunrise,
        sunset
        )
    end


    def initialize(
      lon,
      lat,
      weather_specs,
      base,
      temp,
      pressure,
      humidity,
      temp_min,
      temp_max,
      visibility,
      wind_speed,
      wind_degrees,
      clouds,
      rain,
      snow,
      dt,
      sunrise,
      sunset
      )

      @lon = lon
      @lat = lat
      @weather_specs = weather_specs
      @base = base
      @temp = temp
      @pressure = pressure
      @humidity = humidity
      @temp_min = temp_min
      @temp_max = temp_max
      @visibility = visibility
      @wind_speed = wind_speed
      @wind_degrees = wind_degrees
      @clouds = clouds
      @rain = rain
      @snow = snow
      @dt = dt
      @sunrise = sunrise
      @sunset = sunset

    end


    # Accessor Methods

    def lon
      return @lon
    end

    def lat
      return @lat
    end

    def weather_specs
      ret = Array::new()
      @weather_specs.each do |e|
        ret.push(e)
      end

      return ret
    end

    def base
      return @base
    end

    def temp
      return @temp
    end

    def pressure
      return @pressure
    end

    def humidity
      return @humidity
    end

    def temp_min
      return @temp_min
    end

    def temp_max
      return @temp_max
    end

    def visibility
      return @visibility
    end

    def wind_speed
      return @wind_speed
    end

    def wind_degrees
      return @wind_degrees
    end

    def clouds
      return @clouds
    end

    def rain
      return @rain
    end

    def snow
      return @snow
    end

    def dt
      return @dt
    end

    def sunrise
      return @sunrise
    end

    def sunset
      return @sunset
    end


    # Super-Object overrides

    # override: Object.to_s
    def to_s
      return sprintf(
        "{lon=%s; lat=%s; weather_specs=%s; base='%s'; temp=%s; pressure=%s; humidity=%s; temp_min=%s; temp_max=%s; visibility=%s; wind_speed=%s; wind_degrees=%s; clouds=%s; rain=%s; snow=%s; dt=%s; sunrise=%s; sunset=%s}",
        @lon,
        @lat,
        WeatherSpec::array_to_string(@weather_specs),
        @base,
        @temp,
        @pressure,
        @humidity,
        @temp_min,
        @temp_max,
        @visibility,
        @wind_speed,
        @wind_degrees,
        @clouds,
        @rain,
        @snow,
        @dt,
        @sunrise,
        @sunset
        )
    end

=begin

@lon = lon
@lat = lat
@weather_specs = weather_specs
@base = base
@temp = temp
@pressure = pressure
@humidity = humidity
@temp_min = temp_min
@temp_max = temp_max
@visibility = visibility
@wind_speed = wind_speed
@wind_degrees = wind_degrees
@clouds = clouds
@rain = rain
@snow = snow
@dt = dt
@sunrise = sunrise
@sunset = sunset

=end

  end

  # WeatherSpec
  #
  # A class whose objects each represent
  # a single specification of a weather
  # type or event. Each Data set received
  # from the API may contain multiple
  # WeatherSpec objects
  #
  class WeatherSpec

    # parse_weather_spec_array_from_json (array)
    #
    # param:   array, type: Array
    #
    # Parses the JSON elements of the array
    # and returns an array of WeatherSpec objects
    #
    def self.parse_weather_spec_array_from_json(array)

      ret = Array::new()

      array.each do |root|
        ret.push(
          WeatherSpec::new(
            root["id"],
            root["main"],
            root["description"],
            root["icon"]
            )
          )
      end

      return ret
    end

    def self.array_to_string(array)

      if (array.size == 0)
        return "[]"
      end

      return_string = array[0].to_s

      for k in 1...array.size
        return_string = sprintf("%s,%s", return_string, array[k].to_s)
      end

      return sprintf("[%s]", return_string)
    end


    def initialize(
      id,
      main,
      description,
      icon
      )

      @id = id
      @main = main
      @description = description
      @icon = icon

    end


    # Accessor Methods

    def id
      return @id
    end

    def main
      return @main
    end

    def desription
      return @description
    end

    def icon
      return @icon
    end


    # Super-Object overrides

    # override:  Object.to_s()
    def to_s()
      return sprintf("{id='%s'; main='%s'; description='%s'; icon='%s'}", @id, @main, @description, @icon)
    end


  end

end
