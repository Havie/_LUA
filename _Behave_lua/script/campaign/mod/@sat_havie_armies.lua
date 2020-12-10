----------------------------------------------------------------------------------------
-------------------  TITLE: Havie Armies   ---------------------------------------------
------ Author: Havie  ------------------------------------------
------ Description: Written in lua to attempt ------------------------------------------
------ to make army size dynamically affect supply consumption  ------------------------
-------------------   and movement range  ----------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

local printStatements=false;


local function CusLog(text)
    if type(text) == "string" and printStatements then
	local file = io.open("@sat_havie_armies.txt", "a")
	--local temp = os.date("*t", 906000490)
	local temp = os.date("*t") -- now ?
	local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
	local header=" (armies): "
	local line= time..header..text
	file:write(line.."\n")
	file:close()
	ModLog(header..text)
    end
end

local function IniDebugger()
	printStatements=true;
	local file = io.open("@sat_havie_armies.txt", "w+")
	CusLog("---Begin File----")
end

--[[
local ArmyBundles = {
"3k_dynamic_army_effect_bundle_0",  -- +12% movement range, +6 supplies  
"3k_dynamic_army_effect_bundle_1",  -- +10% movement range, +5 supplies  
"3k_dynamic_army_effect_bundle_2",  -- +8% movement range, +4 supplies  
"3k_dynamic_army_effect_bundle_3",  -- +6% movement range, +3 supplies  
"3k_dynamic_army_effect_bundle_4",  -- +4% movement range, +2 supplies  
"3k_dynamic_army_effect_bundle_5",  -- +2% movement range, +1 supplies  
"3k_dynamic_army_effect_bundle_6",  -- -0% movement range, -0 supplies  
"3k_dynamic_army_effect_bundle_7",  -- -3% movement range, -2 supplies  
"3k_dynamic_army_effect_bundle_8",  -- -5% movement range, -4 supplies  
"3k_dynamic_army_effect_bundle_9",  -- -8% movement range, -7 supplies  
"3k_dynamic_army_effect_bundle_10",  -- -10% movement range, -8 supplies  
}
--]]


local function CalculateSupplies(qChar)
	--CusLog("Running CalculateSupplies")

	if not qChar:is_null_interface() then
		if qChar:has_military_force() then
			--CusLog(" has m force")
			local mforce=qChar:military_force();
			if not mforce:is_armed_citizenry() then 
				local unitList=mforce:unit_list();
				CusLog(qChar:generation_template_key().. "    size of unitList="..tostring(unitList:num_items()))
				--CusLog(tostring(qChar:generation_template_key().." STRENGTH FORCE="..tostring(mforce:strength())))
				--local strength=math.floor((mforce:strength()/10)/2); --assuming this is max 100, making it 0-5
				--CusLog("strength Modifier better be between (0-5)?? ="..tostring(strength));
				local modify_force = cm:modify_military_force(mforce);
				
				local strength=math.floor(unitList:num_items()/4);
				-- This could be written more efficiently with MOD but since i was assuming unit strength was going to be 1-100
				-- I originally wrote this in a manner that would support that. However after finding out unit strengths are like 1205324... i quickly 
				-- changed the logic to work this way.
				--Max Units:   1-21 
			--	CusLog(tostring(unitList:num_items()).." units apply bundle strength= "..tostring(strength))
				if unitList:num_items() < 6 then --(0-1)
					--Strength = 0-1
					--CusLog("Applying: ".."3k_dynamic_army_effect_bundle_"..tostring(strength))
					modify_force:apply_effect_bundle("3k_dynamic_army_effect_bundle_"..tostring(strength), 1);
				elseif unitList:num_items() < 11 then --(2-3)
					--Strength = 1-2
					--CusLog("Applying: ".."3k_dynamic_army_effect_bundle_"..tostring(strength+1))
					modify_force:apply_effect_bundle("3k_dynamic_army_effect_bundle_"..tostring(strength+1), 1);
				elseif unitList:num_items() < 14 then  -- (4-5)
					--Strength = 2-3
					--CusLog("Applying: ".."3k_dynamic_army_effect_bundle_"..tostring(strength+2))
					modify_force:apply_effect_bundle("3k_dynamic_army_effect_bundle_"..tostring(strength+2), 1);
				elseif unitList:num_items() < 17 then -- (6-7)
					--Strength = 3-4
					--CusLog("Applying: ".."3k_dynamic_army_effect_bundle_"..tostring(strength+3))
					modify_force:apply_effect_bundle("3k_dynamic_army_effect_bundle_"..tostring(strength+3), 1);
				elseif unitList:num_items() < 21 then   --(8-9)
					--Strength = 4-5
					--CusLog("Applying: ".."3k_dynamic_army_effect_bundle_"..tostring(strength+4))
					modify_force:apply_effect_bundle("3k_dynamic_army_effect_bundle_"..tostring(strength+4), 1);
				else
					--CusLog("Applying MAX bundle: 3k_dynamic_army_effect_bundle_10")
					modify_force:apply_effect_bundle("3k_dynamic_army_effect_bundle_10", 1);
				end
				--CusLog("finished applying effect bundle")
				return true;
			end
		else
			CusLog("@@!!..Character that stopped moving doesnt have m force??")
		end
end


	--CusLog("Fell through CalculateSupplies")
return false;
end

-----------------------------------------------------------------------

-----------------------------------------------------------------------
------------------Separate Functions from Listeners--------------------
-----------------------------------------------------------------------

-----------------------------------------------------------------------


local function ArmyStartListener()  
	CusLog("### ArmyStartListener loading ###")
	core:remove_listener("ArmyStartH")
	core:add_listener(
	"ArmyStartH",
	"CharacterTurnStart",
	function(context)
		return context:query_character():has_military_force();
	end,
		function(context)
		--CusLog("??? Callback: ArmyStartListener  ###"..tostring(context:query_character():generation_template_key()))
		CalculateSupplies(context:query_character())
	end,
	true
		)
end


--MilitaryForceCreated

-- when the game loads run these functions:
cm:add_first_tick_callback(  --FirstTickAfterWorldCreated
	function(context)
		--IniDebugger()
		--ArmyMovedHavieListener() -- too much
		ArmyStartListener();

		--local qChar=getQChar("3k_main_template_historical_lu_bu_hero_fire");
		--local mforce=qChar:military_force();
		--local modify_force = cm:modify_military_force(mforce);
		--modify_force:apply_effect_bundle("3k_dynamic_army_effect_bundle_"..tostring(3), 5);
		--CusLog("applied bundle to lubu force (TMP)")

		
	end
)