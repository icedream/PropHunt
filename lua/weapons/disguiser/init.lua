// Weapon info for server
SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.ShouldDropOnDie = false

// DEBUG DEBUG DEBUG
print("[Disguiser] Loading serverside...")

// Downloads for the client
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

// Local stuff
SWEP.UndisguiseAs = nil
SWEP.UndisguiseAsMass = nil
SWEP.UndisguiseAsSkin = nil
SWEP.UndisguiseAsSolid = nil
SWEP.UndisguiseAsFullRotation = nil
SWEP.DisguisedAs = nil

// Banned prop models
local PropConfiguration = {}
PropConfiguration["models/props/cs_assault/dollar.mdl"] = {
	Banned = true
}
PropConfiguration["models/props/cs_assault/money.mdl"] = {
	Banned = true
}
PropConfiguration["models/props/cs_office/snowman_arm.mdl"] = {
	Banned = true
}
PropConfiguration["models/props/cs_office/computer_mouse.mdl"] = {
	Banned = true
}
PropConfiguration["models/props/cs_office/projector_remote.mdl"] = {
	Banned = true
}
PropConfiguration["models/props_junk/bicycle01a.mdl"] = {
	// The bicycle in cs_italy has a too big bounding box, you
	// can't even get through doors without this correction
	OBBMinsCorrection = Vector(28, -28, 0),
	OBBMaxsCorrection = Vector(-28, 28, 0)
}

// Door exploits
local ExploitableDoors = {
	"func_door",
	"prop_door_rotating",
	"func_door_rotating"
}

// Usable props on the map
local UsablePropEntities = {
	"prop_physics",
	"prop_physics_multiplayer"
}

// The actual disguise action
function SWEP:Disguise(entity)
	
	// Make sure the model file is not banned
	if self:HasPropConfig(model_file) && self:GetPropConfig(model_file).Banned then
		umsg.Start("cantDisguiseAsBannedProp")
		umsg.End()
	end
	
	// Make sure we are valid
	if (!IsValid(self)) then return false end
	
	// Make sure the player is alive and valid
	if (!IsValid(self.Owner) || !self.Owner:Alive()) then return false end
	
	local owner = self.Owner
	
	// Make sure we aren't already that model
	if (owner:GetModel() == entity:GetModel() && owner:GetSkin() == entity:GetSkin()) then return true end
	
	local physobj = entity:GetPhysicsObject()
	local ophysobj = owner:GetPhysicsObject()
	
	// Back up model
	if (!self.UndisguiseAs) then
		self.UndisguiseAs = owner:GetModel()
		self.UndisguiseAsSkin = owner:GetSkin()
		self.UndisguiseAsMass = ophysobj:GetMass()
		self.UndisguiseAsBloodColor = owner:GetBloodColor()
		self.UndisguiseAsSolid = owner:GetSolid()
		self.UndisguiseAsFullRotation = owner:GetAllowFullRotation()
	end
	
	// Disguise as given model
	self:EnableThirdPerson(owner)
	owner:DrawViewModel(false)
	owner:DrawWorldModel(false)
	owner:SetModel(entity:GetModel())
	owner:SetSolid(SOLID_BSP)
	owner:SetBloodColor(BLOOD_COLOR_RED)
	owner:SetSkin(entity:GetSkin()) // coloring
	owner:SetPos(owner:GetPos() - Vector(0, 0, entity:OBBMins().z - 2)) // anti-stuck
	
	// Apply new physics, too
	ophysobj:SetMass(physobj:GetMass())
	self:UpdateHealth(math.Clamp(physobj:GetVolume() / 300, 1, 200))
	
	// Apply new hull
	local obbmaxs = entity:OBBMaxs()
	local obbmins = entity:OBBMins()
	/*
	local obbmargin = Vector(2, 2, 0)
	obbmaxs = obbmaxs + obbmargin
	obbmins = obbmins - obbmargin
	*/
	if self:HasPropConfig(model_file) then
		// Look for correction values
		local pcfg = self:GetPropConfig(model_file)
		if !!pcfg["OBBMaxsCorrection"] then
			obbmaxs = obbmaxs + pcfg["OBBMaxsCorrection"]
		end
		if !!pcfg["OBBMinsCorrection"] then
			obbmins = obbmins + pcfg["OBBMinsCorrection"]
		end
	end
	owner:SetHull(obbmins, obbmaxs)
	owner:SetHullDuck(obbmins, obbmaxs) -- ducking shouldn't work for props
	
	// Notify all clients about the new hull so the player appears
	// correct for everyone
	umsg.Start("setBounding")
	umsg.Entity(owner)
	umsg.Vector(entity:OBBMins())
	umsg.Vector(entity:OBBMaxs())
	umsg.End()
	
	// Pop!
	owner:EmitSound("Disguiser.Disguise")
	
	// We're now disguised!
	self.DisguisedAs = entity:GetModel()
	owner.Disguised = true
	
	// DEBUG DEBUG DEBUG
	print(owner:Name() .. " switched to model " .. entity:GetModel())
	
	return true
