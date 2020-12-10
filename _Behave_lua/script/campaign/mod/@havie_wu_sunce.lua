---> Wu SunCe 

-- Responsible for 190/AWB AI SunCes expansion

--Not going to do as much for 190 player SunJian, because you might as well just play 194, not much to do in 190-194.
--The behave char events should at least drive zhouyu/zhoutai etc to the 190 player faction



local liuYaoName="3k_main_template_historical_liu_yao_hero_earth" 
local liuYaoFactionName="3k_main_faction_liu_yao" 
local wangLangFactionName="3k_main_faction_wang_lang" 
local wangLangName= "3k_main_template_historical_wang_lang_hero_earth" 
local yanBaihuName= "3k_main_template_historical_yan_baihu_hero_metal" 
local yanBaihuFactionName="3k_dlc05_faction_white_tiger_yan" --Will probably crash?
local yanYuName= "3k_main_template_historical_yan_yu_hero_wood" 

local printStatements=false;


local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_wu_sunce.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec).."] ")
		local header=" (Wu_Sunce)): "
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
	local file = io.open("@havie_wu_sunce.txt", "w+")
	file:close()
	CusLog("---Begin File----")
end


function DemandSeal() --Should be an entry point into AI/Player YuanShus PlotLine
	local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire");
	local qYuanShu= getQChar("3k_main_template_historical_yuan_shu_hero_earth");
	
	if qSunCe:is_null_interface() or qYuanShu:is_null_interface() then 
		CusLog("...!! Sunce or yuanshu is null?")
		return;
	elseif qSunCe:is_dead() or qYuanShu:is_dead() then 
		CusLog("...! Sunce or yuan shu is dead")
		return;
	elseif not qSunCe:is_faction_leader() or not qYuanShu:is_faction_leader() then 
		CusLog("...! Sunce or yuan shu is not leader")
		return;
	elseif qSunCe:faction():is_human() and qYuanShu:faction():is_human() then 
		CusLog("...! both Sunce and Yuanshu are human...cant handle")
	else -- Good to go
		if qSunCe:faction():is_human() then 
			--Trigger dilemma 
			cm:trigger_dilemma(qSunCe:faction():name(), "3k_lua_sunce_demands_seal_wu", true) --TODO he should demand seal but get a rejection follow up excuse. then its up to player
		elseif qYuanShu:faction():is_human() then
			--Trigger other dilemma PG 352
			--But Yuan Shu, secretly cherishing the most ambitious designs, wrote excuses and did not return the state jewel
			--“Sun Ce borrowed an army from me and set out on an expedition which has made him master of the South Land. Now he says nothing of repayment but demands the token of his pledge. Truly he is a boor, and what steps can I take to destroy him?” 
			--You must first remove Liu Bei in revenge for having attacked you without cause, and then you may think about Sun Ce. I have a scheme to put the former into your hands in a very short time.” 
			local triggered=false;
			if qSunCe:faction():name() == "3k_main_faction_sun_jian" then 
				--CusLog("190")
				triggered=cm:trigger_dilemma(qYuanShu:faction():name(), "3k_lua_sunce_demands_seal_yshu", true)
			else
				--CusLog("AWB")
				triggered=cm:trigger_dilemma(qYuanShu:faction():name(), "3k_lua_sunce_demands_seal_yshuAWB", true)
			end
			CusLog("Trigered=="..tostring(triggered))
		else
			--War between the two ?? or do nothing till he declares himself emperor
			--Yuan Shu listens to advisors and focuses on splitting liu bei and lu bu 
			--I Feel like this should call something else in YuanShus script to start some drama with XU
		end
	end


	--Wonder if this could get weird if he was somehow in an alliance?
	if(qSunCe:faction():is_human()==false) then 
		CusLog("  -- Sun Ce is AI have him war LiuBiao/Huang Zu --  ")
		if not cm:query_faction("3k_main_faction_huang_zu"):has_specified_diplomatic_deal_with("treaty_components_war",qSunCe:faction()) then
			cm:apply_automatic_deal_between_factions(qSunCe:faction():name(), "3k_main_faction_huang_zu" , "data_defined_situation_proposer_declares_war_against_target", true);
		end
		if not cm:query_faction("3k_main_faction_liu_biao"):has_specified_diplomatic_deal_with("treaty_components_war",qSunCe:faction()) then
			cm:apply_automatic_deal_between_factions(qSunCe:faction():name(), "3k_main_faction_liu_biao" , "data_defined_situation_proposer_declares_war_against_target", true);
		end
	end
end

local function CheckSunCesLand()
	CusLog("Begin CheckSunCesLand")
	--if Sunce doesnt have the seal / yuan shu does 
	local qSunCe=getQChar("3k_main_template_historical_sun_ce_hero_fire")
	--check Sun Ce has the main capitals in the south land
	local region1= cm:query_region("3k_main_kuaiji_capital")
	local region2= cm:query_region("3k_main_jianye_capital")
	local region3= cm:query_region("3k_main_poyang_capital")
	local region4= cm:query_region("3k_main_xindu_capital")

	if region1:is_null_interface() or  region2:is_null_interface() or region3:is_null_interface() or region4:is_null_interface() then 
		CusLog("..One of the important regions are nulll... Error")
		return false;
	end

	if region1:owning_faction():name() == qSunCe:faction():name() and region2:owning_faction():name() == qSunCe:faction():name() and region3:owning_faction():name() == qSunCe:faction():name() and region4:owning_faction():name() == qSunCe:faction():name() then 
		CusLog("Finished CheckSunCesLand=true")
		return true;
	end
	

	CusLog("Finished CheckSunCesLand=false")
	return false;
end


local function KillSomeone(charTemplate) -- optinal events
	CusLog("Begin KillSomeone: "..tostring(charTemplate))
	
	local qChar = getQChar("charTemplate"); --Check
	if(not qChar:is_null_interface()) then 
		if not qChar:is_dead() then 
			cm:modify_character(qChar):kill_character(false)
			CusLog("..success!")
		end
	end
	
	if charTemplate == "someone_important" then --Could do an event for zhouxin death
		local playersFactionsTable = cm:get_human_factions()
		local playerFaction = playersFactionsTable[1]
		local triggered=cm:trigger_incident(playerFaction,"TODO_Declawing_tiger", true ) -- event might not fire next turn if SunJian dies here
	end
	

	CusLog("Finished KillSomeone")
end
local function getTaishiCi() --This is mainly for the AI  (TODO event)
	local qtaishiCi= getQChar("3k_main_template_historical_taishi_ci_hero_metal");
	local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire");
	if (qtaishiCi:is_null_interface()) then 
		return false;
	elseif qtaishiCi:is_dead() then 
		return false;
	end
	
	if(qtaishiCi:faction():name() ~= qSunCe:faction():name() ) then
		--Should do another check for if hes not in liu yaos faction??
		local moved=MoveCharToFaction("3k_main_template_historical_taishi_ci_hero_metal" , qSunCe:faction():name()) 
		if moved then 
			local playersFactionsTable = cm:get_human_factions()
			local playerFaction = playersFactionsTable[1]
			cm:trigger_incident(playerFaction,"TODO_taishi_joins_sunce", moved ) --TODO
		else
			CusLog("..Taishici didnt move")
		end
	end	
	
	if(qSunCe:faction():is_human()==false) then 
		cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", qSunCe:faction():name() , 30)   -- satisfaction faction wide
		cm:apply_effect_bundle("3k_dlc05_effect_bundle_granted_sanctuary", qSunCe:faction():name() , 1)   -- satisfaction salary and force up keep (strong!?)
		cm:apply_effect_bundle("3k_main_payload_satisfaction_all_characters", qSunCe:faction():name() , 25)
	else 
		cm:apply_effect_bundle("3k_main_payload_satisfaction_all_characters", qSunCe:faction():name() , 4)
	end
	
	
end


