-----> XU _ Lu BU  this script handles events once (ai/player) lu bu takes PuYang
--- Lets 190 LuBu, AI LuBu, and human/AI player save LuBu from CaoCao
--- Triggers ZhangFei Drunk incident for 190,194 all factions, generic
--- Allows 190 AI/Player LuBu to betray AI/Player LiuBei (yuan shu script continues and picks up AWB)



--Spawn Zhangfei in XiapPi (handled in xu_plot2 (and a fail safe in here for AI)

--TODO LuBu needs custom events where he is given an option to listen to chen gong/others, or himself at the cost of global satisfaction reduction 
--TODO spawn lulingqi, add her to the capture (but not if shes in yuan shu faction)

local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_xu_lubu_post.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
		local header=" (lubu_xu_post): "
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
	local file = io.open("@havie_xu_lubu_post.txt", "w+")
	file:close()
	CusLog("---Begin File----")
end


local function RegisterCheZhou() -- this might get weird if CaoCao is human?
	CusLog("Begin RegisterCheZhou")
	local region1= cm:query_region(XIAPICITY)
	local region2= cm:query_region(XIAOPEICITY) 
	local region3= cm:query_region(DONGIRONMINE)
	local region4= cm:query_region(PENGCHENGTEMPLE)
	local region5= cm:query_region("3k_main_langye_capital")
	
	if  region1:is_null_interface() or  region2:is_null_interface() or  region3:is_null_interface() or  region4:is_null_interface()  then 
		CusLog("One of the regions are null, will crash, returning")
		return;
	end
	
	local ChosenRegion=XIAPICITY
	if region1:owning_faction():name() == "3k_main_faction_cao_cao" then
			ChosenRegion= region1:name();
		elseif region2:owning_faction():name() == "3k_main_faction_cao_cao"  then
			ChosenRegion= region2:name();
		elseif region5:owning_faction():name() == "3k_main_faction_cao_cao" then
			ChosenRegion= region3:name();
		elseif region3:owning_faction():name() == "3k_main_faction_cao_cao" then
			ChosenRegion= region4:name();
		elseif region4:owning_faction():name() == "3k_main_faction_cao_cao" then
			ChosenRegion= region5:name();
		end
	
	cm:set_saved_value("chezhou_region",ChosenRegion)
	CusLog("chezhou chooses"..ChosenRegion)
	
	local qCaoCao_Faction=cm:query_faction("3k_main_faction_cao_cao")
	if qCaoCao_Faction:is_human() then 
		--A  dilemma to appoint chezhou in Xu
		--Might have to do some more checks here to see if chezhou is even alive/not in a human faction before firing this
		cm:trigger_dilemma("3k_main_faction_cao_cao", "3k_lua_caocao_appoint_chezhou", true) --TODO
		--Create a listener that will register him 

	else
		cm:set_saved_value("SpawnCheZhou",true)
		register_CheZhou_emergent_faction_2()
	end
	
	CusLog("End RegisterCheZhou")
end
local function ExecuteHelper()
	local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
    local qdiaochan = cm:query_model():character_for_template("3k_main_template_historical_lady_diao_chan_hero_water")
    local qgaoshun = cm:query_model():character_for_template("3k_main_template_historical_gao_shun_hero_fire")
	local qchengong = cm:query_model():character_for_template("3k_main_template_historical_chen_gong_hero_water")
	if not qdiaochan:is_null_interface() then 
		if not qdiaochan:faction():is_human() and not qdiaochan:is_dead() then 
			CusLog("..Killing qdiaochan");
			getModifyChar("3k_main_template_historical_lady_diao_chan_hero_water"):kill_character(false);
			cm:trigger_incident(getPlayerFaction(), "3k_lua_diao_chan_executed",true)
		elseif qdiaochan:is_character_is_faction_recruitment_pool() then 
			CusLog("..Killing qdiaochan");
			getModifyChar("3k_main_template_historical_lady_diao_chan_hero_water"):kill_character(false);
			cm:trigger_incident(getPlayerFaction(), "3k_lua_diao_chan_executed",true)
		end
	end
	if not qgaoshun:is_null_interface() then 
		CusLog("1")
		if not qgaoshun:faction():is_human() and not qgaoshun:is_dead() then 
			CusLog("..Killing qgaoshun");
			getModifyChar("3k_main_template_historical_gao_shun_hero_fire"):kill_character(false);
			cm:trigger_incident(getPlayerFaction(), "3k_lua_gao_shun_executed",true)
		elseif qgaoshun:is_character_is_faction_recruitment_pool() then 
			CusLog("..Killing qgaoshun");
			getModifyChar("3k_main_template_historical_gao_shun_hero_fire"):kill_character(false);
			cm:trigger_incident(getPlayerFaction(), "3k_lua_gao_shun_executed",true)
		end
	end
	if not qchengong:is_null_interface() then 
		if not qchengong:faction():is_human() and not qchengong:is_dead() then 
			CusLog("..Killing qchengong");
			getModifyChar("3k_main_template_historical_chen_gong_hero_water"):kill_character(false);
			cm:trigger_incident(getPlayerFaction(), "3k_lua_chen_gong_executed",true)
		elseif qchengong:is_character_is_faction_recruitment_pool() then 
			CusLog("..Killing qchengong");
			getModifyChar("3k_main_template_historical_chen_gong_hero_water"):kill_character(false);
			cm:trigger_incident(getPlayerFaction(), "3k_lua_chen_gong_executed",true)
		end
	end
	if not qlubu:is_null_interface() then 
		if not qlubu:faction():is_human() and not qlubu:is_dead() then 
			CusLog("..Killing qlubu");
			getModifyChar("3k_main_template_historical_lu_bu_hero_fire"):kill_character(true);
			cm:trigger_incident(getPlayerFaction(), "3k_lua_lu_bu_executed",true)
		elseif qlubu:is_character_is_faction_recruitment_pool() then 
			CusLog("..Killing qlubu");
			getModifyChar("3k_main_template_historical_lu_bu_hero_fire"):kill_character(false);
			cm:trigger_incident(getPlayerFaction(), "3k_lua_lu_bu_executed",true)
		end
	end
		RegisterCheZhou()
end
--TODO add Lu lingqi
local function LuBusCaptureExecuteALL() -- only possible to have 1 dilemma per turn... makes this hard to chose executions
	CusLog("Begin LuBusCaptureExecuteALL")
	local qzhangliao = cm:query_model():character_for_template("3k_main_template_historical_zhang_liao_hero_metal")
 
	if not qzhangliao:is_null_interface() then 
		if not qzhangliao:faction():is_human() then 
			CusLog("..Killing qzhangliao");
			getModifyChar("3k_main_template_historical_zhang_liao_hero_metal"):kill_character(false);
			cm:trigger_incident(getPlayerFaction(), "3k_lua_zhang_liao_executed",true)
		elseif qzhangliao:is_character_is_faction_recruitment_pool() then 
			getModifyChar("3k_main_template_historical_zhang_liao_hero_metal"):kill_character(false);
			cm:trigger_incident(getPlayerFaction(), "3k_lua_zhang_liao_executed",true)
		end
	end

	ExecuteHelper()
	CusLog("finished LuBusCaptureExecuteALL")
end
local function LuBusCaptureExecuteException() -- only possible to have 1 dilemma per turn... makes this hard to chose executions
	CusLog("Begin LuBusCaptureExecuteException")
	local qzhangliao = cm:query_model():character_for_template("3k_main_template_historical_zhang_liao_hero_metal")

	if not qzhangliao:is_null_interface() then 
		if not qzhangliao:faction():is_human() then --goofy but for copypaste
			MoveCharToFactionHard("3k_main_template_historical_zhang_liao_hero_metal", "3k_main_faction_cao_cao")
			cm:trigger_incident(getPlayerFaction(), "3k_lua_zhang_liao_hired",true)
		elseif qzhangliao:is_character_is_faction_recruitment_pool() then 
			MoveCharToFactionHard("3k_main_template_historical_zhang_liao_hero_metal", "3k_main_faction_cao_cao")
			cm:trigger_incident(getPlayerFaction(), "3k_lua_zhang_liao_hired",true)
		end
	end

	ExecuteHelper()
	
	CusLog("End LuBusCaptureExecuteException")
end
local function LuBusCaptureSpared() -- only possible to have 1 dilemma per turn... makes this hard to chose executions
	CusLog("Begin LuBusCaptureSpared")
	local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
	local qzhangliao = cm:query_model():character_for_template("3k_main_template_historical_zhang_liao_hero_metal")
    local qdiaochan = cm:query_model():character_for_template("3k_main_template_historical_lady_diao_chan_hero_water")
    local qgaoshun = cm:query_model():character_for_template("3k_main_template_historical_gao_shun_hero_fire")
	local qchengong = cm:query_model():character_for_template("3k_main_template_historical_chen_gong_hero_water")
 
	if not qzhangliao:is_null_interface() then 
		if not qzhangliao:faction():is_human() then --goofy but for copypaste
			MoveCharToFactionHard("3k_main_template_historical_zhang_liao_hero_metal", "3k_main_faction_cao_cao")
		end
	end

	if not qdiaochan:is_null_interface() then 
		if not qdiaochan:faction():is_human() then 
			CusLog("..moving qdiaochan");
			MoveCharToFactionHard("3k_main_template_historical_lady_diao_chan_hero_water", "3k_main_faction_cao_cao")
		end
	end
	if not qgaoshun:is_null_interface() then 
		if not qgaoshun:faction():is_human() then 
			CusLog("..moving qgaoshun");
			MoveCharToFactionHard("3k_main_template_historical_gao_shun_hero_fire", "3k_main_faction_cao_cao")
		end
	end
	if not qchengong:is_null_interface() then 
		if not qchengong:faction():is_human() then 
			CusLog("..moving qchengong");
			MoveCharToFactionHard("3k_main_template_historical_chen_gong_hero_water", "3k_main_faction_cao_cao")
		end
	end
	if not qlubu:is_null_interface() then 
		if not qlubu:faction():is_human() then 
			CusLog("..moving qlubu");
			MoveCharToFactionHard("3k_main_template_historical_lu_bu_hero_fire", "3k_main_faction_cao_cao")
		end
	end
	RegisterCheZhou()
	CusLog("End LuBusCaptureSpared")
end

local function YuanShaoAids()
	CusLog("Start YuanShaoAids")
	local yuanShuFaction= cm:query_faction("3k_main_faction_yuan_shu")
	local qlubu=getQChar2("3k_main_template_historical_lu_bu_hero_fire")

	cm:force_declare_war("3k_main_faction_yuan_shu", "3k_main_faction_cao_cao", false);

	local general=FindFreeGeneral("3k_main_faction_yuan_shu")
	local region= FindRandomRegionOwned(qlubu:faction():name())
	if general~= nil then 
		CusLog(" trying to spawn general ")
		local unit_list="3k_main_unit_metal_jian_infantry_captain,3k_main_unit_metal_rapid_tiger_infantry,3k_main_unit_wood_ji_infantry,3k_main_unit_metal_jian_swordguards,3k_main_unit_water_archers"
		SpawnAGeneralInRegion(general, region:name(), unit_list)
	end
	 general=FindFreeGeneral(qlubu:faction():name())  
	if general~= nil then 
		CusLog(" trying to spawn general ")
		local unit_list="3k_main_unit_water_archer_captain,3k_main_unit_wood_spear_guards,3k_main_unit_wood_ji_infantry,3k_dlc05_unit_metal_camp_crushers,3k_main_unit_water_archers"
		SpawnAGeneralInRegion(general, region:name(), unit_list)
	end
	CusLog("give bundle ")
	cm:apply_effect_bundle("3k_custom_payload_given_army",qlubu:faction():name(),4);
	cm:modify_faction(qlubu:faction():name()):increase_treasury(1800)

	--Need Military Access
	ForceADeal("3k_main_faction_lu_bu", "3k_main_faction_yuan_shu", "data_defined_situation_military_access")
	
	--Should force vassalizaion, then war again on Cao Cao and Liu Bei (IF we had it)
	CusLog("!!!!...Read me")

	cm:set_saved_value("carriage_madeit",true)
	CusLog("End YuanShaoAids")
end

local function TryMarriage()
	CusLog("Start TryMarriage")
	local yuanShuFaction= cm:query_faction("3k_main_faction_yuan_shu")
	local yuanYao= getQChar2("3k_main_template_historical_yuan_yao_hero_earth")
	local mtululingqi= getQChar2("3k_mtu_template_historical_lady_lu_ji_hero_wood")
	local lulingqi= getQChar2("3k_dlc05_template_historical_lu_lingqi_hero_metal")
	local qlubu=getQChar2("3k_main_template_historical_lu_bu_hero_fire")
	local realLuLingqi=lulingqi;
	local triggered=false;
	CusLog("TestNulls")
	if yuanYao ~= nil then 
		if mtululingqi ~=nil then 
			realLuLingqi=mtululingqi;
		end
		if mtululingqi~=nil and lulingqi~=nil then 
			CusLog("yeah somehow both alive, going with MTU ")
		end
		if realLuLingqi==null then 
			return false
		end
		if yuanYao:is_dead() or realLuLingqi:is_dead() then 
			return false;
		end
		
		if (realLuLingqi:faction():name() == qlubu:faction():name() or realLuLingqi:faction():name() == "3k_main_faction_han_empire") and yuanYao:faction():name()=="3k_main_faction_yuan_shu" then 
			if yuanShuFaction:is_human() then --Dilemma where you marry lubus daughter, and you vassal him or confederate
				cm:modify_faction("3k_main_faction_yuan_shu"):increase_treasury(500)--money for event 
				if realLuLingqi:generation_template_key()=="3k_main_template_historical_lady_lu_ji_hero_wood" then 
					CusLog("Vanilla")
					triggered=cm:trigger_dilemma("3k_main_faction_yuan_shu", "3k_lua_yuanshu_helps_lubu_dilemma", true)
				else
					CusLog("MTU") 
					CusLog("(realLuLingqi:faction():name()="..tostring((realLuLingqi:faction():name())))
					triggered=cm:trigger_dilemma("3k_main_faction_yuan_shu", "3k_mtu_yuanshu_helps_lubu_dilemma", true)
				end
			elseif  qlubu:faction():is_human() then --Dilemma where you marry lubus daughter, and you vassal ?
				if realLuLingqi:generation_template_key()=="3k_main_template_historical_lady_lu_ji_hero_wood" then 
					triggered=cm:trigger_dilemma(qlubu:faction():name(), "3k_mtu_yuanshu_helps_lubu_dilemma", true)
				else
					triggered=cm:trigger_dilemma(qlubu:faction():name(), "3k_lua_yuanshu_helps_lubu_dilemma", true)
				end
			end
		else 
			CusLog("chosen faction="..tostring(realLuLingqi:faction():name()))
			CusLog("yuanYao faction="..tostring(yuanYao:faction():name()))
		end
	end
	CusLog("END TryMarriage="..tostring(triggered))
	return triggered;
end

local function ChenDengTakesCity(qlubu)
	CusLog("Begin ChenDengTakesCity")
	local LubuFactionName= qlubu:faction():name()
	CusLog("lubu factionmae is good"..LubuFactionName)
	CusLog("RegionNames"..XIAPICITY)
	CusLog("RegionNames"..PENGCHENGFARM)
	local region1= cm:query_region(XIAPICITY) -- likely 
	local region3= cm:query_region(PENGCHENGFARM) --liubei probably has 
	local region2= cm:query_region("3k_main_langye_capital") --probably abandoned 
	local region4= cm:query_region(DONGIRONMINE) --maybe abandoned
	
	CusLog("1")
	if not region1:is_null_interface() and not region2:is_null_interface() and not region3:is_null_interface() and not region4:is_null_interface()  then 
		if region1:owning_faction():name() == LubuFactionName then
			cm:modify_model():get_modify_region(region1):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_guangling"))
			CusLog("End ChenDengTakesCity1")
			return true;
		elseif region2:owning_faction():name() == LubuFactionName  then
			cm:modify_model():get_modify_region(region2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_guangling"))
			CusLog("End ChenDengTakesCity2")
			return true;
		elseif region3:owning_faction():name() == LubuFactionName then
			cm:modify_model():get_modify_region(region3):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_guangling"))
			CusLog("End ChenDengTakesCity3")
			return true;
		elseif region4:owning_faction():name() == LubuFactionName then
			cm:modify_model():get_modify_region(region4):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_guangling"))
			CusLog("End ChenDengTakesCity3")
			return true;
		end
	else
		CusLog("~!!!!!!!!Check the globals, somethings null")
	end 
	CusLog("2")
	cm:modify_faction("3k_main_faction_guangling"):increase_treasury(9500)--funds to attack lubu 
	cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", "3k_main_faction_guangling" , 24)  
	CusLog("We fell through... executing random fail safe")
	--Fall thru fail safe , give a random region
	local qfaction = qlubu:faction();
	if qfaction:region_list() then
		CusLog(qfaction:name().." Provinces Owned="..qfaction:faction_province_list():num_items())
		for i = 0, qfaction:faction_province_list():num_items() - 1 do -- Go through each Province
			local province_key = qfaction:faction_province_list():item_at(i);
			-- CusLog("$looking at Province #:"..tostring(i).."  ="..tostring(province_key))
			for i = 0, province_key:region_list():num_items() - 1 do -- Go through each region in that province
				-- CusLog("$$looping: x" ..tostring(i))
				local region_key = province_key:region_list():item_at(i);
				if(not region_key:is_null_interface()) then 
					cm:modify_model():get_modify_region(region_key):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_guangling"))
					CusLog("End ChenDengTakesCity random")
					return true;
				end
			end	
		end
	end
	
	
	CusLog("End ChenDengTakesCity = fail")
	return false;
end

local function LuBuDire() -- sort of a fall back 
	  CusLog("Begin LuBu Dire ")
	  local qlubu=getQChar("3k_main_template_historical_lu_bu_hero_fire")
	  local caocaoFaction= cm:query_faction("3k_main_faction_cao_cao")
	  local yuanShuFaction= cm:query_faction("3k_main_faction_yuan_shu")
	  
	  if qlubu:is_null_interface() or caocaoFaction:is_null_interface() or yuanShuFaction:is_null_interface() then 
		CusLog("somethings null")
		return false
	  end
	 -- MakeDeployable("3k_main_template_historical_lu_bu_hero_fire") -- so AI doesnt execute?  --CRASHES

	if caocaoFaction:is_human() then --Capture and keep/execute the faction 
		cm:trigger_dilemma("3k_main_faction_cao_cao", "3k_lua_cao_captures_lubu_dilemma", true) --TODO
	elseif qlubu:faction():is_human() then --Try to send daughter to yuan shu (add some RNG success)
		cm:trigger_dilemma(qlubu:faction():name(), "3k_lua_lubu_surrounded_dilemma", true) --TODO
	elseif yuanShuFaction:is_human() then --Dilemma where you marry lubus daughter, and you vassal him or confederate
		cm:trigger_dilemma("3k_main_faction_yuan_shu", "3k_lua_yuanshu_helps_lubu_dilemma", true)
	end
	  
	 CusLog("Finished LuBu Dire ")
end
local function CaoCaoTakesLiuBei()
	CusLog("Begin CaoCaoTakesLiuBei")
	local qCaoCao_Faction=cm:query_faction("3k_main_faction_cao_cao")
	local qLiuBei_Faction=cm:query_faction("3k_main_faction_liu_bei")
	local qlubu=getQChar("3k_main_template_historical_lu_bu_hero_fire")
	--vassal_liberation

	cm:force_declare_war(qlubu:faction():name(), "3k_main_faction_liu_bei", true)
	cm:force_declare_war("3k_main_faction_liu_bei", qlubu:faction():name(), true)
	--CusLog("forcing peace..")
	cm:apply_automatic_deal_between_factions("3k_main_faction_liu_bei",qlubu:faction():name(), "data_defined_situation_proposer_declares_war_against_target", true);
	cm:apply_automatic_deal_between_factions(qlubu:faction():name(), "3k_main_faction_liu_bei", "data_defined_situation_proposer_declares_war_against_target", true);

	VassalizeSomeone("3k_main_faction_cao_cao", "3k_main_faction_liu_bei")
	--cm:apply_automatic_deal_between_factions("3k_main_faction_cao_cao", "3k_main_faction_liu_bei", "data_defined_situation_vassalise_recipient_forced", false);
	
	--Give liuBei Chen Farm, or something else of CaoCaos (pengcheng temple, or dong)
	local region1= cm:query_region(PENGCHENGTEMPLE)
	local region2= cm:query_region("3k_main_chenjun_resource_1") -- liuChong...
	local region3= cm:query_region(DONGIRONMINE)
	local region4= cm:query_region(PUYANG)
	
	if not region1:is_null_interface() and not region2:is_null_interface() and not region3:is_null_interface() and not region4:is_null_interface()  then 
	
		if region1:owning_faction():name() == "3k_main_faction_cao_cao" then
			cm:modify_model():get_modify_region(region1):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))
		elseif region2:owning_faction():name() == "3k_main_faction_cao_cao"  then
			cm:modify_model():get_modify_region(region2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))
		elseif region3:owning_faction():name() == "3k_main_faction_cao_cao" then
			cm:modify_model():get_modify_region(region3):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))
		elseif region4:owning_faction():name() == "3k_main_faction_cao_cao" then
			cm:modify_model():get_modify_region(region4):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))
		end
	else
		CusLog("~!!!!!!!!Check the globals, somethings null")
	end 
		
	--CaoCao Declares war LuBu
	 campaign_manager:force_declare_war("3k_main_faction_cao_cao", qlubu:faction():name(), false)
     cm:apply_automatic_deal_between_factions("3k_main_faction_cao_cao",qlubu:faction():name(), "data_defined_situation_war",true) 
 
	--LiuBei Declares war again LuBu
	 campaign_manager:force_declare_war("3k_main_faction_liu_bei", qlubu:faction():name(), false)
     cm:apply_automatic_deal_between_factions("3k_main_faction_liu_bei",qlubu:faction():name(), "data_defined_situation_war",true) 
	 campaign_manager:force_declare_war(qlubu:faction():name(),"3k_main_faction_liu_bei", false)

		if not qLiuBei_Faction:is_human() then 
			cm:modify_faction(qLiuBei_Faction:name()):increase_treasury(3500)--funds to attack lubu 
			CleanOfficerList("3k_main_faction_liu_bei")--only want good officers showing up 
		end
		
		if not qCaoCao_Faction:is_human() then 
			cm:set_saved_value("caocao_buffed_turnlimit", cm:query_model():turn_number() +10)
			--Should have cao Cao make peace w others:
			if not qCaoCao_Faction:factions_we_have_specified_diplomatic_deal_with("treaty_components_war"):is_empty()  then 
				for i=0, qCaoCao_Faction:factions_we_have_specified_diplomatic_deal_with("treaty_components_war"):num_items()-1 do
				local WarTarget = qCaoCao_Faction:factions_we_have_specified_diplomatic_deal_with("treaty_components_war"):item_at(i)
					if WarTarget:name() ~= qlubu:faction():name() then 
						CusLog("forcing peace for Cao Cao and "..tostring(WarTarget:name()))
						cm:apply_automatic_deal_between_factions("3k_main_faction_cao_cao", WarTarget:name(), "data_defined_situation_proposer_declares_peace_against_target", true);
						cm:apply_automatic_deal_between_factions(WarTarget:name(), "3k_main_faction_cao_cao", "data_defined_situation_proposer_declares_peace_against_target", true);
					end
				end
			end
			CleanOfficerList("3k_main_faction_cao_cao")--only want good officers showing up 
		end
		if not qlubu:faction():is_human() then 
			CleanOfficerList(qlubu:faction():name())--only want good officers showing up 
		end
		cm:modify_faction("3k_main_faction_guangling"):increase_treasury(3500)--funds to attack lubu 
		cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", "3k_main_faction_guangling" , 2)  
	CusLog("End CaoCaoTakesLiuBei")
