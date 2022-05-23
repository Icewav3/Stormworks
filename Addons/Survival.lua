--functions
function = write()
end
function = read()
    if 
end
---@param peer_id integer the peer_id of the player you want to get the steam id of
---@return string steam_id the steam id of the player, nil if not found
function getSteamID(peer_id)
    local player_list =  server.getPlayers()
    for peer_index, peer in pairs(player_list) do
        if peer.id == peer_id then
            return tostring(peer.steam_id)
        end
    end
    server.announce("(getSteamID) unable to get steam_id for peer_id: "..peer_id, true, 1)
    return nil
end

function print(msg, to_player)
    server.announce(server.getAddonData((s.getAddonIndex())).name, tostring(msg), to_player)
end

-- g_savedata table that persists between game sessions
g_savedata = {}

-- Tick function that will be executed every logic tick
function onTick(game_ticks)

end

function onPlayerJoin(steam_id, name, peer_id, admin, auth)
	server.announce("[Server]", name .. " has no bitches")
end

function onPlayerLeave(steam_id, name, peer_id, admin, auth)
	server.announce("[Server]", name .. " is going to touch grass")
end

function onPlayerDie(steam_id, name, peer_id, is_admin, is_auth)
    server.announce("[Server]", name .. " has a massive skill issue")
end

function onVehicleSpawn(vehicle_id, peer_id, x, y, z, cost) 
    
end

function onVehicleDespawn(vehicle_id, peer_id)
    
end

function onCustomCommand(full_message, user_peer_id, is_admin, is_auth, command, one, two, three, four, five)

	if (command == "?days") then
		server.announce("[Server]", server.getDateValue() .. " days have passed.")
	end
    if (command == "?id") then
        server.announce("[Server]", server.getCharacterVehicle(object_id) .. " is the vehicle ID")
    end
    --admin only commands
    if is_admin == true then
        if (command == "?restore") then
        end
    end



end
