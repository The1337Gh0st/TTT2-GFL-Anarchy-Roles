if SERVER then
	AddCSLuaFile()
   resource.AddFile("weapons/knight_attack01.mp3" )
   resource.AddFile("weapons/knight_attack02.mp3")
   resource.AddFile("weapons/knight_attack03.mp3")
   resource.AddFile("weapons/knight_attack04.mp3")
   resource.AddFile("weapons/knight_attack04.mp3")
   resource.AddFile("weapons/knight_alert.mp3")

end


SWEP.HoldType = "melee2"

if CLIENT then
	SWEP.PrintName = "Headtaker Axe"
	SWEP.Slot = 8

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 100
	SWEP.DrawCrosshair = true

	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "knife_desc"
	}

	SWEP.Icon = "vgui/ttt/headtaker"
	SWEP.IconLetter = "h"
end

SWEP.Base = "weapon_tttbase"

SWEP.UseHands = true
SWEP.ViewModel							= "models/c_minotaur_axe.mdl"	 
SWEP.WorldModel							= "models/freeman/minotaur_axe_prop.mdl"	

SWEP.Primary.Damage = 50
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0.8
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0.1

SWEP.Kind = WEAPON_ROLE
SWEP.CanBuy = nil
SWEP.notBuyable = true
SWEP.IsSilent = false
SWEP.AllowDrop = false
SWEP.NoSights = true
SWEP.DeploySpeed = 1

SWEP.ShowWorldModel 		= false
SWEP.ShowViewModel 			= true

SWEP.WElements = {
	["axe"] = { type = "Model", model = "models/freeman/minotaur_axe_prop.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(5, 3, 12.987), angle = Angle(-11, 5.8, 8), size = Vector(0.755, 0.755, 0.755), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.MissSound 							= Sound("weapons/cbar_miss1.wav")
SWEP.WallSound 							= Sound("weapons/blade_slice_2.wav")

function SWEP:Deploy()
		self.Weapon:SetNextPrimaryFire(CurTime()+1)
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
		
 math.randomseed( os.time() )
   local decission = math.random( 1,4 )
   
   local SecondarySoundVarOne 	= Sound( "weapons/knight_attack01.mp3" )
   local SecondarySoundVarTwo	= Sound( "weapons/knight_attack02.mp3" )
   local SecondarySoundVarThree = Sound( "weapons/knight_attack03.mp3" )
   local SecondarySoundVarFour 	= Sound( "weapons/knight_attack04.mp3" )
   
   if decission == 1 then self:EmitSound( SecondarySoundVarOne )
		elseif decission == 2 then self:EmitSound( SecondarySoundVarTwo )
		elseif decission == 3 then self:EmitSound( SecondarySoundVarThree )
		elseif decission == 4 then self:EmitSound( SecondarySoundVarFour )
	end

		local owner = self:GetOwner()
  owner:SetNWBool("Headtaker_Speed", true)
		
		return true
	end



function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
--	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	local rdm = math.random(1, 2)
		if rdm == 1 then
		self.Weapon:SendWeaponAnim(ACT_VM_HITRIGHT)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_HITLEFT)
	end

	-- timer.Create("hitdelay"..self:EntIndex(), 0.2, 1, function() self:Attack() end)
	self:Attack()
end

local zap = Sound("ambient/levels/labs/electric_explosion4.wav")
local unzap = Sound("ambient/levels/labs/electric_explosion2.wav")

function SWEP:SecondaryAttack()
	if not self:ShouldTeleport( true ) then return end
	local ply = self.Owner
	
	local tr = ply:GetEyeTrace()
	local pos = tr.HitPos - ( ply:OBBMaxs() - ply:OBBMins() ) * tr.Normal

	local t = {}
	t.start = pos
	t.endpos = pos
	t.filter = ply
	local tr2 = util.TraceEntity(t, ply)

	if tr2.Hit then -- Prevents getting stuck inside an object
		pos = pos - ( ply:OBBMaxs() - ply:OBBMins() ) * tr.Normal * 0.1 -- Maybe we're exactly on the edge of something
		t.start = pos
		t.endpos = pos
		t.filter = ply
		tr2 = util.TraceEntity(t, ply)
		if tr2.Hit then
			t.start = ply:GetPos()
			tr2 = util.TraceEntity(t, ply)
			pos = tr2.HitPos
		end
	end

	if pos:Distance( ply:GetPos() ) < 64 then -- Prevents unintended teleportations
	--	LANG.Msg(ply, "ttt2_headtaker_close", nil, MSG_CHAT_WARN)
		return
	end
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 5 )
	self.Weapon:SetNextPrimaryFire(CurTime()+1)
	
	sound.Play( zap, ply:GetPos(), 65, 100 )
	self:EmitSound( "weapons/knight_alert.mp3" )
	

	self:Trace()
	timer.Simple( 0.1, function()
		ply.PreTeleportPos = ply:GetPos()
		ply:SetPos( pos )
		ply:SetLocalVelocity( Vector( 0, 0, 0 ) )
		sound.Play( unzap, pos, 55, 100 )
		
		self:TeleportCountDownHud( 5 )
	end )