end 
local function ZhangFeiHorses() 
	CusLog("Begin ZhangFeiHorses")
	
	local qCaoCao_Faction=cm:query_faction("3k_main_faction_cao_cao")
	local qLiuBei_Faction=cm:query_faction("3k_main_faction_liu_bei")
	local qlubu=getQChar("3k_main_template_historical_lu_bu_hero_fire")
	
	CusLog("THis might not be finishing, CHECK~~!!")
	local triggered =cm:trigger_incident(getPlayerFaction(),"3k_lua_global_zhangfei_steals_horses", true ) 	
	CusLog("TriggeredZhangfeiHorses="..tostring(triggered))
	--War Declared between liu bei and Lu Bu 
	 campaign_manager:force_declare_war(qlubu:faction():name(), "3k_main_faction_liu_bei", false)
     cm:apply_automatic_deal_between_factions(qlubu:faction():name(),"3k_main_faction_liu_bei", "data_defined_situation_war",true) 
 

	if triggered and qCaoCao_Faction:is_human() then 
		cm:trigger_dilemma("3k_main_faction_cao_cao", "3k_lua_caocao_takes_liubei_dilemma",true)--ToDo
	elseif triggered and  qLiuBei_Faction:is_human() then 
		cm:trigger_dilemma("3k_main_faction_cao_cao", "3k_lua_liubei_flees_caocao_dilemma",true)--ToDo
	else
		CaoCaoTakesLiuBei();
	end 
	
	CusLog("End ZhangFeiHorses")

	return triggered;
