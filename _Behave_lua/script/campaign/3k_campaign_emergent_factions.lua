---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			EMERGENT FACTIONS MANAGER
----- Description: 	Allows factions to 'spawn' based on a variety of criteria.
----- Style:		SelfRegistering, StoresData, RevivesFactions, DLC04
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
out("3k_campaign_emergent_factions.lua: Loading");

emergent_faction_manager = {
	system_id = "[1100] Emergent Factions Manager - ";
	emergent_factions = {};
};

-- initialiser
cm:add_first_tick_callback(function() emergent_faction_manager:initialise() end); --Self register function

--- @function emergent_faction_manager:initialise
--- @desc Initialises the emergent faction manager and adds listeners
--- @return nil
function emergent_faction_manager:initialise()
	self:print("3k_campaign_emergent_factions.lua: Initialise");

	-- Example: trigger_cli_debug_event emergent_factions.spawn(key)
	core:add_cli_listener("emergent_factions.spawn",
		function(key)
			for i, ef in ipairs(self.emergent_factions) do
				if ef.key == key then
					self:print("Spawning force [" .. ef.faction_key .. "].")
					ef:spawn();
					return;
				end;
			end;

			self:print("Spawn [" .. key .. "] failed.")
		end
	);

	core:add_listener(
		"emergent_faction_listener",
		"WorldStartOfRoundEvent",
		true,
		function(context)
			-- Go through all the emergent factions and check if they can spawn.
			for i, ef in ipairs(self.emergent_factions) do

				if is_nil(ef.spawn_condition) or ef.spawn_condition() then
					local success, reason = ef:can_spawn();
					if success then
						self:print("Spawning force [" .. ef.faction_key .. "].")
						ef:spawn();
					else
						self:print("Spawn [" .. ef.faction_key .. "] failed, failure reason = [" .. reason .. "].")
					end;
				end;
			end;
		end,
		true
	);

end;


--- @function emergent_faction_manager:print
--- @desc Function to print to the console. Wraps up functionality to there is a singular point.
--- @p string The string to print.
--- @return nil
function emergent_faction_manager:print(string)
	out.design(self.system_id .. string);
end;


--- @function emergent_faction_manager:add_emergent_faction
--- @desc Function to print to the console. Wraps up functionality to there is a singular point.
--- @p emergent_faction The emergent faction to add.
--- @return nil
function emergent_faction_manager:add_emergent_faction(emergent_faction)
	if tostring(emergent_faction) ~= "TYPE_EMERGENT_FACTION" then
		script_error("ERROR: add_emergent_faction() passed in object is not an emergent_faction");
		return false;
	end;

	self:print("Adding emergent faction spawn [" .. emergent_faction.key .. "]");
	table.insert( self.emergent_factions, emergent_faction );
end;



---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			Emergent Faction
----- Description: 	DLC04 - Mandate system
-----				Object designed to be used when spawning factions as a weapper.
-----				
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
emergent_faction = {};


--- @function emergent_faction:new
--- @desc 
--- @p string key: Handle used when getting, registering or removing an emergent faction.
--- @p string faction_key: The db key of the faction which should spawn.
--- @p string leader_template_key: The db key of the leader_template_key who should lead.
--- @p string leader_subtype: The subtype of the leader.
--- @p string spawn_region:
--- @p bool is_peaceful:
--- @return the created emergent_faction
function emergent_faction:new(key, faction_key, leader_template_key, leader_subtype, spawn_region, is_peaceful)
	-- Declare our class.
	o = {};
	ModLog("..Called emergent_faction:new()")
	setmetatable(o, self);
	self.__index = self;
	self.__tostring = function() return "TYPE_EMERGENT_FACTION" end;

	-- Construct the class vars.
	o.key = key;
	o.faction_key = faction_key;
	o.leader_template_key = leader_template_key;
	o.leader_subtype = leader_subtype;
	o.spawn_region = spawn_region;
	o.is_peaceful = is_peaceful;

	o.min_year = nil;
	o.max_year = nil;
	o.min_week = nil;
	o.max_week = nil;
	o.spawn_condition = nil;
	o.emergence_dilemma = nil;
	o.emergence_owner_incident = nil;

	o.on_spawned_callback = nil;

	o.has_spawned = false;
	-- return the new object
	return o;
end;


