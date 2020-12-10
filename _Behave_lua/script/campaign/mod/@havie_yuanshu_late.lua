--Yuan Shu Late , Responsible for:

---Should Kill AI Yuan Shu  in 199 and before doing so, delete the seal so CaoCao can get it.

local printStatements=false;



local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_yuanshu_late.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
        local header=" (yuanshu_late): "
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
    local file = io.open("@havie_yuanshu_late.txt", "w+")
    file:close()
	CusLog("---Begin File----")
end


function KillYuanShuandSeal() --Handles if factions already been destroyed, and getting the seal to cao cao 
	CusLog("Begin KillYuanShuandSeal")

	local yuanshu_faction = cm:modify_faction("3k_main_faction_yuan_shu")
	if yuanshu_faction:is_null_interface() then 
		CusLog("..!! factions is null, abort whole thing???");
	elseif yuanshu_faction:is_dead() then 
		local factionName=FindAncAccessory("3k_main_ancillary_accessory_imperial_jade_seal" , "3k_main_ceo_category_ancillary_accessory")
		if factionName ~= "none" then 
			local faction= getQFaction(factionName);
			if faction~=nil then 
				if not faction:is_human() then 
					FindAndDestroySeal()
					--Enable Incident for CaoCao:
					cm:set_saved_value("caocao_gets_seal",true)
				else 
					CusLog("seal is with player, not giving to cao cao ")
				end
			end
		else
			CusLog("Seal is Missing..Give to Cao Cao")
			--Enable Incident for CaoCao:
			cm:set_saved_value("caocao_gets_seal",true)
		end
	else 
		local factionName=FindAncAccessory("3k_main_ancillary_accessory_imperial_jade_seal" , "3k_main_ceo_category_ancillary_accessory")
		if factionName == "3k_main_faction_yuan_shu" then 
			yuanshu_faction:ceo_management():remove_ceos("3k_main_ancillary_accessory_imperial_jade_seal")
			--Enable Incident for CaoCao:
			cm:set_saved_value("caocao_gets_seal",true)
		elseif factionName == "none" then  --Seal is missing somehow 
			--Enable Incident for CaoCao:
			cm:set_saved_value("caocao_gets_seal",true)
		else
			CusLog("Warning:"..factionName.." has the seal, not yuanshu");
		end
	end
	
	local qYuanShu= getQChar2("3k_main_template_historical_yuan_shu_hero_earth")
	if not qYuanShu~=nil then 
		CusLog("killing qYuanShu");
		cm:modify_character(qYuanShu):kill_character(true)
		cm:trigger_incident(getPlayerFaction(), "3k_lua_yuan_shu_dies_incident", true) --TODO  (listened for in CAOEMPEOR)
	else
		CusLog("..qYuanShu null 1")
	end


	CusLog("End KillYuanShuandSeal")
	
end 



function YuanShuAfterMath()
	CusLog("Begin YuanShuAfterMath")
	local qFaction1=cm:query_faction("3k_dlc04_faction_prince_liu_chong")
	local qFaction2=cm:query_faction("3k_main_faction_cao_cao")
	local qFaction3=cm:query_faction("3k_main_faction_cao_cao")

	local qChar= getQChar("3k_main_template_historical_liu_chong_hero_earth")
	if not qChar:is_null_interface() then 
		if qChar:is_faction_leader() then 
			ChangeRelations("3k_main_template_historical_liu_chong_hero_earth", "3k_main_template_historical_yuan_shu_hero_earth", "3k_main_relationship_trigger_set_event_negative_generic_extreme") 
		end	

	end
	--Cant do much here because they are all tied into other responses,
	--lets just make liu chong war him? hate him?



	CusLog("End YuanShuAfterMath")
end


-------------------------------------------------------------------------
-------------------------------------------------------------------------

---------------------------LISTENERS-------------------------------------

