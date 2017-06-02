#!/usr/bin/ruby


require "./open_weather"

OpenWeather::init("0c5e74401870eaa1f6872f30f3d329d3", "http://api.openweathermap.org/data/2.5/weather")

city_string = "Vancouver"

printf("Querying weather for '%s'... ", city_string)
data = OpenWeather::get_weather_data_for_city(city_string)
printf("Complete!\n\n")


printf("Pos:        [%f,%f]\n", data.lon, data.lat);
printf("Base:       %s\n", data.base)
printf("Temp:       %s K\n", data.temp)
printf("Pressure:   %s hPa\n", data.pressure)
printf("Humidity:   %s%%\n", data.humidity)
printf("Wind speed: %s m/s\n", data.wind_speed)
printf("Cloud Cov.: %s%%\n\n", data.clouds)
printf("Weather Types:\n")

data.weather_specs.each do |weather_spec|
  printf(" %s\n", weather_spec.main)
end
before_action :method, :only => [:action, :action], :except => [:action, :action]
