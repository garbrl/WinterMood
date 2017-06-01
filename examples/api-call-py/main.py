#!/usr/bin/python3


import urllib.request
from datetime import datetime
import json
import sys


def format_city(city_string, api_key):
  return "http://api.openweathermap.org/data/2.5/weather?q=%s&APPID=%s" % (city_string, api_key)

def format_zip(zip_string, api_key):
  return "http://api.openweathermap.org/data/2.5/weather?zip=%s&APPID=%s" % (zip_string, api_key)

def format_coordinates(lon, lat, api_key):
  return "http://api.openweathermap.org/data/2.5/weather?lon=%d&lat=%d&APPID=%s" % (lon, lat, api_key)



def main():
  
  API_KEY= "0c5e74401870eaa1f6872f30f3d329d3"
  
  # 
  # Change this format call to either 'format_zip' or 'format_coordinates' to 
  # try the other modes of the API
  # 
  # For whatever reason, the zip-code functionality is not working
  # Will investigate if neccessary
  # 
  api_call_string = format_city("vancouver", API_KEY) # Format API string
  
  sys.stdout.write("Calling API... ")
  data = urllib.request.urlopen(api_call_string).read() # Call to API
  sys.stdout.write("Complete\n")
  
  sys.stdout.write("Parsing... ")
  string_data = data.decode('ascii')
  
  json_root = json.loads(string_data)
  coordinate_root = json_root["coord"]
  weather_root = json_root["weather"]
  sys_root = json_root["sys"]
  sys.stdout.write("Complete\n\n\n")
  
  sys.stdout.write("Got Weather at coordinates [%f,%f]\n" % (coordinate_root["lon"], coordinate_root["lat"]) )
  sys.stdout.write("Main:          '%s'\n" % (weather_root[0]["main"])  )
  sys.stdout.write("Description:   '%s'\n" % (weather_root[0]["description"]) )
  sys.stdout.write("Sunrise:       '%s'\n" % (datetime.fromtimestamp(sys_root["sunrise"])).strftime("%H:%M:%S") )
  sys.stdout.write("Sunset:        '%s'\n" % (datetime.fromtimestamp(sys_root["sunset"])).strftime("%H:%M:%S") )


main()
