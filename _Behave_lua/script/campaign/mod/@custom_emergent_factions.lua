---> Emergent Factions

local printStatements=false;



local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@custom_emergent_factions.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
        local header=" (emergent_faction): "
		local line= time..header..text
		file:write(line.."\n")
        file:close()
		ModLog(header..text)
    end
end

local function IniDebugger()
	printStatements=true;
	local file = io.open("@custom_emergent_factions.txt", "w+")
	CusLog("---Begin File----")
end


function register_LuLingqi_emergent_faction_2() 
    
    CusLog("Setting Up Emergent Factions (LuLingqi)")
	cm:set_saved_value("LuLingqi_emergent_registered",true)
    local register_LuLingqi_emergent_faction_2 = emergent_faction:new("register_LuLingqi_emergent_faction_2", "3k_main_faction_yangzhou",cm:get_saved_value("lulingqi_key"),cm:get_saved_value("lulingqi_type"),cm:get_saved_value("LuLingqi_region"), false)
    register_LuLingqi_emergent_faction_2:add_spawn_dates(194, 214);
    register_LuLingqi_emergent_faction_2:add_spawn_condition(
		function()
            CusLog("Checking the condition to spawn LuLingqi_emergent_registered faction")
            if cm:get_saved_value("LuLingqiSpawned")~=true and cm:get_saved_value("SpawnLuLingqi")==true then
                   return true;
            end
            return false;
		end);
	    register_LuLingqi_emergent_faction_2:add_on_spawned_callback( 
        function()
            CusLog("SpawnLuLingqi faction")
            SetupLuLingqiFaction()
            cm:set_saved_value("SpawnLuLingqi", false);
            cm:set_saved_value("LuLingqiSpawned", true);
            cm:trigger_incident("3k_main_faction_yuan_shu","3k_lua_lulingqi_rebels",true)

        end);
        emergent_faction_manager:add_emergent_faction(register_LuLingqi_emergent_faction_2)
end


function register_YuanShang_emergent_faction_2()
    CusLog("Setting Up Emergent Factions (YuanShang)")
	cm:set_saved_value("YuanShang_emergent_registered",true)
    local register_YuanShang_emergent_faction_2 = emergent_faction:new("register_YuanShang_emergent_faction_2", "3k_main_faction_bohai","3k_main_template_historical_yuan_shang_hero_earth","3k_general_earth","3k_main_bohai_capital", false)
    register_YuanShang_emergent_faction_2:add_spawn_dates(199, 206);
    register_YuanShang_emergent_faction_2:add_spawn_condition(
		function()
            CusLog("Checking the condition to spawn YuanShang_emergent_registered faction")
            if cm:get_saved_value("YuanShangSpawned")~=true and cm:get_saved_value("SpawnYuanShang")==true then
               local leader=  getQChar2("3k_main_template_historical_yuan_shang_hero_earth")
                if leader==nil then 
                    --90% sure this is making clones and wont work 
                    --SpawnCharacter("3k_main_template_historical_yuan_shang_hero_earth", "3k_general_earth", "3k_main_faction_han_empire")
                    cm:get_saved_value("SpawnYuanShang",false)
                else
                    return true;
                end
            end
            return false;
		end);
	    register_YuanShang_emergent_faction_2:add_on_spawned_callback( 
        function()
            CusLog("SpawnYuanShang faction")
            SetupYuanShangFaction()
            cm:set_saved_value("SpawnYuanShang", false);
			cm:set_saved_value("YuanShangSpawned", true);

        end);
        emergent_faction_manager:add_emergent_faction(register_YuanShang_emergent_faction_2)
end

function register_CheZhou_emergent_faction_2() 
    
    CusLog("Setting Up Emergent Factions (CheZhou)")
	cm:set_saved_value("CheZhou_emergent_registered",true)  --3k_dlc05_faction_lu_bu_separatists  3k_main_faction_donghai
    local register_CheZhou_emergent_faction_2 = emergent_faction:new("register_CheZhou_emergent_faction_2", "3k_dlc05_faction_lu_bu_separatists","3k_main_template_historical_che_zhou_hero_water","3k_general_water",cm:get_saved_value("chezhou_region"), true)
    register_CheZhou_emergent_faction_2:add_spawn_dates(194, 203);
    register_CheZhou_emergent_faction_2:add_spawn_condition(
		function()
            CusLog("Checking the condition to spawn CheZhou_emergent_registered faction")
            if cm:get_saved_value("CheZhouSpawned")~=true and cm:get_saved_value("SpawnCheZhou")==true then
                local query_character= getQChar("3k_main_template_historical_che_zhou_hero_water")
                if not query_character:is_null_interface() then 
                    if query_character:is_character_is_faction_recruitment_pool() then
                        MoveCharToFactionHard("3k_main_template_historical_che_zhou_hero_water",'3k_main_faction_cao_cao')
                    end
                end
                return true;
            end
            return false;
		end);
	    register_CheZhou_emergent_faction_2:add_on_spawned_callback( 
        function()
            CusLog("SpawnCheZhou faction")
            SetupCheZhouFaction()
            cm:set_saved_value("SpawnCheZhou", false);
			cm:set_saved_value("CheZhouSpawned", true);

        end);
        emergent_faction_manager:add_emergent_faction(register_CheZhou_emergent_faction_2)
end

function register_YuanTan_emergent_faction_2() 
    
    CusLog("Setting Up Emergent Factions (YuanTan)")
	cm:set_saved_value("YuanTan_emergent_registered",true)
    local register_YuanTan_emergent_faction_2 = emergent_faction:new("register_YuanTan_emergent_faction_2", "3k_main_faction_taishan","3k_main_template_historical_yuan_tan_hero_earth","3k_general_earth","3k_main_taishan_capital", false)
    register_YuanTan_emergent_faction_2:add_spawn_dates(194, 195);
    register_YuanTan_emergent_faction_2:add_spawn_condition(
		function()
            CusLog("Checking the condition to spawn YuanTan_emergent_registered faction")
            if cm:get_saved_value("YuanTanSpawned")~=true and cm:get_saved_value("SpawnYuanTan")==true then
                local qShang= getQChar("3k_main_template_historical_yuan_shang_hero_earth")
                    if not qShang:is_null_interface() then 
                        if not qShang:is_dead() then 
                            if qShang:faction():name() ~="3k_main_faction_yuan_shao" then 
                                MoveCharToFactionHard("3k_main_template_historical_yuan_shang_hero_earth", "3k_main_faction_yuan_shao")
                            end
                            local mNewLeader = cm:modify_character(qShang) -- convert to a modifiable character
                                mNewLeader:assign_to_post("faction_heir");
                            return true;
                        else 
                            return true;
                        end
                    else 
                        return true;
                    end
            end
            return false;
		end);
	    register_YuanTan_emergent_faction_2:add_on_spawned_callback( 
        function()
            CusLog("SpawnYuanTan faction")
            SetupYuanTanFaction()
            cm:set_saved_value("SpawnYuanTan", false);
			cm:set_saved_value("YuanTanSpawned", true);

        end);
        emergent_faction_manager:add_emergent_faction(register_YuanTan_emergent_faction_2)
end

function register_zangba_emergent_faction_2() --- uses global DONGIRONMINE name
    
    CusLog("Setting Up Emergent Factions (zangba)")
	cm:set_saved_value("zangba_emergent_registered",true)
    local register_zangba_emergent_faction_2 = emergent_faction:new("register_zangba_emergent_faction_2", "3k_main_faction_dongjun","3k_main_template_historical_zang_ba_hero_wood","3k_general_wood",DONGIRONMINE, false)
    register_zangba_emergent_faction_2:add_spawn_dates(195, 197);
    register_zangba_emergent_faction_2:add_spawn_condition(
		function()
            CusLog("Checking the condition to spawn zangba_emergent_registered faction")
            if cm:get_saved_value("zangbaSpawned")~=true and cm:get_saved_value("Spawnzangba")==true then
				local qChar = getQChar("3k_main_template_historical_zang_ba_hero_wood")
				if not qChar:is_null_interface() then 
					if qChar:is_character_is_faction_recruitment_pool() then 
						MoveCharToFaction("3k_main_template_historical_zang_ba_hero_wood", "3k_main_faction_han_empire")
						return true;
					end
				end
			  return true;
            end
            return false;
		end);
	    register_zangba_emergent_faction_2:add_on_spawned_callback( 
        function()
            CusLog("Spawnzangba faction")
            SetupZangbaFaction()
            cm:set_saved_value("Spawnzangba", false);
			cm:set_saved_value("zangbaSpawned", true);

        end);
        emergent_faction_manager:add_emergent_faction(register_zangba_emergent_faction_2)
end

function register_twochens_emergent_faction_2()
    CusLog("Attempting to register two chens, does this still crash in 194?")
	local leaderName="3k_dlc_04_template_historical_chen_gui_water"
    local chengui= getQChar("3k_dlc_04_template_historical_chen_gui_water")
    if not chengui:is_null_interface() then 
        if chengui:is_dead() then 
            leaderName="3k_dlc04_template_historical_chen_deng_yuanlong_water"
        end
    end

    CusLog("Setting Up Emergent Factions (twochens)")
	cm:set_saved_value("twochens_emergent_registered",true)
    local register_twochens_emergent_faction_2 = emergent_faction:new("register_twochens_emergent_faction_2", "3k_main_faction_guangling",leaderName,"3k_general_water","3k_main_guangling_resource_1", true)
    register_twochens_emergent_faction_2:add_spawn_dates(191, 195);
    register_twochens_emergent_faction_2:add_spawn_condition(
		function()
            CusLog("Checking the condition to spawn twochens_emergent_registered faction")
            if cm:get_saved_value("TwoChensSpawned")~=true and cm:get_saved_value("SpawnTwoChens")==true then
                CusLog("checking if ze rong is the leader of this faction ")
                local qzerong=getQChar("3k_main_template_historical_ze_rong_hero_fire")
                if not qzerong:is_null_interface() then 
                    if not qzerong:is_dead() then 
                        local qFaction=qzerong:faction()
                        CusLog("ze rongs faciton name= "..tostring(qFaction:name()))
                        if qFaction:name()== "3k_main_faction_guangling" then 
                            CusLog("ze rongs faction is our faction, just kill him ")
                            cm:modify_character(qzerong):kill_character(false)
                            CusLog("Killed ze rong")
                            --Move ChenGui there
                            MoveCharToFactionHard("3k_dlc_04_template_historical_chen_gui_water")
                            local qChenGui= getModifyChar("3k_dlc_04_template_historical_chen_gui_water")
                            if not qChenGui:is_null_interface() then 
                                CusLog("making chengui leader ")
                                qChenGui:assign_to_post("faction_leader")
                                return true;
                            end
                        else 
                             return true;
                         end
                    else 
                        return true;
                    end
                else 
                    return true;
                end
            end
            return false;
		end);
	    register_twochens_emergent_faction_2:add_on_spawned_callback( 
        function()
            CusLog("SpawnTwoChens faction")
            SetupTwoChensFaction()
            cm:set_saved_value("SpawnTwoChens", false);
			cm:set_saved_value("TwoChensSpawned", true);

        end);
        emergent_faction_manager:add_emergent_faction(register_twochens_emergent_faction_2)
end

function register_zhang_xiu_emergent_faction_2() 
    
    CusLog("Setting Up Emergent Factions (zhang_xiu)")
	cm:set_saved_value("zhang_xiu_emergent_registered",true)
    local zhang_xiu_emergent_faction_2 = emergent_faction:new("zhang_xiu_emergent_faction_2", "3k_main_faction_runan","3k_main_template_historical_zhang_xiu_hero_fire","3k_general_fire","3k_main_nanyang_capital", false)
    zhang_xiu_emergent_faction_2:add_spawn_dates(195, 198);
    zhang_xiu_emergent_faction_2:add_spawn_condition(
		function()
            CusLog("Checking the condition to spawn zhang_xiu faction")
            local willRebel=false;
            local nanyang_region = cm:query_region("3k_main_nanyang_capital")
            if cm:get_saved_value("Spawnzhang_xiu")==true and cm:get_saved_value("Spawned_zhangxiu")~=true then
                local qFaction=cm:query_faction("3k_main_faction_nanyang")
                local qchengyu= getQChar("3k_main_template_historical_cheng_yu_hero_water")
                if qFaction:is_null_interface() then 
                    return true;
                elseif qFaction:is_dead() then 
                    return true;
                end
                -- our factions alive, gotta fix this 
                CusLog(" Fixing existing NanYang faction from before ")
                if not qchengyu:is_null_interface() then 
                    if qchengyu:is_dead()==false then 
                        if qchengyu:is_faction_leader() then
                            MoveCharToFaction("3k_main_template_historical_cheng_yu_hero_water","3k_main_faction_cao_cao")
                            AbandonLands("3k_main_faction_nanyang")
                            local qNewLeaderCqi=FindAndAppointSomeoneRandom("3k_main_faction_nanyang")
                            local mLeader= cm:modify_character(qNewLeaderCqi):kill_character(true);
                            return true;
                        else
                            return true;
                        end
                    else 
                        AbandonLands("3k_main_faction_nanyang")
                        return true;
                    end
                else
                    CusLog("..emergent:qchengyu is null???, will try to rebel anyway")
                    return true;
                end
            end
            return false 
		end);
	    zhang_xiu_emergent_faction_2:add_on_spawned_callback( 
        function()
            CusLog("Spawnzhang_xius faction")
            SetupZhang_XiusFaction()
            cm:set_saved_value("Spawnzhang_xiu", false);
			cm:set_saved_value("Spawned_zhangxiu", true);

        end);
        emergent_faction_manager:add_emergent_faction(zhang_xiu_emergent_faction_2)
