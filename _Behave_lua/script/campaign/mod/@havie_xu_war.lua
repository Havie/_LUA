
--> Xu War (CaoCao) 
-- Responsible for Setting up AI Tao Qian lands,
-- Trigging Cao Songs Death,
-- Ensuring the war starts for AI and dilemmas for players if involved

local printStatements=false;



local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_xu_war.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
        local header=" (xu_war): "
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
    local file = io.open("@havie_xu_war.txt", "w+")
    file:close()
	CusLog("---Begin File----")
end

local function AIXuWar() -- only happens if player factions arent involved (verified in XuSetupListener() )
	
	 local qtaoQian= getQChar("3k_main_template_historical_tao_qian_hero_water")
	  
	cm:apply_automatic_deal_between_factions("3k_main_faction_cao_cao",qtaoQian:faction():name(), "data_defined_situation_war_proposer_to_recipient",false) --False suprress in feed?
    cm:apply_automatic_deal_between_factions("3k_main_faction_liu_bei","3k_main_faction_cao_cao", "data_defined_situation_war_proposer_to_recipient",true)
    cm:apply_automatic_deal_between_factions(qtaoQian:faction():name(),"3k_main_faction_liu_bei", "data_defined_situation_military_access",true)
	if cm:query_faction("3k_main_faction_liu_bei"):has_specified_diplomatic_deal_with("treaty_components_war",qtaoQian:faction()) then
	    cm:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", qtaoQian:faction():name(), "data_defined_situation_proposer_declares_peace_against_target", true);
        CusLog("...peace1")
        cm:apply_automatic_deal_between_factions(qtaoQian:faction():name(), "3k_main_faction_liu_bei", "data_defined_situation_peace", true);
	end
	cm:apply_automatic_deal_between_factions(qtaoQian:faction():name(),"3k_main_faction_liu_bei", "data_defined_situation_military_access",true)


end

local function XuSetup()
    CusLog("Begin XuSetup")
    local pengcheng_region =cm:query_region(XIAOPEICITY)
    local langye_region =cm:query_region("3k_main_langye_capital")
    local qtaoQian= getQChar("3k_main_template_historical_tao_qian_hero_water")

    if pengcheng_region:is_null_interface() or langye_region:is_null_interface() or qtaoQian:is_null_interface() then 
        CusLog("@@@..Somethings Null in XuSetup. returning/..early..")
        return false;
    end

    if(pengcheng_region:owning_faction():is_human() == false) then 
        cm:modify_model():get_modify_region(pengcheng_region):settlement_gifted_as_if_by_payload(cm:modify_faction(qtaoQian:faction():name()))
        CusLog("--Gave Pengcheng City to TaoQian")
    end

    if(langye_region:owning_faction():is_human() == false) then 
        cm:modify_model():get_modify_region(langye_region):settlement_gifted_as_if_by_payload(cm:modify_faction(qtaoQian:faction():name()))
        CusLog("--Gave Langye City to Tao Qian")
    end

    CusLog("Finished XuSetup")
end

local function CaoCaoStartsWarXu() -- something is wrong , doesnt compile in listener
    CusLog("Begin CaoCaoStartsWarXu (killCaoSong)")
    local playersFactionsTable = cm:get_human_factions()
    local playerFaction = playersFactionsTable[1]  -- this is a weird way to go about this..2p will get fucky

    local q_taoqian = getQChar("3k_main_template_historical_tao_qian_hero_water")
    local taoqian_faction= q_taoqian:faction()

    if(playerFaction ~= "3k_main_faction_cao_cao" and playerFaction ~= "3k_main_faction_liu_bei" and playerFaction ~= taoqian_faction:name()) then
        XuEventPeaceListener() -- make sure our other scripts listener is on (above so can call)
        cm:trigger_incident(playerFaction,"3k_main_historical_cao_father_killed_npc_incident_havie", true ) -- Make sure this makes CaoCao have personal rivalry so less chance AI makes peace
        AIXuWar()--We need to force war for AI factions 
    elseif playerFaction == "3k_main_faction_cao_cao" then  
        CusLog("--Trigger the dil for CaoCao") -- Your fathers dead and u think tao was involved, declare war?
       -- FireDilemma("3k_need_name")
    elseif playerFaction == taoqian_faction:name() then 
       CusLog("--Trigger the dil for taoQian") -- Cao song is suddenly dead and CaoCao blames you for it, request aid from liu bei? Kongrong? both?
       -- FireDilemma("3k_need_name")
    elseif playerFaction == "3k_main_faction_liu_bei" then 
        CusLog("--Trigger the dil for liubei") -- is this out of order? forget how this happens, if CaoCao declares war first or not
       -- FireDilemma("3k_need_name")
    end
    cm:set_saved_value("cao_cao_dads_dead", true);
    core:remove_listener("XuSiegeMakeWar");
    CusLog("End CaoCaoStartsWarXu")
