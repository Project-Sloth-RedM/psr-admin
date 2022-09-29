------------------------------
----- Server Menu Page ------
------------------------------
local PSRCore = exports['psr-core']:GetCoreObject()

RegisterNetEvent('psr-admin:ServerMenuPage', function()

    ServerMenu = {
        {
            header = "SERVER SETTINGS",
            isMenuHeader = true,
        },
        {
            header = "⛈️ | Weather",
            txt = "",
            params = {
                event = 'psr-admin:WeatherPage',
                isServer = false,
            }
        },
        {
            header = "⌚ | Server Time",
            txt = "",
            params = {
                event = 'psr-admin:ServerTimeInput',
                isServer = false,
            }
        },
        {
            header = "⬅️ | Go Back",
            txt = "",
            params = {
                event = 'psr-admin:OpenMainPage',
                isServer = false,
            }
        },
        {
            header = "❌ Close Menu",
            txt = '',
            params = {
                event = 'psr-menu:closeMenu',
            }
        },
    }

    PSRCore.Functions.TriggerCallback('admin:server:hasperms', function(hasperms)
        if hasperms then
            exports['psr-menu']:openMenu(ServerMenu)
        end
    end, 'servermenu')
end)

-- INPUT SERVER TIME --
RegisterNetEvent("psr-admin:ServerTimeInput", function()

    local dialog = exports['qbr-input']:ShowInput({
        header = "Input Server Time",
        submitText = "Submit",
        inputs = {
            {
                text = '[ HOURS ]',
                name = "hour",
                type = "text",
                isRequired = true,
            },
            {
                text = '[ MINUTES ]',
                name = "minute",
                type = "text",
                isRequired = true,
            }
        },
    })

    if dialog ~= nil then
        TriggerServerEvent('psr-weathersync:server:setTime', dialog.hour, dialog.minute)
    end
end)

-- SERVER WEATHER --
RegisterNetEvent('psr-admin:WeatherPage', function()

    ServerMenu = {
        {
            header = "WEATHER",
            isMenuHeader = true,
        },
        {
            header = "🌨️ | Blizzard",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "BLIZZARD"
            }
        },
        {
            header = "☁ | Cloudy",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "CLOUDS"
            }
        },
        {
            header = "☀ | Drizzle",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "DRIZZLE"
            }
        },
        {
            header = "☀ | Foggy",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "FOG"
            }
        },
        {
            header = "☀ | Ground Blizzard",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "GROUNDBLIZZARD"
            }
        },
        {
            header = "🌁 | Hailing",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "HAIL"
            }
        },
        {
            header = "🌁 | High Pressure",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "HIGHPRESSURE"
            }
        },
        {
            header = "🌁 | Hurricane",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "HURRICANE"
            }
        },
        {
            header = "🌁 | Misty",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "MISTY"
            }
        },
        {
            header = "⛅ | Overcast",
            txt = "",
            params = {
                event = 'qbr-weathersync:server:setWeather',
                isServer = true,
                args = "OVERCAST"
            }
        },
        {
            header = "⛅ | Dark Overcast",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "OVERCASTDARK"
            }
        },
        {
            header = "☂️ | Rain",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "RAIN"
            }
        },
        {
            header = "☂️ | Sandstorm",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "SANDSTORM"
            }
        },
        {
            header = "☂️ | Rain Shower",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "SHOWER"
            }
        },
        {
            header = "☂️ | Sleet",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "SLEET"
            }
        },
        {
            header = "❄️ | Snow",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "SNOW"
            }
        },
        {
            header = "❄️ | Light Snow",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "SNOWLIGHT"
            }
        },
        {
            header = "🌤 | Sunny",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "SUNNY"
            }
        },
        {
            header = "⛈️ | Thunder",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "THUNDER"
            }
        },
        {
            header = "⛈️ | Thunderstorm",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "THUNDERSTORM"
            }
        },
        {
            header = "❄️ | Whiteout",
            txt = "",
            params = {
                event = 'psr-weathersync:server:setWeather',
                isServer = true,
                args = "WHITEOUT"
            }
        },
        {
            header = "⬅️ | Go Back",
            txt = "",
            params = {
                event = 'psr-admin:ServerMenuPage',
                isServer = false,
            }
        },
        {
            header = "❌ Close Menu",
            txt = '',
            params = {
                event = 'psr-menu:closeMenu',
            }
        },
    }

    PSRCore.Functions.TriggerCallback('admin:server:hasperms', function(hasperms)
        if hasperms then
            exports['psr-menu']:openMenu(ServerMenu)
        end
    end, 'servermenu')
end)