end 


local function StealXuCity() 
	CusLog("Running StealXuCity")
	  local qlubu=getQChar("3k_main_template_historical_lu_bu_hero_fire")
				
	--Maybe we do some Diplo here ,Seems like too much for the db targets to handle 
	local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
    if cm:query_faction(qlubu:faction():name()):has_specified_diplomatic_deal_with("treaty_components_vassalage",qliubei_faction) then
        CusLog("..we are vassal, must undo")
        cm:apply_automatic_deal_between_factions("3k_main_faction_liu_bei",qlubu:faction():name(), "data_defined_situation_support_independence_offer",true)
        CusLog("...Independence")
        cm:apply_automatic_deal_between_factions(qlubu:faction():name(),"3k_main_faction_liu_bei", "data_defined_situation_vassal_declares_independence",true)
        CusLog("...Might need to declare war")
		if cm:query_faction(qlubu:faction():name()):has_specified_diplomatic_deal_with("treaty_components_vassalage",qliubei_faction) then
			CusLog("...still a vassal..fuck")
			campaign_manager:force_declare_war("3k_main_faction_liu_bei", qlubu:faction():name(), false)
			cm:apply_automatic_deal_between_factions(qlubu:faction():name(),"3k_main_faction_liu_bei", "data_defined_situation_war",true) 
			CusLog("..idk throw my thang down flip it and reverse it..")
			cm:apply_automatic_deal_between_factions("3k_main_faction_liu_bei",qlubu:faction():name(), "data_defined_situation_vassal_declares_independence",true)
		end
	end
	--Another fail safe
	if cm:query_faction(qlubu:faction():name()):has_specified_diplomatic_deal_with("treaty_components_war",qliubei_faction) then
        cm:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", qlubu:faction():name(), "data_defined_situation_proposer_declares_peace_against_target", true);
        CusLog("...peace1")
        cm:apply_automatic_deal_between_factions(qlubu:faction():name(), "3k_main_faction_liu_bei", "data_defined_situation_peace", true);
    end
	--Try to vassalize chendeng
	CusLog("CARE! Says we vassal chen deng but next turn liu bei and lubu both overlords Need to do some indpedence first")
	local qFaction=cm:query_faction("3k_main_faction_guangling")
	if not qFaction:is_null_interface() then 
		if not qFaction:is_dead() then 
			if cm:query_faction("3k_main_faction_guangling"):has_specified_diplomatic_deal_with("treaty_components_vassalage",qliubei_faction) then
				cm:apply_automatic_deal_between_factions("3k_main_faction_guangling","3k_main_faction_liu_bei", "data_defined_situation_war",true) 
				CusLog("..independence for chengui!..")
				cm:apply_automatic_deal_between_factions("3k_main_faction_liu_bei","3k_main_faction_guangling", "data_defined_situation_vassal_declares_independence",true)
				CusLog("forcing war..")
				cm:force_declare_war("3k_main_faction_guangling", "3k_main_faction_liu_bei", true)
				cm:apply_automatic_deal_between_factions("3k_main_faction_guangling", "3k_main_faction_liu_bei", "data_defined_situation_proposer_declares_peace_against_target", true);
				
			end
			if cm:query_faction(qlubu:faction():name()):has_specified_diplomatic_deal_with("treaty_components_war",qFaction) then
				cm:apply_automatic_deal_between_factions("3k_main_faction_guangling", qlubu:faction():name(), "data_defined_situation_proposer_declares_peace_against_target", true);
				CusLog("...peace1")
				cm:apply_automatic_deal_between_factions(qlubu:faction():name(), "3k_main_faction_guangling", "data_defined_situation_peace", true);
			end

		end
		--Vassalize 
		 cm:apply_automatic_deal_between_factions(qlubu:faction():name(), "3k_main_faction_guangling", "data_defined_situation_vassalise_recipient_forced", false)
		CusLog("vassalized the chens")
	end
	CusLog("XIAPICITY= "..tostring(XIAPICITY))
	CusLog("PENGCHENGFARM= "..tostring(PENGCHENGFARM))
	-- Take region if liu bei owns it 
	local desired_region= cm:query_region(XIAPICITY) 
	if(desired_region:owning_faction():name() == "3k_main_faction_liu_bei") then 
		CusLog("--Want to Transfer Region--" )
        cm:modify_model():get_modify_region(desired_region):settlement_gifted_as_if_by_payload(cm:modify_faction(qlubu:faction():name()))
       CusLog("--transferred Region--")
	else
		CusLog("..Not sure how this would even happen.. liu bei didnt own city, but zhang fei was guarding?")
	end
	desired_region= cm:query_region(PENGCHENGFARM) 
	if(desired_region:owning_faction():name() == "3k_main_faction_liu_bei") then 
		CusLog("--Want to Transfer Region--" )
        cm:modify_model():get_modify_region(desired_region):settlement_gifted_as_if_by_payload(cm:modify_faction(qlubu:faction():name()))
       CusLog("--transferred Region--")
	end
	
	CusLog("finished taking regions")
	
	local qliubei_faction= getQFaction("3k_main_faction_liu_bei")
	if qliubei_faction ~=nil then 
		AbandonLands("3k_main_faction_liu_bei") -- will get rid of an regions he had north of XU 
		--Give him donghai fishingport
		CusLog("Giving liu bei the fish port")
		desired_region= cm:query_region(XUFISHPORT) 
		if not desired_region:is_null_interface() then 
			cm:modify_model():get_modify_region(desired_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))
			if not qliubei_faction:is_human() then 
				CleanOfficerList("3k_main_faction_liu_bei")--only want good officers showing up 
				cm:modify_faction(qliubei_faction:name()):increase_treasury(2000)
				CusLog("gave some recovery money to AI liubei")
				--Guess we should teleport his for safety? (but i dont want to TP main force, so ill do manually)
				if not qliubei_faction:military_force_list():is_empty() then -- this is not working..?
					for i=0 , qliubei_faction:military_force_list():num_items() -1 do 
						local m_force= qliubei_faction:military_force_list():item_at(i)
						if(m_force:is_armed_citizenry()) then        --if(qgeneral:is_armed_citizenry()) then  -_Error here --has_garrison_residence
							CusLog("..found a garrison, break..")
						else
							local commander= m_force:character_list():item_at(0) 
							if commander:generation_template_key() ~="3k_main_template_historical_liu_bei_hero_earth" then 
								CusLog("..Teleporting Commander: "..tostring(commander:generation_template_key()))
								local found_pos, x, y = qliubei_faction:get_valid_spawn_location_in_region(XUFISHPORT, false);
								local randomness1 = math.floor(cm:random_number(-4, 4 ));
								local randomness2 = math.floor(cm:random_number(-4, 4 ));
								cm:modify_model():get_modify_character(commander):teleport_to(x+randomness1,y-randomness2) 
							end
						end
					end
				end
			end
		else
			CusLog("fishport region is null??")
		end
   end
	
   if not qlubu:faction():is_human() and qlubu:has_military_force() then 
		CusLog("..Teleporting qlubu: "..tostring(qlubu:generation_template_key()))
		local found_pos, x, y = qlubu:faction():get_valid_spawn_location_in_region(XIAPICITY, false);
		local randomness1 = math.floor(cm:random_number(-3, 3 ));
		local randomness2 = math.floor(cm:random_number(-3, 3 ));
		cm:modify_model():get_modify_character(qlubu):teleport_to(x+randomness1,y-randomness2) 
   end


	if( qliubei_faction:is_human()) then 
		cm:trigger_incident(qliubei_faction, "3k_lua_liubei_notifed_lubu_rebelled", true ) --ToDo, can the event declare independence? check how vanilla does it
	else 
		local playersFactionsTable = cm:get_human_factions()
		local playerFaction = playersFactionsTable[1]
		local triggered =cm:trigger_incident(playerFaction,"3k_lua_global_lubu_steals_city", true ) --relationships worsens check	
	end
	
	if not qlubu:faction():is_human() then --start to debuff him 
		CleanOfficerList(qlubu:faction():name())
		cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua_lite", qlubu:faction():name() , 12)
	end
	
	CusLog("bringing ZhangBa Back, cap on spawn year is 197")
	--Do this Again , maybe this would be the better time to do this actually ?idk
	register_zangba_emergent_faction_2()
	cm:set_saved_value("zangbaSpawned",false)
	cm:set_saved_value("Spawnzangba",true)
	CusLog("..check effect bundle")
	cm:modify_faction(qlubu:faction()):apply_effect_bundle("3k_dlc05_introduction_mission_bundle_lu_bu",3)
	cm:apply_effect_bundle("3k_main_introduction_mission_payload_recruit_units", qlubu:faction():name() , 3) -- growing might?
  
	--Should do growing might bundle instead??
	cm:set_saved_value("lubu_stole_city",true) --Set something up for yuan shu 
	CusLog("Finished StealXuCity")
end

local function LuBuBetraysCheck() --190 only 
	CusLog("Running LuBuBetraysCheck")
	  local qlubu=getQChar("3k_main_template_historical_lu_bu_hero_fire")
	  
	  if qlubu:faction():name() ~= " 3k_main_faction_lu_bu" then  --190 only
		  --190 dilemma only 
		  if qlubu:faction():is_human() then 
				--Trigger a dilemma 
				LuBuBetraysChoiceMadeListener() -- make sure listener is on
				cm:trigger_dilemma(qlubu:faction(), "3k_lua_190lubu_betrays_liubei_dilemma",true)
		  elseif not qlubu:faction():is_human() then 
				--Make LuBu declare independence 
				StealXuCity() -- incidents handled here 
		  end
	end
		cm:set_saved_value("lu_bu_takes_city",false) --stop previous listener
		CusLog("Finished LuBuBetraysCheck")

end


function ZhangFeiDrunkEvent()
	CusLog("Begin ZhangFeiDrunkEvent")
	local playersFactionsTable = cm:get_human_factions()
	local playerFaction = playersFactionsTable[1]
	local triggered =cm:trigger_incident(playerFaction,"3k_lua_zhang_fei_drunk_incident", true ) --relationships worsens check	
	--event is generic 
	if triggered then
		cm:set_saved_value("lu_bu_zhang_fei_incident",false); --Turn off AI fail safe 
		cm:set_saved_value("lu_bu_takes_city",true) 
	else
		CusLog("@@!..Something went wrong with incident firing")
	end
	CusLog("End ZhangFeiDrunkEvent="..tostring(triggered))
	return triggered;
end

function SetUpBeefFailSafe() --Methods a really ghetto FailSafe
	CusLog("Running SetUpBeefFailSafe")
	if cm:get_saved_value("beef_ran")~=true then 
		local qzhangfei= getQChar("3k_main_template_historical_zhang_fei_hero_fire")
		if not qzhangfei:faction():is_human() then 
			--Spawn army via existing char in XiapPi 
			CusLog("hope we can call this across scripts")--CaoCao plot 2
			MoveLiuBeisArmy()
		end
		
		cm:set_saved_value("beef_ran",true)
	end
	CusLog("Finished SetUpBeefFailSafe")
end

