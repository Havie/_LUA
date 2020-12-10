---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			Havie Capture Chance
----- Description: 	Allows Players to Capture the characters of factions they destroy
-----				
-----			Had to use global arrays to do so
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
local startTime1=os.clock();

local printStatements=false;
--Have to use global?
local all_faction_characters = {};
local saved_for_dilemma_characters = {}

local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@sat_capture.txt", "a")
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime1).."] ")
		local line= time..text
		local header=" (capture): "
		file:write(line.."\n")
		file:close()
		ModLog(header..text)
    end
end

local function IniDebugger()
	printStatements=true;
	local file = io.open("@sat_capture.txt", "w+")
	file:close()
	--CusLog("---Begin File----")
end



local function HandleChars(execute) -- wont move if already in player faction 
	local PlayerFaction= cm:query_faction(cm:get_saved_value("Player_faction_capturable"))
	local qfaction = cm:query_faction(cm:get_saved_value("AI_faction_capturable"))

	if PlayerFaction:is_null_interface() then
		return;
	end

	if not qfaction:is_null_interface() then
		for i=1, #saved_for_dilemma_characters do -- start at 1, go to end for tables in lua
			local qchar = cm:query_model():character_for_command_queue_index(saved_for_dilemma_characters[i]) --cqi
			if not qchar:is_null_interface() then
				if(not qchar:is_dead()) then
					if (not qchar:faction():is_human() or qchar:is_character_is_faction_recruitment_pool() ) then   -- move char only if hes not in the player faction
						local mqchar = cm:modify_character(qchar) -- convert to a modifiable character
						if execute then 
							mqchar:kill_character(false) 
						else
							mqchar:set_is_deployable(true) -- keep this here, CA does before 
							mqchar:move_to_faction_and_make_recruited(PlayerFaction:name()) --CA grabs the Modify char again before moving
						end
					end
				end
			end
		end
	end
	

end


------------------------------------------------------------
------------------Listeners from Functions------------------
------------------------------------------------------------



local function PlayerCaptureChoiceMadeListener()
    --CusLog("### PlayerCaptureChoiceMadeListener loading ###")
    core:add_listener(
    "PlayerCaptureChoiceMade",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_capture_choice_dilemma"  
    end,
    function(context)
       -- --CusLog("..! choice was:" .. tostring(context:choice()))
        if context:choice() == 0 then
			HandleChars(false)
		elseif choice ==1 then 
			HandleChars(true) --exectue
		 end
		 saved_for_dilemma_characters = {} --Reset this after were done, other array is always reset when finding a suitable battle
    end,
    false -- dont persist, PromptPlayer will reload when needed 
);
end


local function PromptPlayer()
	PlayerCaptureChoiceMadeListener()
	local PlayerFaction=cm:get_saved_value("Player_faction_capturable")
	local triggered = cm:trigger_dilemma(PlayerFaction, "3k_lua_capture_choice_dilemma", true) 
end

local function SaveCharacters()
	--Doing it this way should hopefully allow the player to capture multiple characters from multiple battles/factions per end turn
	for i=0, #all_faction_characters do 
		 table.insert(saved_for_dilemma_characters, all_faction_characters[i])
	end
	
end

local function PostBattleCaptureListener()
	core:add_listener(
		"PostBattleCapture",
		"FactionDied",
		function(context)
			if context:faction():name()== cm:get_saved_value("AI_faction_capturable") and
			   context:killer_or_confederator_faction_key() == cm:get_saved_value("Player_faction_capturable") then
		    		return true
				end
		return false;
		end,
		function(context)
			SaveCharacters() -- based on when this callback triggers, might have to move up before return
			PromptPlayer() -- doesnt matter when the event fires, as long as it persists till the next turn, more battles could interrupt this?
		end,
		true 
    )
end


local function FinalBattleListener() --Determine if this could be the AI factions last battle
	core:add_listener(
		"capture_chance_battle", -- Unique handle
		"PendingBattle", -- Campaign Event to listen for
		function(context) -- Criteria
			if ( context:query_model():is_player_turn() and  context:query_model():pending_battle()) then--If this event is only on players turn, player cant capture suicide defenders 
				local pb = context:query_model():pending_battle();
				local attacker = nil;
				local defender = nil;
				local player_was_attacker = false;
				local player_was_defender = false;
				local query_faction = nil;
				local player_faction = nil;
	
				if pb:has_attacker() then
					attacker = pb:attacker();
					player_was_attacker = player_attacker_in_battle(pb) -- guess this a global function somewhere
				end

				if pb:has_defender() then
					defender = pb:defender();
					player_was_defender = player_defender_in_battle(pb);
				end
				
				if attacker=="" or defender=="" then 
					return false; 
				end
				
				if(player_was_attacker == true) then
					query_faction=defender:faction();
					player_faction=attacker:faction();
				elseif(player_was_defender ==true) then
					query_faction=attacker:faction();
					player_faction=defender:faction();
				end;
			
			if not player_was_attacker and not player_was_defender then --not sure this is possible if its the players turn 
				cm:set_saved_value("capture_activated",false)
				return false;
			elseif player_was_attacker and  player_was_defender then 
				cm:set_saved_value("capture_activated",false)
				return false;
			end
			
			if not query_faction or query_faction:is_null_interface() then --cant imagine this happening, but best be safe
				cm:set_saved_value("capture_activated",false)
				return false;
			end
			
			local regionCount=0;
			if query_faction:region_list() then -- Look at the AI factions stuff
				for i = 0, query_faction:faction_province_list():num_items() - 1 do -- Go through each Province
					local province_key = query_faction:faction_province_list():item_at(i);
					for i = 0, province_key:region_list():num_items() - 1 do -- Go through each region in that province
						local region_key = province_key:region_list():item_at(i);
						if(not region_key:is_null_interface()) then 
							local region_name = region_key:name()
							regionCount= regionCount+1
						end
					end	
				end
			end
			if( regionCount<2) then --Save the character cqi for after the battle results
				all_faction_characters = {}   --Clear table
				for i = 0, query_faction:character_list():num_items() - 1 do 
					local qchar=query_faction:character_list():item_at(i);
					if not string.find(qchar:generation_template_key(), "generic") then --Cant do armed citizen because thats on military force,this works better anyway,we dont want the rando's
						table.insert(all_faction_characters, qchar:cqi())
					end
				end
				cm:set_saved_value("AI_faction_capturable", query_faction:name())
				cm:set_saved_value("Player_faction_capturable",player_faction:name())
				cm:set_saved_value("capture_activated",true) -- dont think im even using this thanks to new FactionDied Event 
				return true
			end
			--CusLog("returning false");
			return false;
			end;
		end,
		function(context) -- What to do if listener fires.
			--Nothing its done above so I dont have to reparse all the vars from context
		end,
		true --Is persistent
	);
end

-- when the campaign loads run these functions:
cm:add_first_tick_callback(
	function(context)
       -- IniDebugger()
		FinalBattleListener()
		PostBattleCaptureListener()

    end
)


	
