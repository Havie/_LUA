--> Guan Du

local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_guandu.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
		local header=" (guandu): "
		local line= time..header..text
		file:write(line.."\n")
		file:close()
		ModLog(header..text)
    end
end

local function IniDebugger()
	printStatements=true;
	local file = io.open("@havie_guandu.txt", "w+")
	file:close()
	CusLog("---Begin File----")
end


local function KillYuanCore()
	--kill yan liang and wen chou if they are not already dead from guan yu 
	local yanliang="3k_main_template_historical_yan_liang_hero_fire"
	local wenchou="3k_main_template_historical_wen_chou_hero_wood"
	if MTU then 
		wenchou="3k_mtu_template_historical_wen_chou_hero_wood"
		yanliang="3k_mtu_template_historical_yan_liang_hero_fire"
	end

	local qChar=getQChar2(yanliang)
	local qChar2=getQChar2(wenchou)
	if qChar~=nil then 
		CusLog("kill yan liang")
		cm:modify_character(qChar):kill_character(false);
	end 
	if qChar2~=nil then 
		CusLog("kill wenchou")
		cm:modify_character(qChar2):kill_character(false);
	end 
end

local function triggerfued()
	CusLog("Begin triggerfued")
	local q_yuanshaoFaction=cm:query_faction("3k_main_faction_yuan_shao")
	local q_yuanshao= getQChar("3k_main_template_historical_yuan_shao_hero_earth")
	if q_yuanshaoFaction:is_null_interface() or q_yuanshao:is_null_interface()then 
		return ;
	elseif q_yuanshaoFaction:is_dead() then 
		return ;
	end
	if not q_yuanshaoFaction:is_human() then 
		cm:trigger_incident(getPlayerFaction(),"3k_lua_cao_yuan_fued", true ) --sets yuans_mad
	else
		--ToDo trigger a dilemma for yuan shao player 
		--cm:set_saved_value("yauns_mad", true); 
	end

	CusLog("End triggerfued")
end



local function triggerWar()
	
	CusLog("Begin triggerWar")
	local q_yuanshaoFaction=cm:query_faction("3k_main_faction_yuan_shao")
	local q_yuanshao= getQChar("3k_main_template_historical_yuan_shao_hero_earth")
	if q_yuanshaoFaction:is_null_interface() or q_yuanshao:is_null_interface()then 
		return ;
	elseif q_yuanshaoFaction:is_dead() then 
		return ;
	end
	if not q_yuanshaoFaction:is_human() then 
		local playersFactionsTable = cm:get_human_factions()
		local playerFaction = playersFactionsTable[1]
		cm:trigger_incident(playerFaction,"3k_main_caocao_war_yuanshao", true ) 
	else
		--ToDo trigger a dilemma for yuan shao player 
		
	end
	--maybe something for player cao cao?



	CusLog("End triggerWar")
end


local function GuanDu()

    local playersFactionsTable = cm:get_human_factions()
    local playerFaction = playersFactionsTable[1]
    local q_yuanshao = cm:query_faction("3k_main_faction_yuan_shao")
    local q_caocao = cm:query_faction("3k_main_faction_cao_cao")

    local caocao_character = cm:query_model():character_for_template("3k_main_template_historical_cao_cao_hero_earth")
    local yuanshao_character = cm:query_model():character_for_template("3k_main_template_historical_yuan_shao_hero_earth")

	if not q_yuanshao:is_human()  and not q_caocao:is_human() then
        if not q_yuanshao:is_world_leader() then
            CusLog("confederate yuan shao!") 
           -- cm:modify_character(yuanshao_character):kill_character(false)
            cm:force_confederation("3k_main_faction_cao_cao","3k_main_faction_yuan_shao")
            cm:trigger_incident(playerFaction,"3k_main_caocao_confed_yuanshao", true )
			--Could register Yuan shang as an emergent faction ?
		else
            CusLog("didnt pass check")
		end
	end

	KillYuanCore()
	register_YuanShang_emergent_faction_2()
	cm:set_saved_value("SpawnYuanShang",true)
	CleanOfficerList("3k_main_faction_cao_cao")
	cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua", "3k_main_faction_cao_cao" , 6)
	cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua_lite", "3k_main_faction_cao_cao" , 18)
