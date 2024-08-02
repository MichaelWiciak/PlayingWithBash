#!/bin/bash

# Load the .env file
if [ -f .env ]; then
    source .env
else
    echo ".env file not found!"
    exit 1
fi

# Check if the API key is set
if [ -z "$API_KEY" ]; then
    echo "API_KEY is not set in the .env file."
    exit 1
fi

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <city_name>"
    exit 1
fi


# City name from the script arguments
CITY="$1"

# Fetch weather data from OpenWeatherMap
RESPONSE=$(curl -s "http://api.openweathermap.org/data/2.5/weather?q=${CITY}&appid=${API_KEY}&units=metric")

# Check if the API call was successful
if [ "$(echo "$RESPONSE" | jq -r '.cod')" != "200" ]; then
    echo "Error: Could not fetch weather data for ${CITY}. Please check the city name and try again."
    exit 1
fi

# Extract data using jq
CITY_NAME=$(echo "$RESPONSE" | jq -r '.name')
WEATHER_DESC=$(echo "$RESPONSE" | jq -r '.weather[0].description')
TEMP=$(echo "$RESPONSE" | jq -r '.main.temp')
HUMIDITY=$(echo "$RESPONSE" | jq -r '.main.humidity')
WIND_SPEED=$(echo "$RESPONSE" | jq -r '.wind.speed')

# Display the weather information
echo "Weather in ${CITY_NAME}:"
echo "Description: ${WEATHER_DESC}"
echo "Temperature: ${TEMP}°C"
echo "Humidity: ${HUMIDITY}%"
echo "Wind Speed: ${WIND_SPEED} m/s"
