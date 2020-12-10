-- Yuan Shao Early

-- makes sure yuan shao confeds han fu  (190-191) (ToDo player check should be 3 region requirement vanilla)
-- makes sure AI Yuan Shao wars Gonsunzan (194-197)
-- makes sure AI Yuan Shao confeds Gongsunzan (198-199) 
-- makes sure Yuan Shao wars KongRong and spawns yuan tan (196-199) (ToDo Player dilemma)

-- *Ability to advance AI LuBus Demise and or start dongCheng Plot 

--ToDo test Yuan Bandit problem 
--ToDo Test Player YuanShao takes in AI LuBu -test / make dilemmas 
--ToDo Test turn 1 AI yuan Shao coalition AI CaoCao
--TODO 3k_lua_yuanshao_sends_zhouxin -dilemma 


local printStatements=false;

--  In region:3k_main_pingyuan_resource_1  at L POS:558 , 558

local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_yuanshao.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
		local header=" (yuanshao): "
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
	local file = io.open("@havie_yuanshao.txt", "w+")
	file:close()
	CusLog("---Begin File----")
end

local function TriggerGonsunConfed() --ability to progress lubus demise and start dong chengs plot line 
	CusLog("Begin TriggerGonsunConfed")
	local playersFactionsTable = cm:get_human_factions()
	local playerFaction = playersFactionsTable[1]
	local triggered=false;
    if cm:get_saved_value("yuan_shao_is_human")==false then 
		--Trigger Incident
	
		triggered=cm:trigger_incident(playerFaction, "3k_lua_yuanshao_confed_gonsunzan", true ); 
		-- Incident kills gonsunzan, he commits suicide 
		-- cm:force_confederation("3k_main_faction_yuan_shao","3k_main_faction_gongsun_zan") -- Cant Force this thru the incident, only player can? 
		cm:set_saved_value("zhaoyun_free",true); -- If player liubei, wait till liu bei is vassal of yuan shao, or is northern regions, if AI liu bei just send there 
	else
		triggered=true; --TMP 
		--Just let the player do his thing, COULD make an event later about intercepting the message to zhang yan
	end
	if(not triggered) then
		CusLog("@@!!..something went wrong with the event in YuanShaoConfederatesGonsunListener and listener does not persist ")
	end
	
	cm:set_saved_value("gonsun_confed", true)

	if cm:get_saved_value("dongcheng_started") ~= true then --Cant start if LuBu is still around 
		CusLog("Dong cheng hasnt started.. trying to skip ahead")
		local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
		if qlubu:is_null_interface() then 
			StartDongChengPlot()
		elseif qlubu:is_dead() then 
			StartDongChengPlot()
		elseif not qlubu:is_faction_leader() then 
			StartDongChengPlot()
		elseif cm:set_saved_value("chen_betrays")~=true then --Try to speed up lubus demise
			if not qlubu:faction():is_human() then --were ahead of the story line so lets go 
				CusLog("Skipping ahead in storyline for AI LuBu")
				triggered= cm:trigger_incident(playerFaction,"3k_lua_chens_betray", true ) --listener for this in Xu lubu post 
				CusLog("triggered for betrayal="..tostring(triggered))
			end
		end			
	end 
	
	CusLog("End TriggerGonsunConfed")
