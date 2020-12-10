---> Wu leaders

-- Responsible for killing Sun Jian, Sun Ce, and making SunQuan leader


local printStatements=false;



local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_wu_leaders.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec).."] ")
		local header=" (Wu_leaders)): "
		local line= time..header..text
		file:write(line.."\n")
		file:close()
		ModLog(header..text)
    end
end
local function Cuslog(text)
    CusLog(text)
end
local function IniDebugger()
	printStatements=true;
	local file = io.open("@havie_wu_leaders.txt", "w+")
	file:close()
	CusLog("---Begin File----")
end

local function KillSunCe() -- toDo event name
	CusLog("Begin KillSunCe")
	getModifyChar("3k_main_template_historical_sun_ce_hero_fire"):kill_character(false) --Test if killing him here prevents the incident from firing next turn

	local playersFactionsTable = cm:get_human_factions()
	local playerFaction = playersFactionsTable[1]
	local triggered=cm:trigger_incident(playerFaction,"3k_lua_sun_ce_dies", true )
	--local qFaction = cm:query_faction("3k_main_faction_sun_jian")
	
	cm:set_saved_value("sunce_dead", true); -- used for other things (chars joining?)
	CusLog("..Promoting SunQuan");
	--Make sure SunQuan takes over
	local qQuan= getQChar("3k_main_template_historical_sun_quan_hero_earth")
	if not qQuan:is_faction_leader() and not qQuan:is_dead() then 
		local mQuan=cm:modify_character(qQuan)
		if qQuan:is_character_is_faction_recruitment_pool() or qQuan:faction():name() ~= "3k_main_faction_sun_jian" then --If hes in the player faction.. oh well.
			CusLog("...qQuan Was In is_character_is_faction_recruitment_pool.. or not in Wu, making him leader will crash the game, trying to fix")
			mQuan:set_is_deployable(true)
			mQuan:move_to_faction_and_make_recruited("3k_main_faction_han_empire")
			mQuan:set_is_deployable(true)
			mQuan:move_to_faction_and_make_recruited("3k_main_faction_sun_jian")
    	end
		mQuan:assign_to_post("faction_leader");
		--cm:set_saved_value("sunquan_leader", true); -- used for other things (chars joining?)
	end

	CusLog("Finished KillSunCe")
end


local function KillSunJian() 
	CusLog("Begin KillSunJian")
	

	local playersFactionsTable = cm:get_human_factions()
	local playerFaction = playersFactionsTable[1]
	local triggered=cm:trigger_incident(playerFaction,"3k_main_historical_sun_jian_dies_npc_incident_scripted", true ) -- event might not fire next turn if SunJian dies here

	CusLog("triggered="..tostring(triggered));

	--let the event do it
	--[[local qsj=getQChar("3k_main_template_historical_sun_jian_hero_metal")
	if not qsj:is_null_interface() then 
		CusLog("killing sj");
		cm:modify_character(qsj):kill_character(false)
	else
		CusLog("..Sunjians null 1")
	end
	--getModifyChar("3k_main_template_historical_sun_jian_hero_metal"):kill_character(false) --]]
	
	cm:set_saved_value("sunjian_dead", triggered); -- used for other things
	--Note* Sunce keeps the seal till moves west
	CusLog("Finished KillSunJian")
end



local function CheckSunCesPosition() -- TODOregion names
	CusLog("Begin CheckSunCesPosition")
	local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire");
	
	if( qSunCe:is_null_interface()) then 
		CusLog("NULL CheckSunCesPosition=false")
		return false;
	--elseif cm:query_faction("3k_main_faction_liu_biao"):has_specified_diplomatic_deal_with("treaty_components_peace",qSunCe:faction()) then
	--	return false;
	end
	
	local hisRegion= qSunCe:region():name();
	--Best cond he's anywhere in SouthEastern China?
	if( hisRegion=="3k_main_todo1" or  hisRegion=="3k_main_todo1" or  hisRegion=="3k_main_todo1") then 
		CusLog("Finished CheckSunCesPosition=True")
		return true;
	end
	CusLog("Finished CheckSunCesPosition=false")
	return false;
end