-------------------------------------------------------------------------
-------------------------------------------------------------------------
--if yuan_shu_faction:query_faction():pooled_resources():resource("3k_main_pooled_resource_legitimacy"):value() >= 349 then
--cm:modify_model():get_modify_pooled_resource(query_resource_heroism):apply_transaction_to_factor("3k_main_pooled_factor_heroism_from_military_feats", heroism);

function YuanShuHoldsEmperorListener() --will work for AI as well if they use resources?
    CusLog("### YuanShuHoldsEmperorListener loading ###")
    core:remove_listener("YuanShuHoldsEmperor")
	core:add_listener(
		"YuanShuHoldsEmperor",
		"FactionTurnStart",
		function(context)
			if context:faction():name()== "3k_main_faction_yuan_shu" then 
				--CusLog("Does Yuan Shu have Emperor?:")
				--CusLog("YuanShuOwnEmperor= "..tostring(cm:is_world_power_token_owned_by("emperor", "3k_main_faction_yuan_shu")))
				return cm:is_world_power_token_owned_by("emperor", "3k_main_faction_yuan_shu"); 
			end
            return false;
		end,
		function(context)
			CusLog("??? Callback: YuanShuHoldsEmperorListener ###")
			local query_resource_legitimacy=context:faction():pooled_resources():resource("3k_main_pooled_resource_legitimacy")
			CusLog("YuanShu has legitamcy :"..tostring(query_resource_legitimacy:value()))
			cm:modify_model():get_modify_pooled_resource(query_resource_legitimacy):apply_transaction_to_factor("3k_main_pooled_factor_legitimacy_propaganda", 5);

			CusLog("### Passed YuanShuHoldsEmperorListener ###")
		end,
		true
	)
end


function YuanShuFactionDeadListener() --Catches if yuan shus faction dies 
	CusLog("### YuanShuFactionDeadListener listener loading ###")
	core:add_listener(
		"YuanShuDead",
		"FactionDied",
		function(context)
			if context:faction():name()== "3k_main_faction_yuan_shu" and context:query_model():date_in_range(195,205) then
		    		return true
				end
		return false;
		end,
		function(context)
			CusLog("???Callback: YuanShuFactionDeadListener ###")
			--LiuBeiDoesntGiveTroops() --declare war on liu bei for not returning troops
			KillYuanShuandSeal() -- if yuan shus not dead, If he had the seal, caocao will get. 
		end,
		false
    )
end

function YuanShuDiesListener() --Might want a few more conditions on the matter, like he is losing?
    CusLog("### YuanShuDiesListener loading ###")
    core:remove_listener("YuanShuDies")
	core:add_listener(
		"YuanShuDies",
		"FactionTurnStart",
		function(context)
            if context:query_model():calendar_year() >= 199 and context:faction():name() == "3k_main_faction_yuan_shu" and cm:get_saved_value("YuanShuEmperor")==true then 
              return context:faction():is_human()==false; 
            end
            return false;
		end,
		function(context)
			CusLog("### Passed YuanShuDiesListener ###")
			KillYuanShuandSeal()
			--cm:set_saved_value("Admin_set",true)
			core:remove_listener("YuanShuAdmin");
		end,
		true
    )
end


function YuanShuChoiceAssassinListener()
	CusLog("### YuanShuChoiceAssassinListener loading ###")
	core:remove_listener("YuanShuChoiceAssassin")
	core:add_listener(
		"YuanShuChoiceAssassin",
		"DilemmaChoiceMadeEvent",
		function(context)
			 return context:dilemma() == "3k_lua_yuan_kills_chong_dilemma"
		end,
		function(context)
			CusLog("..! 3k_lua_yuan_kills_chong_dilemma choice was:" .. tostring(context:choice()))
			if context:choice() == 0 then
				local playersFactionsTable = cm:get_human_factions()
    			local playerFaction = playersFactionsTable[1]
				local triggered=cm:trigger_incident(playerFaction, "3k_lua_yuan_kills_chong_incident", true )
				CusLog("event triggered="..tostring(triggered))
			end
			CusLog("### Finished YuanShuChoiceAssassinListener ###")
		end,
		false
    )
