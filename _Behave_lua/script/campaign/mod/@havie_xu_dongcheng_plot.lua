-----> Dong Cheng plot
--- Will Start if LuBu is no longer a faction leader  
--- *Can be advanced from YuanShao confederating gonsunzan 

--Six names Dong Cheng, Wang Zifu, Chong Ji, Wu Shi, Wu Zilan, and Ma Teng pg 476 ch 21

-- Removed requirement that liu bei is a vassal of Cao Cao despite:
--Note* CaoCao will take Liu Bei in in Lubu Xu plot after zhang fei horses incident 


---- THIS SCRIPT IS A MESS --- I need to rethink all of this 
--Serious trivia says che zou never gives, land, liu bei just kills him and takes it , i might be able to skip over some of this then 

local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_dongcheng_plot.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
		local header=" (dongcheng_plot): "
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
	local file = io.open("@havie_dongcheng_plot.txt", "w+")
	file:close()
	CusLog("---Begin File----")
end

local function SpawnMaTeng()
	CusLog("Begin  SpawnMaTeng")
	local qMateng= getQChar2("3k_main_template_historical_ma_teng_hero_fire")
	if qMateng:is_null_interface() then 
		CusLog("Mateng Null")
		qMateng=FindFreeGeneral("3k_main_faction_ma_teng")
	elseif qMateng:is_dead() then 
		CusLog("Mateng dead")
		qMateng=FindFreeGeneral("3k_main_faction_ma_teng")
	elseif qMateng:has_military_force() then 
		CusLog("has force")
		qMateng=FindFreeGeneral("3k_main_faction_ma_teng")
	end
	local unit_list="3k_main_unit_fire_mercenary_cavalry_captain,3k_main_unit_fire_qiang_marauders,3k_main_unit_water_qiang_hunters,3k_main_unit_metal_sabre_infantry,3k_main_unit_fire_qiang_marauders"
	local qregion1= cm:query_region("3k_main_luoyang_captial")
	local qregion2= cm:query_region(XUCHANG)
	local qregion3= cm:query_region("3k_main_luoyang_resource_1")
	local qregion4= cm:query_region(CHENLIU)
	local regionName="3k_main_luoyang_captial"
	local found=false;
	CusLog("checking regions btw XUCHANG= "..tostring(XUCHANG))
	if not qregion1:is_null_interface() then 
		if qregion1:owning_faction():name()=="3k_main_faction_cao_cao" then 
			found=true;
		end
	end
	if not qregion2:is_null_interface() and not found then 
		if qregion2:owning_faction():name()=="3k_main_faction_cao_cao" then 
			found=true;
			regionName=XUCHANG
		end
	else 
		CusLog("XUCHANG is ="..tostring(qregion2:is_null_interface()))
	end
	if not qregion3:is_null_interface() and not found then 
		if qregion3:owning_faction():name()=="3k_main_faction_cao_cao" then 
			found=true;
			regionName="3k_main_luoyang_resource_1"
		end
	end
	if not qregion4:is_null_interface() and not found then 
		if qregion4:owning_faction():name()=="3k_main_faction_cao_cao" then 
			found=true;
			regionName=CHENLIU
		end
	end
	if not found then 
		qregion4=FindRandomRegionOwned('3k_main_faction_cao_cao')
		if qregion4~=nil then 
			regionName=qregion4:name()
			found=true;
		end
	end
	CusLog("Chosen region="..tostring(regionName))	
	if found then 	
		SpawnAGeneralInRegion(qMateng,regionName, unit_list)
		cm:set_saved_value("spawn_mateng",false)
		cm:modify_faction("3k_main_faction_ma_teng"):increase_treasury(21500)
	else
		cm:modify_faction("3k_main_faction_ma_teng"):increase_treasury(1500)
	end

	local qMachao= getQChar2("3k_main_template_historical_ma_chao_hero_fire")
	if qMachao~=nil then 
		if qMachao:faction():name()~="3k_main_faction_ma_teng" then 
			MoveCharacterToFaction("3k_main_template_historical_ma_chao_hero_fire", "3k_main_faction_ma_teng")
			local mchar= cm:modify_character(qMachao);
			mchar:assign_to_post("faction_heir");
			CusLog("made ma chao heir again")
		end
	else 
		CusLog("MaChao is nil/dead, spawn him")
		cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_ma_teng", "3k_general_fire", "3k_main_template_historical_ma_chao_hero_fire"); --CHECK
		--How to make heir??
	end
	--PrintOfficersInFaction("3k_main_faction_ma_teng")
	--TellMeAboutFaction("3k_main_faction_ma_teng")

	local changan= cm:query_region("3k_main_changan_capital")
	if not changan:is_null_interface() then 
		if not changan:owning_faction():is_human() then 
			cm:modify_model():get_modify_region(changan):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_ma_teng"))
			CusLog("transfered changan")
		else
			CusLog("changaowner human")
		end
	else
		CusLog("changan is null...")
	end

	CusLog("END  SpawnMaTeng")
