---> LiuBiao 


--Should have AI LiuBiao get river regions around turn 3ish (100%, he still hasnt taken by turn 30)
-- aka when he cuts off supplies to yuanshu

--Do i need something later on for him to finish taking WuLing?

local printStatements=false;



local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_liubiao.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec).."] ")
		local header=" (LiuBiao)): "
		local line= time..header..text
		file:write(line.."\n")
		file:close()
		ModLog(header..text)
    end
end

local function IniDebugger()
	printStatements=true;
	local file = io.open("@havie_liubiao.txt", "w+")
	file:close()
	CusLog("---Begin File----")
end

local function MoveWeiYan() -- I need to be cautious of his age , listener should only pick him up is hes spawned
	CusLog("Begin MoveWeiYan")
	local qChar1= getQChar("3k_main_template_historical_wei_yan_hero_fire");
	local isAlive= (qChar1:is_null_interface()==false)
	local qFaction= getQFaction("3k_main_faction_liu_biao")
	
	if qFaction ~=nil then 
		if not qFaction:is_human() then 
			if isAlive then 
				MoveCharToFaction("3k_main_template_historical_wei_yan_hero_fire","3k_main_faction_liu_biao");
				CleanOfficerList("3k_main_faction_liu_biao")
				cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", "3k_main_faction_liu_biao" , 15)   -- satisfaction faction wide
				cm:apply_effect_bundle("3k_dlc05_effect_bundle_granted_sanctuary", "3k_main_faction_liu_biao" , 3)   -- satisfaction salary and force up keep (strong!?)
				cm:apply_effect_bundle("3k_main_payload_satisfaction_all_characters", "3k_main_faction_liu_biao" , 35)
			else
				CusLog("@..!! How the hell did this happen? weiyan should be alive")
				--cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_liu_biao", "3k_general_fire", "3k_main_template_historical_wei_yan_hero_fire");
			end
		else
			if isAlive then 
				cm:trigger_dilemma("3k_main_faction_liu_biao", "3k_lua_liubiao_hire_weiyan_alive_dilemma", true) -- Have the Dilemma Spawn him 
			else
				CusLog("@..!! How the hell did this happen? weiyan should be alive")
			end
		end
		--Add long satisfaction if AI 
	end
	CusLog("Finished MoveWeiYan")
end
local function Conquer2() -- BaDong
	CusLog("Begin Conquer2");	--Might not need to do all 3 regions, but this happens quickly after MoveEast, dont want him to die
	local qLiuBiao= getQChar("3k_main_template_historical_liu_biao_hero_earth");
	
	local region1= cm:query_region("3k_main_wuling_capital")  
	local region2= cm:query_region("3k_main_wuling_resource_1")
	local region3= cm:query_region("3k_main_wuling_resource_2")
	
	if region1:owning_faction():name() ~= "3k_main_faction_liu_biao" and not region1:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region1):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_biao"))
	end
	if region2:owning_faction():name() ~= "3k_main_faction_liu_biao" and not region2:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_biao"))
	end
	if region3:owning_faction():name() ~= "3k_main_faction_liu_biao" and not region3:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region3):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_biao"))
	end


	CusLog("Finished Conquer2");