local function CheckLiuBeiOwnsXiaPi()
	CusLog("Begin CheckLiuBeiOwnsXiaPi")
	local returnVal=false;
	local qregion=cm:query_region(XIAPICITY)
	if not qregion:is_null_interface() then 
		if qregion:owning_faction()=="3k_main_faction_liu_bei" then 
			returnVal= true;
		elseif not qregion:owning_faction():is_human() then --Should never really happen...would be pretty odd if zhangfei was there but liubei didnt own
			cm:modify_model():get_modify_region(qregion):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))
			returnVal=true;
		end
	end
		
		
	CusLog("End CheckLiuBeiOwnsXiaPi returning="..tostring(returnVal))
	return returnVal;
end

local function confirmSaving() --Used By Player and AI
	CusLog("Begin confirmSaving ")
	local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire") -- not null from before 
    local qlubu_faction = qlubu:faction();
	
	local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")

    local qcaocao = cm:query_model():character_for_template("3k_main_template_historical_cao_cao_hero_earth")
    if(qcaocao:is_faction_leader()) then 
        CusLog("cao cao is leader, lets give him lu bus land")
       -- should check if they have war?
         -- we know its not null from before
         if qlubu_faction:region_list() then
            for i = 0, qlubu_faction:faction_province_list():num_items() - 1 do
                local province_key = qlubu_faction:faction_province_list():item_at(i);
                for i = 0, province_key:region_list():num_items() - 1 do
                    local region_key = province_key:region_list():item_at(i);
                    local region_name = region_key:name()
                    CusLog("region_name::"..tostring(region_name))
                     cm:modify_model():get_modify_region(region_key):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_cao_cao"))
                      CusLog("--LuBu gives: " .. region_name .. " to cao cao")
                 end	
             end
         end
    else -- Cao Cao is not leader
        --Get rid of his old regions  / make deserted 
         -- we know its not null from before
         if qlubu_faction:region_list() then
            for i = 0, qlubu_faction:faction_province_list():num_items() - 1 do
                local province_key = qlubu_faction:faction_province_list():item_at(i);
                for i = 0, province_key:region_list():num_items() - 1 do
                    local region_key = province_key:region_list():item_at(i);
                    local region_name = region_key:name()
                    cm:modify_region(region_name):raze_and_abandon_settlement_without_attacking(); -- does this work? name vs key? it did before
                    CusLog("--LuBu Abandons: " .. region_name)
                 end	
             end
        end
    end
   
                     
     -- Move to liu Beis lands 
    local given_region=  cm:get_saved_value("gift_region");
    local qregion =cm:query_region(given_region)
                                                  
    CusLog("Name = " .. tostring(given_region))
    CusLog("Region to gift = " .. tostring(qregion:name()))
    -- getting lazy not going to check anything should be if weve gotten to here
    cm:modify_model():get_modify_region(qregion):settlement_gifted_as_if_by_payload(cm:modify_faction(qlubu_faction:name()))
     CusLog("Clear Wars")        
   
	 if qlubu_faction:has_specified_diplomatic_deal_with("treaty_components_war",qcaocao:faction()) then 
    	-- need peace becuz vassal buggs sometimes 
   		 cm:modify_faction(qlubu_faction):apply_automatic_diplomatic_deal("data_defined_situation_peace", qcaocao:faction(), ""); 
		cm:apply_automatic_deal_between_factions(qlubu_faction:name(), qcaocao:faction():name(), "data_defined_situation_proposer_declares_peace_against_target", true);
		cm:apply_automatic_deal_between_factions(qcaocao:faction():name(), qlubu_faction:name(), "data_defined_situation_proposer_declares_peace_against_target", true);
	end
	-- should loop though all of Lu Bus wars and end them manually to avoid bugs (?ToDo)

    --check if liu bei has war w lu bu
	if qlubu_faction:has_specified_diplomatic_deal_with("treaty_components_war",qliubei_faction) then 
		cm:modify_faction(qlubu_faction):apply_automatic_diplomatic_deal("data_defined_situation_peace", qliubei_faction, "");   
		cm:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", qlubu_faction:name(), "data_defined_situation_proposer_declares_peace_against_target", true);
		cm:apply_automatic_deal_between_factions(qlubu_faction:name(), "3k_main_faction_liu_bei", "data_defined_situation_proposer_declares_peace_against_target", true);
		-- If we have war, the event probably didnt work...
		-- cm:modify_faction(qliubei_faction):apply_automatic_diplomatic_deal("data_defined_situation_vassalise_recipient_forced", qlubu_faction, ""); 
		CusLog("!!..LiuBei and LuBu had war, tried to force fix..")
	end
	CusLog("make a vassal")      
	cm:modify_faction(qliubei_faction):apply_automatic_diplomatic_deal("data_defined_situation_vassalise_recipient_forced", qlubu_faction, ""); 
	
	--Apply buff to faction 
	 cm:modify_model():get_modify_faction(qlubu_faction):apply_effect_bundle("3k_dlc04_effect_bundle_free_force",2) --Change to the AI Liu Bei one
   
	
	if qlubu_faction:is_human() ==false then 
        -- move lu bus army (only will work if AI)
        local lubu = cm:query_model():character_for_template("3k_main_template_historical_lu_bu_hero_fire")
        if not lubu:is_null_interface() then
            CusLog("LuBu is not null")
            --Tells us if he is deployed
             if lubu:has_military_force() == true then 
                CusLog("LuBu has military Force , teleport") -- Only works for AI
				cm:modify_model():get_modify_character(lubu):teleport_to(560,452)
				cm:modify_faction(qlubu_faction:name()):increase_treasury(1000)
                --cm:modify_model():get_modify_character(lubu):teleport_to(500,450) -- this is CHEN City
             else
                CusLog("no military Force, giving Money")
				cm:modify_faction(qlubu_faction:name()):increase_treasury(10000) -- to redeploy
             end
        end
	end


	--If AI liu bei doesnt own the fishing port, give it to him
	if not qliubei_faction:is_human() then 
		local fishport= cm:query_region("3k_main_donghai_resource_1")
		if fishport:owning_faction():name() ~= "3k_main_faction_liu_bei" and not fishport:owning_faction():is_human() then 
			CusLog("..transfer fishport to liubei")
			cm:modify_model():get_modify_region(fishport):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))
		end
	end

	
	cm:set_saved_value("lubu_saved",true)
	cm:set_saved_value("lu_bu_zhang_fei_incident", true)

	CusLog(" Finished ConfirmSaving")
end

local function saveLubu()
    CusLog("Saving lubu")

	local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire") -- not null from before 
    local qlubu_faction = qlubu:faction();
	local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
	
	if qlubu_faction:is_human() then
		-- trigger dilemma (write custom) ToDo
		CusLog("..lubus human, fire dil:")
		--LuBuSavedChoiceMadeListener() -- maybe i cant see this cuz its below me?
		cm:trigger_dilemma(qlubu_faction, "3k_lua_lubu_flee_liubei_dilemma", true)
	elseif qliubei_faction:is_human() then
		--trigger dilemma for liu bei  ToDo
		CusLog("..liubei human, fire dil:")
		LiuBeiSavedChoiceMadeListener()
		cm:trigger_dilemma(qliubei_faction, "3k_lua_liu_bei_takes_lubu_dilemma", true) -- what if its 194 start date? Liu bei can vassalize here, and if fully destroyed get LuBu byhimself? What if u annex him? lol get same event?
	else
		-- go thru with it
		CusLog("..Send the ai lu bu to ai liu bei:")
		confirmSaving()
		--Fire an Event 
		local playersFactionsTable = cm:get_human_factions()
		local playerFaction = playersFactionsTable[1]
		cm:trigger_incident(playerFaction,"3k_main_custom_ai_liu_bei_takes_in_lu_bu", true ) --relationships deepens check	
	end
	
	CusLog("Finished Saving lubu")
end


local function AiFailSafe()
		CusLog("attempting AiFailSafe")
	  -- give liu bei the right region
	 local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")

	if not qliubei_faction:is_human() then 
		--set up pengcheng
		local pengcheng_region =cm:query_region(XIAOPEICITY)
		local pengcheng_region2 =cm:query_region("3k_main_penchang_resource_2")
		if not pengcheng_region:owning_faction():is_human() then 
			cm:modify_model():get_modify_region(pengcheng_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))
			CusLog("--transferred pengcheng_region--")
		end
		if not pengcheng_region2:owning_faction():is_human() then 
			cm:modify_model():get_modify_region(pengcheng_region2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))
			CusLog("--transferred pengcheng_region2--")
		end
		
	end
	CusLog("Finished AiFailSafe")
end

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-------------------------Function/listener split----------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

local function LubuRedhareListener() 
	CusLog("### LubuRedhareListener loading ###")
	core:remove_listener("LubuRedhare");
	core:add_listener(
		"LubuRedhare",
		"PendingBattle", -- CampaignBattleLoggedEvent better than  PendingBattle ? even tho CA still checks : has_been_fought()?
		function(context) --Seems like CampaignBattleLoggedEvent gets pb from query_model and thats just confusing so ima leave this
			--CusLog("Checking If LuBus LubuRedhareListener")
			local pb=context:query_model():pending_battle();
			local defender= pb:defender(); -- a qchar
			local attacker= pb:attacker();
			local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
			if qlubu:is_null_interface() then 
					return false;
			elseif not qlubu:is_dead() then 
					return false;
			elseif pb:has_been_fought() and qlubu:faction():is_human() then --Only take the horse after for the player.(would do for AI too but thats alot of calls)
				if not (pb:has_attacker() and pb:has_defender()) then 
					CusLog("Does this battle have an attacker/defender?")
					CusLog("Attacker= "..tostring(pb:has_attacker()))
					CusLog("Defender= "..tostring(pb:has_defender()))
					return false;
				end
				--CusLog("attacker:faction():name() ="..tostring(attacker:faction():name()))
				--CusLog("defender:faction():name()="..tostring(defender:faction():name()))
				--CusLog("BattlType=="..tostring(pb:battle_type()))
				if defender:faction():name() == qlubu:faction():name() or attacker:faction():name() == qlubu:faction():name() then 
					CusLog("LuBu's Faction is in the battle")
					local redhare_owner= FindAncAccessory("3k_main_ancillary_mount_red_hare", "3k_main_ceo_category_ancillary_mount");
					CusLog("red hare owner="..tostring(redhare_owner))
					if redhare_owner == qlubu:faction():name() then -- have to check everytime because he could lose it periodically
						CusLog("Lu Bu's Faction owns red hare,abort")
						return false
					elseif lubuAttacker and redhare_owner ~= defender:faction():name() then 
						CusLog("Defender Faction does not own red hare")
						return false;
					elseif not lubuAttacker and redhare_owner ~= attacker:faction():name() then 
						CusLog("Attacker Faction does not own red hare")
						return false;
					end;
					CusLog("We are in the right battle with the owning faction of red hare!")
					local lubuAttacker=true;
					local lubuCommander=attacker;
					local enemyCommander=defender;
					if defender:faction():name() == qlubu:faction():name() then 
						lubuCommander=defender;
						enemyCommander=attacker;
						lubuAttacker=false;
					end
					if not lubuCommander:has_military_force() then --Idk why he wouldnt? maybe he lost?
						CusLog("Does this happen?")
					end
						CusLog("Get LuBus force, and see if he was in the battle")
						local m_force= lubuCommander:military_force();
						for i=0, m_force:character_list():num_items()-1 do
							CusLog("..in i loop #"..tostring(i))
							local qchar= m_force:character_list():item_at(i)
							if (qchar:generation_template_key() == "3k_main_template_historical_lu_bu_hero_fire") then 
								CusLog("LuBu was in the battle!..Check if enemy general had redhare")
								--enemyCommander -- going to avoid checking if they have mil force, becuz maube this is post battle?? and they were destroyed?
								local m_force2= enemyCommander:military_force();
								for j=0, m_force:character_list():num_items()-1 do
									CusLog("..in j loop #"..tostring(j))
									local qchar2= m_force2:character_list():item_at(j)
									local ceo_manager= qchar2:ceo_management()
									for k=0, ceo_manager:all_ceos_for_category("3k_main_ceo_category_ancillary_mount"):num_items()-1 do
										CusLog("..in k loop #"..tostring(k))
										local ceo= ceo_manager:all_ceos_for_category("3k_main_ceo_category_ancillary_mount"):item_at(k);
											CusLog(qchar2:generation_template_key().." has:"..tostring(ceo:ceo_data_key()).."  category:"..tostring(ceo:category_key()))
										if ceo:ceo_data_key()=="3k_main_ancillary_mount_red_hare" then 
											CusLog("FOUND!!"..qchar2:generation_template_key().." has red hare");
											cm:set_saved_value("redhare_owner",redhare_owner)
											return true;
										end
									end
								end
							end 
						end
					--ok
				end
            end
            return false
        end,
		function()
			CusLog("??? Callback LubuRedhareListener ###")
			local qlubu_faction= getQChar("3k_main_template_historical_lu_bu_hero_fire"):faction():name()
			local modify_faction = cm:modify_faction(cm:get_saved_value("redhare_owner"));
			modify_faction:ceo_management():remove_ceos("3k_main_ancillary_mount_red_hare")
			local qlubu_faction = cm:modify_faction(qlubu_faction);
			modify_faction:ceo_management():add_ceo("3k_main_ancillary_mount_red_hare")
			cm:set_saved_value("redhare_owner",qlubu_faction)
			CusLog("Gave Lu Bu back red hare, trigger incident")
			local triggered= cm:trigger_incident(qlubu_faction,"3k_lua_lubu_takes_horse_back",true)--ToDo
			CusLog("### passed LubuRedhareListener ="..tostring(triggered))
		end,
		false
    )
