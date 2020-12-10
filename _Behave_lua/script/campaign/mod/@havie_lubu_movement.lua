---> LuBus Movement post dong zhuo (player)
-- this mod is responsible for the player lu bus faction mechanic 
-- the movement he has from yuan shu, to yuan shao, to zhang yang 
-- taking pu yang from cao cao and acquiring zhang miao and chen gong

local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_lubu_movement.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
        local header=" (lubu_movement): "
		local line= time..header..text
		file:write(line.."\n")
        file:close()
       ModLog(header..text)
    end
end

local function IniDebugger()
	printStatements=true;
    local file = io.open("@havie_lubu_movement.txt", "w+")
    file:close()
	CusLog("---Begin File----")
end


--3k_dlc05_effect_bundle_granted_sanctuary

function ResetLuBusMovement() 
   CusLog("Resetting LuBus movement")
    local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
    if( not qlubu:is_null_interface())then
        if(qlubu:has_military_force() )then 
            for i = 0, qlubu:military_force():character_list():num_items()  - 1 do
                local character= qlubu:military_force():character_list():item_at(i);
                cm:modify_character(character):replenish_action_points()
               CusLog("....reset-->"..character:generation_template_key())
                if(RNGHelper(2) )then 
                        CusLog("...Calling Reset again because sometimes doesnt work...")
                        ResetLuBusMovement()
                    return;
                end

            end
        end      
    end
    CusLog("...Reset LuBus movement!")
end


