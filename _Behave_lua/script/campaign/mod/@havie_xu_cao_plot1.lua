-----> Xu Plot 1 (Rival Tigers)
-- Will play out if only one of cao cao , liu bei, or Lu Bu are Human 
-- does nothing if yuan shu is human, skips right to Plot2


local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_xu_cao_plot1.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
		local header=" (lubu_xu_cao_plot1): "
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
	local file = io.open("@havie_xu_cao_plot1.txt", "w+")
	file:close()
	CusLog("---Begin File----")
end


local function ZhangfeiExposesLetter()
	CusLog("Begin zhangfeiExposesLetter")
	local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
    local qlubu_faction = qlubu:faction();
    local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
	
	--Lubu hearing news of liubeis new appointment, comes to congratulate liu bei on reciept of the imperial bounty
	-- Zhang Fei draws a sword on lu bu , liu bei quickly interrupts. Zhang fei says CaoCao says LuBu is immoral and
	-- requests my brother kill you. Liu Bei pulls Lu Bu aside and shows him the letter exposing the plot .
	-- Liu bei vows not to be guilty of such an infamouse crime. Relationship deeps liubei lubu, relationship worsens CaoCao Lubu
	
	--Liu beis side: Said Guan Yu and Zhang Fei later, “Why not kill him?” Liu Bei said, “Because Cao Cao fears that Lu Bu and I may attack him, he is trying to separate us and get us to swallow each other, while he steps in and takes the advantage
	--LuBus Side: Cheng gong states CaoCao is doing this because he fears the unfied power of You and LiuBei, he means to separate us.
	
	if qlubu_faction:is_human() then 
		cm:trigger_incident(qlubu_faction:name(), "3k_lua_lubu_plot_fails", true); --same outcome on relations, just worded differently
	elseif qliubei_faction:is_human() then 
		cm:trigger_incident("3k_main_faction_liu_bei", "3k_lua_liubei_plot_fails", true);--same outcome on relations, just worded differently
	end

	cm:set_saved_value("rival_plot_exposed",true)
	
	
	CusLog("Finish zhangfeiExposesLetter")
end

local function LiuBeiRespondstoLetter()
	CusLog("Begin LiuBeiRespondstoLetter")
	local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
    local qlubu_faction = qlubu:faction();
    local q_caocao_faction = cm:query_faction("3k_main_faction_cao_cao")
    local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
	
	--caocao and liubei both cant be human from the start of this chain
	
	if q_caocao_faction:is_human() then 
		--Dilemma to fabricate letter between liu bei and lu bu 
		cm:trigger_incident("3k_main_faction_cao_cao", "3k_lua_caocao_plot_fails", true); 
		cm:set_saved_value("rival_plot_exposed",true)
	elseif qliubei_faction:is_human() then 
		--dilemma on how to respond to cao caos letter
		cm:trigger_dilemma("3k_main_faction_liu_bei", "3k_lua_liubei_rival_tigers_dilemma", true);
	else
		cm:set_saved_value("liubei_stalls",true);
	end
	
	CusLog("Finish LiuBeiRespondstoLetter")
end

local function RivalTigers() --ToDo
	CusLog("Begin RivalTigers")

	local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
    local qlubu_faction = qlubu:faction();
    local q_caocao_faction = cm:query_faction("3k_main_faction_cao_cao")
    local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
	
	--if both players are liubei and caocao this will get weird, abort it?
	if q_caocao_faction:is_human() and qliubei_faction:is_human() then 
		CusLog("..Both factions are human, abort")
		return false; -- We need to somehow get yuan shu involved though?
	end
	
	if q_caocao_faction:is_human() then 
		--Dilemma to fabricate letter between liu bei and lu bu 
		cm:trigger_dilemma("3k_main_faction_cao_cao", "3k_lua_caocao_rival_tigers_dilemma", true);
	elseif qliubei_faction:is_human() then 
		--dilemma on how to respond to cao caos letter
		cm:set_saved_value("rival_letter_sent",true);
	elseif qlubu_faction:is_human() then 
		--Skip ahead and assume Cao Cao sent the letter:
		cm:set_saved_value("liubei_stalls",true);
	end
	

	
	CusLog("Finish RivalTigers")
	return true;

end

-----------------------------------------------------------------------
-----------Separate Functions from Listeners---------------------------
-----------------------------------------------------------------------

local function LiuBeiRivalChoiceListener()
	CusLog("### LiuBeiRivalChoiceListener loading ###")
	core:remove_listener("LiuBeiRivalChoiceMade");
    core:add_listener(
    "LiuBeiRivalChoiceMade",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_liubei_rival_tigers_dilemma" -- just asks how to respond to a letter from caocao
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! choice was:" .. tostring(context:choice()))
        if choice == 0 then --Advisors recommend you stall  (increased prestige and treasury) "Such a matter will take time"
            cm:set_saved_value("liubei_stalls",true);
        end    -- choice 1 can be declare war on lu bu   (also increased prestige and treasury)
			-- Choice2 can be decline and get nothing 
    end,
    false -- does not persist
 );