end

// Undisguise
function SWEP:Undisguise()
	
	// Make sure we are valid
	if (!IsValid(self)) then return false end
	
	// Make sure the player is alive and valid
	if (!IsValid(self.Owner) || !self.Owner:Alive()) then return false end
	
	// Make sure we are disguised already
	if (self.DisguisedAs == nil) then return false end
	
	// Make sure we have an old model to revert to
	if (self.UndisguiseAs == nil) then return false end
	
	local owner = self.Owner
	local ophysobj = owner:GetPhysicsObject()
	
	// Revert to old model
	owner:SetModel(self.UndisguiseAs)
	owner:SetMoveType(MOVETYPE_WALK)
	owner:SetSkin(self.UndisguiseAsSkin)
	owner:SetSolid(self.UndisguiseAsSolid)
	owner:SetAllowFullRotation(self.UndisguiseAsFullRotation) // up/down rotation
	owner:SetBloodColor(self.UndisguiseAsBloodColor)
	
	// Revert to old physics
	ophysobj:SetMass(self.UndisguiseAsMass)
	self:UpdateHealth(100)
	
	// Hull reset
	owner:ResetHull()
	owner:SetPos(owner:GetPos() - Vector(0, 0,owner:OBBMins().z - 2)) // anti-stuck
	umsg.Start("resetHull", owner)
	umsg.Entity(owner)
	umsg.End()
	
	// Pop!
	owner:EmitSound("Disguiser.Undisguise")
	
	// We're no longer disguised
	self:DisableThirdPerson(owner)
	owner:DrawViewModel(true)
	owner:DrawWorldModel(true)
	self.UndisguiseAs = nil
	self.DisguisedAs = nil
	owner.Disguised = false
	
	return true
end

function SWEP:UpdateHealth(ent_health)
	local player = self.Owner
	
	if (!player || !IsValid(player)) then return false end
	
	// Scale player health up to entity's maximum health
	local new_health = math.Clamp((player:Health() / player:GetMaxHealth()) * ent_health, 1, 200)
	
	// Transfer to player
	player:SetHealth(new_health)
	player:SetMaxHealth(ent_health)
end

// this is usually triggered on left mouse click
function SWEP:PrimaryAttack()
	self:DoShootEffect()
	
	local trace = self.Owner:GetEyeTrace()
	self:DoShootEffect( trace.HitPos, trace.HitNormal, trace.Entity, trace.PhysicsBone, IsFirstTimePredicted() )

	// Are we aiming at an actual prop?
	local entity = trace.Entity
	if (
		!trace.Hit
		|| !entity:GetModel()
		|| !table.HasValue(UsablePropEntities, entity:GetClass()) /* allowed prop class */
		|| table.HasValue(ExploitableDoors, entity:GetClass()) /* banned door exploit */) then
		// Undisguise instead
		self:Undisguise()
		return
	end
	
	// Now let's disguise, shall we?
	self:Disguise(entity)
	
end

function SWEP:DoShootEffect( hitpos, hitnormal, entity, physbone, bFirstTimePredicted )

	self.Weapon:EmitSound("Disguiser.Shot")
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )         -- View model animation

	-- There's a bug with the model that's causing a muzzle to
	-- appear on everyone's screen when we fire this animation.
	self.Owner:SetAnimation( PLAYER_ATTACK1 )                        -- 3rd Person Animation

	if ( !bFirstTimePredicted ) then return end

	local effectdata = EffectData()
	effectdata:SetOrigin( hitpos )
	effectdata:SetNormal( hitnormal )
	effectdata:SetEntity( entity )
	effectdata:SetAttachment( physbone )
	util.Effect( "selection_indicator", effectdata )        

	local effectdata = EffectData()
	effectdata:SetOrigin( hitpos )
	effectdata:SetStart( self.Owner:GetShootPos() )
	effectdata:SetAttachment( 1 )
	effectdata:SetEntity( self.Weapon )
	util.Effect( "ToolTracer", effectdata )

