#!/usr/bin/python3


import urllib.request
from datetime import datetime
from signal import signal, SIGINT
import json
import sys


class Redirect:
  
  def __init__(self, from_city, to_city):
    
    self.from_city = from_city
    self.to_city = to_city
    self.is_valid = None
    
  def validate(self, valid_cities):
    self.is_valid = self.to_city in valid_cities
    
  def to_city_is_valid(self):
    
    if (self.is_valid == None):
      raise Exception("Cannot check validity before validating")
    return self.is_valid
  
  def get_string(self):
    return "%s -> %s" % (self.from_city, self.to_city)
  
  def get_string_with_padding(self, padding):
    return "%s%s -> %s" % (self.from_city, get_whitespace_of_length(padding), self.to_city)

def get_whitespace_of_length(length):
  
  if (length < 0):
    return ""
  
  ret = ""
  for k in range(length):
    ret += " "
    
  return ret

def format_api_call_string(city_string, api_key):
  return "http://api.openweathermap.org/data/2.5/weather?q=%s,CA&APPID=%s" % (city_string, api_key)

def get_cities(path):
  ret = []
  
  f = open(path, "r")
  
  for line in f:
    
    trimmedLine = line.strip()
    
    if ( not (trimmedLine in ret)):
      ret.append(trimmedLine)
    
  return ret

def output_cities(path, cities):
  
  f = open(path, "w")
  
  for city in cities:
    f.write("\"%s\",\n" % (city))

    
  f.close()
  

def sig_handler(signum, frame):
  sys.stdout.write("\nExiting via interupt signal\n")
  sys.exit(1)



def main():
  
  API_KEY= "0c5e74401870eaa1f6872f30f3d329d3"
  CITY_LIST_PATH = "citylist.txt"
  VALID_CITY_OUTPUT_PATH = "test.txt"
  INVALID_CITY_OUTPUT_PATH = None
  
  signal(SIGINT, sig_handler)
  
  
  
  cities = get_cities(CITY_LIST_PATH);
  valid_cities = []
  redirects = []
  invalid_cities = []
  
  
  
  
  
  sys.stdout.write("Running...\n")
  
  for city in cities:
    
    sys.stdout.write("Querying for \"%s\"...%s" % (city, get_whitespace_of_length(40 - len(city))))
      
    api_call_string = format_api_call_string(city, API_KEY)
    try:
      
      data = urllib.request.urlopen(api_call_string)
      
      json_root = json.loads(data.read().decode("ascii"))
      if (json_root["sys"]["country"] != "CA"):
        sys.stdout.write("Failed: Invalid country code: %s\n" % (json_root["sys"]["country"]));
        invalid_cities.append(city)
      elif (json_root["name"].lower() != city.lower()):
        
        redirects.append(Redirect(city, json_root["name"]))
        sys.stdout.write("Potentially redirected: %s\n" % (json_root["name"]))
      else:
        
        sys.stdout.write("Successful!\n")
        valid_cities.append(city)
    
    except urllib.error.HTTPError as e:
      
      sys.stdout.write("Failed: HTTP%d\n" % (e.getcode()))
      invalid_cities.append(city)
      
    except json.JSONDecodeError as e:
      
      sys.stdout.write("Failed: JSON structure unexpected\n")
      invalid_cities.append(city)
      
    except Exception as e:
      
      sys.stdout.write("Failed: Unexpected error: %s %s\n" % (type(e)))
      invalid_cities.append(city)
      

  
  sys.stdout.write("Done\n")
  
  sys.stdout.write("Checking redirects...\n")
  
  for redirect in redirects:
    
    redirect.validate(valid_cities)
    
    redirect_string = redirect.get_string()
    
    if (redirect.to_city_is_valid()):
      sys.stdout.write("Redirect \"%s\"%sVALID\n" % (redirect_string, get_whitespace_of_length(47 - len(redirect_string))))
    else:
      sys.stdout.write("Redirect \"%s\"%sINVALID\n" % (redirect_string, get_whitespace_of_length(47 - len(redirect_string))))
      invalid_cities.append(redirect.from_city)
  
  sys.stdout.write("Done\n")
  
  
  
  
  
  sys.stdout.write("Valid cities:\n\n")
  for city in valid_cities:
    sys.stdout.write("  %s\n" % (city))
  
  
  
  
  sys.stdout.write("\nRedirected cities:\n\n")
  
  length = 0
  for redirect in redirects:
    if (redirect.to_city_is_valid() and len(redirect.from_city) > length):
      length = len(redirect.from_city)
  
  for redirect in redirects:
    if (redirect.to_city_is_valid()):
      sys.stdout.write("  %s\n" % (redirect.get_string_with_padding(length - len(redirect.from_city))))
  



  sys.stdout.write("\nInvalid cities:\n\n")
  
  for city in invalid_cities:
    sys.stdout.write("  %s\n" % (city))
  





  sys.stdout.write("\n\n")

  if (VALID_CITY_OUTPUT_PATH):
    sys.stdout.write("Writing valid cities to \"%s\"... " % (VALID_CITY_OUTPUT_PATH))
    try:
      output_cities(VALID_CITY_OUTPUT_PATH, valid_cities)
      sys.stdout.write("Done\n")
    except:
      sys.stdout.write("Failed\n")
 
  if (INVALID_CITY_OUTPUT_PATH):
    sys.stdout.write("Writing invalid cities to \"%s\"... " % (INVALID_CITY_OUTPUT_PATH))
    try:
      output_cities(INVALID_CITY_OUTPUT_PATH, invalid_cities)
      sys.stdout.write("Done\n")
    except:
      sys.stdout.write("Failed\n")


main()
