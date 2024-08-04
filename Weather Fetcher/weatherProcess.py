import json

# Load the JSON data from the file
with open('response.json', 'r') as file:
    data = json.load(file)

# Extracting information from the JSON data
location = data['name']
description = data['weather'][0]['description']
temperature = data['main']['temp']
humidity = data['main']['humidity']
wind_speed = data['wind']['speed']
wind_direction = data['wind']['deg']
pressure = data['main']['pressure']
visibility = data['visibility']
sunrise = data['sys']['sunrise']
sunset = data['sys']['sunset']
timezone_offset = data['timezone']
sunrise_local = sunrise + timezone_offset
sunset_local = sunset + timezone_offset

# Convert timestamps to readable formats
from datetime import datetime, timezone

def convert_timestamp(timestamp):
    return datetime.fromtimestamp(timestamp, tz=timezone.utc).strftime('%Y-%m-%d %H:%M:%S')

sunrise_time = convert_timestamp(sunrise_local)
sunset_time = convert_timestamp(sunset_local)

# Printing the weather information in a formatted way
print(f"Weather in {location}:")
print(f"Description: {description.capitalize()}")
print(f"Temperature: {temperature}°C")
print(f"Humidity: {humidity}%")
print(f"Wind Speed: {wind_speed} m/s")
print(f"Wind Direction: {wind_direction}°")
print(f"Pressure: {pressure} hPa")
print(f"Visibility: {visibility} meters")
print(f"Sunrise: {sunrise_time}")
print(f"Sunset: {sunset_time}")