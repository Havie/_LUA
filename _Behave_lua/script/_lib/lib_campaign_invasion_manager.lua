----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	INVASION_MANAGER
--
---	@loaded_in_campaign
---	@class invasion_manager invasion_manager Invasion Manager
--- @desc THIS PAGE IS W.I.P
--- @desc The Invasion Manager is used to create and manage scripted A.I invasions in the campaign

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

---------------------
---- Definitions ----
---------------------
invasion_manager = {
	invasions = {}
};
im_spawn_locations = {};
invasion = {};

function invasion_manager:__tostring()
	return TYPE_INVASION_MANAGER;
end

function invasion_manager:__type()
	return TYPE_INVASION_MANAGER;
end


----------------------------------------------------------------------------
--- @section Invasion Manager Functions
--- @desc Functions relating to the Invasion Manager and its control over the various Invasions it manages
----------------------------------------------------------------------------

--- @function new_invasion
--- @desc Adds a new invasion to the invasion manager
--- @p string invasion key
--- @p string faction key
--- @p string force list
--- @p table spawn location
--- @return invasion The new invasion object created by this function
function invasion_manager:new_invasion(key, faction_key, force_list, spawn_location)
	ModLog("Invasion Manager: New Invasion '" .. tostring(key) .. "'");
	ModLog("\tFaction: "..tostring(faction_key));
	ModLog("\tForce: "..tostring(force_list));
	ModLog("\tSpawn: "..tostring(spawn_location));
	


	if self.invasions[key] ~= nil then
		script_error("ERROR: Attempted to create an invasion with a key that already exists!");
		return nil;
	end

	local new_invasion = invasion:new();
	new_invasion.key = key;
	new_invasion.faction = faction_key;
	new_invasion.general_cqi = nil;
	new_invasion.new_general = nil;
	--new_invasion.immortal_general = nil;
	new_invasion.force_cqi = nil;
	new_invasion.unit_list = force_list;
	new_invasion.unit_list_table = {};
	new_invasion.spawn = self:parse_spawn_location(spawn_location);
	new_invasion.target_type = "NONE";
	new_invasion.target = nil;
	new_invasion.target_faction = nil;
	new_invasion.effect = nil;
	new_invasion.effect_turns = nil;
	new_invasion.turn_spawned = nil;
	new_invasion.started = false;
	new_invasion.stop_at_end = false;
	new_invasion.patrol_position = nil;
	new_invasion.aggro_enabled = false;
	new_invasion.aggro_radius = nil;
	new_invasion.aggro_targets = nil;
	new_invasion.aggro_target_cqi = nil;
	new_invasion.aggro_turn_abort = nil;
	new_invasion.aggro_turn_abort_value = nil;
	new_invasion.aggro_cooldown = nil;
	new_invasion.aggro_cooldown_value = nil;
	new_invasion.callback = nil;
	new_invasion.prespawned = false;
	new_invasion.target_owner_abort = false;
	new_invasion.respawn = false;
	new_invasion.respawn_count = nil;
	new_invasion.respawn_delay = nil;
	new_invasion.respawn_turn = nil;
	--new_invasion.maintain_army = false;
	--new_invasion.maintain_army_chance = nil;
	--new_invasion.rogue_army = false;
	new_invasion.initial_force_strength = 100; -- new 3k_dlc04 value.
	new_invasion.event_feed_suppressed = false;
	new_invasion.force_retreated_flag = false;
    
	
	if(faction_key=="3k_main_faction_zhang_yan") then 
		--If list doesnt contain _captain, make a different one ToDo
		ModLog("my strings length is:")
		ModLog("                    :"..string.len(force_list))
		
		if(force_list ==nil) then
			ModLog("changed0")
			new_invasion.unit_list = "3k_main_unit_metal_black_mountain_marauders,3k_main_unit_wood_black_mountain_outlaws,3k_main_unit_water_black_mountain_hunters"
		--elseif (string.len(force_list) ==0) then  -- doesnt work on commander retinue
			--ModLog("changed1 (general?)")
			--	new_invasion.unit_list = "3k_main_unit_metal_black_mountain_marauders,3k_main_unit_wood_black_mountain_outlaws,3k_main_unit_water_black_mountain_hunters"
		else
			ModLog("changed2 (captains?)")
			new_invasion.unit_list = "3k_main_unit_metal_mercenary_infantry_captain,3k_main_unit_metal_black_mountain_marauders,3k_main_unit_wood_black_mountain_outlaws,3k_main_unit_water_black_mountain_hunters"

		end
	end
	
	
    ModLog("Idk what the point of the unit_list_table is, it doesnt seem to get used, uses unit_list instead")
	-- Force list can be empty in 3K, so we allow this.
	    if force_list then
		for unit in string.gmatch(force_list, '([^,]+)') do
            if(faction_key == "3k_main_faction_zhang_yan" )then --This doesnt work because its using self.unit_list instead...
               ModLog("we found zhang yangs faction, changing the pointless unit table that seems to do nothing")
			   if(unit == "3k_main_unit_wood_spear_warriors") then 
                   ModLog("added:".."3k_main_unit_wood_black_mountain_outlaws")
                    table.insert(new_invasion.unit_list_table, "3k_main_unit_wood_black_mountain_outlaws");
                 elseif(unit == "3k_main_unit_fire_lance_cavalry") then 
                      ModLog("added:".."3k_main_unit_metal_black_mountain_marauders")
                       table.insert(new_invasion.unit_list_table, "3k_main_unit_metal_black_mountain_marauders");
                 elseif(unit == "3k_main_unit_water_archer_??") then 
                     ModLog("added:".."3k_main_unit_water_black_mountain_hunters")
                   table.insert(new_invasion.unit_list_table, "3k_main_unit_water_black_mountain_hunters");
				else
                table.insert(new_invasion.unit_list_table, unit);
                end
            else
                table.insert(new_invasion.unit_list_table, unit);
                ModLog("ran this for loop for unit: "..tostring(unit))
            end
		end
	end;
	
	

	
	
	self.invasions[key] = new_invasion;
	ModLog("\tInvasion Created! (1)");
	return new_invasion;
end