local function CheckSunJiansPosition() 
	CusLog("Begin CheckSunJiansPosition")
	local qSunJian= getQChar("3k_main_template_historical_sun_jian_hero_metal");
	
	if( qSunJian:is_null_interface()) then 
		CusLog("NULL CheckSunJiansPosition")
		return false;
	elseif cm:query_faction("3k_main_faction_liu_biao"):has_specified_diplomatic_deal_with("treaty_components_peace",qSunJian:faction()) then
		CusLog("PEACE CheckSunJiansPosition")
		return false;
	end
	
	local hisRegion= qSunJian:region():name();
	
	if( hisRegion=="3k_main_jingzhou_capital" or hisRegion=="3k_main_jingzhou_resource_1" or  hisRegion=="3k_main_jiangxia_capital" or  hisRegion=="3k_main_lujiang_resource_1") then 
		CusLog("Finished CheckSunJiansPosition =true")
		return true;
	end
	CusLog("Finished CheckSunJiansPosition=false")
	return false;
end


function EnsureSunCeDiesListener() -- wont work for AWB cuz the diff faction names
	CusLog("### EnsureSunCeDiesListener loading ###")
	core:remove_listener("EnsureSunCeDies")
	core:add_listener(
		"EnsureSunCeDies",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(200,203) and context:faction():name() =="3k_main_faction_sun_jian" then 
				local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire")
				if qSunCe:is_null_interface() then
					CusLog("!!!..Sunce is null??wth?")
					return false;
				elseif qSunCe:is_dead() then 
					cm:set_saved_value("sunce_dead", true)
					core:remove_listener("EnsureSunCeDies")
					return false
				end
				CusLog("..Checking if Sunce should die")
				if not context:faction():is_human() then 
						if cm:get_saved_value("sunce_dead") ~=true then
							return RNGHelper(6); -- would be nice to add a check hes not visible to player, but meh
						end
				elseif cm:get_saved_value("sunce_dead") ~=true then --Human  
					CusLog("Player is Wu..going to check Sunce Position")
					return CheckSunCesPosition()
				end
			
			end
			 return false
		end,
		function(context)
			CusLog("??Callback: Passed EnsureSunCeDiesListener ###")
			KillSunCe()
			CusLog("### Finished EnsureSunCeDiesListener Callback ###")
		end,
		false
    )
end




function SunCeRevengeListener() 
	CusLog("### SunCeRevengeListener loading ###")
	core:remove_listener("SunCeRevenge")
	core:add_listener(
		"SunCeRevenge",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(200,203) and context:faction():name() =="3k_main_faction_sun_jian" and cm:get_saved_value("sunce_revenge")~=true then 
				local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire")
				if qSunCe:is_null_interface() then
					CusLog("!!!..Sunce is null??wth?")
					return false;
				elseif qSunCe:is_dead() then 
					cm:set_saved_value("sunce_dead", true)
					core:remove_listener("SunCeRevenge")
					return false
				end
				CusLog("..Checking if Sunce should die")
				if qSunCe:is_faction_leader() then 
					return cm:get_saved_value("sunjian_dead")==true;
				end
			
			end
			 return false
		end,
		function(context)
			CusLog("??Callback: Passed SunCeRevengeListener ###")
			--Fire event 
			local playersFactionsTable = cm:get_human_factions()
			local playerFaction = playersFactionsTable[1]
			local triggered=cm:trigger_incident(playerFaction,"3k_main_lua_sunce_revenge", true ) 
			CusLog("triggered="..tostring(triggered));
			cm:set_saved_value("sunce_revenge",triggered)
			CusLog("### Finished SunCeRevengeListener Callback ###")
		end,
		false
    )
end

function SunCeOfAgeListener()
	CusLog("### SunCeOfAgeListener loading ###") 
	core:remove_listener("SunCeOfAge")
	core:add_listener(
		"SunCeOfAge",
		"FactionTurnEnd",
		function(context)
			if cm:get_saved_value("sunjian_dead")==true and context:faction():name() =="3k_main_faction_sun_jian" then  
				--CusLog(" CHECKING SUNCES AGE FFS ")
				local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire")
				if qSunCe:is_null_interface() then
					CusLog("!!!..qSunCe is null??wth?")
					return false;
				elseif qSunCe:is_dead() then
					CusLog("!!!..qSunCe is Dead??wth?")			
					return false
				elseif qSunCe:faction():name() ~= "3k_main_faction_sun_jian" then --190 only
					MoveCharToFactionHard("3k_main_template_historical_sun_ce_hero_fire", "3k_main_faction_sun_jian")
					return false;
				elseif not qSunCe:is_faction_leader() then 
					CusLog("Sunce is not leader, checking age")
					if qSunCe:age() >=18 then 
						--CusLog("hes old enough")
						local mchar=cm:modify_character(qSunCe)
						if not mchar:is_null_interface() then 
							CusLog("make leader")
							mchar:assign_to_post("faction_leader");
							return true;
						end
					else
						CusLog("Sunce age ="..tostring(qSunCe:age()))
					end
				end
			end
			 return false
		end,
		function(context)
			CusLog("??Callback: Passed SunCeOfAgeListener ###")
			--Did it above cuz whatever, dont want to get the modify char again 
			CusLog("### Finished SunCeOfAgeListener Callback ###")
		end,
		false
    )