end


local function LuLingQiRebelsListener() 
	CusLog("### LuLingQiRebelsListener  loading ###")
	core:remove_listener("LuLingQiRebels");
	core:add_listener(
		"LuLingQiRebels",
		"FactionTurnEnd",
		function(context)
           --would crash if kills was null, but wont initialize unless kills ~=nil so we're safe 
		   return context:faction():name()=="3k_main_faction_yuan_shu" and cm:get_saved_value("lulinqi_kills") <= context:query_model():turn_number() 
        end,
		function(context)
			CusLog("??? Callback: LuLingQiRebelsListener callback ###")
			local key=""
			local type=""
			local region=FindRandomRegionOwned("3k_main_faction_yuan_shu")
			if MTU then --Global 
				key="3k_mtu_template_historical_lady_lu_ji_hero_wood"
				type="3k_general_wood"
			else 
				key="3k_dlc05_template_historical_lu_lingqi_hero_metal"
				type="3k_general_metal"
			end 
			cm:set_saved_value("lulingqi_key", key)
			cm:set_saved_value("lulingqi_type", type)
			cm:set_saved_value("LuLingqi_region",region:name())
			cm:set_saved_value("SpawnLuLingqi",true)
			register_LuLingqi_emergent_faction_2()
			cm:set_saved_value("lulinqi_kills", 999);
		end,
		false -- does persist
    )
end

local function YuanShuHireLubuChoiceMadeListener() 
	CusLog("### YuanShuHireLubuChoiceMadeListener loading ###")
	core:remove_listener("YuanShuHireLubu");
    core:add_listener(
    "YuanShuHireLubu",
    "DilemmaChoiceMadeEvent",
    function(context)
		if context:dilemma() == "3k_lua_yuanshu_hires_lubu_dilemma" then 
			cm:set_saved_value("TRY_AGAIN", false)
			cm:set_saved_value("override_tryagain",true)
			return true;
		end
		return false;
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! 3k_lua_yuanshu_hires_lubu_dilemma choice was:" .. tostring(context:choice()))
		cm:set_saved_value("override_tryagain",true)-- Stop that damn follow up failsafe 
		if choice == 0 then
			LuBuJoinsYou("3k_main_faction_yuan_shu")
			--AbandonLands("3k_main_faction_lu_bu") -- he wont have any 
			cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", "3k_main_faction_yuan_shu",1 )--Also get from event. 
			local mlubu=getModifyChar("3k_main_template_historical_lu_bu_hero_fire")
			if not  mlubu:is_null_interface() then --could be if respawned
				mlubu:add_loyalty_effect("lua_loyalty"); -- player needs to quickly given him a court position, this could be false hope
			end
		else 
			LuBusCaptureExecuteException() -- let CaoCao kill him 
			--Lulingqi hates you path, kills you lol
			CusLog("ToDo, lulingqi hates u, start timer till she betrays u(killsU)")
			local rng= math.floor(cm:random_number(2,4)) -- 1 to 4
			cm:set_saved_value("lulinqi_kills", context:query_model():turn_number()+rng);
			LuLingQiRebelsListener()
			--Should add satisfaction debuff to LuLingqi 
			local key=""
			if MTU then --Global 
				key="3k_mtu_template_historical_lady_lu_ji_hero_wood"
			else 
				key="3k_dlc05_template_historical_lu_lingqi_hero_metal"
			end 
			local mqi=getModifyChar(key)
			if not mqi:is_null_interface() then 
				mqi:add_loyalty_effect("faction_leader_died") --epic_failure
			end
			--These dont seem to work?
			ForceADeal("3k_main_faction_cao_cao", "3k_main_faction_yuan_shu", "data_defined_situation_peace")
			ForceADeal("3k_main_faction_cao_cao", "3k_main_faction_yuan_shu", "data_defined_situation_proposer_declares_peace_against_target")	
		end

		RegisterCheZhou()
		
    end,
    false -- does not persist
 );
end
local function YuanShuCarriageChoiceMadeListener() 
	CusLog("### YuanShuCarriageChoiceMadeListener loading ###")
	core:remove_listener("YuanShuCarriageChoiceMade");
    core:add_listener(
    "YuanShuCarriageChoiceMade",
    "DilemmaChoiceMadeEvent",
    function(context)
		local bool= context:dilemma() == ("3k_lua_yuanshu_helps_lubu_dilemma" or "3k_mtu_yuanshu_helps_lubu_dilemma")
		CusLog("Combined="..tostring(bool));
		return bool;
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! 3k_lua_yuanshu_helps_lubu_dilemma choice was:" .. tostring(context:choice()))
		if choice == 0 then
			if context:dilemma()=="3k_lua_yuanshu_helps_lubu_dilemma" then 
				MoveCharToFaction("3k_dlc05_template_historical_lu_lingqi_hero_metal", "3k_main_faction_yuan_shu")
			else 
				MoveCharToFaction("3k_mtu_template_historical_lady_lu_ji_hero_wood", "3k_main_faction_yuan_shu")
			end
			YuanShaoAids()
			YuanShuHireLubuChoiceMadeListener()
        end
    end,
    false -- does not persist
 );
end

local function LuBuCarriageChoiceMadeListener() --TODO
	CusLog("### LuBuCarriageChoiceMadeListener loading ###")
	core:remove_listener("LuBuCarriageChoiceMade");
    core:add_listener(
    "LuBuCarriageChoiceMade",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_lubu_surrounded_dilemma" 
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! 3k_lua_lubu_surrounded_dilemma choice was:" .. tostring(context:choice()))
        if choice == 0 then
           if RNGHelper(3) then 
				-- Spawn Yuan Shus army to help you, your daughter gets married ??
				-- Make Alliance w yuan shu, and have yuan shu war CaoCao?
				
				--Or Maybe have LuBu create an escape force outside the city and reset his movement to run?
				
				-- MAYBE teleport CaoCaos army??
				 local qlubu=getQChar("3k_main_template_historical_lu_bu_hero_fire")
				 cm:trigger_incident(qlubu:faction():name(), "3k_lua_lubu_carriage_makesit", true)--Apply an effect bundle for redeployment/supplies/morale
				 
			else 
				 local qlubu=getQChar("3k_main_template_historical_lu_bu_hero_fire")
				 cm:trigger_incident(qlubu:faction():name(), "3k_lua_lubu_carriage_fails", true)
		   end 
        end
    end,
    false -- does not persist
 );
end

local function CaoCaoExecuteChoiceMadeListener()
	CusLog("### CaoCaoExecuteChoiceMadeListener loading ###")
	core:remove_listener("CaoCaoExecuteChoice");
    core:add_listener(
    "CaoCaoExecuteChoice",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_cao_captures_lubu_dilemma" --choice relationships deepends, faction affinity
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! 3k_lua_cao_captures_lubu_dilemma choice was:" .. tostring(context:choice()))
		--Better would be to Trigger a Dilemma to appoint CheZhou:
		register_CheZhou_emergent_faction_2()
		cm:set_saved_value("SpawnCheZhou",true)
		
		if choice == 0 then
			LuBusCaptureExecuteException()
			--register
		elseif choice ==1  then 
			LuBusCaptureExecuteALL()
		else 
			LuBusCaptureSpared()
        end
    end,
    false -- does not persist
 );
end
local function LuBuBetrayedChenDengListener() 
	CusLog("### LuBuBetrayedChenDengListener loading ###")
	core:remove_listener("LuBuBetrayedChenDeng")
	core:add_listener(
		"LuBuBetrayedChenDeng",
		"IncidentOccuredEvent",
		function(context)
			 return context:incident() == "3k_lua_chens_betray"
		end,
		function(context)
		CusLog("3k_lua_chens_betray occurred")
		cm:set_saved_value("chen_betrays",true)
		local qlubu=getQChar("3k_main_template_historical_lu_bu_hero_fire")
			if ChenDengTakesCity(qlubu) then 
				VassalizeSomeone("3k_main_faction_cao_cao", "3k_main_faction_guangling")
				--ReDeclare war
				cm:force_declare_war("3k_main_faction_guangling", qlubu:faction():name(), false )
			end
		end,
		false
    )
end

local function CaoCaoTakesInLiuBei2Listener() --LiuBei player TODO
	CusLog("### CaoCaoTakesInLiuBei2Listener loading ###")
	core:remove_listener("CaoCaoTakesInLiuBei");
    core:add_listener(
    "CaoCaoTakesInLiuBei",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_liubei_flees_caocao_dilemma" --choice relationships deepends, faction affinity
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! 3k_lua_liubei_flees_caocao_dilemma choice was:" .. tostring(context:choice()))
        if choice == 0 then
            CaoCaoTakesLiuBei()
        end
    end,
    false -- does not persist
 );
end
local function CaoCaoTakesInLiuBeiListener() --CaoCao Player TODO
	CusLog("### CaoCaoTakesInLiuBeiListener loading ###")
	core:remove_listener("CaoCaoTakesInLiuBei");
    core:add_listener(
    "CaoCaoTakesInLiuBei",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_caocao_takes_liubei_dilemma" --choice relationships deepends, faction affinity
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! 3k_lua_caocao_takes_liubei_dilemma choice was:" .. tostring(context:choice()))
        if choice == 0 then
            CaoCaoTakesLiuBei()
        end
    end,
    false -- does not persist
 );
end

--If zhangfei horses didn't happen yet, this will force it.
local function ChenDeng3Listener() -- Have Chens massively betray you (yuanshao confed gonsunzan can also trigger)
	CusLog("### ChenDeng3Listener listener loading ###")
	core:remove_listener("ChenDeng3")
	core:add_listener(
		"ChenDeng3",
		"FactionTurnStart",
		function(context)
			local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
			if not qlubu:is_null_interface() then 
				if context:faction():name()== qlubu:faction():name() and cm:get_saved_value("chen_betrays")~=true then 
					CusLog("ChenDeng3Listener on")
					local qCaoCao_Faction= getQFaction("3k_main_faction_cao_cao")
					if qCaoCao_Faction~=nil and RNGHelper(3) then --RNG 3 --THis could be crashign somehow?
						local chenFaction= getQFaction("3k_main_faction_guangling")
						--("3k_dlc_04_template_historical_chen_gui_water") --3k_dlc04_template_historical_chen_deng_yuanlong_water
						if chenFaction~=nil then 
							local leader=chenFaction:faction_leader();
							if leader:generation_template_key()== ("3k_dlc_04_template_historical_chen_gui_water"  or leader:generation_template_key()== "3k_dlc04_template_historical_chen_deng_yuanlong_water") then 
								if cm:query_faction(qlubu:faction():name()):has_specified_diplomatic_deal_with("treaty_components_war",qCaoCao_Faction) then
									local number= cm:get_saved_value("turns_till_nogifts");
									if number ==nil then 
										number=999;
									end
									if number+2 < context:query_model():turn_number() then --Dont disrupt the YuanShu Plot line 
										if context:faction():is_human() then 
											return cm:get_saved_value("chen_advice2")==true 
										else
											return true
										end
									else 
										CusLog("Waiting on yuan shu plotline")
									end
								end
							end
						end
					end
				end
			end
		return false;
		end,
		function(context)
			CusLog("???Callback: ChenDeng3Listener ###")
			--This event should take XiaPi or another City from LuBu, and apply a faction wide satisfaction hit 
			local triggered =cm:trigger_incident(getPlayerFaction(),"3k_lua_chens_betray", true )
			if triggered and cm:get_saved_value("zhangfei_horses")~=true then 
				CaoCaoTakesInLiuBeiListener()
				CaoCaoTakesInLiuBei2Listener()
				local triggered2=ZhangFeiHorses() --Fires the incident
				cm:set_saved_value("zhangfei_horses",triggered2);
			end
			cm:set_saved_value("chen_betrays",triggered);
			CusLog("###Passed: ChenDeng3Listener ="..tostring(triggered))
		end,
		false
    )