end
local function YuanShaoSendsYuanTan() -- return true if succeeds
		CusLog("Begin YuanShaoSendsYuanTan")

	local found=false;
	local region_name= ""
	-- Try to spawn army with yuan tan as emergent faction in one of kong rongs regions
	local q_kongrong_faction = cm:query_faction("3k_main_faction_kong_rong") -- we do not do a human check here, intentional 
	if q_kongrong_faction:is_human() == false then 
		--apply some debuffs so AI yuan shao goes hard in the paint 
		CusLog(" Debuff Kongrong")
		cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua_lite", "3k_main_faction_kong_rong" , 8)
	end
	local q_yuanshao_faction = cm:query_faction("3k_main_faction_yuan_shao") 
	
	if q_yuanshao_faction:is_human() == false then 
		cm:modify_faction(q_yuanshao_faction:name()):increase_treasury(1800)
		--Register YuanTan
		CusLog(" register yuanTan")
		register_YuanTan_emergent_faction_2()
		cm:set_saved_value("SpawnYuanTan", true)
		cm:force_declare_war("3k_main_faction_yuan_shao", "3k_main_faction_kong_rong", true);
		--No need for an incident 
	else
		--Trigger Dilemma ToDo
		return cm:trigger_dilemma("3k_main_faction_yuan_shao", "3k_lua_???" , true) --TODO
	end

	cm:set_saved_value("yuan_shao_wars_kongrong",true)
	CusLog("Finish YuanShaoSendsYuanTan")
	return true;

end

local function YuanShaoAcceptLuBu() 
	CusLog("### Running YuanShaoAcceptLuBu ###")
	local lubu=getQChar("3k_main_template_historical_lu_bu_hero_fire")
    CusLog("Lu bu is faction leader = "..tostring(lubu:is_faction_leader()))

    if lubu:faction():name()~="3k_main_faction_dong_zhuo" then 
        MoveCharToFactionHard("3k_main_template_historical_lu_bu_hero_fire", "3k_main_faction_dong_zhuo")
    end

    if not lubu:is_faction_leader() then 
        --Kill Wang Yun if hes alive
        KillWangYun()
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
	
	
	local regionName=cm:get_saved_value("yuanshao_gives_lubu")
	CusLog("giving region:"..tostring(regionName))
	local qregion=cm:query_region(regionName);
	if not qregion:is_null_interface() then 
		if qregion:owning_faction():name() == "3k_main_faction_yuan_shao" then 
			local qlubu=lubu; -- lazy dont wana refactor 
			if qlubu:is_faction_leader() then 
				AbandonLands(qlubu:faction():name()) -- 99% sure this is always dong zhuo lol 
				cm:modify_model():get_modify_region(qregion):settlement_gifted_as_if_by_payload(cm:modify_faction(qlubu:faction():name()))
				TeleportAllArmies(qlubu:faction():name(), regionName)
				--Vassalize here? or via event? -- event should declare war on zhang yang
				VassalizeSomeone("3k_main_faction_yuan_shao", qlubu:faction():name())
				cm:apply_effect_bundle("3k_dlc05_effect_bundle_granted_sanctuary", "3k_main_faction_dong_zhuo" , 2)
				--cm:trigger_incident("3k_main_faction_yuan_shao","3k_lua_yuan_shao_accepts_lu_bu", true ) --this is lu bus version? dunno if wording will work,could clone
				cm:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo","3k_main_faction_zhang_yan", "data_defined_situation_war_proposer_to_recipient",true)
				cm:apply_automatic_deal_between_factions("3k_main_faction_zhang_yan","3k_main_faction_dong_zhuo", "data_defined_situation_war_proposer_to_recipient",true)
  
			else
				CusLog("lubu isnt faction leader?? spawn emergent ?")
			end
		end 
	end 
	
	CusLog("### Finished YuanShaoAcceptLuBu ###")
end

