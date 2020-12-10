-----> Xu YuanShu 
-- Begins If Lu Bu steals Xu , 190 , AWB Player or AI 
-- responsible for lubu being able to make peace and vassalize liu bei

--* If this script gets ahead for player yuan shu, it will speed up SunCe so he requests seal before we offer gifts to LuBu
--* this will not work with 190 Player Lu Bu


local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_xu_yuanshu.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
		local header=" (xu_yuanshu): "
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
	local file = io.open("@havie_xu_yuanshu.txt", "w+")
	file:close()
	CusLog("---Begin File----")
end

local function Defection()
	CusLog("Begin Defection")
	--Cant be null or dead based on how we got here
	local qlubu= getQChar2("3k_main_template_historical_lu_bu_hero_fire")
	local yuanshuFaction= getQFaction("3k_main_faction_yuan_shu")
	--One of these could be though 
	local qYangfeng= getQChar2("3k_main_template_historical_yang_feng_hero_wood")
	local qHanXian= getQChar2("3k_main_template_historical_han_xian_hero_water")
	
	local yangBool=qYangfeng~=nil ;
	local hanXianBool=qHanXian~=nil;
	--f they arent dead or null, validate the faction
	if yangBool then 
		yangBool= qYangfeng:faction():name()=="3k_main_faction_yuan_shu"
	end
	if hanXianBool then 
		hanXianBool= qHanXian:faction():name()=="3k_main_faction_yuan_shu"
	end
	local triggered=false;
	if yuanshuFaction:is_human() then 
		if yangBool then 
			CusLog("yangfeng defecting")
			 triggered= cm:trigger_incident("3k_main_faction_yuan_shu", "3k_lua_yuanshu_yangfeng_defects",true)
			if triggered then 
				MoveCharacterToFactionHard("3k_main_template_historical_yang_feng_hero_wood", qlubu:faction():name())
			end
		end
		if hanXianBool then 
			CusLog("hanXian defecting")
			 triggered= cm:trigger_incident("3k_main_faction_yuan_shu", "3k_lua_yuanshu_hanxian_defects",true)
			if triggered then 
				MoveCharacterToFactionHard("3k_main_template_historical_han_xian_hero_water", qlubu:faction():name())
			end
		end
	elseif qlubu:faction():is_human()  then 
		if yangBool and hanXianBool then 
				CusLog("Both defecting")
				triggered= cm:trigger_dilemma("3k_main_faction_yuan_shu", "3k_lua_lubu_two_defector_dilemma",true)
		elseif hanXianBool then 
				CusLog("hanXian defecting")
				triggered= cm:trigger_dilemma("3k_main_faction_yuan_shu", "3k_lua_lubu_one_defector_dilemma",true)
		elseif yangBool then 
				CusLog("YangFeng defecting")
				triggered= cm:trigger_dilemma("3k_main_faction_yuan_shu", "3k_lua_lubu_one_defector_dilemma",true)
		end
		
		if triggered then 
			cm:set_saved_value("defectors",true)
		end
	end
	CusLog("End Defection ="..tostring(triggered))
end

local function PayLubu()
	CusLog("Begin PayLubu")
	local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
    local qlubu_faction = qlubu:faction();
           
    local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
	local q_yuanshu_faction = cm:query_faction("3k_main_faction_yuan_shu")
	
	
	if qlubu_faction:is_human() then -- LiBei is destroyed
		--You get treasury +5000 and giant personal/faction modifer w yuanshu
		cm:trigger_incident(qlubu_faction:name(), "3k_lua_lubu_gets_paid_incident", true); 
		--SHOULD REGISTER LIU BEI AS AN EMERGENT FACTION IS HES NOT IN LU BUS FACTION FROM CONFEDERATION 
	elseif q_yuanshu_faction:is_human() then --ask lubu to attack liu bei and promise gifts ?
		--You get treasury -2000 and giant personal/faction modifer w lubu
		cm:trigger_incident("3k_main_faction_yuan_shu", "3k_lua_yuanshu_pays_dilemma", true);
	else -- Is this even possible? I dont think so lol 
		--increase AI lubus treasury?
		cm:modify_faction("3k_main_faction_lu_bu"):increase_treasury(2500) -- get him going 
		cm:apply_effect_bundle("3k_main_introduction_mission_payload_recruit_units","3k_main_faction_lu_bu" , 4)
		cm:apply_effect_bundle("3k_main_payload_faction_poised","3k_main_faction_lu_bu" , 4)
	end
	
	CusLog("Finished PayLubu")
