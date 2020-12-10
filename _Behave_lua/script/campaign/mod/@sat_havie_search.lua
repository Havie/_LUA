----------------------------------------------------------------------------------------
-------------------  TITLE: Search Assignment   ----------------------------------------
------ Author: Havie 						  ------------------------------------------
------ Description: Written in lua to attempt ------------------------------------------
------ to make my events fire without interfering with other vanilla incidents --------
------ restricted by the 1 incident per turn db limit ----------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
local printStatements=false;


local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@sat_havie_search.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
		local header=" (search): "
		local line= time..header..text
		file:write(line.."\n")
		file:close()
		ModLog(header..text)
    end
end

local function IniDebugger()
	printStatements=true;
	local file = io.open("@sat_havie_search.txt", "w+")
	CusLog("---Begin File----")
end

local function RNGHelperSEARCH(toBeat)
	--CusLog("RNG : "..tostring(debug.traceback()));
	local rolled_value = cm:random_number( 0, 9 );
	CusLog("$$(RNGHelperSEARCH):: Rolled a:"..tostring(rolled_value).. " , need to beat"..tostring(toBeat))
    if rolled_value > toBeat then 
		return true
	end	
	return false;	
end

local function TriggerIncident(qFaction)

	-- Could lazily fire randomly through them since it doesn't seem query model has access to the season?
	-- Or i could write something more reliably on the turn # itself since some events are in windows?
	-- Maybe some of these events are the more common ones, and the really good ones still only generate from db?
	-- Seems like it would defeat the purpose though. Its kind of hard to set Var_chance reliably here, its just super random without weights 
	-- Maybe the db will still honor the CND TURNS TILL NEXT setting at least?
	-- However firing this way ignore CND_LAST_ROUND so i had to get creative. 
	CusLog("Running Trigger Incident")
	-- i wonder if it would be more efficient to do a table where the string just maps to true, or itself..
	-- that way I can call table[string]=nil to remove things?
	--If i do this, theres no easy operator for size of eventNames , no # op on a map...
	-- I could manually keep track of how many things im adding or removing, but at this point seems like its a horse a piece
	local eventNames= {
			"3k_search_makes_acquitance", --1
			"3k_search_gives_anc", --2
			"3k_search_gives_weapon", --3
			"3k_search_gives_money", --4
			"3k_search_gives_armor", --5
			"3k_search_gives_horse", --6 
			"3k_search_gives_exp", --7
			"3k_search_gives_exp2", --8 
			"3k_search_gives_buff", --9 
			"3k_search_gives_supply", --10 
			"3k_search_gives_supply2", --11
			"3k_search_gives_replenish", --12 
			"3k_search_gives_construction", --13
			"3k_search_hires_officer"} --14
			
			local chances=3; -- could also scale this with the turn # 
			if true then 
			--Feel like i could write this with mod in 1 line 
			if cm:query_model():turn_number() >150 then 
				chances=chances+3;
				--remove 
				table.remove(eventNames,1) --3k_search_makes_acquitance
				table.remove(eventNames,7) --3k_search_gives_exp
				table.remove(eventNames,8) --3k_search_gives_exp2
				table.remove(eventNames,4) --3k_search_gives_money
				table.remove(eventNames,11) --3k_search_gives_supply2
				table.remove(eventNames,13) --3k_search_gives_construction
				table.remove(eventNames,12) --3k_search_gives_replenish
				table.remove(eventNames,14) --3k_search_hires_officer
				-- add 
				table.insert(eventNames,"3k_search_gives_anc")
			elseif cm:query_model():turn_number() >100 then 
				CusLog(">100")
				chances=chances+2;
				CusLog("1")
				table.remove(eventNames, 1) --3k_search_makes_acquitance
				CusLog("2")
				table.remove(eventNames,7)--3k_search_gives_exp
				CusLog("3")
				table.remove(eventNames,3)--3k_search_gives_money
				CusLog("4")
				table.remove(eventNames,11) --3k_search_gives_supply2
				-- add 
				CusLog("add")
				table.insert(eventNames,"3k_search_gives_anc")
			elseif cm:query_model():turn_number() >50 then 
				chances=chances+1;
				-- add 
				table.insert(eventNames,"3k_search_gives_anc")
			else 
			-- add 
				table.insert(eventNames,"3k_search_gives_money")
				table.insert(eventNames,"3k_search_gives_anc")
				table.insert(eventNames,"3k_search_gives_construction")
				table.insert(eventNames,"3k_search_gives_supply")
				table.insert(eventNames,"3k_search_gives_supply2")
			end
			end	
			
			CusLog("Start chances ")
			for i=1, chances do 
				CusLog("i= "..tostring(i)) --see how many times we loop
				local rng= math.floor(cm:random_number(1, #eventNames))
				local triggered= cm:trigger_incident(qFaction:name(), eventNames[rng],true)
				if triggered then 
					CusLog(tostring(rng).." SEARCHED TRIGGERED: "..eventNames[rng])
					return true;
				else
					CusLog(tostring(rng).." Failed to trigger:".. eventNames[rng].."  for :"..tostring(qFaction:name()))
				end 
			end


	return false;

end




local function CheckAssignments(qFaction)
	CusLog("Running CheckAssignments")
	for i=0, qFaction:character_list():num_items() -1 do
		local qChar= qFaction:character_list():item_at(i)
		if not qChar:is_null_interface() 
			and not qChar:active_assignment():is_null_interface()
				and not qChar:active_assignment():is_idle_assignment() then 
				--Should work well enough rooting out the generics id imagine 
				--CusLog(qChar:generation_template_key().." On Assignment="..tostring(qChar:active_assignment():assignment_record_key()))
				if qChar:active_assignment():assignment_record_key() == "3k_main_assignment_custom_search" then 
					local success= TriggerIncident(qFaction)
					if success then 
						--Set some kind of delay bool?
						local rng= math.floor(cm:random_number(2,5));
						cm:set_saved_value("search_turns",cm:query_model():turn_number() + rng)
						return ;
					end 
				end
		end
	end	


	CusLog("Fell through CheckAssignments")			
end


-- Could also use:

--	core:add_listener(
--		"CharacterAssignment_experience",
--		"CharacterTurnStart",

local function SearchListener()  
	CusLog("### SearchListener loading ###")
	core:remove_listener("Search")
	core:add_listener(
		"Search",
		"FactionTurnStart",  --START
		function(context)
			if context:faction():is_human() then -- I couldmake it so this works for AI too 
                if cm:get_saved_value("search_turns") < context:query_model():turn_number() then 
					CusLog("search turns = "..tostring( cm:get_saved_value("search_turns")))
					if RNGHelperSEARCH(2) then --help with the RNG?
						return true;
					end 
				end
			end
            return false;
		end,
		function(context)
			CusLog("??? Callback: SearchListener  ###")
			CheckAssignments(context:faction())
		end,
		true 
    )
end

-- when the game loads run these functions:
cm:add_first_tick_callback(  --FirstTickAfterWorldCreated
	function(context) 
		IniDebugger()
		CusLog("SEARCH ON??")
		if cm:get_saved_value("search_turns")==nil then 
			cm:set_saved_value("search_turns", 1)
		end 
		SearchListener() 
		CusLog("Search_turns="..tostring(cm:get_saved_value("search_turns")))
		--TMP 
		--cm:set_saved_value("search_turns", 1)
    end
)
