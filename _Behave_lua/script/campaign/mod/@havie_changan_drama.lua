--To:Do 195 Guo Si rebels against Li Jue
--> Chan An drama


local printStatements=false;



local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_changan_drama.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
        local header=" (changan_drama): "
		local line= time..header..text
		file:write(line.."\n")
        file:close()
		ModLog(header..text)
    end
end

local function IniDebugger()
	printStatements=true;
	local file = io.open("@havie_changan_drama.txt", "w+")
	CusLog("---Begin File----")
end


function AppointZhangYang()
    CusLog("AppointZhangYang!")
        if NotAPlayerFaction("3k_main_faction_dong_zhuo") then 
            FinishAppointingZhangYang()
        else  --if player is DZ get a dilemma asking if we want to appoint ZhangYang to Hedong following Wuang Kuang Death
           CusLog("..player is DZ!")
            DzZhangYangChoiceMadeListener()
            local playersFactionsTable = cm:get_human_factions()
            local playerFaction = playersFactionsTable[1]
            cm:trigger_dilemma(playerFaction,"3k_lua_wang_kuang_dilemma", true )
        end

        CusLog("Finish AppointZhangYang!")
end

function FinishAppointingZhangYang()
    CusLog("FinishAppointingZhangYang!")
    local qwangk = getQChar("3k_main_template_historical_wang_kuang_hero_metal")
    if not qwangk:is_null_interface() then
        local wangFaction= qwangk:faction();
        local zhangyangFaction = cm:query_faction("3k_main_faction_zhang_yang")
        cm:force_confederation(zhangyangFaction:name(),wangFaction:name())
        KillWangKuang(qwangk)
        --give them hedong capital too if not human (taken peacefully by yangfeng later)
        local hedong_region =cm:query_region("3k_main_hedong_capital")
        if(hedong_region:owning_faction():is_human()==false) then 
            cm:modify_model():get_modify_region(hedong_region):settlement_gifted_as_if_by_payload(cm:modify_faction(zhangyangFaction))      
        end
    else 
            CusLog("!!..WangKuang is null?? and Shouldnt be?")
    end

    CusLog("...end war")
     ForceADeal("3k_main_faction_zhang_yang", "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target")
    ForceADeal("3k_main_faction_zhang_yang", "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target")
    CusLog("...addtreasrue")
    cm:modify_faction("3k_main_faction_zhang_yang"):increase_treasury(2700) 
	
    CusLog("finished FinishAppointingZhangYang")
end

function KillWangKuang(wangkuang_character)
     CusLog("KillWangKuang Attempt")
    if(not wangkuang_character:is_null_interface()) then
        if(not wangkuang_character:is_dead()) then
            CusLog("hes not dead")
            local mwangkuang_character = cm:modify_character(wangkuang_character) 
            cm:modify_character(wangkuang_character):kill_character(false)
            CusLog("--Killed wangkuang_character")
        else
             CusLog("--dead-wangkuang_character?")
        end
    end
end


function dz_civil_war_dilemma()
	
	DzCivilWarChoiceMadeListener()
	fixMtuConcubine(); --prevents lady dong from marrying li Jue/WangYun/DongMin
    local q_dz_faction = cm:query_faction("3k_main_faction_dong_zhuo")
	if( q_dz_faction:is_human()) then 
         local triggered= cm:trigger_dilemma("3k_main_faction_dong_zhuo", "3k_lua_dz_civil_war_dilemma", true) 
	     if not triggered then 
	    	CusLog("@@@!!! Error,3k_lua_dz_civil_war_dilemma tried to trigger but failed? still fires later?")
	    else 
         CusLog("dz_civil_war_dilemma ocurred?")
        --turn off elsewhere
    end	
    
end

end