local function CheckYuanShaoHasLand()
	CusLog("### Running CheckYuanShaoHasLand ###")
	
	local regionName="3k_main_ye_resource_1"
	--Loop through his lands and determine the best one to give
	local qfaction = cm:query_faction("3k_main_faction_yuan_shao")
	local regionList = { };
	if qfaction:region_list() then
	 CusLog(qfaction:name().." Provinces Owned="..qfaction:faction_province_list():num_items())
	 for i = 0, qfaction:faction_province_list():num_items() - 1 do -- Go through each Province
		 local province_key = qfaction:faction_province_list():item_at(i);
		 for i = 0, province_key:region_list():num_items() - 1 do -- Go through each region in that province
			 CusLog("..looping: x" ..tostring(i))
			 local region_key = province_key:region_list():item_at(i);
			 if(not region_key:is_null_interface()) then 
				 local region_name = region_key:name()
				 table.insert(regionList, region_name)
			 end
		 end	
	 end
 end
	
	 if(#regionList >2) then -- wont give away land if hes low 
		for i=1, #regionList do
			if regionList[i] =="3k_main_ye_resource_1" or regionList[i] =="3k_main_anping_resource_1" then
				cm:set_saved_value("yuanshao_gives_lubu", regionList[i])
				CusLog("found region: "..regionList[i])
				return true;
			else
				regionName =regionList[i];
			end
		end
	else
		CusLog("..Yuan Shao Doesnt have enough regions to give, aborting")
		return false;
	end
	CusLog("..Going to give LuBu:"..tostring(regionName))
	cm:set_saved_value("yuanshao_gives_lubu", regionName) -- guess this will be a random region if he doesnt own desired region
	CusLog("### Finished CheckYuanShaoHasLand ### =true")
	return true;

end

local function YuanBanditsProblem()
	CusLog("Begin YuanBanditsProblem ")
	local qfaction = cm:query_faction("3k_main_faction_yuan_shao")
	 local regionList = { };
 	if qfaction:region_list() then
		CusLog(qfaction:name().." Provinces Owned="..qfaction:faction_province_list():num_items())
	 	for i = 0, qfaction:faction_province_list():num_items() - 1 do -- Go through each Province
		 	local province_key = qfaction:faction_province_list():item_at(i);
		 	--CusLog("$looking at Province #:"..tostring(i).."  ="..tostring(province_key))
		 	for i = 0, province_key:region_list():num_items() - 1 do -- Go through each region in that province
				CusLog("$$looping: x" ..tostring(i))
				 local region_key = province_key:region_list():item_at(i);
				 if(not region_key:is_null_interface()) then 
					 local region_name = region_key:name()
					CusLog("$$Adding@: " .. region_name)
					 table.insert(regionList, region_name)
					 --CusLog("...YuanAdded:"..tostring(region_name))
			 	end
			 end	
		 end
 	end

 	
	 
	local rolled_value = math.floor(cm:random_number(1, #regionList-1 )) -- 0 is nil?
	CusLog("region index="..tostring(rolled_value).."  Region at index="..tostring(regionList[rolled_value]))
	local region = cm:query_region(regionList[rolled_value])
	if not region:is_null_interface() then 
		CusLog("..Yuan Bandits Select a region:"..tostring(region:name()).." Region Size:"..tostring(#regionList-1))
		local zyFact= cm:query_faction("3k_main_faction_zhang_yan")
		local found_pos, x, y = zyFact:get_valid_spawn_location_in_region(region:name(), true);
		
		SpawnBanditsYuan("3k_main_faction_zhang_yan", region:name(), "3k_main_faction_yuan_shao", x, y)
	else
		CusLog("..somethings wrong with region selection...")
	end
		
	CusLog("Finished YuanBanditsProblem")
   
end


local function FinishConfederation() --ToDo Vanilla DB lua event name 
	CusLog("Running FinishConfederation")
	local triggered=false;
     if cm:get_saved_value("yuan_shao_is_human")==false then 
			CusLog("--Trigger Incident")
			local playersFactionsTable = cm:get_human_factions()
            local playerFaction = playersFactionsTable[1]
			triggered=cm:trigger_incident(playerFaction, "3k_lua_yuanshao_confed_hanfu",true); --ToDo db
			CusLog("IDK how i am forcing the confederation here AND the incident was still firing")
			cm:force_confederation("3k_main_faction_yuan_shao","3k_main_faction_han_fu") -- Force this thru the incident instead ?
			--Add Satisfaction BUFF
			CusLog("Add satisfaction to prevent zhang he loss")
			MoveCharToFaction("3k_main_template_historical_zhang_he_hero_fire", "3k_main_faction_yuan_shao")--Just incase he didnt come, this ensures it with a loy boost
			cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", "3k_main_faction_yuan_shao" , 30)   -- satisfaction faction wide
			cm:apply_effect_bundle("3k_main_payload_satisfaction_all_characters", "3k_main_faction_yuan_shao" , 25)

		else
			--Trigger vanilla dilemma - see where that goes 
			CusLog("--Trigger Dilemma")
			triggered=cm:trigger_dilemma(cm:query_faction("3k_main_faction_yuan_shao"), "3k_main_???"); --ToDo db
	end
	if(triggered~=true) then
		CusLog("@@!!..something went wrong with the event in YuanShaoConfederatesHanFuListener and listener does not persist ")
	end
	
	
	
	CusLog("Finished FinishConfederation")
end

-------------------------------------------------------
------------------  Listeners  ------------------------
-------------------------------------------------------

local function AiGonsunZanDestroyedListener() --technically hes wandering around or at home taking care of brother
	CusLog("### AiGonsunZanDestroyedListener listener loading ###")
	core:remove_listener("AiGonsunZanDestroyed")	
	core:add_listener(
		"AiGonsunZanDestroyed",
		"FactionDied",
		function(context)
			if context:faction():name()== "3k_main_faction_gongsun_zan" and
			   context:killer_or_confederator_faction_key() == "3k_main_faction_yuan_shao"  then
					return true
				end
		return false;
		end,
		function(context)
			CusLog("???Callback: AiGonsunZanDestroyedListener ###")
			local zhaoyun= getQChar("3k_main_template_historical_zhao_yun_hero_metal")
			if not zhaoyun:is_null_interface() then 
				if not zhaoyun:is_dead() and not zhaoyun:is_faction_leader() then 
					if zhaoyun:faction():name() ~= "3k_main_faction_liu_bei" then 
						MoveCharToFaction("3k_main_template_historical_zhao_yun_hero_metal", "3k_main_faction_yuan_shao")
					elseif zhaoyun:is_character_is_faction_recruitment_pool() then --if he immediately fled to liu bei but wasnt recruited yet
						MoveCharToFaction("3k_main_template_historical_zhao_yun_hero_metal", "3k_main_faction_yuan_shao")
					end
				end
			
			end
			
		end,
		false
    )
end


local function YuanShao3ChoiceMadeListener()
	CusLog("### YuanShao3ChoiceMadeListener loading ###")
	core:remove_listener("DilemmaChoiceMadeYuanshao3")
    core:add_listener(
    "DilemmaChoiceMadeYuanshao3",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_yuanshao_takes_lubu"  
    end,
    function(context)
        CusLog("..! 3k_lua_yuanshao_takes_lubu choice was:" .. tostring(context:choice()))
        if context:choice() == 0 then
			YuanShaoAcceptLuBu()
			--Could develop this more but best to let him go
		end
		
		cm:set_saved_value("lubu_flees_to_yuanshao",false)
		register_lu_bu_emergent_faction_2()
		cm:set_saved_value("lu_bu_to_yingchuan", true)
		core:remove_listener("DilemmaChoiceMadeYuanshao3");
    end,
    true
 );
end
local function YuanShao2ChoiceMadeListener()
	CusLog("### YuanShao2ChoiceMadeListener loading ###")
	core:remove_listener("YuanShao2ChoiceMade")
    core:add_listener(
    "YuanShao2ChoiceMade",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_yuanshao_sends_zhouxin"  
    end,
    function(context)
        CusLog("..! 3k_lua_yuanshao_sends_zhouxin choice was:" .. tostring(context:choice()))
        if context:choice() == 0 then
			SetUpAdmin() -- Yuan Shu early
			--Chengyu will rebel on AI yuan shu regardless 
		end
		
    end,
    true
 );
end

function AILuBuFleesToYuanShaoListener()
	CusLog("### AILuBuFleesToYuanShaoListener loading ###")
	core:remove_listener("LuBuFleesToYuanShao")
	core:add_listener(
		"LuBuFleesToYuanShao",
		"FactionTurnStart",
		function(context)
			if cm:get_saved_value("lubu_flees_to_yuanshao")~=nil and context:faction():name()=="3k_main_faction_yuan_shao" then 
				CusLog("..checking AILuBuFleesToYuanShaoListener ")
				
                if  context:query_model():calendar_year() < 194 and context:query_model():turn_number()>=cm:get_saved_value("lubu_flees_to_yuanshao")  then 
					CusLog("..checking if lubu can appear for yuan shao")
					if RNGHelper(5) and CheckYuanShaoHasLand() then 
						return true
					end
				elseif context:query_model():calendar_year() >= 194 then -- its too late make lu bu an emergent faction
					--core:remove_listener("LuBuFleesToYuanShao")
					cm:set_saved_value("lubu_flees_to_yuanshu",999)
					register_lu_bu_emergent_faction_2()
					cm:set_saved_value("lubu_flees_to_yuanshao", 999)
					cm:set_saved_value("lu_bu_to_yingchuan", true)
				end
			end
            return false;
		end,
		function(context)
			CusLog("### Passed AILuBuFleesToYuanShaoListener ###")
            --Trigger Dilemma
			YuanShao3ChoiceMadeListener()
			cm:trigger_dilemma("3k_main_faction_yuan_shao", "3k_lua_yuanshao_takes_lubu"); --ToDo db
		end,
		true
    )
end

local  function YuanShaoConfederatesGonsunListener()  --Yijing Tower pg 486 **THIS should move liu bei back to XU to cut off YuanShu (same with dongcheng plot)
	CusLog("### YuanShaoConfederatesGonsunListener loading ###")
	core:remove_listener("YuanShaoConfederatesGonsun")
	core:add_listener(
		"YuanShaoConfederatesGonsun",
		"FactionTurnStart",
		function(context)
            if context:faction():is_human() then 
                if context:query_model():calendar_year() == 198 or context:query_model():calendar_year() == 199 then 
					CusLog("..Checking YuanShaoConfederatesGonsunListener ")
					if CheckAlive("3k_main_faction_gongsun_zan") then
						local qgongsun= getQChar("3k_main_template_historical_gongsun_zan_hero_fire")
						if qgongsun:is_dead()==false then 
							return RNGHelper(0) -- 3
						end
					else
						--core:remove_listener("YuanShaoConfederatesGonsun") --already dead and gone
					end	
				end
			end
            return false;
		end,
		function(context) 
			CusLog("### Passed YuanShaoConfederatesGonsunListener ###")
			TriggerGonsunConfed()
			--zhao yun should get picked up by the other listener 
		end,
		false --do not persist
    )
end

local function YuanShao1ChoiceMadeListener() -- kongrong war
	CusLog("### YuanShao1ChoiceMadeListener loading ###")
	core:remove_listener("DilemmaChoiceMadeYuanShao1")
    core:add_listener(
    "DilemmaChoiceMadeYuanShao1",
    "DilemmaChoiceMadeEvent",
    function(context)
        CusLog("..Listening for 3k_lua_yuanshao_wars_kongrong choice ")
        return context:dilemma() == "3k_lua_yuanshao_wars_kongrong"  -- toDo (check vanilla)
    end,
    function(context)
        CusLog("..! choice was:" .. tostring(context:choice()))
        if context:choice() == 0 then
            YuanShaoSendsYuanTan()
            --cm:set_saved_value("Yuan__??",true)

        elseif context:choice() == 1 then 
			--???
		end
		CusLog("### Passed YuanShao1ChoiceMadeListener")
    end,
    false
 );
end


local function YuanShaoWarsKongRongListener() -- todo 
	CusLog("### YuanShaoWarsKongRongListener loading ###")
	core:remove_listener("YuanShaoWarsKongRong")
	core:add_listener(
		"YuanShaoWarsKongRong",
		"FactionTurnStart",
		function(context)
            if context:faction():is_human() and cm:get_saved_value("yuan_shao_wars_kongrong") ~=true then 
			   CusLog("..Checking YuanShaoWarsKongRongListener")
				if context:query_model():calendar_year() >= 195 and context:query_model():calendar_year() <= 199 then 
					if CheckAlive("3k_main_faction_kong_rong") then 
						if RNGHelper(3) then 
							local qchar= getQChar("3k_main_template_historical_kong_rong_hero_water") 
							if not qchar:is_dead() then 
								local desired_region =cm:query_region("3k_main_taishan_capital") --make sure yuan tan doesnt fuck up the player if hes not kongrong
								if not desired_region:is_null_interface() then 
									if desired_region:owning_faction():is_human() then 
										CusLog("taishan faction is:"..tostring(desired_region():owning_faction():name()))
										return desired_region:owning_faction():name()=="3k_main_faction_kong_rong"
									else
										CusLog("taishan faction isnt human")
										return true
									end
								else
									CusLog("taishian is null")
								end
								
							end
						end
					end	--dont remove listeners
				end
			end
            return false;
		end,
		function(context)
			CusLog("### Passed YuanShaoWarsKongRongListener ###")
			local triggered=YuanShaoSendsYuanTan()
				--triggered=cm:trigger_dilemma(cm:query_faction("3k_main_faction_yuan_shao"), "3k_lua_yuanshao_wars_kongrong", true); --ToDo db
				--see if I can use the 194 event?
			if(not triggered) then
				CusLog("@@!!..something went wrong with the event in YuanShaoWarsKongRongListener and listener does not persist ")
			end

		end,
		false --do not persist
    )
end

local function YuanShaoWarsGongsunZanListener() -- todo 
	CusLog("### YuanShaoWarsGongsunZanListener loading ###")
	core:remove_listener("YuanShaoWarsGongsunZan")
	core:add_listener(
		"YuanShaoWarsGongsunZan",
		"FactionTurnStart",
		function(context)
            if context:faction():is_human()--[[ and cm:get_saved_value("yuan_shao_wars_gonsunzan") ~=true --]] then -- keep firing on reloads to ensure they stay at war 
				if context:query_model():calendar_year() >= 194 and context:query_model():calendar_year() <= 197 then 
					--CusLog("..Checking YuanShaoWarsGongsunZanListener")
					if CheckAlive("3k_main_faction_gongsun_zan") then  
						local qchar= getQChar("3k_main_template_historical_gongsun_zan_hero_fire") 
							if not qchar:is_null_interface() then 
								if qchar:is_dead()==false and qchar:is_faction_leader() then 
									if RNGHelper(3) then --3
										return true
									end
								else
									CusLog("gonsunzan is dead")
								end
							else
								CusLog("gonsunzan is null interface?")
							end
					else
						--core:remove_listener("YuanShaoWarsGongsunZan") --will crash 
					end	
				end
			end
            return false;
		end,
		function(context)
			CusLog("??? Callback YuanShaoWarsGongsunZanListener ###")

            if cm:get_saved_value("yuan_shao_is_human")==false then 
				--Force war, no incident 
				local gonsunzanFaction= cm:query_faction("3k_main_faction_gongsun_zan")
				if not cm:query_faction("3k_main_faction_yuan_shao"):has_specified_diplomatic_deal_with("treaty_components_war",gonsunzanFaction) then
					cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shao", "3k_main_faction_gongsun_zan", "data_defined_situation_proposer_declares_war_against_target", false);
				--	CusLog("...War1")
					cm:apply_automatic_deal_between_factions("3k_main_faction_gongsun_zan", "3k_main_faction_yuan_shao", "data_defined_situation_war", true);
				end 
				if not gonsunzanFaction:is_human() then 
				--	CusLog("debuff AI gonsunzan")
					cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua", "3k_main_faction_gongsun_zan" , 12)
					ChangeRelations("3k_main_template_historical_yuan_shao_hero_earth", "3k_main_template_historical_gongsun_zan_hero_fire", "3k_main_relationship_trigger_scripted_event_generic_negative_large")
				end	

			else
				--Do nothing for the player ? maybe later dilemma w requesting aid from CAO CAO (which he lies about sending)
			end
		CusLog("### Passed YuanShaoWarsGongsunZanListener ###")
		end,
		false --On campaign reload, will keep making sure AI yuan Shao stays at war :-) (redo if adding caocao event)
    )
end


local function YuanShaoConfederatesHanFuListener()  
	CusLog("### YuanShaoConfederatesHanFuListener loading ###")
	core:remove_listener("YuanShaoConfederatesHanFu")
	core:add_listener(
		"YuanShaoConfederatesHanFu",
		"FactionTurnEnd", 
		function(context)
			if context:faction():name() == "3k_main_faction_yuan_shao" then 
                if context:query_model():turn_number() >4 and context:query_model():calendar_year() < 193 then --somewhere between 190-192
					if CheckAlive("3k_main_faction_han_fu") then   
						local rolled_value = cm:random_number( 0, 6 );
						local to_beat=2;
						CusLog("Yuanshao Rolled a "..rolled_value.." needs "..to_beat.." to confederate HanFu")
							if rolled_value > to_beat then 
								CusLog("Returning true, verify callback")
								return true
							end
					else
						--core:remove_listener("YuanShaoConfederatesHanFu") --already dead and gone
					end	
				end
			end
            return false;
		end,
		function(context)
			CusLog("??? Callback: YuanShaoConfederatesHanFu  ###")
			FinishConfederation()
			CusLog("### Finished YuanShaoConfederatesHanFu Callback ###")
		end,
		false --do not persist
    )
end

local function YuanShaoSendsZhouXinListener()  
	CusLog("### YuanShaoSendsZhouXinListener loading ###")
	core:remove_listener("YuanShaoSendsZhouXin")
	core:add_listener(
		"YuanShaoSendsZhouXin",
		"FactionTurnStart", 
		function(context)
			if context:faction():name() == "3k_main_faction_yuan_shao" then 
                if context:query_model():turn_number() > 1 and context:query_model():calendar_year() < 193 then --somewhere between 190-192
					if RNGHelper(2) then 
						return true;
					end 
				end
			end
            return false;
		end,
		function(context)
			CusLog("??? Callback: YuanShaoSendsZhouXinListener  ###")
			--do listener
			YuanShao2ChoiceMadeListener();
			cm:trigger_dilemma("3k_main_faction_yuan_shao", "3k_lua_yuanshao_sends_zhouxin", true) --TODO
			CusLog("### Finished YuanShaoSendsZhouXinListener Callback ###")
		end,
		false --do not persist
    )
end

local function YuanShaoBanditsListener()
	CusLog("### YuanShaoBanditsListener loading ###")
	core:remove_listener("YuanShaoBandits")
	core:add_listener(
		"YuanShaoBandits",
		"FactionTurnStart", --well see
		function(context)
			if context:faction():name() == "3k_main_faction_yuan_shao" and context:query_model():turn_number() > 5 and context:query_model():calendar_year()>188 then 
				--CusLog("..Its Yuan Shaos turn to deal w bandit problem")
				local qZhangYanFaction=cm:query_faction("3k_main_faction_zhang_yan")
				if qZhangYanFaction:is_null_interface() then 
					return false
				elseif qZhangYanFaction:is_dead() then 
					return false;
				end
				--CusLog("..Zhang Yang is alive")
				if context:faction():is_human() then 
					return true;
				else -- The AI 
					if cm:get_saved_value("dong_zhuo_is_human") then 
						if (cm:get_saved_value("player_is_lu_bu")~=nil) then --I will have to rework when we get lijue
							if (cm:get_saved_value("Yuan_shao_will_take")) then 
								return false; -- waiting for lubu to enter lands
							else
								return true; -- weve finished the plot line for lubus inital battle
							end
						else
							return false; -- we dont know the players choice yet
						end
					else 
						return true;
					end
				end
			end
            return false;
		end,
		function(context)
			--CusLog("??? Callback: YuanShaoBanditsListener  ###")
			local rolled_value = cm:random_number( 0, 10 );
			local to_beat=4;
			if context:faction():is_human() then 
				to_beat=8;
			end
           --CusLog("..RNGing Bandits Rolled a "..tostring(rolled_value).." needs "..tostring(to_beat).."   (max was):"..tostring(10))
           	if rolled_value > to_beat then 
               -- YuanBanditsProblem() 
           	end

			--CusLog("### Finished YuanShaoBanditsListener Callback ###")
		end,
		true --persist
    )
end

local function YuanShaoCoalitionTurn1()
	CusLog("Begin turn 1 YuanShaoCoalition")
	local yuanFaction= getQFaction("3k_main_faction_yuan_shao")
	local caoFaction= getQFaction("3k_main_faction_cao_cao")
	if yuanFaction~=nil and caoFaction~=nil then 
			
		if not yuanFaction:is_human() and not caoFaction:is_human() then 
			CusLog("attempting an AI coalition") --CA removed this because it "didnt work as expected"
			cm:apply_automatic_deal_between_factions("3k_main_faction_yuan_shao", "3k_main_faction_cao_cao", "data_defined_situation_create_coalition_yuan_shao");
			CusLog(" did it work?")
		end
		
	end
end

local function YuanShaoVariables()
	CusLog("  YuanShao yuan_shao_is_human= "..tostring(cm:get_saved_value("yuan_shao_is_human")))
    CusLog(" *YuanShao player_is_lu_bu= "..tostring(cm:get_saved_value("player_is_lu_bu")))

    CusLog("  YuanShao Yuan_shao_will_take= "..tostring(cm:get_saved_value("Yuan_shao_will_take")))
    CusLog("  YuanShao yuan_shao_wars_gonsunzan= "..tostring(cm:get_saved_value("yuan_shao_wars_gonsunzan")))
	CusLog("  YuanShao yuan_shao_wars_kongrong= "..tostring(cm:get_saved_value("yuan_shao_wars_kongrong")))
    CusLog("  YuanShao lubu_flees_to_yuanshao= "..tostring(cm:get_saved_value("lubu_flees_to_yuanshao")))
    CusLog("  YuanShao gonsun_confed= "..tostring(cm:get_saved_value("gonsun_confed")))
end

local function YuanShaoIni() --if yuan shao is player initialize the script variables
	local curr_faction =cm:query_faction("3k_main_faction_yuan_shao")
	
	if curr_faction:is_human() then
		--cm:set_saved_value("yuan_shao_vanilla_1",false)
		--cm:set_saved_value("yuan_shao_vanilla_2",false)
		cm:set_saved_value("yuan_shao_wars_kongrong",false)
		cm:set_saved_value("yuan_shao_is_human",true) -- might be useful to use this check
	else
		cm:set_saved_value("yuan_shao_is_human",false)
	end

end

-- when the campaign loads run these functions:
cm:add_first_tick_callback(
	function(context)
		IniDebugger()

		YuanShaoVariables()
        if context:query_model():turn_number() ==1 then --set up this scripts initial values
			YuanShaoIni()
		end
		local year = context:query_model():calendar_year();
        if year > 189 and year < 192 then
			YuanShaoSendsZhouXinListener()
        end
		if year > 189 and year < 194 then
			YuanShaoConfederatesHanFuListener()
        end
		if year > 192 and year < 197 then
			YuanShaoWarsGongsunZanListener()
        end
		if year > 193 and year < 199 then
			YuanShaoWarsKongRongListener()
        end
		if year > 195 and year < 201 then
			YuanShaoConfederatesGonsunListener()
			AiGonsunZanDestroyedListener()
		end
		if cm:get_saved_value("yuan_shao_is_human") then 
			if year > 190 and year < 194 then 
				AILuBuFleesToYuanShaoListener()
			end
			if year > 193 and year < 200 then 
				YuanShao1ChoiceMadeListener() -- kong rong war
			end
		end

	--	YuanShaoBanditsListener()
	--CusLog("TMP reset YuanTanSpawned")
	--cm:set_saved_value("YuanTanSpawned",false)

    end
)