end 

local function LiuBeiStealsRegion(qleader_faction)
	CusLog("Begin LiuBeiStealsRegion")
	--LiuBei should get one/two regions from him, the rest abandoned 
	--Going to do this in a very ghetto way 
	--local landArray= {cm:get_saved_value("chezhou_region"), PENGCHENGTEMPLE}
	--GiveSomeoneLand(landArray, "3k_main_faction_liu_bei", qleader:faction():name(), false)

	local success=false;
	local XuRegion= cm:query_region(XIAPICITY)
	if not XuRegion:is_null_interface() then 
		if XuRegion:owning_faction():name()== qleader_faction:name() then 
			cm:modify_model():get_modify_region(XuRegion):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))
			success=true;
		end 
	end
	if not success then 
		local region=FindRandomRegionOwned(qleader_faction:name())
		if region~=nil then 
			cm:modify_model():get_modify_region(region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))
			success=true;
		end
	end
	AbandonLands(qleader_faction:name())
	CusLog("End LiuBeiStealsRegion ="..tostring(success))
end

local function LiuBeiKillsChezhou() --exposes the plot AND gets liu bei to kill chezhou same time 
	CusLog("Begin LiuBeiKillsChezhou")

	local qleader = cm:query_model():character_for_template("3k_main_template_historical_che_zhou_hero_water")
	local triggered=false
	if not qleader:is_null_interface() then 
		if qleader:is_faction_leader() then 
			local qleader_faction = qleader:faction()
			local q_liubei_faction=cm:query_faction("3k_main_faction_liu_bei")
			if q_liubei_faction:is_human() then 
				--Trigger a Dilemma 
				CusLog("TODO")
				triggered=	cm:trigger_dilemma("3k_main_faction_liu_bei", "3k_lua_liubei_kills_chezhou_dilemma", true) --TODO war from CaoCao, choice kills 
			else 
				Cuslog("trying to trigger 3k_lua_liubei_kills_chezhou ")
				triggered=	cm:trigger_incident(getPlayerFaction(), "3k_lua_liubei_kills_chezhou", true) --TODO incident kills him , war from CaoCao
				if triggered then 
					LiuBeiStealsRegion(qleader_faction)
				end
			end
		end
	end 
	CusLog("End LiuBeiKillsChezhou = "..tostring(triggered))
	return triggered;
end


local function ExposedPlot() -- this happens 1 turn after?
	CusLog("Begin ExposedPlot ")
	
	local q_mateng_faction= getQFaction("3k_main_faction_ma_teng")
	if q_mateng_faction~=nil then 
	--Spawn ma tengs army (if not human) else let it ride ?
		if not q_mateng_faction:is_human() then 
			--Tong gate? nah, this leads UP to tong gate later.
			--Not sure where to spawn him. 
			cm:force_declare_war("3k_main_faction_ma_teng", "3k_main_faction_cao_cao", false) 
			CusLog("..!Good Luck getting MaTeng to be deployable")
			--UnDeploy MaTeng and flip a bool so he can Spawn an army on next turn end. Tricky though because hes the faction leader??
			--Not doing this Because it bugs him out as Factionleader
			--MakeDeployable("3k_main_template_historical_ma_teng_hero_fire") --well see how this goes as a FactionLeader
			cm:set_saved_value("spawn_mateng",true)
		else 
			--Dont Trigger an incident? plot has been exposed and calls this 
		end 
	end
	
	local q_caocao_faction= getQFaction("3k_main_faction_cao_cao")
	if q_caocao_faction~=nil then 
		if not q_caocao_faction:is_human() then 
			cm:force_declare_war("3k_main_faction_cao_cao", "3k_main_faction_ma_teng", false) 	
			cm:force_declare_war("3k_main_faction_cao_cao", "3k_main_faction_liu_bei", false)
			cm:set_saved_value("caocao_buffed_turnlimit", cm:query_model():turn_number() +1)
			cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua", "3k_main_faction_cao_cao" , 8)		
		else
			--Dont Trigger an incident? plot has been exposed and calls this 
		end 
	end

	local q_liubei_faction= getQFaction("3k_main_faction_liu_bei")
	if q_liubei_faction~=nil then 
		if not q_liubei_faction:is_human() then 
			cm:force_declare_war("3k_main_faction_liu_bei", "3k_main_faction_cao_cao", false) 	
		else
			--Dont Trigger an incident? plot has been exposed and calls this 
		end 
	end
		
	--hopefully this doesnt come to late, and mess up anything else?
	cm:set_saved_value("turnsNo_till_liuBei_can_flee", cm:query_model():turn_number()+1) --LiuBei can gtfo if need be next turn 
	

	CusLog("End ExposedPlot ")