end
local function ChenDeng2Listener() -- Have Them make suggestions to you, at the consequence of loyalty factionwide? 
	CusLog("### ChenDeng2Listener listener loading ###")
	core:remove_listener("ChenDeng2")
	core:add_listener(
		"ChenDeng2",
		"FactionTurnStart",
		function(context)
			local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
			if not qlubu:is_null_interface() and cm:get_saved_value("chen_advice2")~=true then 
				if context:faction():name()== qlubu:faction():name() and qlubu:is_faction_leader() and context:faction():is_human() and RNGHelper(4) then 
					CusLog("chendeng2: can crash?")
					CusLog("COND:"..tostring( (cm:query_faction("3k_main_faction_liu_bei"):has_specified_diplomatic_deal_with("treaty_components_vassalage",context:faction())
					and cm:query_faction("3k_main_faction_guangling"):has_specified_diplomatic_deal_with("treaty_components_vassalage",context:faction()) 
						)))
					return (cm:query_faction("3k_main_faction_liu_bei"):has_specified_diplomatic_deal_with("treaty_components_vassalage",context:faction())
								and cm:query_faction("3k_main_faction_guangling"):has_specified_diplomatic_deal_with("treaty_components_vassalage",context:faction()) 
									)
				end
			end
		return false;
		end,
		function(context)
			CusLog("???Callback: ChenDeng2Listener ###")
			-- Should provide you a HUGE boost to supplies in a Region you own, but at the cost of satisfaction to chen gong 
			cm:trigger_dilemma(context:faction():name(),"3k_lua_chen_advice2",true) -- only mention chendeng even if gui is alive 
			cm:set_saved_value("chen_advice2",true)
			CusLog("###Passed: ChenDeng2Listener ###")
		end,
		false
    )
end
local function ChenDeng1Listener() --Maybe this is an introduction
	CusLog("### ChenDeng1Listener listener loading ###")
	core:remove_listener("ChenDeng1")
	core:add_listener(
		"ChenDeng1",
		"FactionTurnStart",
		function(context)
			local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
			if not qlubu:is_null_interface() and  cm:get_saved_value("chen_advice1")~=true then 
				if context:faction():name()== qlubu:faction():name() and qlubu:is_faction_leader() and context:faction():is_human() then 
					--Can this crash?
					CusLog("chendeng1: can crash?")
					CusLog("Cond:"..tostring(cm:query_faction("3k_main_faction_guangling"):has_specified_diplomatic_deal_with("treaty_components_vassalage",context:faction() )))
					return cm:query_faction("3k_main_faction_guangling"):has_specified_diplomatic_deal_with("treaty_components_vassalage",context:faction() )
				end
			end
		return false;
		end,
		function(context)
			CusLog("???Callback: ChenDeng1Listener ###")
			--Trigger an incident that introduces them to lu bu 
			local playersFactionsTable = cm:get_human_factions()
			local playerFaction = playersFactionsTable[1]
			local chenFaction= getQFaction("3k_main_faction_guangling")
			local triggered=false;
			if not chenFaction:is_null_interface() then 
				local leader=chenFaction:faction_leader();
				if leader:generation_template_key()== "3k_dlc_04_template_historical_chen_gui_water" then 
					triggered =cm:trigger_incident(playerFaction,"3k_lua_lubu_meets_chengui", true )
				elseif leader:generation_template_key()== "3k_dlc04_template_historical_chen_deng_yuanlong_water" then 
					triggered =cm:trigger_incident(playerFaction,"3k_lua_lubu_meets_chendeng", true )
				end
			end
			cm:set_saved_value("chen_advice1",triggered)
			CusLog("###Passed: ChenDeng1Listener ### "..tostring(triggered))
		end,
		false
    )
end



local function ZhangFeiHorseslistener() --If liubei is a vassal of lubu, eventually will happen (193-201)
	CusLog("### ZhangFeiHorseslistener  loading ###")
	core:remove_listener("ZhangFeiHorses");
	core:add_listener(
		"ZhangFeiHorses",
		"FactionTurnStart",
		function(context)
  			if(context:faction():name()=="3k_main_faction_liu_bei" and cm:get_saved_value("drunkevent") and cm:get_saved_value("zhangfei_horses")~=true) then --generic so 194 can use too
				--check zhang fei is alive, in liu beis faction, and lu bu is vassal
				local qzhangfei= getQChar("3k_main_template_historical_zhang_fei_hero_fire")
				local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
				--These both evaluate to the same damn thing.. lmfao?
				--CusLog("Horses DontWant:"..tostring(cm:query_faction(qlubu:faction():name()):has_specified_diplomatic_deal_with("treaty_components_vassalage",qzhangfei:faction())))
				--CusLog("Horses Want::"..tostring(cm:query_faction(qzhangfei:faction():name()):has_specified_diplomatic_deal_with("treaty_components_vassalage",qlubu:faction())))
				if( not qzhangfei:is_dead() and qlubu:is_faction_leader() and cm:get_saved_value("Turns_until_horses") < context:query_model():turn_number() ) then 
					if cm:query_faction(qzhangfei:faction():name()):has_specified_diplomatic_deal_with("treaty_components_vassalage",qlubu:faction()) then
						 CusLog("..listener ZhangFeiHorses:")
						return RNGHelper(5) -- Keep it kinda high to delay this 
					end
				end
			end
            return false
        end,
		function()
			CusLog("??? Callback: ZhangFeiHorseslistener callback ###")
			CaoCaoTakesInLiuBeiListener()
			CaoCaoTakesInLiuBei2Listener()
			local triggered=ZhangFeiHorses() --Fires the incident
			cm:set_saved_value("zhangfei_horses",triggered);
            CusLog("### Finished ZhangFeiHorseslistener ="..tostring(triggered))

		end,
		false -- does persist
    )
end


local function LuBuBetraysChoiceMadeListener() --ToDo 
	CusLog("### LuBuBetraysChoiceMadeListener loading ###")
	core:remove_listener("DilemmaChoiceMadeLuBuBetrays");
    core:add_listener(
    "DilemmaChoiceMadeLuBuBetrays",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_190lubu_betrays_liubei_dilemma" --ToDo
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! 3k_lua_190lubu_betrays_liubei_dilemma choice was:" .. tostring(context:choice()))
        if choice == 0 then
            StealXuCity() --no war is declared as liubei pusses out 
        end
    end,
    false  -- does not persist
 );
end
local function LuBuBetraysListener() --If lubu is vassal, Zhang Fei drunk event occurred and liu bei has war w yuanshu, lubu is vassal 
	CusLog("### LuBuBetraysListener loading ###")
	core:remove_listener("LuBuBetraysCity");
	core:add_listener(
		"LuBuBetraysCity",
		"FactionTurnEnd",
		function(context)
            if context:query_model():calendar_year() > 194 and context:query_model():calendar_year() < 200 and context:faction():is_human() then 
               if(cm:get_saved_value("lu_bu_takes_city") ==true and  cm:get_saved_value("lubu_stole_city") ~=true ) then --Occurs from zhangfei drunk event 
                    local qlubu=getQChar("3k_main_template_historical_lu_bu_hero_fire")
					local qzhangfei= getQChar("3k_main_template_historical_zhang_fei_hero_fire")
					local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
					if( not qzhangfei:is_dead() and not qlubu:is_dead() and qzhangfei:faction():name() == "3k_main_faction_liu_bei") then 
						if (
							cm:query_faction(qlubu:faction():name()):has_specified_diplomatic_deal_with("treaty_components_vassalage",qzhangfei:faction()) 
							and 
							cm:query_faction("3k_main_faction_yuan_shu"):has_specified_diplomatic_deal_with("treaty_components_war",qzhangfei:faction()) 
							) then
								return RNGHelper(1)   --Low chance for a delay
						else
							CusLog("..Cant Betray because one of the conditions arent true:")
							CusLog("cond1: vassalge"..tostring(cm:query_faction(qlubu:faction():name()):has_specified_diplomatic_deal_with("treaty_components_vassalage",qzhangfei:faction())))
							CusLog("cond2: war"..tostring(cm:query_faction("3k_main_faction_yuan_shu"):has_specified_diplomatic_deal_with("treaty_components_war",qzhangfei:faction())))
						
						end
					end
               end
            end
            return false;
		end,
		function(context)
			CusLog("??? Callback LuBuBetraysListener ###")
            LuBuBetraysCheck() --190 Only 
			CusLog("### Passed LuBuBetraysListener ###")
		end,
		false -- does not persist 
    )
end

local function ZhangFeiDrunklistener() --If zhangfei is in Xia Pi ( will likely be set up from cao dong plot, or could occur naturally)
	CusLog("### ZhangFeiDrunklistener  loading ###")
	core:remove_listener("ZhangFeiDrunk");
	core:add_listener(
		"ZhangFeiDrunk",
		"FactionTurnStart",
		function(context)
           -- CusLog("turn end refugee:")
  			if(context:faction():name()=="3k_main_faction_liu_bei" and cm:get_saved_value("drunkevent")~=true) then --generic so 194 can use too
				local qzhangfei= getQChar("3k_main_template_historical_zhang_fei_hero_fire")
				local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
				if( (not qzhangfei:is_dead()) and qlubu:is_faction_leader()) then 
					if cm:query_faction(qlubu:faction():name()):has_specified_diplomatic_deal_with("treaty_components_vassalage",qzhangfei:faction()) then
						if qzhangfei:region():name() == XIAPICITY and qzhangfei:faction():name()=="3k_main_faction_liu_bei" then --Global
							return CheckLiuBeiOwnsXiaPi();
						else
							CusLog("Zhange feis region="..tostring(qzhangfei:region():name()))
						end
					else 
						CusLog("Lubu doesnt have vassalage")
						CusLog("NORMAL Drunk:"..tostring(cm:query_faction(qlubu:faction():name()):has_specified_diplomatic_deal_with("treaty_components_vassalage",qzhangfei:faction())))
						CusLog("REVERSE Drunk:"..tostring(cm:query_faction(qzhangfei:faction():name()):has_specified_diplomatic_deal_with("treaty_components_vassalage",qlubu:faction())))
					end
				end
			end
            return false
        end,
		function(context)
			CusLog("??? Callback: ZhangFeiDrunklistener callback ###")
            local triggered=ZhangFeiDrunkEvent() --Fires the incident
			if triggered then 
				--set a var 
				cm:set_saved_value("drunkevent", true)
				cm:set_saved_value("Turns_until_horses",context:query_model():turn_number()+4)
				core:remove_listener("ZhangFeiDrunk");
			end
            CusLog("### Finished ZhangFeiDrunklistener ###")

		end,
		true -- does persist
    )
end