------------------------------------------------------------------------------------
---- Adds a new invasion to the invasion manager created from an existing force ----
------------------------------------------------------------------------------------
function invasion_manager:new_invasion_from_existing_force(key, force)
	ModLog("Invasion Manager: New Invasion from existing force'"..tostring(key).."'...");
	ModLog("\tForce: "..tostring(force));
	
	if self.invasions[key] ~= nil then
		ModLog("ERROR: Attempted to create an invasion with a key that already exists!");
		return nil;
	end

	local new_invasion = invasion:new();
	new_invasion.key = key;
	new_invasion.faction = force:faction():name();
	new_invasion.general_cqi = force:general_character():command_queue_index();
	new_invasion.new_general = nil;
	--new_invasion.immortal_general = nil;
	new_invasion.force_cqi = force:command_queue_index();
	new_invasion.unit_list = "";
	new_invasion.unit_list_table = {};
	for i = 0, force:unit_list():num_items() - 1 do
		local unit_key = force:unit_list():item_at(i):unit_key();
		table.insert(new_invasion.unit_list_table, unit_key);
		
		if i == 0 then
			new_invasion.unit_list = unit_key;
		else
			new_invasion.unit_list = new_invasion.unit_list..","..unit_key;
		end
	end
	new_invasion.spawn = {x = force:general_character():logical_position_x(), y = force:general_character():logical_position_y()};
	new_invasion.target_type = "NONE";
	new_invasion.target = nil;
	new_invasion.target_faction = nil;
	new_invasion.effect = nil;
	new_invasion.effect_turns = nil;
	new_invasion.turn_spawned = nil;
	new_invasion.started = false;
	new_invasion.stop_at_end = false;
	new_invasion.patrol_position = nil;
	new_invasion.aggro_enabled = false;
	new_invasion.aggro_radius = nil;
	new_invasion.aggro_targets = nil;
	new_invasion.aggro_target_cqi = nil;
	new_invasion.aggro_turn_abort = nil;
	new_invasion.aggro_turn_abort_value = nil;
	new_invasion.aggro_cooldown = nil;
	new_invasion.aggro_cooldown_value = nil;
	new_invasion.callback = nil;
	new_invasion.prespawned = true;
	new_invasion.target_owner_abort = false;
	new_invasion.respawn = false;
	new_invasion.respawn_count = nil;
	new_invasion.respawn_delay = nil;
	new_invasion.respawn_turn = nil;
	--new_invasion.maintain_army = false;
	--new_invasion.maintain_army_chance = nil;
	--new_invasion.rogue_army = force:faction():culture() == "wh2_main_rogue";
	
	self.invasions[key] = new_invasion;
	ModLog("\tInvasion Created!(2)");
	return new_invasion;
end

------------------------------------------------------------
---- Create a new spawn location that can be used later ----
------------------------------------------------------------
function invasion_manager:new_spawn_location(key, x, y)
	local spawn = {};
	spawn.x = x;
	spawn.y = y;
	im_spawn_locations[key] = spawn;
end

--------------------------------------------------------------------------------
---- Allows parsing of arbitrary spawn location data into a relevant format ----
--------------------------------------------------------------------------------
function invasion_manager:parse_spawn_location(spawn_location)
	ModLog("Invasion Manager: Parsing a Spawn Location of '"..tostring(spawn_location).."'");
	local return_val = nil;
	
	if type(spawn_location) == "table" then
		-- Assume it's an X/Y coordinate table
		return_val = {x = spawn_location.x or spawn_location[1], y = spawn_location.y or spawn_location[2]};		
	elseif type(spawn_location) == "string" then
		-- Assume it's a predetermined location key
		for key, value in pairs(im_spawn_locations) do
			if spawn_location == key then
				return_val = {x = value.x, y = value.y};
			end
		end
	elseif not spawn_location then
		-- If no spawn location is supplied, pick a random one
		local size = 0;
		for key, value in pairs(im_spawn_locations) do
			size = size + 1;
		end
		
		-- Pick a random record based on the size
		local index = cm:random_number(size);
		local count = 0;
		
		for key, value in pairs(im_spawn_locations) do
			count = count + 1;
			
			if count == index then
				local chosen_x = value.x;
				local chosen_y = value.y;
				
				if self:is_valid_position(chosen_x, chosen_y) then
					return_val = {x = chosen_x, y = chosen_y};
				else
					script_error("ERROR: Parse_Spawn_Location() called but failed as a character is standing at coordinates ["..tostring(spawn_location).."]");
				end
				break;
			end
		end
	end
	
	if return_val then
		return return_val;
	else
		script_error("ERROR: Parse_Spawn_Location() called but failed to find coordinates ["..tostring(spawn_location).."]");
	end
end

-----------------------------------------------------------------------------------------------
---- Validates a set of coordinates by testing if a character is standing at that location ----
-----------------------------------------------------------------------------------------------
function invasion_manager:is_valid_position(x, y)
	local faction_list = cm:query_model():world():faction_list();
	
	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i);
		local char_list = faction:character_list();

		for i = 0, char_list:num_items() - 1 do
			local character = char_list:item_at(i);
			
			if character:logical_position_x() == x and character:logical_position_y() == y then
				return false;
			end
		end
	end
	return true;
end

-------------------------------------------------------
---- Returns an invasion from the invasion manager ----
-------------------------------------------------------
function invasion_manager:get_invasion(key)
	if key and self.invasions[key] then
		return self.invasions[key];
	end
end

-------------------------------------------------------
---- Removes an invasion from the invasion manager ----
-------------------------------------------------------
function invasion_manager:remove_invasion(key)
	if key ~= nil then
		ModLog("Invasion Manager: Removing Invasion '"..key.."'");
		
		if key == 'campaign_invasion_1' then
			ModLog("found bad key")
			FixCppLuBu()
		end
		
		self.invasions[key] = nil;
		core:remove_listener("INVASION_"..key);
		
	end
end

----------------------------------------------------
---- Kills an invasion via the invasion manager ----
----------------------------------------------------
function invasion_manager:kill_invasion_by_key(key)	
	local invasion = self.invasions[key];
	
	if invasion then
		ModLog("Invasion Manager: Killing Invasion [" .. invasion.key .. "]");
		invasion:kill();
	end
end

---------------------------------------
---- prints values for any invasion ---
---------------------------------------
function invasion_manager:print(string)
	out.random_army(string);
end;

---------------------------------------
---- Creates a new invasion object ----
---------------------------------------
function invasion:new(o)
	invasion_manager:print("Invasion: New Invasion object created... ["..tostring(o).."]");
	o = o or {};
	setmetatable(o, self);
	self.__index = self;
	return o;
end