end

--Unused
local function ChezhouGivesLand()--Serious trivia says this shouldnt happen, maybe i need to rethink.
	CusLog("Begin CheZhouGivesLand")

	-- Che Zhou gives back Xu  (che zhou is a vassal of cao cao) should still hold some land in area.
	local qleader = cm:query_model():character_for_template("3k_main_template_historical_che_zhou_hero_water")
    if not qleader:is_null_interface() then 
		CusLog("chezhou found")
		if qleader:is_faction_leader() then 
			--Give one of chezhus regions to LiuBei 
			local landArray= {XIAPICITY,XIAOPEICITY, PENGCHENGFARM, PENGCHENGTEMPLE, DONGIRONMINE }
			if (GiveSomeoneLand(landArray, "3k_main_faction_liu_bei", qleader:faction():name(), true) ) then 
				cm:set_saved_value("turnsNo_till_liuBei_can_flee", cm:query_model():turn_number()+5); -- stops him from fleeing for a bit more  (liubei movement)
				cm:set_saved_value("chezhou_gave_lands",true)
				CusLog(" End CheZhouGivesLand true")
				return true;
			end
		end
	end
	
	CusLog("End CheZhouGivesLand false")
	return false;
end

local function LiuBeiIndependence()
	CusLog("Begin LiuBeiIndependence")
	local q_liubei_faction=cm:query_faction("3k_main_faction_liu_bei")
	local q_caocao_faction=cm:query_faction("3k_main_faction_cao_cao")
	
	if q_liubei_faction:has_specified_diplomatic_deal_with("treaty_components_vassalage",q_caocao_faction) then 
		cm:apply_automatic_deal_between_factions("3k_main_faction_liu_bei","3k_main_faction_cao_cao", "data_defined_situation_vassal_declares_independence", false) -- how do i not need the true?
		cm:apply_automatic_deal_between_factions("3k_main_faction_liu_bei","3k_main_faction_cao_cao", "data_defined_situation_vassal_declares_independence") -- how do i not need the true?
		if  q_liubei_faction:has_specified_diplomatic_deal_with("treaty_components_vassalage",q_caocao_faction) then 
			cm:force_declare_war("3k_main_faction_liu_bei", "3k_main_faction_cao_cao", true)
			cm:force_declare_war("3k_main_faction_cao_cao", "3k_main_faction_liu_bei", true)
		end
		--CusLog("forcing peace..")
		ForceADeal("3k_main_faction_liu_bei", "3k_main_faction_cao_cao" , "data_defined_situation_peace")
		cm:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", "3k_main_faction_cao_cao", "data_defined_situation_proposer_declares_peace_against_target", true);
		cm:apply_automatic_deal_between_factions("3k_main_faction_cao_cao", "3k_main_faction_liu_bei", "data_defined_situation_proposer_declares_peace_against_target", true);
		cm:set_saved_value("turnsNo_till_liuBei_can_flee", cm:query_model():turn_number()+10) --Keep him around until exposed!
	end	
	
	CusLog("End LiuBeiIndependence")
	return not q_liubei_faction:has_specified_diplomatic_deal_with("treaty_components_vassalage",q_caocao_faction) 