local function getSunCeOfficers3()
	CusLog("Begin getSunCeOfficers3")
	--ZhouTai and Jiang Qin
	
	local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire");
	local qChar1= getQChar("3k_main_template_historical_zhou_tai_hero_fire");
	local qChar2= getQChar("3k_main_template_historical_jiang_qin_hero_fire"); 
	
	if not qChar1:is_null_interface() then 
		MoveCharToFaction(qChar1:generation_template_key(),qSunCe:faction():name())
	else
		--Careful spawning 
		CusLog("Warning: Couldnt find ".."3k_main_template_historical_zhou_tai_hero_fire".." Spawning in:"..qSunCe:faction():name());
		--cdir_events_manager:spawn_character_subtype_template_in_faction(qSunCe:faction():name(), "3k_general_fire", "3k_main_template_historical_zhou_tai_hero_fire");
	end
	
	if not qChar2:is_null_interface() then 
		MoveCharToFaction(qChar2:generation_template_key(),qSunCe:faction():name())
	else
		--Careful spawning 
		CusLog("Warning: Couldnt find ".."3k_main_template_historical_jiang_qin_hero_fire".." Spawning in:"..qSunCe:faction():name());
		--cdir_events_manager:spawn_character_subtype_template_in_faction(qSunCe:faction():name(), "3k_general_fire", "3k_main_template_historical_jiang_qin_hero_fire");
	end
	if(qSunCe:faction():is_human()==false) then 
		cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", qSunCe:faction():name() , 15)   -- satisfaction faction wide
		cm:apply_effect_bundle("3k_dlc05_effect_bundle_granted_sanctuary", qSunCe:faction():name() , 1)   -- satisfaction salary and force up keep (strong!?)
		cm:apply_effect_bundle("3k_main_payload_satisfaction_all_characters", qSunCe:faction():name() , 12)
	else 
		cm:apply_effect_bundle("3k_main_payload_satisfaction_all_characters", qSunCe:faction():name() , 2)
	end
	
	CusLog("End getSunCeOfficers3")
end

local function MoveZhouTandJianQ()
	CusLog("Begin MoveZhouTandJianQ")
	local qChar1= getQChar("3k_main_template_historical_zhou_tai_hero_fire");
	local qChar2= getQChar("3k_main_template_historical_jiang_qin_hero_fire"); 
	local JQAlive= (qChar2:is_null_interface()==false)

	local region1=cm:query_region("3k_main_yangzhou_capital")
	local region2=cm:query_region("3k_main_yangzhou_resource_3")
	local region3=cm:query_region("3k_main_yangzhou_resource_2")

	if( region1:is_null_interface() or  region2:is_null_interface() or region3:is_null_interface()) then
		CusLog("..regions are nulL!!!")
		return;
	end

	if not region1:owning_faction():is_human() and region1:owning_faction():name()~="3k_main_faction_cao_cao" and region1:owning_faction():name()~="3k_main_faction_yuan_shu" and region1:owning_faction():name()~="3k_main_faction_han_empire" then 
		CusLog("Moving zhoutai to:"..region1:owning_faction():name())
		MoveCharToFaction("3k_main_template_historical_zhou_tai_hero_fire",region1:owning_faction():name());
		if JQAlive then 
			MoveCharToFaction("3k_main_template_historical_jiang_qin_hero_fire",region1:owning_faction():name());
		else
			cdir_events_manager:spawn_character_subtype_template_in_faction(region1:owning_faction():name(), "3k_general_fire", "3k_main_template_historical_jiang_qin_hero_fire");
		end
	elseif not region2:owning_faction():is_human() and region2:owning_faction():name()~="3k_main_faction_cao_cao" and region2:owning_faction():name()~="3k_main_faction_yuan_shu" and region2:owning_faction():name()~="3k_main_faction_han_empire" then 
		CusLog("Moving zhoutai to:"..region2:owning_faction():name())
		MoveCharToFaction("3k_main_template_historical_zhou_tai_hero_fire",region2:owning_faction():name());
		if JQAlive then 
			MoveCharToFaction("3k_main_template_historical_jiang_qin_hero_fire",region2:owning_faction():name());
		else
			cdir_events_manager:spawn_character_subtype_template_in_faction(region2:owning_faction():name(), "3k_general_fire", "3k_main_template_historical_jiang_qin_hero_fire");
		end
	elseif not region3:owning_faction():is_human() and region3:owning_faction():name()~="3k_main_faction_cao_cao" and region3:owning_faction():name()~="3k_main_faction_yuan_shu" and region3:owning_faction():name()~="3k_main_faction_han_empire" then 
		CusLog("Moving zhoutai to:"..region3:owning_faction():name())
		MoveCharToFaction("3k_main_template_historical_zhou_tai_hero_fire",region3:owning_faction():name());
		if JQAlive then 
			MoveCharToFaction("3k_main_template_historical_jiang_qin_hero_fire",region3:owning_faction():name());
		else
			cdir_events_manager:spawn_character_subtype_template_in_faction(region3:owning_faction():name(), "3k_general_fire", "3k_main_template_historical_jiang_qin_hero_fire");
		end
	else
		MoveCharToFaction("3k_main_template_historical_zhou_tai_hero_fire","3k_main_faction_han_empire");
		if JQAlive then 
			MoveCharToFaction("3k_main_template_historical_jiang_qin_hero_fire","3k_main_faction_han_empire");
		else
			cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_han_empire", "3k_general_fire", "3k_main_template_historical_jiang_qin_hero_fire");
		end
		
	end
	CusLog("Finished MoveZhouTandJianQ")
end

local function GetSunCeOfficers2() --add alot of loyalty , reduce salary
	CusLog("Begin getSunCeOfficers2")
	--Get both Zhang brothers 
	local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire");
	local qChar1= getQChar("3k_main_age_fixed_historical_zhang_zhao_hero_water");
	local qChar2= getQChar("3k_main_template_historical_zhang_hong_hero_water");
	
	if not qChar1:is_null_interface() then 
		MoveCharToFaction(qChar1:generation_template_key(),qSunCe:faction():name())
	else
		--Careful spawning 
		CusLog("@Warning: Couldnt find ".."3k_main_template_historical_zhang_something_hero_water".." Spawning in:"..qSunCe:faction():name());
		--cdir_events_manager:spawn_character_subtype_template_in_faction(qSunCe:faction():name(), "3k_general_water", "3k_main_template_historical_zhang_something_hero_water");
	end
	
	if not qChar2:is_null_interface() then 
		MoveCharToFaction(qChar2:generation_template_key(),qSunCe:faction():name())
	else
		--Careful spawning 
		CusLog("@Warning: Couldnt find ".."3k_main_template_historical_zhang_something_hero_water".." Spawning in:"..qSunCe:faction():name());
		--cdir_events_manager:spawn_character_subtype_template_in_faction(qSunCe:faction():name(), "3k_general_water", "3k_main_template_historical_zhang_something_hero_water");
	end
	
	CusLog("End getSunCeOfficers2")
end