-----------------------------------------
---- Sets the target for an invasion ----
-----------------------------------------
function invasion:set_target(target_type, target, target_faction_key)
	invasion_manager:print("Invasion: Set Target for '"..self.key.."'...");
	target_type = target_type or "NONE";
	
	if target_type == "REGION" then
		invasion_manager:print("\tTarget: "..target_type.." - "..tostring(target));
		self.target_type = target_type;
		self.target = target;		
	elseif target_type == "CHARACTER" then
		invasion_manager:print("\tTarget: "..target_type.." - "..tostring(target));
		self.target_type = target_type;
		self.target = target;
	elseif target_type == "LOCATION" then
		invasion_manager:print("\tTarget: "..target_type.." - X:"..tostring(target.x).." / Y:"..tostring(target.y));
		self.target_type = target_type;
		self.target = target;
	elseif target_type == "PATROL" then
		invasion_manager:print("\tTarget: "..target_type.." - "..tostring(target));
		self.target_type = target_type;
		for i = 1, #target do
			if target[i] == "start" then
				target[i] = {x = self.spawn.x, y = self.spawn.y};
			end
		end
		self.target = target;
	else
		invasion_manager:print("\tTarget: NONE");
		self.target_type = "NONE";
		self.target = nil;
	end
	
	self.target_faction = target_faction_key or nil;
end

-------------------------------------------------------
---- Sets an invasion to no longer have any target ----
-------------------------------------------------------
function invasion:suppress_event_feed(suppress)
	self.event_feed_suppressed = suppress;
end;

-------------------------------------------------------
---- Sets an invasion to no longer have any target ----
-------------------------------------------------------
function invasion:remove_target()
	invasion_manager:print("Invasion: Removing Target for '"..self.key.."'");
	self.target_type = "NONE";
	self.target = nil;
	self.target_faction = nil;
end