end
--Theres a problem here because chezhou hasnt been spawned yet, should be fixed with fresh campaign though
local function PlotInMotion() -- Moves Liu Bei to Xu again  to intercept yuan shu meeting yuan shao w the seal 
	CusLog("Begin PlotInMotion")
	--Check chezhou is doing his thing in xu 
	local qleader = cm:query_model():character_for_template("3k_main_template_historical_che_zhou_hero_water")
	if qleader:is_null_interface() then 
		CusLog("Somethings wrong, chezhou's missing we will delay but enable liu bie to flee if he has to")
		cm:set_saved_value("turnsNo_till_liuBei_can_flee", cm:query_model():turn_number()+1)
		return false;
	elseif not qleader:is_faction_leader() then 
		CusLog("Somethings wrong, chezhou's missing we will delay but enable liu bie to flee if he has to")
		cm:set_saved_value("turnsNo_till_liuBei_can_flee", cm:query_model():turn_number()+1)
		return false;
	end
	
	local q_caocao_faction = cm:query_faction("3k_main_faction_cao_cao")
	local q_liubei_faction= cm:query_faction("3k_main_faction_liu_bei")
	
	local inMotion=false;
	--Should fire an incident/dilemma/other nonsense that liu bei is given land to go defeat yuan shu (no mention of emperor)
	if q_caocao_faction:is_human() then 
		--LiuBei requests hes given troops and land to dispatch of yuan shu 
		CusLog("TODO")
		inMotion=cm:trigger_dilemma("", "3k_lua_caocao_lets_liubei_go_dilemma", true) --Apply effect bundle for liubei, attempt to liberate via event ? 
	elseif q_liubei_faction:is_human() then  
		--CaoCao sends you off and gives you troops and land to dispatch of the defamed yuan shu 
		CusLog("TODO")
		inMotion= cm:trigger_incident("3k_main_faction_liu_bei", "3k_lua_liubei_let_go_cao", true) --Apply effect bundle for liubei, attempt to liberate via event? 
		if inMotion then 
			inMotion=LiuBeiIndependence()
		end
	else 
		cm:apply_effect_bundle("3k_custom_payload_given_army", "3k_main_faction_liu_bei" , 2) --only do 2 for the AI, we want him to die out
		inMotion=LiuBeiIndependence()
		if inMotion then 
			--Could use a global event that says this happened
		end
	end
	
	CusLog("End PlotInMotion ="..tostring(inMotion))
	return inMotion; -- kinda tricky return , the dilemma responses may have to unset this 
end


 function StartDongChengPlot() --**THIS should move liu bei back to XU to cut off YuanShu (same with gonsunzan being confederated)
	CusLog("Begin  StartDongChengPlot")
	local q_liubei_faction = cm:query_faction("3k_main_faction_liu_bei")
	local q_mateng_faction= cm:query_faction("3k_main_faction_ma_teng")
	--local q_caocao_faction= cm:query_faction("3k_main_faction_cao_cao")
	
	if q_mateng_faction:is_human() then 
		cm:trigger_dilemma("3k_main_faction_ma_teng", "3k_lua_mateng_dongcheng_dilemma", true)
	elseif q_liubei_faction:is_human() then 
		cm:trigger_dilemma("3k_main_faction_liu_bei", "3k_lua_liubei_dongcheng_dilemma", true)
	else
		--Progress for Cao Cao / AI characters 
		cm:set_saved_value("dongcheng_started", true);
	end
	
	--if cm:get_saved_value("gonsun_confed") ~= true then 
		--TriggerGonsunConfed() -- will happen if not human factions involved 
		--Cant call from below  could set a var
	--end 
	

	CusLog("End StartDongChengPlot ")
end

-------------------------------------------------------------
--------------------------LISTENERS--------------------------
-------------------------------------------------------------

	--SpawnAGeneralInRegion(qchar, regionName, unit_list)
local function SpawnAIMaTengListener() 
	CusLog("### SpawnAIMaTengListener  loading ###")
	core:remove_listener("SpawnAIMaTeng");
	core:add_listener(
		"SpawnAIMaTeng",
		"FactionTurnEnd",
		function(context)
			return context:faction():name()=="3k_main_faction_ma_teng" and cm:get_saved_value("spawn_mateng")==true
        end,
		function(context)
			CusLog("??? Callback SpawnAIMaTengListener ###")
			SpawnMaTeng()
			CusLog("### Finished SpawnAIMaTengListener ")
		end,
		false
    )