function PlayAsLuBu()
        CusLog("Begin PlayAsLuBu")
        local unit_list="3k_main_unit_fire_mercenary_cavalry_captain,3k_main_unit_fire_xiliang_cavalry,3k_main_unit_fire_heavy_xiliang_cavalry,3k_main_unit_metal_sabre_infantry"

        SpawnRealFaction("3k_main_faction_changan", "3k_main_template_historical_li_jue_hero_fire", "3k_main_anding_capital", "3k_main_faction_dong_zhuo", 281, 495,unit_list)
		CusLog("!!.Passed Spawn Real Faction")
		setupLiJuesFaction()
		
		
		cm:set_saved_value("player_is_lu_bu", true) -- starts event line in lubu_movement
		cm:set_saved_value("player_is_li_jue", false)
        --Make Peace with main warlords or loop through everyone except li jue
        MakePeaceAfterCivilWar()
	
		--IDK how this didnt crash calling below in script?
       -- LuBuChangAnDelayListener() -- fire the next dilemma next turn (could use RNG?)
        CusLog("finished PlayAsLuBu")

end

function PlayAsLiJue()

	 cm:set_saved_value("player_is_lu_bu", false)
	 cm:set_saved_value("player_is_li_jue", true)
	CusLog("Determine if Leader is Lubu or WangYun")
	local leaderKey="3k_main_template_historical_wang_yun_hero_earth"
	if getQChar2("3k_main_template_historical_wang_yun_hero_earth")==nil then 
		leaderKey="3k_main_template_historical_lu_bu_hero_fire"
	end
	CusLog("leader will be : "..leaderKey)
	local qFaction = cm:query_faction("3k_main_faction_dong_zhuo") -- hopefully can use DZ faction here since Changan Faction doesnt exist yet 
	local unit_list="3k_main_unit_earth_jian_cavalry_captain,3k_main_unit_wood_ji_militia,3k_main_unit_metal_jian_swordguards,3k_main_unit_metal_sabre_infantry"
	local found_pos, x, y = qFaction:get_valid_spawn_location_in_region("3k_main_changan_capital", false);
	local randomness1 = math.floor(cm:random_number(-2, 2 ));
	SpawnRealFaction("3k_main_faction_changan", leaderKey, "3k_main_changan_capital", "3k_main_faction_dong_zhuo", x+randomness1, y-randomness1,unit_list)
	
	 --Move LuBu and WangYun ppl into spawned faction
	SetupLuBusFaction("3k_main_faction_changan")
	--Give away ChangAn and Louyang TradePort
	local region1 =cm:query_region("3k_main_changan_capital")
	local region2 =cm:query_region("3k_main_changan_resource_1")
	local region3 =cm:query_region("3k_main_luoyang_resource_1") -- 1 or 2? or 3k_main_chenjun_resource_2 ?
	if not region1:is_null_interface() then 
		if region1:owning_faction():name() == "3k_main_faction_dong_zhuo" then
			CusLog("--Want to Transfer Region1--" )
			cm:modify_model():get_modify_region(region1):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_changan"))
			CusLog("--transferred Region1--")
		end
	end
	if not region2:is_null_interface() then 
		if region2:owning_faction():name() == "3k_main_faction_dong_zhuo" then
		   CusLog("--Want to Transfer Region2--" )
		   cm:modify_model():get_modify_region(region2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_changan"))
		   CusLog("--transferred Region2--")
		end
	end
	if not region3:is_null_interface() then 
		 if region3:owning_faction():name() == "3k_main_faction_dong_zhuo" then
		   CusLog("--Want to Transfer Region2--" )
		   cm:modify_model():get_modify_region(region3):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_changan"))
		   CusLog("--transferred Region2--")
		end
	end
	   --Could also abandon other land or give back to Han Empire?
	   --Incident to improve relation with Ma Teng? i think they end up at war? lol idk 
       --Make Peace with main warlords 
       MakePeaceAfterCivilWar()
	   CusLog("..applying civil war bonus and new debuffs")
	   cm:apply_effect_bundle("3k_main_effect_bundle_civil_war_separatists_grace_period", "3k_main_faction_dong_zhuo" , 4)
	   cm:apply_effect_bundle("3k_main_effect_bundle_civil_war_separatists_grace_period", "3k_main_faction_changan" , 3) -- little boost to maybe redeploy
	   cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua_lite", "3k_main_faction_changan" , 18) -- slowly lose
	   local MaTeng=getQFaction("3k_main_faction_ma_teng")
	   if MaTeng~= nil then 
			if MaTeng:is_human()==false then 
				cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", "3k_main_faction_ma_teng" , 16)
				cm:apply_effect_bundle("3k_main_introduction_mission_payload_recruit_units", "3k_main_faction_ma_teng" , 4)
				cm:apply_effect_bundle("3k_main_introduction_mission_payload_recruit_units", "3k_main_faction_zhang_lu" , 20)
			end
		end
end

function MakePeaceAfterCivilWar()

    local q_dongzhuo = cm:query_faction("3k_main_faction_dong_zhuo")
    local q_taoqian = cm:query_faction("3k_main_faction_tao_qian")
    local q_caocao = cm:query_faction("3k_main_faction_cao_cao")
    local q_liubei = cm:query_faction("3k_main_faction_liu_bei")
    local q_yuanshu = cm:query_faction("3k_main_faction_yuan_shu")
    local q_yuanshao = cm:query_faction("3k_main_faction_yuan_shao")
    local q_zhangyan = cm:query_faction("3k_main_faction_zhang_yan")
    local q_gongsunzan = cm:query_faction("3k_main_faction_gongsun_zan")
    local q_zhengjiang = cm:query_faction("3k_main_faction_zheng_jiang")
    local q_sunjian = cm:query_faction("3k_main_faction_sun_jian")
    local q_kongrong = cm:query_faction("3k_main_faction_kong_rong")
    local q_liubiao = cm:query_faction("3k_main_faction_liu_biao")
    local q_mateng = cm:query_faction("3k_main_faction_ma_teng")
    local q_liudai = cm:query_faction("3k_main_faction_liu_dai")
    local q_zhangyang = cm:query_faction("3k_main_faction_zhang_yang")


	--I switched these to try to suppress event feed
	 cm:apply_automatic_deal_between_factions(q_taoqian:name(), "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
	 cm:apply_automatic_deal_between_factions(q_caocao:name(), "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
	 cm:apply_automatic_deal_between_factions(q_liubei:name(), "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
	 cm:apply_automatic_deal_between_factions(q_yuanshu:name(), "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
	 cm:apply_automatic_deal_between_factions(q_yuanshao:name(), "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
	 cm:apply_automatic_deal_between_factions(q_zhangyan:name(), "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
	 cm:apply_automatic_deal_between_factions(q_gongsunzan:name(), "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
	 cm:apply_automatic_deal_between_factions(q_zhengjiang:name(), "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
	 cm:apply_automatic_deal_between_factions(q_kongrong:name(), "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
	 cm:apply_automatic_deal_between_factions(q_liubiao:name(), "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
	 cm:apply_automatic_deal_between_factions(q_mateng:name(), "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
     cm:apply_automatic_deal_between_factions(q_liudai:name(), "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
     cm:apply_automatic_deal_between_factions(q_zhangyang:name(), "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
     
	 --Fail safe with the event suppression
    cm:modify_faction(q_taoqian):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_dongzhuo, "");
    cm:modify_faction(q_caocao):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_dongzhuo, "");
    cm:modify_faction(q_liubei):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_dongzhuo, "");
    cm:modify_faction(q_yuanshu):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_dongzhuo, "");
    cm:modify_faction(q_yuanshao):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_dongzhuo, "");
    cm:modify_faction(q_zhangyan):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_dongzhuo, "");
    cm:modify_faction(q_gongsunzan):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_dongzhuo, "");
    cm:modify_faction(q_zhengjiang):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_dongzhuo, "");
    cm:modify_faction(q_sunjian):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_dongzhuo, "");
    cm:modify_faction(q_zhengjiang):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_dongzhuo, "");
    cm:modify_faction(q_kongrong):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_dongzhuo, "");
    cm:modify_faction(q_liubiao):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_dongzhuo, "");
    cm:modify_faction(q_mateng):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_dongzhuo, "");
    cm:modify_faction(q_liudai):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_dongzhuo, "");
    cm:modify_faction(q_zhangyang):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_dongzhuo, "");
	