local function GetSunCeOfficers1() --Add alot of loyalty , reduce salary
	CusLog("Begin GetSunCeOfficers1")
		--Move Zhu Zhi , Lu fan from YuanShu , cheng Pu , Huang Gai, Han Dang , Zhou Yu,
	local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire");
 --	local qChar1= getQChar("3k_main_template_historical_zhu_zi_hero_water"); -- Not a character i guess...
	local qChar2= getQChar("3k_main_template_historical_lu_fan_hero_water");
	local qChar3= getQChar("3k_main_template_historical_cheng_pu_hero_metal");
	local qChar4= getQChar("3k_cp01_template_historical_huang_gai_hero_fire");
	local qChar5= getQChar("3k_main_template_historical_zhou_yu_hero_water");
	local qChar6= getQChar("3k_main_template_historical_han_dang_hero_fire"); 
	--Need to be careful that other events wont spawn duplicates of these chars 
	
	CusLog("--1")
	--[[if not qChar1:is_null_interface() then 
		MoveCharToFaction(qChar1:generation_template_key(),qSunCe:faction():name())
	else
		--Careful spawning 
		CusLog("Warning: Couldnt find ".."3k_main_template_historical_zhu_zi_hero_water".." Spawning in:"..qSunCe:faction():name());
		cdir_events_manager:spawn_character_subtype_template_in_faction(qSunCe:faction():name(), "3k_general_water", "3k_main_template_historical_zhu_zi_hero_water");
	end--]]
	CusLog("--2")
	--local qyuanshu_faction= cm:query_faction("3k_main_faction_yuan_shu")
	if not qChar2:is_null_interface() then 
		-- if player is yuan shu, AI sun ce can get through a dilemma , dont move HARD 
		MoveCharToFaction(qChar2:generation_template_key(),qSunCe:faction():name())
	else
		--Careful spawning 
		CusLog("@Warning: Couldnt find ".."3k_main_template_historical_lu_fan_hero_water".." Spawning in:"..qSunCe:faction():name());
		cdir_events_manager:spawn_character_subtype_template_in_faction(qSunCe:faction():name(), "3k_general_water", "3k_main_template_historical_lu_fan_hero_water");
	end
	CusLog("--3")
	if not qChar3:is_null_interface() then 
		MoveCharToFaction(qChar3:generation_template_key(),qSunCe:faction():name())
	else
		--Careful spawning 
		CusLog("@Warning: Couldnt find ".."3k_main_template_historical_cheng_pu_hero_metal".." Spawning in:"..qSunCe:faction():name());
		cdir_events_manager:spawn_character_subtype_template_in_faction(qSunCe:faction():name(), "3k_general_metal", "3k_main_template_historical_cheng_pu_hero_metal");
	end
	CusLog("--4")
	if not qChar4:is_null_interface() then 
		MoveCharToFaction(qChar4:generation_template_key(),qSunCe:faction():name())
	else
		--Careful spawning 
		CusLog("@Warning: Couldnt find ".."3k_cp01_template_historical_huang_gai_hero_fire".." Spawning in:"..qSunCe:faction():name());
		cdir_events_manager:spawn_character_subtype_template_in_faction(qSunCe:faction():name(), "3k_general_fire", "3k_cp01_template_historical_huang_gai_hero_fire");
	end
	CusLog("--5")
	if not qChar5:is_null_interface() then 
		MoveCharToFaction(qChar5:generation_template_key(),qSunCe:faction():name())
		--Trigger an event? if Human  (Need to look into how vanilla one works)
	else
		--Careful spawning 
		CusLog("@Warning: Couldnt find ".."3k_main_template_historical_zhou_yu_hero_water".." Spawning in:"..qSunCe:faction():name());
		--cdir_events_manager:spawn_character_subtype_template_in_faction(qSunCe:faction():name(), "3k_general_water", "3k_main_template_historical_zhou_yu_hero_water");
		--Trigger an event? if human  (Need to look into how vanilla one works) Should trigger that event instead
	end

	CusLog("Trigger Zhou Yu Event")
	local playersFactionsTable = cm:get_human_factions()
    local playerFaction = playersFactionsTable[1]
	local triggered=cm:trigger_incident(playerFaction, "3k_lua_zhou_yu_sunce_friends", true );
	if not triggered then 
		CusLog(" FAILED ZHOU YU EVENT !!")
	end 
	CusLog(" @Warning Trying to make prime min, what happens if someone else is there? should remove first?")
	local mChar = cm:modify_character(qChar5) -- convert to a modifiable character
	mChar:assign_to_post("3k_main_court_offices_prime_minister"); -- no idea what happens if someone else is there?

	CusLog("--6")
	if not qChar6:is_null_interface() then 
		MoveCharToFaction(qChar6:generation_template_key(),qSunCe:faction():name())
	else
		--Careful spawning 
		CusLog("@Warning: Couldnt find ".."3k_main_template_historical_han_dang_hero_fire".." Spawning in:"..qSunCe:faction():name());
		cdir_events_manager:spawn_character_subtype_template_in_faction(qSunCe:faction():name(), "3k_general_fire", "3k_main_template_historical_han_dang_hero_fire");
	end
	
	if(qSunCe:faction():is_human()==false) then 
		cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", qSunCe:faction():name() , 30)   -- satisfaction faction wide
		cm:apply_effect_bundle("3k_dlc05_effect_bundle_granted_sanctuary", qSunCe:faction():name() , 16)   -- satisfaction salary and force up keep (strong!?)
	
	else 
		cm:apply_effect_bundle("3k_main_payload_satisfaction_all_characters", qSunCe:faction():name() , 8)
	end
	
	CusLog("End GetSunCeOfficers1")
end

--NOTE** YanBaihu shouldnt be human ... lol
local function Conquer4()  -- to Do region names - WangLang Regions (WuJun = Kuaji ?)
	CusLog("Begin Conquer4");
	local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire");
	
	-- Confederate Yan Baihu/WangLang? technically they both get away, but sunce gets the lands (ch 15 pg 350)
	CusLog("..Forcing confederation of WangLang")
	cm:force_confederation(qSunCe:faction():name(),wangLangFactionName)
	MoveCharToFactionHard(wangLangName, "3k_main_faction_han_empire") 	-- Think i should just move wang lang into the HAN empire, cuz he comes up again later w cao pi i believe. 
		
	local yanFaction= cm:query_faction(yanBaihuFactionName) --WARNING Might CRASH 
	if not yanFaction:is_null_interface() then 
		if not yanFaction:is_human() then 
			CusLog("..Forcing confederation of YanBaihu (wont work) Debuff instead")
			cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua", yanBaihuFactionName , 45)
			if RNGHelper(5) then 
				KillSomeone(yanBaihuName)	-- 50/50 chance to kill yan baihu i guess? says he flees to "Yuhang" no more mention after that, could move to liu yaos vassal faction or liu biao
			elseif RNGHelper(6) then
				MoveCharToFactionHard(yanBaihuName, "3k_main_faction_liu_biao") --If player really should trigger Dilemma 
			else
				MoveCharToFactionHard(yanBaihuName, "3k_main_faction_han_empire") 
			end
		else
			CusLog("..Well.. yan baihu is human, GOOD LUCK")
		end
	end
	--Just incase its AWB
	cm:force_confederation(qSunCe:faction():name(),yanBaihuFactionName) --looks like this wont work in 190
	
	--If SunCe doesnt get from confedertion
	local region1= cm:query_region("3k_main_kuaiji_capital") 
	local region2= cm:query_region("3k_main_kuaiji_resource_1")
	local region3= cm:query_region("3k_main_kuaiji_resource_2")
	local region4= cm:query_region("3k_main_xindu_capital")
	
	if region1:owning_faction():name() ~= qSunCe:faction():name() and not region1:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region1):settlement_gifted_as_if_by_payload(cm:modify_faction(qSunCe:faction():name()))
	end
	if region2:owning_faction():name() ~= qSunCe:faction():name() and not region2:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region2):settlement_gifted_as_if_by_payload(cm:modify_faction(qSunCe:faction():name()))
	end
	if region3:owning_faction():name() ~= qSunCe:faction():name() and not region3:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region3):settlement_gifted_as_if_by_payload(cm:modify_faction(qSunCe:faction():name()))
	end
	if region4:owning_faction():name() ~= qSunCe:faction():name() and not region4:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region4):settlement_gifted_as_if_by_payload(cm:modify_faction(qSunCe:faction():name()))
	end

	
	CusLog("..Killing ZhouXin")
	--Kill ZhouXin 
	KillSomeone("3k_main_template_historical_zhou_xin_hero_fire");
	--Clean this again 
	CleanOfficerList(qSunCe:faction():name())
	--ZhouTai receives wounds defending sun quan from bandits if i wanted to do later, its around this timemarker
	--Could set a value for a listener
	CusLog("Finished Conquer4");
end