end

local function GiveChenGuiPort()
	--CusLog("hope this is specific enough GiveChenGuiPort :"..tostring(XUFISHPORT))
	local qFaction= getQFaction("3k_main_faction_guangling")
	if qFaction ~=nil then 
		local desired_region= cm:query_region(XUFISHPORT)
		if not desired_region:is_null_interface() then 
			cm:modify_model():get_modify_region(desired_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_guangling"))
		else
			CusLog("the Fish port is null?"..tostring(XUFISHPORT))
		end
		local desired_region= cm:query_region("3k_main_guangling_resource_2")
		if not desired_region:is_null_interface() then 
			if desired_region:owning_faction():is_human()==false then 
				cm:modify_model():get_modify_region(desired_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_guangling"))
			end
		end
	end
	--Buff these little fuckers a bit 
	cm:apply_effect_bundle("3k_dlc05_effect_bundle_granted_sanctuary", "3k_main_faction_guangling" , 8)  
	--CusLog("End GiveChenGuiPort")
end
local function LuBuVassalizeLiuBei()
	CusLog("Begin LuBuVassalizeLiuBei")
	local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
    local qlubu_faction = qlubu:faction();
    local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")	
	
	VassalizeSomeone(qlubu_faction:name(), "3k_main_faction_liu_bei")
	
	--give land i guess dont TP armies because hes at peace now 

	local desired_region= cm:query_region(PENGCHENGFARM) -- dont give XIAOPEICITY, so LuBu more likely to be surrounded south,not north
	local desired_region2= cm:query_region(PENGCHENGTEMPLE) 
	if(desired_region:owning_faction():name() == qlubu_faction:name()) then 
		GiveChenGuiPort()
		AbandonLands("3k_main_faction_liu_bei")
		CusLog("-- Transfer PENGCHENGFARM--" )
		cm:modify_model():get_modify_region(desired_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))
		if desired_region2:owning_faction():name() == qlubu_faction:name() and RNGHelper(4) then 
			cm:modify_model():get_modify_region(desired_region2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))
		end
	elseif(desired_region2:owning_faction():name() == qlubu_faction:name()) then  
		GiveChenGuiPort()
		CusLog("-- Transfer PENGCHENGTEMPLE--" )
		AbandonLands("3k_main_faction_liu_bei")
		cm:modify_model():get_modify_region(desired_region2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"))
	end
	
	 cm:apply_effect_bundle("3k_dlc05_effect_bundle_granted_sanctuary", "3k_main_faction_liu_bei" , 3)  
	 if not qliubei_faction:is_human() then 
		cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", "3k_main_faction_liu_bei" , 25)    
	end
	
	--Liu bei should remain LuBus vassal for awhile till he can flee to yuan shao/liu biao.
	cm:set_saved_value("turnsNo_till_liuBei_can_flee", cm:query_model():turn_number() +5); -- start the ability for him to flee (liubei movement) 
	CusLog("Finish LuBuVassalizeLiuBei")
end

local function LubuWarliubei() --AI lubu  
	CusLog("Begin LubuWarliubei")

    local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
	local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
    local qlubu_faction = qlubu:faction();
	if not qlubu_faction:has_specified_diplomatic_deal_with("treaty_components_war",qliubei_faction) then 
		cm:force_declare_war(qlubu_faction:name(), qliubei_faction:name(), false);
	end

	if qliubei_faction:has_specified_diplomatic_deal_with("treaty_components_peace",qlubu_faction) then 
		cm:force_declare_war(qlubu_faction:name(), qliubei_faction:name(), false);
	end
	local success= qliubei_faction:has_specified_diplomatic_deal_with("treaty_components_war",qlubu_faction);
	--Theres always a chance diplo fails, so maybe this should trigger an incident that forces the war via db event
	-- not going to worry about it for the AI sake
	cm:set_saved_value("turnsNo_till_liuBei_can_flee", cm:query_model():turn_number() +1); -- start the ability for him to flee (liubei movement)

	CusLog("Finish LubuWarliubei= "..tostring(success))
end

local function MediatePeace() --(entry point from lubu human choice, yuan shu human choice, and AI path)
	CusLog("Begin MediatePeace")
	--CusLog(debug.traceback())
	
	local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
    local qlubu_faction = qlubu:faction();
    local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")	
	local q_yuanshu_faction = cm:query_faction("3k_main_faction_yuan_shu")

	CusLog("Try to fix any vassal issues")
	VassalizeSomeone(qlubu_faction:name(), "3k_main_faction_guangling")
	

	if not qliubei_faction:is_human() then 
		if cm:query_faction(qlubu_faction:name()):has_specified_diplomatic_deal_with("treaty_components_war",q_yuanshu_faction) then
			cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shu", qlubu_faction:name(), "data_defined_situation_proposer_declares_peace_against_target", true);
			cm:apply_automatic_deal_between_factions(qlubu_faction:name(), "3k_main_faction_yuan_shu", "data_defined_situation_proposer_declares_peace_against_target", true);
			CusLog("...peace1")
			cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shu", qlubu_faction:name(), "data_defined_situation_peace", true);
		end	
		if cm:query_faction(qliubei_faction:name()):has_specified_diplomatic_deal_with("treaty_components_war",q_yuanshu_faction) then
			cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shu", qliubei_faction:name(), "data_defined_situation_proposer_declares_peace_against_target", true);
			cm:apply_automatic_deal_between_factions(qliubei_faction:name(), "3k_main_faction_yuan_shu", "data_defined_situation_proposer_declares_peace_against_target", true);
			CusLog("...peace2")
			cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shu", qliubei_faction:name(), "data_defined_situation_peace", true);
		end	
		if cm:query_faction(q_yuanshu_faction:name()):has_specified_diplomatic_deal_with("treaty_components_war",qliubei_faction) then
			cm:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", q_yuanshu_faction:name(), "data_defined_situation_proposer_declares_peace_against_target", true);
			cm:apply_automatic_deal_between_factions(q_yuanshu_faction:name(), "3k_main_faction_liu_bei", "data_defined_situation_proposer_declares_peace_against_target", true);
			CusLog("...peace3")
			cm:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", q_yuanshu_faction:name(), "data_defined_situation_peace", true);
		end	

		LuBuVassalizeLiuBei()

	else -- Do the vassalship via the event 
		local triggered= cm:trigger_dilemma("3k_main_faction_liu_bei", "3k_lua_liubei_vassalized_lubu_dilemma", true) --TODO
		CusLog("..Dilemma triggered="..tostring(triggered))
	end

	local playersFactionsTable = cm:get_human_factions()
    local playerFaction = playersFactionsTable[1]
	cm:trigger_incident(playerFaction,"3k_lua_lubu_mediates_peace",true)
	
	CusLog("End MediatePeace")
end

local function YuanShuSendsNothing()
	CusLog("Begin YuanShuSendsNothing")

   	local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
    local qlubu_faction = qlubu:faction();
           
    local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
	local q_yuanshu_faction = cm:query_faction("3k_main_faction_yuan_shu")
	
	-- know player count is fine from start of chain

	if qlubu_faction:is_human() then -- YuanShu has not yet sent the promised gifts, you can either press the attack , or vassalize liu bei
		CusLog("@!!! TODO")
		cm:trigger_dilemma(qlubu_faction:name(), "3k_lua_lubu_no_gifts_dilemma", true); --TODO
	elseif q_yuanshu_faction:is_human() then --ask lubu to attack liu bei and promise gifts ?
		--Lubu requests gifts, but liu bei is still alive, do you send them or tell him off 
		--op1 FACTION&Personal relation deepens alot lu bu (costs a good amount)
		--op2 Personal relation worsens slightly lubu 
		cm:trigger_dilemma("3k_main_faction_yuan_shu", "3k_lua_yuanshu_no_gifts_dilemma", true);
	else
		--LuBu vassalizes LiuBei 
		MediatePeace()
	end
	
	
	CusLog("Finish YuanShuSendsNothing")
	return true;
end


local function YuanShuOffersGifts()
	CusLog("Begin YuanShuOffersGifts")


   	local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
    local qlubu_faction = qlubu:faction();
           
    local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
	local q_yuanshu_faction = cm:query_faction("3k_main_faction_yuan_shu")
	
	local playercount=0;
	--if too many players its weird 
	if qlubu_faction:is_human() then 
		playercount=playercount+1;
	end
	--if qliubei_faction:is_human() then 
		--playercount=playercount+1; -- I think its okay that this continues if LiuBei is player
	--end
	if q_yuanshu_faction:is_human() then 
		playercount=playercount+1;
	end
	
	if playercount>1 then 
		CusLog("returning false.. too many players");
		--set something else up?
		return true; -- Too many players, abort the line by stopping to listen 
	end
	
	local triggered=true;
	if qlubu_faction:is_human() then -- Yuan shu offers you gifts to continue to press the attack on Liu Bei  
		-- You can agree (no war declared up to player, but a counter on turn times)
		-- after turn time expires, no gifts were given , so you get another dilemma (this one can unlock vassalize potential)
		--You can refuse, and in turn mediate peace on the spot between the two ? (also unlocking option to vasalize)
		triggered=cm:trigger_dilemma(qlubu_faction:name(), "3k_lua_lubu_offered_gifts_dilemma", true);
	elseif q_yuanshu_faction:is_human() then --ask lubu to attack liu bei and promise gifts ?
		--Offer LuBu gifts to finish off liu bei 
		triggered=cm:trigger_dilemma("3k_main_faction_yuan_shu", "3k_lua_yuanshu_offers_gifts_dilemma", true);
	else
		--AI ? eh?
		--LubuWarliubei() -- this should probably instead let lu bu vassalize liu bei somehow?
		MediatePeace()
	end
	
	
	CusLog("Finish YuanShuOffersGifts")
	return triggered;
end

----------------------------------------------------------------

----------------------------------------------------------------
-------------------------LISTENERS------------------------------
----------------------------------------------------------------

----------------------------------------------------------------

local function LuBuAcceptsDefectorsListener() -- dilemma target wont work for 190 LuBu PLAYER so this is a single player only event
	CusLog("### LuBuAcceptsDefectorsListener loading ###")
	core:remove_listener("LuBuAcceptsDefectors");
    core:add_listener(
    "LuBuAcceptsDefectors",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_lubu_two_defector_dilemma"  or "3k_lua_lubu_one_defector_dilemma"
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! LuBuAcceptsDefectorsListener choice was:" .. tostring(context:choice()))
        if choice == 0 then 
			local qYangfeng= getQChar2("3k_main_template_historical_yang_feng_hero_wood")
			local qHanXian= getQChar2("3k_main_template_historical_han_xian_hero_water")
			local qlubu= getQChar2("3k_main_template_historical_lu_bu_hero_fire")
			if qYangfeng~=nil then 
				if qYangfeng:faction():name()=="3k_main_faction_yuan_shu" then 
					MoveCharacterToFactionHard("3k_main_template_historical_yang_feng_hero_wood", qlubu:faction():name())
				end
			end
			if qHanXian~=nil then 
				if qHanXian:faction():name()=="3k_main_faction_yuan_shu" then 
					MoveCharacterToFactionHard("3k_main_template_historical_han_xian_hero_water", qlubu:faction():name())
				end
			end
        end    
			
    end,
    true-- Is persistent (why does CA leave it on?, and remove manually)
 );
end


local function YuanShuDefectorsListener() -- written in a way that will fall through and check both chars 
	CusLog("### YuanShuDefectorsListener  loading ###")
	core:remove_listener("YuanShuDefectors");
	core:add_listener(
		"YuanShuDefectors",
		"FactionTurnEnd",
		function(context)
			if( context:faction():name() == "3k_main_faction_yuan_shu") and cm:get_saved_value("defectors")~=true then  
				local qlubu= getQChar2("3k_main_template_historical_lu_bu_hero_fire")
                local qYangfeng= getQChar2("3k_main_template_historical_yang_feng_hero_wood")
				local qHanXian= getQChar2("3k_main_template_historical_han_xian_hero_water")
				--If yuan shu has war with lubu and yang feng or han xian return true
				if qlubu~=nil  then 
				--and yuan shu declared himself emperor (ai/player)
					if qlubu:is_faction_leader() and cm:get_saved_value("YuanShuEmperor")==true then 
						if qYangfeng~=nil then 
							if qYangfeng:faction():name()=="3k_main_faction_yuan_shu" then 
								if  qlubu:faction():has_specified_diplomatic_deal_with("treaty_components_war",qYangfeng:faction()) then 
									if qYangfeng:region():owning_faction():name()==qlubu:faction():name() then 
										return true;
									end
								end
							end
						end
						if qHanXian~=nil then 
							if qHanXian:faction():name()=="3k_main_faction_yuan_shu" then 
								if  qlubu:faction():has_specified_diplomatic_deal_with("treaty_components_war",qHanXian:faction()) then 
									if qHanXian:region():owning_faction():name()==qlubu:faction():name() then 
										return true
									end
								end
							end
						end
					end
				end
            end
            return false
        end,
		function(context)
			CusLog("??? Callback YuanShuDefectorsListener ###")
			LuBuAcceptsDefectorsListener()
			Defection()
			CusLog("### Passed YuanShuDefectorsListener ###")
		end,
		false
    )
end


local function YuanShuGifts02ChoiceListener() -- dilemma target wont work for 190 LuBu PLAYER so this is a single player only event
	CusLog("### YuanShuGifts02ChoiceListener loading ###")
	core:remove_listener("YuanShuGifts02ChoiceMade");
    core:add_listener(
    "YuanShuGifts02ChoiceMade",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_yuanshu_no_gifts_dilemma" 
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! choice was:" .. tostring(context:choice()))
        if choice == 0 then --refuse gifts till liubeis destroyed 
			MediatePeace()
		else 
			-- improve relations w lu bu (send gifts)
			cm:modify_faction("3k_main_faction_lu_bu"):increase_treasury(2500) -- get him going 
			cm:apply_effect_bundle("3k_main_introduction_mission_payload_recruit_units","3k_main_faction_lu_bu" , 4)
			cm:apply_effect_bundle("3k_main_payload_faction_poised","3k_main_faction_lu_bu" , 4)
			
        end    
			
    end,
    true-- Is persistent (why does CA leave it on?, and remove manually)
 );
end

local function LubuGifts02ChoiceListener()
	CusLog("### LubuGifts02ChoiceListener loading ###")
	core:remove_listener("LubuGifts02ChoiceMade");
    core:add_listener(
    "LubuGifts02ChoiceMade",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_lubu_no_gifts_dilemma" 
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! choice was:" .. tostring(context:choice()))
        if choice == 0 then 
			--Vassalize Liu Bei and give him lands (give guangling to chendeng)
			cm:set_saved_value("lubu_wants_gifts",false)
			LuBuVassalizeLiuBei()

		else 
			--nothing ?
			cm:set_saved_value("lubu_wants_gifts",true)-- can use this to listen for if liu bei is destroyed, lubu gets paid
			cm:set_saved_value("turnsNo_till_liuBei_can_flee", cm:query_model():turn_number() +4); -- start the ability for him to flee (liubei movement) (still has to stop being lubus vassal, gives lu bu a few turns to destroy him for yuan shu payout)
	   end    
			
    end,
    true-- Is persistent (why does CA leave it on?, and remove manually)
 );
end

local function YuanShuGifts01ChoiceListener()
	CusLog("### YuanShuGifts01ChoiceListener loading ###")
	core:remove_listener("YuanShuGifts01ChoiceMade");
    core:add_listener(
    "YuanShuGifts01ChoiceMade",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_yuanshu_offers_gifts_dilemma" 
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! 3k_lua_yuanshu_offers_gifts_dilemma choice was:" .. tostring(context:choice()))
        if choice == 0 then 
           --set timer for next event
		   local rng= math.floor(cm:random_number( 2, 3 ));
		   cm:set_saved_value("turns_till_nogifts", context:query_model():turn_number()+rng)
		   CusLog("    "..tostring(rng).." more turns till no gifts")
		   LubuWarliubei()
			--enable marriage chain?
		else 
			-- disable marriage event with lubu?
			
        end    
			
    end,
    true -- Is persistent (why does CA leave it on?, and remove manually)
 );
end

local function LubuGifts01ChoiceListener()
	CusLog("### LubuGifts01ChoiceListener loading ###")
	core:remove_listener("LubuGifts01ChoiceMade");
    core:add_listener(
    "LubuGifts01ChoiceMade",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_lubu_offered_gifts_dilemma" -- choice 1 increases relations slightly , choice 2 improves relations 2 liu bei slightly, and worsen yuanshu
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! choice was:" .. tostring(context:choice()))
        if choice == 0 then 
           --set timer for next event
		   local rng= math.floor(cm:random_number( 2, 3 ));
		   cm:set_saved_value("turns_till_nogifts", context:query_model():turn_number()+rng)
		   cm:set_saved_value("lubu_wants_gifts",true) --TMP
		   --enable marriage chain?
		else -- mediate peace between liu bei and yuan shu 
		 -- unlock option to vassalize liu bei if his regions are low
		 MediatePeace()
		 -- disable marriage event with yuan shu?
        end    
			
    end,
    true-- Is persistent (why does CA leave it on?, and remove manually)
 );
end


local function GiftLiuBeidestroyedListener() 
	CusLog("### GiftLiuBeidestroyedListener  loading ###")
	core:remove_listener("GiftLiuBeidestroyed");
	core:add_listener(
		"GiftLiuBeidestroyed", -- Unique handle
		"FactionDied", -- Campaign Event to listen for
		function(context) -- Criteria
			local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
			if qlubu:faction_leader() and cm:get_saved_value("lubu_wants_gifts") then 
				local qlubu_faction = qlubu:faction();
				if context:faction():name()=="3k_main_faction_lu_bu" and
					context:killer_or_confederator_faction_key()==qlubu_faction:name() then
					local q_yuanshu_faction=cm:query_faction("3k_main_faction_yuan_shu")
					if( q_yuanshu_faction:is_human()) then 
						if q_yuanshu_faction:treasury() > 2100 then --cost 2000, but make sure he has enough above for cushion
							return true
						else
							CusLog("Player Yuan Shu is broke, adding money")
							cm:modify_faction("3k_main_faction_yuan_shu"):increase_treasury(2100-q_yuanshu_faction:treasury()) -- hes gotta last a bit 
							return true;
						end
					elseif not q_yuanshu_faction:is_dead() then 
						return true;
					end
				end
			end
			return false;
		end,
		function(context) -- What to do if listener fires.
			PayLubu()
			cm:set_saved_value("lubu_wants_gifts", false)
			core:remove_listener("GiftLiuBeidestroyed")
		end,
		true --Is persistent (why does CA leave it on?, and remove manually)
		)
end

local function GiftFollowupListener() -- if player chooses to go down the line turns_till_nogifts will be set, AI skips this
	CusLog("### GiftFollowupListener  loading ###")
	core:remove_listener("GiftFollowup");
	core:add_listener(
		"GiftFollowup",
		"FactionTurnEnd",
		function(context)
			if( context:faction():name() == "3k_main_faction_yuan_shu") and cm:get_saved_value("gifts_offered02")~=true and cm:get_saved_value("gifts_offered01")==true then  
				local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
                local qlubu_faction = qlubu:faction();
                local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
				if( qlubu:is_faction_leader() and not context:faction():is_dead() --[[and not qliubei_faction:is_dead()--]] ) then
					CusLog("Curr turn="..tostring(context:query_model():turn_number()))
					CusLog("nextevent turn="..tostring(cm:get_saved_value("turns_till_nogifts")))
					return cm:get_saved_value("turns_till_nogifts") == context:query_model():turn_number();
				elseif context:faction():is_dead() then 
					 cm:set_saved_value("gifts_offered02", true); -- end this other scripts can continue 
				end
            end
            return false
        end,
		function()
			CusLog("??? Callback GiftFollowupListener ###")
			local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
			if qliubei_faction:is_null_interface() then
				PayLubu()
				cm:set_saved_value("lubu_wants_gifts", false)
			elseif qliubei_faction:is_dead() then --This should be a fail safe for if lu bu didnt cause the death blow but contributed
				PayLubu()
				cm:set_saved_value("lubu_wants_gifts", false)
			else
				YuanShuSendsNothing()
			end
            cm:set_saved_value("gifts_offered02", true);
		end,
		false
    )
end

local function LuBuTookCityListener() -- 190 Player/AI LuBu/LiuBei
	CusLog("### LuBuTookCityListener  loading ###")
	core:remove_listener("LuBuTookCity");
	core:add_listener(
		"LuBuTookCity",
		"FactionTurnEnd",
		function(context)
			if( context:faction():name() == "3k_main_faction_yuan_shu" and cm:get_saved_value("gifts_offered01")~=true and cm:get_saved_value("lubu_stole_city")==true ) then  
				local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
                local qlubu_faction = qlubu:faction();
				local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
				CusLog("checking if yuanshu offers gifts")
				if cm:get_saved_value("seal_demanded")~=true then 
					CusLog("..Cross script call DemandSeal() to Sunce")
					DemandSeal()
					return false;
				end
				if( qlubu:is_faction_leader() and not context:faction():is_dead()  and not qliubei_faction:is_dead() ) then
					return true; -- no requirement on war/peace, just that the player is prompted to press the attack
				elseif context:faction():is_dead() then 
					cm:set_saved_value("gifts_offered01", true); -- end this so potential other scripts can continue
					cm:set_saved_value("turnsNo_till_liuBei_can_flee", context:query_model():turn_number()+1); --allow liubei to flee
				end
            end
            return false
        end,
		function()
			CusLog("??? Callback LuBuTookCityListener ###")
			local triggered=YuanShuOffersGifts()
            cm:set_saved_value("gifts_offered01", triggered);
		end,
		false
    )
end


local function AWBPlayerCityChoiceListener() --Player AWB LuBu
	CusLog("### AWBPlayerCityChoiceListener loading ###")
	core:remove_listener("AWBCityChoice");
    core:add_listener(
    "AWBCityChoice",
    "DilemmaChoiceMadeEvent",
    function(context)
        if (context:dilemma() == "3k_dlc05_historical_lu_bu_betrays_liu_bei_dilemma" or context:dilemma() == "3k_dlc05_historical_lu_bu_betrays_liu_bei_dilemma_repeated") then 
			return context:choice() == 0
		end
		return false;
    end,
    function(context)
       CusLog("??? Callback: AWBPlayerCityChoiceListener")
		cm:set_saved_value("lubu_stole_city",true)
		cm:apply_effect_bundle("3k_main_introduction_mission_payload_recruit_units","3k_main_faction_lu_bu" , 4) -- growing might?
		CusLog("### Finished AWBPlayerCityChoiceListener")
    end,
    false 
 );
end

local function AWBAICityChoiceListener() --AI AWB LuBu (and player/AI liu bei)
	CusLog("### AWBAICityChoiceListener loading ###")
	core:remove_listener("AWBAICityChoice")
	core:add_listener(
		"AWBAICityChoice",
		"IncidentOccuredEvent",
		function(context)
			 return context:incident() == "3k_dlc05_historical_liu_bei_lu_bu_chain_03_incident" or context:incident()=="3k_dlc05_historical_global_lu_bu_betrays_liu_bei"
		end,
		function(context)
			CusLog("??? Callback: AWBAICityChoiceListener ###")
			cm:set_saved_value("lubu_stole_city", true);
			CusLog("### Finished AWBAICityChoiceListener ###")
		end,
		false
    )
end


local function XuYuanShuVariables()
	CusLog("  *XuYuanshu lubu_stole_city= "..tostring(cm:get_saved_value("lubu_stole_city"))) --from xu lubu post

	CusLog("   XuYuanshu gifts_offered01= "..tostring(cm:get_saved_value("gifts_offered01")))
    CusLog("   XuYuanshu gifts_offered02= "..tostring(cm:get_saved_value("gifts_offered02"))) 
	CusLog("   XuYuanshu turns_till_nogifts= "..tostring(cm:get_saved_value("turns_till_nogifts"))) 
	

end


-- when the game loads run these functions:
cm:add_first_tick_callback(
	function(context)
		IniDebugger()
		XuYuanShuVariables()
        if context:query_model():calendar_year() > 193 and context:query_model():calendar_year() < 201 then
			AWBAICityChoiceListener()
			AWBPlayerCityChoiceListener()
			LuBuTookCityListener()
			GiftFollowupListener()
			--If lubu is human 
			LubuGifts01ChoiceListener()
			LubuGifts02ChoiceListener()
			if( cm:get_saved_value("yuan_shu_is_human")) then 
				YuanShuGifts01ChoiceListener()
				YuanShuGifts02ChoiceListener()
			end
		end
		
		if cm:get_saved_value("defectors")~=true and context:query_model():calendar_year() < 210 then --eventually you can go to war safely?
			YuanShuDefectorsListener()
		end

		--CusLog("TMP money")
		--cm:modify_faction("3k_main_faction_yuan_shu"):increase_treasury(13000)
	end
)

