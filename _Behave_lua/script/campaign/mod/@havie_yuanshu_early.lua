--Yuan Shu Early , Responsible for:
--> Setting up ChengYu
--> Yuan Shao Sends ZhouXin (could inject if player is yuan shao)
--> LiuBiaos Cuts off Supplies
--> Hiring black mountain bandits to fight CaoCao
--> Betrayed by ChengYu
--> Escape to ShouChun
--* YuanShu gets LuFan From wu_Sunce regardless of player/AI

--ToDo Test take in lu bu dilemma
--ToDo Move Liu Yao to southEast 
--Consider vassalizing sunjian on turn turn 188 or something 

local printStatements=false;



local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_yuanshu_early.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
        local header=" (yuanshu_early): "
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
    local file = io.open("@havie_yuanshu_early.txt", "w+")
    file:close()
	CusLog("---Begin File----")
end




function YuanShuAcceptLuBu() 
	CusLog("### Running YuanShuAcceptLuBu ###")
	
	
	local lubu=getQChar("3k_main_template_historical_lu_bu_hero_fire")
    CusLog("Lu bu is faction leader = "..tostring(lubu:is_faction_leader()))

    if lubu:faction():name()~="3k_main_faction_dong_zhuo" then 
        MoveCharToFactionHard("3k_main_template_historical_lu_bu_hero_fire", "3k_main_faction_dong_zhuo")
    end

    if not lubu:is_faction_leader() then 
        --Kill Wang Yun if hes alive
        KillWangYun() -- LUbuMovement 
    end


    if cm:is_world_power_token_owned_by("emperor", lubu:faction():name())  then
        CusLog("..! LuBu has the emperor, transfer")
        --local lijue = cm:query_model():character_for_template("3k_main_template_historical_li_jue_hero_fire")
        --local lijue_faction = lijue:faction()
        -- Move emperor 
       -- campaign_emperor_manager:transfer_token_to_faction(cm:modify_faction(lijue_faction:name()):query_faction(), myFaction(), "emperor")
       LiJueTakesEmperor(lubu:faction())
    else
        CusLog(".. lu bu doesnt have the emperor?")
    end
    

    if cm:query_faction("3k_main_faction_yuan_shu"):has_specified_diplomatic_deal_with("treaty_components_war",lubu:faction()) then
        cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shu", lubu:faction():name(), "data_defined_situation_proposer_declares_peace_against_target", true);
        CusLog(".makepeace for lubu and yuan shu")
        cm:apply_automatic_deal_between_factions(lubu:faction():name(), "3k_main_faction_yuan_shu", "data_defined_situation_peace", true);
    end
    --Give military access 
    CusLog("giving military access")
    cm:apply_automatic_deal_between_factions(lubu:faction():name(), "3k_main_faction_yuan_shu", "data_defined_situation_military_access", true);
    cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shu", lubu:faction():name(), "data_defined_situation_military_access", true);

    AbandonLands(lubu:faction():name())

    local regionName=cm:get_saved_value("yuanshu_gives_lubu")
    --Give LuBu Nanyang mine, or runan mine , or something else if he hasnt those but >1 region 
    local qregion_1 = cm:query_region(regionName)
    if not qregion_1:is_null_interface() then 
        CusLog("moving to region: "..regionName)
        cm:modify_model():get_modify_region(qregion_1):settlement_gifted_as_if_by_payload(cm:modify_faction(lubu:faction():name()))
        --Teleport all armies to region
        TelportAllFactionArmies(lubu:faction():name(),regionName)
    end

    --Decide if we want to vassalize? Im gonna say no? hopefully add something later on for this when choosing to flee

   
    cm:set_saved_value("lubu_flees_to_yuanshu",999)
    CusLog("we def set lubu_flees_to_yuanshu to nil =="..tostring( cm:get_saved_value("lubu_flees_to_yuanshu")))
    core:remove_listener("LuBuFleesToYuanShu")
    
     --Make Zhang Yang like him?
     ChangeRelations("3k_main_template_historical_lu_bu_hero_fire", "3k_main_template_historical_zhang_yang_hero_earth", "3k_main_relationship_trigger_set_scripted_event_generic_small")
	
	CusLog("### Finished YuanShuAcceptLuBu ###")
end

function CheckAnyArmiesInRegion(FactionName,RegionName)
    CusLog(tostring(FactionName).." Checking for any armies in region: "..tostring(RegionName))

    local qFaction= cm:query_faction(FactionName)
    if qFaction:is_null_interface() then 
        CusLog("factions null")
        return false
    end
    for i=0 , qFaction:military_force_list():num_items() -1 do 
        --CusLog("found force #"..tostring(i).." in faction "..qFaction:name())
         local m_force= qFaction:military_force_list():item_at(i)
         if(m_force:is_armed_citizenry()) then        --if(qgeneral:is_armed_citizenry()) then  -_Error here --has_garrison_residence
            --CusLog("found a garrison, do nothing")
         else
            local qgeneral= m_force:character_list():item_at(0)
            CusLog("Found a general"..tostring(qgeneral:generation_template_key()).." In region:"..tostring(qgeneral:region():name()))
            if qgeneral:region():name() == RegionName then 
                return true;
            end
         end
         
     end

     CusLog(FactionName.." Finished without any armies in region:".. RegionName)
end