end


local function CaoCaoRivalChoiceListener()
	CusLog("### CaoCaoRivalChoiceListener loading ###")
	core:remove_listener("CaoCaoRivalChoiceMade");
    core:add_listener(
    "CaoCaoRivalChoiceMade",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_caocao_rival_tigers_dilemma" -- one option deepen relation with xun yu
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! choice was:" .. tostring(context:choice()))
        if choice == 0 then
            cm:set_saved_value("rival_letter_sent",true);
        end
    end,
    false -- does not persist
 );
end


function RivalTigerExposedListener()
	CusLog("### RivalTigerExposedListener  loading ###")
	core:remove_listener("RivalTigerExposed");
	core:add_listener(
		"RivalTigerExposed",
		"FactionTurnEnd",
		function(context)
			if( context:faction():name() == "3k_main_faction_liu_bei") then  
				local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
                local qlubu_faction = qlubu:faction();
                local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
				if( qlubu:is_faction_leader() and cm:query_faction(qlubu_faction:name()):has_specified_diplomatic_deal_with("treaty_components_vassalage",qliubei_faction)) then
					return (cm:get_saved_value("liubei_stalls")==true);  --lua usually hates this 
				end
            end
            return false
        end,
		function()
			CusLog("??? Callback RivalTigerExposedListener ###")
			ZhangfeiExposesLetter()
            cm:set_saved_value("liubei_stalls", false);
		end,
		false
    )
end

function LiuBeiReceivesLetterListener()
	CusLog("### LiuBeiReceivesLetterListener  loading ###")
	core:remove_listener("LiuBeiReceivesLetter");
	core:add_listener(
		"LiuBeiReceivesLetter",
		"FactionTurnEnd",
		function(context)
			if( context:faction():name() == "3k_main_faction_liu_bei") then  
				local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
                local qlubu_faction = qlubu:faction();
                local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
				if( qlubu:is_faction_leader()) then
					return (cm:get_saved_value("rival_letter_sent")==true);  --lua usually hates this 
				end
            end
            return false
        end,
		function()
			CusLog("??? Callback LiuBeiReceivesLetterListener ###")
			LiuBeiRespondstoLetter()
            cm:set_saved_value("rival_letter_sent", false);

		end,
		false
    )
end

function RivalTigersPlotListener()
	CusLog("### RivalTigersPlotListener  loading ###")
	core:remove_listener("RivalTigersPlot");
	core:add_listener(
		"RivalTigersPlot",
		"FactionTurnEnd",
		function(context)
			if( context:faction():name() == "3k_main_faction_cao_cao") and cm:get_saved_value("rivaltigers_started")~=true then  
				local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
                local qlubu_faction = qlubu:faction();
                local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
				if( qlubu:is_faction_leader() and cm:query_faction(qlubu_faction:name()):has_specified_diplomatic_deal_with("treaty_components_vassalage",qliubei_faction) ) then
					return true
				end
            end
            return false
        end,
		function()
			CusLog("??? Callback RivalTigersPlotListener ###")
			local triggered =RivalTigers()
			cm:set_saved_value("rivaltigers_started", triggered);
			CusLog("### Finished RivalTigersPlotListener ###")
		end,
		false
    )
end



local function XuPlotVariables()
	CusLog("  XuCaoPlot rivaltigers_started= "..tostring(cm:get_saved_value("rivaltigers_started")))
    CusLog("  XuCaoPlot rival_letter_sent= "..tostring(cm:get_saved_value("rival_letter_sent")))   
	CusLog("  XuCaoPlot liubei_stalls= "..tostring(cm:get_saved_value("liubei_stalls")))
	CusLog("  XuCaoPlot rival_plot_exposed= "..tostring(cm:get_saved_value("rival_plot_exposed")))
   
end


-- when the game loads run these functions:
cm:add_first_tick_callback(
	function(context)
		IniDebugger()
		XuPlotVariables()
		if context:query_model():turn_number() ==1 then 
			cm:set_saved_value("rivaltigers_started",-1) --So we delay the 2nd plot cuz nil might eval to false, idk lua
		end
		
        if context:query_model():calendar_year() > 193 and context:query_model():calendar_year() < 201 then
			RivalTigersPlotListener()
			LiuBeiReceivesLetterListener()
			CaoCaoRivalChoiceListener()
			LiuBeiRivalChoiceListener()
			RivalTigerExposedListener()
		end
		
		--TMP
		--CusLog("TMP set rivaltigers_started to false")
		--cm:set_saved_value("rivaltigers_started",false) 
	
	end
)

