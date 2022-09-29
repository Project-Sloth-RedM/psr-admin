-------------------------------
----- Players Menu Page ------
-------------------------------
local PSRCore = exports['psr-core']:GetCoreObject()
local playertab = {}
local lastSpectateCoord = nil
local isSpectating = false

RegisterNetEvent('psr-admin:client:BanMenu', function(data)
    BanMenu = {
        {
            header = "| Set Permissions |",
            isMenuHeader = true,
        },
        {
            header = "🔳 | Input Reason",
            txt = "",
            params = {
                event = 'psr-admin:BanReason',
                isServer = false,
                args = {id = data.id}
            }
        },
        {
            header = "⬅️ | Go Back",
            txt = "",
            params = {
                event = 'psr-admin:PlayersPage',
                isServer = false,
            }
        },
        {
            header = "❌ | Close Menu",
            txt = '',
            params = {
                event = 'psr-menu:closeMenu',
            }
        },
    }

    PSRCore.Functions.TriggerCallback('admin:server:hasperms', function(hasperms)
        if hasperms then
            exports['psr-menu']:openMenu(BanMenu)
        end
    end, 'ban')
end)

RegisterNetEvent("psr-admin:BanReason", function(id)

    local dialog = exports['qbr-input']:ShowInput({
        header = "Ban Player",
        submitText = "Submit",
        inputs = {
            {
                text = '[ REASON ]',
                name = "reason",
                type = "text",
                isRequired = true,
            },
            {
                text = '[ LENGTH ]',
                name = "length",
                type = "number",
                isRequired = true,
            },
        },
    })

    if dialog ~= nil then
        TriggerServerEvent('admin:server:ban', id, dialog.length, dialog.reason)
    end
end)

RegisterNetEvent('psr-admin:client:KickMenu', function(data)
    KickMenu = {
        {
            header = "| Set Permissions |",
            isMenuHeader = true,
        },
        {
            header = "🔳 | Input Reason",
            txt = "",
            params = {
                event = 'psr-admin:KickReason',
                isServer = false,
                args = {id = data.id}
            }
        },
        {
            header = "⬅️ | Go Back",
            txt = "",
            params = {
                event = 'psr-admin:PlayersPage',
                isServer = false,
            }
        },
        {
            header = "❌ | Close Menu",
            txt = '',
            params = {
                event = 'psr-menu:closeMenu',
            }
        },
    }

    PSRCore.Functions.TriggerCallback('admin:server:hasperms', function(hasperms)
        if hasperms then
            exports['psr-menu']:openMenu(KickMenu)
        end
    end, 'kick')
end)

RegisterNetEvent("psr-admin:KickReason", function(id)

    local dialog = exports['qbr-input']:ShowInput({
        header = "Kick Player",
        submitText = "Submit",
        inputs = {
            {
                text = '[ REASON ]',
                name = "reason",
                type = "text",
                isRequired = true,
            },
        },
    })

    if dialog ~= nil then
        TriggerServerEvent('admin:server:kick', id, dialog.reason)
    end
end)

RegisterNetEvent('psr-admin:client:PermissionsMenu', function(data)
    PermissionsMenu = {
        {
            header = "| Set Permissions |",
            isMenuHeader = true,
        },
        {
            header = "🔳 | Set Group",
            txt = "",
            params = {
                event = 'psr-admin:PermissionsInput',
                isServer = false,
                args = {id = data.id}
            }
        },
        {
            header = "⬅️ | Go Back",
            txt = "",
            params = {
                event = 'psr-admin:PlayersPage',
                isServer = false,
            }
        },
        {
            header = "❌ | Close Menu",
            txt = '',
            params = {
                event = 'psr-menu:closeMenu',
            }
        },
    }

    PSRCore.Functions.TriggerCallback('admin:server:hasperms', function(hasperms)
        if hasperms then
            exports['psr-menu']:openMenu(PermissionsMenu)
        end
    end, 'perms')
end)

RegisterNetEvent("psr-admin:PermissionsInput", function(data)

    local dialog = exports['qbr-input']:ShowInput({
        header = "Set Player Permissions",
        submitText = "Submit",
        inputs = {
            {
                text = '[ MOD, ADMIN, GOD ]',
                name = "group",
                type = "text",
                isRequired = true,
            },
        },
    })

    if dialog ~= nil then
        TriggerServerEvent('admin:server:setpermission', data.id, dialog.group)
    end
end)

RegisterNetEvent('psr-admin:PlayersPage', function()

    PSRCore.Functions.TriggerCallback('admin:server:getplayers', function(players)
        local PlayersPage = {
            {
                header = '| Online Players |',
                isMenuHeader = true,
            },
        }

        for k, v in pairs(players) do
            PlayersPage[#PlayersPage + 1] = {
                header = 'ID: '..k..' | '..v.name,
                txt = "",
                params = {
                    event = 'psr-admin:OpenPlayerMenu',
                    args = {name = v.name, player = k},
                }
            }
        end

        PlayersPage[#PlayersPage + 1] = {
            header = "⬅️ | Go Back",
            text = "",
            params = {
                event = "psr-admin:OpenMainPage",
            }
        }

        PlayersPage[#PlayersPage + 1] = {
            header = "❌ | Close Menu",
            text = "",
            params = {
                event = "psr-menu:closeMenu",
            }
        }

        PSRCore.Functions.TriggerCallback('admin:server:hasperms', function(hasperms)
            if hasperms then
                exports['psr-menu']:openMenu(PlayersPage)
            end
        end, 'playermenu')
    end)
end)

