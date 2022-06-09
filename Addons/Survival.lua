function getSteamID(peer_id)
    local player_list =  server.getPlayers()
    for peer_index, peer in pairs(player_list) do
        if peer.id == peer_id then
            return tostring(peer.steam_id)
        end
    end
    server.announce("(getSteamID) unable to get steam_id for peer_id: ".. peer_id, true, 1)
    return nil
end

function print(msg, to_player)
    server.announce(server.getAddonData((server.getAddonIndex())).name, tostring(msg), to_player)
end

function onPlayerJoin(steam_id, name, peer_id, admin, auth)
    if admin == true then
        print("The almighty " .. name .. " is upon us!")
        server.setTutorial(false)
    else
    print(name .. " has no bitches")
    end
end

function onPlayerLeave(steam_id, name, peer_id, admin, auth)
    print(name .. " is going to touch grass")
end

function onPlayerDie(steam_id, name, peer_id, is_admin, is_auth)
    print(name .. " has a massive skill issue")
end

--write
g_savedata = {
    spawned_vehicles = {}
}

function onVehicleSpawn(vehicle_id, peer_id, x, y, z, cost)
    if g_savedata == nil then
    g_savedata = {
        spawned_vehicles = {}
    }
    else
    end
    steamid = getSteamID(peer_id)
        if steamid ~= nil then
        print("logged: " .. vehicle_id)
        g_savedata.spawned_vehicles[vehicle_id] = {
            steamid = steamid,
            transform = matrix.translation(x, y, z),
            cost = cost
        }
        else
        print("Ai vehicle spawned - not logged")
        end
end

function onVehicleDespawn(vehicle_id, peer_id)
    g_savedata.spawned_vehicles[vehicle_id] = nil
end

function onCustomCommand(full_message, user_peer_id, is_admin, is_auth, command, one, two, three, four, five)

    if (command == "?days") then
        print(server.getDateValue() .. " days have passed.")
    --admin only commands
    elseif is_admin == true then
        if (command == "?restore") then
            if one ~= nil then
                server.resetVehicleState(one)
                print ("Successful, vehicle reset")
            else
                print("Error: no vehicle ID")
            end
        elseif (command == "?clean_players" ) then
            server.cleanVehicles()
        elseif (command == "?debug_wipe") then
            g_savedata.spawned_vehicles={nil}
            print("save data wiped")
        elseif (command == "?refund") then

            -- return if the input is invalid 
            if not tonumber(one) then
                print("Error: vehicle_id must be a number!")
                return
            end
        
            one = tonumber(one)
        
            -- return if the vehicle id sent is not in the database
            if not g_savedata.spawned_vehicles[one] then
                print("Error: Unknown vehicle_id: "..one)
                return
            end
        
            -- get the new blance
            local money = server.getCurrency() + g_savedata.spawned_vehicles[one].cost
            print("New Balance: "..money)
            server.setCurrency(money, server.getResearchPoints())
        
            print("Vehicle cost: "..g_savedata.spawned_vehicles[one].cost)
            print("Successful, vehicle refunded")
        
            -- refund the vehicle's cost
            server.despawnVehicle(one, true)

        elseif command == "?settings" then
            local game_setting = server.getGameSettings()
            for setting, value in pairs(game_setting) do
                print(setting..": "..tostring(value))
            end
        elseif command =="?setting" then
            if not two then print("Error: Invalid number of arguments"); return end
        
            local game_setting = server.getGameSettings()
            if game_setting[one] == nil then print("Error: Setting "..one.." does not exist!"); return end
        
            two = tonumber(two) or two == "true" or false
            server.setGameSetting(one, two)
            
            local game_setting = server.getGameSettings()
            print("Set "..one.." to "..tostring(game_setting[one]))

            --list vehicles
        elseif command == "?list" then
            for vehicle_id, data in pairs(g_savedata.spawned_vehicles) do
                print(vehicle_id .. " " .. tostring(data.steamid) .. " $" .. tostring(data.cost))
            end
        else
            print("Valid commands are as follows:\n?refund\n?restore\n?list\n?days\n?settings\n?setting\n?days" )
        end
    end
end
--Report bugs/suggestions to Icewave#0394 on discord or https://github.com/Icewav3/Stormworks/issues
--Huge thanks to Toastery#2075 for helping me with this!