--This listener is oddly specific...
local function LuBuZhangFeiFailSafelistener() -- If Yuan Shu and CaoCao are Humans, and LiuBei and LuBu are AI we will make AI LuBu Rebel Against AI LiuBei, Otherwise we use Tiger Plot 
	CusLog("### LuBuZhangFeiFailSafelistener  loading ###")
	core:remove_listener("LuBuZhangFei");
	core:add_listener(
		"LuBuZhangFei",
		"FactionTurnStart",
		function(context)
           -- CusLog("turn end refugee:") --Incident var set after AI/Player LuBU is saved by AI/Player LiuBei
  			if( cm:get_saved_value("lu_bu_zhang_fei_incident") == true and context:faction():name() == "3k_main_faction_liu_bei") and not context:faction():is_human() then -- 190 campaign var
				CusLog(".. checking if CaoCao and yuan shu are both human for FailSafe betrayal")
				local qFaction2 = getQFaction("3k_main_faction_cao_cao")
				local qFaction3 = getQFaction("3k_main_faction_yuan_shu")
				if qFaction2==nil or qFaction3 ==nil then 
					return false
				end
				if qFaction2:is_human() and qFaction3:is_human() then -- If Yuan Shu and CaoCao are Humans, we will naturally make AI LuBu Rebel Against AI LiuBei 
					CusLog("FailSafe continuing..for too many players");
					--check zhang fei is alive, in liu beis faction, and lu bu is vassal
					local qzhangfei= getQChar("3k_main_template_historical_zhang_fei_hero_fire")
					local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
					if( not qzhangfei:is_dead() and qlubu:is_faction_leader()) then 
						if qzhangfei:faction():name() ~= "3k_main_faction_liu_bei" and not qzhangfei:faction():is_human() then 
							MoveCharToFaction("3k_main_template_historical_zhang_fei_hero_fire", "3k_main_faction_liu_bei")
							return false -- and try again later
						end
						if cm:query_faction(qlubu:faction():name()):has_specified_diplomatic_deal_with("treaty_components_vassalage",qzhangfei:faction()) then 
							if qzhangfei:region() ~= XIAPICITY then --Get him there, otherwise the other listener would work 
								return true;
							end
						end
					end
				end
			end
            return false
        end,
		function()
			CusLog("??? Callback: LuBuZhangFeiFailSafelistener callback ###")
            SetUpBeefFailSafe() -- move zhang fei to XiaPi as an army, next listener will pick up
            CusLog("### Finished LuBuZhangFeiFailSafelistener ###")
		end,
		false 
    )
end
--[[
local function LuBuZhangFeiAWBListener()
	CusLog("### LuBuZhangFeiAWBListener  loading ###")
	core:remove_listener("LuBuZhangFeiAWB");
	core:add_listener(
		"LuBuZhangFeiAWB",
		"FactionTurnStart",
		function(context)
  			if(context:faction():is_human() and context:faction():name() ==" 3k_main_faction_lu_bu" ) then 
				--check zhang fei is alive, in liu beis faction, and lu bu is vassal
				local qzhangfei= getQChar("3k_main_template_historical_zhang_fei_hero_fire")
				local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
				if( not qzhangfei:is_dead() and qlubu:is_faction_leader()) then 
					return true;
				end
			end
            return false
        end,
		function()
			CusLog("??? Callback: LuBuZhangFeiAWB callback ###")
            cm:set_saved_value("lu_bu_zhang_fei_incident",true) --Alt entry to storyline from AWB
            CusLog("### Finished LuBuZhangFeiAWB ###")

		end,
		false -- does not persist
    )
end
--]]
local function LiuBeiSavedChoiceMadeListener()
	CusLog("### LiuBeiSavedChoiceMadeListener loading ###")
	core:remove_listener("DilemmaChoiceMadeLiuBeiSaved");
    core:add_listener(
    "DilemmaChoiceMadeLiuBeiSaved",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_liu_bei_takes_lubu_dilemma" --choice relationships deepends, faction affinity
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! choice was:" .. tostring(context:choice()))
        if choice == 0 then
            confirmSaving()
        end
    end,
    false -- does not persist
 );
end

local function LuBuSavedChoiceMadeListener()
	CusLog("### LuBuSavedChoiceMadeListener loading ###")
	core:remove_listener("DilemmaChoiceMadeLuBuSaved");
    core:add_listener(
    "DilemmaChoiceMadeLuBuSaved",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_lubu_flee_liubei_dilemma" --choice relationships deepends, faction affinity
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! choice was:" .. tostring(context:choice()))
        if choice == 0 then
            confirmSaving()
        end
    end,
    false  -- does not persist
 );
end
local function TRYINGAGAINLISTENER() --This is a real last ditch effort disaster, for some reason Lu Bu becomes untargetable despite being alive and previous dilms wont trigger.
	CusLog("### TRYINGAGAINLISTENER  loading ###")
	core:remove_listener("TRYINGAGAIN");
	core:add_listener(
		"TRYINGAGAIN",
		"FactionTurnStart",
		function(context)
           -- CusLog("turn end refugee:")
		   return context:faction():is_human() and cm:get_saved_value("TRY_AGAIN")==true 
        end,
		function(context)
			CusLog("??? Callback: TRYINGAGAINLISTENER callback ###")
			if cm:get_saved_value("carriage_madeit")==true and cm:get_saved_value("override_tryagain")~=true then 
				CusLog("TRYING DIL AGAIN")
				local triggered=cm:trigger_dilemma("3k_main_faction_yuan_shu","3k_lua_yuanshu_hires_lubu_dilemma",true)
				local qlubu=getQChar("3k_main_template_historical_lu_bu_hero_fire")
				CusLog("lubus dead="..tostring(qlubu:is_dead()))
				CusLog("lubu faction="..tostring(qlubu:faction():name()))
				CusLog("triggered=="..tostring(triggered))
				if not triggered then 
					LuBusCaptureExecuteException()
				end
				cm:set_saved_value("TRY_AGAIN",false)
			end

		end,
		false -- does persist
    )
end

local function LubuLastStandListener() -- If Yuan Shu and CaoCao are Humans, and LiuBei and LuBu are AI we will make AI LuBu Rebel Against AI LiuBei, Otherwise we use Tiger Plot 
	CusLog("### LubuLastStandListener  loading ###")
	core:remove_listener("LubuLastStand");
	core:add_listener(
		"LubuLastStand",
		"FactionTurnStart",
		function(context)
           -- CusLog("turn end refugee:") --Incident var set after AI/Player LuBU is saved by AI/Player LiuBei
		 local qlubu= getQChar2("3k_main_template_historical_lu_bu_hero_fire")	
		 if qlubu~=nil  then  
			if qlubu:is_faction_leader() and not context:faction():is_human() and context:faction():name()==qlubu:faction():name() and CountRegions(qlubu:faction():name()) ==1 then
				if qlubu:faction():region_list() and not qlubu:has_military_force() and not qlubu:faction():is_human() then
					for i = 0, qlubu:faction():faction_province_list():num_items() - 1 do -- Go through each Province
						local province_key = qlubu:faction():faction_province_list():item_at(i);
					   -- CusLog("$looking at Province #:"..tostring(i).."  ="..tostring(province_key))
						for i = 0, province_key:region_list():num_items() - 1 do -- Go through each region in that province
						   -- CusLog("$$looping: x" ..tostring(i))
							local region_key = province_key:region_list():item_at(i);
							if(not region_key:is_null_interface()) then 
								local region_name = region_key:name()
								if cm:get_saved_value("lubu_requested_support") ~=true then 
									CusLog("trying to spawn LuBu")
									local unit_list="3k_main_unit_fire_mercenary_cavalry_captain,3k_dlc05_unit_fire_formation_breakers,3k_main_unit_wood_ji_infantry,3k_main_unit_metal_sabre_infantry"
									SpawnAGeneralInRegion(qlubu, region_name, unit_list)
									--Try to prevent lulingqi from leaving
									cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", qlubu:faction():name(),3 )
									return true;
								else --stop him from respawning and getting executed???
									return true; --Do i need this??? I am going to stop listening if lubu_requested_support ==true
								end
							end
						end	
					end
				end

			elseif qlubu:is_faction_leader()  and qlubu:faction():is_human() and context:faction():name()==qlubu:faction():name() and CountRegions(qlubu:faction():name()) ==1 then 
				CusLog(" need leader check??")
				return true;
			end
		end
            return false
        end,
		function(context) --refactor this to work w saving him once normally, and a second time IF he accepted marriage in which case he submits 
			CusLog("??? Callback: LubuLastStandListener callback ###")
			--ununused really...
			if cm:get_saved_value("lubu_requested_support") ~=true then 
				local success=TryMarriage()
				cm:set_saved_value("lubu_requested_support", success);
			end
            CusLog("### Finished LubuLastStandListener ###")
		end,
		false 
    )
end
local function AiLuBuCapturedListener() 
	CusLog("### PostBattleCaptureListener listener loading ###")
	core:remove_listener("AiLuBuCaptured")	
	core:add_listener(
		"AiLuBuCaptured",
		"FactionDied",
		function(context)
			CusLog("Faction Destroyed="..tostring(context:faction():name()))
			CusLog("Killer="..tostring(context:killer_or_confederator_faction_key())) -- doesnt work???
			if context:faction():name()== "3k_main_faction_lu_bu" then 
				if context:killer_or_confederator_faction_key() == "3k_main_faction_cao_cao"  then
					if  cm:get_saved_value("lubu_saved")==true then 
						return true
					else
						--Trigger the AWB liu bei takes in Lu Bu thing cuz it aint happening?
					end
				elseif context:killer_or_confederator_faction_key() == "3k_main_faction_liu_bei"  then
					return cm:query_faction("3k_main_faction_cao_cao"):has_specified_diplomatic_deal_with("treaty_components_vassalage",cm:query_faction("3k_main_faction_liu_bei"))
				elseif context:killer_or_confederator_faction_key() == "" then 
					CusLog("@@!!..op1") -- this does happen.. idk how 
				end 
			end
		return false;
		end,
		function(context)
			CusLog("???Callback: AiLuBuCapturedListener ###")
			local caocaoFaction= cm:query_faction("3k_main_faction_cao_cao")
			if cm:get_saved_value("carriage_madeit")==true then --Player is yuanshu
				if cm:get_saved_value("override_tryagain")~=true then 
					TRYINGAGAINLISTENER()
					cm:set_saved_value("TRY_AGAIN",true)
				end 
			elseif caocaoFaction:is_human() then 
				cm:trigger_dilemma("3k_main_faction_cao_cao", "3k_lua_cao_captures_lubu_dilemma", true)
			else
				LuBusCaptureExecuteException() -- kill everyone and move zhang liao to ai Cao Cao 
				register_CheZhou_emergent_faction_2()
				cm:set_saved_value("SpawnCheZhou",true)
			end
			
		end,
		false
    )
end
--This one is sort of a fall back because it doesnt work randomly.
local function LubuSurroundedListener() 
	CusLog("### LubuSurroundedListener loading ###")
	core:remove_listener("LubuSurrounded");
	core:add_listener(
		"LubuSurrounded",
		"PendingBattle",
		function(context)
			--CusLog("Checking If LuBus Surrounded in a siege")
			if cm:get_saved_value("lu_bu_refugee")~=false  or cm:get_saved_value("lubu_surrounded")==true then 
				--CusLog("Lubu hasnt been saved yet, cant trigger surrounded, or has already been surrounded ")
				return false;
			end 
		--	CusLog("Checking If LuBus Surrounded in a siege")
			local pb=context:query_model():pending_battle();
			local defender= pb:defender(); -- a qchar
			local attacker= pb:attacker();
			local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
			if qlubu:is_null_interface() then 
					--remove_listener("LubuSurrounded")
					CusLog("return false null")
					return false;
			elseif not qlubu:is_faction_leader() then 
					--remove_listener("LubuSurrounded")
					CusLog("return false not leader")
					return false;
			else
				--CusLog("were passing but next line will crash?")
				--CusLog("is siege battle="..tostring(pb:battle_type()))
				if not (pb:has_attacker() and pb:has_defender()) then 
					CusLog("Does this battle have an attacker/defender?")
					CusLog("Attacker= "..tostring(pb:has_attacker()))
					CusLog("Defender= "..tostring(pb:has_defender()))
					return false;
				end
				--CusLog("attacker:faction():name() ="..tostring(attacker:faction():name()))
				--CusLog("defender:faction():name()="..tostring(defender:faction():name()))
				--CusLog("BattlType=="..tostring(pb:battle_type()))
				if defender:faction():name() == qlubu:faction():name() or attacker:faction():name() == qlubu:faction():name() then 
					CusLog("!!..LUBU in a battle !!")
					local LubuRegions= CountRegions(qlubu:faction():name())
					if LubuRegions ==1  and (pb:battle_type() == "settlement_relief" or pb:battle_type() == "settlement_sally" or pb:battle_type() == "settlement_unfortified" or pb:battle_type() == "settlement_standard") then 
						if (attacker:faction():name() == "3k_main_faction_cao_cao" and not defender:faction():is_human()) or (defender:faction():name() == "3k_main_faction_cao_cao" and not attacker:faction():is_human()) then 
							return true; --Player is CaoCao and will capture the city from AI Lu Bu
						elseif defender:faction():is_human() then 
							return true; -- Player is lubu and needs to send word to yuan shu (saved from anyone)
						else   --check yuan shu is player and might want to aid 
							local yuanShuFaction=cm:query_faction("3k_main_faction_yuan_shu")
							if yuanShuFaction:is_null_interface() then
								return false
							elseif yuanShuFaction:is_dead() then 
								return false;
							elseif yuanShuFaction:is_human() then 
								if cm:query_faction("3k_main_faction_yuan_shu"):has_specified_diplomatic_deal_with("treaty_components_peace",qlubu:faction()) then
									CusLog("player yuan shu has peace w lubu, return true ")
									return true; --written this way to log print statements 
								else 
									CusLog("Player Yuan Shu doesnt have peace w lubu, return false")
									return false;
								end
							end
						end 
					elseif LubuRegions ==0  then
						CusLog(" lubus got zero regions:surrounded")
						--local triggered=cm:trigger_dilemma("3k_main_faction_yuan_shu","3k_lua_yuanshu_hires_lubu_dilemma",true)
							cm:set_saved_value("TRY_AGAIN",true)
							TRYINGAGAINLISTENER()
							return true;
					end
				end
            end
            return false
        end,
		function()
			CusLog("??? Callback LubuSurroundedListener ###")
			CusLog("!!! Look into this cuz events are unfinished ###")
			LuBuDire()
			cm:set_saved_value("lubu_surrounded",true) -- Only gets one chance 
		end,
		true
    )