end
	
	
local function DongChengEventExposedListener()
	CusLog("### DongChengEventExposedListener loading ###")
	core:remove_listener("DongChengPlotExposed")
	core:add_listener(
		"DongChengPlotExposed",
		"IncidentOccuredEvent",
		function(context)
			 return context:incident() == "3k_lua_dongcheng_exposed"
		end,
		function(context)
			CusLog("??? Callback: DongChengEventExposedListener ###")
          -- cm:set_saved_value("rebellion_launched", true);
			ExposedPlot()
			cm:set_saved_value("dongcheng_exposed",true) 
			CusLog("### Finished DongChengEventExposedListener ###")
		end,
		false
    )
end

local function DongChengExposedListener() --I think the plot should be exposed if YuanShu is Dead 
	CusLog("### DongChengExposedListener  loading ###")
	core:remove_listener("DongChengExposed");
	core:add_listener(
		"DongChengExposed",
		"FactionTurnEnd",
		function(context)
			if( context:query_model():calendar_year() >=200 and context:faction():name() == "3k_main_faction_cao_cao") and cm:get_saved_value("turnsNo_till_exposed") ~=nil  and cm:get_saved_value("dongcheng_exposed")~=true then  
                local q_liubei_faction = cm:query_faction("3k_main_faction_liu_bei")
				local q_mateng_faction= cm:query_faction("3k_main_faction_ma_teng")
				local q_caocao_faction= context:faction();
				local qMateng= getQChar("3k_main_template_historical_ma_teng_hero_fire")
				--Verify everyone relevant is around 
				if cm:get_saved_value("turnsNo_till_exposed") <= context:query_model():turn_number()  --[[and not q_liubei_faction:has_specified_diplomatic_deal_with("treaty_components_war",q_mateng_faction)--]] then 
					if not q_caocao_faction:is_dead() and not q_liubei_faction:is_dead() and not q_mateng_faction:is_dead() then 
						local q_yuanshuFaction= getQFaction("3k_main_faction_yuan_shu")
							if q_yuanshuFaction==nil then 
								return true;
							else 
								if q_yuanshuFaction:is_human() then 
									CusLog("Rolling for Dong Plot Exposed, human YuanShu")
									return RNGHelper(0) --5 Chance to progress the plot if player is yuanshu, need not mention yuan shus death in expose plotline.
								end
							end
					else
						CusLog("someone essential to the plot is dead, abort")
						cm:set_saved_value("dongcheng_exposed",true) -- allow other scripts to proceed that might be waiting?
					end
				else
					CusLog("..(3) Turn time is wrong ");
					--ForceADeal("3k_main_faction_ma_teng","3k_main_faction_liu_bei","data_defined_situation_peace")
				end
            end
            return false
        end,
		function(context)
			CusLog("??? Callback DongChengExposedListener ###")
			--Should really be fire the incident
			DongChengEventExposedListener()
			local success=cm:trigger_incident(getPlayerFaction(), "3k_lua_dongcheng_exposed", true)
			--and IF liu bei is in Xu :
			--if cm:get_saved_value("chezhou_gave_lands") then 
			if success then 
				success = LiuBeiKillsChezhou() --ass backwards feeling 
			end
			--end
			CusLog("### Finished DongChengExposedListener success="..tostring(success))
		end,
		false
    )
end


local function LiuBeiKillChezhouChoiceListener()
	CusLog("### LiuBeiKillChezhouChoiceListener loading ###")
	core:remove_listener("LiuBeiKillChezhouChoice");
    core:add_listener(
    "LiuBeiKillChezhouChoice",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_liubei_kills_chezhou_dilemma" 
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! 3k_lua_caocao_lets_liubei_go_dilemma choice was:" .. tostring(context:choice()))
        if choice == 0 then
			LiuBeiStealsRegion();
		end
    end,
    false -- does not persist
 );
end

local function CaoCaoReleasesLiubeiChoiceListener()
	CusLog("### CaoCaoReleasesLiubeiChoiceListener loading ###")
	core:remove_listener("CaoCaoReleasesLiubeiChoice");
    core:add_listener(
    "CaoCaoReleasesLiubeiChoice",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_caocao_lets_liubei_go_dilemma" 
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! 3k_lua_liubei_kills_chezhou_dilemma choice was:" .. tostring(context:choice()))
        if choice == 0 then
			LiuBeiIndependence()
		end
    end,
    false -- does not persist
 );