end





-------------------
--BEGIN LISTENERS--
-------------------

function GuanDuConfederationListener() --AIs only 
	CusLog("### GuanDuConfederationListener loading ###")
	core:remove_listener("guanduconfed");
	core:add_listener(
		"guanduconfed",
		"FactionTurnEnd",
		function(context)
		--	CusLog("turn start guan du:")
			if context:faction():name()=="3k_main_faction_yuan_shao" and not context:faction():is_human() then 
				if context:query_model():calendar_year() >= 200 then
					-- make sure hes alive
					local yuanshao_character = cm:query_model():character_for_template("3k_main_template_historical_yuan_shao_hero_earth")
					local caocao_character = cm:query_model():character_for_template("3k_main_template_historical_cao_cao_hero_earth")
					CusLog(" checking if yuan and cao are alive")
					if not yuanshao_character:is_null_interface() and not caocao_character:is_null_interface() then 
						if  not caocao_character:faction():is_human() and not yuanshao_character:is_dead() and not caocao_character:is_dead() and yuanshao_character:is_faction_leader() and caocao_character:is_faction_leader()  then 
							if CountRegions("3k_main_faction_cao_cao") >= CountRegions("3k_main_faction_yuan_shao")then 
								CusLog(" CaoCao has more regions than Shao, do it ")
								return context:faction():has_specified_diplomatic_deal_with("treaty_components_war",caocao_character:faction())
							else
								CusLog("Check if Cao owns the right regions:")
								--Check if Cao Cao owns regions in right place
								local northernRegion1= cm:query_region("3k_main_henei_capital")
                                local northernRegion2= cm:query_region("3k_main_henei_resource_1")
								local northernRegion3= cm:query_region("3k_main_pingyuan_capital")
								local northernRegion4= cm:query_region("3k_main_ye_capital")
                                if not northernRegion1:is_null_interface() and not northernRegion2:is_null_interface() and not northernRegion3:is_null_interface() and not northernRegion4:is_null_interface() then 
									CusLog("not nulls")
									if northernRegion1:owning_faction():name() =="3k_main_faction_cao_cao" or northernRegion2:owning_faction():name() =="3k_main_faction_cao_cao" or northernRegion3:owning_faction():name() =="3k_main_faction_cao_cao" or northernRegion4:owning_faction():name() =="3k_main_faction_cao_cao" then 
										CusLog("Cao Cao owns a relevant region ")
										if  context:faction():has_specified_diplomatic_deal_with("treaty_components_war",caocao_character:faction())then 
											return RNGHelper(3)
										else 
											CusLog("Caocao and yuan dont have war? force it?")
										end
									end
								else 
									CusLog("@@!!! regions are null!!")
								end
								CusLog(" Falling through so buffing CaoCao")
								cm:modify_faction("3k_main_faction_cao_cao"):increase_treasury(500)
							end
						end
					end
				end
			end
			
			return false
		end,
		function(context)
			CusLog("??? Callback: GuanDuConfederationListener ###")
			GuanDu()
			cm:set_saved_value("caocao_war_launched", false);
			core:remove_listener("guanduconfed")
			CusLog("removed listener")
			CusLog("### FINISHED GuanDuConfederationListener ###")
		end,
		true
    )
end


function YuanWarsCaoListener()
	CusLog("### YuanWarsCaoListener listener loading ###")
	core:remove_listener("guanduWar");
	core:add_listener(
		"guanduWar",
		"IncidentOccuredEvent",
		function(context)
			 return context:incident() == "3k_main_caocao_war_yuanshao"
		end,
		function(context)
			CusLog("??? CallBack: YuanWarsCaoListener ###")
			cm:set_saved_value("caocao_war_launched", true);
			cm:set_saved_value("caocao_buffed_turnlimit", cm:query_model():turn_number() +8)-- Buff AI Cao cao for 8turns
			local q_yuanshaoFaction=cm:query_faction("3k_main_faction_yuan_shao")
			local q_caocaoFaction=cm:query_faction("3k_main_faction_cao_cao")
			--Fail Safe
			if not q_yuanshaoFaction:has_specified_diplomatic_deal_with("treaty_components_war",q_caocaoFaction) then 
				cm:force_declare_war("3k_main_faction_yuan_shao", "3k_main_faction_cao_cao", true)
			end
		end,
		false
    )