end


function YuanShuKillsLiuChongListener() --Probably if LiuBei is In Xu again , just kill him
    CusLog("### YuanShuKillsLiuChongListener loading ###")
    core:remove_listener("YuanShuKillsLiuChong")
	core:add_listener(
		"YuanShuKillsLiuChong",
		"FactionTurnStart",
		function(context)
            if context:query_model():calendar_year() >= 197 and context:faction():name() == "3k_main_faction_yuan_shu" then 
			  if cm:get_saved_value("YuanShuEmperor") and cm:get_saved_value("liuchong_dead")~=true then 
				local qChar= getQChar("3k_main_template_historical_liu_chong_hero_earth")
				if not qChar:is_null_interface() then 
					return qChar:is_faction_leader()
				end
			  end
            end
            return false;
		end,
		function(context)
			CusLog("??? Callback: YuanShuKillsLiuChongListener ###")
			local triggered=false;
			if context:faction():is_human() then 
				CusLog("--Trigger Dilemma--")
				YuanShuChoiceAssassinListener()
				triggered=cm:trigger_dilemma("3k_main_faction_yuan_shu","3k_lua_yuan_kills_chong_dilemma", true)
			else
				CusLog("--Trigger incident--")
				local playersFactionsTable = cm:get_human_factions()
    			local playerFaction = playersFactionsTable[1]
				triggered=cm:trigger_incident(playerFaction, "3k_lua_yuan_kills_chong_incident", true )
			end
			--cm:set_saved_value("lichongDead",triggered)
			CusLog("Event success="..tostring(triggered))
			if triggered then 
				cm:set_saved_value("liuchong_dead",true)
				core:remove_listener("YuanShuKillsLiuChong")
			end
			CusLog("### Passed YuanShuKillsLiuChongListener ###")
		end,
		true
	)
end


function YuanShuWarsListener() --not sure what i want to do here 
    CusLog("### YuanShuKillsLiuChongListener loading ###")
    core:remove_listener("YuanShuKillsLiuChong")
	core:add_listener(
		"YuanShuKillsLiuChong",
		"FactionTurnStart",
		function(context)
            if context:query_model():calendar_year() >= 197 and cm:get_saved_value("YuanShuEmperor") and context:faction():name()~="3k_main_faction_yuan_shu" then 
					return true; -- check if major faction, RNG to declare war?
            end
            return false;
		end,
		function(context)
			CusLog("??? Callback: YuanShuWarsListener ###")
			local triggered=false;
			if not context:faction():is_human() then 
			end
			CusLog("### Passed YuanShuWarsListener ###")
		end,
		false
	)
end

function YuanShuDeclaresHimselfDILListener()
	CusLog("### YuanShuDeclaresHimselfDILListener loading ###")
	core:remove_listener("YuanShuDeclaresHimselfDIL")
	core:add_listener(
		"YuanShuDeclaresHimselfDIL",
		"DilemmaChoiceMadeEvent",
		function(context)
			 return context:dilemma() == "3k_lua_yuan_shu_yuan_shu_emperor_override_dilemma"
		end,
		function(context)
			CusLog("..! 3k_lua_yuan_shu_yuan_shu_emperor_override_dilemma choice was:" .. tostring(context:choice()))
			if context:choice() == 0 then
				cm:set_saved_value("YuanShuEmperor", true);
			end
			CusLog("### Finished YuanShuDeclaresHimselfDILListener ###")
		end,
		false
    )
end


function YuanShuDeclaresHimselfINCListener()
	CusLog("### YuanShuDeclaresHimselfINCListener loading ###")
	core:remove_listener("YuanShuDeclaresHimselfINC")
	core:add_listener(
		"YuanShuDeclaresHimselfINC",
		"IncidentOccuredEvent",
		function(context)
			 return context:incident() == "3k_lua_yuan_shu_emperor_incident_override"
		end,
		function(context)
			CusLog("??? Callback: YuanShuDeclaresHimselfINCListener ###")
			cm:set_saved_value("YuanShuEmperor", true);
			YuanShuAfterMath()
			CusLog("### Finished YuanShuDeclaresHimselfINCListener ###")
		end,
		false
    )