end
--LuBu Needs to be defeated, everyone relevant still around/alive.
local function DongChengMotionListener() --Yuan Shu should be around/emperor as Liu Bei is excused to go defeat him 
	CusLog("### DongChengMotionListener  loading ###")
	core:remove_listener("DongChengMotion");
	core:add_listener(
		"DongChengMotion",
		"FactionTurnEnd",
		function(context)
			if( context:query_model():calendar_year() >=199 and context:faction():name() == "3k_main_faction_cao_cao") and cm:get_saved_value("dongcheng_started")==true  and cm:get_saved_value("plot_in_motion")~=true then  
                local q_liubei_faction = cm:query_faction("3k_main_faction_liu_bei")
				local q_mateng_faction= cm:query_faction("3k_main_faction_ma_teng")
				local q_caocao_faction= cm:query_faction("3k_main_faction_cao_cao")
				local qMateng= getQChar("3k_main_template_historical_ma_teng_hero_fire")
				local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
				--left over safety check for LuBu , but should never happen 
				if not qlubu:is_null_interface() then --Verify LuBu isnt around , this shouldnt happen at this point 
					if qlubu:is_faction_leader() then 
						if not qlubu:faction():is_human() then 
							cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua", qlubu:faction():name() , 15)
						end
						return false;
					end
				end 
				--Verify everyone relevant is around 
				if( not qMateng:is_dead() and not cm:query_faction(q_caocao_faction:name()):has_specified_diplomatic_deal_with("treaty_components_war",q_liubei_faction) ) then
					if not q_liubei_faction:has_specified_diplomatic_deal_with("treaty_components_war",q_mateng_faction) then 
						if not q_caocao_faction:is_dead() and not q_liubei_faction:is_dead() and not q_mateng_faction:is_dead() then 
							local qyuanshu= getQChar2("3k_main_template_historical_yuan_shu_hero_earth")
							if qyuanshu~=nil then -- hes alive
								if cm:get_saved_value("YuanShuEmperor") then 
									return true
								else 
									return RNGHelper(5) -- event shouldnt not mention yuan shu is emperor, just needs to be dealt with
								end
							end
						else
							CusLog("someone essential to the plot is dead, abort, should flip a bool?")
						end
					else
					CusLog("..(2)LiuBei and Mateng at war??, perhaps i should do something ");
					ForceADeal("3k_main_faction_ma_teng","3k_main_faction_liu_bei","data_defined_situation_peace")
					end
				end
            end
            return false
        end,
		function(context)
			CusLog("??? Callback DongChengMotionListener ###")
			local success=PlotInMotion() -- Gives LiuBei a buff, and possibly liberates (if i can figure out) Mainly progresses the story. 
			if not success then 
				cm:set_saved_value("plot_in_motion", false)
			elseif success then 
				local rng= math.floor(cm:random_number(2,5)); 
				cm:set_saved_value("turnsNo_till_exposed", context:query_model():turn_number()+rng)
				cm:set_saved_value("plot_in_motion", true)
			end
			CusLog("### Finished DongChengMotionListener success="..tostring(success))
		end,
		false
    )
end


local function LiuBeiDongChoiceListener()
	CusLog("### LiuBeiDongChoiceListener loading ###")
	core:remove_listener("LiuBeiDongChoice");
    core:add_listener(
    "LiuBeiDongChoice",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_liubei_dongcheng_dilemma" 
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! 3k_lua_liubei_dongcheng_dilemma choice was:" .. tostring(context:choice()))
        if choice == 0 then
			cm:set_saved_value("dongcheng_started", true);
		else
			cm:set_saved_value("dongcheng_started", false); -- turn it all off 
		end
    end,
    false -- does not persist
 );
end

local function MaTengDongChoiceListener()
	CusLog("### MaTengDongChoiceListener loading ###")
	core:remove_listener("MaTengDongChoice");
    core:add_listener(
    "MaTengDongChoice",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_mateng_dongcheng_dilemma" 
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! 3k_lua_mateng_dongcheng_dilemma choice was:" .. tostring(context:choice()))
        if choice == 0 then
			cm:set_saved_value("dongcheng_started", true);
		else
			cm:set_saved_value("dongcheng_started", false);
        end
    end,
    false -- does not persist
 );
end