end


local function WarDelayCaoYuan()
	CusLog("### WarDelayCaoYuan listener loading ###")
	core:remove_listener("WarDelayCaoYuanyuancao");
	core:add_listener(
		"WarDelayCaoYuanyuancao",
		"FactionTurnEnd",
		function(context)
			if context:faction():name() == "3k_main_faction_yuan_shao" and cm:get_saved_value("yauns_mad") == true then 
				if context:query_model():calendar_year() >=200 then 
					return RNGHelper(2)
				end
			end

			return false
		end,
		function(context)
			cm:set_saved_value("yauns_mad", false);
			triggerWar()
			core:remove_listener("WarDelayCaoYuanyuancao");
		end,
		true
    )
end





function CaoAndYuanFuedListener()
	CusLog("### CaoAndYuanFuedListener listener loading ###")
	core:remove_listener("caofuedyuan");
	core:add_listener(
		"caofuedyuan",
		"IncidentOccuredEvent",
		function(context)
			 return context:incident() == "3k_lua_cao_yuan_fued"
		end,
		function(context)
			cm:set_saved_value("yauns_mad", true);
			cm:set_saved_value("caocao_buffed_turnlimit", cm:query_model():turn_number() +2)-- Buff Cao cao for 2
			core:remove_listener("caofuedyuan");
		end,
		true
    )
end

local function YuansBeefListener()
	CusLog("### Setting up YuansBeefListener ###")
	core:remove_listener("YuansBeef");
	core:add_listener(
		"YuansBeef",
		"FactionTurnStart",
		function(context)
			if context:faction():name() == "3k_main_faction_yuan_shao" and cm:get_saved_value("TimeTillFued") <= context:query_model():turn_number() then 
				return true;
			end
			return false
		end,
		function(context)
			CusLog("??? Callback: YuansBeefListener ###")
			cm:set_saved_value("TimeTillFued",999)
			CaoAndYuanFuedListener();
			triggerfued()
			CusLog("### Finished: YuansBeefListener ###")
		end,
		false
    )
end

function CaoHasEmperorListener()
	CusLog("### CaoHasEmperorListener listener loading ###")
	core:remove_listener("CaoHasEmperorL");
	core:add_listener(
		"CaoHasEmperorL",
		"FactionTurnEnd",
		function(context)
			 if cm:get_saved_value("caocao_vs_yuanshao") == true then
			 	return true
			 end
			return false
		end,
		function(context)
			CusLog("??? Callback: CaoHasEmperorListener ")
			cm:set_saved_value("caocao_vs_yuanshao", false);
			--Should Probably Do a Check that Yuan Shao isnt human?
			--triggerfued()
			local rng= math.floor(cm:random_number(2,6));
			cm:set_saved_value("TimeTillFued", context:query_model():turn_number()+rng);
		end,
		false
    )
end

local function GuanDuIni()
	CusLog(" *GuanDu caocao_vs_yuanshao (startsScript)= "..tostring(cm:get_saved_value("caocao_vs_yuanshao"))) --CaoCAo has emperor
	CusLog("  GuanDu TimeTillFued= "..tostring(cm:get_saved_value("TimeTillFued")))
	CusLog("  GuanDu yauns_mad= "..tostring(cm:get_saved_value("yauns_mad"))) --Feud occurred 
	CusLog("  GuanDu caocao_war_launched= "..tostring(cm:get_saved_value("caocao_war_launched")))

	 
end


-- when the game loads run these functions:
cm:add_first_tick_callback(
	function(context)
		IniDebugger()
		GuanDuIni()
		if context:query_model():date_in_range(194,205) then
			if cm:get_saved_value("TimeTillFued") ~= 999 then 
				CaoHasEmperorListener()
				YuansBeefListener()
				CaoAndYuanFuedListener()
			end
			if cm:get_saved_value("caocao_war_launched") ~=true then 
				WarDelayCaoYuan()
				YuanWarsCaoListener()
			end
			GuanDuConfederationListener()

		end

		--CusLog("TMP")
		--cm:trigger_incident(getPlayerFaction(), "3k_main_caocao_confed_yuanshao", true )
    end
)