end

-----------------------------------------------------------------------

-----------------------------------------------------------------------
------------------Separate Functions from Listeners--------------------
-----------------------------------------------------------------------

-----------------------------------------------------------------------

local function caowartaoqianListener()
	CusLog("### cao_cao_war_tao_qian listener loading ###")
	core:add_listener(
		"XuSiegeMakeWar",
		"FactionTurnEnd",
		function(context)
            	--CusLog("turn end xu:")
                    if context:faction():is_human() == true then 
                        if context:query_model():calendar_year() == 193 then
                            CusLog("Checking if CaoCao shud War=" .. tostring(context:query_model():calendar_year()))
                            -- make sure CaoSong alive
                             local qcharacter = cm:query_model():character_for_template("3k_main_template_historical_cao_song_hero_earth")
                             if not qcharacter:is_null_interface() then
                                if qcharacter:is_dead() ==false then 
                                   CusLog("These callbacks wont work..,Test this calls CaoCaoStartsWarXu()")
                                    return true
                                end
                            end
                        end
                    end 
                
                return false
            end,
            function(context)
                    CusLog("????? A Call back actually happened caowartaoqianListener")
                    CaoCaoStartsWarXu() --Investigate
					CusLog("### Passed caowartaoqianListener")
            end,
            false
        )
    end
    
local function XuSetupListener()
	CusLog("### XuSetup listener loading ###")
	core:add_listener(
		"XuSetup1",
		"FactionTurnEnd",
        function(context)
            local qtaoQian= getQChar("3k_main_template_historical_tao_qian_hero_water")
            if not qtaoQian:is_null_interface() and context:query_model():calendar_year()==191 then 
               -- CusLog("..check faction: "..tostring(context:faction():name()))
                --CusLog("..q_taoqian faction: "..tostring(qtaoQian:faction():name()))
                if qtaoQian:faction():name()==context:faction():name() then 
                    CusLog("..checking XuSetup")
			        local pengcheng_region =cm:query_region(XIAOPEICITY)
			        if not qtaoQian:faction():is_human() and not qtaoQian:is_dead() and not pengcheng_region:is_null_interface() then -- faction is human 
			        	local pengcheng_owner = pengcheng_region:owning_faction()
			    	    if pengcheng_owner:name() ~= qtaoQian:faction():name() then 
                            if(not pengcheng_owner:is_human()) then 
                                 local cond= (pengcheng_owner:is_human()==false)
                                --CusLog(" the condition to return="..tostring(cond))
                                return cond --lua doesnt like complicated returns..i swear, so i do this...
                            end
			    	    end
                    end
                end
            end
			return false
		end,
		function(context)
            CusLog("??? Trigger XuSetup Call back ###")
            XuSetup()
            CusLog("### Successful XuSetup Call back ###")
		end,
		false
    )
end

local function XuWarVariables()
	CusLog("Debug: XuWarVariables")
	CusLog("  XuWar XuSetUp= "..tostring("Warning, keeps running on purpose if land is wrong for AI, for all of 191"))
	CusLog("  XuWar cao_cao_dads_dead= "..tostring(cm:get_saved_value("cao_cao_dads_dead"))) --, Also doesnt matter much because of is_dead cond"
 
end


-- when the game loads run these functions:
cm:add_first_tick_callback(   --Start the 190 listeners at 189 otherwise wont register till a battle/reload and will be missed 
    function(context)
        IniDebugger() 
		XuWarVariables()
    if context:query_model():calendar_year() > 189 and context:query_model():calendar_year() < 193 then
       XuSetupListener()
    end
    if context:query_model():calendar_year() > 189 and context:query_model():calendar_year() < 195 then
        caowartaoqianListener()
    end
end
)