end

// this is usually triggered on right mouse click
function SWEP:SecondaryAttack()
	// Are we disguised?
	if !!self.DisguisedAs then
		// Toggle full rotation (up/down)
		self.Owner:SetAllowFullRotation(!self.Owner:GetAllowFullRotation())
	end
end

function SWEP:DisableThirdPerson(player)
	if !player:GetNetworkedBool("thirdperson") then
		return
	end
	
	local entity = player:GetViewEntity()
	player:SetNetworkedBool("thirdperson", false)
	entity:Remove()
	
	player:SetViewEntity(player)
end

function SWEP:EnableThirdPerson(player)
	
	if player:GetNetworkedBool("thirdperson") then
		return
	end
	
	local entity = ents.Create("prop_dynamic")
	entity:SetModel(player:GetModel())
	entity:Spawn()
	entity:SetAngles(player:GetAngles())
	entity:SetMoveType(MOVETYPE_NONE)
	entity:SetParent(player)
	entity:SetOwner(player)
	entity:SetPos(player:GetPos() + Vector(0, 0, 60))
	entity:SetRenderMode(RENDERMODE_NONE)
	entity:SetSolid(SOLID_NONE)
	player:SetViewEntity(entity)
	
	player:SetNetworkedBool("thirdperson", true)
end

hook.Add("PlayerDeath", "Disguiser.ThirdPersonDeath", function(victim, inflictor, killer)

	victim:SetNetworkedBool("thirdperson", false)
	local ventity = victim:GetViewEntity()
	
	// Escape third-person mode
	if (IsValid(ventity)) then
		ventity:Remove()
		victim:SetViewEntity(victim)
	end
	
	if (!!victim.Disguised) then
		// fake entity for spectacular death!
		local dentity = ents.Create("prop_physics")
		dentity:SetModel(victim:GetModel())
		dentity:SetAngles(victim:GetAngles())
		dentity:SetPos(victim:GetPos())
		dentity:SetVelocity(victim:GetVelocity())
		local physics = victim:GetPhysicsObject()
		dentity:SetBloodColor(BLOOD_COLOR_RED) -- this thing was alive, ya know? :(
		dentity:Spawn()
		local dphysics = dentity:GetPhysicsObject()
		dphysics:SetAngles(physics:GetAngles())
		dphysics:SetVelocity(physics:GetVelocity())
		dphysics:SetDamping(physics:GetDamping())
		dphysics:SetInertia(physics:GetInertia())
		dentity:Fire("break", "", 0)
		dentity:Fire("kill", "", 2)
		dentity:Fire("enablemotion","",0)
		
		// Manually draw additional blood (for some reason setting the blood color has no effect)
		local traceworld = {}
		traceworld.start = victim:GetPos() + Vector(0, 0, 20)
		traceworld.endpos = traceworld.start + (Vector(0,0,-1) * 8000) // aim max. 8000 units down
		local trw = util.TraceLine(traceworld) // Send the trace and get the results.
		local edata = EffectData()
		edata:SetStart(victim:GetPos() - physics:GetVelocity())
		edata:SetOrigin(victim:GetPos())
		edata:SetNormal(trw.Normal)
		edata:SetEntity(dentity)
		util.Effect("BloodImpact", edata)
		util.Decal("Splash.Large", trw.HitPos + trw.HitNormal, trw.HitPos - trw.HitNormal)
	end
end)

function SWEP:HasPropConfig(name)
	return !!PropConfiguration && !!PropConfiguration[name]
end

function SWEP:GetPropConfig(name)
	if !PropConfiguration || !PropConfiguration[name] then return {} end
	return PropConfiguration[name]
end

function SWEP:Deploy()
	self.Owner:DrawViewModel(!self.DisguisedAs)
	self.Owner:DrawWorldModel(!self.DisguisedAs)
end
