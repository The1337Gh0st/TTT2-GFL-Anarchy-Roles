if SERVER then

--dunno what it's for but I'll keep it anyways

	function RoleCheck(role)
		local roleName = nil
		if role == ROLE_SWAPPER then
			roleName = "swapper"
		end
		if role == ROLE_BEGGAR then
			roleName = "beggar"
		end
		if role == ROLE_CLOWN then
			roleName = "clown"
		end
		return roleName -- Return the role name 
	end


	local offsets = {}

	for i = 0, 360, 15 do
	    table.insert(offsets, Vector(math.sin(i), math.cos(i), 0))
	end

	function FindRespawnLocation(pos)
	    local midsize = Vector(33, 33, 74)
	    local tstart = pos + Vector(0, 0, midsize.z / 2)

	    for i = 1, #offsets do
	        local o = offsets[i]
	        local v = tstart + o * midsize * 1.5

	        local t = {
	            start = v,
	            endpos = v,
	            mins = midsize / -2,
	            maxs = midsize / 2
	        }

	        local tr = util.TraceHull(t)

	        if not tr.Hit then return (v - Vector(0, 0, midsize.z / 2)) end
	    end

	    return false
	end
end