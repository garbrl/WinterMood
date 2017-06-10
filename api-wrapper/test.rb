#!/usr/bin/ruby


require "./open_weather"

OpenWeather::init("0c5e74401870eaa1f6872f30f3d329d3", "http://api.openweathermap.org/data/2.5/weather")

lon = 90
lat = 0

printf("Querying weather for '%d, %d'... ", lon, lat)
data = OpenWeather::get_weather_data_for_coordinates(lon, lat)
printf("Complete!\n\n")


printf("Pos:        [%f,%f]\n", data.lon, data.lat);
printf("Base:       %s\n", data.base)
printf("Temp:       %s K\n", data.temp)
printf("Pressure:   %s hPa\n", data.pressure)
printf("Humidity:   %s%%\n", data.humidity)
printf("Wind speed: %s m/s\n", data.wind_speed)
printf("Cloud Cov.: %s%%\n\n", data.clouds)
printf("Sunrise:    %s\n", data.sunrise)
printf("Sunset:     %s\n", data.sunset)
printf("Weather Types:\n")

data.weather_specs.each do |weather_spec|
  printf(" %s\n", weather_spec.main)

printf("\n")
printf("OpenWeather::Data object:\n%s\n", data)

end