------------------------------------------------------------------------------------------------------------------------------------------------
---- Add an aggravation radius to this invasion in which the force will attack all specified targets.										----
---- A value of -1 will attack any valid target the character can reach. If no target(s) are specified then will target any warring faction ----
---- A value of 0 (or nil) will attack the nearest valid target.																			----
---- If no target(s) are specified then will target any warring faction.																	----
------------------------------------------------------------------------------------------------------------------------------------------------
function invasion:add_aggro_radius(radius, target_list, cooldown_timer, abort_timer)
	radius = radius or 0;
	target_list = target_list or {"war"};
	cooldown_timer = cooldown_timer or 0;
	abort_timer = abort_timer or 0;
	
	invasion_manager:print("Invasion: Adding Aggro Radius of "..tostring(radius).." for '"..self.key.."' with "..tostring(#target_list).." targets, a cooldown of "..tostring(cooldown_timer).." and an abort time of "..tostring(abort_timer).." turns");
	self.aggro_enabled = true;
	self.aggro_radius = radius;
	self.aggro_targets = target_list;
	self.aggro_turn_abort = abort_timer;
	self.aggro_turn_abort_value = 0;
	self.aggro_cooldown = cooldown_timer;
	self.aggro_cooldown_value = 0;
end

-------------------------------------------------------------
---- Removes all aggravation behaviour from the invasion ----
-------------------------------------------------------------
function invasion:remove_aggro_radius()
	self.aggro_enabled = false;
	self.aggro_radius = nil;
	self.aggro_targets = nil;
	self.aggro_target_cqi = nil;
	self.aggro_turn_abort = nil;
	self.aggro_turn_abort_value = nil;
	self.aggro_cooldown = nil;
	self.aggro_cooldown_value = nil;
end

------------------------------------------------------------------------------------------------------------
---- Sets if the Invasion will abort if the owner of the target differs to the Invasions faction target ----
------------------------------------------------------------------------------------------------------------
function invasion:abort_on_target_owner_change(abort)
	invasion_manager:print("Invasion: Invasion '"..self.key.."' will abort on target owner change: "..tostring(abort));
	self.target_owner_abort = abort;
end

---------------------------------------------------------------
---- Sets a General to be used when spawning this invasion ----
---------------------------------------------------------------
function invasion:assign_general(character)
	if type(character) == "number" then
		self.general_cqi = character;
		self.new_general = nil;
	elseif character:is_null_interface() == false then
		self.general_cqi = character:command_queue_index();
		self.new_general = nil;
	end
end

-------------------------------------------------------------------------------------------
---- Sets up a general to be created to command this invasion force when it is spawned ----
-------------------------------------------------------------------------------------------
function invasion:create_general(make_faction_leader, agent_subtype, agent_template, forename, clan_name, family_name, other_name)
	local agent_type = "general";
	make_faction_leader = make_faction_leader or false;
	agent_subtype = agent_subtype or "3k_general_fire";
	agent_template = agent_template or "";
	forename = forename or "";
	clan_name = clan_name or "";
	family_name = family_name or "";
	other_name = other_name or "";
	
	self.new_general = {agent_type = agent_type, agent_subtype = agent_subtype, agent_template = agent_template, forename = forename, clan_name = clan_name, family_name = family_name, other_name = other_name, make_faction_leader = make_faction_leader};
	self.general_cqi = nil;
end

function invasion:set_initial_force_strength(initial_force_strength)
	self.initial_force_strength = initial_force_strength;
end;

----------------------------------------------------------------------------------
---- Sets whether the General leading this invasion should be immortal or not ----
----------------------------------------------------------------------------------
function invasion:set_general_immortal(is_immortal)
	script_error("Immortal character flags are not supported in 3K.");

	--[[
	self.immortal_general = is_immortal;
	
	if self:has_started() then
		local general = self:get_general();
		
		if general:is_null_interface() == false then
			cm:set_character_immortality("character_cqi:"..general:command_queue_index(), is_immortal);
		end
	end]]--
end

function invasion:set_force_retreated()
	self.force_retreated_flag = true;
end

---------------------------------------------------------------------------
---- Sets the Invasion should not move after completing it's objective ----
---------------------------------------------------------------------------
function invasion:should_stop_at_end(should_stop)
	if should_stop == true then
		invasion_manager:print("Invasion: Invasion will stop after target");
	else
		invasion_manager:print("Invasion: Invasion will NOT stop after target");
	end
	self.stop_at_end = should_stop;
end

-----------------------------------------------------------------------------
---- Allows you to apply an effect bundle to the forces in this invasion ----
-----------------------------------------------------------------------------
function invasion:apply_effect(effect_key, turns)
	script_error("Applying effects to forces is not supported in 3K.")
	--[[
	if effect_key == nil and turns == nil then
		invasion_manager:print("Invasion: Applying stored effect '"..self.effect.."' ("..self.effect_turns..") to force "..self.force_cqi);
		cm:apply_effect_bundle_to_force(self.effect, self.force_cqi, self.effect_turns);
	else
		if self.started == true then
			invasion_manager:print("Invasion: Applying effect '"..effect_key.."' ("..turns..") to force "..self.force_cqi);
			cm:apply_effect_bundle_to_force(effect_key, self.force_cqi, turns);
		else
			invasion_manager:print("Invasion: Preparing effect '"..effect_key.."' ("..turns..")");
			self.effect = effect_key;
			self.effect_turns = turns;
		end
	end
	]]--
end

function invasion:apply_faction_effect(bundle_key, turns)
	turns = turns or -1;

	if bundle_key == nil then
		script_error("ERROR: No bundle specified.");
		return;
	end;

	cm:apply_effect_bundle(bundle_key, self.faction, turns);
end;

-----------------------------------------------------------------------------------------
---- Allows you to add experience to the general in this invasion or set their level ----
-----------------------------------------------------------------------------------------
function invasion:add_character_experience(experience_amount)
	if self.general_cqi then
		local modify_character = cm:modify_character(self.general_cqi);

		if experience_amount == nil then
			invasion_manager:print("Invasion: Applying stored character experience amount of " .. self.experience_amount .. " to general " .. self.general_cqi);
			
			modify_character:add_experience(self.experience_amount, 0);
			return;

		elseif self.started == true then
			invasion_manager:print("Invasion: Applying character experience amount of " .. experience_amount .. " to general " .. self.general_cqi);
			
			modify_character:add_experience(experience_amount, 0);
			return;
		end
	end

	invasion_manager:print("Invasion: Preparing character experience amount of " .. experience_amount);
	self.experience_amount = experience_amount;
end

--------------------------------------------------------------------------------
---- Allows you to add experience to the units of the army in this invasion ----
--------------------------------------------------------------------------------
function invasion:add_unit_experience(unit_experience_amount)
	script_error("Assing unit experience is not supported in 3k.");

	--[[
	if unit_experience_amount == nil then
		invasion_manager:print("Invasion: Applying stored unit experience amount of " .. self.unit_experience_amount .. " to units of general " .. self.general_cqi);
		cm:add_experience_to_units_commanded_by_character(cm:char_lookup_str(self.general_cqi), self.unit_experience_amount);
	else
		if self.started == true then
			invasion_manager:print("Invasion: Applying unit experience amount of " .. unit_experience_amount .. " to units of general " .. self.general_cqi);
			cm:add_experience_to_units_commanded_by_character(cm:char_lookup_str(self.general_cqi), unit_experience_amount);
		else
			self.unit_experience_amount = (self.unit_experience_amount or 0) + unit_experience_amount;
			invasion_manager:print("Invasion: Preparing unit experience amount of " .. unit_experience_amount .. " - Total: " .. self.unit_experience_amount);
		end
	end
	]]--
end

-------------------------------------------------------------------------------------------------------------------------------
---- Allow you to add a respawn to the invasion so that if it dies it will respawn a set amount of times after a set delay ----
-------------------------------------------------------------------------------------------------------------------------------
function invasion:add_respawn(respawn, respawn_count, respawn_delay)
	if respawn == true then
		self.respawn = true;
		self.respawn_count = respawn_count or 1;
		self.respawn_delay = respawn_delay or 10;
		self.respawn_turn = 0;
	else
		self.respawn = false;
		self.respawn_count = nil;
		self.respawn_delay = nil;
		self.respawn_turn = nil;
	end
end

----------------------------------------------------------------------------------------------------------------------------------
---- Allows you to set the invasion to maintain its army strength by adding a missing unit each turn with a percentage chance ----
----------------------------------------------------------------------------------------------------------------------------------
function invasion:should_maintain_army(maintain, chance)
	script_error("Mainhtain army not supported.");
	
	--[[
	if maintain == true then
		chance = chance or 100;
		self.maintain_army_chance = chance;
	else
		self.maintain_army_chance = nil;
	end
	self.maintain_army = maintain;
	]]--
end

-----------------------------
---- Begin the invasion! ----
-----------------------------
function invasion:start_invasion(callback_function, declare_war, invite_attacker_allies, invite_defender_allies)
	invasion_manager:print("Invasion: Starting Invasion for '"..self.key.."'...");
	ModLog("Invasion: Starting Invasion for '"..self.key.."'...")
	--ModLog(tostring(debug.traceback()))
	if declare_war == nil then
		declare_war = true;
	end

	if invite_attacker_allies == nil then
		invite_attacker_allies = true;
	end

	if invite_defender_allies == nil then
		invite_defender_allies = true;
	end
	
	if self.started == false then
		self.started = true;
		self.callback = callback_function or nil;
		
		if self.prespawned == true then
			invasion_manager:print("\tPre-Spawned force: Ignoring force spawning...");
			self:force_created(self.general_cqi, declare_war, invite_attacker_allies, invite_defender_allies);
		else
			invasion_manager:print("\tSpawning Force '"..tostring(self.unit_list).."'...");
            ModLog("Spawning Force '"..tostring(self.unit_list))
			local temp_region = cm:query_model():world():region_manager():region_list():item_at(0):name();
			
			if self.new_general ~= nil then
				invasion_manager:print("\t\tCreating new general!");
                ModLog("creating new general"); --PRINT OUT EVERYTHING
				ModLog("faction_key:"..tostring(self.faction))
				ModLog("unit_list:"..tostring(self.unit_list))
				ModLog("region_key:"..tostring(temp_region))
				ModLog("      x:"..tostring(self.spawn.x))
				ModLog("      y:"..tostring(self.spawn.y))
				ModLog("agent_type:"..tostring(self.new_general.agent_type))
				ModLog("agent_subtype:"..tostring(self.new_general.agent_subtype))
				ModLog("character_template_key:"..tostring(self.new_general.agent_template))
				ModLog("id:"..tostring(self.key))
				ModLog("make_faction_leader:"..tostring( self.new_general.make_faction_leader))
				ModLog("success_callback:"..tostring("ignore"))
				--Why do i have this here?
				--create_force_with_general(faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, character_template_key, id, make_faction_leader, success_callback)
				ModLog("create force create_force_with_general here:")

				cm:create_force_with_general(self.faction, self.unit_list, temp_region, self.spawn.x, self.spawn.y, 
					self.new_general.agent_type, self.new_general.agent_subtype, self.new_general.agent_template, self.key, self.new_general.make_faction_leader,
						function(cqi) self:force_created(cqi, declare_war, invite_attacker_allies, invite_defender_allies) end, self.initial_force_strength);
			else
				if self.general_cqi == nil then
					-- create_force(faction_key, unit_list, region_key, x, y, id, exclude_named_characters, success_callback)
					ModLog("Did Not Spawn Force becuz cqi = nil?");
					cm:create_force(self.faction, self.unit_list, temp_region, self.spawn.x, self.spawn.y, self.key, true,
						function(cqi) self:force_created(cqi, declare_war, invite_attacker_allies, invite_defender_allies) end, self.initial_force_strength);
				else
					--char_str, faction_key, unit_list, region_key, x, y, id, success_callback, starting_health_percentage)
					ModLog("Creating Force @ spawn loc:".. tostring(self.spawn.x) .. " " .. tostring(self.spawn.y) );
					cm:create_force_with_existing_general(self.general_cqi, self.faction, self.unit_list, temp_region, self.spawn.x, self.spawn.y, self.key,
						function(cqi) self:force_created(cqi, declare_war, invite_attacker_allies, invite_defender_allies) end, self.initial_force_strength);
				end
			end
		end
		ModLog("passed create Force");
		invasion_manager:print("\tAdding Listener 'INVASION_"..self.key.."'");
		core:add_listener(
			"INVASION_"..self.key,
			"FactionBeginTurnPhaseNormal",
			function(context)
				return context:faction():name() == self.faction;
			end,
			function(context) self:advance() end,
			true
		);
	else
		ModLog("ERROR: Trying to start an invasion that has already been started!");
	end

	ModLog("Finished invasion:start_invasion")
end

function invasion:force_created(general_cqi, declare_war, invite_attacker_allies, invite_defender_allies, was_respawn)
	self.general_cqi = general_cqi;
	self.declare_war = declare_war;
	self.invite_attacker_allies = invite_attacker_allies;
	self.invite_defender_allies = invite_defender_allies;
	
	if was_respawn == nil then
		was_respawn = false;
	end
	
	if self.target_type ~= "NONE" then
		cm:modify_campaign_ai():cai_disable_movement_for_character("character_cqi:"..general_cqi);

		if self.target_type == "PATROL" then
			self.patrol_position = 1;
		end
	end
	
	--[[ Not supported in 3K.
	if self.immortal_general ~= nil then
		invasion_manager:print("\t\tMaking Character Immortal: "..tostring(self.immortal_general));
		cm:set_character_immortality("character_cqi:"..general_cqi, self.immortal_general);
	end
	]]--
	
	local force = cm:force_from_general_cqi(general_cqi);
	
	if force then
		self.force_cqi = force:command_queue_index();

		if self.force_retreated_flag then
			local modify_force = cm:modify_military_force(force);
			if modify_force and not modify_force:is_null_interface() then
				modify_force:set_retreated();
			end;
		end;
	end
	
	invasion_manager:print("\t\tForce Spawned (General CQI: "..tostring(general_cqi)..", Force CQI: "..tostring(self.force_cqi)..", Invasion: "..tostring(self.key)..")");
	
	self.turn_spawned = cm:query_model():turn_number();
	
	if self.callback ~= nil and type(self.callback) == "function" then
		self.callback(self);
	end
	
	if self.effect ~= nil and self.effect_turns ~= nil then
		self:apply_effect();
	end
	
	if self.experience_amount then
		self:add_character_experience();
	end
	
	if self.unit_experience_amount then
		self:add_unit_experience();
	end
	
	if self.target_faction ~= nil then
		local this_faction = cm:query_faction(self.faction);
		local enemy_faction = cm:query_faction(self.target_faction);
		
		if this_faction and enemy_faction then
			if declare_war and not cm:is_at_war_with(this_faction:name(), enemy_faction:name()) then
				cm:force_declare_war(self.faction, self.target_faction, self.event_feed_suppressed);
				invasion_manager:print("\t\t\tDeclared war on "..tostring(self.target_faction));
			end
		end
	end
	
	if was_respawn == true then
		self.respawn_turn = 0;
		
		if self.respawn_count and self.respawn_count > -1 then
			self.respawn_count = self.respawn_count - 1;
			
			if self.respawn_count == 0 then
				self.respawn = false;
				self.respawn_delay = nil;
				self.respawn_turn = nil;
			end
		end
		core:trigger_event("ScriptEventInvasionManagerRespawn", cm:query_character(general_cqi));
	end

end

----------------------------------------------------
---- Respawn the invasion at its start location ----
----------------------------------------------------
function invasion:attempt_respawn()
	invasion_manager:print("Invasion: Attempting Respawn for '"..self.key.."'...");
	invasion_manager:print("\tRespawns Remaining: "..tostring(self.respawn_count));
	
	if self.respawn_turn >= self.respawn_delay then
		local temp_region = cm:query_model():world():region_manager():region_list():item_at(0):name();
		
		if cm:query_model():has_character_command_queue_index(self.general_cqi) == true then
			-- If we can find the existing General to use for the respawn then do that
			cm:create_force_with_existing_general(self.general_cqi, self.faction, self.unit_list, temp_region, self.spawn.x, self.spawn.y,
			function(cqi) self:force_created(cqi, self.declare_war, self.invite_attacker_allies, self.invite_defender_allies, true) end);
		elseif self.new_general ~= nil then
			-- If we couldn't find the existing General and the invasion was initially spawned with a new one, we can remake them
			cm:create_force_with_general(self.faction, self.unit_list, temp_region, self.spawn.x, self.spawn.y, 
			self.new_general.agent_type, self.new_general.agent_subtype, self.new_general.agent_template, self.key, self.new_general.make_faction_leader,
				function(cqi) self:force_created(cqi, self.declare_war, self.invite_attacker_allies, self.invite_defender_allies, true) end);
		--[[ rogue armies not supported in 3K
		elseif self.rogue_army == true then
			cm:spawn_rogue_army(self.faction, self.spawn.x, self.spawn.y);
			local forces = cm:query_faction(self.faction):military_force_list();
			local force_count = forces:num_items();
			
			if force_count > 0 then
				local last_force = forces:item_at(force_count - 1);
				
				if last_force:has_general() == true then
					local cqi = last_force:general_character():command_queue_index();
					self:force_created(cqi, self.declare_war, self.invite_attacker_allies, self.invite_defender_allies, true);
				end
			end
		]]--
		else
			-- otherwise let the model create a new character
			cm:create_force(self.faction, self.unit_list, temp_region, self.spawn.x, self.spawn.y, true,
			function(cqi) self:force_created(cqi, self.declare_war, self.invite_attacker_allies, self.invite_defender_allies, true) end);
		end
	else
		invasion_manager:print("\tTurns: "..tostring(self.respawn_turn).." / Delay: "..tostring(self.respawn_delay));
		self.respawn_turn = self.respawn_turn + 1;
		invasion_manager:print("\tWaiting another turn...");
	end
end

---------------------------------------------------------------------------------
---- Advances the invasion, moving or attacking their target if there is one ----
---------------------------------------------------------------------------------
function invasion:advance()
	invasion_manager:print("Invasion: Advancing Invasion for '"..self.key.."'...");
	local force = self:get_force();
	local should_remove = false;
	
	if force:is_null_interface() == false then
		local general = self:get_general();
		
		if general:is_null_interface() == false then
			local general_cqi = general:command_queue_index();
			local general_lookup = "character_cqi:"..general_cqi;
			local modify_character = cm:modify_character(general);

			invasion_manager:print("\tGeneral Lookup: "..general_lookup);
			invasion_manager:print("\tTarget: "..tostring(self.target_type).." ["..tostring(self.target).."]");
			
			--[[ Maintaining armies not supported in 3K
			if self.maintain_army == true then
				invasion_manager:print("\tMaintaining army...");
				if force:unit_list():num_items() < #self.unit_list_table then
					invasion_manager:print("\t\tArmy is missing units: "..force:unit_list():num_items().."/"..#self.unit_list_table);
					if cm:modify_model():random_percent(self.maintain_army_chance) then
						invasion_manager:print("\t\tArmy succeeded its maintain chance of "..self.maintain_army_chance.."%");
						-- Go through the initial force and the current force to compare the units in both
						local multiple_units = {};
						multiple_units["initial"] = {};
						multiple_units["current"] = {};
						
						for i = 1, #self.unit_list_table do
							local initial_unit = self.unit_list_table[i];
							multiple_units["initial"][initial_unit] = multiple_units["initial"][initial_unit] or 0;
							multiple_units["initial"][initial_unit] = multiple_units["initial"][initial_unit] + 1;
						end
						for i = 0, force:unit_list():num_items() - 1 do
							local current_unit = force:unit_list():item_at(i):unit_key();
							multiple_units["current"][current_unit] = multiple_units["current"][current_unit] or 0;
							multiple_units["current"][current_unit] = multiple_units["current"][current_unit] + 1;
						end
						
						for initial_unit, initial_number in pairs(multiple_units["initial"]) do
							for current_unit, current_number in pairs(multiple_units["current"]) do
								if initial_unit == current_unit then
									if current_number < initial_number then
										-- There are not enough of this unit in the army
										cm:grant_unit_to_character(general_lookup, initial_unit);
										invasion_manager:print("\t\tAdding unit to army: "..initial_unit);
									end
								end
							end
						end
					else
						invasion_manager:print("\t\tArmy failed its maintain chance of "..self.maintain_army_chance.."%");
					end
				end
			end
			]]--
			
			if self.target_type ~= "NONE" then
				invasion_manager:print("\tDisabling movement for invasion general");
				cm:modify_campaign_ai():cai_disable_movement_for_character(general_lookup);
				
				if self.target_faction ~= nil then
					invasion_manager:print("\tOn advance, "..self.faction.." declares war on "..self.target_faction);
					cm:force_declare_war(self.faction, self.target_faction, true, true);
				end
				
				if self.aggro_enabled == true then
					if self.aggro_target_cqi ~= nil then
						-- We have an aggro target already
						local still_valid = true;
						local target_char = cm:query_character(self.aggro_target_cqi);
						
						-- Check if the target is still valid
						still_valid = target_char:is_null_interface() == false;
						still_valid = still_valid and target_char:has_military_force() == true;
						still_valid = still_valid and target_char:in_settlement() == false;
						still_valid = still_valid and target_char:is_at_sea() == general:is_at_sea();
						-- Check if the invasion has been chasing this aggro target for too long
						still_valid = still_valid and self.aggro_turn_abort_value < self.aggro_turn_abort;
						
						if still_valid then
							invasion_manager:print("\tAggro target already in progress ("..tostring(self.aggro_target_cqi).." - "..target_char:faction():name()..")");
						else
							invasion_manager:print("\tTarget is no longer valid!");
							self.aggro_target_cqi = nil;
							self.aggro_cooldown_value = self.aggro_cooldown;
						end
					end
					
					if self.aggro_target_cqi == nil then
						invasion_manager:print("\tAggro is enabled - Targets:");
						for tar = 1, #self.aggro_targets do
							if self.aggro_targets[1] == "war" then
								invasion_manager:print("\t\tAny factions at war");
							else
								invasion_manager:print("\t\t'"..tostring(self.aggro_targets[tar]).."'");
							end;
						end
						
						-- We don't have an aggro target
						if self.aggro_cooldown_value > 0 then
							-- Invasion is in aggro cooldown
							self.aggro_cooldown_value = self.aggro_cooldown_value - 1;
							invasion_manager:print("\t\tAggro cooldown is in effect ("..tostring(self.aggro_cooldown_value)..")");
						else
							invasion_manager:print("\t\tAttempting to find target in aggro radius ("..tostring(self.aggro_radius)..")");
							local aggro_target_cqi, aggro_target_faction_name = self:find_aggro_target();
							
							if aggro_target_cqi ~= nil then
								invasion_manager:print("\t\t\tFound target: "..tostring(aggro_target_cqi).." in faction " ..tostring(aggro_target_faction_name));
								self.aggro_target_cqi = aggro_target_cqi;
							else
								invasion_manager:print("\t\t\tCouldn't find target");
							end
						end
					end
				end
				
				if self.aggro_enabled == true and self.aggro_target_cqi ~= nil then
					----------------------------------------------------------------------------------
					---- AGGRO TARGET ----------------------------------------------------------------
					----------------------------------------------------------------------------------
					---- Invasion force found a target within its aggro radius and will attack it ----
					----------------------------------------------------------------------------------
					local char_obj = cm:query_character(self.aggro_target_cqi);
					
					if char_obj:is_null_interface() == false then
						local target_character_lookup = "character_cqi:"..self.aggro_target_cqi;
						invasion_manager:print("\tAttacking aggro target: "..tostring(self.aggro_target_cqi));
						cm:modify_campaign_ai():cai_disable_movement_for_character(general_lookup);

						modify_character:replenish_action_points();
						cm:force_declare_war(char_obj:faction():name(), general:faction():name(), false, false);
						cm:attack(general_lookup, target_character_lookup);
						self.aggro_turn_abort_value = self.aggro_turn_abort_value + 1;
						invasion_manager:print("\t\tTurns spent in aggro: "..tostring(self.aggro_turn_abort_value));
					else
						script_error("ERROR: Aggro Target CQI is set but interface was null");
					end
				elseif self.target_type == "LOCATION" then
					--------------------------------------------------------------------------------
					---- LOCATION ------------------------------------------------------------------
					--------------------------------------------------------------------------------
					---- Move to a location and then release the army when it gets close enough ----
					--------------------------------------------------------------------------------
					invasion_manager:print("\tMoving to Location... ["..self.target.x..", "..self.target.y.."]");
					local distance_from_target = distance_squared(general:logical_position_x(), general:logical_position_y(), self.target.x, self.target.y);
					invasion_manager:print("\tDistance from target = "..distance_from_target);
				
					if distance_from_target < 2 then
						invasion_manager:print("\tArrived at Location!");
						self.target_type = "NONE";
					else
						invasion_manager:print("\tMoving...");

						modify_character:walk_to(self.target.x, self.target.y);
					end
				elseif self.target_type == "CHARACTER" then
					-------------------------------------------------------------------------------------
					---- CHARACTER ----------------------------------------------------------------------
					-------------------------------------------------------------------------------------
					---- Attack a character as long as they aren't a null interface and have a force ----
					-------------------------------------------------------------------------------------
					local tagert_character_obj = cm:query_character(self.target);
					
					if tagert_character_obj:is_null_interface() == false and tagert_character_obj:has_military_force() then
						invasion_manager:print("\tAttacking Character...");
						cm:modify_campaign_ai():cai_disable_movement_for_character(general_lookup);
						modify_character:replenish_action_points();

						modify_character:attack(tagert_character_obj);
					else
						invasion_manager:print("\tCouldn't find target... releasing force!");
						self.target_type = "NONE";
					end
				elseif self.target_type == "REGION" then
					-----------------------------------------------------------------------------------
					---- REGION -----------------------------------------------------------------------
					-----------------------------------------------------------------------------------
					---- Attack a region providing it is not a null interface and is not abandoned ----
					-----------------------------------------------------------------------------------
					local target_region_key = self.target;
					local target_region_obj = cm:query_model():world():region_manager():region_by_key(target_region_key);
					
					if target_region_obj:is_null_interface() == false and target_region_obj:is_abandoned() == false then
						local region_owner = target_region_obj:owning_faction():name();
						
						if region_owner == self.target_faction then
							invasion_manager:print("\tAttacking Region...");
							cm:modify_campaign_ai():cai_disable_movement_for_character(general_lookup);
							modify_character:replenish_action_points();
							
							modify_character:attack_settlement(target_region_obj:settlement());
						else
							invasion_manager:print("\tTarget Region owner is no longer initial faction target:");
							invasion_manager:print("\t\tInitial: "..tostring(self.target_faction));
							invasion_manager:print("\t\tCurrent: "..region_owner);
							
							if self.target_owner_abort == false then
								invasion_manager:print("\ttarget_owner_abort is "..tostring(self.target_owner_abort).." - Switching Target Faction!");
								self.target_faction = region_owner;
								cm:force_declare_war(self.faction, self.target_faction, true, true);
							else
								invasion_manager:print("\ttarget_owner_abort is "..tostring(self.target_owner_abort).." - Aborting Invasion!");
								self.target_type = "NONE";
							end
						end
					else
						invasion_manager:print("\tCouldn't find target... releasing force!");
						self.target_type = "NONE";
					end
				elseif self.target_type == "FORCE" then
					-------------------------------------------------------------------------------
					---- FORCE --------------------------------------------------------------------
					-------------------------------------------------------------------------------
					---- Attack a force providing it is not a null interface and has a general ----
					-------------------------------------------------------------------------------
					local target_force_cqi = self.target;
					local target_force_obj = cm:query_model():military_force_for_command_queue_index(target_force_cqi);
					
					if target_force_obj:is_null_interface() == false then
						if target_force_obj:has_general() == true then
							local enemy_general_cqi = target_force_obj:general_character():command_queue_index();
							local enemy_general_lookup = "character_cqi:"..enemy_general_cqi;
							
							invasion_manager:print("\tAttacking Force...");
							cm:modify_campaign_ai():cai_disable_movement_for_character(general_lookup);
							modify_character:replenish_action_points();

							modify_character:attack(target_force_obj:general_character());
						end
					else
						invasion_manager:print("\tCouldn't find target... releasing force!");
						self.target_type = "NONE";
					end
				elseif self.target_type == "PATROL" then
					------------------------------------------------------------------------------------
					---- PATROL ------------------------------------------------------------------------
					------------------------------------------------------------------------------------
					---- Walks to a set of coordinates indefinitely until destroyed or told to stop ----
					------------------------------------------------------------------------------------
					invasion_manager:print("\tFollowing patrol route...");
					invasion_manager:print("\tNext patrol point: #"..self.patrol_position.." ["..self.target[self.patrol_position].x..", "..self.target[self.patrol_position].y.."]");
					local distance_from_target = distance_squared(general:logical_position_x(), general:logical_position_y(), self.target[self.patrol_position].x, self.target[self.patrol_position].y);
					invasion_manager:print("\tDistance from next patrol point " .. general:logical_position_x() .. ", " .. general:logical_position_y() .. " -> " .. self.target[self.patrol_position].x .. ", " .. self.target[self.patrol_position].y .. " = "..distance_from_target);
				
					if distance_from_target < 2 then
						invasion_manager:print("\tArrived at patrol location #"..self.patrol_position);
						
						if self.patrol_position == #self.target then
							invasion_manager:print("\t\tLast patrol position reached...");
							
							if self.stop_at_end == true then
								invasion_manager:print("\t\t\tStopping!");
								self.target_type = "NONE";
								self.patrol_position = 0;
							else
								self.patrol_position = 1;
								invasion_manager:print("\t\t\tRestarting patrol and moving... #"..self.patrol_position.." ["..self.target[self.patrol_position].x..", "..self.target[self.patrol_position].y.."]");

								modify_character:walk_to(self.target[self.patrol_position].x, self.target[self.patrol_position].y);
							end
						elseif self.target[self.patrol_position + 1] ~= nil then
							self.patrol_position = self.patrol_position + 1;
							invasion_manager:print("\t\tMoving to next patrol point... #"..self.patrol_position.." ["..self.target[self.patrol_position].x..", "..self.target[self.patrol_position].y.."]");
							
							modify_character:walk_to(self.target[self.patrol_position].x, self.target[self.patrol_position].y);
						else
							invasion_manager:print("\t\t\tAborting?!");
							self.target_type = "NONE";
							self.patrol_position = 0;
						end
					else
						invasion_manager:print("\tMoving... #"..self.patrol_position.." ["..self.target[self.patrol_position].x..", "..self.target[self.patrol_position].y.."]");
						
						modify_character:walk_to(self.target[self.patrol_position].x, self.target[self.patrol_position].y);
					end
				end
			end
		end
	else
		-- This invasion force is a null interface, likely meaning it is dead
		invasion_manager:print("\tForce is a null interface, assuming it has died...");
		
		if self.respawn == true then
			self:attempt_respawn();
		else
			self.target_type = "NONE";
			should_remove = true;
		end
	end
	
	if self.target_type == "NONE" then
		local general = self:get_general();
		
		if general:is_null_interface() == false then
			local general_cqi = general:command_queue_index();
			local general_lookup = "character_cqi:"..general_cqi;
			local modify_character = cm:modify_character(general);
			
			if self.stop_at_end == true then
				invasion_manager:print("\tInvasion has been told to stop after completion");
				invasion_manager:print("\tDisabling movement for invasion general");
				cm:modify_campaign_ai():cai_disable_movement_for_character(general_lookup);
			else
				invasion_manager:print("\tEnabling movement for invasion general ["..general_lookup.."]");
				cm:modify_campaign_ai():cai_enable_movement_for_character(general_lookup);
				modify_character:enable_movement();

				should_remove = true;
			end
		end
		
		if should_remove == true then
			invasion_manager:remove_invasion(self.key);
		end
	end
end

function invasion:find_aggro_target() -- TODO: might want to return the weakest force here, as currently will return the first one it finds
	local general = self:get_general();
	
	if general:is_null_interface() == false then
		local pos_x = general:logical_position_x();
		local pos_y = general:logical_position_y();
		local at_sea = general:is_at_sea();
		
		if self.aggro_targets[1] == "war" then
			local faction_list = cm:factions_at_war_with(general:faction():name());
			self.aggro_targets = {};
			
			for i = 0, faction_list:num_items() - 1 do
				table.insert(self.aggro_targets, faction_list:item_at(i):name());
			end
		end
		
		for i = 1, #self.aggro_targets do
			local target_faction = cm:query_faction(self.aggro_targets[i]);
			
			if target_faction then
				for j = 0, target_faction:military_force_list():num_items() - 1 do
					local force = target_faction:military_force_list():item_at(j);
					
					if force:is_armed_citizenry() == false and force:has_general() == true then
						local enemy_general = force:general_character();
						
						if enemy_general:is_at_sea() == at_sea then
							if self.aggro_radius < 1 then
								if self.aggro_radius == 0 or cm:query_model():character_can_reach_character(general, enemy_general) then
									return enemy_general:command_queue_index(), self.aggro_targets[i];
								end
							else
								local distance = distance_squared(pos_x, pos_y, enemy_general:logical_position_x(), enemy_general:logical_position_y());
								
								if distance <= self.aggro_radius then
									return enemy_general:command_queue_index(), self.aggro_targets[i];
								end
							end
						end
					end
				end
			end
		end
	end
end

--------------------------------------------------------
---- Releases the invasion force back to AI control ----
--------------------------------------------------------
function invasion:release()
	invasion_manager:print("Invasion: Releasing Invasion with key '"..self.key.."'...");
	local general = self:get_general();
	
	if general:is_null_interface() == false then
		local general_cqi = general:command_queue_index();
		local general_lookup = "character_cqi:"..general_cqi;
		
		invasion_manager:print("\tEnabling movement for invasion general ["..general_lookup.."]");
		cm:modify_campaign_ai():cai_enable_movement_for_character(general_lookup);
		invasion_manager:remove_invasion(self.key);
	end
end

-------------------------------------------------------------------------------
---- Kills the invasions General and the whole force (or just the General) ----
-------------------------------------------------------------------------------
function invasion:kill(general_only)
	general_only = general_only or false;
	local commander = self:get_commander();
	
	if commander:is_null_interface() == false then
		invasion_manager:print("Invasion: Killing Invasion with key '"..self.key.."'...");

		local modify_commander = cm:modify_character(commander);
		local killed = modify_commander:kill_character(not general_only);

		invasion_manager:print("\tKilled: "..tostring(killed));
	end
	self:remove_target();
	invasion_manager:remove_invasion(self.key);
end

-----------------------------------------------------------
---- Returns the character leading this invasion force ----
-----------------------------------------------------------
function invasion:get_general()
	local force = self:get_force();
	
	if force:is_null_interface() == false then
		if force:has_general() == true then
			return force:general_character();
		end
	end
	return cm:null_interface();
end

------------------------------------------------------------------------
---- Returns the character that is the current leader of this force ----
------------------------------------------------------------------------
function invasion:get_commander()
	local general = self:get_general();
	
	if general:is_null_interface() == false then
		return general;
	else
		local force = self:get_force();
		
		if force:is_null_interface() == false then
			local characters = force:character_list();
			
			for i = 0, characters:num_items() - 1 do
				local current_char = characters:item_at(i);
				
				if current_char:character_type("colonel") then
					return current_char;
				end
			end
		end
	end
	return cm:null_interface();
end

------------------------------------------------------
---- Returns the force interface of this invasion ----
------------------------------------------------------
function invasion:get_force()
	-- Early exit if we don't have the correct data.
	if not self.force_cqi then
		script_error("ERROR: Attempted to call get_force but, force cqi is nil. Returning nil");
		return cm:null_interface();
	end;

	if not is_number(self.force_cqi) then
		script_error("ERROR: Attempted to call get_force but, force cqi isn't a number. Returning nil");
		return cm:null_interface();
	end;

	if cm:query_model():has_military_force_command_queue_index(self.force_cqi) then
		return cm:query_model():military_force_for_command_queue_index(self.force_cqi);
	end
	return cm:null_interface();
end

--------------------------------------------
---- Checks if an invasion has a target ----
--------------------------------------------
function invasion:has_target()
	return (self.target ~= nil);
end

-------------------------------------------
---- Checks if an invasion has started ----
-------------------------------------------
function invasion:has_started()
	return self.started or false;
end

------------------------------------------------
---- What turn this invasion was spawned on ----
------------------------------------------------
function invasion:turn_spawned()
	return self.turn_spawned or 0;
end

--------------------------
---- Saving / Loading ----
--------------------------
function save_invasion_manager(context)
	cm:save_named_value("Invasion_Manager", invasion_manager, context);
end

function load_invasion_manager(context)
	local loaded_invasion_manager = cm:load_named_value("Invasion_Manager", invasion_manager, context);
	invasion_manager:print("Loaded invasion manager");
	
	for key, value in pairs(loaded_invasion_manager.invasions) do
		invasion_manager:print("\t\tKey: "..tostring(key)..", Value: "..tostring(value));
		local loaded_invasion = invasion:new(value);
		invasion_manager.invasions[key] = loaded_invasion;
		
		if loaded_invasion:has_started() then
			-- Re-enable the invasion listeners
			invasion_manager:print("\tAdding Listener 'INVASION_"..key.."'");
			core:add_listener(
				"INVASION_"..key,
				"FactionBeginTurnPhaseNormal",
				function(context)
					return context:faction():name() == value.faction;
				end,
				function(context) value:advance() end,
				true
			);
		end
	end
	core:add_listener(
		"INVASION_respawn_check",
		"FactionTurnEnd",
		function(context)
			return context:faction():name() == "rebels";
		end,
		function(context)
			for key, value in pairs(invasion_manager.invasions) do
				if value:has_started() == true and value.respawn == true then
					local force = value:get_force();
					
					if force:is_null_interface() == true then
						value:advance();
					end
				end
			end
		end,
		true
	);
end