local function Conquer3() -- to Do region names - YanBaihu Regions JianAN ?
	CusLog("Begin Conquer3");
	local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire");
	--Take some of Yan Baihus Regions and move him closer to wanglang if needed
	local region1= cm:query_region("3k_main_xindu_resource_1") 
	--local region2= cm:query_region("3k_main_jianan_resource_2") --leave the lumberyard for yanbaihu to live to fight another day w wanglang
	local region3= cm:query_region("3k_main_xindu_capital")
	
	if region11:owning_faction():name() ~= qSunCe:faction():name() and not region11:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region11):settlement_gifted_as_if_by_payload(cm:modify_faction(qSunCe:faction():name()))
	end
	--if region2:owning_faction():name() ~= qSunCe:faction():name() and not region2:owning_faction():is_human() then
		--cm:modify_model():get_modify_region(region2):settlement_gifted_as_if_by_payload(cm:modify_faction(qSunCe:faction():name()))
	--end
	if region3:owning_faction():name() ~= qSunCe:faction():name() and not region3:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region3):settlement_gifted_as_if_by_payload(cm:modify_faction(qSunCe:faction():name()))
	end
	
	--Kill YanYu
	KillSomeone(yanYuName)
	--WangLang Declare war on Sunce
	CusLog("..Wanglang declares war")
	cm:apply_automatic_deal_between_factions(wangLangFactionName,qSunCe:faction():name(), "data_defined_situation_war_proposer_to_recipient",false)
	--ZhouXin should be in wanglangs faction
	CusLog("..Moving ZhouXin to wanglang")
	MoveCharToFaction("3k_main_template_historical_zhou_xin_hero_fire", wangLangFactionName)

	
	CusLog("Finished Conquer3");
end

local function SetUpYanBaihu() --WILL CRASH , Dont use
	CusLog("Begin SetUpYanBaihu")
	CusLog("--WARNING Might CRASH, porbably cant give him regions cuz of key")
	local region4= cm:query_region("3k_main_xindu_resource_1") -- lumberyard 
	if region4:owning_faction():name() ~= yanBaihuFactionName and not region4:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region4):settlement_gifted_as_if_by_payload(cm:modify_faction(yanBaihuFactionName)) --WARNING Might CRASH
	end
	local region5= cm:query_region("3k_main_jianan_resource_2") --lumberyard2
	if region5:owning_faction():name() ~= yanBaihuFactionName and not region5:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region5):settlement_gifted_as_if_by_payload(cm:modify_faction(yanBaihuFactionName)) --WARNING Might CRASH
	end

	CusLog("Finished SetUpYanBaihu")
end
 
local function SetUpWangLang()
	CusLog("Begin SetUpWangLang")
	local region4= cm:query_region("3k_main_jianye_resource_1") --give this to wangLang (saltmine)
	if region4:owning_faction():name() ~= wangLangFactionName and not region4:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region4):settlement_gifted_as_if_by_payload(cm:modify_faction(wangLangFactionName))
	end
	local region5= cm:query_region("3k_main_kuaiji_capital") --give this to wangLang 
	if region5:owning_faction():name() ~= wangLangFactionName and not region5:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region5):settlement_gifted_as_if_by_payload(cm:modify_faction(wangLangFactionName))
	end
	local region6= cm:query_region("3k_main_kuaiji_resource_1") --give this to wangLang 
	if region6:owning_faction():name() ~= wangLangFactionName and not region6:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region6):settlement_gifted_as_if_by_payload(cm:modify_faction(wangLangFactionName))
	end
	local region7= cm:query_region("3k_main_kuaiji_resource_2") --give this to wangLang 
	if region7:owning_faction():name() ~= wangLangFactionName and not region7:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region7):settlement_gifted_as_if_by_payload(cm:modify_faction(wangLangFactionName))
	end

	CusLog("Finished SetUpWangLang")
end

local function Conquer2() -- to Do region names - LiuYao Regions (JianYe = Moling)
	CusLog("Begin Conquer2");
	local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire");
	
	local region1= cm:query_region("3k_main_xindu_resource_2")
	local region2= cm:query_region("3k_main_jianye_capital")
	local region3= cm:query_region("3k_main_jianye_resource_2")
	
	if region1:owning_faction():name() ~= qSunCe:faction():name() and not region1:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region1):settlement_gifted_as_if_by_payload(cm:modify_faction(qSunCe:faction():name()))
	end
	if region2:owning_faction():name() ~= qSunCe:faction():name() and not region2:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region2):settlement_gifted_as_if_by_payload(cm:modify_faction(qSunCe:faction():name()))
	end
	if region3:owning_faction():name() ~= qSunCe:faction():name() and not region3:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region3):settlement_gifted_as_if_by_payload(cm:modify_faction(qSunCe:faction():name()))
	end
	CusLog("..Gonna hook up wanglang")
	SetUpWangLang()
	CusLog("Flipping random YanBaihu Cheeze")
	cm:set_saved_value("yanBaihu_cheeze",true);



	-- Confederate Liu Yao 
	CusLog("Forcing confederation of Liu Yao ")
	cm:force_confederation(qSunCe:faction():name(),liuYaoFactionName)
	
	--Liu Yao himself fled to Yuzhang and sought safety with Liu Biao, Imperial Protector of Jingzhou
	local liubiaoFaction=cm:query_faction("3k_main_faction_liu_biao")
	if not liubiaoFaction:is_null_interface() then 
		if liubiaoFaction:is_dead() then
			KillSomeone(liuYaoName) 
		elseif liubiaoFaction:is_human() then
			--TODO Trigger a dilemma 
			MoveCharToFactionHard(liuYaoName, "3k_main_faction_han_empire") 	
		else
			MoveCharToFactionHard(liuYaoName, "3k_main_faction_liu_biao") -- or Liu yao could be an emergent faction in YuZhang.
		end
	else
		KillSomeone(liuYaoName) --just get rid of him 
	end
	CusLog("Getting rid of the extra officers")
	CleanOfficerList(qSunCe:faction():name())

	--Get TaishiCi
	if cm:get_saved_value("taishi_w_liuyao") and qSunCe:faction():is_human() then 
		getTaishiCi(); -- has incident attached
	elseif not qSunCe:faction():is_human() then 
		MoveCharToFaction("3k_main_template_historical_taishi_ci_hero_metal" , qSunCe:faction():name()) --Check
	end
	
	 CusLog("..trigging war with YanBaihu")
	 --Declare war on Yan Baihu
	 CusLog("--Note* Somehow doesnt crash")
	cm:apply_automatic_deal_between_factions(qSunCe:faction():name(),yanBaihuFactionName, "data_defined_situation_war_proposer_to_recipient",false) --WARNING Might CRASH
	cm:apply_automatic_deal_between_factions(yanBaihuFactionName,qSunCe:faction():name(), "data_defined_situation_war_proposer_to_recipient",true) --WARNING Might CRASH
	

	CusLog("..Applying some satisfaction")
	if(qSunCe:faction():is_human()==false) then 
		cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", qSunCe:faction():name() , 25)   -- satisfaction faction wide
		--salary included 
	else --Not sure if human will ever have this path, but just to be safe
		cm:apply_effect_bundle("3k_main_payload_satisfaction_all_characters", qSunCe:faction():name() , 4)
	end
	
	CusLog("Finished Conquer2");
end