end

function SWEP:Trace()
	local ply = self.Owner
	local tr = ply:GetEyeTrace()
	local effectdata = EffectData()
	effectdata:SetOrigin( tr.HitPos )
	effectdata:SetStart( ply:GetShootPos() )
	effectdata:SetAttachment(1)
	effectdata:SetEntity( self.Weapon )
	util.Effect( "ToolTracer", effectdata )
end

function SWEP:ShouldTeleport( IsPrimaryFire )
	local ply, target = self.Owner, self.Owner:GetEyeTrace().Entity
	
	if ply:Crouching() then
	--	LANG.Msg(ply, "ttt2_headtaker_crouch", nil, MSG_CHAT_WARN)
		return false
	end
	
	-- minecraft_b5 limits are dumb af
	if game.GetMap() == "ttt_minecraft_b5" then
		local t = ply:GetEyeTrace().HitPos
		if t.x > 1650 or t.x < -2800 or t.y > 1500 or t.y < -1900 then
		--	LANG.Msg(ply, "ttt2_headtaker_deny", nil, MSG_CHAT_WARN)
			return false
		end
	end

	-- minecraftcity limits are dumb af
	if game.GetMap():sub(1, 17) == "ttt_minecraftcity" then
		local t = ply:GetEyeTrace().HitPos
		if t.x > 1488 or t.x < -1104 or t.y > 1008 then
		--	LANG.Msg(ply, "ttt2_headtaker_deny", nil, MSG_CHAT_WARN)
			return false
		end
	end

	-- Prevent going outside of the map on 67th way
	if game.GetMap():sub(1, 11) == "ttt_67thway" then
		local t = ply:GetEyeTrace().HitPos
		if ( t.x > -300 and t.x < 170 and ( t.y > 2340 or t.y < -1150  ) ) or ( t:WithinAABox( Vector( -2000, -1100, 200 ), Vector( 2000, 2100, 800 ) ) and not t:WithinAABox( Vector( -1920, -960, 200 ), Vector( 1850, 1980, 800 ) ) ) then
		--	LANG.Msg(ply, "ttt2_headtaker_deny", nil, MSG_CHAT_WARN)
			return false
		end
	end

	-- Prevent going outside of the map on skyscraper
	if game.GetMap() == "ttt_skyscraper" then
		local t = ply:GetEyeTrace().HitPos
		if t.z < 0 then
		--	LANG.Msg(ply, "ttt2_headtaker_deny", nil, MSG_CHAT_WARN)
			return false
		end
	end

	-- Prevent going outside of the map on aircraft
	if game.GetMap():sub(1, 12)  == "ttt_aircraft" then
		local t = ply:GetEyeTrace().HitPos
		if t.x > 974 or t.x < -966 or t.z < -1042 then
		--	LANG.Msg(ply, "ttt2_headtaker_deny", nil, MSG_CHAT_WARN)
			return false
		end
	end
	
	if IsPrimaryFire then
		if IsValid( target ) and target:IsPlayer() then
		--	LANG.Msg(ply, "ttt2_headtaker_player", nil, MSG_CHAT_WARN)
			return false
		end
	else
		if not ( IsValid( target ) and target:IsPlayer() ) then
	--		LANG.Msg(ply, "ttt2_headtaker_require_player", nil, MSG_CHAT_WARN)
			return false
		end
	
		if target:Crouching() then
		--	LANG.Msg(ply, "ttt2_headtaker_crouch_switch", nil, MSG_CHAT_WARN)
			return false
		end
		
		if not ply:OnGround() then
		--	LANG.Msg(ply, "ttt2_headtaker_crouch_air", nil, MSG_CHAT_WARN)
			return false
		end
	end
	return true
