util.AddNetworkString("NewConfetti")

resource.AddFile("sound/ttt2/birthdayparty.mp3")
resource.AddFile("materials/confetti.png")

util.PrecacheSound("ttt2/birthdayparty.mp3")

function roles.JESTER.SpawnJesterConfetti(ply)
	net.Start("NewConfetti")
	net.WriteEntity(ply)
	net.Broadcast()

	ply:EmitSound("ttt2/birthdayparty.mp3")
end

hook.Add("TTT2PharaohPreventDamageToAnkh", "TTT2PharaohPreventDamageToAnkhJester", function(attacker)
	if attacker:GetSubRole() == ROLE_JESTER then
		return true
	end
end)