end


function fixMtuConcubine() -- takes lady dong out

    mtu_global_events.leader_milf_list = {
        "3k_main_template_historical_lady_diao_chan_hero_water",
        "3k_main_template_historical_lady_da_qiao_hero_earth",
        "3k_main_template_historical_lady_xiao_qiao_hero_metal",
        "3k_mtu_template_historical_lady_wu_minyu_hero_earth",
        "3k_mtu_template_historical_lady_wang_liting_hero_metal",
        "3k_main_template_historical_lady_sun_shangxiang_hero_fire",
        "3k_mtu_template_historical_lady_ma_lanli_hero_metal",
        "3k_mtu_template_historical_not_real_remove_for_event",
        "3k_mtu_template_historical_lady_ma_yunlu_hero_metal",
        "3k_dlc04_template_historical_empress_he_fire",
        "3k_mtu_template_historical_lady_du_hero_earth",
        "3k_mtu_template_historical_lady_feng_hero_earth",
        "3k_mtu_template_historical_lady_yuan_anyang_hero_water",
        "3k_dlc04_template_historical_lady_mi_earth",
        "3k_main_template_historical_lady_zheng_jiang_hero_wood",
        "3k_mtu_template_historical_lady_lu_zheng_hero_water",
        "3k_mtu_template_historical_lady_cai_yan_hero_water",
        "3k_main_template_historical_lady_bian_huilan_hero_wood",
        "3k_mtu_template_historical_lady_lu_ji_hero_wood",
        "3k_mtu_template_historical_lady_gongsun_jinting_hero_water",
        "3k_mtu_template_historical_lady_trieu_hero_wood"
    };
    CusLog("Finished concubine fix")
