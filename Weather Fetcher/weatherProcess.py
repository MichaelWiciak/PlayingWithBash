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

# Colors
CYAN = '96'
YELLOW = '93'
WHITE = '97'
GREEN = '92'
BLUE = '94'
BLACK = '90'
RED = '91'

def sky_art(description):

    clear_sky_art = """
      \   /   
       .-.    
    ― (   ) ― 
       `-’    
      /   \   

    """

    few_clouds_art = """
        \  |  /    
    `.     .'    
        ( .-. )    
    ‘(   :   )’  
        `-’ ‘-’    
    """

    scattered_clouds_art = """
       .--.    
    .-(    ).  
    (___.__)__) 
    """

    broken_clouds_art = """
       .--.   
    .-(    ). 
   (___.__)__)
      .--.    
   .-(    ).  
  (___.__)__) 
    """

    shower_rain_art = """
       .--.    
    .-(    ).  
    (___.__)__) 
    ‘ ‘ ‘ ‘ ‘  
    """

    rain_art = """
       .--.    
    .-(    ).  
    (___.__)__) 
    ‘ ‘ ‘ ‘ ‘  
    ‘‘ ‘ ‘ ‘ ‘ 
    """

    thunderstorm_art = """
       .--.    
    .-(    ).  
    (___.__)__) 
    ⚡ ‘ ‘ ‘ ‘ 
    ⚡ ‘ ‘ ‘ ‘ ‘ 
    """

    snow_art = """
       .--.    
    .-(    ).  
    (___.__)__) 
    *  *  *  * 
    *  *  *  * 
    """

    mist_art = """
     _ - _ - _ -
    _ - _ - _ - 
    """

    if description == 'clear sky':
        return clear_sky_art, YELLOW
    elif description == 'few clouds':
        return few_clouds_art, CYAN
    elif description == 'scattered clouds':
        return scattered_clouds_art, WHITE
    elif description == 'broken clouds':
        return broken_clouds_art, WHITE
    elif description == 'shower rain':
        return shower_rain_art, BLUE
    elif description == 'rain':
        return rain_art, BLUE
    elif description == 'thunderstorm':
        return thunderstorm_art, BLACK
    elif description == 'snow':
        return snow_art, WHITE
    elif description == 'mist':
        return mist_art, WHITE
    else:
        return clear_sky_art
    
    
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
    

# Function to add color
def colored(text, color_code):
    return f"\033[{color_code}m{text}\033[0m"

def generate_thermometer_art(temperature):
    min_temp = -30
    max_temp = 50
    height = 6  # Height of the thermometer (number of fillable segments)
    
    # Ensure temperature is within bounds
    if temperature < min_temp:
        temperature = min_temp
    elif temperature > max_temp:
        temperature = max_temp
    
    # Calculate the number of filled segments
    fillable_range = max_temp - min_temp
    filled_segments = int(((temperature - min_temp) / fillable_range) * height)
    
    # Generate the thermometer art
    thermometer_art = " ____\n"
    for i in range(height):
        if i < (height - filled_segments):
            thermometer_art += "|    |\n"
        else:
            thermometer_art += "|####|\n"
    thermometer_art += "|0000|\n"
    
    # if the temperature is below 0, return WHITE, if it's above 30, return RED, otherwise return GREEN

    if temperature < 0:
        return colored(thermometer_art, WHITE)
    elif temperature > 30:
        return colored(thermometer_art, RED)
    else:
        return colored(thermometer_art, GREEN)

def print_weather(location, description, temperature, humidity, wind_speed, wind_direction, pressure, visibility, sunrise_time, sunset_time):
    # print the location
    print(colored(f"Weather in {location}:", CYAN))
    
    # print the sky art
    sky_art_text, color_code = sky_art(description)
    print(colored(sky_art_text, color_code))

    # print the temperature art
    thermometer_art = generate_thermometer_art(temperature)
    print(colored(thermometer_art, RED))

    print(colored(f"Description: {description}", WHITE))
    print(colored(f"Temperature: {temperature}°C", GREEN))
    print(colored(f"Humidity: {humidity}%", GREEN))
    print(colored(f"Wind Speed: {wind_speed} m/s", GREEN))
    print(colored(f"Wind Direction: {wind_direction}°", GREEN))
    print(colored(f"Pressure: {pressure} hPa", BLUE))
    print(colored(f"Visibility: {visibility} meters", BLUE))
    print(colored(f"Sunrise: {sunrise_time}", YELLOW))
    print(colored(f"Sunset: {sunset_time}", YELLOW))

def main():
    data = open_file()
    location, description, temperature, humidity, wind_speed, wind_direction, pressure, visibility, sunrise_time, sunset_time = display_weather(data)

    print_weather(location, description, temperature, humidity, wind_speed, wind_direction, pressure, visibility, sunrise_time, sunset_time)



if __name__ == '__main__':
    main()