local function Conquer1() --Most of Poyang
	CusLog("Begin Conquer1");	--Might not need to do all 3 regions, but this happens quickly after MoveEast, dont want him to die
	local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire");
	
	local region1= cm:query_region("3k_main_poyang_capital")  --Que  
	local region2= cm:query_region("3k_main_poyang_resource_3")
	local region3= cm:query_region("3k_main_poyang_resource_2")
	--local region4= cm:query_region("3k_main_poyang_resource_1") --the Iron mine to the West
	
	if region1:owning_faction():name() ~= qSunCe:faction():name() and not region1:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region1):settlement_gifted_as_if_by_payload(cm:modify_faction(qSunCe:faction():name()))
	end
	if region2:owning_faction():name() ~= qSunCe:faction():name() and not region2:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region2):settlement_gifted_as_if_by_payload(cm:modify_faction(qSunCe:faction():name()))
	end
	if region3:owning_faction():name() ~= qSunCe:faction():name() and not region3:owning_faction():is_human() then
		cm:modify_model():get_modify_region(region3):settlement_gifted_as_if_by_payload(cm:modify_faction(qSunCe:faction():name()))
	end
	
	CusLog("..Increasing SunCe funds and giving him zhoutai,jianqin")
	cm:modify_faction(qSunCe:faction():name()):increase_treasury(1800)
	getSunCeOfficers3() --ZhouTai JiangQin
	 
	 CusLog("..Making sure still waring LiuYao")
	 --War LiuYao Again Check2
	if not cm:query_faction(liuYaoFactionName):has_specified_diplomatic_deal_with("treaty_components_war",qSunCe:faction()) then
		cm:apply_automatic_deal_between_factions(qSunCe:faction():name(),liuYaoFactionName, "data_defined_situation_war_proposer_to_recipient",false)
		cm:apply_automatic_deal_between_factions(liuYaoFactionName,qSunCe:faction():name(), "data_defined_situation_war_proposer_to_recipient",true)
    end
	 
	CusLog("Finished Conquer1");
end
local function GiveSunCeBackSeal()
	CusLog("Begin GiveSunCeBackSeal")
	-- Give Yuan shu the seal 
	local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire");
	local sunce_faction=cm:modify_faction(qSunCe:faction():name())
	local yuanshu_faction = cm:modify_faction("3k_main_faction_yuan_shu")
	--	modify_faction:ceo_management():add_ceo( "3k_main_ancillary_accessory_imperial_jade_seal" );
	if sunce_faction:is_null_interface() or  yuanshu_faction:is_null_interface() then 
		CusLog("One of these factions is null, abort");
	else 
		CusLog("swaping")
		FindAndDestroySeal()
		sunce_faction:ceo_management():add_ceo("3k_main_ancillary_accessory_imperial_jade_seal")
	end
	cm:set_saved_value("Yuanshu_TookSeal", false) --used to declare player yuanshu emperor
	CusLog("End GiveSunCeBackSeal")
end

local function GiveYuanShuSeal() 
	CusLog("Begin GiveYuanShuSeal")
	-- Give Yuan shu the seal 
	local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire");
	local sunce_faction=cm:modify_faction(qSunCe:faction():name())
	local yuanshu_faction = cm:modify_faction("3k_main_faction_yuan_shu")
	--	modify_faction:ceo_management():add_ceo( "3k_main_ancillary_accessory_imperial_jade_seal" );
	if sunce_faction:is_null_interface() or  yuanshu_faction:is_null_interface() then 
		CusLog("One of these factions is null, abort");
	else 
		CusLog("swaping")
		FindAndDestroySeal()
		yuanshu_faction:ceo_management():add_ceo("3k_main_ancillary_accessory_imperial_jade_seal")
	end
	cm:set_saved_value("Yuanshu_TookSeal", true) -- unused atm
	CusLog("End GiveYuanShuSeal")
end