end

function YuanShuDeclaresListener() --bases this off of the year, and the seal, and less about Resource
	CusLog("### YuanShuDeclaresListener  loading ###")
	core:remove_listener("YuanShuDeclares");
	core:add_listener(
		"YuanShuDeclares",
		"FactionTurnStart",
		function(context)
			if( context:faction():name() == "3k_main_faction_yuan_shu") and cm:get_saved_value("YuanShuEmperorFIRE")~=true and cm:get_saved_value("Yuanshu_TookSeal")==true then  
				CusLog("..Checking the year for yuan shu to declare himself emperor")
				if( context:query_model():calendar_year() >= 197 ) then
					return RNGHelper(6); -- no requirement on LiuBei war/peace, just that the player is prompted to press the attack
				end
            end
            return false
        end,
		function(context)
			CusLog("??? Callback YuanShuDeclaresListener ###")
			local triggered=false;
			if context:faction():is_human() then 
				triggered=cm:trigger_dilemma("3k_main_faction_yuan_shu" , "3k_lua_yuan_shu_yuan_shu_emperor_override_dilemma", true)
			else
				local playersFactionsTable = cm:get_human_factions()
				local playerFaction = playersFactionsTable[1]
				triggered=cm:trigger_incident(playerFaction,"3k_lua_yuan_shu_emperor_incident_override", true ) 
			end
			cm:set_saved_value("YuanShuEmperorFIRE", triggered);
			CusLog("### passed YuanShuDeclaresListener ="..tostring(triggered))
		end,
		false
    )
end

	
local function YuanShuLateVariables()
	CusLog("Debug: YuanShuLateVariables:")
	
	CusLog(" YuanShuLate YuanShuEmperorFIRE= "..tostring(cm:get_saved_value("YuanShuEmperorFIRE"))) -- to fire the event
	CusLog(" YuanShuLate YuanShuEmperor= "..tostring(cm:get_saved_value("YuanShuEmperor")))
	CusLog(" YuanShuLate liuchong_dead= "..tostring(cm:get_saved_value("liuchong_dead")))
	CusLog(" YuanShuLate caocao_gets_seal= "..tostring(cm:get_saved_value("caocao_gets_seal"))) 




 end



-- when the game loads run these functions:
cm:add_first_tick_callback(
    function(context)
        IniDebugger()
		YuanShuLateVariables()

		
		if context:query_model():date_in_range(195,205) then 

			if( cm:get_saved_value("yuan_shu_is_human")) then 
				if 	cm:get_saved_value("YuanShuEmperor") ~=true then 
					YuanShuDeclaresHimselfDILListener()
				end
			else
				YuanShuDeclaresHimselfINCListener()
				YuanShuFactionDeadListener()
				YuanShuDiesListener()

			end
			--both

			if 	cm:get_saved_value("YuanShuEmperor") ~=true then 
				YuanShuDeclaresListener()
			end
			if cm:get_saved_value("liuchong_dead")~=true then 
				YuanShuKillsLiuChongListener()
			end
		end

		YuanShuHoldsEmperorListener() --AI aswell
		--CusLog("TMP dilemma")
		--local triggered=cm:trigger_dilemma("3k_main_faction_yuan_shu" , "3k_lua_yuan_shu_yuan_shu_emperor_override_dilemma", true)
		--local triggered=cm:trigger_dilemma("3k_main_faction_yuan_shu","3k_lua_yuan_shu_hires_yang_feng_dilemma", true)
		--CusLog("Triggered="..tostring(triggered))
		--tmp 
		--cm:set_saved_value("liuchong_dead",true);
    end
)

