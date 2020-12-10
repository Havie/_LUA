---> LiuBeis Movement 
--> Go to YuanShao if <2 regions between 195-201 and Yuan Shao isnt human  (cushion time for sandbox/dongchengplot)
--> Go to LiuBiao if <2 regions after 201 and Liu Biaos alive 
--> Gets LiuBei ZhaoYun in a number of ways 


--After gonsuzan is confederated/dongcheng plot starts, liu bei should end up back in Xu 
-- At such time, we should listen that if he has 1 region or less, he can flee to yuan shao , in which he will lose guan yu
-- Need to start buffing cao cao again,
-- Also if yuan shu faction is destroyed, have cao cao declare war on liu bei for not returning troops (dong cheng exposes letter accomplishes this well enough)

--TODO set up guan yus loss and return 
--TODO all player parts of this 
-->TODO starts Player liu beis war on Shu?

local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_liubei_movement.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
        local header=" (liubei_movement): "
		local line= time..header..text
		file:write(line.."\n")
        file:close()
       ModLog(header..text)
    end
end

local function IniDebugger()
	printStatements=true;
    local file = io.open("@havie_liubei_movement.txt", "w+")
    file:close()
	CusLog("---Begin File----")
end



function ResetliubeisMovement() 
   CusLog("Resetting LiuBeis movement")
    local qliubei= getQChar("3k_main_template_historical_liu_bei_hero_earth")
    if( not qliubei:is_null_interface())then
        if(qliubei:has_military_force() )then 
            for i = 0, qliubei:military_force():character_list():num_items()  - 1 do
                local character= qliubei:military_force():character_list():item_at(i);
                cm:modify_character(character):replenish_action_points()
				CusLog("....reset-->"..character:generation_template_key())
                if(RNGHelper(2) )then 
                        CusLog("...Calling Reset again because sometimes doesnt work...")
                        ResetliubeisMovement()
                    return;
                end

            end
        end      
    end
    CusLog("...Reset LiuBeis movement!")
end



local function LiuBiaoGivesLands()
    CusLog(" BEGIN LiuBiaoGivesLands ")
    --Liu Bei convinced Yuan Shao to "lend" him troops to assist Liu Pi. At this time, Guan Yu rejoined Liu Bei. 
    --Liu Bei and Liu Pi then led their forces from Runan Commandery to attack Xuchang while Cao Cao was away at Guandu, but they were defeated by Cao Ren. 
    --Liu Bei then returned to Yuan Shao and urged him to ally with Liu Biao, 
	cm:modify_faction("3k_main_faction_liu_bei"):increase_treasury(700) 
	CusLog("--Gave liuBei Money")

    cm:apply_effect_bundle("3k_dlc05_effect_bundle_granted_sanctuary", "3k_main_faction_liu_bei" , 2)
	CusLog("--Gave LiuBei bundle")
	local qliubeiFaction= cm:query_faction("3k_main_faction_liu_bei")
	local qliuBiaoFaction = cm:query_faction("3k_main_faction_liu_biao")
   

    local qRegion_1 =cm:query_region("3k_main_runan_capital")
    local qRegion_2 =cm:query_region("3k_main_runan_resource_1") 
    local qRegion_3 =cm:query_region("3k_main_nanyang_resource_1") 
    local qRegion_4 =cm:query_region("3k_main_xiangyang_resource_1")
    local qRegion_5 =cm:query_region("3k_main_xiangyang_capital")
    
    if qRegion_1:owning_faction():name()== "3k_main_faction_liu_biao" or not qRegion_1:owning_faction():is_human() then 
        cm:modify_model():get_modify_region(qRegion_1):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))					
		if not qliubeiFaction:is_human() then 
			TelportAllFactionArmies("3k_main_faction_liu_bei",qRegion_1:name())
        end
        if (qRegion_2:owning_faction():name()== "3k_main_faction_liu_biao" or not qRegion_2:owning_faction():is_human()) then 
            cm:modify_model():get_modify_region(qRegion_2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))					
        end
	elseif qRegion_2:owning_faction():name()== "3k_main_faction_liu_biao" or not qRegion_3:owning_faction():is_human() then 
        cm:modify_model():get_modify_region(qRegion_2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))					
		if not qliubeiFaction:is_human() then 
			TelportAllFactionArmies("3k_main_faction_liu_bei",qRegion_2:name())
        end
        if (qRegion_3:owning_faction():name()== "3k_main_faction_liu_biao" or not qRegion_3:owning_faction():is_human()) then 
            cm:modify_model():get_modify_region(qRegion_3):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))					
        end
	elseif qRegion_3:owning_faction():name()== "3k_main_faction_liu_biao" or not qRegion_3:owning_faction():is_human() then 
        cm:modify_model():get_modify_region(qRegion_3):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))					
		if not qliubeiFaction:is_human() then 
			TelportAllFactionArmies("3k_main_faction_liu_bei",qRegion_3:name())
        end
        CusLog("liu bei in a weird spot, giving him some cushion")
        qRegion_3 =cm:query_region("3k_main_nanyang_capital") --3k_main_nanyang_capital 3k_main_shangyong_capital
        if not qRegion_3:is_null_interface() and not qRegion_3:owning_faction():is_human() and RNGHelper(3) then 
            cm:modify_model():get_modify_region(qRegion_3):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))					
        end
    elseif qRegion_4:owning_faction():name()== "3k_main_faction_liu_biao" then 
        cm:modify_model():get_modify_region(qRegion_4):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))					
		if not qliubeiFaction:is_human() then 
			TelportAllFactionArmies("3k_main_faction_liu_bei",qRegion_4:name())
        end
    elseif qRegion_5:owning_faction():name()== "3k_main_faction_liu_biao" then 
        cm:modify_model():get_modify_region(qRegion_5):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))					
		if not qliubeiFaction:is_human() then 
			TelportAllFactionArmies("3k_main_faction_liu_bei",qRegion_5:name())
		end
	else
		CusLog("Warning, no good regions for LiuBei")
	end

    
    --Set vassalship via event(s)
    
        --do I NEED a peace check for war?

        if cm:query_faction("3k_main_faction_liu_biao"):has_specified_diplomatic_deal_with("treaty_components_alliance",qliubeiFaction) or cm:query_faction("3k_main_faction_liu_biao"):has_specified_diplomatic_deal_with("treaty_components_coalition",qliubeiFaction) then
            --Do nothing 
            CusLog("liubiao in an alliance with liu bei, leave it alone?")
         else
             CusLog("liubei and biao not in allystate, must vassalize")
             VassalizeSomeone("3k_main_faction_liu_biao", "3k_main_faction_liu_bei")
         end
	

	if qliubeiFaction:is_human() then 
		--Trigger differently worded incident 
		cm:trigger_incident(playerFaction,"3k_lua_liubiao_accepts_liubei", true ) --TODO
	elseif qliuBiaoFaction:is_human() then 
		--Do Nothing? You chose this via dilemma 
	else
		local playersFactionsTable = cm:get_human_factions()
		local playerFaction = playersFactionsTable[1]
		cm:trigger_incident(playerFaction,"3k_lua_liubiao_accepts_liubei_global", true ) --TODO
	end
	
    --Set a value here or in listener 
    cm:set_saved_value("liubei_saved",true);
    CusLog("Finished LiuBiaoGivesLands")

