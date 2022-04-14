--[[Wave Menu -- Admin Menu
    Copyright (C) 2022  Mosheba
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.
    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>. ]]--

-- Created by Mosheba || https://discord.gg/xP67BKbk6A



local artofc = [[
_      _____ _   ______  __  ________  ____  __
| | /| / / _ | | / / __/ /  |/  / __/ |/ / / / /
| |/ |/ / __ | |/ / _/  / /|_/ / _//    / /_/ /
|__/|__/_/ |_|___/___/ /_/  /_/___/_/|_/\____/
]]

local art2ofc = [[
^1__          __     _____  _   _ _____ _   _  _____
^1\ \        / /\   |  __ \| \ | |_   _| \ | |/ ____|
 ^1\ \  /\  / /  \  | |__) |  \| | | | |  \| | |  __
  ^1\ \/  \/ / /\ \ |  _  /| . ` | | | | . ` | | |_ |
   ^1\  /\  / ____ \| | \ \| |\  |_| |_| |\  | |__| |
    ^1\/  \/_/    \_\_|  \_\_| \_|_____|_| \_|\_____|
]]


local serverSessionManager = {}

Citizen.CreateThread(function()
while true do
  Wait(500)
  for k,v in pairs(GetActivePlayers()) do
    local found = false
    for _,j in pairs(serverSessionManager) do
      if GetPlayerServerId(v) == j then
        found = true
      end
    end
    if not found then
      table.insert(serverSessionManager, GetPlayerServerId(v))
    end
  end
end
end)




local timers = {
    health = 0,
    armour = 0,
    bus = 0,
    invincibility = 0,
}

local cooldowns = {
    health = 15,
    armour = 15,
    bus = 60,
    invincibility = 5
}


function setInvincibility()
    timers.invincibility = cooldowns.invincibility
  end

RegisterNetEvent('mDWaveMenu:checkinifadmin')
AddEventHandler('mDWaveMenu:checkinifadmin', function()
isPlayerAdmin = true
end)

function notify(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
    DrawNotification(true, false)
end

RMenu.Add('combat', 'main', RageUI.CreateMenu("[PVP LOBBY] MENU", "PVP LOBBY | ~g~By Mosheba: dsc.gg/mdev"))
RMenu.Add('combat', 'weapons', RageUI.CreateSubMenu(RMenu:Get('combat','main'), "Weapon Spawner", "~b~Choose your weapon", nil, nil))
RMenu.Add('combat', 'teleport', RageUI.CreateSubMenu(RMenu:Get('combat','main'), "Teleporter", "~b~Select a location to teleport to", nil, nil))
Citizen.CreateThread(function()
while true do
  RageUI.IsVisible(RMenu:Get('combat', 'main'), true, true, true, function()
    RageUI.Button("Replenish Health", "Replenish Health", {RightLabel = "💚"},true, function(Hovered, Active, Selected)
        if (Selected) then
            if timers.health <= 0 then
                timers.health = cooldowns.health
                SetEntityHealth(PlayerPedId(), 200)
                notify("~g~Replenished your health")
            else
                notify(string.format("~r~You must wait another %ss before you can replenish your health again!", timers.health))
            end
        end
    end, RMenu:Get('combat', 'main'))

    RageUI.Button("Replenish Armour", "Select to replenish your armour", {RightLabel = "🛡"}, true, function(Hovered, Active, Selected)
        if (Selected) then
            if timers.armour <= 0 then
                timers.armour = cooldowns.armour
                SetPedArmour(PlayerPedId(), 100)
                notify("~g~Replenished your armour")
            else
                notify(string.format("~r~You must wait another %ss before you can replenish your armour again!", timers.armour))
            end
        end
    end, nil)


    RageUI.Button("Weapon Spawner ", "Select to open the weapon spawner", { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
        if (Selected) then end
    end, RMenu:Get('combat','weapons'))

    RageUI.Button("~r~Teleport To Red Zones", "Teleport To Red Zones", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
        if (Selected) then end
    end, RMenu:Get('combat','teleport'))

    end, function() 
end)


            RageUI.IsVisible(RMenu:Get('combat', 'weapons'),true,true,true,function(source)
                for name, values in ipairs(ConfigPvPMenu.Weapons) do
                    RageUI.Button(tostring(values.name), string.format("%s", values.description),{ }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            GiveWeaponToPed(PlayerPedId(), GetHashKey(values.id), 9999, false, true)
                            notify("Gave you a "..values.name)
                        end
                    end)
                end 
                end, function()
                
                end)
            



                RageUI.IsVisible(RMenu:Get('combat', 'teleport'),true,true,true,function()
                    for name, values in ipairs(ConfigPvPMenu.locations) do
                        RageUI.Button(tostring(values.name), string.format("Select to teleport to %s", values.name),{ }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                local playerPed = PlayerPedId()
                                setInvincibility()
                                SetEntityCoords(playerPed, values.coords.x, values.coords.y, values.coords.z, 0, 0, 0, false)
                                SetEntityHeading(playerPed, values.heading)
                            end
                        end)
                    end 
                end, function()
                
                end)

        Citizen.Wait(0)
    end
end)



RegisterNetEvent('md_lobbies:menus:openPVP')
AddEventHandler('md_lobbies:menus:openPVP', function()
    RageUI.Visible(RMenu:Get('combat', 'main'), not RageUI.Visible(RMenu:Get('combat', 'main')))
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1,56) then
            RageUI.Visible(RMenu:Get('combat', 'main'), not RageUI.Visible(RMenu:Get('combat', 'main')))
        end
    end
end)