end


function MoveEmperorToLouyang()
    CusLog("Begin MoveEmperorToLouyang")
    local yangfeng = cm:query_model():character_for_template("3k_main_template_historical_yang_feng_hero_wood")
    if yangfeng:is_null_interface()==false and yangfeng:is_faction_leader() ==true then
    -- check louyang owend by player
        local playersFactionsTable = cm:get_human_factions()
        local playerFaction = playersFactionsTable[1]
        local yangfeng_faction_name= yangfeng:faction():name();

        local louyang_region =cm:query_region("3k_main_luoyang_capital")
        local hedong_region =cm:query_region("3k_main_hedong_capital")
        if louyang_region:owning_faction():name() ~= playerFaction then
                  CusLog("..Louyang not owned by player")
                  CusLog(".. get rid of he dong")
                  local zyFaction= cm:query_faction("3k_main_faction_zhang_yang")
                  if not zyFaction:is_null_interface() and not zyFaction:is_dead() then 
                    cm:modify_model():get_modify_region(hedong_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_zhang_yang"))
                  else
                    cm:modify_region(hedong_region):raze_and_abandon_settlement_without_attacking();
                  end
                    --CusLog("..give lou yang feng")
                    cm:modify_model():get_modify_region(louyang_region):settlement_gifted_as_if_by_payload(cm:modify_faction(yangfeng:faction()))
                    --cm:modify_model():get_modify_region(region_script_interface):settlement_gifted_as_if_by_payload(faction_script_interface)
                    local found_pos, x, y = yangfeng:faction():get_valid_spawn_location_in_region("3k_main_luoyang_capital", false);
                  
                    --CusLog("..check armies")
                    -- teleport yang feng to lou yang
                    -- I could rewrite this to be better ,test first 
                    if yangfeng:has_military_force() == true then
                       CusLog("--yangfeng has military Force , teleport")
                         cm:modify_model():get_modify_character(yangfeng):teleport_to(x,y)
                    end

                    --check xu huang
                    local xuhuang = cm:query_model():character_for_template("3k_main_template_historical_xu_huang_hero_metal")
                    if xuhuang:is_null_interface()==false and xuhuang:faction():name() ==yangfeng_faction_name and xuhuang:has_military_force() then
                    cm:modify_model():get_modify_character(xuhuang):teleport_to(x+1,y-2) --(399,486)
                    else
                        CusLog("..@ XuHuang invalid?")
                    end


                    
        end
          
        CusLog("..move emp to yang feng")
        -- Move emperor to yang feng
        local lijue = cm:query_model():character_for_template("3k_main_template_historical_li_jue_hero_fire")
        local lijue_faction = lijue:faction()    
        campaign_emperor_manager:transfer_token_to_faction(cm:modify_faction(yangfeng_faction_name):query_faction(), lijue_faction, "emperor")
        
        if not cm:is_world_power_token_owned_by("emperor", yangfeng:faction()) then
            campaign_emperor_manager:transfer_token_to_faction(cm:modify_faction(yangfeng_faction_name):query_faction(), lijue_faction, "emperor")
            CusLog("Wtf Emperor didnt transfer???")
        end
        CusLog("--move complete")


    -- declare war lijue guo si
     CusLog("--Declare War on Li Jue")
     cm:modify_faction(yangfeng:faction()):apply_automatic_diplomatic_deal("data_defined_situation_war", lijue:faction(), ""); 
     CusLog("--War Declared")


    --fire an event that is trigger for cao cao to take emperor 
    cm:trigger_incident(playerFaction,"3k_lua_yang_feng_takes_emperor", true )

    CusLog("Finished MoveEmperorToLouyang")
    end
end


function LiJueTakesEmperor(owningFaction)
   
   CusLog("starting LiJueTakeEmperor")
    local lijue = cm:query_model():character_for_template("3k_main_template_historical_li_jue_hero_fire")
    local lijue_faction = lijue:faction()

    -- Move emperor 
	campaign_emperor_manager:transfer_token_to_faction(cm:modify_faction(lijue_faction:name()):query_faction(), owningFaction, "emperor")
    --campaign_emperor_manager.dynamic_variables[lijue_faction:name()]["emperor_flag"] = 2
    -- give them chang an
      --set up anding2
      local changan =cm:query_region("3k_main_changan_capital")
      if changan:owning_faction():is_human() == false then -- if lu bu split, li jue doesnt get
        CusLog("--Want to Transfer Region--" .. tostring(changan:name()) )      -- key shud be okay
         cm:modify_model():get_modify_region(changan):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_changan"))
         --CusLog("--transferred Region--")
     end

    --Fire an event
   -- MoveEmperorToLouyangListener() -- cant call the listener cuz its below
    local playersFactionsTable = cm:get_human_factions()
    local playerFaction = playersFactionsTable[1]
    cm:trigger_incident(playerFaction,"3k_lua_li_jue_takes_emperor", true )
    CusLog("..Moved Emperor to Li Jue")
    cm:set_saved_value("li_jue_took_emperor", true);

    CusLog("Finished LiJueTakeEmperor")
end


function LiJueEmperorListener()
    CusLog("### LiJueEmperor Listener loading ###")
    core:remove_listener("LiJueEmperor")
	core:add_listener(
		"LiJueEmperor",
		"FactionTurnEnd",
        function(context)
            local faction_key = context:faction():name();
            if cm:is_world_power_token_owned_by("emperor", faction_key) and cm:get_saved_value("li_jue_took_emperor") ~=true  then
                CusLog("..Emperor is owned by " .. tostring(faction_key) .." _____  checking if li jue should steal")
                local lijue = cm:query_model():character_for_template("3k_main_template_historical_li_jue_hero_fire")
                if not lijue:is_null_interface() then
                    if( lijue:is_faction_leader()) then
                       CusLog("..Li Jue is faction leader:")
                        if context:query_model():calendar_year() >= 195 then -- was 196?seems late   
                            if  lijue:faction():name() ~= faction_key then 
                                 local rolled_value = cm:random_number( 0, 5 );
                                 local to_beat=2;
                                 if cm:get_saved_value("player_is_lu_bu")==true then -- if he stays and fights
                                    to_beat=4;
                                end
                                CusLog("LiJue Rolled a "..tostring(rolled_value).." needs "..tostring(to_beat))
                                if rolled_value > to_beat then 
                                     return true
                                end
                            else
                                CusLog("..Li Jue owns the emperor,  turning off variable!")
                                cm:set_saved_value("li_jue_took_emperor",true)
                                --core:remove_listener("LiJueEmperor")
                            end
                        end
                    end
                end
             end
            return false
		end,
		function(context)
			CusLog("### LiJueEmperor passed ###")
             LiJueTakesEmperor(context:faction()) --   <-- turned off in "li_jue_took_emperor",
            core:remove_listener("LiJueEmperor");

          CusLog("removed listener")
		end,
		true
    )
end


function LouYangDelayListener() -- set by yang feng emergent faction
    CusLog("### LouYangDelayListener loading ###")
    core:remove_listener("LouYangDelayListener")
  --  output("talked about earlier")
	core:add_listener(
		"LouYangDelayListener",
		"FactionTurnEnd",
        function(context)
           local faction_key = context:faction():name();
            if cm:is_world_power_token_owned_by("emperor", faction_key) and cm:get_saved_value("move_emperor_louyang") == true and context:query_model():calendar_year() >194 then
            CusLog("--Trying to Pass Move Emperor to Louyang Delay, rolled a:")
                 return RNGHelper(2); --3
             end
             return false
		end,
		function()
            CusLog("### Passed LouYangDelayListener ###")
            MoveEmperorToLouyang()
            cm:set_saved_value("move_emperor_louyang",false)
            core:remove_listener("LouYangDelayListener");
         --   CusLog("removed listener")

		end,
		true
    )
end


function MoveEmperorToLouyangListener() --tells us to spawn yang feng
    CusLog("### MoveEmperorToLouyang listener loading ###")
    core:remove_listener("MoveEmperorToLouyang")
  --  output("talked about earlier")
	core:add_listener(
		"MoveEmperorToLouyang",
		"IncidentOccuredEvent",
		function(context)
             if context:incident() == "3k_lua_li_jue_takes_emperor" == true then
                    return true
             end
             
             return false
		end,
		function() --Somehow this didnt occur? we need a fall back
            CusLog("### Passed MoveEmperorToLouyang ###")
            cm:set_saved_value("SpawnYangFeng", true);
            register_yang_feng_emergent_faction_2()
            core:remove_listener("MoveEmperorToLouyang");
		end,
		true
    )
end

function EmperorToLouYangFallBackListener()-- this will spawn yang feng and move the emperor
    CusLog("### EmperorToLouYangFallBackListener loading ###")
    core:remove_listener("EmperorToLouYangFallBack")
	core:add_listener(
		"EmperorToLouYangFallBack",
		"FactionTurnEnd", --If u change to start doesnt work... if u change to end, player can miss it if he exits campaign..
        function(context)
            if context:faction():name() =="3k_main_faction_changan" then 
                CusLog(" Found li jue faction")
            if cm:is_world_power_token_owned_by("emperor", context:faction():name()) and cm:get_saved_value("move_emperor_louyang") ~= true and context:query_model():calendar_year() >=194 then
                return RNGHelper(2);
            end
          else
            return false;
          end
		end,
		function(context)
            CusLog("??? Callback: EmperorToLouYangFallBackListener ###")
            cm:set_saved_value("SpawnYangFeng", true);
            register_yang_feng_emergent_faction_2()
			CusLog("### Finished EmperorToLouYangFallBackListener ###")

		end,
		false
    )
end

function DzCivilWarChoiceMadeListener()
    CusLog("### DzCivilWarChoiceMadeListener loading ###")
    core:remove_listener("DilemmaChoiceMadeDzCivilWar")
    core:add_listener(
    "DilemmaChoiceMadeDzCivilWar",
    "DilemmaChoiceMadeEvent",
    function(context)
        CusLog("..Listening for 3k_lua_dz_civil_war_dilemma choice ")
        return context:dilemma() == "3k_lua_dz_civil_war_dilemma"
    end,
    function(context)
        CusLog("..! choice was:" .. tostring(context:choice()))
        cm:set_saved_value("dz_civil_war_dilemma", false); -- turn if off so listener stops , somehow this stays on??
         if context:choice() == 1 then
            --cm:set_saved_value("playLuBu", true);
            CusLog("Player chose to play Lu Bu")
            PlayAsLuBu()
         else  -- = 0
            CusLog("Player chose to play Li Jue")
			PlayAsLiJue()
         end
         --HAVE A FEELING THIS DOESNT END PROPERLY?
         CusLog("!X!X!X!X! FINISHED SUCCESFULLY, WANT TO KNOW DzCivilWarChoiceMadeListener ")
        core:remove_listener("DilemmaChoiceMadeDzCivilWar");
    end,
    true
);
end

function DzCivilWarListener()
    CusLog("### DzCivilWarListener loading ###")
    core:remove_listener("DzCivilWar")
	core:add_listener(
		"DzCivilWar",
		"FactionTurnEnd", --If u change to start doesnt work... if u change to end, player can miss it if he exits campaign..
        function(context)
          if context:faction():name() =="3k_main_faction_dong_zhuo" then 
                CusLog("DzCivilWarListener returning  "..tostring( cm:get_saved_value("dz_civil_war_dilemma")==true))
                return cm:get_saved_value("dz_civil_war_dilemma")==true
          else
            return false;
          end
		end,
		function(context)
            CusLog("??? Callback: DzCivilWarListener ###")
            dz_civil_war_dilemma()
            core:remove_listener("DzCivilWar");
			CusLog("### Finished DzCivilWarListener ###")

		end,
		false
    )
end


function DzZhangYangChoiceMadeListener()
    CusLog("### DzZhangYangChoiceMadeListener loading ###")
    core:remove_listener("DilemmaChoiceMadeDzZhangYang")
    core:add_listener(
    "DilemmaChoiceMadeDzZhangYang",
    "DilemmaChoiceMadeEvent",
    function(context)
        CusLog("..Listening for 3k_lua_wang_kuang_dilemma choice ")
        return context:dilemma() == "3k_lua_wang_kuang_dilemma"
    end,
    function(context)
        CusLog("..! choice was:" .. tostring(context:choice()))
         if context:choice() == 0 then
            FinishAppointingZhangYang()
         end
         core:remove_listener("DilemmaChoiceMadeDzZhangYang");
    end,
    true
);
end

function ZhangYangLandListener() --This is written all fucked up because I had it worded perfectly fine and it would crash on the first if dz or wk are null interface checks....Only AFTER wk was killed (meaning it passed once)
    CusLog("### ZhangYangLandListener loading ###")
    core:remove_listener("ZhangYangLand")
  --  output("talked about earlier")
	core:add_listener(
		"ZhangYangLand",
		"FactionTurnEnd",
        function(context)
           if context:faction():is_human() and context:query_model():date_in_range(190,193) and context:query_model():turn_number() >2 then 
                CusLog("..Checking ZhangYangLandListener")
                local dz= getQChar("3k_main_template_historical_dong_zhuo_hero_fire")
                if dz:is_null_interface() then 
                   CusLog("DZ is NULL")
                   -- core:remove_listener("ZhangYangLand");
                elseif dz:is_dead()==false  then 
                    CusLog("dz is not dead")
                    local wk= getQChar("3k_main_template_historical_wang_kuang_hero_metal")
                    if not wk:is_null_interface() then 
                        CusLog("WK not Null")
                        if not wk:is_dead() then 
                            CusLog("WK not Dead Trying to Pass ZhangYangLandListener, :")  
                            local chance = RNGHelper(5)
                            CusLog("holy hell, chance="..tostring(chance ))
                            return chance
                        else
                            CusLog("WK is dead so ingore")
                           -- core:remove_listener("ZhangYangLand")
                        end
                    end
                else 
                   --CusLog("Else...")
                   -- core:remove_listener("ZhangYangLand")
                end
            end
             return false
		end,
		function(context)
            CusLog("??? Callback ZhangYangLandListener ###")
            AppointZhangYang()
            CusLog("### Passed ZhangYangLandListener ###")
		end,
		false
    )
end

--This is temp, until I can figure out how to add lives to characters
function KeepWangYungAliveListener() -- move wangyung to that faction when diaochan occurs
        CusLog("### KeepWangYungAlive loading ###")
        core:remove_listener("KeepWangYungAlive")
        core:add_listener(
            "KeepWangYungAlive",
            "FactionTurnEnd",
            function(context)
               if context:faction():is_human() and context:query_model():date_in_range(188,193) then 
                    CusLog("..Checking if we need to keep wangyung alive")
                    local wy= getQChar("3k_main_template_historical_wang_yun_hero_earth")
                     if(wy:is_dead() ==false ) then 
                        if(wy:faction():name()~="3k_main_faction_dong_zhuo") then
                            return true -- if i move wangyun here, it crashes for no reason after completeing the move
                        end
                    else
                       -- CusLog("...fucking wangyung died??????!...again!?")
                       -- core:remove_listener("KeepWangYungAlive")
                    end
                end
                 return false
            end,
            function(context)
                CusLog("???Callback: KeepWangYungAlive ###")
                MoveCharToFaction("3k_main_template_historical_wang_yun_hero_earth","3k_main_faction_dong_zhuo" )
               if cm:get_saved_value("player_is_lu_bu") or cm:get_saved_value("player_is_lijue") then
                    CusLog("### Removing KeepWangYungAlive because player is lubu or lijue ")    
                    core:remove_listener("KeepWangYungAlive")
               end
               CusLog("### Finished KeepWangYungAlive callback ")
            end,
            true
        )
end

local function ChangAnVariables()
    CusLog("Debug: ChangAnVariables")

     CusLog("  ChangAnVariables dz_civil_war_dilemma= "..tostring(cm:get_saved_value("dz_civil_war_dilemma")))
     CusLog("  ChangAnVariables SpawnYangFeng= "..tostring(cm:get_saved_value("SpawnYangFeng")))
 
     CusLog("  ChangAnVariables move_emperor_louyang= "..tostring(cm:get_saved_value("move_emperor_louyang")))
     CusLog("  ChangAnVariables li_jue_took_emperor= "..tostring(cm:get_saved_value("li_jue_took_emperor")))
	CusLog("Passed: ChangAnVariables")
 end


cm:add_first_tick_callback(
    function(context)
		IniDebugger()
	    ChangAnVariables()
        if context:query_model():date_in_range(190,193) then
            ZhangYangLandListener()
            KeepWangYungAliveListener()
        end
		if context:query_model():date_in_range(191,195) then
            LiJueEmperorListener()
            MoveEmperorToLouyangListener()
			DzCivilWarListener()
        end
		if context:query_model():date_in_range(193,196) then
            MoveEmperorToLouyangListener()
            EmperorToLouYangFallBackListener()
            LouYangDelayListener()
        end
        --TMP
           -- cm:set_saved_value("dz_civil_war_dilemma",true)
        
        if cm:get_saved_value("dz_civil_war_dilemma")==true then 
            CusLog("!!..player exited campaign since civil war event, trying to restore..hope this works..")
            dz_civil_war_dilemma()
        end
    end
    

)