end

local function ChecklandsLiuBiao()
    CusLog("Begin ChecklandsLiuBiao")
    local qRegion_1 =cm:query_region("3k_main_runan_capital")
    local qRegion_2 =cm:query_region("3k_main_runan_resource_1")
    local qRegion_3 =cm:query_region("3k_main_nanyang_resource_1") 
    local qRegion_4 =cm:query_region("3k_main_xiangyang_resource_1")
    local qRegion_5 =cm:query_region("3k_main_xiangyang_capital")
    
    if not qRegion_1:is_null_interface() then 
        if not qRegion_1:owning_faction():is_human() and qRegion_1:owning_faction():name()~= "3k_main_faction_liu_biao" then
            cm:modify_model():get_modify_region(qRegion_1):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_biao"))				
        end
    end
    if not qRegion_2:is_null_interface() then 
        if not qRegion_2:owning_faction():is_human() and qRegion_2:owning_faction():name()~= "3k_main_faction_liu_biao" then
            cm:modify_model():get_modify_region(qRegion_2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_biao"))				
        end
    end
    if not qRegion_3:is_null_interface() then 
        if not qRegion_3:owning_faction():is_human() and qRegion_3:owning_faction():name()~= "3k_main_faction_liu_biao" then
            cm:modify_model():get_modify_region(qRegion_3):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_biao"))				
        end
    end
    if not qRegion_4:is_null_interface() then 
        if not qRegion_1:owning_faction():is_human() and qRegion_4:owning_faction():name()~= "3k_main_faction_liu_biao" then
            cm:modify_model():get_modify_region(qRegion_4):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_biao"))				
        end
    end
    if not qRegion_5:is_null_interface() then 
        if not qRegion_1:owning_faction():is_human() and qRegion_5:owning_faction():name()~= "3k_main_faction_liu_biao" then
            cm:modify_model():get_modify_region(qRegion_5):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_biao"))				
        end
    end

    CusLog("End ChecklandsLiuBiao")
end


local function YuanShaoGivesLandsLiuBei() --Todo Need pingyuan names , events in db 
	
	cm:apply_effect_bundle("3k_dlc05_effect_bundle_granted_sanctuary", "3k_main_faction_liu_bei" , 2)
	CusLog("--Gave LiuBei bundle")
	local qliubeiFaction= cm:query_faction("3k_main_faction_liu_bei")
	local qYuanShaoFaction = cm:query_faction("3k_main_faction_yuan_shao")
	
	local qRegion_1 =cm:query_region("3k_main_qRegion_1")
    local qRegion_2 =cm:query_region("3k_main_qRegion_2") 
	local qRegion_3 =cm:query_region("3k_main_qRegion_3") 
    
    if qRegion_1:owning_faction():name()== "3k_main_faction_yuan_shao" then 
        cm:modify_model():get_modify_region(qRegion_1):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))					
		if not qliubeiFaction:is_human() then 
			TelportAllFactionArmies("3k_main_faction_liu_bei",qRegion_1:name())
		end
	elseif qRegion_2:owning_faction():name()== "3k_main_faction_yuan_shao"  then 
        cm:modify_model():get_modify_region(qRegion_2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))					
		if not qliubeiFaction:is_human() then 
			TelportAllFactionArmies("3k_main_faction_liu_bei",qRegion_2:name())
		end
	elseif qRegion_3:owning_faction():name()== "3k_main_faction_yuan_shao" then 
		cm:modify_model():get_modify_region(qRegion_3):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))					
		if not qliubeiFaction:is_human() then 
			TelportAllFactionArmies("3k_main_faction_liu_bei",qRegion_3:name())
		end
	else
		CusLog("Warning, no good regions for LiuBei")
	end
	
	--Set vassalship via event(s)
	
	if qliubeiFaction:is_human() then 
		--Trigger differently worded incident 
		cm:trigger_incident(playerFaction,"3k_lua_yuanshao_accepts_liubei", true ) --TODO
	elseif qYuanShaoFaction:is_human() then 
		--Do Nothing? You chose this via dilemma 
	else
		local playersFactionsTable = cm:get_human_factions()
		local playerFaction = playersFactionsTable[1]
		cm:trigger_incident(playerFaction,"3k_lua_yuanshao_accepts_liubei_global", true ) --TODO
	end
	
	--Set a value here or in listener 
    cm:set_saved_value("turnsNo_till_liuBei_can_flee", cm:query_model():turn_number()+8)
	CusLog("Finished LiuBiaoGivesLands")
	