function CheckYuanShuHasLand()
	CusLog("### Running CheckYuanShuHasLand ###")


	local regionName="3k_main_nanyang_resource_1"
	--Loop through his lands and determine the best one to give
	local qfaction = cm:query_faction("3k_main_faction_yuan_shu")
	local regionList = { };
    if qfaction:region_list() then
	    -- CusLog(qfaction:name().." Provinces Owned="..qfaction:faction_province_list():num_items())
	     for i = 0, qfaction:faction_province_list():num_items() - 1 do -- Go through each Province
		     local province_key = qfaction:faction_province_list():item_at(i);
		     --CusLog("$looking at Province #:"..tostring(i).."  ="..tostring(province_key))
		     for i = 0, province_key:region_list():num_items() - 1 do -- Go through each region in that province
			     --CusLog("$$looping: x" ..tostring(i))
			     local region_key = province_key:region_list():item_at(i);
			     if(not region_key:is_null_interface()) then 
			    	 local region_name = region_key:name()
			    	 --CusLog("$$Adding@: " .. region_name)
			    	 table.insert(regionList, region_name)
		    	 end
		     end	
	     end
    end
    
     if(#regionList >1) then 
        
        local region1= cm:query_region("3k_main_nanyang_resource_1")
        local region2= cm:query_region("3k_main_runan_resource_1")

        if region2:owning_faction():name()=="3k_main_faction_yuan_shu" then 
            CusLog("Passed 1")
           cm:set_saved_value("yuanshu_gives_lubu", "3k_main_runan_resource_1")
           regionName="3k_main_runan_resource_1"
           return true; -- ignored?
        elseif region2:owning_faction():name()=="3k_main_faction_yuan_shu" then 
            CusLog("Passed 2")
            cm:set_saved_value("yuanshu_gives_lubu", "3k_main_nanyang_resource_1")
            regionName="3k_main_nanyang_resource_1"
            return true; -- why wont this return?
        else
            CusLog("Passed else???")
            for i=1, #regionList do
		    	if regionList[i] ~= "3k_main_nanyang_captial" then
			    	cm:set_saved_value("yuanshu_gives_lubu", regionList[i])
			    else
			    	regionName =regionList[i];
			    end
		    end
         end
     else
        CusLog("..Yuan Shu Doesnt have enough regions to give, aborting")
        return false;
    end

	CusLog("..Going to give LuBu:"..tostring(regionName))
	cm:set_saved_value("yuanshu_gives_lubu", regionName) -- guess this will be a random region if he doesnt own nanyang resource_1
	
    CusLog("### Finished CheckYuanShuHasLand ###")
    return true;
end

function MoveLiuYao() --Doesnt seem to need to happen, CA moved him down there already, but still applies diplo
	CusLog("Begin MoveLiuYao")
	
	local qLiuYao= getQChar("3k_main_template_historical_liu_yao_hero_earth")
	--If hes not even alive, spawn emergent
	if qLiuYao:is_null_interface() then 
		--Register emergent faction TODO if tested pos 
	else
		if not qLiuYao:is_faction_leader() then 
			CusLog("..@WARNING: LiuYao is not a leader??");
		end
		--Else pick his ass up and move to JianYe
		local qregion_1=cm:query_region("3k_main_jianye_captial"); --TODO
		if not qregion_1:is_null_interface() then 
			if not qregion_1:owning_faction():name() == qLiuYao:faction():name() then 
				cm:modify_model():get_modify_region(qregion_1):settlement_gifted_as_if_by_payload(cm:modify_faction(qLiuYao:faction():name()))
			end
		end
		--Give him military access with AI wang lang, and AI yan baihu (make peace if have to)
		if cm:query_faction("3k_main_faction_wang_lang"):has_specified_diplomatic_deal_with("treaty_components_war",qLiuYao:faction()) then
			CusLog("..make peace LiuYao WangLAnger ")
			cm:apply_automatic_deal_between_factions("3k_main_faction_liu_yao","3k_main_faction_wang_lang", "data_defined_situation_peace",true)
			cm:apply_automatic_deal_between_factions("3k_main_faction_liu_yao","3k_main_faction_wang_lang", "data_defined_situation_proposer_peace_against_target",true)
			cm:apply_automatic_deal_between_factions("3k_main_faction_wang_lang","3k_main_faction_liu_yao", "data_defined_situation_proposer_peace_against_target",true) 
		end
		--Military access
		CusLog("..apply mil access WangLang")
		cm:apply_automatic_deal_between_factions(qLiuYao:faction():name(), "3k_main_faction_wang_lang", "data_defined_situation_military_access", true);
        cm:apply_automatic_deal_between_factions("3k_main_faction_wang_lang", qLiuYao:faction():name(), "data_defined_situation_military_access", true);
		
        CusLog("..check yanBaihu")
		local qYanB= getQChar("3k_main_template_historical_yan_baihu_hero_metal")
		if not qYanB:is_null_interface() then 
			if not qYanB:faction():is_human() and qYanB:is_faction_leader() then 
				if cm:query_faction(qYanB:faction():name()):has_specified_diplomatic_deal_with("treaty_components_war",qLiuYao:faction()) then
					CusLog("..make peace 2 ")
					cm:apply_automatic_deal_between_factions("3k_main_faction_liu_yao",qYanB:faction():name(), "data_defined_situation_peace",true)
					cm:apply_automatic_deal_between_factions("3k_main_faction_liu_yao",qYanB:faction():name(), "data_defined_situation_proposer_peace_against_target",true)
					cm:apply_automatic_deal_between_factions(qYanB:faction():name(),"3k_main_faction_liu_yao", "data_defined_situation_proposer_peace_against_target",true) 
				end
				CusLog("..apply mil access yanB")
				cm:apply_automatic_deal_between_factions(qLiuYao:faction():name(), qYanB:faction():name(), "data_defined_situation_military_access", true);
                cm:apply_automatic_deal_between_factions(qYanB:faction():name(), qLiuYao:faction():name(), "data_defined_situation_military_access", true);
		
            end
		end

	end
	
	 
	
	cm:set_saved_value("liuYao_moved",true);
	CusLog("Finished MoveLiuYao")
end

function MoveToShouchun(cityNo) --Need to make sure we move LiuYao to southEast now as u "take" this land from him
    CusLog("Running MoveToShouchun"..tostring(cityNo))
    local regionTotal=cityNo;

    --if AI yuan shu, teleport his armies there (give money)
    local qyuanshu_faction = cm:query_faction("3k_main_faction_yuan_shu")
    if(qyuanshu_faction:is_human()==false) then
            AbandonLands("3k_main_faction_yuan_shu") -- Human will have done via event
            CusLog("Yuan Shus faction has this many armies: "..qyuanshu_faction:military_force_list():num_items())
            if not qyuanshu_faction:military_force_list():is_empty() then -- this is not working..?
            for i=0 , qyuanshu_faction:military_force_list():num_items() -1 do 
                local m_force= qyuanshu_faction:military_force_list():item_at(i)
                if(m_force:is_armed_citizenry()) then        --if(qgeneral:is_armed_citizenry()) then  -_Error here --has_garrison_residence
					CusLog("found a garrison, break..")
                else
                    CusLog("found army")
                    local commander= m_force:character_list():item_at(0) 
                    CusLog("Teleporting Commander: "..tostring(commander:generation_template_key()))
                    local found_pos, x, y = qyuanshu_faction:get_valid_spawn_location_in_region("3k_main_yangzhou_capital", false);
                    cm:modify_model():get_modify_character(commander):teleport_to(x,y) 
                end
            end
				
            end
        cm:modify_faction(qyuanshu_faction:name()):increase_treasury(3200)
    else
        cm:modify_faction(qyuanshu_faction:name()):increase_treasury(500)
    end
    --find any non players controlled regions in yangzhou and give to yuan shu
    local qregion_1 = cm:query_region("3k_main_yangzhou_capital")
    local qregion_2 = cm:query_region("3k_main_yangzhou_resource_3")
    local qregion_3 = cm:query_region("3k_main_yangzhou_resource_2")
    local qregion_4 = cm:query_region("3k_main_yangzhou_resource_1")


    if qregion_1:owning_faction():is_human()==false and regionTotal ~=0  then 
        CusLog("..Giving "..qregion_1:name().." to yuanshu")
        cm:modify_model():get_modify_region(qregion_1):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_yuan_shu"))
        regionTotal= regionTotal-1;
    end
    if qregion_2:owning_faction():is_human()==false and regionTotal ~=0 then 
        CusLog("..Giving "..qregion_2:name().." to yuanshu")
        cm:modify_model():get_modify_region(qregion_2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_yuan_shu"))
        regionTotal= regionTotal-1;
    end
    if qregion_3:owning_faction():is_human()==false and regionTotal ~=0 then 
        CusLog("..Giving "..qregion_3:name().." to yuanshu")
        cm:modify_model():get_modify_region(qregion_3):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_yuan_shu"))
        regionTotal= regionTotal-1;
    end
    if qregion_4:owning_faction():is_human()==false and regionTotal ~=0 then 
        CusLog("..Giving "..qregion_4:name().." to yuanshu")
        cm:modify_model():get_modify_region(qregion_4):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_yuan_shu"))
        regionTotal= regionTotal-1;
    end



    --Trigger an incident about taking over the city (maybe for ai too?) (todo)
    local playersFactionsTable = cm:get_human_factions()
    local playerFaction = playersFactionsTable[1]
    cm:trigger_incident(playerFaction ,"3k_lua_yuanshu_enters_yangzhou", true)
    
	if cm:get_saved_value("liuYao_moved") ~=true then 
		MoveLiuYao()
	end 
	
    cm:set_saved_value("yuanshu_flees_shouchun",false)  --Player 
    cm:set_saved_value("yuanshu_moved_shouchun",true) -- used for AI events in other scripts (lubu)
    core:remove_listener("YuanShuEntersShouChun")
    core:remove_listener("YuanShuWiped")
    CusLog("Finished MoveToShouchun")
end

function ChengYuRebels()
    CusLog(" Running ChengYuRebels")
    local willRebel=false;
    local qchengyu= getQChar("3k_main_template_historical_cheng_yu_hero_water")
    if not qchengyu:is_null_interface() then 
        if qchengyu:is_dead()==false then 
            if qchengyu:faction():name() ~= "3k_main_faction_yuan_shu" then
                 CusLog("..cheng yu is not in yuan shus faction")
                 if qchengyu:faction():is_human() ==false then
                    willRebel=true
                 end
            elseif qchengyu:loyalty() <75 then
                CusLog("..chengyu lotalty <75")
                -- make sure yuan shus army isnt in nanyang
                local qyuanshu = getQChar("3k_main_template_historical_yuan_shu_hero_earth")
                if( qyuanshu:has_military_force()) then 
                    if qyuanshu:region():name() ~= "3k_main_nanyang_capital" then 
                        willRebel=true;
                    end
                else
                     willRebel=true
                end
            end
        end
    else
        CusLog("..@@chengyu is null???, will try to rebel anyway")
        willRebel=true
    end

    CusLog("..Passed cheng yu check with willrebel="..tostring(willRebel))

    if(willRebel) then
        --register emergent faction
        register_cheng_yu_emergent_faction_2() --Spawning triggers the dilemma for human yuan shu , or moves AI yuan shu
        cm:set_saved_value("SpawnChengYu", true);
        cm:set_saved_value("chengyu_can_rebel", false) --stop checking
        core:remove_listener("YuanShuAdmin");
    end



    CusLog(" Finished ChengYuRebels")

end

function YuanShuVsCaoCao()
    CusLog("Running YuanShuVsCaoCao")
    local qcaocao_faction = cm:query_faction("3k_main_faction_cao_cao")
    local zhangyan_faction = cm:query_faction("3k_main_faction_zhang_yan")

    -- Declare war 
    cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shu","3k_main_faction_cao_cao", "data_defined_situation_war_proposer_to_recipient",true)
    cm:apply_automatic_deal_between_factions("3k_main_faction_cao_cao","3k_main_faction_yuan_shu", "data_defined_situation_war_proposer_to_recipient",true)
    cm:apply_automatic_deal_between_factions("3k_main_faction_zhang_yan","3k_main_faction_cao_cao", "data_defined_situation_war_proposer_to_recipient",true)

    --miltary access free 
    cm:apply_automatic_deal_between_factions("3k_main_faction_zhang_yan","3k_main_faction_yuan_shu", "data_defined_situation_military_access",true)
   --See if we can get a coalition?
    cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shu","3k_main_faction_zhang_yan", "data_defined_situation_create_coalition",true)
   
    --Give CaoCao a boat load of cash - to fight back
    if (qcaocao_faction:is_human() == false) then 
		cm:modify_faction(qcaocao_faction:name()):increase_treasury(8500)
	end

    --Give zhang yan the 800 yen
     if (zhangyan_faction:is_human() == false) then 
		cm:modify_faction(zhangyan_faction:name()):increase_treasury(800)
    end
    --GlobalFunction
    SpawnBandits("3k_main_faction_zhang_yan", "3k_main_chenjun_resource_2", "3k_main_faction_cao_cao", 442, 421)
    cm:set_saved_value("chengyu_can_rebel", true)
    CusLog("Finished YuanShuVsCaoCao")
end

function BanditsVsYuanshu()
    CusLog(" Running BanditsVsYuanshu")
    SpawnBandits("3k_main_faction_zhang_yan", "3k_main_nanyang_resource_1", "3k_main_faction_yuan_shu", 442, 421)
    CusLog(" Finished BanditsVsYuanshu")
end

function CaoCaoNeedsProxyWar()
    CusLog("Running CaoCaoNeedsProxyWar")
    local qyuanshu = getQChar("3k_main_template_historical_yuan_shu_hero_earth")
    local qyuanshu_faction = qyuanshu:faction()
    local qcaocao_faction = cm:query_faction("3k_main_faction_cao_cao")

    if (qyuanshu_faction:treasury() >800) then 
     local needsproxbool = false;
        if(qyuanshu_faction:is_human()) then 
         CusLog("..yuanshu is player, fire dilemma")
            --fire dilemma
            YuanShu1ChoiceMadeListener()
            needsproxbool= cm:trigger_dilemma(qyuanshu_faction, "3k_lua_yuanshu_vs_caocao_dilemma", true) 
        elseif qcaocao_faction:is_human() then 
         CusLog("..qcaocao_faction is player, do nothing?") -- maybe one day
        else
          YuanShuVsCaoCao() -- do i even want to do this ? maybe Ai can handle it 
          needsproxbool=true;
         end

        if needsproxbool==true then -- if dilemma not triggered successfully, keep asking (CNDon treasury in db)
            cm:set_saved_value("cao_cao_needs_proxywar",false) --Stop the listener
            core:remove_listener("YuanshuCaoCaoProxy");
        else
            CusLog("..dilemma did not fire successfully, will try again")
        end
    else
    CusLog("Not enough money")
    end
    CusLog("..finished cao_cao_needs_proxywar")
end

function LiuBiaoSupplyCheck()
    CusLog("Running LiuBiaoSupplyCheck")
    local qyuanshu = getQChar("3k_main_template_historical_yuan_shu_hero_earth")
    local qyuanshu_faction = qyuanshu:faction()
    local qliubiao_faction = cm:query_faction("3k_main_faction_liu_biao")

    if(qliubiao_faction:is_human()) then 
        CusLog("..liubiao is player")
        --fire dilemma
        cm:trigger_dilemma(qliubiao_faction, "3k_lua_liubiao_cut_supplies_dilemma", true) -- TO:DO create in pack 
        CusLog("..fired for player")
    elseif qyuanshu_faction:is_human() then 
        CusLog("..yuanshu is player")
        --fire incident
        cm:trigger_incident(qyuanshu_faction,"3k_lua_yuanshu_cut_supplies", true ) 
        CusLog("..fired for player")
        TakeSupplies()
    else
        TakeSupplies()
    end
    cm:set_saved_value("liubiao_cut_supplies",true) -- in listener callback also cuz callbacks suck
    CusLog("..finished supply check")
end

function TakeSupplies()
    cm:apply_effect_bundle("3k_main_payload_character_liu_biao_supplies", "3k_main_faction_yuan_shu" , 4)
    CusLog("..applied supply bundle effect")
end

function YuanShuVanillaEvent(eventName, isDilemma)
	local qyuanshao_faction = cm:query_faction("3k_main_faction_yuan_shu")
	local triggered=false;
	if(isDilemma==true) then 
		triggered=cm:trigger_dilemma(qyuanshao_faction, eventName, true) 
	else
		triggered=cm:trigger_incident(qyuanshao_faction, eventName, true) 
	end
	
	CusLog("YuanShu Event Triggered="..tostring(triggered))
	return triggered;
end

function SetUpAdmin() --Used By YuanShao As Well give to player and AI (ChengYu will come out of nowhere if 182 start.. but can fix later)
    CusLog("..SetUp Yuan Shus Admin")
    local qchengyu= getQChar("3k_main_template_historical_cheng_yu_hero_water")
    if not qchengyu:is_null_interface() then 
        if qchengyu:faction():name() ~= "3k_main_faction_yuan_shu" then
            CusLog("..moving chengyu to yuanshu")
            MoveCharToFaction("3k_main_template_historical_cheng_yu_hero_water", "3k_main_faction_yuan_shu")
        end
    else
        CusLog("..chengyu is null, spawning in for yuan shu")
        cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_yuan_shu", "3k_general_water", "3k_main_template_historical_cheng_yu_hero_water");
    end
    CusLog("..chengyu is inyuanshus faction")

    local mchar =getModifyChar("3k_main_template_historical_cheng_yu_hero_water")
    if(not mchar:is_null_interface() ) then 
       CusLog("..trying to make him admin...")
       -- mchar:assign_to_post("ministerial_position_cultural_variant"); --Fix this?
        mchar:add_loyalty_effect("presented_gift");
    end
  
    CusLog("..finished setting up Chengyu...")
    cm:set_saved_value("SpawnZhouXin",true)
    CusLog("..set value to spawn ZhouXin")
    register_zhou_xin_emergent_faction_2()
end

-------------------------------------------------------------------------

-------------------------------------------------------------------------
-----------------------------LISTNERS------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------


function YuanShuAiMovesListener() -- AI
    CusLog("### YuanShuAiMovesListener loading ###")
    core:remove_listener("YuanShuWiped")
	core:add_listener(
		"YuanShuWiped",
		"CampaignBattleLoggedEvent",
		function(context)
            if context:query_model():date_in_range(193,199) then
                if (context:query_model():pending_battle():has_been_fought()) then 
                    local log_entry = context:log_entry()
                    for i=0, log_entry:losing_faction():num_items()-1 do
                        local faction = log_entry:item_at(i)
                        CusLog("YuanShuWiped:..found losing faction "..faction:name())
                        if(faction:name()=="3k_main_yuan_shu") then 
                            return true;
                        end
                    end
                end
            end
            return false;
		end,
        function(context)
            CusLog("???CallBack: YuanShuAiMovesListener ###")
            MoveToShouchun(3) -- here to avoid callback delay and lose campaign
        end,
		true
    )
end

function YuanShuEntersShouChunListener()
    CusLog("### YuanShuEntersShouChunListener loading ###")
    core:remove_listener("YuanShuEntersShouChun")
	core:add_listener(
		"YuanShuEntersShouChun",
		"CharacterFinishedMovingEvent",
		function(context)
            if cm:get_saved_value("yuanshu_flees_shouchun")==true then
                if context:query_character():faction():name()== "3k_main_faction_yuan_shu" then 
                    local qchar= context:query_character();
                    if qchar:region():name() == "3k_main_yangzhou_capital"   
                    or qchar:region():name() == "3k_main_yangzhou_resource_1"
                    or qchar:region():name() == "3k_main_yangzhou_resource_2"
                    or qchar:region():name() == "3k_main_yangzhou_resource_3" then 
                        CusLog("Yuan Shu makes it to ShouChun, return true")
                        return true;
                    end
                end
            end
            return false;
		end,
        function(context)
            CusLog("### passed YuanShuEntersShouChun ###")
            MoveToShouchun(4)
        end,
		true
    )
end


function YuanShu3ChoiceMadeListener()
    CusLog("### YuanShu3ChoiceMadeListener loading ###")
    core:remove_listener("DilemmaChoiceMadeYuanshu3")
    core:add_listener(
    "DilemmaChoiceMadeYuanshu3",
    "DilemmaChoiceMadeEvent",
    function(context)
        CusLog("..Listening for 3k_lua_yuanshu_takes_lubu choice ")
        return context:dilemma() == "3k_lua_yuanshu_takes_lubu"  -- TO Do???
    end,
    function(context)
        CusLog("..! choice was:" .. tostring(context:choice()))
        if context:choice() == 0 then
            YuanShuAcceptLuBu()
            --Could RNG this if we wanted , maybe he stays?
            if RNGHelper(7) then 
                cm:set_saved_value("lu_bu_to_yingchuan", true)
                register_lu_bu_emergent_faction_2()
            end
            cm:set_saved_value("Yuanshu_TookLuBu", true)
		else
			--resetup so he emerges in PuYang? Can the player keep him at all?
			local qyuanshao_faction = cm:query_faction("3k_main_faction_yuan_shao")
			if(qyuanshao_faction:is_human()) then 
				--Send to Yuan Shao
			else
				cm:set_saved_value("lubu_flees_to_yuanshu",false)
				register_lu_bu_emergent_faction_2()
				cm:set_saved_value("lu_bu_to_yingchuan", true)
			end
        end
         core:remove_listener("DilemmaChoiceMadeYuanshu3");
    end,
    true
 );
end

function YuanShu2ChoiceMadeListener() -- I want to add a path where if player chose to stay and fight, and gave lubu land, he will have an option to confederate lubu or become his vassal or something.
    CusLog("### YuanShu2ChoiceMadeListener loading ###")
    core:remove_listener("DilemmaChoiceMadeYuanshu2")
    core:add_listener(
    "DilemmaChoiceMadeYuanshu2",
    "DilemmaChoiceMadeEvent",
    function(context)
        CusLog("..Listening for 3k_lua_yuanshu_loses_nanyang choice ")
        return context:dilemma() == "3k_lua_yuanshu_loses_nanyang"  
    end,
    function(context)
        CusLog("..! choice was:" .. tostring(context:choice()))
        if context:choice() == 0 then
            cm:set_saved_value("yuanshu_flees_shouchun",true) -- listen for him entering yangzhou
            AbandonLands("3k_main_faction_yuan_shu");
            --Check # of armies
            local qyuanshu_faction = cm:query_faction("3k_main_faction_yuan_shu")
            local regionSelected="3k_main_nanyang_resource_1"
            if qyuanshu_faction:military_force_list():num_items() ==0 then --fail safe
                --give him shouchun but only 1 province and some cash
                CusLog("..triggering MoveToShouchun fail safe")
                MoveToShouchun(1)
                cm:modify_faction(qyuanshu_faction:name()):increase_treasury(1000)
                 regionSelected="3k_main_yangzhou_capital"
            else
                YuanShuEntersShouChunListener()
                CusLog("Yuan shu has forces")
            end
            local qyuanshu=getQChar('3k_main_template_historical_yuan_shu_hero_earth') -- cant be null, that wud be nuts
            CusLog("Got YuanShu")
            if not qyuanshu:is_null_interface() then 
                if not qyuanshu:has_military_force() then 
                    CusLog("..! Yuanshu has no army, attempting to deploy")
                    local found_pos, x, y = qyuanshu_faction:get_valid_spawn_location_in_region(regionSelected, false);
                    local unit_list="3k_main_unit_fire_mercenary_cavalry_captain,3k_main_unit_metal_rapid_tiger_infantry,3k_main_unit_metal_rapid_tiger_infantry,3k_main_unit_metal_sabre_infantry"
                    cm:create_force_with_existing_general(qyuanshu:cqi(), "3k_main_faction_yuan_shu", unit_list, regionSelected, x, y,"3kyuanshu_01",nil, 100);
                end
            end
            --give yuan shu effect bundle
            CusLog("applying Effects 1")
             cm:modify_model():get_modify_faction(qyuanshu_faction):apply_effect_bundle("3k_dlc04_effect_bundle_free_force",3)
             CusLog("applying Effects 2")
             cm:apply_effect_bundle("3k_main_payload_faction_regionless_movement", "3k_main_faction_yuan_shu" , 3)   
             
             if cm:get_saved_value("Yuanshu_TookLuBu") then  --if we took in lubu, and chose to flee, he should too 
                cm:set_saved_value("lu_bu_to_yingchuan", true)
                register_lu_bu_emergent_faction_2()
            end

            CusLog(" finished choice 0")
        end
        CusLog("Finished")
         core:remove_listener("DilemmaChoiceMadeYuanshu2");
    end,
    true
 );
end

function YuanShu1ChoiceMadeListener()
    CusLog("### YuanShu1ChoiceMadeListener loading ###")
    core:remove_listener("DilemmaChoiceMadeYuanshu1")
    core:add_listener(
    "DilemmaChoiceMadeYuanshu1",
    "DilemmaChoiceMadeEvent",
    function(context)
        CusLog("..Listening for 3k_lua_yuanshu_vs_caocao_dilemma choice ")
        return context:dilemma() == "3k_lua_yuanshu_vs_caocao_dilemma"  
    end,
    function(context)
        CusLog("..! choice was:" .. tostring(context:choice()))
        if context:choice() == 0 then
            YuanShuVsCaoCao() --Enables setting so cheng yu will rebel
        else 
            BanditsVsYuanshu()
        end
         core:remove_listener("DilemmaChoiceMadeYuanshu1");
    end,
    true
 );
end



function YuaShuPlayerFleesListener() --Opt2 for Player yuanShu to move ( also handled in chengyu emerges) (year 193+)
        CusLog("### YuaShuPlayerFleesListener loading ###")
        core:remove_listener("YuaShuPlayerFlees")
        core:add_listener(
            "YuaShuPlayerFlees",
            "FactionTurnStart", -- Does this call back happen?
            function(context)
                if cm:get_saved_value("yuanshu_flees_shouchun")==nil and context:faction():is_human() and context:faction():name() == "3k_main_faction_yuan_shu"  and context:query_model():calendar_year() >=193  then 
                    CusLog(" going to count regions YuaShuPlayerFleesListener ")
                    if CountRegions("3k_main_faction_yuan_shu") < 2 then 
                        return true; 
                    end
                end
                return false;
            end,
            function(context)
                CusLog("??? Callback: YuaShuPlayerFleesListener ###")
                CusLog("..Fire dilemma for player yuanshu, do i need to set anything?")
                YuanShu2ChoiceMadeListener()
                cm:trigger_dilemma("3k_main_faction_yuan_shu", "3k_lua_yuanshu_loses_nanyang",true) -- if it didnt fire already its fine
                CusLog("### Passed: YuaShuPlayerFleesListener ###")
            end,
            true
        )
end


function ChengYuRebelsListener()  --AI and PLayer 
    CusLog("### ChengYuRebelsListener loading ###")
    core:remove_listener("ChengYuRebels")
	core:add_listener(
		"ChengYuRebels",
		"FactionTurnStart", --yes Works 
		function(context)
            if cm:get_saved_value("chengyu_can_rebel") and context:faction():is_human() then 
                local rolled_value = cm:random_number( 0, 5 );
                local to_beat=3;
                CusLog("..ChengYu Rebels Rolled a "..rolled_value.." needs "..to_beat.." to pass")
                if rolled_value > to_beat then 
                    CusLog("CHECK IF CALLBACK WORKS:")
					return true
                end
            elseif context:faction():name()=="3k_main_faction_yuan_shu" and not context:faction():is_human() then 
                local qyuan_shu =getQChar("3k_main_template_historical_yuan_shu_hero_earth")
                if(context:calendar_year()==193 and qyuan_shu:is_faction_leader()) and cm:get_saved_value("yuanshu_moved_shouchun")~=true then 
                    local rolled_value = cm:random_number( 0, 6 );
                    local to_beat=3;
                    CusLog("..(AI)ChengYu Rebels Rolled a "..rolled_value.." needs "..to_beat.." to pass")
                    if rolled_value > to_beat then 
						return true -- Ai yuan Shu moves
                    end
                end
            end
            return false;
		end,
		function(context)
			CusLog("??? Callback: ChengYuRebelsListener ###")
            ChengYuRebels()
            CusLog("### Passed: ChengYuRebelsListener ###")
		end,
		true
    )
end

function AILuBuFleesToYuanShuListener() -- i guess LuBu is already a leader? how does this work, wang yun should be leader?
    CusLog("### AILuBuFleesToYuanShuListener loading ###")
    core:remove_listener("LuBuFleesToYuanShu")
	core:add_listener(
		"LuBuFleesToYuanShu",
		"FactionTurnStart",
		function(context)
            if cm:get_saved_value("lubu_flees_to_yuanshu")~=nil and context:faction():is_human() then 
                CusLog(" lubu_flees_to_yuanshu="..tostring(cm:get_saved_value("lubu_flees_to_yuanshu")))
                if  context:query_model():calendar_year() < 194 and context:query_model():turn_number() >= cm:get_saved_value("lubu_flees_to_yuanshu") then 
					local rolled_value = cm:random_number( 0, 5 );
					local to_beat=2;
					CusLog("Ai LuBu Showsup to Yuanshu Rolled a "..rolled_value.." needs "..to_beat.." to pass")
					if rolled_value > to_beat and CheckYuanShuHasLand() then -- only if we have enough land to give
						return true
					end
				elseif context:query_model():calendar_year() >= 194 then  -- its too late make lu bu an emergent faction
					cm:set_saved_value("lubu_flees_to_yuanshu",999)
					register_lu_bu_emergent_faction_2()
                    cm:set_saved_value("lu_bu_to_yingchuan", true) --SAFE this wont keep getting set becuz first tick doesnt check via year 
                    --Dont remove listeners!
				end
			end
            return false;
		end,
		function(context)
            CusLog("??? Callback: AILuBuFleesToYuanShuListener ###")
            --Trigger Dilemma
			YuanShu3ChoiceMadeListener()
			local qyuanshu_faction= cm:query_faction("3k_main_faction_yuan_shu")
            local triggered =cm:trigger_dilemma(qyuanshu_faction, "3k_lua_yuanshu_takes_lubu"); 
            if triggered then 
                cm:set_saved_value("lubu_flees_to_yuanshu",999)
            else
                CusLog("..didnt fire?")
            end
            CusLog("### Passed AILuBuFleesToYuanShuListener ###")
		end,
		true
    )
end

function YuanshuCaoCaoProxyWarListener() -- if yuan shus commanding , has to be in garrison, if not, army just has to be in region
    CusLog("### YuanshuCaoCaoProxyWarListener loading ###")
    core:remove_listener("YuanshuCaoCaoProxy")
	core:add_listener(
		"YuanshuCaoCaoProxy",
		"FactionTurnStart", -- doesnt work on end turn call back? idk
		function(context)
            if context:query_model():calendar_year() > 191 and context:query_model():turn_number() >9 and context:faction():is_human() then 
                CusLog("..listening, does cao_cao_needs_proxywar  ="..tostring(cm:get_saved_value("cao_cao_needs_proxywar")))
                if cm:get_saved_value("cao_cao_needs_proxywar") ==true then
                    local qcaocao_faction = cm:query_faction("3k_main_faction_cao_cao")
                	local chen_region =cm:query_region("3k_main_chenjun_resource_2") 
			        if chen_region:owning_faction():is_human()==false and chen_region:owning_faction():name() == qcaocao_faction:name() then			 
                        --need to add a check that yuan shu has an army in nanyang iron mine /chengjun farm to be close enough to the invading bandits hired
                        local nanyang_region =cm:query_region("3k_main_nanyang_resource_1")
                        local runan_region =cm:query_region("3k_main_runan_resource_1")
                        local qyuanshu= getQChar("3k_main_template_historical_yuan_shu_hero_earth")
                        if(qyuanshu:has_military_force()) then 
                           if(qyuanshu:in_settlement() and qyuanshu:region():name()== "3k_main_nanyang_resource_1" ) then
                                CusLog("..yuanShus army is in nanyang iron mine!, trigger dilemma")
                                local TurnNo= cm:get_saved_value("lubu_flees_to_yuanshu")
                                return (TurnNo==nil or TurnNo==999 ); -- will wait for lu bu if hes on his way
                           elseif(qyuanshu:in_settlement() and qyuanshu:region():name()== "3k_main_runan_resource_1" ) then
                                CusLog("..yuanShus army is garrisoned in runan ironmine!, trigger dilemma")
                                local TurnNo= cm:get_saved_value("lubu_flees_to_yuanshu")
                                return (TurnNo==nil or TurnNo==999 ); -- will wait for lu bu if hes on his way
                           elseif(qyuanshu:region():name()== "3k_main_chenjun_resource_2" ) then
                                CusLog("..yuanShus army is in chen!, trigger dilemma")
                                local TurnNo= cm:get_saved_value("lubu_flees_to_yuanshu")
                                return (TurnNo==nil or TurnNo==999 ); -- will wait for lu bu if hes on his way
                           else
                            CusLog("..yuan shus army is not in the right place")
                           end
                        else 
                            CusLog(" yuan shu doesnt have amilitary force, hes not commanding?")
                            --Instead check if theres another army in the region, thats not a garrison:
                            if CheckAnyArmiesInRegion("3k_main_faction_yuan_shu", "3k_main_nanyang_resource_1")
                                or  CheckAnyArmiesInRegion("3k_main_faction_yuan_shu", "3k_main_runan_resource_1")
                                    or  CheckAnyArmiesInRegion("3k_main_faction_yuan_shu", "3k_main_chenjun_resource_2") then 
                                        CusLog(" Found an army in one of the dope regions1 ")
                                        local TurnNo= cm:get_saved_value("lubu_flees_to_yuanshu")
                                        local chance= (TurnNo==nil or TurnNo==999 )
                                        CusLog("THE CHANCE="..tostring(chance))
                                        return chance ; -- will wait for lu bu if hes on his way
                                    end
                            CusLog("..fell through?")
                        end
                    end
                end 
            end
            return false;
		end,
        function(context)
            CusLog("??? Callback: YuanshuCaoCaoProxyWarListener ###")
            CaoCaoNeedsProxyWar()
			--Okay the saved value isnt set here, for a reason
            CusLog("### Passed YuanshuCaoCaoProxyWarListener ###")
		end,
		true
    )
end

function YuanshuCaoCaoFarmListener() --Player 190 only 
    CusLog("### YuanshuCaoCaoFarmListener loading ###")
    core:remove_listener("YuanshuCaoCaoFarm")
	core:add_listener(
		"YuanshuCaoCaoFarm",
		"FactionTurnStart",
		function(context)
            if context:query_model():calendar_year() > 189 and context:faction():is_human() and context:faction():name() =="3k_main_faction_yuan_shu" then 
                if context:query_model():turn_number() >3 and context:query_model():turn_number() <7 then -- wont work for 182
                    CusLog("..YuanshuCaoCaoFarmListener")
                	local chen_region =cm:query_region("3k_main_chenjun_resource_2") 
			        if chen_region:owning_faction():is_human()==false and chen_region:owning_faction():name() ~= "3k_main_faction_cao_cao" then			 
				        cm:modify_model():get_modify_region(chen_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_cao_cao")) 
                        CusLog("..Gave CaoCao Chen")
                        return true
					elseif chen_region:owning_faction():name() == "3k_main_faction_cao_cao" then 
						CusLog("..CaoCao had Chen")
						return true;
                    end
                end
            end
            return false;
		end,
		function(context)
			CusLog("??? Callback: YuanshuCaoCaoFarmListner ###")
            cm:set_saved_value("cao_cao_needs_proxywar",true)
		end,
		false
    )
end

function YuanShuResponseListener()
    CusLog("### YuanShuResponseListener loading ###")
    core:remove_listener("YuanShuResponse")
	core:add_listener(
		"YuanShuResponse",
		"FactionTurnEnd", --Callback not working anymore? it used to wtf
		function(context)
            if context:faction():is_human() then 
               if(cm:get_saved_value("liubiao_cut_supplies") ==true and cm:get_saved_value("yuanshu_responded")~=true ) then 
                    return true
               elseif cm:get_saved_value("yuanshu_responded")==true then 
                   -- CusLog("already responded,  Do not try to be efficent and remove core listener here or crash.. YuanShuResponseListener")
                 end
            end
            return false;
		end,
		function(context)
			CusLog("??? Callback: YuanShuResponseListener Callback ###")
            local triggered=cm:trigger_dilemma("3k_main_faction_yuan_shu", "3k_lu_tutorial_progression_yuan_shu_primary_overwrite" , true )
            cm:set_saved_value("yuanshu_responded",triggered) -- dont know what happens if this triggers, you enter a battle on another AIs end turn, or u exit campaign on quicksave
            if triggered then 
                core:remove_listener("YuanShuResponse");
            end
            CusLog("### Passed YuanShuResponseListener ### ="..tostring(triggered))
		end,
		true
    )
end

function LiuBiaoSuppliesListener()
    CusLog("### LiuBiaoSuppliesListener loading ###")
    core:remove_listener("LiuBiaoSupplies1")
	core:add_listener(
		"LiuBiaoSupplies1",
		"FactionTurnEnd", --Callback not working anymore? it used to wtf
        function(context)
            --CusLog("..listening for LiuBiaoSuppliesListener"..tostring(context:faction():name()))
            if context:query_model():calendar_year() > 189 and context:query_model():calendar_year() < 193 and context:faction():name() == "3k_main_faction_liu_biao" then 
               if(cm:get_saved_value("liubiao_cut_supplies") ~=true) then 
                    local rolled_value = cm:random_number( 0, 5 );
                    local to_beat=3;
                    CusLog("..LiuBiao Supply Rolled a "..rolled_value.." needs "..to_beat.." to pass")
                    if rolled_value > to_beat then 
                       -- LiuBiaoSupplyCheck() --crap wont call back
                        return true
                    end
               end
            end
            return false;
		end,
		function(context)
			CusLog("??? Callback: LiuBiaoSuppliesListener Callback ###")
            LiuBiaoSupplyCheck()
			cm:set_saved_value("liubiao_cut_supplies",true)
            core:remove_listener("LiuBiaoSupplies1");
            CusLog("### Passed LiuBiaoSuppliesListener ###")
		end,
		true
    )
end

function YuanShuAdminListener()
    CusLog("### YuanShuAdminListener loading ###")
    core:remove_listener("YuanShuAdmin")
	core:add_listener(
		"YuanShuAdmin",
		"FactionTurnStart",
		function(context)
            if context:query_model():calendar_year() == 190 and context:faction():is_human() and cm:get_saved_value("Admin_set")~=true then 
                if context:query_model():turn_number() >20 or context:query_model():turn_number() == 1 then
                    return true
                else
                    --CusLog("turn # wrong,Do not try to be efficent and remove core listener here YuanShuAdmin ")
                end
            end
            return false;
		end,
		function(context)
			CusLog("### Passed YuanShuAdminListener ###")
            SetUpAdmin()
			cm:set_saved_value("Admin_set",true)
			core:remove_listener("YuanShuAdmin");
		end,
		true
    )
end

local function YuanShuEarlyVariables()
    CusLog("Debug: YuanShuEarlyVariables")
	
	 CusLog("  YuanShuEarly Admin_set= "..tostring(cm:get_saved_value("Admin_set")))
   
     CusLog("  YuanShuEarly liubiao_cut_supplies= "..tostring(cm:get_saved_value("liubiao_cut_supplies")))
     CusLog("  YuanShuEarly yuanshu_responded= "..tostring(cm:get_saved_value("yuanshu_responded")))

     CusLog("  YuanShuEarly chengyu_can_rebel= "..tostring(cm:get_saved_value("chengyu_can_rebel")))
     CusLog("  YuanShuEarly Yuanshu_TookLuBu= "..tostring(cm:get_saved_value("Yuanshu_TookLuBu")))
     CusLog("  YuanShuEarly cao_cao_needs_proxywar= "..tostring(cm:get_saved_value("cao_cao_needs_proxywar")))
     CusLog("  YuanShuEarly lubu_flees_to_yuanshu= "..tostring(cm:get_saved_value("lubu_flees_to_yuanshu")))

	 
	 CusLog("  YuanShuEarly yuanshu_flees_shouchun= "..tostring(cm:get_saved_value("yuanshu_flees_shouchun")))
     CusLog("  YuanShuEarly yuanshu_moved_shouchun= "..tostring(cm:get_saved_value("yuanshu_moved_shouchun")))

    

 end

function YuanShuEarlyIni() --if yuan shu is player initialize the script variables
    cm:set_saved_value("liubiao_cut_supplies",false)
    local curr_faction =cm:query_faction("3k_main_faction_yuan_shu")
    cm:set_saved_value("chengyu_can_rebel",false)
	if curr_faction:is_human() then
		cm:set_saved_value("cao_cao_needs_proxywar",false)
		--cm:set_saved_value("yuan_shu_vanilla_1",false)
		--cm:set_saved_value("yuan_shu_vanilla_2",false)
		cm:set_saved_value("yuan_shu_is_human",true) -- might be useful to use this check
	else
		cm:set_saved_value("yuan_shu_is_human",false)
	end
end

-- when the game loads run these functions:
cm:add_first_tick_callback(
    function(context)
        IniDebugger()
		 YuanShuEarlyVariables()
        if context:query_model():turn_number() ==1 then --set up this scripts initial values
           YuanShuEarlyIni()
        end

        if context:query_model():calendar_year() > 189 and context:query_model():calendar_year() < 195 then
            LiuBiaoSuppliesListener()
            ChengYuRebelsListener() -- can move AI to shouchoun
            if( cm:get_saved_value("yuan_shu_is_human")) then 
                YuanShuAdminListener()
                YuanShuResponseListener()
                YuanshuCaoCaoFarmListener()
                YuanshuCaoCaoProxyWarListener()
                AILuBuFleesToYuanShuListener() -- just listen regardless 
                YuaShuPlayerFleesListener()

            end

        end
        if context:query_model():date_in_range(193,199) and cm:get_saved_value("yuan_shu_is_human")==false then
            if(cm:get_saved_value("yuanshu_moved_shouchun")~=true) then 
                YuanShuAiMovesListener() -- having two ways to move him might be bad?
            end
        end

        if cm:get_saved_value("yuanshu_flees_shouchun")==true then 
            YuanShuEntersShouChunListener()
            --YuanShuWipedListener() --doesnt work
        end
        
        
       -- CusLog("TMP YUAN SHU MONEY")
        --cm:modify_faction("3k_main_faction_yuan_shu"):increase_treasury(8600)
		--TEST 
		--CusLog("TEST TMP RELATION:")
		--ChangeRelations("3k_main_template_historical_yuan_shu_hero_earth", "3k_main_template_historical_lu_bu_hero_fire", "3k_main_relationship_trigger_set_scripted_event_generic_large") 
       
    end
)

