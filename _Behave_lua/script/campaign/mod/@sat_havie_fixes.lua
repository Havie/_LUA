
--> Havie Satisfaction Fixes

local printStatements=false;



local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@sat_havie_fixes.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
		local header=" (sat_early): "
		local line= time..header..text
		file:write(line.."\n")
		file:close()
		ModLog(header..text)
    end
end

local function IniDebugger()
	printStatements=true;
	local file = io.open("@sat_havie_fixes.txt", "w+")
	CusLog("---Begin File----")
end



local function LiuZhangFix()
		CusLog("Running LiuZhangFix")
		
		local qChar= cm:query_model():character_for_template("3k_main_template_historical_liu_zhang_hero_earth")		
	
		if not qChar:is_null_interface()  then
			CusLog("!!..Lizhangs CQI="..tostring(qChar:cqi()))
			if not qChar:is_dead() then 
			  local mgeneral = cm:modify_character(qChar)
               if mgeneral:is_null_interface() then 
                  CusLog("mLiuZhang is null")
               else
					CusLog("LiuZhang not null so add stuff")
					mgeneral:add_experience(100) --WHY NOT :-)
					mgeneral:add_loyalty_effect("extraordinary_success");
					mgeneral:add_loyalty_effect("lua_loyalty"); -- Could use a diff custom effect that last a longer amount of turns
					local qFaction = qChar:faction();
					cm:apply_effect_bundle("3k_main_payload_satisfaction_all_characters", qFaction:name() , 10)   -- satisfaction faction wide

				end
			end
		else
			CusLog("qLiuzhang is null?")
		end 
		cm:modify_faction("3k_main_faction_liu_yan"):increase_treasury(1500)
		cm:apply_effect_bundle("3k_main_payload_satisfaction_all_characters", "3k_main_faction_liu_yan" , 30)   -- satisfaction faction wide

		CusLog("Finished LiuZhangFix")
end

local function ZhangLuFix()
		CusLog("Running ZhangLuFix")
		
		local qFaction =cm:query_faction("3k_main_faction_zhang_lu")
		if not qFaction:is_null_interface() then
			cm:modify_faction(qFaction:name()):increase_treasury(7700) -- hopes its enough
			cm:apply_effect_bundle("3k_main_faction_trait_ma_teng", qFaction:name() , 5)   --whatever?
		end
		CusLog("Finished ZhangLuFix")
end

local function FixLowSats()
		CusLog("Running FixLowSats")
		local world = cm:query_model():world()
		if not world:is_null_interface() then 
			for i=0, world:faction_list():num_items()-1 do
				local qFaction = world:faction_list():item_at(i)
				--CusLog("looking at characters in "..tostring(qFaction:name()))
				if qFaction:name() ~= "3k_main_faction_han_empire" then 
					for j=0, qFaction:character_list():num_items() -1 do
						local qChar= qFaction:character_list():item_at(j)
						if not qChar:is_null_interface() then 
							if qFaction:is_human() then 
							--	CusLog("Char #"..tostring(j).." is "..qChar:generation_template_key().." with loyalty="..tostring(qChar:loyalty()))
							end
							if not qChar:is_dead() and qChar:loyalty()<20 then 
								local mgeneral = cm:modify_character(qChar:cqi())
								if(not mgeneral:is_null_interface()) then 
									mgeneral:add_loyalty_effect("extraordinary_success"); -- could make a custom one
									mgeneral:add_loyalty_effect("lua_loyalty2"); -- could make a custom one
									CusLog("Found and Fixed: "..tostring(qChar:generation_template_key()))
								else
									CusLog("Found a null interface m_char??")
								end
							end
							--CusLog("finished looking at "..tostring(qChar:generation_template_key()))
						end
					end	
				end
			end
		else
			CusLog("@@@@!... the world is null? in FixLowSats")
		end
		
		
		CusLog("Finished FixLowSats")
end


local function SatEarlyIni()
	CusLog("Running Various Early Game fixes")
	FixLowSats()
	ZhangLuFix()
	LiuZhangFix()
	CusLog("Finished Various Early Game fixes")
	cm:set_saved_value("ran_turn1_earlysat",true)
end

-- when the game loads run these functions:
cm:add_first_tick_callback(  --FirstTickAfterWorldCreated
	function(context) 
		IniDebugger()
        if context:query_model():turn_number() ==1 and cm:get_saved_value("ran_turn1_earlysat") ~=true then --set up this scripts initial values
           SatEarlyIni() 
        end
       
    end
)