--Work start until LuBu is gone, Mateng,LiuBei,CaoCao Alive, and MaTeng/LiuBei have peace. 
local function DongChengPlotListener() --199 spring -- a man named dong cheng approaches you (ma teng/liubei) asks you to sign a blood oath decreed by the emperor to destroy Cao cao. 
	CusLog("### DongChengPlotListener  loading ###")
	core:remove_listener("functionDongChengPlot");
	core:add_listener(
		"functionDongChengPlot",
		"FactionTurnEnd",
		function(context)
			if( context:query_model():calendar_year() >=199 and context:faction():name() == "3k_main_faction_cao_cao") and cm:get_saved_value("dongcheng_started")~=true then  
				local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
				if not qlubu:is_null_interface() then -- check LuBu isnt around 
					if qlubu:is_faction_leader() and not qlubu:faction():is_human() then 
						cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua", qlubu:faction():name() , 3)
						return false;
					elseif  qlubu:is_faction_leader() then --Player 
						return false;
					end
				end 
				-- Check everyone else is good. 
				local q_liubei_faction = cm:query_faction("3k_main_faction_liu_bei")
				local q_caocao_faction= cm:query_faction("3k_main_faction_cao_cao")
				local qMateng= getQChar("3k_main_template_historical_ma_teng_hero_fire")
				if( not qMateng:is_dead() --[[and not cm:query_faction(q_caocao_faction:name()):has_specified_diplomatic_deal_with("treaty_components_war",q_liubei_faction) --]]) then -- going to get rid of the need for liubei to be at peace w cao cao ?
					if  q_liubei_faction:has_specified_diplomatic_deal_with("treaty_components_war",qMateng:faction()) then 
						CusLog("..LiuBei and Mateng at trying to make peace  ");
						ForceADeal("3k_main_faction_ma_teng","3k_main_faction_liu_bei","data_defined_situation_peace")
					end
					if not q_caocao_faction:is_dead() and not q_liubei_faction:is_dead() and not qMateng:faction():is_dead() then 
						local qleader = cm:query_model():character_for_template("3k_main_template_historical_che_zhou_hero_water")
						if not qleader:is_null_interface() then 
							return qleader:is_faction_leader(); -- wait for chezhou to be leader
						end
					else
						CusLog("someone essential to the plot is dead, abort")
						cm:set_saved_value("dongcheng_started",true) -- allow other scripts to proceed that might be waiting?
					end
				end
            end
            return false
        end,
		function()
			CusLog("??? Callback DongChengPlotListener ###")
			StartDongChengPlot() 
		end,
		false
    )
end



local function DongChengVariables()
	CusLog("  DongChengVariables dongcheng_started= "..tostring(cm:get_saved_value("dongcheng_started")))
	CusLog("  DongChengVariables plot_in_motion= "..tostring(cm:get_saved_value("plot_in_motion")))
	--CusLog("  DongChengVariables chezhou_gave_lands= "..tostring(cm:get_saved_value("chezhou_gave_lands")))
	CusLog("  DongChengVariables turnsNo_till_exposed= "..tostring(cm:get_saved_value("turnsNo_till_exposed")))--Also relies on yuanshu being dead if AI 
	CusLog("  DongChengVariables dongcheng_exposed= "..tostring(cm:get_saved_value("dongcheng_exposed"))) 
	CusLog("  DongChengVariables spawn_mateng= "..tostring(cm:get_saved_value("spawn_mateng")))
end


-- when the game loads run these functions:
cm:add_first_tick_callback(
	function(context)
		IniDebugger()
		DongChengVariables()
        if context:query_model():calendar_year() > 197 and context:query_model():calendar_year() < 205 then
			if cm:get_saved_value("dongcheng_started") ~= true then 
				DongChengPlotListener()
			--Could use some checks for if ma teng or liu bei are human 
				MaTengDongChoiceListener()
				LiuBeiDongChoiceListener()
			elseif cm:get_saved_value("dongcheng_started") and cm:get_saved_value("dongcheng_exposed")~=true then 
				DongChengMotionListener()
				DongChengExposedListener()
				LiuBeiKillChezhouChoiceListener()
				SpawnAIMaTengListener()
			end
		elseif cm:get_saved_value("spawn_mateng")==true then 
			SpawnAIMaTengListener() -- just incase the player somehow reloads campaign during end turn where plots been exposed 
		end
		
		--TMP
		--CusLog("TMP 999")
		--cm:set_saved_value("turnsNo_till_exposed",999)
		--CusLog("TMP")
		--cm:trigger_incident(getPlayerFaction(), "3k_lua_liubei_kills_chezhou", true )
		
	end
)