end

function register_cheng_yu_emergent_faction_2() 
    
    CusLog("Setting Up Emergent Factions (ChengYu)")
	cm:set_saved_value("cheng_yu_emergent_registered",true)
    local cheng_yu_emergent_faction_2 = emergent_faction:new("cheng_yu_emergent_faction_2", "3k_main_faction_nanyang","3k_main_template_historical_cheng_yu_hero_water","3k_general_water","3k_main_nanyang_capital", true)
    cheng_yu_emergent_faction_2:add_spawn_dates(191, 195);
    cheng_yu_emergent_faction_2:add_spawn_condition(
		function()
            CusLog("Checking the condition to spawn chengyu faction")
            local willRebel=false;
            local nanyang_region = cm:query_region("3k_main_nanyang_capital")
            if cm:get_saved_value("ChengYuSpawned")~=true and cm:get_saved_value("SpawnChengYu")==true and nanyang_region:owning_faction():name() == "3k_main_faction_yuan_shu" or nanyang_region:owning_faction():name() == "3k_main_faction_cao_cao" then
                local qchengyu= getQChar("3k_main_template_historical_cheng_yu_hero_water")
                if not qchengyu:is_null_interface() then 
                    if qchengyu:is_dead()==false then 
                        if qchengyu:faction():name() ~= "3k_main_faction_yuan_shu" then
                            willRebel=true
                        elseif qchengyu:loyalty() <75 then
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
                    CusLog("..emergent:chengyu is null???, will try to rebel anyway")
                    willRebel=true
                end
            end
            return willRebel 
		end);
	    cheng_yu_emergent_faction_2:add_on_spawned_callback( 
        function()
            CusLog("SpawnChengyus faction")
            SetupChengYusFaction()
            cm:set_saved_value("SpawnChengYu", false);
			cm:set_saved_value("ChengYuSpawned", true);

        end);
        emergent_faction_manager:add_emergent_faction(cheng_yu_emergent_faction_2)
end

function register_zhou_xin_emergent_faction_2() 
    
    CusLog("Setting Up Emergent Factions (Zhou Xin)")
	cm:set_saved_value("zhou_xin_emergent_registered",true)
    local zhou_xin_emergent_faction_2 = emergent_faction:new("zhou_xin_emergent_faction_2", "3k_main_faction_runan","3k_main_template_historical_zhou_xin_hero_fire","3k_general_fire","3k_main_runan_resource_1", false)
    zhou_xin_emergent_faction_2:add_spawn_dates(190, 191);
    zhou_xin_emergent_faction_2:add_spawn_condition(
		function()
            CusLog("Checking the condition to spawn qzhouxin")
            if cm:get_saved_value("SpawnZhouXin")==true and cm:get_saved_value("ZhouXinSpawned")~=true then
               CusLog("Time to Spawn qzhouxin Faction")
                -- Check player does not own qzhouxin - if he does side branch new dilemma to send him 
                local qzhouxin = cm:query_model():character_for_template("3k_main_template_historical_zhou_xin_hero_fire")
                if not qzhouxin:is_null_interface() then
                    CusLog("qzhouxin NotNull")
                    if(not qzhouxin:is_dead()) then
                        if not qzhouxin:faction():is_null_interface() then 
                            if qzhouxin:faction():is_human() ==false then 
                                CusLog("qzhouxin is not in player faction")
                                -- Check Player does not Own Region
                                local qregion =cm:query_region("3k_main_runan_resource_1")
                                local region_owner = qregion:owning_faction()
                                if ((region_owner:is_human() )==false  or (region_owner:name() == "3k_main_faction_yuan_shu" ))then
                                   return true
                                 end
                            end
                        else
                            CusLog("ZhouXin doesnt have a faction")
                            local qregion =cm:query_region("3k_main_runan_resource_1")
                            local region_owner = qregion:owning_faction()
                            if ((region_owner:is_human() )==false  or (region_owner:name() == "3k_main_faction_yuan_shu" ))then
                                return true
                             end
                        end
                    end
                else 
                    CusLog("qzhouxin is Null so spawn")
                    return true;
                end
            end
            return false 
		end);
	    zhou_xin_emergent_faction_2:add_on_spawned_callback( 
        function()
            CusLog("Spawn Zhouxin faction")
            SetupZhouXinsFaction()
            cm:set_saved_value("SpawnZhouXin", false);
			cm:set_saved_value("ZhouXinSpawned", true);

        end);
        emergent_faction_manager:add_emergent_faction(zhou_xin_emergent_faction_2)
end


