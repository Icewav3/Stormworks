function onPlayerJoin(steam_id, name, peer_id, admin, auth)
	server.addAuth(peer_id)
    server.announce("[Server]", name .. " has auth")
end