local function MoveEast() --AI Only
	CusLog("Begin MoveEast");
	local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire");
	--Sun Ce had subdued Lu Gang, the Governor of Lujiang.  
	-- Get Zhu Zhi , Lu fan from YuanShu , cheng Pu , Huang Gai, Han Dang , Zhou Yu, both Zhangs ... ( have to add alot of loyalty here)
	GetSunCeOfficers1()
	--Give Yuan Shu Lu Fan regardless of human or not
	local qChar2= getQChar("3k_main_template_historical_lu_fan_hero_water"); --CHECK
	if not qChar2:is_null_interface() then 
		if qChar2:faction():name()~="3k_main_faction_yuan_shu" then 
			MoveCharToFactionHard(qChar2:generation_template_key(),"3k_main_faction_yuan_shu")
		else
			MoveCharToFaction(qChar2:generation_template_key(),"3k_main_faction_yuan_shu")
		end
	else
		--Careful spawning 
		CusLog("Warning: Couldn't find ".."3k_main_template_historical_lu_fan_hero_water".." Spawning in:".."3k_main_faction_yuan_shu");
		cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_yuan_shu", "3k_general_water", "3k_main_template_historical_lu_fan_hero_water"); --CHECK
	end
	
	--IF yuan Shu is not human Move him 
	local qyuanshu_faction = cm:query_faction("3k_main_faction_yuan_shu")
	if(qyuanshu_faction:is_human()==false and  cm:get_saved_value("yuanshu_moved_shouchun")~=true ) then
		if cm:query_model():campaign_name()~="3k_dlc05_start_pos" then 
			MoveToShouchun(2) -- since its possible its early, we'll give him less regions (need testing)
		end
		GiveYuanShuSeal()
	else
		--Trigger a dilemma for player yuan shu to take seal in exchange for lu fan and sending troops (decreased replenishment)
		local triggered =cm:trigger_dilemma("3k_main_faction_yuan_shu", "3k_lua_yuanshu_aids_sunce", true);
		if not triggered then 
			CusLog("dilemma failed")
		end
	end
	
	if cm:get_saved_value("liuYao_moved") ~=true then 
		MoveLiuYao() --YuanShuEarly
	end 
	
	
	--War LiuYao
	if not cm:query_faction(liuYaoFactionName):has_specified_diplomatic_deal_with("treaty_components_war",qSunCe:faction()) then
		cm:apply_automatic_deal_between_factions(qSunCe:faction():name(),liuYaoFactionName, "data_defined_situation_war_proposer_to_recipient",false)
		cm:apply_automatic_deal_between_factions(liuYaoFactionName,qSunCe:faction():name(), "data_defined_situation_war_proposer_to_recipient",true)
    end
	if cm:query_model():campaign_name()~="3k_dlc05_start_pos" then 
		AbandonLands("3k_main_faction_sun_jian")
		local region1= cm:query_region("3k_main_lujiang_capital")
		local region2= cm:query_region("3k_main_lujiang_resource_2")
		--50/50 on getting the town 
		local gifted=false;
		local chosenName=""
		local chanceOnTown=5;

		--100% on gettig the lumberyard if AI owned 
		if region2:owning_faction():name() ~= qSunCe:faction():name() and not region2:owning_faction():is_human() then
			cm:modify_model():get_modify_region(region2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_sun_jian"))
			gifted=true;
			chosenName="3k_main_lujiang_resource_2"
		else
			chanceOnTown=-1;
		end
			--Chance on the town based on getting lumberyard
		if RNGHelper(chanceOnTown) and region1:owning_faction():name() ~= qSunCe:faction():name() and not region1:owning_faction():is_human() then
			cm:modify_model():get_modify_region(region1):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_sun_jian"))
			gifted=true;
			chosenName="3k_main_lujiang_capital"
		end

		if not gifted then --Total fail safe i guess
			local region3= cm:query_region("3k_main_xindu_resource_2")
			cm:modify_model():get_modify_region(region3):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_sun_jian"))
			chosenName="3k_main_xindu_resource_2"
		end
	
		CusLog("..Attempting to teleport armies");
	 	--Teleport any armies there 
		 TelportAllFactionArmies("3k_main_faction_sun_jian",chosenName)
	else 
		local region2= cm:query_region("3k_main_lujiang_resource_2")
		if region2:owning_faction():name() ~= qSunCe:faction():name() and not region2:owning_faction():is_human() then
			cm:modify_model():get_modify_region(region2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_sun_jian"))
		end

	end
	 CusLog("Moving TaishiCi TO liuYao")
	 --Move TaishCi Into LiuYaos force
	local moved= MoveCharToFaction("3k_main_template_historical_taishi_ci_hero_metal" , liuYaoFactionName)
	if moved then 
		cm:set_saved_value("taishi_w_liuyao", true);
	else
		cm:set_saved_value("taishi_w_liuyao", false);
	end
 
	CusLog("Finished MoveEast");
end

local function FinishMovingSunCe()

	GetSunCeOfficers2()
	CusLog("..Applying bonuses")
	cm:modify_faction("3k_main_faction_sun_jian"):increase_treasury(3000)
	cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", "3k_main_faction_sun_jian" , 4)
	cm:apply_effect_bundle("3k_main_introduction_mission_payload_recruit_units", "3k_main_faction_sun_jian" , 6)
	
	--Give Sun Ce back Lu Fan
	local qChar2= getQChar("3k_main_template_historical_lu_fan_hero_water");
	if not qChar2:is_null_interface() then 
		-- if player is yuan shu, AI sun ce can get through a dilemma , 
		MoveCharToFactionHard(qChar2:generation_template_key(),qSunCe:faction():name())
	else -- this shouldnt never happen
		--Careful spawning 
		CusLog("@Warning: SHOULD NEVER HAPPEN Couldnt find ".."3k_main_template_historical_lu_fan_hero_water".." Spawning in:"..qSunCe:faction():name());
		cdir_events_manager:spawn_character_subtype_template_in_faction(qSunCe:faction():name(), "3k_general_water", "3k_main_template_historical_lu_fan_hero_water");
	end
	 
end
-----------------------------------------------------------------------
-----------Separate Functions from Listeners---------------------------
-----------------------------------------------------------------------

local function SunCeWantsWarListener() --Will work for both 190/AWB AI/Player 
	CusLog("### SunCeWantsWarListener loading ###")  
	core:remove_listener("SunCeWantsWar")  
	core:add_listener(
		"SunCeWantsWar",
		"FactionTurnEnd",
		function(context)       --Date range is fine, cuz AWB can keep sunce alive
			if context:query_model():date_in_range(197,202) and cm:get_saved_value("seal_demanded") ==true then 
				local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire")
				if qSunCe:is_null_interface() then
					CusLog("!!!..qSunCe is null??wth?")
					return false;
				elseif qSunCe:is_dead() then			
					return false
				elseif qSunCe:faction():name() ~= context:faction():name() then 
					return false;
				elseif not qSunCe:is_faction_leader() then 
					return false;
				end 
				if not context:faction():is_human() then 
					CusLog("Checking if SunCE wants war")
					local Cond1= cm:query_faction("3k_main_faction_liu_biao"):has_specified_diplomatic_deal_with("treaty_components_war",qSunCe:faction())
					local Cond2= cm:query_faction("3k_main_faction_huang_zu"):has_specified_diplomatic_deal_with("treaty_components_war",qSunCe:faction())
					CusLog("Cond1="..tostring(Cond1))
					CusLog("Cond2="..tostring(Cond2))
					if Cond1==false or Cond2==false then 
						CusLog("returning TRUE!")
						return true;
					end
				end
			
			end
			 return false
		end,
		function(context)
			CusLog("??Callback: Passed SunCeWantsWarListener ###")
			cm:force_declare_war(context:faction():name(), "3k_main_faction_liu_biao")
			cm:force_declare_war(context:faction():name(), "3k_main_faction_huang_zu")
			CusLog("### Finished SunCeWantsWarListener Callback ###")
		end,
		false
    )
end


local function YuanShuSealChoiceMadeListener()
    CusLog("### YuanShuSealChoiceMadeListener loading ###")
    core:remove_listener("YuanShuSealChoiceMade")
    core:add_listener(
    "YuanShuSealChoiceMade",
    "DilemmaChoiceMadeEvent",
    function(context)
        CusLog("..Listening for 3k_lua_yuanshu_aids_sunce choice ") --Should have Dilemma VASSALIZE
        return context:dilemma() == "3k_lua_yuanshu_aids_sunce"  
    end,
    function(context)
        CusLog("..! choice was:" .. tostring(context:choice()))
        if context:choice() == 0 then
			GiveYuanShuSeal()
			FinishMovingSunCe()
			cm:set_saved_value("NextTurn",context:query_model():turn_number()+1)
			--CusLog("Did this work? Next turn="..tostring(cm:get_saved_value("NextTurn")))
		else
			
        end

    end,
    false
 );
end

local function YuanShuSealBACKChoiceMadeListener()
    CusLog("### YuanShuSealBACKChoiceMadeListener loading ###")
    core:remove_listener("YuanShuSealBACKChoiceMade")
    core:add_listener(
    "YuanShuSealBACKChoiceMade",
    "DilemmaChoiceMadeEvent",
    function(context)
        CusLog("..Listening for 3k_lua_sunce_demands_seal_yshu choice ") --Should have Dilemma VASSALIZE
        return context:dilemma() == "3k_lua_sunce_demands_seal_yshu"  or  context:dilemma() == "3k_lua_sunce_demands_seal_yshuAWB" 
    end,
    function(context)
        CusLog("..! choice was:" .. tostring(context:choice()))
        if context:choice() == 1 then
			GiveSunCeBackSeal()
		else
			--do nothing? set a variable for a plan w liu bei?
        end

    end,
    false
 );
end

local function YanBaihuCheezeListener() --Will work for both 190/AWB AI/Player 
	CusLog("### YanBaihuCheezeListener loading ###")  --Should be an entry point into AI/Player YuanShus PlotLine
	core:remove_listener("YanBaihuCheeze")  --Needs to happen before 197 and yuan shu declares emperor ideally
	core:add_listener(
		"YanBaihuCheeze",
		"FactionTurnEnd",
		function(context)       --Date range is fine, cuz AWB can keep sunce alive
			if context:faction():name() == yanBaihuFactionName then 
				--CusLog("FOUND YNABAIUM FACTION")
				if not context:faction():is_human() then --idk why this works 
					return cm:get_saved_value("yanBaihu_cheeze");
						--return true;
				elseif context:faction():is_human() then
					--Do nothing 
					cm:set_saved_value("yanBaihu_cheeze",false);
				end
			end
			 return false
		end,
		function(context)
			CusLog("??Callback: Passed YanBaihuCheezeListener ###")
			CusLog("??Warning might just crash  ###")
			cm:set_saved_value("yanBaihu_cheeze",false);
		--	cm:set_saved_value("seal_demanded",true)
		local region4= cm:query_region("3k_main_xindu_resource_1") -- lumberyard 
		if region4:owning_faction():name() ~= yanBaihuFactionName and not region4:owning_faction():is_human() then
			CusLog("Try 1")
			cm:modify_model():get_modify_region(region4):settlement_gifted_as_if_by_payload(cm:modify_faction(context:faction())) --WARNING Might CRASH
			CusLog("Pass")
		end
		local region5= cm:query_region("3k_main_jianan_resource_2") --lumberyard2
		if region5:owning_faction():name() ~= yanBaihuFactionName and not region5:owning_faction():is_human() then
			--cm:modify_model():get_modify_region(region5):settlement_gifted_as_if_by_payload(cm:modify_faction(context:faction())) --WARNING Might CRASH
			CusLog("Try 2")
			cdir_events_manager:transfer_region_to_faction("3k_main_jianan_resource_2", context:faction():name());
			CusLog("Pass")
		end

			CusLog("### Finished YanBaihuCheezeListener Callback ###")
		end,
		false
    )
end


local function SunCeWantsSealBackListener() --Will work for both 190/AWB AI/Player 
	CusLog("### SunCeWantsSealBackListener loading ###")  --Should be an entry point into AI/Player YuanShus PlotLine
	core:remove_listener("SunCeWantsSealBack")  --Needs to happen before 197 and yuan shu declares emperor ideally
	core:add_listener(
		"SunCeWantsSealBack",
		"FactionTurnEnd",
		function(context)       --Date range is fine, cuz AWB can keep sunce alive
			if context:query_model():date_in_range(196,202) and cm:get_saved_value("seal_demanded") ~=true then 
				local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire")
				if qSunCe:is_null_interface() then
					CusLog("!!!..qSunCe is null??wth?")
					return false;
				elseif qSunCe:is_dead() then			
					return false
				elseif qSunCe:faction():name() ~= context:faction():name() then 
					return false;
				elseif not qSunCe:is_faction_leader() then 
					return false;
				elseif not CheckSunCesLand() then --Any SunCe that holds these regions
					return false;
				end 
				if not context:faction():is_human() then 
					CusLog("..Checking if SunCE wants seal (AI) TMP0")
						return RNGHelper(4); --4  
				elseif context:faction():is_human() then
					CusLog("..Checking if SunCE wants seal (player)")
					return RNGHelper(2); 
				end
			
			end
			 return false
		end,
		function(context)
			CusLog("??Callback: Passed SunCeWantsSealBackListener ###")
			YuanShuSealBACKChoiceMadeListener()
			DemandSeal()
			cm:set_saved_value("seal_demanded",true)
			EnsureSunCeDiesListener() -- incase it isnt on 
			CusLog("### Finished SunCeWantsSealBackListener Callback ###")
		end,
		false
    )
end


local function LittleConqueror4Listener() --Will work for both 190/AWB AI 
	CusLog("### LittleConqueror4Listener loading ###") --Take Yan Baihu
	core:remove_listener("LittleConqueror4")
	core:add_listener(
		"LittleConqueror4",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(196,199) then 
				local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire")
				if qSunCe:is_null_interface() then
					CusLog("!!!..qSunCe is null??wth?")
					return false;
				elseif qSunCe:is_dead() then			
					return false
				elseif qSunCe:faction():name() ~= context:faction():name() then 
					return false;
				elseif not qSunCe:is_faction_leader() then 
					return false;
				end --Wont base this off of little_C3, just incase RNG is low, but we still want to expand the right dir
				if not context:faction():is_human() then 
						if cm:get_saved_value("YuanShu_ahead") and cm:get_saved_value("little_C4") ~=true then 
							CusLog("..Skipping ahead in story, SunCe land 4")
							return true;
						elseif cm:get_saved_value("little_C4") ~=true then 
							CusLog("..Checking if Should Give SunCe land 4")
							if cm:get_saved_value("NextTurn") <= context:query_model():turn_number() then 
								return RNGHelper(5); -- would be nice to add a check hes not visible to player, but meh
							end
						end
				elseif context:faction():is_human() then
					-- Do nothing
				end
			
			end
			 return false
		end,
		function(context)
			CusLog("??Callback: Passed LittleConqueror4Listener ###")
			Conquer4()
			SunCeWantsSealBackListener()
			cm:set_saved_value("little_C4",true)
			cm:set_saved_value("NextTurn",context:query_model():turn_number()+1)
			CusLog("### Finished LittleConqueror4Listener Callback ###")
		end,
		false
    )
end


local function LittleConqueror3Listener() --Will work for both 190/AWB AI 
	CusLog("### LittleConqueror3Listener loading ###") --Take Yan Baihu
	core:remove_listener("LittleConqueror3")
	core:add_listener(
		"LittleConqueror3",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(195,198) then --Little delay on this compared to last one 
				local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire")
				if qSunCe:is_null_interface() then
					CusLog("!!!..qSunCe is null??wth?")
					return false;
				elseif qSunCe:is_dead() then			
					return false
				elseif qSunCe:faction():name() ~= context:faction():name() then 
					return false;
				elseif not qSunCe:is_faction_leader() then 
					return false;
				end --Tied in so this doesnt happen before the other 
				if not context:faction():is_human() then 
						CusLog("..Checking if Should Give SunCe land 3")
						if cm:get_saved_value("YuanShu_ahead") then 
							return true;
						elseif cm:get_saved_value("little_C2") and cm:get_saved_value("little_C3") ~=true then 
							if cm:get_saved_value("NextTurn") <= context:query_model():turn_number() then 
								return RNGHelper(5); -- would be nice to add a check hes not visible to player, but meh
							end
						end
				elseif context:faction():is_human() then
					-- Do nothing
				end
			
			end
			 return false
		end,
		function(context)
			CusLog("??Callback: Passed LittleConqueror3Listener ###")
			CusLog(" CARE! somehow little_C3 doesnt get set to true??? INVESTIGATE")
			Conquer3()
			LittleConqueror4Listener()
			cm:set_saved_value("little_C3",true) -- somehow this didnt get set?
			cm:set_saved_value("NextTurn",context:query_model():turn_number()+1)
			CusLog("### Finished LittleConqueror3Listener Callback ###")
		end,
		false
    )
end


local function LittleConqueror2Listener() --Will work for both 190/AWB AI 
	CusLog("### LittleConqueror2Listener loading ###") --Take LiuYao
	core:remove_listener("LittleConqueror2")
	core:add_listener(
		"LittleConqueror2",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(193,196) then 
				local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire")
				if qSunCe:is_null_interface() then
					CusLog("!!!..qSunCe is null??wth?")
					return false;
				elseif qSunCe:is_dead() then			
					return false
				elseif qSunCe:faction():name() ~= context:faction():name() then 
					return false;
				elseif not qSunCe:is_faction_leader() then 
					return false;
				end 
				if not context:faction():is_human() then 
						CusLog("..Checking if Should Give SunCe land 2")
						if cm:get_saved_value("little_C1") and cm:get_saved_value("little_C2") ~=true then 
							if cm:get_saved_value("NextTurn") <= context:query_model():turn_number() then 
								return RNGHelper(5); -- would be nice to add a check hes not visible to player, but meh
							end
						end
				elseif context:faction():is_human() then
					-- Do nothing
				end
			
			end
			 return false
		end,
		function(context)
			CusLog("??Callback: Passed LittleConqueror2Listener ###")
			Conquer2()
			LittleConqueror3Listener()
			cm:set_saved_value("little_C2",true)
			CusLog("### Finished LittleConqueror2Listener Callback ###")
		end,
		false
    )
end


function LittleConqueror1Listener() --Will work for both 190/AWB AI
	CusLog("### LittleConqueror1Listener loading ###") --Foothold in Poyang
	core:remove_listener("LittleConqueror1")
	core:add_listener(
		"LittleConqueror1",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(192,195) then 
				local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire")
				if qSunCe:is_null_interface() then
					CusLog("!!!..qSunCe is null??wth?")
					return false;
				elseif qSunCe:is_dead() then			
					return false
				elseif qSunCe:faction():name() ~= context:faction():name() then 
					return false;
				elseif not qSunCe:is_faction_leader() then 
					return false;
				end
				if not context:faction():is_human() then 
						CusLog("..Checking if Should Give SunCe land")
						if cm:get_saved_value("MoveWuEast") and cm:get_saved_value("little_C1") ~=true then
							if cm:get_saved_value("NextTurn") <= context:query_model():turn_number() then 
								return RNGHelper(5); -- would be nice to add a check hes not visible to player, but meh
							end
						end
				elseif context:faction():is_human() then
					-- Do nothing
				end
			
			end
			 return false
		end,
		function(context)
			CusLog("??Callback: Passed LittleConqueror1Listener ###")
			Conquer1()
			LittleConqueror2Listener()
			cm:set_saved_value("little_C1",true)
			cm:set_saved_value("NextTurn",context:query_model():turn_number()+1)
			CusLog("### Finished LittleConqueror1Listener Callback ###")
		end,
		false
    )
end


function MoveZhouTaiAndJiangQListener() --190 only 
	CusLog("### MoveZhouTaiAndJiangQListener loading ###") 
	core:remove_listener("MoveZhouTaiAndJiangQ")
	core:add_listener(
		"MoveZhouTaiAndJiangQ",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(190,191) and context:faction():name() == "3k_main_faction_sun_jian" then  
				ModLog("Checking MoveZhouTaiAndJiangQListener ")
				local qZhouTai= getQChar("3k_main_template_historical_zhou_tai_hero_fire")
				if qZhouTai:is_null_interface() then
					CusLog("..ZhouTai is NUll..")
					return false;
				elseif qZhouTai:is_dead() then
					CusLog("..ZhouTai is dead early....AF..")
					core:remove_listener("MoveZhouTaiAndJiangQ")
					return false
				elseif qZhouTai:faction():name() == "3k_main_faction_sun_jian" then 
					CusLog("..ZhouTai is in Wu.")
					return false;
				elseif  qZhouTai:faction():is_human() then 
					CusLog("..ZhouTai faction is human .")
					return false;
				end
				if cm:get_saved_value("MovedThemBoth") ~=true then 
					return true;
				end
			end
			return false
		end,
		function(context)
			CusLog("??Callback: Passed MoveZhouTaiAndJiangQListener ###")
			MoveZhouTandJianQ();
			cm:set_saved_value("MovedThemBoth",true)
			CusLog("### Finished MoveZhouTaiAndJiangQListener Callback ###")
		end,
		false
    )
end


function MoveWuEastListener() --Will work for 190 only
	CusLog("### MoveWuEastListener loading ###") -- WIll get AI Yuan Shu to proper place 
	core:remove_listener("MoveWuEast")
	core:add_listener(
		"MoveWuEast",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(191,194)then 
				local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire")
				if qSunCe:is_null_interface() then
					CusLog("!!!..qSunCe is null??wth?")
					return false;
				elseif qSunCe:is_dead() then
					--core:remove_listener("MoveWuEast")				
					return false
				elseif qSunCe:faction():name() ~= "3k_main_faction_sun_jian"  then --190 only
					CusLog("Sunces faction name is actually:"..tostring(qSunCe:faction():name()))
					return false;
				elseif not qSunCe:is_faction_leader() then --Also slows this down closer to 192
					return false;
				end
				if not context:faction():is_human() and qSunCe:faction():name() == context:faction():name() then 
						CusLog("..Checking if Should Move Wu east")
						local year= context:query_model():calendar_year();
						local chance = 194- year;  -- 194-191= 3 +4 =7   --194-192=2 +4 =6  193= 5  194=4  
						if cm:get_saved_value("MoveWuEast") ~=true then --We want a delay on year cuz it moves AI YuanSHu
							return RNGHelper(chance+4); -- would be nice to add a check hes not visible to player, but meh
						else
							cm:modify_faction(qSunCe:faction():name()):increase_treasury(300) -- keep them alive
						end
				elseif context:faction():is_human() then
					-- Trigger Dilemma where you exchange the seal, in return  you get 
					-- Redployment/Recruitment buff
					-- Get Zhu Zhi , Lu fan from YuanShu , cheng Pu , Huang Gai, Han Dang and Zhou Yu
					-- Zhou Yu suggests you reach out to zhangs- Then get both Zhangs
				end
			elseif context:query_model():calendar_year()==195 and cm:get_saved_value("MoveWuEast") ~=true then --fail safe on RNGesus
				return true
			end
			 return false
		end,
		function(context)
			CusLog("??Callback: Passed MoveWuEastListener ###")
			MoveEast()
			LittleConqueror1Listener()
			cm:set_saved_value("NextTurn",context:query_model():turn_number()+1)
			cm:set_saved_value("MoveWuEast",true)
			CusLog("### Finished MoveWuEastListener Callback ###")
		end,
		false
    )
end





local function WuSunCeVariables()
		CusLog("Debugg: WuLeadersVariables")
		CusLog("  WuSunce MoveWuEast= "..tostring(cm:get_saved_value("MoveWuEast")))
		CusLog("  WuSunce Yuanshu_TookSeal= "..tostring(cm:get_saved_value("Yuanshu_TookSeal")))
		CusLog("  WuSunce little_C1= "..tostring(cm:get_saved_value("little_C1")))
		CusLog("  WuSunce little_C2= "..tostring(cm:get_saved_value("little_C2")))
		CusLog("  WuSunce little_C3= "..tostring(cm:get_saved_value("little_C3")))
		CusLog("  WuSunce little_C4= "..tostring(cm:get_saved_value("little_C4")))
		CusLog("  WuSunce taishi_w_liuyao= "..tostring(cm:get_saved_value("taishi_w_liuyao")))
		CusLog("  WuSunce NextTurn= "..tostring(cm:get_saved_value("NextTurn")))
		CusLog("  WuSunce seal_demanded= "..tostring(cm:get_saved_value("seal_demanded")))
		CusLog(" *WuSunce YuanShu_ahead= "..tostring(cm:get_saved_value("YuanShu_ahead"))) --from xuplot2

		CusLog("Finished: WuLeadersVariables")
end
local function WuSunCeIni() 
	CusLog("Debugg: WuSunCeIni")
	local qSunCe= getQChar("3k_main_template_historical_sun_ce_hero_fire")
	
	if (not qSunCe:is_null_interface()) then 
		CusLog("Sunce is not null")
		if(qSunCe:is_faction_leader()) then 
			CusLog("Sunce faction =") 
			CusLog("              ="..tostring(qSunCe:faction():name())) 
			if qSunCe:faction():is_human() then 
				cm:set_saved_value("wu_is_human",true) -- also set in wuleaders, but only for 190 faction,this sets for AWB
			else
				cm:set_saved_value("wu_is_human",false)
			end
		end
		
	end
	
	--[[
    local curr_faction = cm:query_faction("3k_dlc05_faction_sun_ce") --CRASH
	if(curr_faction:is_null_interface()) then
		CusLog("Error: NullInterface")
	else 
		CusLog("Middle: WuSunCeIni")
		if curr_faction:is_human() then
			cm:set_saved_value("wu_is_human",true) -- also set in wuleaders, but only for 190 faction,this sets for AWB
		else
			cm:set_saved_value("wu_is_human",false)
		end
	
	end --]]

	CusLog("Fniished: WuSunCeIni")
end

local function DLC5Issues()
	CusLog("--Warning DLC5Issues")
	local qYanBaihu= getQChar("3k_main_template_historical_yan_baihu_hero_metal")
		if not qYanBaihu:is_null_interface() then 
			CusLog("..We found yanBaihu --WARNING Might CRASH")
			if not qYanBaihu:is_dead() then 
				CusLog("..He's not dead, so his factionname="..tostring(qYanBaihu:faction():name()))
				yanBaihuFactionName= qYanBaihu:faction():name();
			end
		end
		CusLog("--END DLC5Issues")
end

-- when the campaign loads run these functions:
cm:add_first_tick_callback(
	function(context)
		IniDebugger()
		WuSunCeVariables()

		if context:query_model():turn_number() == 1 then 
			ModLog("..Dont check DLC faction in 190....")
			WuSunCeIni()
		end
        if context:query_model():date_in_range(189,193) then
			MoveWuEastListener()
			LittleConqueror1Listener()
		end
		if context:query_model():date_in_range(193,202) then
			--Register them backwards to help delay? ...didnt work which makes no sense  
			if cm:get_saved_value("little_C4") then 
				SunCeWantsWarListener()
			end
			
			if not cm:get_saved_value("little_C4") then --idk how this doesnt set
				LittleConqueror4Listener()
			end
			if not cm:get_saved_value("little_C3") then --idk how this doesnt set
				LittleConqueror3Listener()
			end
			if not cm:get_saved_value("little_C2") then 
				LittleConqueror2Listener()
				YanBaihuCheezeListener()
			end
			if not cm:get_saved_value("little_C1") then 
				LittleConqueror1Listener()
			end
			if not cm:get_saved_value("MoveWuEast") then 
				MoveWuEastListener()
				YuanShuSealChoiceMadeListener()
			end

		end
		if cm:get_saved_value("Yuanshu_TookSeal")==true and context:query_model():date_in_range(197,203) then
			SunCeWantsSealBackListener()--he will probably be dead by 202
		end 

		if cm:get_saved_value("MovedThemBoth") ~=true then 
			MoveZhouTaiAndJiangQListener()
		end

		--[[CusLog("TMP XINDU")
		local region4= cm:query_region("3k_main_xindu_capital")
		if region4:owning_faction():name() ~= "3k_main_faction_sun_jian" and not region4:owning_faction():is_human() then
			cm:modify_model():get_modify_region(region4):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_sun_jian"))
		end--]]

	end
)