end

function EnsureSunJianDiesListener() --NEED to add a condition if player is yuan shu to wait till first dilemma 
	CusLog("### EnsureSunJianDiesListener loading ###")
	core:remove_listener("EnsureSunJianDies")
	core:add_listener(
		"EnsureSunJianDies",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(191,193) and context:faction():name() =="3k_main_faction_sun_jian" then 
				local qSJian= getQChar("3k_main_template_historical_sun_jian_hero_metal")
				if qSJian:is_null_interface() then
					CusLog("!!!..qSunJian is null??wth?")
					return false;
				elseif qSJian:is_dead() then
					cm:set_saved_value("sunjian_dead", true)
					core:remove_listener("EnsureSunJianDies")				
					return false
				end
				if not context:faction():is_human() then 
						CusLog("..Checking if SunJian should die")
						local qyuanshuFaction = cm:query_faction("3k_main_faction_yuan_shu")
						if not qyuanshuFaction:is_null_interface() then 
							if qyuanshuFaction:is_human() and cm:get_saved_value("sunjian_dead") ~=true then 
								if cm:get_saved_value("yuanshu_responded") then 
									if cm:get_saved_value("sun_turnDelay") ==nil then 
										cm:set_saved_value("sun_turnDelay",4)
										return false 
									else 
										local weight=cm:get_saved_value("sun_turnDelay")
										local chance= RNGHelper(weight); -- would be nice to add a check hes not visible to player, but meh
										CusLog("..returning "..tostring(chance))
										if not chance then 
											cm:set_saved_value("sun_turnDelay",weight-1)
										end
										return chance
									end 
								end
								CusLog(" yuan shu is human returning response="..tostring(chance))
							elseif cm:get_saved_value("sunjian_dead") ~=true then
								local chance= RNGHelper(6); -- would be nice to add a check hes not visible to player, but meh
								CusLog("..returning "..tostring(chance))
								return chance
							end
						else
							CusLog("..yuan shu is null wtf?..goahead")
							return RNGHelper(3)
						end
				elseif cm:get_saved_value("sunjian_dead") ~=true then -- Human
					CusLog("Player is Wu..going to check SunJians Region")
					return CheckSunJiansPosition()
				end
			
			end
			 return false
		end,
		function(context)
			CusLog("??Callback: Passed EnsureSunJianDiesListener ###")
			KillSunJian() -- wont call back?
			--MoveWuEastListener() -- incase it isnt on 
			CusLog("### Finished EnsureSunJianDiesListener Callback ###")
		end,
		false
    )
end



local function WuLeadersVariables()
		CusLog("  WuLeaders sunjian_dead= "..tostring(cm:get_saved_value("sunjian_dead")))
		CusLog("  WuLeaders sunce_revenge= "..tostring(cm:get_saved_value("sunce_revenge")))
		CusLog("  WuLeaders sunce_dead= "..tostring(cm:get_saved_value("sunce_dead")))

end
local function WuLeadersIni() 
   CusLog("begin WuLeadersIni")
	local qSunJian= getQChar("3k_main_template_historical_sun_jian_hero_metal")
	if not qSunJian:is_null_interface() then 
		CusLog("1")
		if not qSunJian:is_dead() then 	
			CusLog("2")
			local curr_faction = qSunJian:faction();
			CusLog("3")
			if(curr_faction:is_null_interface()) then
				CusLog("4")
				return;
			end
			CusLog("5")
			if curr_faction:is_human() then
				CusLog("6")
				cm:set_saved_value("wu_is_human",true) -- might be useful to use this check
			else
				CusLog("7")
				cm:set_saved_value("wu_is_human",false)
			end
		end
	end
	CusLog("emd")
end


-- when the campaign loads run these functions:
cm:add_first_tick_callback(
	function(context)
		IniDebugger()
		WuLeadersVariables()
		if context:query_model():turn_number() == 1 then 
			WuLeadersIni()
		end
        if context:query_model():date_in_range(189,193) then 
			EnsureSunJianDiesListener()
		end
		if context:query_model():date_in_range(189,194) then 
			SunCeOfAgeListener()
			SunCeRevengeListener()
		end
		if context:query_model():date_in_range(198,202) then 
			EnsureSunCeDiesListener()
		end
		

	end
)


