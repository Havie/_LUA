--> Faction Debuffs Based on who the player is

local printStatements=false;



local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_debuffs.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
		local header=" (debuffs): "
		local line= time..header..text
		file:write(line.."\n")
		file:close()
		ModLog(header..text)
    end
end

local function IniDebugger()
	printStatements=true;
	local file = io.open("@havie_debuffs.txt", "w+")
	file:close()
	CusLog("---Begin File----")
end



local function ApplyDebuffs()

	if cm:get_saved_value("yuan_shu_is_human") then 
		--debuff cao cao for short amount of turns (he snowballs hard into louyang etc)
		if not cm:get_saved_value("cao_cao_is_human") then 
			CusLog("Debuff caocao lite")
			cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua_lite", "3k_main_faction_cao_cao" , 5)
		end
	end

	if cm:get_saved_value("dong_zhuo_is_human") then 
		--nerf zheng jian and liu chong 
		if not cm:get_saved_value("zheng_jiang_is_human") then 
			CusLog("Debuff zheng_jiang_ heavy")
			cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua", "3k_main_faction_zheng_jiang" , 45)
		end
		if cm:get_saved_value("liu_chong_is_human") then 
			CusLog("Debuff liu_chong_ heavy")
			cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua", "3k_dlc04_faction_prince_liu_chong" , 45)
		end
	end

	if cm:get_saved_value("yuan_shao_is_human") then 
		--nerf who? sjun jian for a bit?
	end

	if cm:get_saved_value("cao_cao_is_human") then 
		--nerf yuan shu??
		
	end

	if cm:get_saved_value("wu_is_human") then 
		--BUFF HuangZu and CaiMao?
		
	end

end




local function ApplyDebuffsListener()
	CusLog("### ApplyDebuffsListener listener loading ###")
	core:remove_listener("ApplyDebuffsListener")
	core:add_listener(
		"ApplyDebuffs",
		"FactionTurnEnd",
		function(context)
			if context:faction():is_human() == true then
				if context:query_model():turn_number()==2 and cm:get_saved_value("Debuffed_complete") ~= true then 
					return true;
				else
				core:remove_listener("ApplyDebuffsListener")	
				end
			end
			 return false;
		end,
		function(context)
			CusLog("???Callback: ApplyDebuffsListener  ###")
			ApplyDebuffs()
			cm:set_saved_value("Debuffed_complete",true)
		end,
		false
    )
end

--Mainly people i wont be writing stories for will be here , rest in their actual scripts
local function FigurePlayersIni() --if yuan shu is player initialize the script variables
   
    local curr_faction =cm:query_faction("3k_dlc04_faction_prince_liu_chong")
	
	if curr_faction:is_human() then
		cm:set_saved_value("liu_chong_is_human",true) 
	else
		cm:set_saved_value("liu_chong_is_human",false)
	end

	curr_faction =cm:query_faction("3k_main_faction_zheng_jiang")
	if curr_faction:is_human() then
		cm:set_saved_value("zheng_jiang_is_human",true) 
	else
		cm:set_saved_value("zheng_jiang_is_human",false)
	end
	
	curr_faction =cm:query_faction("3k_main_faction_cao_cao")
	if curr_faction:is_human() then
		cm:set_saved_value("cao_cao_is_human",true) 
	else
		cm:set_saved_value("cao_cao_is_human",false)
	end
	
	curr_faction =cm:query_faction("3k_main_faction_liu_bei")
	if curr_faction:is_human() then
		cm:set_saved_value("liu_bei_is_human",true) 
	else
		cm:set_saved_value("liu_bei_is_human",false)
	end


end

local function DebuffsVariables()
	CusLog("Debug: DebuffsVariables")
	CusLog("  Debuffs liu_chong_is_human= "..tostring(cm:get_saved_value("liu_chong_is_human")))
	CusLog("  Debuffs zheng_jiang_is_human= "..tostring(cm:get_saved_value("zheng_jiang_is_human")))
	CusLog("  Debuffs cao_cao_is_human= "..tostring(cm:get_saved_value("cao_cao_is_human")))
	CusLog("Passed: DebuffsVariables")
end


-- when the campaign loads run these functions:
cm:add_first_tick_callback(
	function(context)
		IniDebugger()
		DebuffsVariables()
		if context:query_model():turn_number() ==1 then --set up this scripts initial values
			FigurePlayersIni()
		 end

        if context:query_model():turn_number() < 3  then
			ApplyDebuffsListener()
		end


		--TMP (remove)
		--CusLog("TMP DEBUFFING CAOCAO EVERYLOAD REMOVE")
		--cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua_lite", "3k_main_faction_cao_cao" , 5)
    end
)