--- @function emergent_faction:add_spawn_dates
--- @desc 
--- @p number min_year: Year to spawn 
--- @p number max_year: Year to spawn
--- @p number min_week: (0-48) week of year to spawn. default = 0
--- @p number max_week: (0-48) week of year to spawn. default = 48
--- @return nil
function emergent_faction:add_spawn_dates(min_year, max_year, min_week, max_week)
	min_week = min_week or 0;
	max_week = max_week or 47;

	if not is_number(min_year) then
		script_error("ERROR: emergent_faction:add_spawn_dates() Min year [" .. tostring(min_year) .. "] is not a number.");
		return;
	end;

	if not is_number(max_year) then
		script_error("ERROR: emergent_faction:add_spawn_dates() Max year [" .. tostring(max_year) .. "] is not a number.");
		return;
	end;

	self.min_year = min_year;
	self.max_year = max_year;
	self.min_week = min_week;
	self.max_week = max_week;
end;


--- @function emergent_faction:add_spawn_condition
--- @desc 
--- @p function callback: bool return callback whether this can fire.
--- @return nil
function emergent_faction:add_spawn_condition(callback)
	if not is_function(callback) then
		script_error(" ERROR: emergent_faction:add_spawn_condition() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	self.spawn_condition = callback;
end;


--- @function emergent_faction:add_on_spawned_callback
--- @desc 
--- @p function callback: Callback to fire when the force spawns.
--- @return nil
function emergent_faction:add_on_spawned_callback(callback)
	if not is_function(callback) then
		script_error(" ERROR: emergent_faction:add_on_spawned_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		ModLog("Tfailed on callback")
		return false;
	end;

	self.on_spawned_callback = callback;
end;


--- @function emergent_faction:add_emergence_dilemma
--- @desc 
--- @p string dilemma_key: Dilemma to fire.
--- @return nil
function emergent_faction:add_emergence_dilemma(dilemma_key)
	if not is_string(dilemma_key) then
		script_error(" ERROR: emergent_faction:add_emergence_dilemma() called but supplied event [" .. tostring(dilemma_key) .. "] is not a string");
		return false;
	end;

	self.emergence_dilemma = dilemma_key;
end;


--- @function emergent_faction:add_leave_incident
--- @desc 
--- @p function callback: Callback to fire when the force spawns.
--- @return nil
function emergent_faction:add_leave_incident(incident_key)
	if not is_string(incident_key) then
		script_error(" ERROR: emergent_faction:add_leave_incident() called but supplied event [" .. tostring(incident_key) .. "] is not a string");
		return false;
	end;

	self.emergence_owner_incident = incident_key;
end;


--- @function emergent_faction:can_spawn
--- @desc 
--- @return bool can_spawn, string reason
function emergent_faction:can_spawn()
	
ModLog("**Emergent Faction::check can spawn")
	-- already spawned
	if self.has_spawned then
			ModLog("alreadySpawned")
        return false, "already spawned";
	end;
	ModLog("s2")
	ModLog("What is selfkey="..tostring(self.faction_key))
	local query_faction = cm:query_faction(self.faction_key);
	-- malformed faction
	if not query_faction or query_faction:is_null_interface() then
            ModLog("malformed faction")
        return false, "cannot find faction";
	end;
ModLog("s3")
	-- faction exists.
	if not query_faction:is_dead() then
		ModLog(tostring(query_faction:name()) .. " is alive ABORTING")
		fixFactionAlive(query_faction:name())
		return false, "Faction is alive [" .. self.faction_key .. "].";
	end;
ModLog("s4")
	-- character checks.
	local query_character = cm:query_model():character_for_template(self.leader_template_key);
	if query_character and not query_character:is_null_interface() then
ModLog("s5")
		-- faction leader dead. Must test before other things.
		if query_character:is_dead() then
			return false, "Character is dead [" .. tostring(self.leader_template_key) .. "].";
		end;
ModLog("s6")
		-- Check if character is in the pool. 
		if query_character:is_character_is_faction_recruitment_pool() then
			return false, "Character is in recruitment pool, making them a faction leader will crash the game! [" .. tostring(self.leader_template_key) .. "].";
		end;
ModLog("s7")		
		-- is faction leader
		if not query_character:character_post():is_null_interface() then
			if query_character:is_faction_leader() or query_character:character_post():ministerial_position_record_key() == "faction_heir" then
				return false, "Character is faction leader or heir [" .. tostring(self.leader_template_key) .. "].";
			end
		end;
ModLog("s8")		
		-- is spy
		if query_character:is_spy() then
			return false, "Character is spy [" .. tostring(self.leader_template_key) .. "].";
		end;

	end;
ModLog("s9")
	-- date in window.
	if self.min_year and not cm:query_model():date_and_week_in_range(self.min_week, self.min_year, self.max_week, self.max_year ) then
		return false, "Date outside of range.";
	end;

	ModLog("Passed Spawn check")
	return true, "success";
end;


--- @function emergent_faction:spawn
--- @desc 
--- @return nil
function emergent_faction:spawn()
	ModLog("Trying to spawn faction!")
	local query_character = cm:query_model():character_for_template(self.leader_template_key);
	local query_region = cm:query_region(self.spawn_region);
	local region_owner_key = query_region:owning_faction():name();
	ModLog("..passed set up")
	ModLog("..self.spawn_region"..tostring(self.spawn_region))
	-- SPAWNING FORCES   --self.faction_key
	local new_invasion = campaign_invasions:create_invasion(self.faction_key, self.spawn_region, 3, true);
	ModLog("Created new force")
	if not new_invasion then
		script_error("ERROR: Emergent Factions. Failed to spawn emergent force. Faction:[" .. tostring(self.faction_key) .. "], Region:[" .. tostring(self.spawn_region) .. "]");
		ModLog("error in invasion!")
		return false;
	end;

	-- If the character doesn't exist then spawn them or move them to a new faction, triggering an incident.
	if not query_character or query_character:is_null_interface() then
		new_invasion:create_general(true, self.leader_subtype, self.leader_template_key); -- override the given general with our own one.;
		ModLog("spawn00!")
	else
		local modify_character = cm:modify_character(query_character);
		ModLog("spawn1!")
		--Fire an event for the currently owning faction letting them know what's going on.
		if query_character:faction():is_human() and self.emergence_owner_incident then
			ModLog("spawn2!")
			cm:trigger_incident(query_character:faction():name(), self.emergence_owner_incident, true);
		end;
		ModLog("spawn3!")
		-- Re-emerge the faction, moving their 'leader' to the new faction and spawning a military force with their faction leader owning.
		if query_character:is_character_is_faction_recruitment_pool() then 
			ModLog("This guys in the faction recruit pool..??")
		else
			--modify_character:move_to_faction(self.faction_key);
			--modify_character:assign_to_post("faction_leader");
			ModLog("char is in : "..query_character:faction():name())
			local post= query_character:character_post();
			local assign= query_character:active_assignment();
			if not post:is_null_interface() then 
				ModLog(" post="..tostring(post:ministerial_position_record_key()))
			end 
			if not assign:is_null_interface() then 
				ModLog(" post="..tostring(assign:assignment_record_key()))
			end 
			ModLog("is spy="..tostring(query_character:is_spy()))
			ModLog("is dead="..tostring(query_character:is_dead()))
			ModLog("is factionleader="..tostring(query_character:is_faction_leader()))
			ModLog("is Region="..tostring(query_character:region():name()))
			ModLog(" mchar is null="..tostring(modify_character:is_null_interface()))
			modify_character:set_is_deployable(true) 
			--modify_character:move_to_faction_and_make_recruited(self.faction_key)
			ModLog("moved manually");
			--modify_character:assign_to_post("faction_leader");
			--new_invasion:assign_general(query_character:command_queue_index());
		end
	end;
	ModLog("spawn4!")
	new_invasion:start_invasion();
	ModLog("spawn5!")

	-- DILEMMA AND REGION TRANSFER
	-- Fire a dilemma, or give the region, or declare war depending on the settings.
	-- PLAYER OWNS REGION
	if query_region:owning_faction():is_human() and self.emergence_dilemma then
		-- trigger dilemma
			ModLog("spawn6 trgger dilemma!")
		if cm:trigger_dilemma(region_owner_key, self.emergence_dilemma, true) then
			core:add_listener(
				region_owner_key .. self.emergence_dilemma,
				"DilemmaChoiceMadeEvent",
				function(context)
					return context:dilemma() == self.emergence_dilemma and context:faction():name() == region_owner_key;
				end,
				function(context)
					if context:choice() == 0 then -- accepted
						cm:modify_region(query_region):settlement_gifted_as_if_by_payload(cm:modify_faction(self.faction_key));
					else -- refused
						if not self.is_peaceful then -- declare war if not peaceful.
							cm:force_declare_war(self.faction_key, region_owner_key, false);
						end;
					end;
				end,
				false
			)
		end;
		
	-- AI OWNS REGION
	else
		ModLog("spawn7- ai owns!")
		cm:modify_region(query_region):settlement_gifted_as_if_by_payload(cm:modify_faction(self.faction_key));
		-- Not peaceful, declare war.
		if not self.is_peaceful then
			cm:force_declare_war(self.faction_key, region_owner_key, false);
			ModLog("spawn8- ai owns!")
		end;
	end;

	ModLog("spawn9!")
	-- Set up a listener to fire the callback after we've finished.
	if self.on_spawned_callback then
		self.on_spawned_callback();
	end
	ModLog("spawn Final!")
	self.has_spawned = true;
end;