function TakePuYang()
	--This is for Player LuBu 
	local qlubu=getQChar("3k_main_template_historical_lu_bu_hero_fire")
	local qlubu_faction= qlubu:faction();
	local qcaocao_faction = cm:query_faction("3k_main_faction_cao_cao")
	local qzhangMiao = getQChar("3k_main_template_historical_zhang_miao_hero_water")
    local qchenGong= getQChar("3k_main_template_historical_chen_gong_hero_water")
    local qyuanshao_faction= cm:query_faction("3k_main_faction_yuan_shao")
	
     local yingchuan_region =cm:query_region("3k_main_yingchuan_resource_1")
     
     CusLog("..check vassalship status of lu bu and zhang yangand yuan shao")
    --undo vassalship with zhang yang 
    local qzhangyang_faction = cm:query_faction("3k_main_faction_zhang_yang")
    local qyuanshao_faction = cm:query_faction("3k_main_faction_yuan_shao")
    if cm:query_faction("3k_main_faction_dong_zhuo"):has_specified_diplomatic_deal_with("treaty_components_vassalage",qzhangyang_faction) then
       CusLog("..we are vassal, must undo(1)")
       -- cm:apply_automatic_deal_between_factions("3k_main_faction_zhang_yang","3k_main_faction_dong_zhuo", "data_defined_situation_support_independence_offer",true)
        CusLog("...indepence1")
        cm:apply_automatic_deal_between_factions("3k_main_faction_zhang_yang","3k_main_faction_dong_zhuo", "data_defined_situation_vassal_declares_independence",true)
       CusLog("...declared1")
        cm:apply_automatic_deal_between_factions("3k_main_faction_zhang_yang", "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
       CusLog("...peace1")
        cm:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo", "3k_main_faction_zhang_yang", "data_defined_situation_peace", true);
    elseif cm:query_faction("3k_main_faction_dong_zhuo"):has_specified_diplomatic_deal_with("treaty_components_vassalage",qyuanshao_faction) then --WHY CANT I UNDO VASSALSHIP?
        CusLog("..we are vassal, must undo (2)")
        cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shao","3k_main_faction_yuan_shao", "data_defined_situation_vassal_declares_independence",false)
        cm:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo","3k_main_faction_dong_zhuo", "data_defined_situation_vassal_declares_independence",false)
        cm:modify_faction(qlubu_faction):apply_automatic_diplomatic_deal("data_defined_situation_vassal_declares_independence", qyuanshao_faction, "");   
       
       CusLog("...indepence 2")
        cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shao","3k_main_faction_yuan_shao", "data_defined_situation_support_independence_demand",false)
        cm:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo","3k_main_faction_dong_zhuo", "data_defined_situation_support_independence_demand",false)
        CusLog("...indepence 2.5")
        cm:modify_faction(qlubu_faction):apply_automatic_diplomatic_deal("data_defined_situation_war", qyuanshao_faction, "");   
       CusLog("...indepence 2.57")
        campaign_manager:force_declare_war("3k_main_faction_yuan_shao", "3k_main_faction_dong_zhuo", false)
        cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shao","3k_main_faction_dong_zhuo", "data_defined_situation_war",true) --idk why this has to be for yuan but not the other
        cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shao","3k_main_faction_dong_zhuo", "data_defined_situation_proposer_war_against_target",false) --idk why this has to be for yuan but not the other
        cm:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo","3k_main_faction_yuan_shao", "data_defined_situation_proposer_war_against_target",false) --idk why this has to be for yuan but not the other
        cm:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo","3k_main_faction_yuan_shao", "data_defined_situation_war",true) --idk why this has to be for yuan but not the other
        CusLog("...declared 2")
        cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shao", "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
        CusLog("...peace 2")
        cm:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo", "3k_main_faction_yuan_shao", "data_defined_situation_peace", true);
        cm:set_saved_value("doublecheck_vassal",true)
        VassalsBuggedistener()
    end
        CusLog("passed vassal status")


	
	
	-- move chen gong into player faction regardless  
	if(not qchenGong:is_null_interface()) then 
		CusLog(".. moving qchenGong to lubu")
		MoveCharToFactionHard("3k_main_template_historical_chen_gong_hero_water", qlubu_faction:name())
		else
		CusLog("@@!!..somehow chen going isnt spawned?? spawn him in lu bu faction...")
		 cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_dong_zhuo", "3k_general_water", "3k_main_template_historical_chen_gong_hero_water");
    end
    --Trigger a follow up incident that improves relations
     cm:trigger_incident(qlubu_faction,"3k_lua_lubu_friends_chengong", true )
    
    local mChenGong= getModifyChar("3k_main_template_historical_chen_gong_hero_water")
    if not mChenGong:is_null_interface() then 
        mChenGong:add_loyalty_effect("data_lu_bu_inspire")
        mChenGong:add_loyalty_effect("extraordinary_success");
        mChenGong:add_loyalty_effect("recently_promoted");
    end
	
	-- 
    MoveLuBusExistingFaction()
    
    --TMP TEST
   -- MoveCharToFaction("3k_main_template_historical_zhang_miao_hero_water", "3k_main_faction_liu_dai")
	
    
    local confederatedZhangMiao=false;
	--if Zhang Miao owns yingchuan (confederate him)  --Trigger a follow up incident that improves relations 
	if( not qzhangMiao:is_null_interface() ) then 
		if( yingchuan_region:owning_faction():name() == qzhangMiao:faction():name()) then 
			CusLog("..LuBu confederating zhang miao")
			 cm:modify_faction(qlubu_faction):apply_automatic_diplomatic_deal("data_defined_situation_peace", qzhangMiao:faction(), "");
             cm:force_confederation("3k_main_faction_dong_zhuo","3k_main_faction_liu_dai")
             confederatedZhangMiao=true;
             --IF zhang miao left, but his ass back
             qzhangMiao = getQChar("3k_main_template_historical_zhang_miao_hero_water")
             if(qzhangMiao:faction():name() ~= qlubu_faction:name()) then 
                MoveCharToFactionHard("3k_main_template_historical_zhang_miao_hero_water", qlubu_faction:name())
            end
		else 	-- else move him into lu bus faction regardless
            CusLog("..@ uh-oh zhang miao faction name= "..qzhangMiao:faction():name())
            CusLog("..@ zhang miao doesnt own chenliu, but well move him in to lubus faction anyway")
			MoveCharToFaction("3k_main_template_historical_zhang_miao_hero_water", qlubu_faction:name())
		end
        --Trigger a follow up incident that improves relations 
       cm:trigger_incident(qlubu_faction,"3k_lua_lubu_friends_zhangmiao", true )
       cm:set_saved_value("lubu_knows_zhangmiao", true) -- set again here just in case	, has to be under movelubufaction()--> giveuplands()	
    end
    
    	-- if we did not confederate Zhang Miao - take yingchuan farm 
	if(confederatedZhangMiao==false) then 
        CusLog("didnt confederate so take yingchuang")
        cm:modify_model():get_modify_region(yingchuan_region):settlement_gifted_as_if_by_payload(cm:modify_faction(qlubu_faction:name()))
    end 
        
    local mqzhangMiao= getModifyChar("3k_main_template_historical_zhang_miao_hero_water")
    if not mqzhangMiao:is_null_interface() then 
        mqzhangMiao:add_loyalty_effect("data_lu_bu_inspire")
        mqzhangMiao:add_loyalty_effect("extraordinary_success");
        mqzhangMiao:add_loyalty_effect("recently_promoted");
    end

    local xuchang_region =cm:query_region(XUCHANG) 
    if(xuchang_region:is_null_interface() ==false) then 
	    -- if CaoCao owns Yingchuan town (take it)
	    if(xuchang_region:owning_faction():name() == "3k_main_faction_cao_cao") then 
		    cm:modify_model():get_modify_region(xuchang_region):settlement_gifted_as_if_by_payload(cm:modify_faction(qlubu_faction:name()))
		  --  CusLog("..gave xuchang_region to lubu")
        else
            CusLog("... CaoCAo doesnt own xuchang_region")
        end
    end
	
	-- if CaoCao owns Dong town (take it)
    local dong_region =cm:query_region(PUYANG) 
    if(dong_region:is_null_interface() ==false) then 
	    -- if CaoCao owns PuYang town (take it)
	    if(dong_region:owning_faction():name() == "3k_main_faction_cao_cao") then 
		    cm:modify_model():get_modify_region(dong_region):settlement_gifted_as_if_by_payload(cm:modify_faction(qlubu_faction:name()))
		    CusLog("..gave dong_region to lubu")
        else
            CusLog("...CaoCAo doesnt own dong_region")
        end
    end
	
	--(give some gold to lu bu for an offensive -if hes been dead broke)
	cm:modify_faction(qlubu_faction:name()):increase_treasury(1500)
	
	-- Give AI CaoCao a ton of gold to fight back
	if (qcaocao_faction:is_human() == false) then 
        cm:modify_faction(qcaocao_faction:name()):increase_treasury(19000)
       CusLog("..Applying some new bonuses to AI CAO CAO")
        cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", "3k_main_faction_cao_cao" , 16)
        cm:apply_effect_bundle("3k_main_introduction_mission_payload_recruit_units", "3k_main_faction_cao_cao" , 4)
       CusLog("..passed effects")
        local chen_region = cm:query_region("3k_main_chenjun_resource_2") 
        if not chen_region:is_null_interface() then 
            if chen_region:owning_faction():name() ~= "3k_main_faction_cao_cao" and chen_region:owning_faction():is_human()==false then 
              --  CusLog("..Give CaoCao chen farm WEST..") --Keep liu Chong in the East
                cm:modify_model():get_modify_region(chen_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_cao_cao"))
            end
        end
    end

    local yuanshuFaction= cm:query_faction("3k_main_faction_yuan_shu")
    if( yuanshuFaction:is_human()==false and cm:get_saved_value("yuanshu_moved_shouchun") ~=true )then 
        MoveToShouchun(3) -- ensure yuan shu moves 
    end
	LuBuRefuge_listener()
    cm:set_saved_value("lu_bu_in_puyang", true); -- used in Xu_lubu refugee
    cm:set_saved_value("lubu_bonus_movement",false) --end the bonus movement per turn
	cm:set_saved_value("peace_needed",true) --Xu_peace Script to continue the storyline
    core:remove_listener("LuBuBonusMovement"); --would go away on its own but whatever
    CusLog("..Finished taking PuYang!")
end

function MoveLuBusExistingFaction() -- used to be for ghost Lu bu that spawned for AI after fall of empire 
    CusLog("..MoveLuBusExistingFaction")
    local lubu = cm:query_model():character_for_template("3k_main_template_historical_lu_bu_hero_fire")
             
    -- move lu bus army
     if not lubu:is_null_interface() then
        local qfaction = lubu:faction();
        CusLog("..Moving of Lu Bu faction name is : " ..qfaction:name())
    
        --Tells us if he is deployed
			if lubu:has_military_force() == true then
				CusLog("YOU CANT TELEPORT PLAYER ARMIES...gg")
               -- cm:modify_model():get_modify_character(lubu):teleport_to(484,487)  --((482,489))
			else
				CusLog(" no military Force")
				--idk? give money for deployment
				cm:modify_faction(q_faction:name()):increase_treasury(9500)
			end 

            
        --If LuBu owns Emperor... need to get rid of him only should happen in testing (why doesnt this work?)
        if cm:is_world_power_token_owned_by("emperor", qfaction:name()) then
            campaign_emperor_manager:transfer_token_to_faction(cm:modify_faction("3k_main_faction_zhang_yang"):query_faction(), qfaction, "emperor")
            CusLog("..Transfered emperor?")
        else
           CusLog("..we didnt own emperor")
        end

        GiveUpLands(lubu:faction())
    end

    --Get Missing Generals
    local hou_cheng = cm:query_model():character_for_template("3k_dlc05_template_historical_hou_cheng_hero_wood")
    if not hou_cheng:is_null_interface() then
        if(not hou_cheng:is_dead()) then
            if hou_cheng:faction():name() ~= lubu:faction():name() then 
                MoveCharToFactionHard("3k_dlc05_template_historical_hou_cheng_hero_wood", lubu:faction():name())
            elseif hou_cheng:is_character_is_faction_recruitment_pool() then 
                MoveCharToFactionHard("3k_dlc05_template_historical_hou_cheng_hero_wood", "3k_main_faction_han_empire")
                MoveCharToFactionHard("3k_dlc05_template_historical_hou_cheng_hero_wood", lubu:faction():name())
            end
            local mhou_cheng = cm:modify_character(hou_cheng)  
            mhou_cheng:add_loyalty_effect("data_lu_bu_inspire");
            mhou_cheng:add_loyalty_effect("recently_promoted");
            CusLog("added loyalty hou_cheng")
        else
            CusLog("dead-hou_cheng")
        end
    else
        CusLog("cant find hou_cheng, Spawn Him, ")
        cdir_events_manager:spawn_character_subtype_template_in_faction(lubu:faction():name(), "3k_general_wood", "3k_dlc05_template_historical_hou_cheng_hero_wood");
        local mchar1=getModifyChar("3k_dlc05_template_historical_hou_cheng_hero_wood")
        mchar1:add_loyalty_effect("recently_promoted");
        mchar1:add_loyalty_effect("data_lu_bu_inspire");
    end
    --Wish he was earth...
    local hao_meng = cm:query_model():character_for_template("3k_main_template_historical_hao_meng_hero_fire")
    if not hao_meng:is_null_interface() then
        if(not hao_meng:is_dead()) then
           CusLog("..Before we go doing stuff, haomengs faction:"..tostring(hao_meng:faction():name()))
            if hao_meng:faction():name() ~= lubu:faction():name() then 
                MoveCharToFactionHard("3k_main_template_historical_hao_meng_hero_fire", lubu:faction():name())
            elseif hao_meng:is_character_is_faction_recruitment_pool() then 
                MoveCharToFactionHard("3k_main_template_historical_hao_meng_hero_fire", "3k_main_faction_han_empire")
                MoveCharToFactionHard("3k_main_template_historical_hao_meng_hero_fire", lubu:faction():name())
            end
            local mhao_meng = cm:modify_character(hao_meng)  
            mhao_meng:add_loyalty_effect("data_lu_bu_inspire");
            mhao_meng:add_loyalty_effect("recently_promoted");
           CusLog("added loyalty mhao_meng")
        else
           CusLog("dead-mhao_meng")
        end
    else
        CusLog("cant find mhao_meng, Spawn Him,")
        cdir_events_manager:spawn_character_subtype_template_in_faction(lubu:faction():name(), "3k_general_fire", "3k_main_template_historical_hao_meng_hero_fire");
        local mchar=getModifyChar("3k_main_template_historical_hao_meng_hero_fire")
        mchar:add_loyalty_effect("recently_promoted");
        mchar:add_loyalty_effect("data_lu_bu_inspire");
    end

	-- we should check if lu lingqi stayed with us?
	 --Spawn lulingqi
         CusLog("figuring out LuLingqi")
         if MTU then 
            local lulinqi=getQChar2("3k_mtu_template_historical_lady_lu_ji_hero_wood")
            if lulingqi~=nil then 
				if lulingqi:faction():name() ~= lubu:faction():name() then 
					MoveCharToFaction("3k_mtu_template_historical_lady_lu_ji_hero_wood", lubu:faction():name())
				end
            else
                CusLog("Spawn MTU")  
                cdir_events_manager:spawn_character_subtype_template_in_faction(lubu:faction():name(), "3k_general_wood", "3k_mtu_template_historical_lady_lu_ji_hero_wood");
            end
            local mchar = getModifyChar("3k_dlc05_template_historical_lu_lingqi_hero_metal")
		    mchar:assign_to_post("faction_heir")
         else 
            local lulinqi=getQChar2("3k_dlc05_template_historical_lu_lingqi_hero_metal")
            if lulingqi~=nil then 
                if lulingqi:faction():name() ~= lubu:faction():name() then 
					MoveCharToFaction("3k_dlc05_template_historical_lu_lingqi_hero_metal", lubu:faction():name())
				end
            else
                CusLog("Spawn vanilla")  
                cdir_events_manager:spawn_character_subtype_template_in_faction(lubu:faction():name(), "3k_general_metal", "3k_dlc05_template_historical_lu_lingqi_hero_metal");
             end
            local mchar = getModifyChar("3k_dlc05_template_historical_lu_lingqi_hero_metal")
		    mchar:assign_to_post("faction_heir")
         end
		 
    --Give everybody a loyalty boost:
    MakeLuBusCoreHappy()

    
    --3k_main_introduction_mission_payload_recruit_units
    cm:apply_effect_bundle("3k_main_introduction_mission_payload_recruit_units", "3k_main_faction_dong_zhuo" , 4)
    cm:set_saved_value("lubu_took_puyang",true)
    CusLog("..Passed MoveLuBus faction")

   
end

function GiveUpLands(qfaction)

    local regionList = { };

    if qfaction:region_list() then
        CusLog("LuBu Provinces Owned="..qfaction:faction_province_list():num_items())
        for i = 0, qfaction:faction_province_list():num_items() - 1 do -- Go through each Province
            local province_key = qfaction:faction_province_list():item_at(i);
            CusLog("*looking at Province #:"..tostring(i).."  ="..tostring(province_key))
            for i = 0, province_key:region_list():num_items() - 1 do -- Go through each region in that province
             --   CusLog("--looping: x" ..tostring(i))
                local region_key = province_key:region_list():item_at(i);
                if(not region_key:is_null_interface()) then 
                    local region_name = region_key:name()
                   CusLog("--Adding@: " .. region_name)
                    table.insert(regionList, region_name)
                end
            end	
        end
    end

    CusLog("..Try to get rid of old regions:")
    for i=1, #regionList do
        local region = cm:query_region(regionList[i])
        CusLog("Found something: "..region:name())
          --Give back lands to Zhang Yang if we got them 
          if(cm:get_saved_value("lubu_knows_zhangmiao") ==true ) then 
            cm:modify_model():get_modify_region(region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_zhang_yang"))
           CusLog("--LuBu Gifts ZhangYang: " .. region:name())
        else
            cm:modify_region(region):raze_and_abandon_settlement_without_attacking();
           CusLog("--LuBu Abandons: " .. region:name())
        end
      
    end

end

function ZhangYangGivesLands() -- make it to ZhangYang enables the Xu_peace script to trigger LuBus PuYang Dilemma
    CusLog("Begin ZhangYangGivesLands")
    local playersFactionsTable = cm:get_human_factions()
    local playerFaction = playersFactionsTable[1]
    cm:trigger_incident(playerFaction,"3k_lua_zhang_yang_accepts_lu_bu", true )  --double check this has diplo bonus

	-- abandon any lands Lu Bu had ???
    CusLog("..done abandoning")

    cm:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo", "3k_main_faction_yuan_shao", "data_defined_situation_vassal_declares_independence", false);
    cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shao", "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
  
    
	cm:apply_automatic_deal_between_factions("3k_main_faction_zhang_yang", "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
    cm:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo", "3k_main_faction_zhang_yang", "data_defined_situation_peace", true);
   -- cm:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo", "3k_main_faction_zhang_yang", "data_defined_situation_vassalise_recipient_forced", false);
   --this was reversed? did it thru event 

   CusLog("..applied that diplo")

	local givenLand=false;
	-- Have Zhang Yang give him the farm land (as long as its not his only region)
    local qzhanyang_faction = cm:query_faction("3k_main_faction_zhang_yang")
	if qzhanyang_faction:region_list() then
        if(qzhanyang_faction:region_list():num_items() >1) then 
            local region_count= CountRegions("3k_main_faction_zhang_yang")
            local farmland_region =cm:query_region("3k_main_shangdang_resource_1")
            local ye_resource_1 = cm:query_region("3k_main_weijun_resource_1")
            local hedong = cm:query_region("3k_main_hedong_capital")
            if(not farmland_region:is_null_interface() and not ye_resource_1:is_null_interface() and not hedong:is_null_interface() ) then
			    if( region_count>1 and farmland_region:owning_faction():name() == "3k_main_faction_zhang_yang") then 
                  --  CusLog("..found the farm1")
                    cm:modify_model():get_modify_region(farmland_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_dong_zhuo"))
                    givenLand=true;
                elseif(region_count>1 and ye_resource_1:owning_faction():name() == "3k_main_faction_zhang_yang") then 
                  --  CusLog("..found the farm2")
                    cm:modify_model():get_modify_region(ye_resource_1):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_dong_zhuo"))
                    givenLand=true;
                elseif region_count>1 and hedong:owning_faction():name() == "3k_main_faction_zhang_yang" then 
                    cm:modify_model():get_modify_region(hedong):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_dong_zhuo"))
                    givenLand=true;
                else
                       CusLog("@!!..Uh oh zhang yang didnt have any of the regions???")
                end
            else
               CusLog("@!!..cant find farm")
            end
		else
			CusLog("@!!..Uh oh zhang yang didnt have enough land to spare?")
		end
	end
    
   CusLog("...Passed the Regions")
    --give supplies? (in event)?
    local qlubu_faction = getQChar("3k_main_template_historical_lu_bu_hero_fire"):faction();   
    cm:modify_model():get_modify_faction(qlubu_faction):apply_effect_bundle("3k_dlc04_effect_bundle_free_force",2)
    cm:apply_effect_bundle("3k_main_payload_faction_forces_supplies_enemy_territory", "3k_main_faction_dong_zhuo" , 3)
    cm:apply_effect_bundle("3k_main_effect_bundle_civil_war_separatists_grace_period", "3k_main_faction_dong_zhuo" , 1)
     
    if giveland==true then 
        cm:modify_faction(qlubu_faction:name()):increase_treasury(1800)
    else
        cm:modify_faction(qlubu_faction:name()):increase_treasury(500)
   		
    end
    CusLog("...Past the supplies")

    --Fire and incident about meeting Zhang Miao (add relationship modifier) Good friends Passed on the road
    --When Lü Bu left Yuan Shao to join Zhang Yang in Henei (河內; in present-day Henan), 
    --he passed by Chenliu and met Zhang Miao.
    -- Zhang Miao treated him generously and made a pledge of friendship with him when he saw him off.
    --[7] Yuan Shao was angry when he heard that Zhang Miao had befriended Lü Bu.
    -- Zhang Miao also feared that Cao Cao might ally with Yuan Shao to attack him so he felt very uncomfortable.
    --[8] Besides, his jurisdiction, Chenliu, was in Yan Province, which was under Cao Cao's control.
    
    --cm:set_saved_value("lubu_meet_zhangmiao", true); -- do this when fleeing instead
	
	--Really force the narrative here 
	local taoqian_character = cm:query_model():character_for_template("3k_main_template_historical_tao_qian_hero_water")
	local taoqian_faction = taoqian_character:faction();
    if cm:query_faction("3k_main_faction_cao_cao"):has_specified_diplomatic_deal_with("treaty_components_war",taoqian_faction) then
       --  CusLog("..LuBu in right conditions for XuStory to Continue")-- good
	else
		CusLog("..the AI CaoCao is no longer at war w taoQian, and LuBu is in position..Do something?") --ToDo 
		local caocao_faction= cm:query_faction("3k_main_faction_cao_cao")
		if not caocao_faction:is_human() then 
			cm:apply_automatic_deal_between_factions("3k_main_faction_cao_cao",taoqian_faction:faction():name(), "data_defined_situation_war_proposer_to_recipient",true)
			cm:set_saved_value("xu_at_war",true) -- Listener to trigger Puyang dilemma in Xu_Peace
			CusLog("...really driving the narrative for Xu..failsafe")
		end
    end

	cm:apply_effect_bundle("3k_dlc05_effect_bundle_granted_sanctuary", "3k_main_faction_dong_zhuo" , 2)
	peace194Listener()
    CusLog("...Done W ZhangYangs lands")

end
function YuanShaoGivesLands()
    CusLog(" BEGIN YuanShaoGivesLands ")
    local q_lubu_faction = cm:query_faction("3k_main_faction_dong_zhuo")
    local q_yuanshao_faction = cm:query_faction("3k_main_faction_yuan_shao")
    	
	local qlubu = cm:query_model():character_for_template("3k_main_template_historical_lu_bu_hero_fire")
    local qyuanshao = cm:query_model():character_for_template("3k_main_template_historical_yuan_shao_hero_earth")


    
      -- Give lu bu certain region under yuan shaos control (ensured by "GoToYuanShao())
      local ye_resource_1 = cm:query_region("3k_main_weijun_resource_1")
      local anping_resource_1 =cm:query_region("3k_main_anping_resource_1") 
      local given=false;

      if ye_resource_1:owning_faction():name() == "3k_main_faction_yuan_shao" then 
       --     CusLog("Give 3k_main_weijun_resource_1")
        --  cm:modify_region(ye_resource_1):raze_and_abandon_settlement_without_attacking();
        -- cm:modify_model():get_modify_region(ye_resource_1):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_dong_zhuo"))					
            cdir_events_manager:transfer_region_to_faction("3k_main_weijun_resource_1", "3k_main_faction_dong_zhuo");
            given=true;
        elseif ye_resource_1:owning_faction():is_human()==false and ye_resource_1:owning_faction():name()~= "3k_main_faction_zhang_yang" and ye_resource_1:owning_faction():name()~= "3k_main_faction_zhang_yan" then 
        --    CusLog("Owner="..ye_resource_1:owning_faction():name())
            given=true;
            cdir_events_manager:transfer_region_to_faction("3k_main_weijun_resource_1", "3k_main_faction_dong_zhuo");
      end

      if anping_resource_1:owning_faction():name() == "3k_main_faction_yuan_shao" and not given then 
        --  CusLog("Give anping_resource_1")
          cdir_events_manager:transfer_region_to_faction("3k_main_anping_resource_1", "3k_main_faction_dong_zhuo");
        elseif not given then 
          cm:modify_faction("3k_main_faction_dong_zhuo"):increase_treasury(3700)
         CusLog("uh..oh, yuan shao doesnt have any of the right regions to give?")
          cm:apply_effect_bundle("3k_dlc05_effect_bundle_granted_sanctuary", "3k_main_faction_dong_zhuo" , 3) --extra then
         -- cdir_events_manager:transfer_region_to_faction("3k_main_weijun_resource_1", "3k_main_faction_dong_zhuo");
      end

      cm:modify_faction("3k_main_faction_dong_zhuo"):increase_treasury(700) 
    --  CusLog("--Gave LuBu Money")

      -- Give Lu Bu a movement speed bonus?
      cm:apply_effect_bundle("3k_dlc05_effect_bundle_granted_sanctuary", "3k_main_faction_dong_zhuo" , 2)
      CusLog("--Gave LuBu 3k_dlc05_effect_bundle_pooled_resource_pooled_resource_lu_bu_momentum_level_9")
      

   


        --If Zhang Yan doesnt own Taiyun Give it so Lu bu can fight
    -- Also dont take away from zhang yang, need we flee there
    local taiyuan_resource_1 =cm:query_region("3k_main_taiyuan_resource_1")
    local taiyuan_resource_2 =cm:query_region("3k_main_taiyuan_resource_2") 
    
    if taiyuan_resource_1:owning_faction():name()~= "3k_main_faction_zhang_yan" and taiyuan_resource_1:owning_faction():name()~= "3k_main_faction_zhang_yang" then 
        cm:modify_model():get_modify_region(taiyuan_resource_1):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_zhang_yan"))					
    end
    if taiyuan_resource_2:owning_faction():name()~= "3k_main_faction_zhang_yan" and taiyuan_resource_2:owning_faction():name()~= "3k_main_faction_zhang_yang" then 
        cm:modify_model():get_modify_region(taiyuan_resource_2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_zhang_yan"))					
    end
    cm:modify_faction("3k_main_faction_zhang_yan"):increase_treasury(1700) 
    CusLog("Gave Zhang Yan something to fight with")
    cm:apply_effect_bundle("3k_dlc04_effect_bundle_free_force", "3k_main_faction_zhang_yan" , 2)
    
   
 
    -- Set vassalship in event?
    -- Set war in event ?
    -- improve relations with yuan shao and Lu Bu via event 
    
    --War didnt work? so redeclare here?
    --Turn off LuBus movement?

    cm:trigger_incident(q_lubu_faction,"3k_lua_yuan_shao_accepts_lu_bu", true ) 
    cm:apply_automatic_deal_between_factions("3k_main_faction_zhang_yan","3k_main_faction_dong_zhuo", "data_defined_situation_war_proposer_to_recipient",true)
   
    --Spawn a bandit stack in lu bus region from zhang yan
    local zyFact= cm:query_faction("3k_main_faction_zhang_yan")
    local found_pos, x, y = zyFact:get_valid_spawn_location_in_region(qlubu:region():name(), false);
    SpawnBandits("3k_main_faction_zhang_yan", qlubu:region():name(), "3k_main_faction_dong_zhuo", qlubu:logical_position_x(), qlubu:logical_position_y())
    if( qlubu:region():name() ~= "3k_main_weijun_resource_1") then 
        found_pos, x, y = zyFact:get_valid_spawn_location_in_region("3k_main_weijun_resource_1", false);
        SpawnBandits("3k_main_faction_zhang_yan", "3k_main_weijun_resource_1", "3k_main_faction_yuan_shao", x, y)
    end
    --Turn back on LuBus movement to race to bandits
    cm:set_saved_value("lubu_bonus_movement",true) 
    cm:set_saved_value("lubu_turntime", 5) 
    cm:set_saved_value("lubu_turncounter", 4);
    LuBuMoveDecayListener()

    --Break LiJue off something 
    local changan =cm:query_region("3k_main_changan_capital")
    if changan:owning_faction():is_human() == false and changan:owning_faction():name() ~="3k_main_faction_changan" then -- if lu bu split, li jue doesnt get
         CusLog("--Give LiJue --" .. tostring(changan:name()) )     
        cm:modify_model():get_modify_region(changan):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_changan"))
    end


    cm:modify_faction("3k_main_faction_zhang_yang"):increase_treasury(300) 
    cm:apply_effect_bundle("3k_dlc04_effect_bundle_free_force", "3k_main_faction_zhang_yang" , 1)
    CusLog("Finished YuanShaoGiveLands")

end

function GoToZhangYang()
    CusLog("Begin GoToZhangYang ")
    cm:set_saved_value("Yuan_shao_will_take",false) --used by yuan bandits
    cm:set_saved_value("lu_bu_fire_zhang_yang_accepts", true);
    AbandonLands("3k_main_faction_dong_zhuo"); -- maybe we should give them back to yuan shao instead, need playtesting
    cm:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo", "3k_main_faction_zhang_yang", "data_defined_situation_peace", true);
	cm:apply_automatic_deal_between_factions("3k_main_faction_zhang_yang", "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
    cm:modify_faction(cm:query_faction("3k_main_faction_dong_zhuo")):apply_automatic_diplomatic_deal("data_defined_situation_peace", cm:query_faction("3k_main_faction_zhang_yang"), "");
    cm:modify_faction(cm:query_faction("3k_main_faction_zhang_yang")):apply_automatic_diplomatic_deal("data_defined_situation_peace", cm:query_faction("3k_main_faction_dong_zhuo"), "");
   
    if cm:query_faction("3k_main_faction_liu_dai"):has_specified_diplomatic_deal_with("treaty_components_war",qzhangyang_faction) then
        cm:modify_faction(cm:query_faction("3k_main_faction_liu_dai")):apply_automatic_diplomatic_deal("data_defined_situation_peace", cm:query_faction("3k_main_faction_zhang_yang"), "");
    end

    --check chen gong is in caocao faction
	qchenGong= getQChar("3k_main_template_historical_chen_gong_hero_water")
	if(not qchenGong:is_null_interface()) then
		if(qchenGong:faction():name() ~= "3k_main_faction_cao_cao") then 
			MoveCharToFaction("3k_main_template_historical_chen_gong_hero_water", "3k_main_faction_cao_cao");
		end
    end
    
	-- check zhang miao took over liu dai and owns yingchaun
	qzhangMiao= getQChar("3k_main_template_historical_zhang_miao_hero_water")
	if(not qzhangMiao:is_null_interface()) then
		if( not qzhangMiao:is_faction_leader()) then
			local liudai_faction = cm:query_faction("3k_main_faction_liu_dai") -- double check 
				if(not liudai_faction:is_null_interface()) then 
					if(not liudai_faction:is_dead()) then 
						MoveCharToFaction("3k_main_template_historical_chen_gong_hero_water", "3k_main_faction_liu_dai"); -- double check
						KillLiuDai()
					end
				end
		end
    end

    -- Give Zhang yang right regions if he/player doesnt own:
    local farmland_region =cm:query_region("3k_main_shangdang_resource_1")
    if(not farmland_region:owning_faction():is_human() and farmland_region:owning_faction():name() ~="3k_main_faction_zhang_yang" ) then 
       CusLog("...give the farm to zhang yang")
        cm:modify_model():get_modify_region(farmland_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_zhang_yang"))         
    end
    local hedong_region =cm:query_region("3k_main_hedong_capital")
    if( not hedong_region:owning_faction():is_human() and  hedong_region:owning_faction():name() ~="3k_main_faction_zhang_yang") then 
        CusLog("...give 3k_main_hedong_capital")
        cm:modify_model():get_modify_region(hedong_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_zhang_yang"))      
    end
        cm:modify_faction("3k_main_faction_zhang_yang"):increase_treasury(3300) -- keep him a float

    -- do a double check CaoCao will get Dong / yan province
    if cm:get_saved_value("cao_given_yan") ~=true then 
        local caocao_faction=cm:query_faction("3k_main_faction_cao_cao")
        if not caocao_faction:is_human() then 
            CaoCaoGivenYanProvince()
        end
    end
    ZhangYangAcceptsListener()
    CusLog("Finished GoToZhangYang ")
end
function GoToYuanShu()
    CusLog("Begin GoToYuanShu")
    cm:set_saved_value("lu_bu_fire_yuan_shu_rejection", true);
    YuanShuRejectionDelayListener();
   -- YuanShuRejectsListener(); -- unused now, just fired the dilemma instead

    --Before you go move emperor to Li Jue
    local myFaction= cm:query_faction("3k_main_faction_dong_zhuo")
    if cm:is_world_power_token_owned_by("emperor", "3k_main_faction_dong_zhuo")  then
        CusLog("..! LuBu has the emperor, transfer")
        --local lijue = cm:query_model():character_for_template("3k_main_template_historical_li_jue_hero_fire")
        --local lijue_faction = lijue:faction()
        -- Move emperor 
       -- campaign_emperor_manager:transfer_token_to_faction(cm:modify_faction(lijue_faction:name()):query_faction(), myFaction(), "emperor")
       LiJueTakesEmperor(myFaction)
    else
        CusLog(".. lu bu doesnt have the emperor?")
    end
    --Check LuBu has an army deployed, if not deploy him
    local qlubu=getQChar('3k_main_template_historical_lu_bu_hero_fire') -- cant be null, that wud be nuts
    if not qlubu:has_military_force() then 
        CusLog("..! LuBu has no army, attempting to deploy")
        local found_pos, x, y = myFaction:get_valid_spawn_location_in_region("3k_main_changan_capital", false);
        local unit_list="3k_main_unit_fire_mercenary_cavalry_captain,3k_main_unit_fire_xiliang_cavalry,3k_main_unit_fire_heavy_xiliang_cavalry,3k_main_unit_metal_sabre_infantry"

        cm:create_force_with_existing_general(qlubu:cqi(), "3k_main_faction_dong_zhuo", unit_list, "3k_main_changan_capital", x, y,"3klubu_01",nil, 100);
        ResetLuBusMovement()
    end

    if myFaction:treasury() < 1000 then 
        cm:modify_faction("3k_main_faction_dong_zhuo"):increase_treasury(4700) -- keep him a float
    elseif myFaction:treasury() < 2200 then 
        cm:modify_faction("3k_main_faction_dong_zhuo"):increase_treasury(3200) -- keep him a float
    elseif myFaction:treasury() < 3500 then 
        cm:modify_faction("3k_main_faction_dong_zhuo"):increase_treasury(2100) -- keep him a float
    elseif myFaction:treasury() < 5000 then 
        cm:modify_faction("3k_main_faction_dong_zhuo"):increase_treasury(1200) -- keep him a float
    else
        cm:modify_faction("3k_main_faction_dong_zhuo"):increase_treasury(1000) -- keep him a float
    end

    AbandonLands("3k_main_faction_dong_zhuo");
    CusLog("End GoToYuanShu")
    --We need to make Cao Cao and Yuan Shao like Eachother ToDo

end
function GoToYuanShao()
    CusLog("Begin GoToYuanShao ")
    cm:set_saved_value("lu_bu_fire_yuan_shao_accepts", true);
    cm:set_saved_value("Yuan_shao_will_take",true) --used by yuan bandits
    YuanShaoAcceptsListener();

    --have to handle if player skips to this 
    local myFaction= cm:query_faction("3k_main_faction_dong_zhuo")
    if cm:is_world_power_token_owned_by("emperor", "3k_main_faction_dong_zhuo")  then
        CusLog("..! LuBu has the emperor, transfer")
        LiJueTakesEmperor(myFaction)
        --Check LuBu has an army deployed, if not deploy him
        local qlubu=getQChar('3k_main_template_historical_lu_bu_hero_fire') -- cant be null, that wud be nuts
     if not qlubu:has_military_force() then 
        CusLog("..! LuBu has no army, attempting to deploy")
        local found_pos, x, y = myFaction:get_valid_spawn_location_in_region("3k_main_changan_capital", false);
        local unit_list="3k_main_unit_fire_mercenary_cavalry_captain,3k_main_unit_fire_xiliang_cavalry,3k_main_unit_fire_heavy_xiliang_cavalry,3k_main_unit_metal_sabre_infantry"

        cm:create_force_with_existing_general(qlubu:cqi(), "3k_main_faction_dong_zhuo", unit_list, "3k_main_changan_capital", x, y,"3klubu_01",nil, 100);
        ResetLuBusMovement()
    end
    if myFaction:treasury() < 1000 then 
        cm:modify_faction("3k_main_faction_dong_zhuo"):increase_treasury(4700) -- keep him a float
    elseif myFaction:treasury() < 2200 then 
        cm:modify_faction("3k_main_faction_dong_zhuo"):increase_treasury(3200) -- keep him a float
    elseif myFaction:treasury() < 3500 then 
        cm:modify_faction("3k_main_faction_dong_zhuo"):increase_treasury(2100) -- keep him a float
    elseif myFaction:treasury() < 5000 then 
        cm:modify_faction("3k_main_faction_dong_zhuo"):increase_treasury(1200) -- keep him a float
    else
        cm:modify_faction("3k_main_faction_dong_zhuo"):increase_treasury(1000) -- keep him a float
    end
    else
        CusLog(".. lu bu doesnt have the emperor?")
    end
   


    AbandonLands("3k_main_faction_dong_zhuo");
    cm:apply_effect_bundle("3k_dlc05_effect_bundle_pooled_resource_pooled_resource_lu_bu_momentum_level_9", "3k_main_faction_dong_zhuo" , 2)

    --make sure YuanShao has land for us (should have from confederating HanFu)
    q_yuanshao_faction =cm:query_faction("3k_main_faction_yuan_shao")
    if(q_yuanshao_faction:is_human() ==false) then 
	    local desired_region =cm:query_region("3k_main_weijun_resource_1")
	    local desired_region2 =cm:query_region("3k_main_anping_resource_1") 
	    if desired_region:owning_faction():is_human()==false then 
		    cm:modify_model():get_modify_region(desired_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_yuan_shao"))
	    elseif desired_region2:owning_faction():is_human()==false then 
            cm:modify_model():get_modify_region(desired_region2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_yuan_shao"))
        end
    end
    
    q_zhangyang_faction =cm:query_faction("3k_main_faction_zhang_yang")
    local desired_region3 =cm:query_region("3k_main_weijun_resource_1")
    local desired_region4 =cm:query_region("3k_main_anping_resource_1") 
    if desired_region3:owning_faction():name() ~= "3k_main_faction_zhang_yang" and desired_region3:owning_faction():is_human()==false then  
        cm:modify_model():get_modify_region(desired_region3):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_zhang_yang"))
        cm:modify_faction("3k_main_faction_zhang_yang"):increase_treasury(2300) -- keep him a float
    elseif desired_region4:owning_faction():name() ~= "3k_main_faction_zhang_yang" then  
        cm:modify_faction("3k_main_faction_zhang_yang"):increase_treasury(7700) -- our boy needs to take back his lands
    end

    
							
    CusLog("End GoToYuanShao ")
end

function KillWangYun() -- used in YuanShus/yuanShao Script too
    CusLog("Run KillWangYun")
    local qlubu = getQChar("3k_main_template_historical_lu_bu_hero_fire")
    if not qlubu:is_faction_leader() then 
        local lubu= getModifyChar("3k_main_template_historical_lu_bu_hero_fire")
        lubu:assign_to_post("faction_leader");
    end
    --Should find a way to add global effect_bundle
    --cm:apply_effect_bundle("3k_dlc04_effect_bundle_free_force", current_faction_name, 0);
    CusLog("..Apply 3k_main_effect_bundle_civil_war_loyalists_won")
    cm:modify_faction("3k_main_faction_dong_zhuo"):apply_effect_bundle("3k_main_effect_bundle_civil_war_loyalists_won", 3); 

    CusLog("..see if WangYungs alive")
    local qchar= getQChar("3k_main_template_historical_wang_yun_hero_earth")
    if not qchar:is_dead() then 
        local mchar= getModifyChar("3k_main_template_historical_wang_yun_hero_earth")
        if(mchar:is_null_interface() ==false) then 
          mchar:kill_character(false)
          CusLog("..Killed Wangyun")
        end
    end
    CusLog("Fnished KillWangYun")
end

function EnteredPuYangListener()
    CusLog("### EnteredPuYangListener 2 loading ###")
    core:remove_listener("EnteredPuYang")
	core:add_listener(
		"EnteredPuYang",
		"CharacterFinishedMovingEvent",
		function(context)
            CusLog("Listening for EnteredPuYang")
            if cm:get_saved_value("lubu_in_route")==true then 
                local lubu = getQChar("3k_main_template_historical_lu_bu_hero_fire")
                if context:query_character():faction():name()== lubu:faction():name() then 
                    --Could add more checks to ensure zhangmiao/caocao own the entered region
                    if context:query_character():region():name() == "3k_main_yingchuan_resource_1" then 
                        return true;
                    elseif context:query_character():region():name() == XUCHANG then 
                        return true;
                    elseif context:query_character():region():name() == PUYANG then 
                        return true;
                    end
                end
            end
            return false;
		end,
        function(context)
            cm:set_saved_value("lubu_in_route",false)   
            CusLog("??? Callback: for lu bu entering puyang")
            local playersFactionsTable = cm:get_human_factions()
            local playerFaction = playersFactionsTable[1]
            cm:trigger_incident(playerFaction ,"3k_lua_lubu_enters_puyang", true)
            TakePuYang()
            cm:set_saved_value("caocao_buffed_turnlimit", context:query_model():turn_number() +8)-- Buff Cao cao for 8turns
            core:remove_listener("EnteredPuYang");
            
		end,
		false
    )
end

function MeetZhangMiao()
    CusLog("..!MeetZhangMiao")
    
    --if zhang miao isnt in liu dai faction move him
    local qzhangMiao= getQChar("3k_main_template_historical_zhang_miao_hero_water")
    if(qzhangMiao:faction():name() ~= "3k_main_faction_liu_dai") then
        CusLog("..Have to move zhang miao to liu dai faction, hasnt happened yet?")
        MoveCharToFaction("3k_main_template_historical_zhang_miao_hero_water", "3k_main_faction_liu_dai" )
        CusLog("..move complete")
    end

    local zhangmiaoAlive=cm:trigger_incident("3k_main_faction_dong_zhuo","3k_lua_lubu_meets_zhangmiao", true )
	if zhangmiaoAlive ==nil then
		CusLog("@!!.. the return for zhangmiaos incident isnt working, should move bool outside")
		cm:set_saved_value("lubu_knows_zhangmiao", true); -- hope for the best..!
	elseif(zhangmiaoAlive ==true) then 
		CusLog("@!!.. the return for zhangmiaos incident is working, should move bool inside")
		cm:set_saved_value("lubu_knows_zhangmiao", true); -- this bool will also get zhang yang his lands back (if we earned any under his rule)
    end
    cm:set_saved_value("lubu_meet_zhangmiao", false); 
end


function VassalsBuggedistener()
    CusLog("### VassalsBuggedistener 2 loading ###")
    core:remove_listener("VassalsBugged") -- prevent duplicates
	core:add_listener(
		"VassalsBugged",
		"FactionTurnStart", -- done on start kinda doesnt work? maybe next turn idk
        function(context)
            if context:faction():is_human() == true and cm:get_saved_value("doublecheck_vassal") then
                local qyuanshao_faction = cm:query_faction("3k_main_faction_yuan_shao")
                if cm:query_faction("3k_main_faction_dong_zhuo"):has_specified_diplomatic_deal_with("treaty_components_vassalage",qyuanshao_faction) then
                   return true;  
                end
			    --return cm:get_saved_value("lubu_meet_zhangmiao");
            end
             return false
		end,
		function(context)
            CusLog("??Callback: VassalsBuggedistener ###")
            cm:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo", "3k_main_faction_yuan_shao", "data_defined_situation_vassal_declares_independence", false);
            cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shao", "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
            local qyuanshao_faction = cm:query_faction("3k_main_faction_yuan_shao")
            if not cm:query_faction("3k_main_faction_dong_zhuo"):has_specified_diplomatic_deal_with("treaty_components_vassalage",qyuanshao_faction) then
                 cm:set_saved_value("doublecheck_vassal",false)
            end

		end,
		true
    )
end

function LuBuMeetsZhangMiaoListener()
    CusLog("### LuBuMeetsZhangMiaoListener 2 loading ###")
    core:remove_listener("LuBuMeetsZhangMiao") -- prevent duplicates
	core:add_listener(
		"LuBuMeetsZhangMiao",
		"FactionTurnEnd", -- done on start kinda doesnt work? maybe next turn idk
        function(context)
            if context:faction():is_human() == true then
                CusLog("..listening for LuBuMeetsZhangMiaoListener")
                CusLog("..!.! We are returning::"..tostring(cm:get_saved_value("lubu_meet_zhangmiao")))
                if(cm:get_saved_value("lubu_meet_zhangmiao") and not cm:get_saved_value("lubu_knows_zhangmiao") ) then
                    return true;
                end
			    --return cm:get_saved_value("lubu_meet_zhangmiao");
            end
             return false
		end,
		function(context)
            CusLog("??Callback: LuBuMeetsZhangMiaoListener ###")
            MeetZhangMiao()
		end,
		false
    )
end

function ZhangYangAcceptsListener() 
    CusLog("### ZhangYangAcceptsListener 2 loading ###")
    core:remove_listener("ZhangYangAcceptsListener") -- prevent duplicates
	core:add_listener(
		"ZhangYangAcceptsListener",
		"CharacterFinishedMovingEvent",
        function(context)
            local qchar = context:query_character();
			local qlubu = getQChar("3k_main_template_historical_lu_bu_hero_fire")
            if qchar:faction():name() ==qlubu:faction():name() and cm:get_saved_value("lu_bu_fire_zhang_yang_accepts") then
                CusLog("..Checking ZhangYangAcceptsListener delay:") 
                if qchar:region():owning_faction():name() == "3k_main_faction_zhang_yang" then 
                    return true;
                end
            end
             return false
		end,
		function(context)
            CusLog("??? Callback: ZhangYangAcceptsListener ###")
			cm:set_saved_value("lu_bu_fire_zhang_yang_accepts", false);
            ZhangYangGivesLands();
            core:remove_listener("ZhangYangAcceptsListener");
		end,
		false
    )
end
function YuanShaoAcceptsListener() 
    CusLog("### YuanShaoAcceptsListener 2 loading ###")
    core:remove_listener("YuanShaoAccepts") -- prevent duplicates
	core:add_listener(
		"YuanShaoAccepts",
		"CharacterFinishedMovingEvent",
        function(context)
           CusLog("..Listening for LubU to stop moving (shao)")
            local qchar = context:query_character();
			local qlubu = getQChar("3k_main_template_historical_lu_bu_hero_fire")
            if qchar:faction():name() ==qlubu:faction():name()  and cm:get_saved_value("lu_bu_fire_yuan_shao_accepts") then
				CusLog("..listening for YuanShao Accepts, checking region: "..tostring(qchar:region():name()))
					if(qchar:region():owning_faction():name() == "3k_main_faction_yuan_shao") then
						return true;
                    end
            end
             
             return false
		end,
		function(context)
            CusLog("### Passed YuanShaoAcceptsListener ###")
     		YuanShaoGivesLands();
            cm:set_saved_value("lu_bu_fire_yuan_shao_accepts", false);
            local max=5;
            if context:query_model():calendar_year() >194 then 
                max=2;
            elseif context:query_model():calendar_year() == 193 then
                max=3;
            end
            local rolled_value = cm:random_number( 1, max );
            cm:set_saved_value("lu_bu_fire_yuan_shao_rumors",rolled_value)
            YuanShaoRumorsDelayListener()
		end,
		false
    )
end


function YuanShaoRumorsDelayListener() 
    CusLog("### lu_bu_fire_yuan_shao_rumors 2 loading ###")
    core:remove_listener("YuanShaoRumorsDelayListener") -- prevent duplicates
	core:add_listener(
		"YuanShaoRumorsDelayListener",
		"FactionTurnEnd",
        function(context)
            local faction_key = context:faction();
            if faction_key:is_human() == true and cm:get_saved_value("lu_bu_fire_yuan_shao_rumors") ~=nil then
            CusLog("..listening for YuanShaoRumorsDelayListener delay int:".. tostring(cm:get_saved_value("lu_bu_fire_yuan_shao_rumors"))) 
			local timeUntilRumor = cm:get_saved_value("lu_bu_fire_yuan_shao_rumors")
			CusLog("--Time Until Rumors=:"..timeUntilRumor)
                 if timeUntilRumor <=1 or context:query_model():calendar_year()>194 then 
					 return true
				 else
					cm:set_saved_value("lu_bu_fire_yuan_shao_rumors", timeUntilRumor-1);
                 end
            end
             
             return false
		end,
		function()
            CusLog("### Passed YuanShaoRumorsDelayListener ###")
            core:remove_listener("YuanShaoRumorsDelayListener");
            cm:set_saved_value("lu_bu_fire_yuan_shao_rumors",999)
           --Fire incident ok here cuz of turn start?
            YuanShaoRumorsListener()
              local playersFactionsTable = cm:get_human_factions()
              local playerFaction = playersFactionsTable[1]
              cm:trigger_incident(playerFaction,"3k_lua_yuan_shao_rumours_lu_bu", true ) 
		end,
		true
    )
end
function YuanShuRejectionDelayListener() 
    CusLog("### YuanShuRejectionDelayListener 2 loading ###")
   CusLog(tostring(debug.traceback())) --WTH is going on
    core:remove_listener("YuanShuRejectionDelayListener") -- prevent duplicates
	core:add_listener(
		"YuanShuRejectionDelayListener",
		"CharacterFinishedMovingEvent",
        function(context)
            local qchar = context:query_character();
			local qlubu = getQChar("3k_main_template_historical_lu_bu_hero_fire")
            if qchar:faction():name() ==qlubu:faction():name()  and cm:get_saved_value("lu_bu_fire_yuan_shu_rejection") then
				CusLog("..listening for YuanShuRejection, checking region: "..qchar:region():owning_faction():name())
					if(qchar:region():owning_faction():name() == "3k_main_faction_yuan_shu") then
						return true;
					end
             end
             
             return false
		end,
		function()
            CusLog("### Passed YuanShuRejectionDelayListener ###")
            core:remove_listener("YuanShuRejectionDelayListener");
           --Fire incident ok here cuz of turn start?
            LuBu2ChoiceMadeListener()
            local playersFactionsTable = cm:get_human_factions()
            local playerFaction = playersFactionsTable[1]
			cm:trigger_dilemma(playerFaction, "3k_lua_lubu_02_dilemma", true) -- TO:DO worsen relations 
		end,
		false
    )
end


function YuanShaoRumorsListener()
    CusLog("### YuanShaoRumorsListener 2 loading ###")
    core:remove_listener("YuanShaoRumorsListener") -- prevent duplicates
	core:add_listener(
		"YuanShaoRumorsListener",
		"IncidentOccuredEvent",
		function(context)
			 return context:incident() == "3k_lua_yuan_shao_rumours_lu_bu"
		end,
		function(context)
            CusLog("??? Callback: YuanShaoRumorsListener (trigger next dilemma)")
            LuBu3ChoiceMadeListener()
            --Trigger Dilemma to go to zhang yang 
            if not cm:get_saved_value("lu_bu_in_puyang") and not cm:get_saved_value("lubu_in_route") then -- weird part of quest line, dont interrupt
			    local playersFactionsTable = cm:get_human_factions()
                local playerFaction = playersFactionsTable[1]
			    cm:trigger_dilemma(playerFaction, "3k_lua_lubu_03_dilemma", true) 
                --WorsenRelations(1,2)
            end
		end,
		false
    )
end
function YuanShuRejectsListener() -- Unused now
    CusLog("### YuanShuRejectsListener 2 loading ###")
    core:remove_listener("YuanShuRejectsListener") -- prevent duplicates
	core:add_listener(
		"YuanShuRejectsListener",
		"IncidentOccuredEvent",
		function(context)
			 return context:incident() == "3k_lua_yuan_shu_rejects_lu_bu"
		end,
		function(context)
			core:remove_listener("YuanShuRejectsListener");
			--Trigger Dilemma to go to yuan shao 
			 local playersFactionsTable = cm:get_human_factions()
             local playerFaction = playersFactionsTable[1]
			 cm:trigger_dilemma(playerFaction, "3k_lua_lubu_02_dilemma", true) 
		end,
		true
    )
end
    
function CheckOwnerShip(choiceint)
    CusLog("..!CheckOwnership")
    local qcaocao_faction=cm:query_faction("3k_main_faction_cao_cao")
    local qzhangmiao_faction=cm:query_faction("3k_main_faction_liu_dai")

    local errorIncidents = {
        "3k_main_lubu_mischoice_chenliu",
        "3k_main_lubu_mischoice_xuchang",
        "3k_main_lubu_mischoice_puyang"
    };
    CusLog("..pass error incident table")
 
        local query_region= cm:query_region("3k_main_yingchuan_resource_1")

        if choiceint==2 then 
             query_region =cm:query_region(XUCHANG)
            CusLog("Checking Xuchang"..tostring(choiceint))
        elseif choiceint==3 then 
             query_region =cm:query_region(PUYANG)
            CusLog("Checking Puyang"..tostring(choiceint))
        end

        if query_region:is_null_interface() then 
            CusLog("@@!!..couldnt find region??")
        end

        CusLog("..the regions arent null")

        if (query_region:owning_faction():name() ==  qzhangmiao_faction:name() 
            or
            query_region:owning_faction():name() ==  qcaocao_faction:name() ) then 
                CusLog("..Choice was Sound by LuBu")
        else 
            CusLog("@@!!..Choice was poor by LuBu")
            CusLog("@@!!..Region Ownership was: "..query_region:owning_faction():name())
            cm:set_saved_value("lubu_bonus_movement",false) --end the bonus movement per turn cuz players potentially not following story
            local playersFactionsTable = cm:get_human_factions()
            local playerFaction = playersFactionsTable[1]
            CusLog("trigger incident="..errorIncidents[choiceint])
            cm:trigger_incident(playerFaction, errorIncidents[choiceint],true )
        end

end

function LuBu4ChoiceMadeListener()
    CusLog("### LuBu4ChoiceMadeListener 2 loading ###")
    core:remove_listener("DilemmaChoiceMadeLuBu4") -- prevent duplicates
    core:add_listener(
    "DilemmaChoiceMadeLuBu4",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_lubu_take_puyang_dilemma"
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! 3k_lua_lubu_take_puyang_dilemma choice was:" .. tostring(context:choice()))
       -- if choice < 4 then
            if choice ~= 0 then -- "sounds like a trap"
                CusLog("..Turn off any possible old quest lines")
                cm:set_saved_value("lu_bu_fire_yuan_shao_accepts",false) -- turn off some old stuff just incase
                cm:set_saved_value("lu_bu_fire_yuan_shu_rejection",false)
                cm:set_saved_value("lu_bu_fire_zhang_yang_accepts",false)
                EnteredPuYangListener() -- should be on but doesnt hurt again
                cm:set_saved_value("lubu_in_route",true)
                CheckOwnerShip(choice)
            end
         core:remove_listener("DilemmaChoiceMadeLuBu4");
    end,
    true
 );
end
function LuBu3ChoiceMadeListener()
    CusLog("### LuBu3ChoiceMadeListener 2 loading ###")
    core:remove_listener("DilemmaChoiceMadeLuBu3") -- prevent duplicates
    core:add_listener(
    "DilemmaChoiceMadeLuBu3",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_lubu_03_dilemma"
    end,
    function(context)
        CusLog("..! 3k_lua_lubu_03_dilemma choice was:" .. tostring(context:choice()))
        if context:choice() == 0 then
            GoToZhangYang()
            cm:set_saved_value("lubu_meet_zhangmiao", true);
            cm:apply_effect_bundle("3k_main_payload_faction_forces_supplies_enemy_territory", "3k_main_faction_dong_zhuo" , 1)
            cm:apply_effect_bundle("3k_dlc04_effect_bundle_free_force", "3k_main_faction_dong_zhuo" , 1)    
	    end
         core:remove_listener("DilemmaChoiceMadeLuBu3");
    end,
    true
 );
end
function LuBu2ChoiceMadeListener()
    CusLog("### LuBu2ChoiceMadeListener 2 loading ###")
    core:remove_listener("DilemmaChoiceMadeLuBu2") -- prevent duplicates
    core:add_listener(
    "DilemmaChoiceMadeLuBu2",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_lubu_02_dilemma"
    end,
    function(context)
        CusLog("..! 3k_lua_lubu_02_dilemma choice was:" .. tostring(context:choice()))
        if context:choice() == 0 then
            GoToYuanShao() 
            cm:apply_effect_bundle("3k_main_payload_faction_forces_supplies_enemy_territory", "3k_main_faction_dong_zhuo" , 1)
            cm:apply_effect_bundle("3k_dlc04_effect_bundle_free_force", "3k_main_faction_dong_zhuo" , 1)
        end
        cm:set_saved_value("lu_bu_fire_yuan_shu_rejection",false)
        core:remove_listener("DilemmaChoiceMadeLuBu2");
    end,
    true
  );
end
function LuBu1ChoiceMadeListener()
    CusLog("### LuBu1ChoiceMadeListener 2 loading ###")
    core:remove_listener("DilemmaChoiceMadeLuBu1") -- prevent duplicates
    core:add_listener(
    "DilemmaChoiceMadeLuBu1",
    "DilemmaChoiceMadeEvent",
    function(context)
        CusLog("..Listening for 3k_lua_lubu_01_dilemma choice ")
        return context:dilemma() == "3k_lua_lubu_01_dilemma"  
    end,
    function(context)
        CusLog("..! 3k_lua_lubu_01_dilemma choice was:" .. tostring(context:choice()))
        KillWangYun() -- maybe not the best spot
        if context:choice() == 0 then
             GoToYuanShu()
             cm:set_saved_value("lubu_bonus_movement",true) 
             cm:set_saved_value("lubu_turntime", 7) 
             cm:set_saved_value("lubu_turncounter", 4);
             LuBuMoveDecayListener()
             --Shud make dummy effects (ToDo)
            --cm:apply_effect_bundle("3k_main_payload_faction_forces_supplies_enemy_territory", "3k_main_faction_dong_zhuo" , 2)
            --cm:apply_effect_bundle("3k_dlc04_effect_bundle_free_force", "3k_main_faction_dong_zhuo" , 2)
            cm:apply_effect_bundle("3k_main_effect_bundle_civil_war_separatists_grace_period", "3k_main_faction_dong_zhuo" , 3)
        elseif context:choice() == 1 then 
            GoToYuanShao()
            cm:set_saved_value("lubu_bonus_movement",true)
            m:set_saved_value("lubu_turntime", 7) 
            cm:set_saved_value("lubu_turncounter", 4);
            LuBuMoveDecayListener()
          -- cm:apply_effect_bundle("3k_main_payload_faction_forces_supplies_enemy_territory", "3k_main_faction_dong_zhuo" , 4)
           cm:apply_effect_bundle("3k_main_effect_bundle_civil_war_separatists_grace_period", "3k_main_faction_dong_zhuo" , 3)
        end
         cm:set_saved_value("lubu_decided",true)
         core:remove_listener("DilemmaChoiceMadeLuBu1");
    end,
    true
 );
end

function ChangAnStuck()
  CusLog("Begin ChanAnStuck!!")
  LuBu1ChoiceMadeListener()
  local playersFactionsTable = cm:get_human_factions()
  local playerFaction = playersFactionsTable[1]
  cm:trigger_dilemma(playerFaction,"3k_lua_lubu_01_dilemma", true )
  --Debuff Zhang Jiang so Zhang Yang can hold land:
  local zj= cm:query_faction("3k_main_faction_zheng_jiang")
  if( zj:is_human() ==false) then
    CusLog("..Debuffing ZhengJiang")
    cm:apply_effect_bundle("3k_dlc05_effect_bundle_internal_conflict", "3k_main_faction_zheng_jiang" , 4)
    cm:apply_effect_bundle("3k_dlc05_effect_bundle_faction_support_human_bandit_0_to_20_normal", "3k_main_faction_zheng_jiang" , 7)
    cm:apply_effect_bundle("3k_main_effect_bundle_action_weaken_trade", "3k_main_faction_zheng_jiang" , 6)
    cm:apply_effect_bundle("3k_main_effect_bundle_food_shortage_tier_4", "3k_main_faction_zheng_jiang" , 2)
    cm:apply_effect_bundle("3k_dlc04_payload_global_disaster_locust_plague", "3k_main_faction_zheng_jiang" , 3)
  end
  cm:apply_effect_bundle("3k_dlc04_effect_bundle_free_force", "3k_main_faction_zhang_yang" , 2)
  
  --PLay is LuBU try, to enable merc contracts
  CusLog("..! Attempting to enable merc contracts for lubu")
	local model = cm:modify_model();
 	model:enable_diplomacy("subculture:3k_main_chinese","faction:" .. "3k_main_faction_dong_zhuo","treaty_components_mercenary_contract_recipient_declares_war_against_target,treaty_components_mercenary_counter_contract_recipient_declares_war_against_target","hidden")
	model:enable_diplomacy("faction:" .. "3k_main_faction_dong_zhuo", "subculture:3k_main_chinese","treaty_components_mercenary_contract_proposer_declares_war_against_target,treaty_components_mercenary_counter_contract_proposer_declares_war_against_target","hidden")
	model:enable_diplomacy("subculture:3k_dlc05_subculture_bandits","faction:" .. "3k_main_faction_dong_zhuo","treaty_components_mercenary_contract_recipient_declares_war_against_target,treaty_components_mercenary_counter_contract_recipient_declares_war_against_target","hidden")
	model:enable_diplomacy("faction:" .. "3k_main_faction_dong_zhuo", "subculture:3k_dlc05_subculture_bandits","treaty_components_mercenary_contract_proposer_declares_war_against_target,treaty_components_mercenary_counter_contract_proposer_declares_war_against_target","hidden")

  CusLog("..Finished ChanAnStuck")
end
function LuBuChangAnDelayListener()
    CusLog("### LuBuChangAnDelayListener 2 loading ###")
    core:remove_listener("LuBuChangAnDelay") -- prevent duplicates
	core:add_listener(
		"LuBuChangAnDelay",
		"FactionTurnEnd",
        function(context)
           CusLog("..listening for LuBuChangAnDelayListener ")
                if context:faction():is_human() == true and context:faction():name()=="3k_main_faction_dong_zhuo" then 
                    if cm:get_saved_value("lubu_decided")~=true then 
                        return cm:get_saved_value("player_is_lu_bu")
                    end
                elseif cm:get_saved_value("player_is_lu_bu") then
                   -- core:remove_listener("LuBuChangAnDelay")
                end
             return false
		end,
        function(context)
            CusLog("??? Callback: LuBuChangAnDelayListener ###")
            ChangAnStuck()
			CusLog("### Pass LuBuChangAnDelayListener ###")
		end,
		false
    )
end
function LuBuMoveDecayListener()
    CusLog("### LuBuMoveDecayListener 2 loading ###")
    core:remove_listener("LuBuMoveDecay") -- prevent duplicates
	core:add_listener(
		"LuBuMoveDecay",
		"FactionTurnStart",
        function(context)
            CusLog("..listening for LuBuMoveDecayListener ")
                if context:faction():is_human() == true and context:faction():name()=="3k_main_faction_dong_zhuo" then 
                    if(cm:get_saved_value("lubu_bonus_movement")) then 
                     --Callbacks dont work on FactionTurn Starts..IDK WHY
                     --Lower the movement chance
                         cm:set_saved_value("lubu_turncounter", 3);
                         CusLog("..Reset LuBus turn counter")
                        local no= cm:get_saved_value("lubu_turntime");
                        if(no>1) then 
                             cm:set_saved_value("lubu_turntime", no-1)
                         else
                              cm:set_saved_value("lubu_bonus_movement",false)
                         end
                    end
                end
             return false
		end,
        function(context)
            CusLog("??? Callback: LuBuMoveDecayListener  ###")
		end,
		true
    )
end
function LuBusArmyMechanicListener()
    CusLog("### LuBusArmyMechanicListener 2 loading ###")
    core:remove_listener("LuBuFactionMechanic") -- prevent duplicates
    core:add_listener(
        "LuBuFactionMechanic",
        "CharacterPostBattleEnslave",
		function(context)
			if( context:modify_character():query_character():generation_template_key() == "3k_main_template_historical_lu_bu_hero_fire") then 
				return true
			end
		end,
    function(context)
		CusLog("..!! LuBus movement replenished PostBattle!")
        ResetLuBusMovement()
		end,
    true
 );
end

function LuBuBonusMovementListener()
    CusLog("### LuBuBonusMovementListener 2 loading ###")
    core:remove_listener("LuBuBonusMovement") -- prevent duplicates
	core:add_listener(
		"LuBuBonusMovement",
		"CharacterFinishedMovingEvent",
		function(context)
            if cm:get_saved_value("lubu_bonus_movement")==true then 
                if context:query_character():generation_template_key()== "3k_main_template_historical_lu_bu_hero_fire" then 
                    local lubu = getQChar("3k_main_template_historical_lu_bu_hero_fire")
                    local timesUsed= cm:get_saved_value("lubu_turncounter");
                    CusLog("....Timesused="..tostring(timesUsed))
                    cm:set_saved_value("lubu_turncounter", timesUsed-1);
                    return cm:get_saved_value("lubu_turncounter") > 0; 
                end
            end
            return false;
		end,
        function(context)
            CusLog("???Callback: LuBuBonusMovement ###")
            local max=cm:get_saved_value("lubu_turntime");
            local rolled_value = cm:random_number( 0, max );
            local to_beat=2;
           CusLog("...LuBuBonusMovement Rolled a "..tostring(rolled_value).." needs "..tostring(to_beat).."   (max was):"..tostring(max))
           if rolled_value > to_beat then 
                ResetLuBusMovement() 
                cm:set_saved_value("lubu_turntime", max-1)
           end
           
        end,
		true
    )
end



local function LubuMovementVariables()
   CusLog("Debug: LubuMovementVariables")
    
    CusLog("  LuBuMovement lubu_turntime= "..tostring(cm:get_saved_value("lubu_turntime")))
    CusLog("  LuBuMovement lubu_turncounter= "..tostring(cm:get_saved_value("lubu_turncounter")))
    CusLog("  LuBuMovement lubu_decided= "..tostring(cm:get_saved_value("lubu_decided")))

    CusLog("  LuBuMovement lu_bu_fire_yuan_shu_rejection= "..tostring(cm:get_saved_value("lu_bu_fire_yuan_shu_rejection")))
    CusLog("  LuBuMovement lu_bu_fire_yuan_shao_accepts= "..tostring(cm:get_saved_value("lu_bu_fire_yuan_shao_accepts")))
    CusLog("  LuBuMovement lu_bu_fire_yuan_shao_rumors= "..tostring(cm:get_saved_value("lu_bu_fire_yuan_shao_rumors")))
    CusLog("  LuBuMovement lu_bu_fire_zhang_yang_accepts= "..tostring(cm:get_saved_value("lu_bu_fire_zhang_yang_accepts")))
   
    CusLog("  LuBuMovement lubu_knows_zhangmiao= "..tostring(cm:get_saved_value("lubu_knows_zhangmiao")))
    CusLog("  LuBuMovement player_is_lu_bu= "..tostring(cm:get_saved_value("player_is_lu_bu")))   
    CusLog("  LuBuMovement lubu_took_puyang= "..tostring(cm:get_saved_value("lubu_took_puyang")))
    CusLog("  LuBuMovement doublecheck_vassal= "..tostring(cm:get_saved_value("doublecheck_vassal")))
   
  CusLog("passed testLubU")
end


cm:add_first_tick_callback(
    function(context)
        IniDebugger()
        LubuMovementVariables()
		if context:query_model():calendar_year() >= 190 and context:query_model():calendar_year() < 195 then
            if cm:get_saved_value("player_is_lu_bu")==nil and cm:get_saved_value("dong_zhuo_is_human") then  
				LuBuChangAnDelayListener() -- turned off in chanang drama cuz idk if it can call it 
			end
			if cm:get_saved_value("player_is_lu_bu")==true then -- Tells us the player is LuBu and ready
                LuBuChangAnDelayListener()
			    LuBu1ChoiceMadeListener()
                LuBu2ChoiceMadeListener()
                LuBu3ChoiceMadeListener()
				LuBu4ChoiceMadeListener()
                LuBusArmyMechanicListener()
                LuBuBonusMovementListener()
                EnteredPuYangListener()
                LuBuMeetsZhangMiaoListener()
                ZhangYangAcceptsListener()
				if cm:get_saved_value("lu_bu_fire_yuan_shu_rejection") then
					YuanShuRejectionDelayListener(); -- this one is weird because we fire an incident (undoing this)
					--YuanShuRejectsListener();		-- then listen for the follow up dilemma here 
				end 
				if cm:get_saved_value("lu_bu_fire_yuan_shao_accepts") then
					YuanShaoAcceptsListener();
                end
                if cm:get_saved_value("lubu_bonus_movement") then
                    LuBuMoveDecayListener();
                end
               if cm:get_saved_value("lu_bu_fire_yuan_shao_rumors") ~=nil then
                    if cm:get_saved_value("lu_bu_fire_yuan_shao_rumors") >=0 then 
                        YuanShaoRumorsDelayListener()
                    else 
                        CusLog("lu_bu_fire_yuan_shao_rumors="..tostring(cm:get_saved_value("lu_bu_fire_yuan_shao_rumors")))
                    end
                end
        elseif context:query_model():date_in_range(194,198) then --a bit more time on these
            EnteredPuYangListener()
            YuanShaoRumorsListener()
            ZhangYangAcceptsListener()
            LuBuMeetsZhangMiaoListener()
            LuBusArmyMechanicListener()
		elseif cm:get_saved_value("player_is_lu_bu")==true then --persisit throughout the campaign
            if cm:get_saved_value("lubu_in_route")==true then 
                EnteredPuYangListener()
            end
            LuBusArmyMechanicListener()-- enable a listener that works for Lu Bus unique faction mechanic, but only for his army this time
        end
        
        if not cm:get_saved_value("lubu_knows_zhangmiao") and cm:get_saved_value("lubu_meet_zhangmiao") then 
            MeetZhangMiao() -- maybe the event didnt persist across saves?
        end
        if cm:get_saved_value("doublecheck_vassal") then
            VassalsBuggedistener()
        end
    end
        ---TMP
        --TEST
       --cm:set_saved_value("lubu_turntime",100);
	end
)