end

function LuBuRefuge_listener() -- Wont work for AWB Player LUBU, has to use vanilla event.
	CusLog("### LuBuRefuge listener loading ###")
	core:remove_listener("LuBuRefuge");
	core:add_listener(
		"LuBuRefuge",
		"FactionTurnStart",
		function(context)
			  if( (cm:get_saved_value("lu_bu_in_puyang")==true and context:faction():name() == "3k_main_faction_dong_zhuo") --190 player 
				or
				(cm:get_saved_value("lu_bu_refugee")==true and context:faction():name() == "3k_main_faction_lu_bu" and not context:faction():is_human())) then --194 (ai)
					if cm:get_saved_value("lubu_saved") ~=true then    
						CusLog("---Its LuBus turn check If he needs to be saved---")
						local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
                        local qlubu_faction = qlubu:faction();
                        local q_caocao_faction = cm:query_faction("3k_main_faction_cao_cao")
                        local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")

                        if(qlubu_faction:is_dead()) then
                            CusLog("X!X!X!X!X!X!X!X!X  Lubus factons dead but its his end turn??  X!X!X!X!X!X!X!X!X")
                            return false
                        end

                        local qcaocao = cm:query_model():character_for_template("3k_main_template_historical_cao_cao_hero_earth")
                        local qliubei = cm:query_model():character_for_template("3k_main_template_historical_liu_bei_hero_earth")

                        if not qlubu:is_null_interface() and not qcaocao:is_null_interface() and not qliubei:is_null_interface() then
                            CusLog("...leaders are not null")
                            if qlubu:is_faction_leader() and qliubei:is_faction_leader() then 
                                CusLog("...lubu and liu bei are leaders")
                                -- check lu bu owns 1 or less regions 
                                if CountRegions(qlubu_faction:name()) < 2  then
                                    CusLog("...lu bu owns less than 2 regions")
                                    --check liu bei owns pengcheng city or farm
                                     if CountRegions("3k_main_faction_liu_bei") < 2  then
										CusLog("....LiuBei doesnt have enough regions to give..")
										AiFailSafe() --maybe LuBu can hang on
										return false
									end
                                    local pengcheng_region =cm:query_region(XIAOPEICITY)
                                    local pengcheng_region2 =cm:query_region("3k_main_penchang_resource_2")
									if pengcheng_region:owning_faction():name() == "3k_main_faction_liu_bei" then 
										cm:set_saved_value("gift_region", pengcheng_region:name());
										return true
									elseif pengcheng_region2:owning_faction():name() == "3k_main_faction_liu_bei" then 
										cm:set_saved_value("gift_region", pengcheng_region2:name());
										return true
                                    end
                                end
                           	end
						end
					end
            end
            return false
        end,
		function()
			CusLog("??? Callback LuBu Refugee ###")
			LuBuZhangFeiFailSafelistener()
			saveLubu() 
            cm:set_saved_value("lu_bu_refugee", false);
			--cm:set_saved_value("lu_bu_in_puyang", false);
			LubuSurroundedListener()
			CusLog("### Finished LuBu Refugee ###")
		end,
		false
    )
end


--donta listener for AWB rescue script will continue based on vassal status?

local function ParseAWB()--Entry point from AWB 
	CusLog("..seeing if AWB LuBu is in puyang")
	local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
	if not qlubu:is_null_interface() then 
		if qlubu:faction():name()=="3k_main_faction_lu_bu" then 
			cm:set_saved_value("lu_bu_in_puyang",true)
			CusLog("..he is!, alt entry point into script")
		end
	end
end

local function XuLubuVariables()
	CusLog("  XuLubu lu_bu_refugee= "..tostring(cm:get_saved_value("lu_bu_refugee")))
    CusLog("  XuLubu lu_bu_in_puyang= "..tostring(cm:get_saved_value("lu_bu_in_puyang")))   
	CusLog("  XuLubu lu_bu_zhang_fei_incident= "..tostring(cm:get_saved_value("lu_bu_zhang_fei_incident")))
	CusLog("  XuLubu drunkevent= "..tostring(cm:get_saved_value("drunkevent")))
	CusLog("  XuLubu lu_bu_takes_city= "..tostring(cm:get_saved_value("lu_bu_takes_city")))
	CusLog("  XuLubu lubu_stole_city= "..tostring(cm:get_saved_value("lubu_stole_city")))-- used in cao plot
	CusLog("  XuLubu Turns_until_horses= "..tostring(cm:get_saved_value("Turns_until_horses")))
	CusLog("  XuLubu zhangfei_horses= "..tostring(cm:get_saved_value("zhangfei_horses")))
	CusLog("  XuLubu chen_advice1= "..tostring(cm:get_saved_value("chen_advice1")))
	CusLog("  XuLubu chen_advice2= "..tostring(cm:get_saved_value("chen_advice2")))
	CusLog(" *XuLubu turns_till_nogifts= "..tostring(cm:get_saved_value("turns_till_nogifts"))) --unused now 
	CusLog("  XuLubu chen_betrays= "..tostring(cm:get_saved_value("chen_betrays")))
	CusLog("  XuLubu lubu_surrounded= "..tostring(cm:get_saved_value("lubu_surrounded")))
	CusLog("  XuLubu lubu_requested_support= "..tostring(cm:get_saved_value("lubu_requested_support")))
	CusLog("  XuLubu carriage_madeit= "..tostring(cm:get_saved_value("carriage_madeit")))
	CusLog("  XuLubu TRY_AGAIN= "..tostring(cm:get_saved_value("TRY_AGAIN")))
	CusLog("  XuLubu override_tryagain= "..tostring(cm:get_saved_value("override_tryagain")))
	CusLog("  XuLubu lulinqi_kills= "..tostring(cm:get_saved_value("lulinqi_kills")))

end


-- when the game loads run these functions:
cm:add_first_tick_callback(
	function(context)
		IniDebugger()
		if context:query_model():turn_number()==1 then 
			ParseAWB()
		end
		XuLubuVariables()
        if context:query_model():calendar_year() > 193 and context:query_model():calendar_year() < 201 then
            --TmpRefuge()
			LuBuRefuge_listener()
			LuBuSavedChoiceMadeListener()
			LiuBeiSavedChoiceMadeListener()
			if cm:get_saved_value("drunkevent")~=true then
				--LuBuZhangFeiAWBListener() --Made more generic , dont use 
				ZhangFeiDrunklistener() -- Will trigger if zhang fei is commanding an army in region (TigerPlot2 sets this)
			end
			if cm:get_saved_value("lubu_stole_city")~=true then 
				LuBuBetraysListener()
				LuBuBetraysChoiceMadeListener()
			end
			
			if cm:get_saved_value("yuan_shu_is_human") and cm:get_saved_value("cao_cao_is_human") then 
				LuBuZhangFeiFailSafelistener() --Checks if TIger Wolf wont work 
			end

			--Always good to listen for:
			ZhangFeiHorseslistener()
		
			LuBuBetrayedChenDengListener() -- always listen cuz can trigger from yuanshao confed gonsunzan
		end
		
		--Outside of the Year requirement 
		if cm:get_saved_value("lu_bu_refugee")==false  and cm:get_saved_value("lubu_surrounded")~=true then 
			LubuSurroundedListener()
		end

		if cm:get_saved_value("lu_bu_in_puyang") then --Dont let refuge turn it off, let this be a symbol lubu is alive
			if cm:get_saved_value("chen_advice1")~=true then 
				ChenDeng1Listener()
			end
			if cm:get_saved_value("chen_advice2")~=true then 
				ChenDeng2Listener()
			end
			if cm:get_saved_value("chen_betrays")~=true then 
				ChenDeng3Listener()
			end
		end 
		
		--Both for AI LUBU
		AiLuBuCapturedListener() -- 190 and AWB (AI)lubu and  (Player/AI)Cao Cao 
		CaoCaoExecuteChoiceMadeListener()

		if cm:get_saved_value("lubu_requested_support")~=true then 
			YuanShuCarriageChoiceMadeListener()
			LubuLastStandListener()
		end


		if cm:get_saved_value("carriage_madeit") then 
			YuanShuHireLubuChoiceMadeListener()
		end

		if cm:get_saved_value("lulinqi_kills")~=nil then 
			if  cm:get_saved_value("lulinqi_kills") ~= 999 then 
				LuLingQiRebelsListener()
			end 
		end
		local qlubu= getQChar2("3k_main_template_historical_lu_bu_hero_fire")
		if qlubu~=nil then 
			if qlubu:faction():is_human() then 
				LubuRedhareListener()
			end
		end
		--TMP
		--CusLog("TMP set 3k_lua_global_zhangfei_steals_horses")
		--cm:set_saved_value("drunkevent",true)
		--local triggered =cm:trigger_incident(getPlayerFaction(),"3k_lua_global_zhangfei_steals_horses", true ) 	
		--local triggered =cm:trigger_incident(getPlayerFaction(),"3k_lua_chens_betray", true ) 	
		--CusLog("triggered1="..tostring(triggered))
		
		--cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_lu_bu", "3k_general_metal", "3k_dlc05_template_historical_lu_lingqi_hero_metal");
		--cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_lu_bu", "3k_general_wood", "3k_mtu_template_historical_lady_lu_ji_hero_wood");
		--MoveCharToFaction("3k_mtu_template_historical_lady_lu_ji_hero_wood", "3k_main_faction_lu_bu")
		--local mchar = getModifyChar("3k_mtu_template_historical_lady_lu_ji_hero_wood")
		--mchar:assign_to_post("faction_heir")
		--local triggered= cm:trigger_dilemma("3k_main_faction_yuan_shu", "3k_mtu_yuanshu_helps_lubu_dilemma", true)
		--CusLog("triggered="..tostring(triggered))

		--TryMarriage()
		--CusLog("TMP mil")
		--ERROR: can_modify() failed - no model interface is present. Last event triggered is 
		--campaign_manager:grant_military_access("3k_main_faction_lu_bu", "3k_main_faction_yuan_shu", true) --always use true or error
		--ForceADeal("3k_main_faction_lu_bu", "3k_main_faction_yuan_shu", "data_defined_situation_military_access")

		--data_defined_situation_break_deal
		--local triggered=cm:trigger_dilemma("3k_main_faction_yuan_shu","3k_lua_yuanshu_hires_lubu_dilemma",true)
		--CusLog("triggered=="..tostring(triggered))

		--LubuLastStandListener() --TMP
	end
)

