--> Cao Emperor


local startTime=os.clock() --can put in CM:val if needed ?




local function CusLog(text)
    if type(text) == "string" then
        local file = io.open("@havie_cao_emperor.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
        local header=" (cao_emperor): "
		local line= time..header..text
		file:write(line.."\n")
        file:close()
		ModLog(header..text)
    end
end

local function IniDebugger()
	printStatements=true;
	local file = io.open("@havie_cao_emperor.txt", "w+")
	CusLog("---Begin File----")
end

local function CaoCaoGetsSeal() -- IF yuan shu dies/faction is destroyed

	CusLog("Begin CaoCaoGetsSeal")
	-- Give Yuan shu the seal 
	
	if FindAncAccessory("3k_main_ancillary_accessory_imperial_jade_seal" , "3k_main_ceo_category_ancillary_accessory")=="unknown" then --Secondary safeguard,should be destroyed by now 
		CusLog("Giving CaoCao Seal")
		CaoCaoFaction:ceo_management():add_ceo("3k_main_ancillary_accessory_imperial_jade_seal")
		--trigger Incident:
		local triggered=cm:trigger_incident(getPlayerFaction(), "3k_lua_caocao_gets_seal", true) --TODO
		cm:set_saved_value("caocao_has_seal",triggered)
		if not triggered then 
			CusLog("@..!! incident failed")
		end
	end

	CusLog("End CaoCaoGetsSeal")
	
end 

function CaoCaoDilemma()
    local playersFactionsTable = cm:get_human_factions()
    local playerFaction = playersFactionsTable[1]

    cm:trigger_dilemma("3k_main_faction_cao_cao", "3k_lua_cao_cao_takes_emperor_dilemma", true)

end

function MoveyanFenghelper()
    CusLog("Begin MoveyanFenghelper")
    local faction = cm:query_faction("3k_main_faction_yuan_shu")
    local yangfeng_character = cm:query_model():character_for_template("3k_main_template_historical_yang_feng_hero_wood")
    if not yangfeng_character:is_null_interface() then
            if(not yangfeng_character:is_dead()) then
                local myangfeng_character = cm:modify_character(yangfeng_character) -- convert to a modifable character
                myangfeng_character:set_is_deployable(true)
                myangfeng_character:move_to_faction_and_make_recruited(faction:name())
                myangfeng_character:add_loyalty_effect("extraordinary_success");
                myangfeng_character:add_loyalty_effect("recently_promoted");
              
                CusLog("Moved yangfeng_character")
            else
                CusLog("dead-yangfeng_character")
            end
        else
         CusLog("cant find yangfeng_character?")
   end

   CusLog("Finished MoveyanFenghelper")
end


function MoveYangFeng()
    CusLog("---MoveYangFeng")

    local playersFactionsTable = cm:get_human_factions()
    local playerFaction = playersFactionsTable[1]
    local yangfeng = cm:query_model():character_for_template("3k_main_template_historical_yang_feng_hero_wood")
    local yuanshu_faction =  cm:query_faction("3k_main_faction_yuan_shu")
    if(yuanshu_faction:is_human() and not yangfeng:is_null_interface() ) then      -- if yuan shu is human fire a dilemma
        CusLog("---YuanShu is human, fire dilemma")
        -- is this happening on end turn? other ppls turns? can it misfire? (need testing)
        if yangfeng:is_faction_leader() then 
            FindAndAppointSomeoneRandom(yangfeng:faction():name())
        end

        local triggered=cm:trigger_dilemma("3k_main_faction_yuan_shu", "3k_lua_yuan_shu_hires_yang_feng_dilemma", true)

        if not triggered then 
            MoveCharToFaction("3k_main_template_historical_yang_feng_hero_wood", "3k_main_faction_yuan_shu")
        end

        CusLog(" 3k_lua_yuan_shu_hires_yang_feng_dilemma Triggered="..tostring(triggered))
    else
         --move yangfeng to yuan shu
        CusLog("---Yuan Shu is AI")  -- change fire_immediately to true ?
        local playersFactionsTable = cm:get_human_factions()
        local playerFaction = playersFactionsTable[1]
        local triggered =cm:trigger_incident(playerFaction,"3k_main_historical_yang_feng_joins_pc_incident_not", true )
        if not triggered then 
            CusLog("-- fire event broken to move yang feng, doing manually")
            MoveyanFenghelper()
        end
        cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", "3k_main_faction_yuan_shu" , 1)  
        cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", "3k_main_faction_yuan_shu" , 6)    
    end
	
	--Make Han Xian Show up regardless, fuck it 
	local hanxian = cm:query_model():character_for_template("3k_main_template_historical_han_xian_hero_water")
	if not hanxian:is_null_interface() then 
		SpawnCharacter("3k_main_template_historical_han_xian_hero_water", "3k_general_water",  "3k_main_faction_yuan_shu")
	elseif not hanxian:is_dead()	then 
		MoveCharToFaction("3k_main_template_historical_han_xian_hero_water", "3k_main_faction_yuan_shu")
	end
	
    CusLog("---MoveYangFeng Complete")
end


function MoveXuHuang()
    CusLog("Begin MoveXuHuang")
    local faction = cm:query_faction("3k_main_faction_cao_cao")
   -- move Xu Huang if hes not in the player faction
   local xuhuang_character = cm:query_model():character_for_template("3k_main_template_historical_xu_huang_hero_metal")
   if not xuhuang_character:is_null_interface() then
            if( xuhuang_character:is_dead() ==false  and xuhuang_character:faction():is_human()==false) then
                local mxuhuang_character = cm:modify_character(xuhuang_character) -- convert to a modifable character
                mxuhuang_character:set_is_deployable(true)
                mxuhuang_character:move_to_faction_and_make_recruited(faction:name())
                mxuhuang_character:add_loyalty_effect("recently_promoted");
                mxuhuang_character:add_loyalty_effect("extraordinary_success");
                CusLog("Moved xuhuang_character")
            else
                CusLog("dead-xuhuang_character")
            end
        else
         CusLog("cant find xuhuang_character?")
   end

   CusLog("Finish MoveXuHuang")
end

function CaoCaoTakesEmperor() 
    CusLog("Begin CaoCaoTakesEmperor")
    -- if the player owned louyang, the emperor would still be in hedong..

    -- make sure yang feng is owner of louyang otherswise.. idk 
    local yangfeng = cm:query_model():character_for_template("3k_main_template_historical_yang_feng_hero_wood")
    if yangfeng:is_null_interface()==false and yangfeng:is_faction_leader() ==true then
 
        local yangfeng_faction_name= yangfeng:faction():name();
        local cao_cao_faction =  cm:query_faction("3k_main_faction_cao_cao")

        CusLog("--moving emperor")
        campaign_emperor_manager:transfer_token_to_faction(cm:modify_faction("3k_main_faction_cao_cao"):query_faction(), yangfeng:faction(), "emperor")
       -- campaign_emperor_manager:transfer_token_to_faction(cm:modify_faction(yangfeng_faction_name):query_faction(), lijue_faction, "emperor")
         
        local louyang_region =cm:query_region("3k_main_luoyang_capital")
        local hedong_region =cm:query_region("3k_main_hedong_capital")
        if louyang_region:owning_faction():is_human()==false then
            CusLog("--Louyang not owned by player")
            cm:modify_model():get_modify_region(louyang_region):settlement_gifted_as_if_by_payload(cm:modify_faction(cao_cao_faction))
        end
     end

    CusLog("..trigger Incidient 3k_lua_cao_cao_takes_emperor")
    local playersFactionsTable = cm:get_human_factions()
    local playerFaction = playersFactionsTable[1]
    -- could fire a generic event that says Cao Cao has claimed the emperor fires for player and AI
    local triggered= cm:trigger_incident(playerFaction,"3k_lua_cao_cao_takes_emperor", true ) --Broken!? do this before the yang feng one
    CusLog("The indicident 3k_lua_cao_cao_takes_emperor fired="..tostring(triggered))

    MoveXuHuang()
    MoveYangFeng()
    --set value for yuan shao event line
    cm:set_saved_value("caocao_vs_yuanshao", true);
	cm:set_saved_value("caocao_has_emp",true)
    
    CusLog("Finished CaoCaoTakesEmperor")

end


---------------------------------------------------------------
---------------------------------------------------------------
-------------- Listeners From Functions -----------------------
---------------------------------------------------------------
---------------------------------------------------------------



function CaoGetsSeallistener()
    CusLog("### CaoGetsSeallistener listener loading ###")
    core:remove_listener("CaoGetsSeal")
	core:add_listener(
		"CaoGetsSeal",
		"IncidentOccuredEvent",
		function(context)
			 return context:incident() == "3k_lua_yuan_shu_dies_incident" 
		end,
		function(context)
			if cm:get_saved_value("caocao_gets_seal") then 
				CaoCaoGetsSeal()
			end
		end,
		false
    )
end

function CaoCaoTakesEmpListener() 
    CusLog("### CaoCaoTakesEmpListener listener loading ###")
    core:remove_listener("delayMadeCaoCaoEmpr")
    core:add_listener(
    "delayMadeCaoCaoEmpr",
    "FactionTurnEnd",
    function(context)
        if context:faction():name() == "3k_main_faction_cao_cao" then
            CusLog("..checking if Caocao should take emperor cao_will_take_emp=" ..tostring(cm:get_saved_value("cao_will_take_emp")))
            return cm:get_saved_value("cao_will_take_emp") -- sometimes callbacks hate this
        end
        return false
    end,
    function()
		CusLog("??? Callback: CaoCaoTakesEmpListener");
        CaoCaoTakesEmperor()
        cm:set_saved_value("cao_will_take_emp", false);
        core:remove_listener("delayMadeCaoCaoEmpr");
    end,
    true
);
end

function AICaoCaoTakesEmpListener() -- instead of listening for AWB event, listen if happens naturally 
    CusLog("### AICaoCaoTakesEmpListener listener loading ###")
    core:remove_listener("AICaoCaoTakesEmp")
    core:add_listener(
    "AICaoCaoTakesEmp",
    "FactionTurnEnd",
    function(context)
        if context:faction():name() == "3k_main_faction_cao_cao" then
            return cm:is_world_power_token_owned_by("emperor", "3k_main_faction_cao_cao") and cm:get_saved_value("caocao_has_emp") ~=true 
        end
        return false
    end,
    function()
		CusLog("??? Callback: AICaoCaoTakesEmpListener");
        cm:set_saved_value("caocao_vs_yuanshao", true); -- start beef script
        cm:set_saved_value("caocao_has_emp",true)
    end,
    true
);
end

function CaoCaoChoiceMadeEListener()
    CusLog("### CaoCaoChoiceMadeEListener listener loading ###")
    core:remove_listener("DilemmaChoiceMadeCaoCaoEmpr")
    core:add_listener(
    "DilemmaChoiceMadeCaoCaoEmpr",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_cao_cao_takes_emperor_dilemma"
    end,
    function(context)
        CusLog("..! 3k_lua_cao_cao_takes_emperor_dilemma choice was:" .. tostring(context:choice()))
         if context:choice() == 0 then
            cm:set_saved_value("cao_will_take_emp", true);
         end
		 cm:set_saved_value("emp_in_luoyang", false); -- turn off other listener 
    end,
    false
);
end


function EmperorDelayListener() -- AI will take right away if he owns XuChang, Player will get a dilemma that takes 1 turn .
    CusLog("### caoEmpDelay listener loading ###")
    core:remove_listener("caoEmpDelay")
	core:add_listener(
		"caoEmpDelay",
		"FactionTurnEnd",
        function(context)
             if context:faction():name()=="3k_main_faction_cao_cao" and cm:get_saved_value("emp_in_luoyang") == true and context:query_model():calendar_year() >195 then
                  if cm:get_saved_value("caocao_has_emp")~=true and RNGHelper(2) then
				    CusLog("..listening for emp_in_luoyang delay :")
                    if context:faction():is_human() then
                        cm:trigger_dilemma("3k_main_faction_cao_cao", "3k_lua_cao_cao_takes_emperor_dilemma", true)--retest
                    else    --if players lubu, can take unless cao owns yingchuan capital
                        if cm:get_saved_value("player_is_lu_bu") then
                            local qRegion=cm:query_region(XUCHANG)
                            if qRegion:owning_faction():name()=="3k_main_faction_cao_cao" then 
                                CusLog("Ai route")
                                return true;
                            else
                                CusLog("..AI CAOCAO doesnt own XuChang, cant capture")
                                return false;
                            end
                        else
                            return true;
                        end
                    end
                 end
             end
             
             return false
		end,
		function(context)
            CusLog("??? Callback: caoEmpDelay (AI) ###")
            CaoCaoTakesEmperor()
            cm:set_saved_value("emp_in_luoyang", false);
            CusLog("### Finished back: caoEmpDelay ###")
		end,
		false
    )
end



function EmperorInLuoyangListener()
    CusLog("### EmperorInLuoyangListener loading ###")
    core:remove_listener("EmperorInLuoyang")
	core:add_listener(
		"EmperorInLuoyang",
		"IncidentOccuredEvent",
		function(context)
			 return context:incident() == "3k_lua_yang_feng_takes_emperor" 
		end,
		function(context)
			CusLog("??? Callback: EmperorInLuoyangListener ###")
		    cm:set_saved_value("emp_in_luoyang", true);
		end,
		false
    )
end

local function CaoEmpVariables()
	CusLog("  CaoEmp emp_in_luoyang= "..tostring(cm:get_saved_value("emp_in_luoyang")))
    CusLog("  CaoEmp cao_will_take_emp= "..tostring(cm:get_saved_value("cao_will_take_emp")))
	CusLog("  CaoEmp caocao_has_emp= "..tostring(cm:get_saved_value("caocao_has_emp")))
    CusLog("  CaoEmp caocao_vs_yuanshao= "..tostring(cm:get_saved_value("caocao_vs_yuanshao")))
    CusLog("  CaoEmp caocao_gets_seal= "..tostring(cm:get_saved_value("caocao_gets_seal")))
	CusLog("  CaoEmp caocao_has_seal= "..tostring(cm:get_saved_value("caocao_has_seal")))
	CusLog(" *CaoEmp move_emperor_louyang (continue yangfeng)= "..tostring(cm:get_saved_value("move_emperor_louyang")))
end


-- when the game loads run these functions:
cm:add_first_tick_callback(
    function(context)
        IniDebugger()
        CaoEmpVariables()
        if context:query_model():calendar_year()>193 and context:query_model():calendar_year() < 205 then
            EmperorInLuoyangListener()
            EmperorDelayListener()
            if cm:get_saved_value("cao_cao_is_human") then 
                CaoCaoChoiceMadeEListener()
            end
			
			if cm:get_saved_value("caocao_has_seal")~=true then 
				CaoGetsSeallistener()
			end

			if cm:get_saved_value("caocao_has_emp")~=true then 
                CaoCaoTakesEmpListener()
                AICaoCaoTakesEmpListener()
			end
        end
		
		

        
       -- cm:trigger_incident("3k_main_faction_dong_zhuo","3k_lua_yang_feng_takes_emperor", true ) --Broken!?
        --RETEST yangFeng takes emperor incident fires! i dont think it will, as CaoCAos wouldnt unless i added a GND_CND_SELF/TargetFaction
    end
)
