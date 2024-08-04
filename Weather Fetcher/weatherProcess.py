"""This is what the data looks like:
{
  "coord": { "lon": 21.0118, "lat": 52.2298 },
  "weather": [
    { "id": 800, "main": "Clear", "description": "clear sky", "icon": "01d" }
  ],
  "base": "stations",
  "main": {
    "temp": 24.82,
    "feels_like": 24.64,
    "temp_min": 23.88,
    "temp_max": 26.03,
    "pressure": 1009,
    "humidity": 49,
    "sea_level": 1009,
    "grnd_level": 998
  },
  "visibility": 10000,
  "wind": { "speed": 5.81, "deg": 250, "gust": 0 },
  "clouds": { "all": 0 },
  "dt": 1722788402,
  "sys": {
    "type": 2,
    "id": 2032856,
    "country": "PL",
    "sunrise": 1722740518,
    "sunset": 1722795722
  },
  "timezone": 7200,
  "id": 756135,
  "name": "Warsaw",
  "cod": 200
}
"""


import json
# Convert timestamps to readable formats
from datetime import datetime, timezone

def convert_timestamp(timestamp):
    return datetime.fromtimestamp(timestamp, tz=timezone.utc).strftime('%Y-%m-%d %H:%M:%S')

def open_file():
    with open('response.json', 'r') as file:
        data = json.load(file)
    return data

def display_weather(data):

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

    sunrise_time = convert_timestamp(sunrise_local)
    sunset_time = convert_timestamp(sunset_local)

    return location, description, temperature, humidity, wind_speed, wind_direction, pressure, visibility, sunrise_time, sunset_time
    


def print_weather(location, description, temperature, humidity, wind_speed, wind_direction, pressure, visibility, sunrise_time, sunset_time):
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

def main():
    data = open_file()
    location, description, temperature, humidity, wind_speed, wind_direction, pressure, visibility, sunrise_time, sunset_time = display_weather(data)

    print_weather(location, description, temperature, humidity, wind_speed, wind_direction, pressure, visibility, sunrise_time, sunset_time)



if __name__ == '__main__':
    main()