function register_yang_feng_emergent_faction_2() 
    
    CusLog("Setting Up Emergent Factions (yang Feng)")
	cm:set_saved_value("yan_feng_emergent_registered",true)
    local yang_feng_emergent_faction_2 = emergent_faction:new("yang_feng_emergent_faction_2", "3k_main_faction_hedong_separatists","3k_main_template_historical_yang_feng_hero_wood","3k_general_wood","3k_main_hedong_capital", true)
    yang_feng_emergent_faction_2:add_spawn_dates(191, 194);
    yang_feng_emergent_faction_2:add_spawn_condition(
		function()
            CusLog("Checking the condition to spawn yang feng")
            if cm:get_saved_value("SpawnYangFeng") and cm:get_saved_value("yangFeng_was_spawned")~=true then
              --  CusLog("Time to Spawn Yang Feng Faction")
                -- Check player does not own Yang Feng - if he does side branch new dilemma to send him 
                local qyangfeng = cm:query_model():character_for_template("3k_main_template_historical_yang_feng_hero_wood")
                if not qyangfeng:is_null_interface() then
                    if(not qyangfeng:is_dead()) then
                        if not qyangfeng:faction():is_null_interface() then 
                            if not qyangfeng:faction():is_human() then 
                                    CusLog("Yang feng is not in player faction")
                                    -- Check Player does not Own Hedong :
                                    local qregion =cm:query_region("3k_main_hedong_capital")
                                    local hedong_owner = qregion:owning_faction();
                                    if not hedong_owner:is_human() then
                                         return true
                                     end
                            else
                                 CusLog("@@@ WoW!, YangFeng is with the player! Trigger a Dilemma.. (To:Do) @@@")
                            end
                        else
                            CusLog("yang feng doesnt have a faction")
                            local qregion =cm:query_region("3k_main_hedong_capital")
                            local hedong_owner = qregion:owning_faction();
                             if not hedong_owner:is_human() then
                                 return true
                             end
                        end
                    end
                end
            end
            return false 
		end);
	    yang_feng_emergent_faction_2:add_on_spawned_callback( 
        function()
            CusLog("Spawn YangFengs faction")
            SetupYangFengsFaction()
            cm:set_saved_value("li_jue_took_emperor", false); --careful
            cm:set_saved_value("SpawnYangFeng", false);
            cm:set_saved_value("yangFeng_was_spawned",true);
            --Can try
            --core:remove_listener(
            --"INVASION_"..self.key
            --to get rid of this?

        end);
    emergent_faction_manager:add_emergent_faction(yang_feng_emergent_faction_2)
end

function register_li_jue_emergent_faction_2() 
    
    CusLog("Setting Up Emergent Factions (LiJue)")
    cm:set_saved_value("li_jue_emergent_registered",true)
    local li_jue_emergent_faction_2 = emergent_faction:new("li_jue_emergent_faction_2", "3k_main_faction_changan","3k_main_template_historical_li_jue_hero_fire","3k_general_fire","3k_main_anding_capital", false)
    li_jue_emergent_faction_2:add_spawn_dates(191, 194);   --191,194
    li_jue_emergent_faction_2:add_spawn_condition(
		function()
            CusLog("Checking the condition to spawn li Jue")
            if cm:get_saved_value("fall_of_empire")==true and cm:get_saved_value("lijue_was_spawned")~=true then
                 CusLog("Time to Spawn Li Jues Faction")
                 return true
            else
                CusLog("Wtf is fall_of_empire:"..tostring(cm:get_saved_value("fall_of_empire")))
            end
            return false 
		end);
	    li_jue_emergent_faction_2:add_on_spawned_callback( 
        function()
            CusLog("Spawn LiJues faction")
            SetupLiJuesFaction()
			cm:set_saved_value("lijue_was_spawned",true)
            cm:set_saved_value("fall_of_empire", false);
            cm:set_saved_value("li_jue_took_emperor", false);

        end);
    emergent_faction_manager:add_emergent_faction(li_jue_emergent_faction_2)
end

function register_lu_bu_emergent_faction_2() 
    
    CusLog("Setting Up Emergent Factions (LuBu)")
	cm:set_saved_value("lu_bu_emergent_registered",true)
    local lu_bu_emergent_faction_2 = emergent_faction:new("lu_bu_emergent_faction_2", "3k_main_faction_lu_bu","3k_main_template_historical_lu_bu_hero_fire","3k_general_fire",CHENLIU, true)
    lu_bu_emergent_faction_2:add_spawn_dates(194, 195);
    lu_bu_emergent_faction_2:add_spawn_condition(
		function()
         --   CusLog("Checking the condition to spawn lu bu")
            if cm:get_saved_value("lu_bu_to_yingchuan") and cm:get_saved_value("ai_lubu_emerged")~=true then
                local qlubu=getQChar("3k_main_template_historical_lu_bu_hero_fire")
                if qlubu:is_faction_leader() then 
                    --Find an appoint someone random 
                    local qFaction= cm:query_faction("3k_main_faction_han_empire")
                    for i=0, qFaction:character_list():num_items()-1 do 
                        --CusLog("looking through character #"..tostring(i))
                        local qgeneral= qFaction:character_list():item_at(i)
                        if not qgeneral:has_garrison_residence() then 
                            if  qgeneral:character_post():is_null_interface() then
                                CusLog("Trying to move: "..tostring(qgeneral:generation_template_key()))
                               -- MoveCharToFaction(qgeneral:cqi(), qlubu:faction():name());
                                local mNewLeader = cm:modify_character(qgeneral) -- convert to a modifiable character
					            mNewLeader:set_is_deployable(true) -- keep this here, CA does before 
					            mNewLeader:move_to_faction_and_make_recruited(qlubu:faction():name()) --CA grabs the Modify char again before moving
                                mNewLeader:assign_to_post("faction_leader");
                                if qgeneral:faction():name() == qlubu:faction():name() then 
                                    CusLog("Move succeeded")
                                    return true;
                                else
                                    CusLog(" GG...hope for the best?")
                                    return true;
                                end
                                
                            end
                        end
                    end
                end
                CusLog("Time to Spawn Lu Bus Faction")
               return true;
            end
            return false 
		end);
	    lu_bu_emergent_faction_2:add_on_spawned_callback( 
        function()
            CusLog("Spawn LuBus faction")
            SetupLuBusFaction("3k_main_faction_lu_bu")
            cm:set_saved_value("lu_bu_to_yingchuan", false); 
				cm:set_saved_value("ai_lubu_emerged",true)

        end);
    emergent_faction_manager:add_emergent_faction(lu_bu_emergent_faction_2)
end

function FixCppLuBu() --Should trace back to where i put this and investigate some more
    CusLog("!!..I heard you! undoing hardcoded invasion")
    local lubu = cm:query_model():character_for_template("3k_main_template_historical_lu_bu_hero_fire")
    if not lubu:is_null_interface() then
        if(not lubu:is_dead()) then
            local mlubu = cm:modify_character(lubu)  
            mlubu:set_is_deployable(true)
            mlubu:move_to_faction_and_make_recruited("3k_main_faction_dong_zhuo")
            mlubu:add_loyalty_effect("extraordinary_success");
            mlubu:add_loyalty_effect("presented_gift");
            mlubu:assign_to_post("3k_main_court_offices_minister_fire_default");
            CusLog("!!..Moved lubu back to DongZhuos faction, Idk what will happen with rest of invasion")
        else
            CusLog("@@..dead-lubu")
        end
    else
        CusLog("@@..cant find lubu")
    end
  
    
end

function fixFactionAlive(key)
    CusLog("@@@heard::" .. tostring(key) .." is trying to be spawned but alive, maybe we should do something?")
        --Should try to find emergent_faction:remove()
end


function SetupLuLingqiFaction()
    CusLog("Running SetupLuLingqiFaction")
    local qleader = cm:query_model():character_for_template(cm:get_saved_value("lulingqi_key"))
    local qleader_faction = qleader:faction()
    if(qleader_faction:is_null_interface()==false) then 
        local chosenFaction=qleader_faction:name();
     
        cm:modify_faction(qleader_faction:name()):increase_treasury(15700) -- gotta last a bit 

        cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", qleader_faction:name() , 8)  
        cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", qleader_faction:name() , 15)    

        local found_pos, x, y = qleader_faction:get_valid_spawn_location_in_region(qleader_faction:name(), false);
        local unit_list="3k_main_unit_wood_ji_infantry_captain,3k_dlc05_unit_metal_camp_crushers,3k_dlc05_unit_fire_formation_breakers, 3k_main_unit_metal_sabre_infantry"

        cm:create_force_with_existing_general(qleader:cqi(), qleader_faction:name(), unit_list, cm:get_saved_value("LuLingqi_region"), x, y,tostring(qleader:cqi()+x+y),nil, 100);
      
        CusLog("Force war")
        --Force War
        cm:force_declare_war(chosenFaction, "3k_main_faction_yuan_shu", true);

       
    end
    CusLog("Finished SetupLuLingqiFaction")
end
function SetupYuanShangFaction()
	 CusLog("Running SetupYuanShangFaction")
    local qleader = cm:query_model():character_for_template("3k_main_template_historical_yuan_shang_hero_earth")
    local qleader_faction = qleader:faction()
    if(qleader_faction:is_null_interface()==false) then 
        local chosenFaction=qleader_faction:name();
     
        cm:modify_faction(qleader_faction:name()):increase_treasury(17700) -- hes gotta last a bit 

        cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", qleader_faction:name() , 8)  
        cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", qleader_faction:name() , 15)    

        local found_pos, x, y = qleader_faction:get_valid_spawn_location_in_region(qleader_faction:name(), false);
        local unit_list="3k_main_unit_wood_ji_infantry_captain,3k_main_unit_wood_warriors_of_ye,3k_main_unit_wood_warriors_of_ye, 3k_main_unit_metal_sabre_infantry"

        cm:create_force_with_existing_general(qleader:cqi(), qleader_faction:name(), unit_list, "3k_main_beihai_capital_capital", x, y,"3k_yuanshang01",nil, 100);
      
        CusLog("Force war")
        --Force War
        cm:force_declare_war(chosenFaction, "3k_main_faction_cao_cao", true);

        local region1= cm:query_region("3k_main_bohai_resource_1")
        local region2= cm:query_region("3k_main_youbeiping_capital")
        local region3= cm:query_region("3k_main_pingyuan_capital")
        if not region1:is_null_interface() then 
            if not region1:owning_faction():is_human() then 
                cm:modify_model():get_modify_region(region1):settlement_gifted_as_if_by_payload(cm:modify_faction(chosenFaction))
            end
        end
        if not region2:is_null_interface() then 
            if not region2:owning_faction():is_human() then 
                cm:modify_model():get_modify_region(region2):settlement_gifted_as_if_by_payload(cm:modify_faction(chosenFaction))
            end
        end
        if not region3:is_null_interface() then 
            if not region3:owning_faction():name()=="3k_main_faction_cao_cao" then 
                cm:modify_model():get_modify_region(region3):settlement_gifted_as_if_by_payload(cm:modify_faction(chosenFaction))
            end
        end
    end
    CusLog("Finished SetupYuanShangFaction")

end

function SetupCheZhouFaction()
    CusLog("Running SetupCheZhouFaction")
    local qleader = cm:query_model():character_for_template("3k_main_template_historical_che_zhou_hero_water")
    local qleader_faction = qleader:faction()
    if(qleader_faction:is_null_interface()==false) then 
        local chosenFaction=qleader_faction:name();
        ChangeRelations(qleader:generation_template_key(), "3k_main_template_historical_cao_cao_hero_earth", "3k_main_relationship_trigger_set_event_positive_generic_large") 
    
        cm:modify_faction(qleader_faction:name()):increase_treasury(15700) -- hes gotta last a bit 

        cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", qleader_faction:name() , 8)  
        cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", qleader_faction:name() , 15)    

        local found_pos, x, y = qleader_faction:get_valid_spawn_location_in_region(qleader_faction:name(), false);
        local unit_list="3k_main_unit_wood_ji_infantry_captain,3k_main_unit_metal_sabre_infantry,3k_main_unit_metal_sabre_infantry, 3k_main_unit_metal_sabre_infantry"

        cm:create_force_with_existing_general(qleader:cqi(), qleader_faction:name(), unit_list, "3k_main_guangling_capital", x, y,qleader_faction:name()..tostring(x+y),nil, 100);
       --Force vassal
       CusLog("make vassal")
       cm:apply_automatic_deal_between_factions("3k_main_faction_cao_cao", chosenFaction, "data_defined_situation_vassalise_recipient_forced", false);
   
        --CusLog("Force war")
        --Force War
        --cm:force_declare_war(chosenFaction, "3k_main_faction_kong_rong", true);

        local region1= cm:query_region(PENGCHENGFARM)
        local region2= cm:query_region(PENGCHENGTEMPLE)
        local region3= cm:query_region(XIAPICITY)
        if not region1:is_null_interface() then 
            if region1:owning_faction():name() == "3k_main_faction_cao_cao" then 
                cm:modify_model():get_modify_region(region1):settlement_gifted_as_if_by_payload(cm:modify_faction(chosenFaction))
            end
        end
        if not region2:is_null_interface() then 
            if region2:owning_faction():name() == "3k_main_faction_cao_cao" then 
                cm:modify_model():get_modify_region(region2):settlement_gifted_as_if_by_payload(cm:modify_faction(chosenFaction))
            end
        end
        if not region3:is_null_interface() then 
            if region3:owning_faction():name() == "3k_main_faction_cao_cao" or region3:owning_faction():name() == "3k_main_faction_guangling"  then 
                cm:modify_model():get_modify_region(region3):settlement_gifted_as_if_by_payload(cm:modify_faction(chosenFaction))
            else
                region3= cm:query_region("3k_main_langye_capital")
                if region3:owning_faction():name() == "3k_main_faction_cao_cao" or region3:owning_faction():name() == "3k_main_faction_guangling"  then 
                    cm:modify_model():get_modify_region(region3):settlement_gifted_as_if_by_payload(cm:modify_faction(chosenFaction))
                end
            end
        end
    end
	
	--if chen deng isnt a vassal of cao cao do now?
	
    CusLog("Finished SetupCheZhouFaction")
end

function SetupYuanTanFaction()
    CusLog("Running SetupYuanTanFaction")
    local qleader = cm:query_model():character_for_template("3k_main_template_historical_yuan_tan_hero_earth")
    local qleader_faction = qleader:faction()
    if(qleader_faction:is_null_interface()==false) then 
        local chosenFaction=qleader_faction:name();
        ChangeRelations(qleader:generation_template_key(), "3k_main_template_historical_yuan_shao_hero_earth", "3k_main_relationship_trigger_set_event_positive_generic_large") 
    
        cm:modify_faction(qleader_faction:name()):increase_treasury(19700) -- hes gotta last a bit 

        cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", qleader_faction:name() , 8)  
        cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", qleader_faction:name() , 15)    

        local found_pos, x, y = qleader_faction:get_valid_spawn_location_in_region("3k_main_faction_taishan", false);
        local unit_list="3k_main_unit_wood_ji_infantry_captain,3k_main_unit_wood_warriors_of_ye,3k_main_unit_wood_warriors_of_ye, 3k_main_unit_metal_sabre_infantry"

        cm:create_force_with_existing_general(qleader:cqi(), qleader_faction:name(), unit_list, "3k_main_taishan_capital", x, y,"3k_yuantan01",nil, 100);
       --Force vassal
       CusLog("make vassal")
       cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shao", chosenFaction, "data_defined_situation_vassalise_recipient_forced", false);
   
        CusLog("Force war")
        --Force War
        cm:force_declare_war(chosenFaction, "3k_main_faction_kong_rong", true);

        local region1= cm:query_region("3k_main_taishan_resource_1")
        local region2= cm:query_region("3k_main_pingyuan_resource_1")
        if not region1:is_null_interface() then 
            if not region1:owning_faction():is_human() or region1:owning_faction():name()=="3k_main_faction_kong_rong" or region1:owning_faction():name()=="3k_main_faction_yuan_shao" then 
                cm:modify_model():get_modify_region(region1):settlement_gifted_as_if_by_payload(cm:modify_faction(chosenFaction))
            end
        end
        if not region2:is_null_interface() then 
            if not region2:owning_faction():is_human()or region2:owning_faction():name()=="3k_main_faction_kong_rong" or region2:owning_faction():name()=="3k_main_faction_yuan_shao"  then 
                cm:modify_model():get_modify_region(region2):settlement_gifted_as_if_by_payload(cm:modify_faction(chosenFaction))
            end
        end
    end
    CusLog("Finished SetupYuanTanFaction")
end

function SetupZangbaFaction()
    CusLog("Running SetupZangbaFaction")
    --Sun_guan Wu Dun, Yin Li, and Chang Xi-
    local qleader = cm:query_model():character_for_template("3k_main_template_historical_zang_ba_hero_wood")
    local qleader_faction = qleader:faction()
    if(qleader_faction:is_null_interface()==false) then 
        local chosenFaction=qleader_faction:name();

        local qchar1= getQChar("3k_main_template_historical_chang_xi_hero_wood")
        local qchar2= getQChar("3k_main_template_historical_yin_li_hero_metal")
        if not qchar1:is_null_interface() then 
			MoveCharToFactionHard(qchar1:generation_template_key(), chosenFaction)
		else 
			CusLog("@Warning: Couldnt find ".."3k_main_template_historical_chang_xi_hero_wood".." Spawning in:"..tostring(chosenFaction));
			cdir_events_manager:spawn_character_subtype_template_in_faction(chosenFaction, "3k_general_wood", "3k_main_template_historical_yin_li_hero_metal");
		
        end
        ChangeRelations(qleader:generation_template_key(), qchar1:generation_template_key(), "3k_main_relationship_trigger_set_event_positive_generic_large") 
    
        if not qchar2:is_null_interface() then 
			MoveCharToFactionHard(qchar2:generation_template_key(), chosenFaction)
		else 
			CusLog("@Warning: Couldnt find ".."3k_main_template_historical_yin_li_hero_metal".." Spawning in:"..tostring(chosenFaction));
			cdir_events_manager:spawn_character_subtype_template_in_faction(chosenFaction, "3k_general_metal", "3k_main_template_historical_chang_xi_hero_wood");
		
        end
        ChangeRelations(qleader:generation_template_key(), qchar2:generation_template_key(), "3k_main_relationship_trigger_set_event_positive_generic_large") 
    
        --Get cause could be spawned above
        local mChar=getModifyChar("3k_main_template_historical_yin_li_hero_metal")
        if not mChar:is_null_interface() then 
            CusLog("making _yin_li  heir")
            mChar:assign_to_post("faction_heir");
        end

        CusLog("_give qleader_faction money")
        cm:modify_faction(qleader_faction:name()):increase_treasury(12700)
        cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", qleader_faction:name() , 8)  
        cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", qleader_faction:name() , 25)    

        local found_pos, x, y = qleader_faction:get_valid_spawn_location_in_region(DONGIRONMINE, false);
        local unit_list="3k_main_unit_wood_ji_infantry_captain,3k_dlc05_unit_metal_bandit_warriors,3k_dlc05_unit_fire_bandit_raiders,3k_dlc05_unit_water_bandit_hunters, 3k_dlc05_unit_fire_bandit_raiders"

        cm:create_force_with_existing_general(qleader:cqi(), qleader_faction:name(), unit_list, DONGIRONMINE, x, y,"3k_zangba",nil, 100);
        cm:create_force_with_existing_general(qchar1:cqi(), qleader_faction:name(), unit_list, DONGIRONMINE, x+2, y-2,"3k_zangba2",nil, 100);
       
        local temple= cm:query_faction(PENGCHENGTEMPLE) --Global
        if not temple:is_null_interface() then 
            CusLog("--Roll to transfer temple--" )
            if RNGHelper(4) then 
                 cm:modify_model():get_modify_region(temple):settlement_gifted_as_if_by_payload(cm:modify_faction(qleader_faction:name()))
            end
        else
            CusLog("Temple is null, check globals")
        end

        CusLog("Spawned Force")

    end

    CusLog("Finished SetupZangbaFaction")
end

function SetupTwoChensFaction()
    CusLog("Running SetupTwoChensFaction")
    local qleader = cm:query_model():character_for_template("3k_dlc_04_template_historical_chen_gui_water")
    local qleader_faction = cm:query_faction("3k_main_faction_guangling")
    
    if(qleader_faction:is_null_interface()==false) then 
        
        local qchar2= getQChar("3k_dlc04_template_historical_chen_deng_yuanlong_water")
        local chosenFaction=qleader_faction:name();
        if not qchar2:is_null_interface() and qchar2:faction():name() ~= chosenFaction then 
			MoveCharToFactionHard(qchar2:generation_template_key(), chosenFaction)
		else 
			CusLog("@Warning: Couldnt find ".."3k_dlc04_template_historical_chen_deng_yuanlong_water".." Spawning in:"..tostring(chosenFaction));
			cdir_events_manager:spawn_character_subtype_template_in_faction(chosenFaction, "3k_general_water", "3k_dlc04_template_historical_chen_deng_yuanlong_water");
		
        end
        if qleader:is_null_interface() then 
            if qleader:is_dead() then 
              ChangeRelations("3k_dlc_04_template_historical_chen_gui_water", "3k_dlc04_template_historical_chen_deng_yuanlong_water", "3k_main_relationship_trigger_set_event_positive_generic_large") 
            end
        end
            --Get cause could be spawned above
        local mChar=getModifyChar("3k_dlc04_template_historical_chen_deng_yuanlong_water")
        if not mChar:is_null_interface() then 
            CusLog("making chen deng heir")
            mChar:assign_to_post("faction_heir");
        end
         
        --GetVassal
        cm:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", chosenFaction, "data_defined_situation_vassalise_recipient_forced", false);
        ChangeRelations("3k_dlc_04_template_historical_chen_gui_water", "3k_main_template_historical_liu_bei_hero_earth", "3k_main_relationship_trigger_set_event_positive_generic_large") 
        
        CusLog("_give qleader_faction money")
        cm:modify_faction(chosenFaction):increase_treasury(7700)
        cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", chosenFaction , 14)  
        cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", chosenFaction , 25)    


        local qzerong=getQChar("3k_main_template_historical_ze_rong_hero_fire")
        if not qzerong:is_null_interface() then 
            if not qzerong:is_dead() then 
                local qFaction=qzerong:faction()
                local desired_region=cm:query_region("3k_main_guangling_capital")
                if not desired_region:is_null_interface() then 
                    if desired_region:owning_faction():name() == qFaction:name() then 
                        CusLog("Ze Rong has the region")
                        cm:modify_model():get_modify_region(desired_region):settlement_gifted_as_if_by_payload(cm:modify_faction(qleader_faction:name()))
                        AbandonLands(qFaction:name())
                        local desired_region2 = cm:query_region("3k_main_jianan_resource_1")
                        if not desired_region2:is_null_interface() then 
                            if not desired_region2:owning_faction():is_human() then 
                                cm:modify_model():get_modify_region(desired_region2):settlement_gifted_as_if_by_payload(cm:modify_faction(qFaction:name()))
                                TelportAllFactionArmies(qFaction:name(),"3k_main_jianan_resource_1")
                            end
                        end
                    end
                end
            end
        end
        CusLog("Tried Dealing with ze rong")
    end

    CusLog("Finished SetupTwoChensFaction")
end

function SetupZhang_XiusFaction()
	CusLog("Setting up ZhangXiuFaction")
    local caocao_faction = cm:query_faction("3k_main_faction_cao_cao")
    local qleader = getQChar("3k_main_template_historical_zhang_xiu_hero_fire")
    local qleader_faction = qleader:faction()
        if(qleader_faction:is_null_interface()==false) then 
        local chosenFaction=qleader_faction:name()

        --Trigger an incident where zhang xiu dislikes CaoCao?
        --or figure out how to change relationships via lua

        if caocao_faction:is_human() then 
            --fire dilemma for cao cao
            CaoCaoChoiceMade4Listener()
            cm:trigger_dilemma("3k_main_faction_cao_cao", "3k_lua_caocao_zhangxiu_dilemma", true) --ToDo
        else
            --Do nothing?
            --We need to force Zhang Xiu to War Cao Cao here since we wont have the key in event?
        end

        --give zhangxiu money
        cm:modify_faction(qleader_faction:name()):increase_treasury(12700)
        cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", qleader_faction:name() , 8)  
        
        --Does he get any officers? Jia Xu? etc?
        
        CusLog("try to make him hate cao cao ")
        ChangeRelations("3k_main_template_historical_zhang_xiu_hero_fire", "3k_main_template_historical_cao_cao_hero_earth", "3k_main_relationship_trigger_set_event_negative_insulted")
        CusLog("KOUYANG"..tostring(LUOYANGLUMBER))
        local region1= cm:query_region("3k_main_nanyang_resource_1")
        CusLog("1")
        local region2= cm:query_region("3k_main_runan_resource_1")
        CusLog("2")
        local region3= cm:query_region(LUOYANGLUMBER) 
        CusLog("3"..tostring(LUOYANGLUMBER))
        local region4= cm:query_region("3k_main_nanyang_capital") -- do this becuz AI is stuck here
        
        if not region1:is_null_interface() then 
            if not region1:owning_faction():is_human() then 
                cm:modify_model():get_modify_region(region1):settlement_gifted_as_if_by_payload(cm:modify_faction(chosenFaction))
            end
        end
        if not region2:is_null_interface() then 
            if not region2:owning_faction():is_human() and RNGHelper(3) then 
                cm:modify_model():get_modify_region(region2):settlement_gifted_as_if_by_payload(cm:modify_faction(chosenFaction))
            end
        end
        if not region3:is_null_interface() then 
            if region3:owning_faction():name() == "3k_main_faction_cao_cao" then 
                cm:modify_model():get_modify_region(region3):settlement_gifted_as_if_by_payload(cm:modify_faction(chosenFaction))
            end
        end
        if not region4:is_null_interface() then 
            if region4:owning_faction():is_human() then 
                cm:modify_model():get_modify_region(region4):settlement_gifted_as_if_by_payload(cm:modify_faction(chosenFaction))
            end
        end
        MoveCharToFaction("3k_main_template_historical_jia_xu_hero_water", chosenFaction);
        --Getting lazy 
        local mJiaXu=getModifyChar("3k_main_template_historical_jia_xu_hero_water")
        local qChar=getQChar("3k_main_template_historical_jia_xu_hero_water")

        if not qChar:is_null_interface() then 

            if qChar:faction():name() == chosenFaction then 
               CusLog("names match")
                mJiaXu:assign_to_post("3k_main_court_offices_prime_minister")
                CusLog("tried making mJiaXu advisor")
                mJiaXu:add_loyalty_effect("lua_loyalty");
            end
        end
       -- TellMeAboutFaction(chosenFaction)
        --try to ally LiuBiao
        ChangeRelations("3k_main_template_historical_zhang_xiu_hero_fire", "3k_main_template_historical_liu_biao_hero_earth", "3k_main_relationship_trigger_set_event_positive_good_omen")
    
        --WHHYY DONT THESE WORK?
        CusLog("Trying to apply auto deals for liu biao and "..chosenFaction)
        ForceADeal(chosenFaction, "3k_main_faction_liu_biao", "data_defined_situation_non_aggression_pact")
        ForceADeal(chosenFaction, "3k_main_faction_liu_biao", "data_defined_situation_military_access")
        ForceADeal(chosenFaction, "3k_main_faction_liu_biao", "data_defined_situation_trade")
       --[[ cm:apply_automatic_deal_between_factions("3k_main_faction_liu_biao", chosenFaction, "data_defined_situation_non_aggression_pact", false);
        cm:apply_automatic_deal_between_factions(chosenFaction, "3k_main_faction_liu_biao", "data_defined_situation_non_aggression_pact", false);
        cm:apply_automatic_deal_between_factions("3k_main_faction_liu_biao", chosenFaction, "data_defined_situation_military_access", false);
        cm:apply_automatic_deal_between_factions(chosenFaction, "3k_main_faction_liu_biao", "data_defined_situation_military_access", false);
        --Try Trade
        CusLog("Try trade")
        cm:apply_automatic_deal_between_factions("3k_main_faction_liu_biao", chosenFaction, "data_defined_situation_trade", false);
        cm:apply_automatic_deal_between_factions(chosenFaction, "3k_main_faction_liu_biao", "data_defined_situation_trade", false);
        --]]
        --	cm:apply_automatic_deal_between_factions(self.yt_leader_faction_key, "3k_main_faction_yellow_turban_rebels", "data_defined_situation_join_alliance_proposer", false);
        -- cm:apply_automatic_deal_between_factions(coalition_leader_key, faction_key, "data_defined_situation_create_coalition_yuan_shao");
		
		cm:force_declare_war(chosenFaction, "3k_main_faction_cao_cao", false);
		
		local qFaction = getQFaction("3k_main_faction_liu_biao")
		local coalitionKey= "data_defined_situation_???"
		--try to join
		if qFaction~=nil then 
			if qFaction:has_specified_diplomatic_deal_with_anybody(coalitionKey) then 
				for i=0, qFaction:number_of_factions_we_have_specified_diplomatic_deal_with(coalitionKey) -1  do 
					local faction= qFaction:factions_we_have_specified_diplomatic_deal_with(coalitionKey):item_at(i);
					CusLog("trying to join "..tostring(faction:name()))
					cm:apply_automatic_deal_between_factions(faction:name(), chosenFaction, "data_defined_situation_join_alliance_proposer", false); -- see if theres a coalition one?
				end
			else 
				CusLog("try to create a new coalition")
				cm:apply_automatic_deal_between_factions("3k_main_faction_liu_biao", chosenFaction, "data_defined_situation_create_coalition"); --check 
			end
		end	
    
    end

   
	CusLog("Finished ZhangXiuFaction")
end

function SetupChengYusFaction()
    CusLog("__Running SetupChengYusFaction")
    local qleader = cm:query_model():character_for_template("3k_main_template_historical_cheng_yu_hero_water")
    local qleader_faction = qleader:faction()


    if(qleader_faction:is_null_interface()==false) then 
        --declare war on yuan shu
        CusLog("..qleader_faction=  "..qleader_faction:name())
        cm:apply_automatic_deal_between_factions(qleader_faction:name(), "3k_main_faction_yuan_shu", "data_defined_situation_recipient_declares_war_against_target", true);
        cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shu", qleader_faction:name(), "data_defined_situation_war_proposer_to_recipient", true);
        CusLog("qleader_faction War")
        cm:apply_automatic_deal_between_factions(qleader_faction:name(), "3k_main_faction_cao_cao", "data_defined_situation_military_access", true);
        cm:apply_automatic_deal_between_factions(qleader_faction:name(), "3k_main_faction_liu_biao", "data_defined_situation_military_access", true);
        CusLog("qleader_faction does military access ")
    end

    CusLog("_give qleader_faction money")
    cm:modify_faction(qleader_faction:name()):increase_treasury(3700)
    cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", qleader_faction:name() , 4)    

    --If Yuan shu has too many lands, seize more of them

    --Fire an Dilemma for Yuan Shu (player)
    local qyuanshu_faction = cm:query_faction("3k_main_faction_yuan_shu")
    if(qyuanshu_faction:is_human()) then 
        CusLog("..Fire dilemma for player yuanshu")
        YuanShu2ChoiceMadeListener()
        cm:trigger_dilemma(qyuanshu_faction, "3k_lua_yuanshu_loses_nanyang",true)
    else
        --Move Ai YuanShu to Shouchun
        CusLog("..moving Ai YuanShu to yangzhou")
        MoveToShouchun(4)
    end
  
	CusLog("..making chengyu a vassal of cao  "..tostring(qleader:faction():name()))
    --Make ChengYu a vassal of CaoCao
    
    ChangeRelations("3k_main_template_historical_cheng_yu_hero_water", "3k_main_template_historical_cao_cao_hero_earth", "3k_main_relationship_trigger_set_event_positive_generic_large") 
	cm:apply_automatic_deal_between_factions("3k_main_faction_cao_cao", qleader:faction():name(), "data_defined_situation_vassalise_recipient_forced", false);
    
    local caocao_faction=cm:query_faction("3k_main_faction_cao_cao")
    if not cm:query_faction("3k_main_faction_nanyang"):has_specified_diplomatic_deal_with("treaty_components_vassalage",caocao_faction) then
       CusLog("Still no vassalge, try again")
        cm:apply_automatic_deal_between_factions("3k_main_faction_cao_cao", "3k_main_faction_nanyang", "data_defined_situation_vassalise_recipient_forced", false);
     end
     
     if not cm:query_faction("3k_main_faction_yuan_shu"):has_specified_diplomatic_deal_with("treaty_components_vassalage",qleader_faction) then
        CusLog("..wow force war again") 
        cm:apply_automatic_deal_between_factions(qleader_faction:name(), "3k_main_faction_yuan_shu", "data_defined_situation_recipient_declares_war_against_target", true);
    end
    CusLog("Finished SetupChengYusFaction")
end
function SetupZhouXinsFaction()
    CusLog("__Running Zhou Xin Faction set up")
    local qzhouxin = cm:query_model():character_for_template("3k_main_template_historical_zhou_xin_hero_fire")
    local qzhouxin_faction = qzhouxin:faction()


    if(qzhouxin_faction:is_null_interface()==false) then 
        --declare war on yuan shu
        CusLog("..zhouxinFactionname=  "..qzhouxin_faction:name())
        cm:apply_automatic_deal_between_factions(qzhouxin_faction:name(), "3k_main_faction_yuan_shu", "data_defined_situation_recipient_declares_war_against_target", true);
        cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shu", qzhouxin_faction:name(), "data_defined_situation_war_proposer_to_recipient", true);
        CusLog("_ZhouXinDeclares War")
        cm:apply_automatic_deal_between_factions(qzhouxin_faction:name(), "3k_main_faction_yuan_shao", "data_defined_situation_military_access", true);
        cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shao", qzhouxin_faction:name(), "data_defined_situation_military_access", true);
		cm:apply_automatic_deal_between_factions("3k_main_faction_liu_biao", qzhouxin_faction:name(), "data_defined_situation_military_access", true);
		cm:apply_automatic_deal_between_factions(qzhouxin_faction:name(), "3k_main_faction_liu_biao", "data_defined_situation_military_access", true);
        CusLog("_ZhouXin does military access ")
    end

    CusLog("_give ZhouXin  money")
    cm:modify_faction(qzhouxin_faction:name()):increase_treasury(5800)
    cm:apply_effect_bundle("3k_main_payload_faction_regionless_movement", qzhouxin_faction:name() , 4)    
    cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", qzhouxin_faction:name() , 4)    

    --Fire an Incident for Yuan Shu (player)
    local qyuanshu_faction = cm:query_faction("3k_main_faction_yuan_shu")
    if(qyuanshu_faction:is_human()) then 
        cm:trigger_incident(qyuanshu_faction, "3k_lua_yuanshao_sends_zhouxin",true)
    end
  

    CusLog("done Setting Up ZhouXin")

end

function SetupYangFengsFaction() -- needs testing that he finishes this and flips the bool
    CusLog("_Running Yang feng faction Set up")

    -- Declare War on LiJue ? meh -  can do it in next event


    local faction = cm:query_faction("3k_main_faction_hedong_separatists")
    
    -- move Xu Huang if hes not in the player faction
    local xuhuang_character = cm:query_model():character_for_template("3k_main_template_historical_xu_huang_hero_metal")
    if not xuhuang_character:is_null_interface() then
        if(not xuhuang_character:is_dead()) then
            local mxuhuang_character = cm:modify_character(xuhuang_character)  
            mxuhuang_character:set_is_deployable(true)
            mxuhuang_character:move_to_faction_and_make_recruited(faction:name())
            mxuhuang_character:add_loyalty_effect("extraordinary_success");
            CusLog("Moved xuhuang_character")
            
            local found_pos, x, y = faction:get_valid_spawn_location_in_region("3k_main_hedong_capital", false);
            local unit_list="3k_main_unit_wood_ji_infantry_captain,3k_main_unit_metal_jian_swordguards,3k_main_unit_metal_sabre_infantry,3k_main_unit_metal_sabre_infantry"
    
            cm:create_force_with_existing_general(xuhuang_character:cqi(), "3k_main_faction_hedong_separatists", unit_list, "3k_main_hedong_capital", x, y,"3kxuhuang_01",nil, 100);
            CusLog("Spawned XuHuang")
        else
            CusLog("dead-xuhuang_character")
        end
    else
        CusLog("cant find xuhuang_character?")
    end


    -- increase treasury small
    CusLog("give yang feng  money")
    cm:modify_faction(faction:name()):increase_treasury(5200)

    -- flip a bool to trigger taking LouYang and Emperor
    cm:set_saved_value("move_emperor_louyang", true);

    cm:apply_automatic_deal_between_factions("3k_main_faction_hedong_separatists", "3k_main_faction_zhang_yang", "data_defined_situation_military_access", true);
    cm:apply_automatic_deal_between_factions("3k_main_faction_zhang_yang", "3k_main_faction_hedong_separatists", "data_defined_situation_military_access", true);
    
    CusLog("_Finished setting up Yang Feng")

end

function SetupLiJuesFaction()
   
   CusLog("_Running liJue faction Set up")
    local faction = cm:query_faction("3k_main_faction_changan")
    

	-- find and move guo Si
    local guosi_character = cm:query_model():character_for_template("3k_main_template_historical_guo_si_hero_fire")
    if not guosi_character:is_null_interface() then
        if(not guosi_character:is_dead()) then
            local mguosi_character = cm:modify_character(guosi_character)  
            mguosi_character:set_is_deployable(true)
            mguosi_character:move_to_faction_and_make_recruited(faction:name())
            mguosi_character:add_loyalty_effect("extraordinary_success");
            CusLog("Moved guosi_character")
        else
            CusLog("dead-guosi_character")
        end
    else
        CusLog("cant find guosi_character?")
    end
	
	
	--Figure out leader if spawned wrong 
	local qliujue= getQChar("3k_main_template_historical_li_jue_hero_fire")
	if not qliujue:is_faction_leader() then --If hes spawned from the dilemma 
		CusLog("..Caught LiJue wasnt faction leader,fixing") -- would crash
		if  qliujue:is_character_is_faction_recruitment_pool() or qliujue:is_dead() then 
            CusLog("@@!..Li Jue is dead? going to make mguosi_character leader")
            CusLog("qlijue=factionleader="..tostring(qliujue:is_faction_leader()))
            CusLog("qlijue=dead="..tostring(qliujue:is_dead()))
            if not guosi_character:is_character_is_faction_recruitment_pool() then 
                local mguosi_character=cm:modify_character(guosi_character)
                mguosi_character:assign_to_post("faction_leader");
            else
                CusLog("...mguosi_character Was In is_character_is_faction_recruitment_pool.. making him leader will crash the game")
            end
    
		else
			local mlijue=cm:modify_character(qliujue)
			mlijue:assign_to_post("faction_leader");
		end
	end
	
    --Niu Fu 3k_main_template_historical_niu_fu_hero_fire
    local niufu_character = cm:query_model():character_for_template("3k_main_template_historical_niu_fu_hero_fire")
    if not niufu_character:is_null_interface() then
        if(not niufu_character:is_dead()) then
            local mniufu_character = cm:modify_character(niufu_character)
            mniufu_character:set_is_deployable(true)
            mniufu_character:move_to_faction_and_make_recruited(faction:name())
            mniufu_character:add_loyalty_effect("extraordinary_success");
            CusLog("Moved niufu_character")
        else
            CusLog("dead-niufu_character")
        end
    else
        CusLog("cant find niufu_character?")
    end

     -- Jia Xu  
     local jiaxu_character = cm:query_model():character_for_template("3k_main_template_historical_jia_xu_hero_water")
     if not jiaxu_character:is_null_interface() then
         if(not jiaxu_character:is_dead()) then
             local mjiaxu_character = cm:modify_character(jiaxu_character) 
             mjiaxu_character:set_is_deployable(true)
             mjiaxu_character:move_to_faction_and_make_recruited(faction:name())
             mjiaxu_character:add_loyalty_effect("extraordinary_success");
             CusLog("Moved jiaxu_character")
         else
             CusLog("dead-jiaxu_character")
         end
     else
         CusLog("cant find jiaxu_character?")
     end


    --li ru (vanilla)
    local liru_character = cm:query_model():character_for_template("3k_main_template_historical_li_ru_hero_water")
    if not liru_character:is_null_interface() then
        if(not liru_character:is_dead()) then
            local mliru_character = cm:modify_character(liru_character) 
            mliru_character:set_is_deployable(true)
            mliru_character:move_to_faction_and_make_recruited(faction:name())
            mliru_character:add_loyalty_effect("extraordinary_success");
            CusLog("Moved liru_character")
        else
            CusLog("dead-liru_character")
        end
    else
        CusLog("cant find liru_character?")
    end

     --li ru (MTU)
     local liru_character = cm:query_model():character_for_template("3k_mtu_template_historical_li_ru_hero_water")
     if not liru_character:is_null_interface() then
         if(not liru_character:is_dead()) then
             local mliru_character = cm:modify_character(liru_character) 
             mliru_character:set_is_deployable(true)
             mliru_character:move_to_faction_and_make_recruited(faction:name())
             mliru_character:add_loyalty_effect("extraordinary_success");
             CusLog("Moved liruMTU_character")
         else
             CusLog("dead-liruMTU_character")
         end
     else
         CusLog("cant find liruMTU_character?")
     end
    

    -- dong min (vanilla)
    local dongmin_character = cm:query_model():character_for_template("3k_main_template_historical_dong_min_hero_earth")
    if not dongmin_character:is_null_interface() then
        if(not dongmin_character:is_dead()) then
            local mdongmin_character = cm:modify_character(dongmin_character) 
            local rolled_value = cm:random_number( 0, 5 );
            CusLog("--Trying to Kill Dong ming, rolled a:"..rolled_value)
                 if rolled_value >1 then 
                   cm:modify_character(dongmin_character):kill_character(false)
                   CusLog("Killed DongMin")
                 else
                   mdongmin_character:set_is_deployable(true)
                   mdongmin_character:move_to_faction_and_make_recruited(faction:name())
                   mdongmin_character:add_loyalty_effect("extraordinary_success");
                CusLog("Moved dongmin_character")
                 end
        else
            CusLog("dead-dongmin_character")
        end
    else
        CusLog("cant find dongmin_character?")
    end

     -- dong min (mtu))
     local dongmin_character = cm:query_model():character_for_template("3k_mtu_template_historical_dong_min_hero_earth")
     if not dongmin_character:is_null_interface() then
         if(not dongmin_character:is_dead()) then
             local mdongmin_character = cm:modify_character(dongmin_character) 
             local rolled_value = cm:random_number( 0, 5 );
             CusLog("--Trying to Kill Dong ming (MTU), rolled a:"..rolled_value)
                  if rolled_value >3 then 
                    cm:modify_character(dongmin_character):kill_character(false)
                    CusLog("Killed DongMin")
                  else
                    mdongmin_character:set_is_deployable(true)
                    mdongmin_character:move_to_faction_and_make_recruited(faction:name())
                    mdongmin_character:add_loyalty_effect("extraordinary_success");
                 CusLog("Moved dongmin_character MTU")
                  end
         else
             CusLog("dead-dongmin_character")
         end
     else
         CusLog("cant find dongmin_character?")
     end


    -- dong peishan  (vanilla)
    local ladydong_character = cm:query_model():character_for_template("3k_main_template_historical_lady_dong_peishan_hero_earth")
    if not ladydong_character:is_null_interface() then
        if(not ladydong_character:is_dead()) then
            local mladydong_character = cm:modify_character(ladydong_character) 
            local rolled_value = cm:random_number( 0, 5 );
            CusLog("--Trying to kill lady dong, rolled a:"..rolled_value)
            if rolled_value >1 then 
                cm:modify_character(ladydong_character):kill_character(false)
                CusLog("Killed Lady Dong")
              else
                mladydong_character:set_is_deployable(true)
                mladydong_character:move_to_faction_and_make_recruited(faction:name())
                mladydong_character:add_loyalty_effect("extraordinary_success");
                CusLog("Moved ladydong_character")
              end
        else
            CusLog("dead-ladydong_character")
        end
    else
        CusLog("cant find ladydong_character?")
    end


    -- dong peishan  (MTU)
    local ladydong_character = cm:query_model():character_for_template("3k_mtu_template_historical_lady_dong_peishan_hero_earth")
    if not ladydong_character:is_null_interface() then
        if(not ladydong_character:is_dead()) then
            local mladydong_character = cm:modify_character(ladydong_character)  
            local rolled_value = cm:random_number( 0, 5 );
            CusLog("--Trying to kill lady dong (MTU), rolled a:"..rolled_value)
            if rolled_value >3 then 
                cm:modify_character(ladydong_character):kill_character(false)
                CusLog("Killed lady dong MTU")
              else
                mladydong_character:set_is_deployable(true)
                mladydong_character:move_to_faction_and_make_recruited(faction:name())
                mladydong_character:add_loyalty_effect("extraordinary_success");
                CusLog("Moved ladydong_character")
              end
        else
            CusLog("dead-ladydongMTU_character")
        end
    else
        CusLog("cant find ladydongMTU_character?")
    end


    -- give them more land
     --set up anding1
     local anding1 =cm:query_region("3k_main_anding_resource_2")
     if anding1:owning_faction():name() == "3k_main_faction_dong_zhuo" then
        CusLog("--Want to Transfer Region1--" )
        cm:modify_model():get_modify_region(anding1):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_changan"))
        CusLog("--transferred Region1--")
    end
    --set up anding2
    local anding2 =cm:query_region("3k_main_anding_resource_1")
    if anding2:owning_faction():name() == "3k_main_faction_dong_zhuo" then
       CusLog("--Want to Transfer Region2--" )
       cm:modify_model():get_modify_region(anding2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_changan"))
       CusLog("--transferred Region2--")
   end
    --set up anding3
    local anding3 =cm:query_region("3k_main_anding_capital")
    if anding3:owning_faction():name() == "3k_main_faction_dong_zhuo" then
        CusLog("--Want to Transfer Region3--" )
        cm:modify_model():get_modify_region(anding3):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_changan"))
        CusLog("--transferred Region3--")
   end
   --set up andingTown
   local anding4 =cm:query_region("3k_main_anding_capital")
   if anding4:owning_faction():name() == "3k_main_faction_dong_zhuo" then
       CusLog("--Want to Transfer Region4--" )
       cm:modify_model():get_modify_region(anding4):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_changan"))
       CusLog("--transferred Region4--")
  end

     --abandon the north 1
     local shofu1 =cm:query_region("3k_main_shoufang_resource_1")
     if shofu1:owning_faction():name() == "3k_main_faction_dong_zhuo" then
        cm:modify_region("3k_main_anding_resource_3"):raze_and_abandon_settlement_without_attacking();
        CusLog("--burned Region4--")
    end
     --abandon the north 2
     local shofu2 =cm:query_region("3k_main_shoufang_resource_2")
     if shofu2:owning_faction():name() == "3k_main_faction_dong_zhuo" then
        cm:modify_region("3k_main_anding_resource_3"):raze_and_abandon_settlement_without_attacking();
        CusLog("--burned Region5--")
    end
     --abandon the north 3
     local shofu3 =cm:query_region("3k_main_shoufang_resource_3")
     if shofu3:owning_faction():name() == "3k_main_faction_dong_zhuo" then
        cm:modify_region("3k_main_anding_resource_3"):raze_and_abandon_settlement_without_attacking();
        CusLog("--burned Region5--")
    end


    -- Make Loyalist stick with Lu Bu
     MakeLuBusCoreHappy();


    --TMP ??
    --local kill_character = cm:query_model():character_for_template("3k_main_template_historical_dong_zhuo_hero_fire")
    --if not kill_character:is_null_interface() then
     --     cm:modify_character(kill_character):kill_character(false)
     --     CusLog("Killed Dongzhuo")
	--  else
    --    MogLog("Dong Zhuo is null")
   -- end

    CusLog("Check wang yun1")
   --make sure wang yun is spawned
   local qwangyun1 = cm:query_model():character_for_template("3k_main_template_historical_wang_yun_hero_earth")
   if not qwangyun1:is_null_interface() then
    CusLog("wang yung exists")
    if qwangyun1:is_dead() then
        CusLog("Wang Yun is dead, wont spawn, cuz it gets weird")
       --local anything= cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_dong_zhuo", "3k_general_earth", "3k_main_template_historical_wang_yun_hero_earth");
       CusLog("does anything come back w wang yung?.")
        CusLog("                                   ="..tostring(anything)) --So this cant happen..nothing comes back
    end
   else
    CusLog("cant find Wang Yun going to spawn2:")
    cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_dong_zhuo", "3k_general_earth", "3k_main_template_historical_wang_yun_hero_earth");
   end

   CusLog("make wang yun leader")
   -- make wang yun leader
   local qwangyun = cm:query_model():character_for_template("3k_main_template_historical_wang_yun_hero_earth")
   if not qwangyun:is_null_interface() then
    -- check is hes alive
       if not qwangyun:is_dead() then
            local mwangyun = cm:modify_character(qwangyun)  
            local wangs_faction = qwangyun:faction():name()
             -- check faction
             CusLog("..wang Yuns faction is: " .. tostring(wangs_faction) )
             if wangs_faction ~= "3k_main_faction_dong_zhuo" then
               -- move to faction
                mwangyun:set_is_deployable(true)
                mwangyun:move_to_faction_and_make_recruited("3k_main_faction_dong_zhuo")
                CusLog("Moved wang Yun")
              end
			 if not qwangyun:is_character_is_faction_recruitment_pool() then 
				mwangyun:assign_to_post("faction_leader");
				CusLog("Assigned FactionLeader - wang Yun")
			else
				CusLog("...mguosi_character Was In is_character_is_faction_recruitment_pool.. making him leader will crash the game")
			end
       else --FAIL SAFE..
            CusLog("wangyungs dead, making lubu leader")-- Make luBu leader
            local mlubu= getModifyChar("3k_main_template_historical_lu_bu_hero_fire")
            if not mlubu:is_null_interface() then 
                mlubu:assign_to_post("faction_leader"); -- could crash if hes in recruitment pool, could get odd if hes not in dz faction if i undo the vanilla CPP 
            end
        end
    else
        CusLog("@@!!..Wang yuns dead?? OOPS @Warning")
   end

     --set income
     CusLog("..give li jue money")
     cm:modify_faction(faction:name()):increase_treasury(19500) -- Was 19000 dropped and added buff
     cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", faction:name() , 4) -- they really need a supply buff   

     --!!!!!!!
     --TEST TODO--replace with move lu bus faction to him
     -- This needs to change based on whos the player and he must go to yuan shao now (ai)
     --cm:set_saved_value("lu_bu_to_yingchuan", true);  -- move Lu Bu to Ying Chuan
    CusLog("Test the factions for follow up conditions ")
	local qyuanshu_faction = cm:query_faction("3k_main_faction_yuan_shu")
	local qyuanshao_faction = cm:query_faction("3k_main_faction_yuan_shao")
    local qdongz_faction =  cm:query_faction("3k_main_faction_dong_zhuo")
    if(qdongz_faction:is_human() ==false ) then 
       CusLog("..Dongzhuo is AI, check some other players to see where lu bu goes")
        if(qyuanshu_faction:is_human()) then 
		    CusLog("YuanShu is human, sending LuBu there")
		    --Set Listener and conditions for Dilemma
		    cm:set_saved_value("lubu_flees_to_yuanshu",cm:query_model():turn_number()+1)
		    AILuBuFleesToYuanShuListener() -- hope these arent local
	    elseif(qyuanshao_faction:is_human()) then 
		    CusLog("YuanShao is human, sending LuBu there")
		    --Set Listener and conditions for Dilemma
		    cm:set_saved_value("lubu_flees_to_yuanshao",cm:query_model():turn_number()+2)--Can the faction survive 1 extra turn?
		    AILuBuFleesToYuanShaoListener() -- hope these arent local
	    else
            CusLog("..guess lu bu goes to ying chuan?..do we want this?")
            --register him to emergent at PuYang after wandering around doing whatever
		    register_lu_bu_emergent_faction_2()
		    cm:set_saved_value("lu_bu_to_yingchuan", true)
			cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua", "3k_main_faction_dong_zhuo" , 16)
        end
        --Debuff Lubu/wangyun
        cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua_lite", "3k_main_faction_dong_zhuo" , 2)
    end
   


    --Declare war on any potential YTs that steal cities (doesnt seem to work)
    cm:apply_automatic_deal_between_factions("3k_main_faction_yellow_turban_rebels", "3k_main_faction_changan", "data_defined_situation_proposer_declares_war_against_target", true);
    cm:apply_automatic_deal_between_factions("3k_main_faction_changan", "3k_main_faction_yellow_turban_rebels", "data_defined_situation_war", true);

    local found_pos, x, y = faction:get_valid_spawn_location_in_region("3k_main_anding_capital", false);
    local unit_list="3k_main_unit_wood_ji_infantry_captain,3k_main_unit_fire_xiliang_cavalry,3k_main_unit_fire_xiliang_cavalry,3k_main_unit_fire_heavy_xiliang_cavalry, 3k_main_unit_metal_sabre_infantry"

    cm:create_force_with_existing_general(qliujue:cqi(), faction:name(), unit_list, "3k_main_anding_capital", x, y,"3k_lijuw",nil, 100);
    cm:create_force_with_existing_general(guosi_character:cqi(), faction:name(), unit_list, "3k_main_anding_capital", x+2, y-2,"3k_gousi",nil, 100);
   
    cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction",faction:name() , 30)    
   CusLog("Done setting Up Li Jues Faction")
end


--Create a new lisener that fires after Fall of the empire to see if LuBu made his new faction
-- If true set up his faction()



function SetupLuBusFaction(FactionKey)
    CusLog("_SetupLuBusFaction")
    local lubu_faction = cm:query_faction(FactionKey)
    -- find and move zhang liao
    local zhangliao_character = cm:query_model():character_for_template("3k_main_template_historical_zhang_liao_hero_metal")
    if not zhangliao_character:is_null_interface() then
        if(not zhangliao_character:is_dead()) then
            local mzhangliao_character = cm:modify_character(zhangliao_character)  
            mzhangliao_character:set_is_deployable(true)
            mzhangliao_character:move_to_faction_and_make_recruited(lubu_faction:name())
            -- mzhangliao_character:move_to_faction(lubu_faction:name())
            mzhangliao_character:add_loyalty_effect("extraordinary_success");
            CusLog("Moved Zhangliao")
        else
            CusLog("dead-Zhangliao")
        end
    else
        CusLog("cant find zhangLiao")
    end

    -- find and move diao chan
    local diaochan_character = cm:query_model():character_for_template("3k_main_template_historical_lady_diao_chan_hero_water")
    if not diaochan_character:is_null_interface() then
        if(not diaochan_character:is_dead()) then
            local mdiaochan_character = cm:modify_character(diaochan_character)  
            mdiaochan_character:set_is_deployable(true)
            mdiaochan_character:move_to_faction_and_make_recruited(lubu_faction:name())
            mdiaochan_character:add_loyalty_effect("extraordinary_success");
            CusLog("moved DiaoChan")
        else
            CusLog("dead-DiaoChan")
        end
    else
        CusLog("cant find DiaoChan going to spawn:")
        cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_lu_bu", "3k_general_water", "3k_main_template_historical_lady_diao_chan_hero_water");
    end

     -- find and move gao shun
    local gaoshun_character = cm:query_model():character_for_template("3k_main_template_historical_gao_shun_hero_fire")
    if not gaoshun_character:is_null_interface() then
        if(not gaoshun_character:is_dead()) then
             local mgaoshun_character = cm:modify_character(gaoshun_character)  
            mgaoshun_character:set_is_deployable(true)
            mgaoshun_character:move_to_faction_and_make_recruited(lubu_faction:name())
            mgaoshun_character:add_loyalty_effect("extraordinary_success");
         CusLog("moved GaoShun")
     else
         CusLog("dead-Gaoshun")
    end
    else
     CusLog("cant find GaoShun going to spawn:")
     cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_lu_bu", "3k_general_fire", "3k_main_template_historical_gao_shun_hero_fire");
 end

 if FactionKey == "3k_main_faction_lu_bu" then -- only do rest for puyang 
	  -- find and move cheng gong
	  local chengong = cm:query_model():character_for_template("3k_main_template_historical_chen_gong_hero_water")
	  if not chengong:is_null_interface() then
		  if(not chengong:is_dead()) then
			  local mchengong = cm:modify_character(chengong)  
			  mchengong:set_is_deployable(true)
			  mchengong:move_to_faction_and_make_recruited(lubu_faction:name())
			  mchengong:add_loyalty_effect("extraordinary_success");
			  CusLog("moved chengong")
		  else
			  CusLog("dead-chengong")
		  end
	  else
		  CusLog("cant find chengong going to spawn")
		  --Should Spawn cheng gong  
		 cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_lu_bu", "3k_general_water", "3k_main_template_historical_chen_gong_hero_water");
	  end



	--first try to confderate 

  
	  local confederatedZhangMiao=false;
	  local qzhangMiao= getQChar("3k_main_template_historical_zhang_miao_hero_water")
	  --if Zhang Miao owns yingchuan (confederate him)  --Trigger a follow up incident that improves relations 
	  if( not qzhangMiao:is_null_interface() ) then 
		local yingchuan_region =cm:query_region(CHENLIU) -- GLOBAL
		if yingchuan_region:is_null_interface() then 
			CusLog("YingChuan is Null, will crash, check globals")
		end
		  if( "3k_main_faction_liu_dai" == qzhangMiao:faction():name()) then 
			  CusLog("..LuBu confederating zhang miao")
			   cm:modify_faction(lubu_faction):apply_automatic_diplomatic_deal("data_defined_situation_peace", qzhangMiao:faction(), "");
			   cm:force_confederation(lubu_faction:name(),"3k_main_faction_liu_dai")
			   confederatedZhangMiao=true;
			   --IF zhang miao left, put his ass back
			   qzhangMiao = getQChar("3k_main_template_historical_zhang_miao_hero_water")
			   if(qzhangMiao:faction():name() ~= lubu_faction:name()) then 
				  MoveCharToFactionHard("3k_main_template_historical_zhang_miao_hero_water", lubu_faction:name())
			  end
		  else 	-- else move him into lu bus faction regardless
			  CusLog("..@ uh-oh zhang miao faction name= "..qzhangMiao:faction():name())
			  CusLog(" YingChuangs owning faction is:"..tostring(yingchuan_region:owning_faction():name()))
			  CusLog("..@ zhang miao doesnt own chenliu, but well move him in to lubus faction anyway")
			  MoveCharToFaction("3k_main_template_historical_zhang_miao_hero_water", lubu_faction:name())
		  end
	  end
  
		  -- if we did not confederate Zhang Miao - take yingchuan farm 
	  if(confederatedZhangMiao==false) then 
		  CusLog("didnt confederate sketchy")
	  end 
		  
	  local mqzhangMiao= getModifyChar("3k_main_template_historical_zhang_miao_hero_water")
	  if not mqzhangMiao:is_null_interface() then 
		CusLog("add loy mqzhangMiao")  
		  mqzhangMiao:add_loyalty_effect("data_lu_bu_inspire")
		  mqzhangMiao:add_loyalty_effect("extraordinary_success");
		  mqzhangMiao:add_loyalty_effect("recently_promoted");
	  end
	  CusLog("Check XuChang")
		local XuChang_region =cm:query_region(XUCHANG) -- GLOBAL
		if not XuChang_region:is_null_interface() then 
			if XuChang_region:owning_faction():name() == "3k_main_faction_cao_cao" then 
				CusLog(" give lubu xuchang")
				cm:modify_model():get_modify_region(XuChang_region):settlement_gifted_as_if_by_payload(cm:modify_faction(lubu_faction:name()))
			else 
				CusLog("xuChang owner="..tostring(XuChang_region:owning_faction():name()))
			end
		else 
			CusLog("XuChang_region check globals"..tostring(XUCHANG))
		end
		--ToDo Maybe Hulao gate if it stays
		CusLog("Check HouCheng")
		--find and move hou cheng
		local houcheng = cm:query_model():character_for_template("3k_dlc05_template_historical_hou_cheng_hero_wood")
		if not houcheng:is_null_interface() then
			if(not houcheng:is_dead()) then
				local mhoucheng = cm:modify_character(houcheng)  
				mhoucheng:set_is_deployable(true)
				mhoucheng:move_to_faction_and_make_recruited(lubu_faction:name())
				mhoucheng:add_loyalty_effect("extraordinary_success");
				CusLog("moved houcheng")
			else
				CusLog("dead-houcheng")
			end
		else
			CusLog("cant find houcheng going to spawn:")
			cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_lu_bu", "3k_general_wood", "3k_dlc05_template_historical_hou_cheng_hero_wood");
		end
		 CusLog("Check HaoMeng")
		-- find and move 3k_main_template_historical_hao_meng_hero_fire
		local haomeng = cm:query_model():character_for_template("3k_main_template_historical_hao_meng_hero_fire")
		if not haomeng:is_null_interface() then
			if(not haomeng:is_dead()) then
				local mhaomeng = cm:modify_character(haomeng)  
				mhaomeng:set_is_deployable(true)
				mhaomeng:move_to_faction_and_make_recruited(lubu_faction:name())
				mhaomeng:add_loyalty_effect("extraordinary_success");
				CusLog("moved haomeng")
			else
				CusLog("dead-haomeng")
			end
		else
			CusLog("cant find haomeng going to spawn:")
			cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_lu_bu", "3k_general_fire", "3k_main_template_historical_hao_meng_hero_fire");
		end


		--set income
		CusLog("give lu bu money")
		local q_faction = cm:query_faction("3k_main_faction_lu_bu")
		cm:modify_faction(q_faction:name()):increase_treasury(12000)
	
		-- might want to do a temp buff for character salary or replenishment?
		cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", q_faction:name() , 4)    


        --Declare war on Cao Cao via event
		
		local playersFactionsTable = cm:get_human_factions()
		local playerFaction = playersFactionsTable[1]
		local triggered=cm:trigger_incident(playerFaction,"3k_main_lu_bu_emerge", true ) --doesnt make peace anymore
		
		LuBuEmergesListener()

		cm:set_saved_value("peace_needed",triggered) --Xu_peace Script to continue the storyline handles the follow up dilemmas/incidents
		cm:set_saved_value("lu_bu_refugee", true); -- used in Xu_lubu refugee

		 --Make Zhang Yang like him?
		 ChangeRelations("3k_main_template_historical_lu_bu_hero_fire", "3k_main_template_historical_zhang_yang_hero_earth", "3k_main_relationship_trigger_set_event_positive_dilemma_very_large")
		 --Cao Cao hate 
		 ChangeRelations("3k_main_template_historical_lu_bu_hero_fire", "3k_main_template_historical_cao_cao_hero_earth", "3k_main_relationship_trigger_scripted_event_generic_negative_large")
		 ChangeRelations("3k_main_template_historical_lu_bu_hero_fire", "3k_main_template_historical_cao_cao_hero_earth", "3k_main_relationship_trigger_set_event_negative_dilemma_large")
		
		 local found_pos, x, y = lubu_faction:get_valid_spawn_location_in_region(CHENLIU, false);
		 --local unit_list="3k_main_unit_wood_ji_infantry_captain,3k_dlc05_unit_metal_bandit_warriors,3k_dlc05_unit_fire_bandit_raiders,3k_dlc05_unit_water_bandit_hunters, 3k_dlc05_unit_fire_bandit_raiders"
		local qlubu=getQChar("3k_main_template_historical_lu_bu_hero_fire")
		 cm:create_force_with_existing_general(qlubu:cqi(), lubu_faction:name(), "", CHENLIU, x, y,"3k_lubuE",nil, 90);

		 CusLog("Teleport Caocaos main army to global var CHENCITY")
		 --Should teleport AI CaoCao to Chen Farm ToDo
		 local qcaocao= getQChar("3k_main_template_historical_cao_cao_hero_earth")
		 if qcaocao:has_military_force() then 
			CusLog("..Teleporting Commander: "..tostring(qcaocao:generation_template_key()))
			local found_pos, x, y = qcaocao:faction():get_valid_spawn_location_in_region(CHENCITY, false); --Global
			local randomness1 = math.floor(cm:random_number(-4, 4 ));
			local randomness2 = math.floor(cm:random_number(-4, 4 ));
			cm:modify_model():get_modify_character(qcaocao):teleport_to(x+randomness1,y-randomness2)      
		 end
		 cm:set_saved_value("caocao_buffed_turnlimit", cm:query_model():turn_number() +8)-- Buff Cao cao for 8turns
		
		--Should set a turn timer, for if hes alive longer than that, then debuff him 
		-- cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua_lite", lubu_faction:name() , 2)

		 --Make it so he fights with his core famous officers
		 CleanOfficerList("3k_main_faction_cao_cao")
         CleanOfficerList(lubu_faction:name())
         
         --Spawn lulingqi
         CusLog("figuring out LuLingqi")
         if MTU then 
            local lulinqi=getQChar2("3k_mtu_template_historical_lady_lu_ji_hero_wood")
            if lulingqi~=nil then 
                MoveCharToFaction("3k_mtu_template_historical_lady_lu_ji_hero_wood", "3k_main_faction_lu_bu")
            else
                CusLog("Spawn MTU")  
                cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_lu_bu", "3k_general_wood", "3k_mtu_template_historical_lady_lu_ji_hero_wood");
            end
            local mchar = getModifyChar("3k_dlc05_template_historical_lu_lingqi_hero_metal")
		    mchar:assign_to_post("faction_heir")
         else 
            local lulinqi=getQChar2("3k_dlc05_template_historical_lu_lingqi_hero_metal")
            if lulingqi~=nil then 
                MoveCharToFaction("3k_dlc05_template_historical_lu_lingqi_hero_metal", "3k_main_faction_lu_bu")
            else
                CusLog("Spawn vanilla")  
                cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_lu_bu", "3k_general_metal", "3k_dlc05_template_historical_lu_lingqi_hero_metal");
             end
            local mchar = getModifyChar("3k_dlc05_template_historical_lu_lingqi_hero_metal")
		    mchar:assign_to_post("faction_heir")
         end
	end
    CusLog("---Finished Lu Bu Set up ---")
end

function MakeLuBusCoreHappy()
    CusLog("make lubus core happy");
    local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
    local zhangliao_character = cm:query_model():character_for_template("3k_main_template_historical_zhang_liao_hero_metal")
    if not zhangliao_character:is_null_interface() then
        if(not zhangliao_character:is_dead()) then
            if not zhangliao_character:faction():name() == qlubu:faction():name() then 
                MoveCharToFactionHard("3k_main_template_historical_zhang_liao_hero_metal",qlubu:faction():name() )
            end
            local mzhangliao_character = cm:modify_character(zhangliao_character)  
            mzhangliao_character:add_loyalty_effect("data_lu_bu_inspire");
            mzhangliao_character:add_loyalty_effect("defection_bonus");
            mzhangliao_character:add_loyalty_effect("lua_loyalty");
            CusLog("added loyalty Zhangliao")
        else
            CusLog("dead-Zhangliao")
        end
    else
        CusLog("cant find zhangLiao")
    end
  
     local diaochan_character = cm:query_model():character_for_template("3k_main_template_historical_lady_diao_chan_hero_water")
     if not diaochan_character:is_null_interface() then
         if(not diaochan_character:is_dead()) then
            if not diaochan_character:faction():name() == qlubu:faction():name() then 
                MoveCharToFactionHard("3k_main_template_historical_lady_diao_chan_hero_water",qlubu:faction():name() )
            end
             local mdiaochan_character = cm:modify_character(diaochan_character)  
             mdiaochan_character:add_loyalty_effect("data_lu_bu_inspire");
             mdiaochan_character:add_loyalty_effect("defection_bonus");
             mdiaochan_character:add_loyalty_effect("lua_loyalty");
             CusLog("added loyalty DiaoChan")
         else
             CusLog("dead-DiaoChan")
         end
    else
            CusLog("cant find DiaoChan")
     end
  
     local gaoshun_character = cm:query_model():character_for_template("3k_main_template_historical_gao_shun_hero_fire")
     if not gaoshun_character:is_null_interface() then
         if(not gaoshun_character:is_dead()) then
            if  gaoshun_character:faction():name() ~= qlubu:faction():name() then 
                MoveCharToFactionHard("3k_main_template_historical_gao_shun_hero_fire",qlubu:faction():name() )
            end
              local mgaoshun_character = cm:modify_character(gaoshun_character)  
             mgaoshun_character:add_loyalty_effect("data_lu_bu_inspire");
             mgaoshun_character:add_loyalty_effect("defection_bonus");
             mgaoshun_character:add_loyalty_effect("lua_loyalty");
             CusLog("added loyalty GaoShun")
        else
          CusLog("dead-Gaoshun")
        end
    end

   -- local lubu_character = cm:query_model():character_for_template("3k_main_template_historical_lu_bu_hero_fire")
    if not qlubu:is_null_interface() then
        if not qlubu:is_dead() then
            if (not qlubu:is_faction_leader()) then 
                local mlubu = cm:modify_character(qlubu)  
                mlubu:add_loyalty_effect("data_lu_bu_inspire");
                mlubu:add_loyalty_effect("defection_bonus");
                mlubu:add_loyalty_effect("lua_loyalty");
                CusLog("added loyalty LuBu")
            end
        else
            CusLog("dead-LuBu")
        end
    else
        CusLog("cant find LuBu")
    end
    CusLog("Finished make lubus core happy");
end
--random #
--local exp_to_give = cm:modify_model():random_number(88000, 206000) -- Level 7 - 9



local function EmergentVariables()
		CusLog("Debug: EmergentVariables")
		
		CusLog("  EmergentFactions fall_of_empire= "..tostring(cm:get_saved_value("fall_of_empire")))
		CusLog("  EmergentFactions li_jue_emergent_registered= "..tostring(cm:get_saved_value("li_jue_emergent_registered")))
		CusLog("  EmergentFactions lijue_was_spawned= "..tostring(cm:get_saved_value("lijue_was_spawned")))
		
		CusLog("  EmergentFactions lu_bu_to_yingchuan= "..tostring(cm:get_saved_value("lu_bu_to_yingchuan")))
		CusLog("  EmergentFactions lu_bu_emergent_registered= "..tostring(cm:get_saved_value("lu_bu_emergent_registered")))
		CusLog("  EmergentFactions ai_lubu_emerged= "..tostring(cm:get_saved_value("ai_lubu_emerged")))
		
		
		CusLog("  EmergentFactions SpawnYangFeng= "..tostring(cm:get_saved_value("SpawnYangFeng")))
		CusLog("  EmergentFactions yan_feng_emergent_registered= "..tostring(cm:get_saved_value("yan_feng_emergent_registered")))
		CusLog("  EmergentFactions yangFeng_was_spawned= "..tostring(cm:get_saved_value("yangFeng_was_spawned")))

		CusLog("  EmergentFactions Spawnzhang_xiu= "..tostring(cm:get_saved_value("Spawnzhang_xiu")))
		CusLog("  EmergentFactions zhang_xiu_emergent_registered= "..tostring(cm:get_saved_value("zhang_xiu_emergent_registered")))
		CusLog("  EmergentFactions Spawnzhang_xiu= "..tostring(cm:get_saved_value("Spawnzhang_xiu")))

		CusLog("  EmergentFactions SpawnZhouXin= "..tostring(cm:get_saved_value("SpawnZhouXin")))
		CusLog("  EmergentFactions zhou_xin_emergent_registered= "..tostring(cm:get_saved_value("zhou_xin_emergent_registered")))
		CusLog("  EmergentFactions ZhouXinSpawned= "..tostring(cm:get_saved_value("ZhouXinSpawned")))
		
		
		CusLog("  EmergentFactions SpawnChengYu= "..tostring(cm:get_saved_value("SpawnChengYu")))
		CusLog("  EmergentFactions cheng_yu_emergent_registered= "..tostring(cm:get_saved_value("cheng_yu_emergent_registered")))
		CusLog("  EmergentFactions ChengYuSpawned= "..tostring(cm:get_saved_value("ChengYuSpawned")))
		
        CusLog("  EmergentFactions TwoChensSpawned= "..tostring(cm:get_saved_value("TwoChensSpawned")))
		CusLog("  EmergentFactions twochens_emergent_registered= "..tostring(cm:get_saved_value("twochens_emergent_registered")))
		CusLog("  EmergentFactions SpawnTwoChens= "..tostring(cm:get_saved_value("SpawnTwoChens")))


        CusLog("  EmergentFactions zangbaSpawned= "..tostring(cm:get_saved_value("zangbaSpawned")))
		CusLog("  EmergentFactions zangba_emergent_registered= "..tostring(cm:get_saved_value("zangba_emergent_registered")))
		CusLog("  EmergentFactions Spawnzangba= "..tostring(cm:get_saved_value("Spawnzangba")))


        CusLog("  EmergentFactions YuanTanSpawned= "..tostring(cm:get_saved_value("YuanTanSpawned")))
		CusLog("  EmergentFactions YuanTan_emergent_registered= "..tostring(cm:get_saved_value("YuanTan_emergent_registered")))
		CusLog("  EmergentFactions SpawnYuanTan= "..tostring(cm:get_saved_value("SpawnYuanTan")))
        
        CusLog("  EmergentFactions YuanTanSpawned= "..tostring(cm:get_saved_value("YuanTanSpawned")))
		CusLog("  EmergentFactions YuanTan_emergent_registered= "..tostring(cm:get_saved_value("YuanTan_emergent_registered")))
		CusLog("  EmergentFactions SpawnYuanTan= "..tostring(cm:get_saved_value("SpawnYuanTan")))
        
        CusLog("  EmergentFactions YuanShangSpawned= "..tostring(cm:get_saved_value("YuanShangSpawned")))
		CusLog("  EmergentFactions YuanShang_emergent_registered= "..tostring(cm:get_saved_value("YuanShang_emergent_registered")))
		CusLog("  EmergentFactions SpawnYuanShang= "..tostring(cm:get_saved_value("SpawnYuanShang")))
        
        CusLog("  EmergentFactions CheZhouSpawned= "..tostring(cm:get_saved_value("CheZhouSpawned")))
		CusLog("  EmergentFactions CheZhou_emergent_registered= "..tostring(cm:get_saved_value("CheZhou_emergent_registered")))
		CusLog("  EmergentFactions SpawnCheZhou= "..tostring(cm:get_saved_value("SpawnCheZhou")))
		
        
        CusLog("  EmergentFactions LuLingqiSpawned= "..tostring(cm:get_saved_value("LuLingqiSpawned")))
		CusLog("  EmergentFactions LuLingqi_emergent_registered= "..tostring(cm:get_saved_value("LuLingqi_emergent_registered")))
		CusLog("  EmergentFactions SpawnLuLingqi= "..tostring(cm:get_saved_value("SpawnLuLingqi")))
		
        
		CusLog("Passed: EmergentVariables")
end


-- this didnt work , had to add to require.lua for main campaign
cm:add_pre_first_tick_callback(function() 
    require("3k_campaign_cdir_global_events"); -- Global events manager - allows events to be fired for players/AI.
    require("3k_campaign_invasions"); -- Script which wraps the lib_invasion manager. Allows spawnignof invasions and armies.
    require("3k_campaign_emergent_factions"); -- Script which controls re-emergence of factions. Retire after timelines?

 end)



cm:add_first_tick_callback(
    function(context)
		IniDebugger()
		EmergentVariables()
            if cm:get_saved_value("fall_of_empire") and context:query_model():date_in_range(191,194) then 
                -- check if player is dong zhuo
				local q_dz_faction = cm:query_faction("3k_main_faction_dong_zhuo")
				if not q_dz_faction:is_human() then -- this isnt that bad becuz the dilemma if player insta spawns, doesnt use emergent
					-- AI is dong zhuo 
                    if cm:get_saved_value("li_jue_emergent_registered")~= true or cm:get_saved_value("lijue_was_spawned")~= true then
						CusLog("!!..re-register LiJue emergent ")
						register_li_jue_emergent_faction_2_emergent_faction_2() -- unknown if these persist over saves
					else
						CusLog("???.. fall_of_empire, but li_jue_emergent_registered="..tostring(cm:get_saved_value("li_jue_emergent_registered")))
					end
                end
            end
			if context:query_model():date_in_range(192,195) then
                if cm:get_saved_value("lu_bu_to_yingchuan") then
                    if cm:get_saved_value("ai_lubu_emerged")~= true  then 
                        CusLog("!!..re-register LuBu emergent ")
                        register_lu_bu_emergent_faction_2() -- unknown if these persist over saves
                    else
                        CusLog("???.. lu_bu_to_yingchuan, but lu_bu_emergent_registered="..tostring(cm:get_saved_value("lu_bu_emergent_registered")))
                    end
                end
            end
            if context:query_model():date_in_range(193,197) and cm:get_saved_value("SpawnYangFeng")then
                if cm:get_saved_value("yangFeng_was_spawned")~= true or cm:get_saved_value("yan_feng_emergent_registered")~=true then --cm:get_saved_value("yangFeng_was_spawned")~=true
					CusLog("!!..re-register Yangfeng emergent ")
					register_yang_feng_emergent_faction_2() -- unknown if these persist over saves
				else
					CusLog("???.. SpawnYangFeng, but yangFeng_was_spawned="..tostring(cm:get_saved_value("yangFeng_was_spawned")))
				end
            end
             if context:query_model():date_in_range(189,192) and cm:get_saved_value("SpawnZhouxin") then
				if cm:get_saved_value("zhou_xin_emergent_registered")~= true or cm:get_saved_value("ZhouXinSpawned")~=true then 
					CusLog("!!..re-register SpawnZhouxin emergent ")
					register_zhou_xin_emergent_faction_2() -- unknown if these persist over saves
				else
					CusLog("???.. SpawnZhouxin, but zhou_xin_emergent_registered="..tostring(cm:get_saved_value("zhou_xin_emergent_registered")))
				end
            end
			if context:query_model():date_in_range(194,197) and cm:get_saved_value("Spawnzhang_xiu") then
				if cm:get_saved_value("zhang_xiu_emergent_registered")~= true or cm:get_saved_value("ZhangxiuSpawned")~=true then 
                    if context:query_model():campaign_name()~="3k_dlc05_start_pos" then 
                        CusLog("!!..re-register Spawnzhang_xiu emergent ")
                        register_zhang_xiu_emergent_faction_2() -- unknown if these persist over saves
                    else 
                        CusLog("cant spawn zhang xiu in 194-unknown")
                    end
				else
					CusLog("???.. Spawnzhang_xiu, but zhang_xiu_emergent_registered="..tostring(cm:get_saved_value("zhang_xiu_emergent_registered")))
				end
            end
			-----CHENG YU
			if context:query_model():date_in_range(191,194) and cm:get_saved_value("SpawnChengYu") then
				if cm:get_saved_value("cheng_yu_emergent_registered")~= true or cm:get_saved_value("ChengYuSpawned")~=true then 
					CusLog("!!..re-register Spawnzhang_xiu emergent ")
					register_cheng_yu_emergent_faction_2() -- unknown if these persist over saves
				else
					CusLog("???.. ChengYuSpawned, but register_cheng_yu_emergent_faction_2="..tostring(cm:get_saved_value("cheng_yu_emergent_registered")))
				end
            end
              --2Chens
             if context:query_model():date_in_range(190,195)  then -- might crash in 194 campaign 
                if cm:get_saved_value("SpawnTwoChens")== true and cm:get_saved_value("TwoChensSpawned")~=true then 
                    CusLog("!!..re-register twochens emergent ")
                    register_twochens_emergent_faction_2() -- unknown if these persist over saves
                else
                     CusLog("???.. SpawnTwoChens, but register_twochens_emergent_faction_2="..tostring(cm:get_saved_value("twochens_emergent_registered")))
                end
            end
             --ZangBa 190
             if context:query_model():date_in_range(193,194)  then
                if cm:get_saved_value("Spawnzangba")== true and cm:get_saved_value("zangbaSpawned")~=true then 
                    CusLog("!!..re-register zangba emergent ")
                    register_zangba_emergent_faction_2() -- unknown if these persist over saves
                else
                     CusLog("???.. Spawnzangba, but register_zangba_emergent_faction_2="..tostring(cm:get_saved_value("zangba_emergent_registered")))
                end
            end
             --YuanTan 190
             if context:query_model():date_in_range(194,196)  then
                if cm:get_saved_value("SpawnYuanTan")== true and cm:get_saved_value("YuanTanSpawned")~=true then 
                    if context:query_model():campaign_name()~="3k_dlc05_start_pos" then 
                        CusLog("!!..re-register YuanTan emergent ")
                        register_YuanTan_emergent_faction_2() -- unknown if these persist over saves
                    end
                else
                     CusLog("???.. SpawnYuanTan, but register_YuanTan_emergent_faction_2="..tostring(cm:get_saved_value("YuanTan_emergent_registered")))
                end
            end 
			--YuanShang All?
             if context:query_model():date_in_range(199,207)  then
                if cm:get_saved_value("SpawnYuanShang")== true and cm:get_saved_value("YuanShangSpawned")~=true then 
                    CusLog("!!..re-register YuanShang emergent ")
                    register_YuanShang_emergent_faction_2() -- unknown if these persist over saves
                else
                     CusLog("???.. SpawnYuanShang, but register_YuanShang_emergent_faction_2="..tostring(cm:get_saved_value("YuanShang_emergent_registered")))
                end
            end    
            	--CheZhou All?
                if context:query_model():date_in_range(195,207)  then -- will probably crash in AWB 
                    if cm:get_saved_value("SpawnCheZhou")== true and cm:get_saved_value("CheZhouSpawned")~=true then 
                        CusLog("!!..re-register CheZhou emergent ")
                        register_CheZhou_emergent_faction_2() -- unknown if these persist over saves
                    else
                         CusLog("???.. SpawnCheZhou, but register_CheZhou_emergent_faction_2="..tostring(cm:get_saved_value("CheZhou_emergent_registered")))
                    end
                end    
            --LuLingqi All?
            if context:query_model():date_in_range(194,213)  then
                if cm:get_saved_value("SpawnLuLingqi")== true and cm:get_saved_value("LuLingqiSpawned")~=true then 
                    CusLog("!!..re-register LuLingqi emergent ")
                    register_LuLingqi_emergent_faction_2() -- unknown if these persist over saves
                else
                     CusLog("???.. SpawnLuLingqi, but register_LuLingqi_emergent_faction_2="..tostring(cm:get_saved_value("LuLingqi_emergent_registered")))
                end
            end    	
            
            CusLog("CAMPAIGN="..context:query_model():campaign_name())
    end
)
