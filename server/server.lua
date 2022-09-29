local PSRCore = exports['psr-core']:GetCoreObject()

local frozen = false
local permissions = {
  -- MENU PERMS --
  ['menu'] = 'mod',
  ['playermenu'] = 'mod',
  ['adminmenu'] = 'admin',
  ['servermenu'] = 'admin',
  ['developermenu'] = 'god',

  -- MOD PERMS --
  ['kick'] = 'mod',
  ['staffchat'] = 'mod',
  ['revive'] = 'mod',
  ['heal'] = 'mod',
  ['goto'] = 'mod',
  ['freeze'] = 'mod',
  ['reportresponse'] = 'mod',

  -- ADMIN PERMS --
  ['announcements'] = 'admin',
  ['kill'] = 'admin',
  ['spectate'] = 'admin',
  ['ban'] = 'admin',
  ['noclip'] = 'admin',
  ['showcoords'] = 'admin',

  -- GOD PERMS --
  ['perms'] = 'god',
  ['kickall'] = 'god',
}

--------------------------
-------- COMMANDS --------
--------------------------
PSRCore.Commands.Add('staffchat', "Send Message to Staff", {{name='message', help='Message'}}, true, function(source, args)
  local msg = table.concat(args, ' ')
  TriggerClientEvent('psr-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, permissions['staffchat'])

PSRCore.Commands.Add('announce', "Make Announcement", {}, false, function(_, args)
  local msg = table.concat(args, ' ')
  if msg == '' then return end
  TriggerClientEvent('chat:addMessage', -1, {
    color = { 255, 0, 0},
    multiline = true,
    args = {"[ANNOUNCEMENT] ", msg}
  })
end, permissions['announcements'])

PSRCore.Commands.Add('warn', "Warn a Player", {{name='ID', help='Player'}, {name='Reason', help='Mention a reason'}}, true, function(source, args)
  local targetPlayer = PSRCore.Functions.GetPlayer(tonumber(args[1]))
  local senderPlayer = PSRCore.Functions.GetPlayer(source)
  table.remove(args, 1)
  local msg = table.concat(args, ' ')
  local warnId = 'WARN-'..math.random(1111, 9999)
  if targetPlayer ~= nil then
  TriggerClientEvent('chat:addMessage', targetPlayer.PlayerData.source, { args = { "SYSTEM", "[WARNING]: "..GetPlayerName(source).." [REASON]: "..msg }, color = 255, 0, 0 })
  TriggerClientEvent('chat:addMessage', source, { args = { "SYSTEM", "[WARNED]: "..GetPlayerName(targetPlayer.PlayerData.source).." [REASON]: "..msg }, color = 255, 0, 0 })
    -- MySQL.insert('INSERT INTO player_warns (senderIdentifier, targetIdentifier, reason, warnId) VALUES (?, ?, ?, ?)', {
    --   senderPlayer.PlayerData.license,
    --   targetPlayer.PlayerData.license,
    --   msg,
    --   warnId
    -- })
  else
    TriggerClientEvent('PSRCore:Notify', src, 'Player is not online!', 'error', 5000)
  end
end, 'admin')

PSRCore.Commands.Add('admin', 'Open the admin menu (Admin Only)', {}, false, function(source)
  local src = source
  TriggerClientEvent('psr-admin:OpenMainPage', src)
end, 'admin')

PSRCore.Commands.Add('noclip', 'No Clip (Admin Only)', {}, false, function(source)
  local src = source
  TriggerClientEvent('admin:client:ToggleNoClip', src)
end, 'admin')

local savedCoords = {}
PSRCore.Commands.Add('bring', 'Bring a player to you (Admin only)', { { name = 'id', help = 'Player ID' }, }, true, function(source, args)
  if args[1] then
    local src = source
    local admin = GetPlayerPed(src)
    local coords = GetEntityCoords(admin) --Admin coords
    local target = GetPlayerPed(tonumber(args[1])) --Player ped
    SetEntityCoords(target, coords)
    savedCoords[tonumber(args[1])]= GetEntityCoords(target) --Save player coords
  end
end, 'admin')

PSRCore.Commands.Add('bringback', 'Bring back a player (Admin only)', { { name = 'id', help = 'Player ID' }, }, true, function(source, args)
  if args[1] then
    local src = source
    local coords = savedCoords[tonumber(args[1])] --Player saved coords
    local target = GetPlayerPed(tonumber(args[1])) --Player ped
    SetEntityCoords(target, coords)
  end
end, 'admin')

PSRCore.Commands.Add('goto', 'Teleport yourself to the player (Admin only)', { { name = 'id', help = 'Player ID' }, }, true, function(source, args)
  if args[1] then
    local src = source
    local admin = GetPlayerPed(src)
    local target = GetPlayerPed(tonumber(args[1]))
    local targetCoords = GetEntityCoords(target)
    SetEntityCoords(admin, coords)
  end
end, 'admin')

----------------------------
----- REPORT COMMANDS -----
----------------------------
PSRCore.Commands.Add('report', "Send Admin Report", {{name='message', help='Message'}}, true, function(source, args)
  local src = source
  local msg = table.concat(args, ' ')
  local Player = PSRCore.Functions.GetPlayer(source)
  TriggerClientEvent('psr-admin:client:SendReport', -1, GetPlayerName(src), src, msg)
  TriggerEvent('psr-log:server:CreateLog', 'report', 'Report', 'green', '**'..GetPlayerName(source)..'** (CitizenID: '..Player.PlayerData.citizenid..' | ID: '..source..') **Report:** ' ..msg, false)
end)

PSRCore.Commands.Add('reportr', "Respond to Report", {{name='id', help='Player'}, {name = 'message', help = 'Message to respond with'}}, false, function(source, args)
  local src = source
  local playerId = tonumber(args[1])
  table.remove(args, 1)
  local msg = table.concat(args, ' ')
  local OtherPlayer = PSRCore.Functions.GetPlayer(playerId)
  if msg == '' then return end
  if not OtherPlayer then return TriggerClientEvent('PSRCore:Notify', src, 'Player is not online!', 'error', 5000) end
  if not PSRCore.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') ~= 1 then return end
  TriggerClientEvent('chat:addMessage', playerId, {
    color = {255, 0, 0},
    multiline = true,
    args = {'[ADMIN RESPONSE]', msg}
  })
  TriggerClientEvent('chat:addMessage', src, {
    color = {255, 0, 0},
    multiline = true,
    args = {'[REPORT RESPONSE] ('..playerId..')', msg}
  })
  TriggerClientEvent('PSRCore:Notify', src, 'Report reply sent!', 'success', 5000)
  TriggerEvent('psr-log:server:CreateLog', 'report', 'Report Reply', 'red', '**'..GetPlayerName(src)..'** replied on: **'..OtherPlayer.PlayerData.name.. ' **(ID: '..OtherPlayer.PlayerData.source..') **Message:** ' ..msg, false)
end, permissions['reportresponse'])

----------------------------------
------ DEVELOPER COMMANDS --------
----------------------------------
PSRCore.Commands.Add('vector3', 'Copy vector3 to clipboard (Admin only)', {}, false, function(source)
  local src = source
  TriggerClientEvent('psr-admin:CopytoClipboard', src, 'coords3')
end, 'admin')

PSRCore.Commands.Add('vector4', 'Copy vector4 to clipboard (Admin only)', {}, false, function(source)
  local src = source
  TriggerClientEvent('psr-admin:CopytoClipboard', src, 'coords4')
end, 'admin')

PSRCore.Commands.Add('heading', 'Copy heading to clipboard (Admin only)', {}, false, function(source)
  local src = source
  TriggerClientEvent('psr-admin:CopytoClipboard', src, 'heading')
end, 'admin')

-----------------------------
---------- CALLBACKS --------
-----------------------------
-- GET PERMISSIONS --
PSRCore.Functions.CreateCallback('admin:server:hasperms', function(source, cb, action)
  local src = source
  if PSRCore.Functions.HasPermission(src, permissions[action]) or IsPlayerAceAllowed(src, 'command') then
    cb(true)
  else
    TriggerClientEvent('PSRCore:Notify', src, 'You don\'t have permission to do this!', 'error', 5000)
    cb(false)
  end
end)

-- GET PLAYERS --
PSRCore.Functions.CreateCallback('admin:server:getplayers', function(source, cb)
  local src = source
  local players = {}
  for k,v in pairs(PSRCore.Functions.GetPlayers()) do
    local target = GetPlayerPed(v)
    local ped = PSRCore.Functions.GetPlayer(v)
    players[#players + 1] = {
      name = ped.PlayerData.charinfo.firstname .. ' ' .. ped.PlayerData.charinfo.lastname .. ' | (' .. GetPlayerName(v) .. ')',
      id = v,
      coords = GetEntityCoords(target),
      citizenid = ped.PlayerData.citizenid,
      sources = GetPlayerPed(ped.PlayerData.source),
      sourceplayer = ped.PlayerData.source
    }
  end

  table.sort(players, function(a, b)
    return a.id < b.id
  end)

  cb(players)
end)

RegisterNetEvent('admin:server:getPlayersForBlips', function()
  local src = source
  local players = {}
  for k,v in pairs(PSRCore.Functions.GetPlayers()) do
    local target = GetPlayerPed(v)
    local ped = PSRCore.Functions.GetPlayer(v)
    players[#players + 1] = {
      name = ped.PlayerData.charinfo.firstname .. ' ' .. ped.PlayerData.charinfo.lastname .. ' | ' .. GetPlayerName(v),
      id = v,
      coords = GetEntityCoords(target),
      citizenid = ped.PlayerData.citizenid,
      sources = GetPlayerPed(ped.PlayerData.source),
      sourceplayer = ped.PlayerData.source
    }
  end

  TriggerClientEvent('admin:client:show', src, players)
end)

-----------------------------
----------- EVENTS ---------
-----------------------------
-- STAFFCHAT --
RegisterNetEvent('psr-admin:server:Staffchat:addMessage', function(name, msg)
  local src = source
  if PSRCore.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') then
    if PSRCore.Functions.IsOptin(src) then
      TriggerClientEvent('chat:addMessage', src, {
        color = {255, 0, 0},
        multiline = true,
        args = {"STAFFCHAT: "..name, msg}
      })
    end
  end
end)

-- REPORTS --
RegisterNetEvent('psr-admin:server:SendReport', function(name, targetSrc, msg)
  local src = source
  if PSRCore.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') then
    if PSRCore.Functions.IsOptin(src) then
      TriggerClientEvent('chat:addMessage', src, {
        color = {255, 0, 0},
        multiline = true,
        args = {"[REPORT] "..name..' ('..targetSrc..')', msg}
      })
    end
  end
end)

-- KILL PLAYER --
RegisterNetEvent('psr-admin:server:kill', function(player)
  local src = source
  if PSRCore.Functions.HasPermission(src, permissions['kill']) or IsPlayerAceAllowed(src, 'command') then
    TriggerClientEvent('hospital:client:KillPlayer', player.id)
  end
end)

-- REVIVE PLAYER --
RegisterNetEvent('psr-admin:server:revive', function(player)
  local src = source
  if PSRCore.Functions.HasPermission(src, permissions['revive']) or IsPlayerAceAllowed(src, 'command') then

    -- TriggerClientEvent('admin:client:revivePlayer', player.id)
    TriggerClientEvent('hospital:client:Revive', player.id)
  end
end)

-- HEAL PLAYER --
RegisterNetEvent('psr-admin:server:heal', function(player)
  local src = source
  if PSRCore.Functions.HasPermission(src, permissions['heal']) or IsPlayerAceAllowed(src, 'command') then

    TriggerClientEvent('admin:client:healPlayer', player.id)
  end
end)

-- GIVE PLAYER CLOTHING MENU --
RegisterNetEvent('psr-admin:server:cloth', function(player)
  local src = source
  if PSRCore.Functions.HasPermission(src, permissions['perms']) or IsPlayerAceAllowed(src, 'command') then
    TriggerClientEvent('qbr-clothing:client:openMenu', player.id, 'all')
  end
end)

-- KICK PLAYER --
RegisterNetEvent('psr-admin:server:kick', function(player, reason)
  local src = source
  if PSRCore.Functions.HasPermission(src, permissions['kick']) or IsPlayerAceAllowed(src, 'command') then
    TriggerEvent('psr-log:server:CreateLog', 'bans', 'Player Kicked', 'red', string.format('%s was kicked by %s for %s', GetPlayerName(player.id), GetPlayerName(src), reason), true)
    DropPlayer(player.id, "You have been kicked from the server" .. ':\n' .. reason .. '\n\n' .. "🔸 Check our Discord for more information: " .. exports['psr-core']:GetConfig().Server.discord)
  end
end)

-- GO TO PLAYER --
RegisterNetEvent('psr-admin:server:goto', function(player)
  local src = source
  if PSRCore.Functions.HasPermission(src, permissions['goto']) or IsPlayerAceAllowed(src, 'command') then
    local target = GetPlayerPed(player.id)
    local targetCoords = GetEntityCoords(target)
    TriggerClientEvent('admin:client:spectate', src, player.id)
  end
end)

-- SPECTATE PLAYER --
RegisterNetEvent('psr-admin:server:spectate', function(player)
  local src = source
  if PSRCore.Functions.HasPermission(src, permissions['spectate']) or IsPlayerAceAllowed(src, 'command') then
    local admin = GetPlayerPed(src)
    local target = GetEntityCoords(GetPlayerPed(player.id))
    SetEntityCoords(admin, target)
  end
end)

-- BRING PLAYER --
RegisterNetEvent('psr-admin:server:bring', function(player)
  local src = source
  local admin = GetPlayerPed(src)
  local coords = GetEntityCoords(admin) --Admin coords
  local target = GetPlayerPed(player.id) --Player ped
  SetEntityCoords(target, coords)
end)

-- FREEZE PLAYER --
RegisterNetEvent('psr-admin:server:freeze', function(player)
  local src = source
  if PSRCore.Functions.HasPermission(src, permissions['freeze']) or IsPlayerAceAllowed(src, 'command') then
    local target = GetPlayerPed(player.id)
    if not frozen then
      frozen = true
      FreezeEntityPosition(target, true)
    else
      frozen = false
      FreezeEntityPosition(target, false)
    end
  end
end)

-- OPEN PLAYER INVENTORY --
RegisterNetEvent('psr-admin:server:inventory', function(player)
  local src = source
  if PSRCore.Functions.HasPermission(src, permissions['perms']) or IsPlayerAceAllowed(src, 'command') then
    TriggerClientEvent('psr-admin:client:inventory', src, player.id)
  end
end)

-- BAN PLAYER --
RegisterNetEvent('psr-admin:server:ban', function(player, time, reason)
  local src = source
  if PSRCore.Functions.HasPermission(src, permissions['ban']) or IsPlayerAceAllowed(src, 'command') then
    local time = tonumber(time)
    local banTime = tonumber(os.time() + time)
    if banTime > 2147483647 then
      banTime = 2147483647
    end
    local timeTable = os.date('*t', banTime)

    MySQL.Async.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
      GetPlayerName(player.id),
      PSRCore.Functions.GetIdentifier(player.id, 'license'),
      PSRCore.Functions.GetIdentifier(player.id, 'discord'),
      PSRCore.Functions.GetIdentifier(player.id, 'ip'),
      reason,
      banTime,
      GetPlayerName(src)
    })

    TriggerClientEvent('chat:addMessage', -1, {
      template = "<div class=chat-message server'><strong>ANNOUNCEMENT | {0} has been banned:</strong> {1}</div>",
      args = {GetPlayerName(player.id), reason}
    })

    TriggerEvent('psr-log:server:CreateLog', 'bans', 'Player Banned', 'red', string.format('%s was banned by %s for %s', GetPlayerName(player.id), GetPlayerName(src), reason), true)
      if banTime >= 2147483647 then
        DropPlayer(player.id, "You have been banned:" .. '\n' .. reason .. "\n\nYour ban is permanent.\n🔸 Check our Discord for more information: " .. exports['psr-core']:GetConfig().Server.discord)
      else
        DropPlayer(player.id, "You have been banned:" .. '\n' .. reason .. "\n\nBan expires: " .. timeTable['day'] .. '/' .. timeTable['month'] .. '/' .. timeTable['year'] .. ' ' .. timeTable['hour'] .. ':' .. timeTable['min'] .. '\n🔸 Check our Discord for more information: ' .. exports['psr-core']:GetConfig().Server.discord)
      end
    end
end)