RegisterNetEvent('psr-admin:OpenPlayerMenu', function(data)

    PlayerPage = {
        {
            header = data.name,
            isMenuHeader = true,
        },
        {
            header = "🔳 | Revive",
            txt = "",
            params = {
                event = 'psr-admin:server:revive',
                isServer = true,
                args = {id = data.player}
            }
        },
        {
            header = "🔳 | Heal",
            txt = "",
            shouldClose = false,
            params = {
                event = 'psr-admin:server:heal',
                isServer = true,
                args = {id = data.player}
            }
        },
        {
            header = "🔳 | Kill",
            txt = "",
            shouldClose = false,
            params = {
                event = 'psr-admin:server:kill',
                isServer = true,
                args = {id = data.player}
            }
        },
        {
            header = "🔳 | Spectate",
            txt = "",
            shouldClose = false,
            params = {
                event = 'psr-admin:server:spectate',
                isServer = true,
                args = {id = data.player}
            }
        },
        {
            header = "🔳 | Freeze",
            txt = "",
            shouldClose = false,
            params = {
                event = 'psr-admin:server:freeze',
                isServer = true,
                args = {id = data.player}
            }
        },
        {
            header = "🔳 | Goto",
            txt = "",
            shouldClose = false,
            params = {
                event = 'psr-admin:server:goto',
                isServer = true,
                args = {id = data.player}
            }
        },
        {
            header = "🔳 | Bring",
            txt = "",
            shouldClose = false,
            params = {
                event = 'psr-admin:server:bring',
                isServer = true,
                args = {id = data.player}
            }
        },
        {
            header = "🔳 | Sit on Mount",
            txt = "",
            shouldClose = false,
            params = {
                event = 'psr-admin:server:sitonmount',
                isServer = false,
                args = {id = data.player}
            }
        },
        {
            header = "🔳 | Open Inventory",
            txt = "",
            shouldClose = false,
            params = {
                event = 'psr-admin:server:inventory',
                isServer = true,
                args = {id = data.player}
            }
        },
        {
            header = "🔳 | Give Clothing Menu",
            txt = "",
            shouldClose = false,
            params = {
                event = 'psr-admin:server:cloth',
                isServer = true,
                args = {id = data.player}
            }
        },
        {
            header = "🔳 | Kick",
            txt = "",
            shouldClose = false,
            params = {
                event = 'psr-admin:client:KickMenu',
                isServer = false,
                args = {id = data.player}
            }
        },
        {
            header = "🔳 | Ban",
            txt = "",
            shouldClose = false,
            params = {
                event = 'psr-admin:client:BanMenu',
                isServer = false,
                args = {id = data.player}
            }
        },
        -- {
        --     header = "🔳 | Permissions",
        --     txt = "",
        --     shouldClose = false,
        --     params = {
        --         event = 'psr-admin:client:PermissionsMenu',
        --         isServer = false,
        --         args = {id = data.player}
        --     }
        -- },
        {
            header = "⬅️ | Go Back",
            txt = "",
            params = {
                event = 'psr-admin:OpenMainPage',
                isServer = false,
            }
        },
        {
            header = "❌ | Close Menu",
            txt = '',
            params = {
                event = 'psr-menu:closeMenu',
            }
        },
    }

    PSRCore.Functions.TriggerCallback('admin:server:hasperms', function(hasperms)
        if hasperms then
            exports['psr-menu']:openMenu(PlayerPage)
        end
    end, 'playermenu')
end)

------------------------
------- EVENTS ---------
------------------------
-- SEND REPORTS --
RegisterNetEvent('psr-admin:client:SendReport', function(name, src, msg)
    TriggerServerEvent('psr-admin:server:SendReport', name, src, msg)
end)

-- OPEN INVENTORY --
RegisterNetEvent('psr-admin:client:inventory', function(targetPed)
    TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", targetPed)
end)

-- SPECTATE --
RegisterNetEvent('psr-admin:client:spectate', function(targetPed)
    local myPed = PlayerPedId()
    local targetplayer = GetPlayerFromServerId(targetPed)
    local target = GetPlayerPed(targetplayer)
    if not isSpectating then
        isSpectating = true
        SetEntityVisible(myPed, false) -- Set invisible
        SetEntityCollision(myPed, false, false) -- Set collision
        SetEntityInvincible(myPed, true) -- Set invincible
        NetworkSetEntityInvisibleToNetwork(myPed, true) -- Set invisibility
        lastSpectateCoord = GetEntityCoords(myPed) -- save my last coords
        NetworkSetInSpectatorMode(true, target) -- Enter Spectate Mode
    else
        isSpectating = false
        NetworkSetInSpectatorMode(false, target) -- Remove From Spectate Mode
        NetworkSetEntityInvisibleToNetwork(myPed, false) -- Set Visible
        SetEntityCollision(myPed, true, true) -- Set collision
        SetEntityCoords(myPed, lastSpectateCoord) -- Return Me To My Coords
        SetEntityVisible(myPed, true) -- Remove invisible
        SetEntityInvincible(myPed, false) -- Remove godmode
        lastSpectateCoord = nil -- Reset Last Saved Coords
    end
end)