end

local ShouldDrawHud, CoolDownEnd

function SWEP:DrawHUD()
	if crosshair then
		draw.RoundedBox( 0, ScrW()/2-1, ScrH()/2-1, 2, 2, Color(150, 150, 150, 255) )
	end

	if self.ShouldDrawHud then
		if not self.CoolDownEnd then self.CoolDownEnd = CurTime() end
		local w = 100 * (self.CoolDownEnd - CurTime())
		local h = 30
		local t = math.ceil( self.CoolDownEnd - CurTime() )
		draw.RoundedBox( 0, (ScrW()-w)/2, (ScrH()-h)/2, w, h, Color( 255, 0, 0, 255 ) )
		if t > 0 then
			draw.SimpleText( t, "DermaLarge", ScrW()/2-8, ScrH()/2-15, Color( 255, 255 ,255 ) )
		end
	end
end

function SWEP:TeleportCountDownHud( time )
	self.ShouldDrawHud = true
	self.CoolDownEnd = CurTime() + time
	timer.Create( "TeleportCountDownHud", time, 1, function() ShouldDrawHud = false end )
end

function SWEP:Attack( dmg, atkdist )
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
--	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

	if not IsValid(self.Owner) then return end

	self.Owner:LagCompensation(true)

	local spos = self.Owner:GetShootPos()
	local sdest = spos + (self.Owner:GetAimVector() * 70)

	local kmins = Vector(1, 1, 1) * -10
	local kmaxs = Vector(1, 1, 1) * 10

	local tr = util.TraceHull({start = spos, endpos = sdest, filter = self.Owner, mask = MASK_SHOT_HULL, mins = kmins, maxs = kmaxs})

	-- Hull might hit environment stuff that line does not hit
	if not IsValid(tr.Entity) then
		tr = util.TraceLine({start = spos, endpos = sdest, filter = self.Owner, mask = MASK_SHOT_HULL})
	end

	local hitEnt = tr.Entity

	-- effects
	if IsValid(hitEnt) then
		self:SendWeaponAnim(ACT_VM_HITCENTER)

		local edata = EffectData()
		edata:SetStart(spos)
		edata:SetOrigin(tr.HitPos)
		edata:SetNormal(tr.Normal)
		edata:SetEntity(hitEnt)

		if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
			util.Effect("BloodImpact", edata)
		end
	else
		self:SendWeaponAnim(ACT_VM_MISSCENTER)
		self:EmitSound(self.MissSound,100,math.random(90,120))
	end

	if SERVER then
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end


	if SERVER and tr.Hit and tr.HitNonWorld and IsValid(hitEnt) and hitEnt:IsPlayer() then
		local dmg = DamageInfo()
		dmg:SetDamage(self.Primary.Damage)
		dmg:SetAttacker(self.Owner)
		dmg:SetInflictor(self)
		dmg:SetDamageForce(self.Owner:GetAimVector() * 5)
		dmg:SetDamagePosition(self.Owner:GetPos())
		dmg:SetDamageType(DMG_SLASH)

		hitEnt:DispatchTraceAttack(dmg, spos + (self.Owner:GetAimVector() * 3), sdest)
		hitEnt:EmitSound(self.WallSound,100,math.random(90,120))
	end

	self.Owner:LagCompensation(false)


end

function SWEP:Equip()
	self:SetNextPrimaryFire(CurTime() + (self.Primary.Delay * 1.5))
	self:SetNextSecondaryFire(CurTime() + (self.Secondary.Delay * 1.5))
end

function SWEP:OnRemove()
	if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
		RunConsoleCommand("lastinv")
	end
end

function SWEP:OnDrop()
  self:GetOwner():SetNWBool("Headtaker_Speed", false)
	self:Remove()
end

function SWEP:Initialize()

	// other initialize code goes here
	self:SetWeaponHoldType( self.HoldType )

	if CLIENT then
	
		// Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements) // create viewmodels
		self:CreateModels(self.WElements) // create worldmodels
		
		// init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
				// Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					// we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255,255,255,1))
					// ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					// however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	end

end

function SWEP:Holster()
	
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	  local owner = self:GetOwner()
  owner:SetNWBool("Headtaker_Speed", false)
	
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			// when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r // Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			// !! WORKAROUND !! //
			// We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			// !! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				// !! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	/**************************
		Global utility code
	**************************/

	// Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	// Does not copy entities of course, only copies their reference.
	// WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end

