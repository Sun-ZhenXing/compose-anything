# OpenWeather MCP Server

OpenWeather MCP Server provides weather data and meteorological information through the Model Context Protocol.

## Features

- 🌤️ **Current Weather** - Get current weather data
- 📋 **Weather Forecast** - Get weather forecasts
- 🌡️ **Temperature Data** - Access temperature information
- 🌍 **Location-based** - Query weather by location

## Environment Variables

| Variable                        | Default  | Description                    |
| ------------------------------- | -------- | ------------------------------ |
| `MCP_OPENWEATHER_VERSION`       | `latest` | MCP OpenWeather image version  |
| `MCP_OPENWEATHER_PORT_OVERRIDE` | `8000`   | MCP service port               |
| `OPENWEATHER_API_KEY`           | -        | OpenWeather API key (required) |
| `TZ`                            | `UTC`    | Timezone                       |

## Getting Started

1. Sign up at [OpenWeatherMap](https://openweathermap.org/api) to get your API key
2. Set the `OPENWEATHER_API_KEY` in your `.env` file
3. Run `docker compose up -d`