end
local function GoToLiuBiao() -- Need Region Names
	CusLog("Begin GoToLiuBiao ")
    cm:set_saved_value("liu_bei_fire_liubiao_accepts", true);

    --have to handle if player skips to this 
    local myFaction= cm:query_faction("3k_main_faction_liu_bei")
    if cm:is_world_power_token_owned_by("emperor", "3k_main_faction_liu_bei")  then
        CusLog("..! liubei has the emperor, transfer to Cao CAo? ")
		campaign_emperor_manager:transfer_token_to_faction(cm:modify_faction("3k_main_faction_cao_cao"):query_faction(), myFaction, "emperor")
	end
	
    local qliubei=getQChar('3k_main_template_historical_liu_bei_hero_earth') -- cant be null, that wud be nuts
	if not qliubei:has_military_force() then 
		NoForceSpawn("3k_main_faction_liu_bei")
	end
	
	if myFaction:treasury() < 1500 then 
		cm:modify_faction("3k_main_faction_liu_bei"):increase_treasury(1500-myFaction:treasury()) -- keep him a float
	end

    AbandonLands("3k_main_faction_liu_bei");

    --make sure LiuBiao has land for us 
    qLiuBiaoFaction =cm:query_faction("3k_main_faction_yuan_shao")
    if(qLiuBiaoFaction:is_human() ==false) then 
	    local desired_region =cm:query_region("3k_main_weijun_resource_1") --?? TODO
	    local desired_region2 =cm:query_region("3k_main_anping_resource_1") --?? 2 TODO 
	    if desired_region:owning_faction():is_human()==false and desired_region2:owning_faction():name()~="3k_main_faction_yuan_shao" then 
		    cm:modify_model():get_modify_region(desired_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_yuan_shao"))
	    elseif desired_region2:owning_faction():is_human()==false and desired_region2:owning_faction():name()~="3k_main_faction_yuan_shao"  then 
            cm:modify_model():get_modify_region(desired_region2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_yuan_shao"))
        end
    end


    
					
    CusLog("End GoToLiuBiao ")
end

local function GoToYuanShao() -- Need pingyuan names 
    CusLog("Begin GoToYuanShao ")
    cm:set_saved_value("liu_bei_fire_yuan_shao_accepts", true);

    --have to handle if player skips to this 
    local myFaction= cm:query_faction("3k_main_faction_liu_bei")
    if cm:is_world_power_token_owned_by("emperor", "3k_main_faction_liu_bei")  then
        CusLog("..! liubei has the emperor, transfer to Cao CAo? ")
		campaign_emperor_manager:transfer_token_to_faction(cm:modify_faction("3k_main_faction_cao_cao"):query_faction(), myFaction, "emperor")
	end
	
    local qliubei=getQChar('3k_main_template_historical_liu_bei_hero_earth') -- cant be null, that wud be nuts
	if not qliubei:has_military_force() then 
		NoForceSpawn()
	end
	
	if myFaction:treasury() < 1500 then 
		cm:modify_faction("3k_main_faction_liu_bei"):increase_treasury(1500-myFaction:treasury()) -- keep him a float
	end

    AbandonLands("3k_main_faction_liu_bei");

    --make sure YuanShao has land for us 
    q_yuanshao_faction =cm:query_faction("3k_main_faction_yuan_shao")
    if(q_yuanshao_faction:is_human() ==false) then 
	    local desired_region =cm:query_region("3k_main_weijun_resource_1") --Pingyuan TODO
	    local desired_region2 =cm:query_region("3k_main_anping_resource_1") --PingYuan 2 TODO 
	    if desired_region:owning_faction():is_human()==false and desired_region2:owning_faction():name()~="3k_main_faction_yuan_shao" then 
		    cm:modify_model():get_modify_region(desired_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_yuan_shao"))
	    elseif desired_region2:owning_faction():is_human()==false and desired_region2:owning_faction():name()~="3k_main_faction_yuan_shao"  then 
            cm:modify_model():get_modify_region(desired_region2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_yuan_shao"))
        end
    end
    
	--Tigger dilemma where Liu Bei loses Guan Yu
	local caoFaction= getQFaction("3k_main_faction_cao_cao")
	if caoFaction~=nil then 
		MoveCharToFactionHard("3k_main_template_historical_guan_yu_hero_wood", "3k_main_faction_cao_cao");
		if qliubei:faction():is_human() then 
			trigger_incident("3k_main_faction_liu_bei", "3k_lua_liubei_separated_guanyu",true)--TODO 
		end
		if caoFaction:is_human() then 
			--Trigger vanilla dilemma 
			trigger_incident("3k_main_faction_cao_cao", "?????",true)--TODO 
		end
		
	end			
    CusLog("End GoToYuanShao ")
end

local function PromptLiuBiao()
	CusLog("Begin PromptLiuBiao")
	local qliuBeiFaction = cm:query_faction("3k_main_faction_liu_bei")
	local qLiuBiaoFaction = cm:query_faction("3k_main_faction_liu_biao")
	
	if qliuBeiFaction:is_null_interface() or qLiuBiaoFaction:is_null_interface() then 
		CusLog("..one factions null")
		return ;
	elseif qliuBeiFaction:is_human() and qLiuBiaoFaction:is_human() then 
		CusLog("both factions humans...sketch, hopefully zhao yun made it to liu bei by now")
		MoveCharToFaction("3k_main_template_historical_zhao_yun_hero_metal", "3k_main_faction_liu_bei")
		--return ;
	elseif qLiuBiaoFaction:is_dead() then 
		CusLog("yuan shaos dead,  hopefully zhao yun made it to liu bei by now")
		--MoveCharToFaction("3k_main_template_historical_zhao_yun_hero_metal", "3k_main_faction_liu_bei")
		return ;
	end 
	
	if qliuBeiFaction:is_human() then 
		--tigger dilemma to flee
        cm:trigger_dilemma("3k_main_faction_liu_bei", "3k_lua_liubei_yuanshao_dilemma", true)
        ChecklandsLiuBiao()
	elseif qLiuBiaoFaction:is_human() then 
		--trigger dilemma to accept 
		cm:trigger_dilemma("3k_main_faction_liu_biao", "3k_lua_liubiao_liubei_dilemma", true)
	else 
        ChecklandsLiuBiao()
        AbandonLands("3k_main_faction_liu_bei")
        LiuBiaoGivesLands() -- move him to the general region and let the vanilla confederation script do rest
	end
	CusLog("End PromptLiuBiao")
end

local function PromptYuanShao() 
	CusLog("Begin PromptYuanShao")
	local qliuBeiFaction = cm:query_faction("3k_main_faction_liu_bei")
	local qYuanShaoFaction = cm:query_faction("3k_main_faction_yuan_shao")
	
	if qliuBeiFaction:is_null_interface() or qYuanShaoFaction:is_null_interface() then 
		CusLog("..one factions null")
		return;
	elseif qliuBeiFaction:is_human() and qYuanShaoFaction:is_human() then 
		CusLog("both factions humans...sketch, go to liu biao, idk about zhao yun *sad* just move him? (not hard)")
		MoveCharToFaction("3k_main_template_historical_zhao_yun_hero_metal", "3k_main_faction_liu_bei")
		PromptLiuBiao()
		return ;
	elseif qYuanShaoFaction:is_dead() then 
		CusLog("yuan shaos dead, go to liubiao idk about zhao yun *sad* , just move him? (not hard)")
		MoveCharToFaction("3k_main_template_historical_zhao_yun_hero_metal", "3k_main_faction_liu_bei")
		PromptLiuBiao()
		return ;
	end 
	
	if qliuBeiFaction:is_human() then 
		cm:trigger_dilemma("3k_main_faction_liu_bei", "3k_lua_liubei_yuanshao_dilemma", true)
	elseif qYuanShaoFaction:is_human() then 
		cm:trigger_dilemma("3k_main_faction_liu_bei", "3k_lua_yuanshao_liubei_dilemma", true)
	else 
        AbandonLands("3k_main_faction_liu_bei")
        YuanShaoGivesLandsLiuBei()
	end
	CusLog("End PromptYuanShao")
end

--Cant flee if vassal of CaoCao, or Plot line active 
local function CheckPlotLines(LiuBeiFaction)
	CusLog("Checking if other scripts set LiuBei can flee, also depends on vassal status w caocao (turn#)="..tostring(cm:get_saved_value("turnsNo_till_liuBei_can_flee")))
    if cm:query_faction("3k_main_faction_cao_cao"):has_specified_diplomatic_deal_with("treaty_components_vassalage",LiuBeiFaction) then 
        return false 
	else  
		return cm:get_saved_value("turnsNo_till_liuBei_can_flee") <= context:query_model():turn_number() 
    end 
		
	
end



---------------------------------------------------------------
------------------------- LISTENERS ---------------------------
---------------------------------------------------------------

local function LiuBiaoAcceptsListener() 
    CusLog("### LiuBiaoAcceptsListener 2 loading ###")
    core:remove_listener("LiuBiaoAccepts") -- prevent duplicates
	core:add_listener(
		"LiuBiaoAccepts",
		"CharacterFinishedMovingEvent",
        function(context)
            local qchar = context:query_character();
            if qchar:faction():name() =="3k_main_faction_liu_bei" and cm:get_saved_value("liubei_fire_liubiao_accepts") then
                CusLog("..Checking LiuBiaoAcceptsListener delay:") 
                if qchar:region():owning_faction():name() == "3k_main_faction_liu_biao" then 
                    return true;
                end
            end
             return false
		end,
		function(context)
            CusLog("??? Callback: LiuBiaoAcceptsListener ###")
			cm:set_saved_value("liubei_fire_liubiao_accepts", false);
            LiuBiaoGivesLands();
			--Also Check ZhaoYun incase we missed it 
			local qChar= getQChar2("3k_main_template_historical_zhao_yun_hero_metal")
			if qChar~=nil then 
				if qChar:faction():name() ~= "3k_main_faction_liu_bei" then --Shud also be caught in the listener. 
					cm:trigger_dilemma("3k_main_faction_liu_bei", "3k_lua_zhao_yun_joins_dilemma", true)
				end
			end
		end,
		false
    )
end
local function YuanShaoAccepts1Listener() 
    CusLog("### YuanShaoAcceptsListener 1 loading ###")
    core:remove_listener("YuanShaoAccepts1") -- prevent duplicates
	core:add_listener(
		"YuanShaoAccepts1",
		"CharacterFinishedMovingEvent",
        function(context)
           CusLog("..Listening for liubei to stop moving (shao)")
            local qchar = context:query_character();
            if qchar:faction():name() == "3k_main_faction_liu_bei"  and cm:get_saved_value("liubei_fire_yuanshao_accepts") then
				CusLog("..listening for YuanShao Accepts, checking region: "..tostring(qchar:region():name()))
					if(qchar:region():owning_faction():name() == "3k_main_faction_yuan_shao") then
						return true;
                    end
            end
             
             return false
		end,
		function(context)
            CusLog("### Passed YuanShaoAccepts1Listener ###")
     		YuanShaoGivesLandsLiuBei();
            cm:set_saved_value("liu_bei_fire_yuan_shao_accepts", false);
            local maxT=6;
            if context:query_model():calendar_year() >199 then 
                maxT=3;
            elseif context:query_model():calendar_year() == 198 then
                maxT=4;
            end
            local rolled_value = cm:random_number( 2, maxT );
            cm:set_saved_value("liubei_fire_yuanshao_rumors",rolled_value)
			--cm:set_saved_value("liubei_went_to_yuanshao",true)
            YuanShaoRumorsDelayListener1()
		end,
		false
    )
end


local function YuanShaoRumorsDelayListener1() --ToDo 
    CusLog("### YuanShaoRumorsDelayListener1 1 loading ###")
    core:remove_listener("YuanShaoRumorsDelay1") -- prevent duplicates
	core:add_listener(
		"YuanShaoRumorsDelay1",
		"FactionTurnEnd",
        function(context)
            local faction_key = context:faction();
            if faction_key:is_human() == true and cm:get_saved_value("liu_bei_fire_yuan_shao_rumors") ~=nil then
            CusLog("..listening for YuanShaoRumorsDelayListener1 delay int:".. tostring(cm:get_saved_value("liu_bei_fire_yuan_shao_rumors"))) 
			local timeUntilRumor = cm:get_saved_value("liu_bei_fire_yuan_shao_rumors")
			CusLog("--Time Until Rumors=:"..timeUntilRumor)
                 if timeUntilRumor <=1 or context:query_model():calendar_year()>194 then 
					 return true
				 else
					cm:set_saved_value("liu_bei_fire_yuan_shao_rumors", timeUntilRumor-1);
                 end
            end
             
             return false
		end,
		function()
            CusLog("### Passed YuanShaoRumorsDelayListener1 ###")
            core:remove_listener("YuanShaoRumorsDelay1");
            cm:set_saved_value("liubei_fire_yuanshao_rumors",999)
           --Fire incident ok here cuz of turn start?
            YuanShaoRumorsListener()
             local playersFactionsTable = cm:get_human_factions()
             local playerFaction = playersFactionsTable[1]
             cm:trigger_incident(playerFaction,"3k_lua_yuan_shao_rumours_liu_bei", true ) 
		end,
		true
    )
end
function YuanShaoRumorsListener()   --ToDo
    CusLog("### YuanShaoRumorsListener 2 loading ###")
    core:remove_listener("YuanShaoRumorsListener") -- prevent duplicates
	core:add_listener(
		"YuanShaoRumorsListener",
		"IncidentOccuredEvent",
		function(context)
			 return context:incident() == "3k_lua_yuan_shao_rumours_liu_bei"
		end,
		function(context)
            CusLog("??? Callback: YuanShaoRumorsListener (trigger next dilemma)")
            liubei3ChoiceMadeListener()
            --Trigger Dilemma to go to LiuBiao and get Guan Yu back? and 
			cm:trigger_dilemma(playerFaction, "3k_lua_liubei_03_dilemma", true) 
		end,
		false
    )
end


local function ZhaoYunJoinsListener() -- there is some failsafe, where if liu bei is promoted to go to yuanshao and yuanshao is dead, or both human, will get zhaoyun becuz he wont make it north
    CusLog("### ZhaoYunJoinsListener loading ###")
    core:remove_listener("ZhaoYunJoins") -- prevent duplicates
	core:add_listener(
		"ZhaoYunJoins",
		"FactionTurnStart",
        function(context)
                if context:faction():name()=="3k_main_faction_liu_bei" then 
                    CusLog("Liubeis turn")
                    local qChar= getQChar("3k_main_template_historical_zhao_yun_hero_metal")
                    if not qChar:is_null_interface() then 
                        if not qChar:is_dead() then 
                            if qChar:faction():name() ~= "3k_main_faction_gongsun_zan" and qChar:faction():name() ~= "3k_main_faction_liu_bei" then 
                                CusLog(".. Zhao Yun is not with gonsun or liubei")
                                local liubeiFaction=cm:query_faction("3k_main_faction_liu_bei")
                                if liubeiFaction:is_human() then 
                                    if cm:query_faction("3k_main_faction_yuan_shao"):has_specified_diplomatic_deal_with("treaty_components_vassalage",liubeiFaction) then
                                        return true; 
									elseif cm:query_faction("3k_main_faction_liu_biao"):has_specified_diplomatic_deal_with("treaty_components_vassalage",liubeiFaction) then
                                        return true; --LiuBei skipped Yuan Shao cuz he was late. 
									else
                                        --Check regions
                                        local northernRegion1= cm:query_region("3k_main_pingyuan_capital")
                                        local northernRegion2= cm:query_region("3k_main_pingyuan_resource_1")
                                        local northernRegion3= cm:query_region("3k_main_bohai_resource_1")
                                        if not northernRegion1:is_null_interface() and not northernRegion2:is_null_interface() and not northernRegion3:is_null_interface() then 
                                            if northernRegion1:owning_faction():name() =="3k_main_faction_liu_bei" or northernRegion2:owning_faction():name() =="3k_main_faction_liu_bei" or northernRegion3:owning_faction():name() =="3k_main_faction_liu_bei" then 
                                               CusLog("liu bei owns the right regions ")
                                                return true
                                            else
                                                local qliubei= getQChar("3k_main_template_historical_liu_bei_hero_earth")
                                                if qliubei:has_military_force() then 
                                                    if qliubei:region():name()=="3k_main_pingyuan_capital" or  qliubei:region():name()=="3k_main_pingyuan_resource_1" or  qliubei:region():name()=="3k_main_bohai_resource_1" then 
                                                        CusLog("liubei in the right place to find zhao yun")
                                                        return true;
                                                    end
                                                end
                                            end
                                        else
                                            CusLog(" one of these regions are null, check")
                                        end
                                     end
                                elseif not liubeiFaction:is_dead() then --AI 
                                  CusLog("Liubei Ai alive ")
                                    return true
                                end
                            end
                        else
                            CusLog("@@@! Zhao Yun is dead... should we respawn for player?")
                        end
                    end
                end
             return false
		end,
        function(context)
            CusLog("??? Callback: ZhaoYunJoinsListener  ###")
            if context:faction():is_human() then 
                cm:trigger_dilemma("3k_main_faction_liu_bei", "3k_lua_zhao_yun_joins_dilemma", true)
            else
                MoveCharToFaction("3k_main_template_historical_zhao_yun_hero_metal", "3k_main_faction_liu_bei")
            end
		end,
		true
    )
end
 
local function liubei2ChoiceMadeListener()
    CusLog("### liubei2ChoiceMadeListener 2 loading ###")
    core:remove_listener("DilemmaChoiceMadeliubei2") -- prevent duplicates
    core:add_listener(
    "DilemmaChoiceMadeliubei2",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_liubei_liubiao_dilemma"
    end,
    function(context)
        CusLog("..! 3k_lua_liubei_liubiao_dilemma choice was:" .. tostring(context:choice()))
        if context:choice() == 0 then
            GoToLiuBiao() 
            cm:apply_effect_bundle("3k_main_payload_faction_forces_supplies_enemy_territory", "3k_main_faction_liu_bei" , 1)
            cm:apply_effect_bundle("3k_dlc04_effect_bundle_free_force", "3k_main_faction_liu_bei" , 2)
        end
        cm:set_saved_value("liu_bei_fire_yuan_shu_rejection",false)
        core:remove_listener("DilemmaChoiceMadeliubei2");
    end,
    true
  );
end
local function YuanShaoTakeInLiuBeiListener()
    CusLog("### YuanShaoTakeInLiuBeiListener 2 loading ###")
    core:remove_listener("YuanShaoTakeInLiuBei") -- prevent duplicates
    core:add_listener(
    "YuanShaoTakeInLiuBei",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_yuanshao_liubei_dilemma" --ToDo
    end,
    function(context)
        CusLog("..! 3k_lua_yuanshao_liubei_dilemma choice was:" .. tostring(context:choice()))
        if context:choice() == 0 then
            AbandonLands("3k_main_faction_liu_bei")
			--Teleport armies??
			YuanShaoGivesLandsLiuBei() 
            cm:apply_effect_bundle("3k_main_payload_faction_forces_supplies_enemy_territory", "3k_main_faction_liu_bei" , 1)
            cm:apply_effect_bundle("3k_dlc04_effect_bundle_free_force", "3k_main_faction_liu_bei" , 2)
        end
        --cm:set_saved_value("liu_bei_fire_yuan_shu_rejection",false)

    end,
    false
  );
end
local function liubei1ChoiceMadeListener()
    CusLog("### liubei1ChoiceMadeListener 2 loading ###")
    core:remove_listener("DilemmaChoiceMadeliubei1") -- prevent duplicates
    core:add_listener(
    "DilemmaChoiceMadeliubei1",
    "DilemmaChoiceMadeEvent",
    function(context)
        CusLog("..Listening for 3k_lua_liubei_yuanshao_dilemma choice ")
        return context:dilemma() == "3k_lua_liubei_yuanshao_dilemma"  
    end,
    function(context)
        CusLog("..! 3k_lua_liubei_yuanshao_dilemma choice was:" .. tostring(context:choice()))
        if context:choice() == 0 then
             GoToYuanShao()
             cm:set_saved_value("liubei_bonus_movement",true) 
             cm:set_saved_value("liubei_turntime", 2) 
             cm:set_saved_value("liubei_turncounter", 4);
             liubeiMoveDecayListener()
             cm:apply_effect_bundle("3k_dlc04_effect_bundle_free_force", "3k_main_faction_liu_bei" , 2)
		end
        -- cm:set_saved_value("liubei_decided",true)  - unused?
         core:remove_listener("DilemmaChoiceMadeliubei1");
    end,
    true
 );
end

--Needs serious testing 
local function liubeiFleesListener() --Player and AI 190 and AWB , cant flee if vassal of lubu/Caocao, OR certain plot lines in play
    CusLog("### liubeiFleesListener 2 loading ###")
    core:remove_listener("liubeiFlees") 
	core:add_listener(
		"liubeiFlees",
		"FactionTurnEnd",
        function(context)
                if context:faction():name()=="3k_main_faction_liu_bei"  and cm:get_saved_value("liubei_saved")~=true then 
                    local RegionCount= CountRegions("3k_main_faction_liu_bei")
                    if RegionCount < 2 then 
                        CusLog("Liubei has less than 2 regions")
                        local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
					    if qlubu:is_faction_leader() and not cm:query_faction(qlubu:faction():name()):has_specified_diplomatic_deal_with("treaty_components_vassalage",context:faction()) then
						    return CheckPlotLines(context:faction()) -- relies on turnsNo_till_liuBei_can_flee
                        end
                    elseif RegionCount < 4 and context:query_model():calendar_year() >201 then 
                        --if war with cao cao, and not vassal of liu biao, , leggo
                        local q_liubei_faction=context:faction()
	                    local q_caocao_faction=cm:query_faction("3k_main_faction_cao_cao")
                        
                        if q_liubei_faction:has_specified_diplomatic_deal_with("treaty_components_war",q_caocao_faction) then 
                            local q_liubiao_faction=cm:query_faction("3k_main_faction_liu_biao") 
                            CusLog("CONDITION(1)="..tostring((not q_liubiao_faction:is_dead() and not q_liubei_faction:has_specified_diplomatic_deal_with("treaty_components_vassalage",q_liubiao_faction))))
                            return (not q_liubiao_faction:is_dead() and not q_liubei_faction:has_specified_diplomatic_deal_with("treaty_components_vassalage",q_liubiao_faction))
                        end
                    elseif RegionCount < 5 and context:query_model():calendar_year()>202 then 
                        local q_liubei_faction=context:faction()
	                    local q_caocao_faction=cm:query_faction("3k_main_faction_cao_cao")
                        
                        if q_liubei_faction:has_specified_diplomatic_deal_with("treaty_components_war",q_caocao_faction) then 
                            local q_liubiao_faction=cm:query_faction("3k_main_faction_liu_biao") 
                            CusLog("CONDITION(2)="..tostring((not q_liubiao_faction:is_dead() and not q_liubei_faction:has_specified_diplomatic_deal_with("treaty_components_vassalage",q_liubiao_faction))))
                            return (not q_liubiao_faction:is_dead() and not q_liubei_faction:has_specified_diplomatic_deal_with("treaty_components_vassalage",q_liubiao_faction))
                        end
	
                    end
				end
             return false
		end,
        function(context)
            CusLog("### Pass liubeiFleesListener ###")
			if context:query_model():date_in_range(195,201) then --have to give some cushion time for sandbox,the dongcheng plot can really slow things down.
				PromptYuanShao() -- lose guan yu to cao cao 
			elseif context:query_model():date_in_range(201,211) then 
				PromptLiuBiao()
			end
		end,
		true
    )
end
local function LiuBeiMoveDecayListener()
    CusLog("### LiuBeiMoveDecayListener loading ###")
    core:remove_listener("LiuBeiMoveDecay") -- prevent duplicates
	core:add_listener(
		"LiuBeiMoveDecay",
		"FactionTurnStart",
        function(context)
            CusLog("..listening for LiuBeiMoveDecayListener ")
                if context:faction():is_human() == true and context:faction():name()=="3k_main_faction_liu_bei" then 
                    if(cm:get_saved_value("liubei_bonus_movement")) then 
                         cm:set_saved_value("liubei_turncounter", 3);
                         CusLog("..Reset liubeis turn counter")
                        local no= cm:get_saved_value("liubei_turntime");
                        if(no>1) then 
                             cm:set_saved_value("liubei_turntime", no-1)
                         else
                              cm:set_saved_value("liubei_bonus_movement",false)
                         end
                    end
                end
             return false
		end,
        function(context)
            CusLog("??? Callback: liubeiMoveDecayListener  ###")
		end,
		true
    )
end


local function liubeiBonusMovementListener()
    CusLog("### liubeiBonusMovementListener 2 loading ###")
    core:remove_listener("liubeiBonusMovement") -- prevent duplicates
	core:add_listener(
		"liubeiBonusMovement",
		"CharacterFinishedMovingEvent",
		function(context)
            if cm:get_saved_value("liubei_bonus_movement")==true then 
                if context:query_character():generation_template_key()== "3k_main_template_historical_liu_bei_hero_earth" then 
                    local liubei = getQChar("3k_main_template_historical_liu_bei_hero_earth")
                    local timesUsed= cm:get_saved_value("liubei_turncounter");
                    CusLog("....Timesused="..tostring(timesUsed))
                    cm:set_saved_value("liubei_turncounter", timesUsed-1);
                    return cm:get_saved_value("liubei_turncounter") > 0; 
                end
            end
            return false;
		end,
        function(context)
            CusLog("???Callback: liubeiBonusMovement ###")
            local max=cm:get_saved_value("liubei_turntime");
            local rolled_value = cm:random_number( 0, max );
            local to_beat=2;
           CusLog("...liubeiBonusMovement Rolled a "..tostring(rolled_value).." needs "..tostring(to_beat).."   (max was):"..tostring(max))
           if rolled_value > to_beat then 
                ResetliubeisMovement() 
                cm:set_saved_value("liubei_turntime", max-1)
           end
           
        end,
		true
    )
end


local function liubeiMovementVariables()
   CusLog("Debug: liubeiMovementVariables")
    
    CusLog("  liubeiMovement liubei_turntime= "..tostring(cm:get_saved_value("liubei_turntime")))
    CusLog("  liubeiMovement liubei_turncounter= "..tostring(cm:get_saved_value("liubei_turncounter")))
	CusLog("  liubeiMovement turnsNo_till_liuBei_can_flee= "..tostring(cm:get_saved_value("turnsNo_till_liuBei_can_flee")))
    
   CusLog("  liubeiMovement liu_bei_fire_yuan_shao_accepts= "..tostring(cm:get_saved_value("liu_bei_fire_yuan_shao_accepts")))
    CusLog("  liubeiMovement liu_bei_fire_yuan_shao_rumors= "..tostring(cm:get_saved_value("liu_bei_fire_yuan_shao_rumors"))) -- get guan yu back 
    CusLog("  liubeiMovement liu_bei_fire_liubiao_accepts= "..tostring(cm:get_saved_value("liu_bei_fire_liubiao_accepts")))
    CusLog("  liubeiMovement liubei_saved= "..tostring(cm:get_saved_value("liubei_saved")))
   
  CusLog("passed testliubei")
end



cm:add_first_tick_callback(
    function(context)
        IniDebugger()
        liubeiMovementVariables()
        if context:query_model():turn_number() ==1 then 
			cm:set_saved_value("turnsNo_till_liuBei_can_flee", 999);
		end
		if context:query_model():date_in_range(194,210) then
            if cm:get_saved_value("liu_bei_is_human")==true then
			    liubei1ChoiceMadeListener() -- go to yuan shao 
                liubei2ChoiceMadeListener() -- go to liu biao 
				
				if cm:get_saved_value("liu_bei_fire_yuan_shao_accepts")~=false then
					YuanShaoAccepts1Listener(); -- enters regions 
                end
				if cm:get_saved_value("liubei_fire_liubiao_accepts")~=false then
					LiuBiaoAcceptsListener(); -- enters regions 
                end
                if cm:get_saved_value("liubei_bonus_movement")==true then
                    liubeiMoveDecayListener();
                end
				if cm:get_saved_value("liu_bei_fire_yuan_shao_rumors") ~=nil then
                    if cm:get_saved_value("liu_bei_fire_yuan_shao_rumors") >=0 then 
                        YuanShaoRumorsDelayListener1()
                    else 
                        CusLog("liu_bei_fire_yuan_shao_rumors="..tostring(cm:get_saved_value("liu_bei_fire_yuan_shao_rumors")))
                    end
                end
            end
            ZhaoYunJoinsListener() --AI and player 
            liubeiFleesListener() -- cant flee past 210? (Ai/player)
			
			--CusLog("TMP")
           -- cm:set_saved_value("turnsNo_till_liuBei_can_flee", 999);
            
            --TMP FIX 
          --  ChecklandsLiuBiao()
           -- AbandonLands("3k_main_faction_liu_bei")
           -- LiuBiaoGivesLands() -- move him to the general region and let the vanilla confederation script do rest
            CusLog("TMP liubei_saved")
            cm:set_saved_value("liubei_saved",true)
      
		end 
	end
)

