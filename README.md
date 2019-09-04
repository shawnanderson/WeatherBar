WeatherBar
==========

This project is a fork of the demo weather app written by Brad Greenlee

The very helpful tutorial is available at http://footle.org/WeatherBar/

** Change log **
- Updated to Swift 5
- API call now specifies US zip instead of city name
- Menubar refreshes every 15 minutes

** Instructions **
- Create an account to get an API key here: [https://home.openweathermap.org/users/sign_up]
- Register your API key within WeatherAPI.swift
- Update the Default zip within StatusMenuController.swift or in the app preferences

** Issues **
- Preferences window doesn't validate input
- Refresh rate should be in preferences, not hardcoded
- Does not work for zip codes outside of US
- No test cases