end
local function Conquer1() -- BaDong
	CusLog("Begin Conquer1");	--Might not need to do all 3 regions, but this happens quickly after MoveEast, dont want him to die
	local qLiuBiao= getQChar("3k_main_template_historical_liu_biao_hero_earth");
	
	local region1= cm:query_region("3k_main_badong_capital")  
	local region2= cm:query_region("3k_main_badong_resource_1")
	local region3= cm:query_region("3k_main_badong_resource_2")
	--local region4= cm:query_region("3k_main_wuling_resource_1") --farm
	if not region1:is_null_interface() then 
		if region1:owning_faction():name() ~= "3k_main_faction_liu_biao" and not region1:owning_faction():is_human() then
			cm:modify_model():get_modify_region(region1):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_biao"))
		end
	end
	if not region2:is_null_interface() then 
		if region2:owning_faction():name() ~= "3k_main_faction_liu_biao" and not region2:owning_faction():is_human() then
			cm:modify_model():get_modify_region(region2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_biao"))
		end
	end
	if not region3:is_null_interface() then 
		if region3:owning_faction():name() ~= "3k_main_faction_liu_biao" and not region3:owning_faction():is_human() then
			cm:modify_model():get_modify_region(region3):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_biao"))
		end
	end
	
	--CusLog("..Increasing qLiuBiao funds, idk why")
	--cm:modify_faction(qLiuBiao:faction():name()):increase_treasury(400)
 

	CusLog("Finished Conquer1");
end


-----------------------------------------------------------------------
-----------Separate Functions from Listeners---------------------------
-----------------------------------------------------------------------
function LiuBiaoExpansion2Listener() --Will work for both 190/AWB AI
	CusLog("### LiuBiaoExpansion2Listener loading ###") --Foothold in Poyang
	core:remove_listener("LiuBiaoExpansion2")
	core:add_listener(
		"LiuBiaoExpansion2",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(197,204) then 
				local qLiuBiao= getQChar("3k_main_template_historical_liu_biao_hero_earth")
				if qLiuBiao:is_null_interface() then
					CusLog("!!!..qLiuBiao is null??wth?")
					return false;
				elseif qLiuBiao:is_dead() then			
					return false
				elseif qLiuBiao:faction():name() ~= context:faction():name() then 
					return false;
				elseif not qLiuBiao:is_faction_leader() then 
					return false;
				end
				if not context:faction():is_human() and cm:get_saved_value("expand_south2") ~=true then 
					CusLog("..Checking if Should Give liubiao land")
					if cm:get_saved_value("NextTurn_LB") <= context:query_model():turn_number() then 
						return RNGHelper(3); 
					end
				--elseif context:faction():is_human() and cm:get_saved_value("expand_south1") ~=true then
					-- Do nothing , maybe its time for a dilemma?
				end
			
			end
			 return false
		end,
		function(context)
			CusLog("??Callback: Passed LiuBiaoExpansion2Listener ###")
			Conquer2()
			LiuBiaoExpansion2Listener()
			cm:set_saved_value("expand_south2",true)
			cm:set_saved_value("NextTurn_LB",context:query_model():turn_number()+8)
			CusLog("### Finished LiuBiaoExpansion2Listener Callback ###")
		end,
		false
    )
end

function LiuBiaoExpansion1Listener() 
	CusLog("### LiuBiaoExpansion1Listener loading ###") 
	core:remove_listener("LiuBiaoExpansion")
	core:add_listener(
		"LiuBiaoExpansion",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(193,196) then 
				local qLiuBiao= getQChar("3k_main_template_historical_liu_biao_hero_earth")
				if qLiuBiao:is_null_interface() then
					CusLog("!!!..qLiuBiao is null??wth?")
					return false;
				elseif qLiuBiao:is_dead() then			
					return false
				elseif qLiuBiao:faction():name() ~= context:faction():name() then 
					return false;
				elseif not qLiuBiao:is_faction_leader() then 
					return false;
				end
				if not context:faction():is_human() and cm:get_saved_value("expand_south1") ~=true then 
					CusLog("..Checking if Should Give liubiao land")
					if cm:get_saved_value("NextTurn_LB") <= context:query_model():turn_number() then 
						return RNGHelper(3); 
					end
				--elseif context:faction():is_human() and cm:get_saved_value("expand_south1") ~=true then
					-- Do nothing , maybe its time for a dilemma?
				end
			
			end
			 return false
		end,
		function(context)
			CusLog("??Callback: Passed LiuBiaoExpansion1Listener ###")
			Conquer1()
			LiuBiaoExpansion2Listener()
			cm:set_saved_value("expand_south1",true)
			cm:set_saved_value("NextTurn_LB",context:query_model():turn_number()+1)
			CusLog("### Finished LiuBiaoExpansion1Listener Callback ###")
		end,
		false
    )
end

function LiuBiaoWeiYanListener() --Will work for both 190/AWB AI
	CusLog("### LiuBiaoWeiYanListener loading ###") 
	core:remove_listener("LiuBiaoWeiYan")
	core:add_listener(
		"LiuBiaoWeiYan",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(189,195) then 
				local qLiuBiao= getQChar("3k_main_template_historical_liu_biao_hero_earth")
				if qLiuBiao:is_null_interface() then
					CusLog("!!!..qLiuBiao is null??wth?")
					return false;
				elseif qLiuBiao:is_dead() then			
					return false
				elseif qLiuBiao:faction():name() ~= context:faction():name() then 
					return false;
				elseif not qLiuBiao:is_faction_leader() then 
					return false;
				end
				if cm:get_saved_value("GaveWeiYan") ~=true then 
					local qChar1= getQChar("3k_main_template_historical_wei_yan_hero_fire");
					if qChar1:is_null_interface() then 
						return false
					else
						return true; -- should hopefully only pick him up once he spawns 
					end
				end
			end
			 return false
		end,
		function(context)
			CusLog("??Callback: Passed LiuBiaoWeiYanListener ###")
			MoveWeiYan()
			cm:set_saved_value("GaveWeiYan",true) -- dont think this is being set? investiage next campaign, may have only ran function?
			CusLog("### Finished LiuBiaoWeiYanListener Callback ###")
		end,
		false
    )
end

local function AILiuBiaoCutkSuppliesListener() -- TODO region name 
	CusLog("### AILiuBiaoCutkSuppliesListener loading ###")
	core:remove_listener("AILiuBiaoCutkSupplies")
	core:add_listener(
		"AILiuBiaoCutkSupplies",
		"IncidentOccuredEvent",
		function(context)
			 return context:incident() == "3k_lua_yuanshu_cut_supplies"
		end,
		function(context)
		cm:set_saved_value("NextTurn_LB",context:query_model():turn_number()+4)
		local region1= cm:query_region("3k_main_jingzhou_capital")
			if not region1:is_null_interface() then 
				if not region1:owning_faction():is_human() and region1:owning_faction():name()~="3k_main_faction_liu_biao" then 
					cm:modify_model():get_modify_region(region1):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_biao"))
				end
			end
		end,
		false
    )
end

local function LiuBiaoVariables()
		CusLog("  LiuBiao expand_south1= "..tostring(cm:get_saved_value("expand_south1")))
		CusLog("  LiuBiao NextTurn_LB= "..tostring(cm:get_saved_value("NextTurn_LB")))
		CusLog("  LiuBiao GaveWeiYan= "..tostring(cm:get_saved_value("GaveWeiYan")))
end
local function LiuBiaoIni() 
   

    local curr_faction =cm:query_faction("3k_main_faction_liu_biao")
	if(curr_faction:is_null_interface()) then
		return;
	end
	if curr_faction:is_human() then
		cm:set_saved_value("liu_biao_is_human",true) -- might be useful to use this check
	else
		cm:set_saved_value("liu_biao_is_human",false)

		
		 
	end 
end


-- when the campaign loads run these functions:
cm:add_first_tick_callback(
	function(context)
		IniDebugger()
		LiuBiaoVariables()
		if context:query_model():turn_number() == 1 then 
			LiuBiaoIni()
		end
        if context:query_model():date_in_range(189,193) then 
			AILiuBiaoCutkSuppliesListener()
		end
		if context:query_model():date_in_range(193,202) then 
			if cm:get_saved_value("expand_south1")~=true then 
				LiuBiaoExpansion1Listener()			
			end
			if cm:get_saved_value("expand_south2")~=true then 
				LiuBiaoExpansion2Listener()			
			end
		end
		if cm:get_saved_value("GaveWeiYan")~=true then 
			LiuBiaoWeiYanListener()			
		end

	
		--CusLog("TMP Conquer1()")
		--Conquer1()
		--CusLog("TMP MoveWeiYan()")
		--MoveWeiYan()

	end
)


