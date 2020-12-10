--> Cao Cao misc
-- responsible for setting up Zhang Miao and CaoCaos in Yan 

--> Need to get CaoCao his core officers...

--TODO we are calling to destroy yuanshus seal, but his factions dead,
-- so what if someone else has it? When we kill yuan shu, destroy it first!

--need a function that keeps 3k_main_template_historical_che_zhou_hero_water alive (in hanEmpire?)

local printStatements=false;



local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_caocao_misc.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
		local header=" (cao_misc): "
		local line= time..header..text
		file:write(line.."\n")
        file:close()
		ModLog(header..text)
    end
end

local function IniDebugger()
	printStatements=true;
	local file = io.open("@havie_caocao_misc.txt", "w+")
	CusLog("---Begin File----")
end

local function CheckDianWei()
	CusLog("Begin CheckDianWei")
	
	local qdianwei=getQChar2("3k_main_template_historical_dian_wei_hero_wood")
	if qdianwei==nil then 
		CusLog("Dian wei is null, so spawning w Zhang Miao")
		cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_liu_dai", "3k_general_wood", "3k_main_template_historical_dian_wei_hero_wood");
	else
		CusLog(" Dian wei is alive?")
		if qdianwei:faction():name() ~= "3k_main_faction_cao_cao" then 
			MoveCharToFaction("3k_main_template_historical_dian_wei_hero_wood", "3k_main_faction_liu_dai")
		end 
	end
	cm:set_saved_value("DianWei_check",true)
	CusLog("End CheckDianWei")
end

function KillLiuDai()
	CusLog("Begin KillLiuDai")
	-- Zhang Miao (move to faction)
	CusLog("checking ZhangMiaos situation")
	local qZhangMiao = getQChar("3k_main_template_historical_zhang_miao_hero_water")
	if(qZhangMiao:is_null_interface()) then 
		CusLog("ZhangMiao is missing-going to spawn (1)");
		--spawn
		cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_cao_cao", "3k_general_water", "3k_main_template_historical_zhang_miao_hero_water");
	elseif  qZhangMiao:is_dead() then 
		CusLog("ZhangMiao is dead-going to spawn (2)");
		--spawn
		cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_cao_cao", "3k_general_water", "3k_main_template_historical_zhang_miao_hero_water");
	elseif qZhangMiao:faction():name() ~="3k_main_faction_liu_dai" then --if hes in the player faction.. too bad?
		CusLog("ZhangMiao is alive");
		MoveCharToFaction("3k_main_template_historical_zhang_miao_hero_water", "3k_main_faction_liu_dai");
	end

	--kill liu dai 
	local mliudai= getModifyChar("3k_main_template_historical_liu_dai_hero_water")
	if(not mliudai:is_null_interface()) then 
		mliudai:kill_character(false)
		local mZhangMiao = getModifyChar("3k_main_template_historical_zhang_miao_hero_water") -- have to grab again
		--Make Zhang Miao Leader 
		if(mZhangMiao:is_null_interface()==false ) then 
			mZhangMiao:assign_to_post("faction_leader"); --Make Zhang Miao Leader
		end
	end
	
	local qfaction= cm:query_faction("3k_main_faction_liu_dai")
	--Make peace with dong, otherwise AI dong kills zhang miao, or zhand miao takes trade port

	if cm:query_faction("3k_main_faction_dong_zhuo"):has_specified_diplomatic_deal_with("treaty_components_war",qfaction) then
		cm:apply_automatic_deal_between_factions("3k_main_faction_liu_dai", "3k_main_faction_dong_zhuo", "data_defined_situation_proposer_declares_peace_against_target", true);
		CusLog(".make hidden peace for zhang miao dong")
		cm:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo", "3k_main_faction_liu_dai", "data_defined_situation_peace", true);
	end
 	qfaction= cm:query_faction("3k_main_faction_cao_cao")
	if cm:query_faction("3k_main_faction_dong_zhuo"):has_specified_diplomatic_deal_with("treaty_components_war",qfaction) then
		cm:apply_automatic_deal_between_factions("3k_main_faction_liu_dai", "3k_main_faction_cao_cao", "data_defined_situation_proposer_declares_peace_against_target", true);
		CusLog(".make hidden peace for zhang miao caocao")
		cm:apply_automatic_deal_between_factions("3k_main_faction_cao_cao", "3k_main_faction_liu_dai", "data_defined_situation_peace", true);
	end

	--If player is not CaoCao:
	-- ToDO Spawn DianWei / Move him to ZhangMiaos Faction  (move him to CaoCaos Faction shortly after) 
	-- OR just spawn him in CaoCaos faction anyway, becuz Dian Wei leaves Zhang Miao badly 
	-- This is like RIGHT before cao songs death Dian wei joins 
	-- Cao Cao. “Who is he?” asked Cao Cao. “He is from Chenliu and is named Dian Wei. He is the boldest of the bold, the strongest of the strong. He was one of Zhang Miao’s people, but quarreled with his tent companions and killed some dozens of them with his fists. Then he fled to the mountains where I found him. I was out shooting and saw him follow a tiger across a stream. I persuaded him to join my troop, and I recommend him.”  
	CheckDianWei()
	
	core:remove_listener("Liu_Dai_DiesListener");
	CusLog("Finished KillLiuDai")
	
end

function CaoCaoGivenYanProvince()
		CusLog("Running CaoCaoGivenYanProvince ")
	-- Give dong capital 
   local dong_region =cm:query_region(PUYANG) 
	if (dong_region:owning_faction():is_human() ==false) then 
		CusLog("..gave dong AI")
		cm:modify_model():get_modify_region(dong_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_cao_cao"))
	elseif dong_region:owning_faction():name() == "3k_main_faction_yuan_shao" then 
		CusLog("..gave dong YuanShao")
		cm:modify_model():get_modify_region(dong_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_cao_cao"))
	end


	CusLog("..Check XuChang")
	-- Give XuChang (yingchuan city) - if not owned by player
   local xuchang_region =cm:query_region(XUCHANG) 
	if (xuchang_region:owning_faction():is_human() ==false) then 
		CusLog("xuchang is owned by "..xuchang_region:owning_faction():name())
		if xuchang_region:owning_faction():name() == "3k_dlc04_faction_prince_liu_chong" then   -- check ID 
			cm:modify_model():get_modify_region(xuchang_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_cao_cao"))
			--swap liu chong somewhere to die by yuan shu?
			CusLog("@!!LiuChong Owns this regions, what to do?? -- should move him to chen if the player is not cao cao")
			local chen_region =cm:query_region("3k_main_chenjun_resource_1") 
			local chen_region2 =cm:query_region("3k_main_chenjun_resource_2") 
			if chen_region:owning_faction():is_human()==false then			 
				cm:modify_model():get_modify_region(chen_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc04_faction_prince_liu_chong")) 
				CusLog("..moved liu chong")
			elseif chen_region2:owning_faction():is_human()==false then			 
				cm:modify_model():get_modify_region(chen_region2):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc04_faction_prince_liu_chong")) 
				CusLog("..moved liu chong(2)")
			end
		else
			cm:modify_model():get_modify_region(xuchang_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_cao_cao"))
		end
	end 

	-- Give Chen Gong to Zhang Miao ( he leaved dongjun to join zhang miao after CaoSong dies) --Could split into its own event later?
	local qchengong= getQChar("3k_main_template_historical_chen_gong_hero_water")
	if(not qchengong:is_null_interface()) then 
		if(qchengong:faction():name() ~= "3k_main_faction_cao_cao") then 
			if(not qchengong:faction():is_human() ) then 
				MoveCharToFaction("3k_main_template_historical_chen_gong_hero_water", "3k_main_faction_liu_dai");
			end
		end
	else 
		CusLog("..Chen gong is not alive-spawn in caocao")
		cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_liu_dai", "3k_general_water", "3k_main_template_historical_chen_gong_hero_water");
	end

	--Check Liu Dai(zhang miao) is still in yingchuan farm 
	CusLog("..check yingchuan stuff")
	local zhangmiaogood=false;
	local qfaction = cm:query_faction("3k_main_faction_liu_dai")
     if qfaction:region_list() then
        for i = 0, qfaction:faction_province_list():num_items() - 1 do
            local province_key = qfaction:faction_province_list():item_at(i);
            for i = 0, province_key:region_list():num_items() - 1 do
                local region_key = province_key:region_list():item_at(i);
                local region_name = region_key:name()
				if( region_name == "3k_main_yingchuan_resource_1") then 
					zhangmiaogood=true;
				end
            end	
        end
    end
	
	if(zhangmiaogood==false) then 
		CusLog("@!!!! Zhang Miao doesnt own yingchuan farm for set up for Lu BU..??")
		CusLog("@!!!! Potenially good chose your own adventure, perhaps the player purposely interrupts..??")
	else
		CusLog("..Zhang Miao in the right place")
		cm:modify_faction("3k_main_faction_liu_dai"):increase_treasury(1500) -- keep him afloat
		--cease wars to increase survival
		if cm:query_faction("3k_main_faction_cao_cao"):has_specified_diplomatic_deal_with("treaty_components_war",qfaction) then
			cm:apply_automatic_deal_between_factions("3k_main_faction_liu_dai","3k_main_faction_cao_cao", "data_defined_situation_war_proposer_to_recipient",true)
		end
		if cm:query_faction("3k_main_faction_zhang_yang"):has_specified_diplomatic_deal_with("treaty_components_war",qfaction) then
			cm:apply_automatic_deal_between_factions("3k_main_faction_liu_dai","3k_main_faction_zhang_yang", "data_defined_situation_war_proposer_to_recipient",true)
		end
	end

	local playersFactionsTable = cm:get_human_factions()
	local playerFaction = playersFactionsTable[1]
	CusLog("Trigger incident : 3k_lua_caocao_given_yan ") 
	if(playerFaction ~= "3k_main_faction_cao_cao" and playerFaction ~= "3k_main_faction_yuan_shao" ) then 
    	cm:trigger_incident(playerFaction ,"3k_lua_caocao_given_yan", true)
	end 
	cm:set_saved_value("cao_given_yan",true) -- used by lu bu movement
	CusLog("Finish CaoCaoGivenYanProvince")
end

function YuanShaoGivenYanProvince()
	local dong_region =cm:query_region(PUYANG) 
	if (dong_region:owning_faction():is_human() ==false) then 
		cm:modify_model():get_modify_region(dong_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_yuan_shao"))
	elseif dong_region:owning_faction():name() == "3k_main_faction_cao_cao" then 
		cm:modify_model():get_modify_region(dong_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_yuan_shao"))
	end

end

function YanCallBack()
	CusLog("Running YanCallBack")
	core:remove_listener("cao_cao_inherits_yan_provinceListener");
			
	local q_caocao = cm:query_faction("3k_main_faction_cao_cao")
	local q_yuanshao = cm:query_faction("3k_main_faction_yuan_shao")
			
	if(q_caocao:is_human() == true) then 
		--trigger dilemma to accept yuan shaos proposal
		CaoCaoChoiceMadeListener()
		FireDilemma("3k_lua_caocao_yan_dilemma")
	elseif(q_yuanshao:is_human()==true) then
	--trigger dilemma to give CaoCao Dong
		YuanShaoChoiceMadeListener()
		FireDilemma("3k_lua_yuanshao_yan_dilemma") -- questionable 
	else 
		CaoCaoGivenYanProvince()
	end
	cm:set_saved_value("cao_cao_has_yan", true);
	CusLog("finished YanCallBack")
end

---------------------------------------------------------------
---------------------------------------------------------------
-------------- Listeners From Functions -----------------------
---------------------------------------------------------------
---------------------------------------------------------------



--Needs serious testing 
local function LiuBeiAndCaoFightLubuListener() 
    CusLog("### LiuBeiAndCaoFightLubuListener 2 loading ###")
    core:remove_listener("LiuBeiAndCaoFightLubu") 
	core:add_listener(
		"LiuBeiAndCaoFightLubu",
		"FactionTurnEnd",
        function(context)
			if context:faction():name()=="3k_main_faction_liu_bei" then 
				local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
				 if qlubu:is_faction_leader() and not context:faction():has_specified_diplomatic_deal_with("treaty_components_war",qlubu:faction()) then
					CusLog("Lubu is a leader and liu bei doesnt have war")
					CusLog("Is LiuBei vassal of Cao="..tostring(cm:query_faction("3k_main_faction_cao_cao"):has_specified_diplomatic_deal_with("treaty_components_vassalage",context:faction())))
					return cm:query_faction("3k_main_faction_cao_cao"):has_specified_diplomatic_deal_with("treaty_components_vassalage",context:faction()) 
				end
			end
             return false
		end,
        function(context)
			CusLog("??? callback LiuBeiAndCaoFightLubuListener ###")
			local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
			local CaoCaoFaction=cm:query_faction("3k_main_faction_cao_cao")
				--LiuBei Declares war again LuBu
			campaign_manager:force_declare_war("3k_main_faction_liu_bei", qlubu:faction():name(), false)
			cm:apply_automatic_deal_between_factions("3k_main_faction_liu_bei",qlubu:faction():name(), "data_defined_situation_war_proposer_to_recipient",true) 
			campaign_manager:force_declare_war(qlubu:faction():name(),"3k_main_faction_liu_bei", false)
   
			--CaoCao Declares war LuBu
	 		campaign_manager:force_declare_war("3k_main_faction_cao_cao", qlubu:faction():name(), false)
     		cm:apply_automatic_deal_between_factions("3k_main_faction_cao_cao",qlubu:faction():name(), "data_defined_situation_war_proposer_to_recipient",true) 
 
			 CusLog("### Pass LiuBeiAndCaoFightLubuListener ###")
		end,
		true
    )
end

local function CaoGetsXuChuListener() --AI (should keep char in the faction as well for few years if he leaves )
	CusLog("### CaoGetsXuChuListener listener loading ###")
	core:remove_listener("CaoGetsXuChu")
	core:add_listener(
		"CaoGetsXuChu",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(192,197)  and context:faction():name() == "3k_main_faction_cao_cao" then
				local id="3k_main_template_historical_xu_chu_hero_wood"
				local qChar= getQChar(id)
				if not qChar:is_null_interface() then 
					if not qChar:is_dead() then 
						return qChar:faction():name()~="3k_main_faction_cao_cao"
					end
				else
					CusLog("LUA spawning in: "..id)
					cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_cao_cao", "3k_general_wood", id);
				end
			end
			 return false;
		end,
		function(context)
			CusLog("???Callback: CaoGetsXuChuListener Callback ###")
			if context:faction():is_human() then 
				CusLog("@???Check vanilla/custom xuchu events?")
			else
				MoveCharToFaction("3k_main_template_historical_xu_chu_hero_wood", "3k_main_faction_cao_cao");
			end
		end,
		true
    )
end

local function CaoGetsGuoJiaListener() --AI/Player (should keep char in the faction as well for few years if he leaves )
	CusLog("### CaoGetsGuoJiaListener listener loading ###")
	core:remove_listener("CaoGetsGuoJia")
	core:add_listener(
		"CaoGetsGuoJia",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(191,195)  and context:faction():name() == "3k_main_faction_cao_cao" then
				local id="3k_main_template_historical_guo_jia_hero_water"
				local qChar= getQChar(id)
				if not qChar:is_null_interface() then 
					if not qChar:is_dead() then 
						return qChar:faction():name()~="3k_main_faction_cao_cao"
					end
				else
					CusLog("LUA spawning in: "..id)
					cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_cao_cao", "3k_general_water", id);
				end
			end
			 return false;
		end,
		function(context)
			CusLog("???Callback: CaoGetsGuoJiaListener Callback ###")
			MoveCharToFaction("3k_main_template_historical_guo_jia_hero_water", "3k_main_faction_cao_cao");
		end,
		true
    )
end

local function CaoGetsYuJinListener() --AI/Player (should keep char in the faction as well for few years if he leaves )
	CusLog("### CaoGetsYuJinListener listener loading ###")
	core:remove_listener("CaoGetsYuJin")
	core:add_listener(
		"CaoGetsYuJin",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(191,195)  and context:faction():name() == "3k_main_faction_cao_cao" then
				local qChar= getQChar("3k_main_template_historical_yu_jin_hero_metal")
				if not qChar:is_null_interface() then 
					if not qChar:is_dead() then 
						return qChar:faction():name()~="3k_main_faction_cao_cao"
					end
				else
					CusLog("LUA spawning in: 3k_main_template_historical_yu_jin_hero_metal")
					cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_cao_cao", "3k_general_metal", "3k_main_template_historical_yu_jin_hero_metal");
				end
			end
			 return false;
		end,
		function(context)
			CusLog("???Callback: CaoGetsYuJinListener Callback ###")
			MoveCharToFaction("3k_main_template_historical_yu_jin_hero_metal", "3k_main_faction_cao_cao");
		end,
		true
    )
end

local function CaoGetsYueJinListener() --AI (should keep char in the faction as well for few years if he leaves )
	CusLog("### CaoGetsYueJinListener listener loading ###")
	core:remove_listener("CaoGetsYueJin")
	core:add_listener(
		"CaoGetsYueJin",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(191,195)  and context:faction():name() == "3k_main_faction_cao_cao" then
				local qChar= getQChar("3k_main_template_historical_yue_jin_hero_metal")
				if not qChar:is_null_interface() then 
					if not qChar:is_dead() then 
						return qChar:faction():name()~="3k_main_faction_cao_cao"
					end
				else
					CusLog("LUA spawning in: 3k_main_template_historical_yue_jin_hero_metal")
					cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_cao_cao", "3k_general_metal", "3k_main_template_historical_yue_jin_hero_metal");
				end
			end
			 return false;
		end,
		function(context)
			CusLog("???Callback: CaoGetsYueJinListener Callback ###")
			if context:faction():is_human() then 
				--trigger incident or dilemma? dilemma to much work
				CusLog("Test YueJin human")
				--What about vanilla dilemma???			
			else --Wont move if hes w player
				MoveCharToFaction("3k_main_template_historical_yue_jin_hero_metal", "3k_main_faction_cao_cao");
			end
		end,
		true
    )
end

local function CaoGetsDianWeiListener() --AI / player ?
	CusLog("### CaoGetsDianWeiListener listener loading ###")
	core:remove_listener("CaoGetsDianWei")
	core:add_listener(
		"CaoGetsDianWei",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(191,194)  and context:faction():name() == "3k_main_faction_cao_cao" and cm:get_saved_value("DianWei_check") then
				 local qdianwei= getQChar2("3k_main_template_historical_dian_wei_hero_wood")
				 if qdianwei~=nil then 
					return qdianwei:faction():name()~="3k_main_faction_cao_cao"
				 end
			end
			 return false;
		end,
		function(context)
			CusLog("???Callback: CaoGetsDianWeiListener Callback ###")
			if context:faction():is_human() then 
				--trigger incident or dilemma? dilemma to much work
				CusLog("Test dianwei human")
				--What about vanilla dilemma???
				--cm:trigger_incident("3k_main_faction_cao_cao", "3k_lua_cao_hires_dian_wei",true) -- use vanilla move even and rewrite
			else
				MoveCharToFaction("3k_main_template_historical_dian_wei_hero_wood", "3k_main_faction_cao_cao");
			end
		end,
		true
    )
end

local function CaoCaovsLuBuListener() --If AI cao cao stats losing, we really beef him up (190 LuBu)
	CusLog("### CaoCaovsLuBuListener listener loading ###")
	core:remove_listener("CaoCaovsLuBuListener")
	core:add_listener(
		"CaoCaovsLuBu",
		"FactionTurnEnd",
		function(context)
			if not context:faction():is_human() and context:faction():name() =="3k_main_faction_cao_cao" and  cm:get_saved_value("lubu_took_puyang")==true and cm:get_saved_value("lubu_saved")~=true then
				CusLog("Few conditions for CaoCaovsLuBuListener..")
				if cm:query_faction("3k_main_faction_cao_cao"):has_specified_diplomatic_deal_with("treaty_components_war",cm:query_faction("3k_main_faction_dong_zhuo")) then
					local countCC= CountRegions("3k_main_faction_cao_cao")
					local countLB = CountRegions("3k_main_faction_dong_zhuo")
					if( countCC <= countLB)then 
						local modifer= 1 + (countLB-countCC);
						cm:modify_faction("3k_main_faction_cao_cao"):increase_treasury(math.floor(1200*modifer))
						cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", "3k_main_faction_cao_cao" , 1)
						return true;
					end
				else
					CusLog("CaoCao doesnt have War w LuBu")
				end
			end
			 return false;
		end,
		function(context)
			CusLog("???Callback: Applied CaoCaovsLuBu Bonus to AI CAOCAO  ###")
		end,
		true
    )
end

local function CaoCaoBonusLimitedListener() --for the AI
	CusLog("### CaoCaoBonusLimitedListener listener loading ###")
	core:remove_listener("CaoCaoBonusLimited")
	core:add_listener(
		"CaoCaoBonusLimited",
		"FactionTurnEnd",
		function(context)
			if not context:faction():is_human() and context:faction():name() =="3k_main_faction_cao_cao" and  cm:get_saved_value("caocao_buffed_turnlimit")~=nil then
				--CusLog("..Checking CaoCaoBonusLimitedListener Turn#= "..tostring(context:query_model():turn_number()))
				if cm:get_saved_value("caocao_buffed_turnlimit") > context:query_model():turn_number() then 
					return true;
				else
					--CusLog("CaoCao Turn Bonus exceeded , last cap was:"..tostring(cm:get_saved_value("caocao_buffed_turnlimit")))
					--core:remove_listener("CaoCaoBonusLimited")
				end
			end
			 return false;
		end,
		function(context)
			CusLog("???Callback: Applied Limited bonus to AI CAOCAO  ###")
			if context:faction():treasury() <30000 then -- limit the OP ness 
				cm:modify_faction("3k_main_faction_cao_cao"):increase_treasury(2500)
				cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", "3k_main_faction_cao_cao" , 1)
			end
		end,
		true
    )
end

--maybe if player is yuan shu, this should be delayed 
local function cao_cao_inherits_yan_provinceListener()
	CusLog("### cao_cao_inherits_yan_province listener loading ###")
	core:remove_listener("cao_cao_inherits_yan_provinceListener")
	core:add_listener(
		"cao_cao_inherits_yan_provinceListener",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(191,194)  and context:faction():is_human() == true and cm:get_saved_value("cao_given_yan") ~=true and cm:get_saved_value("liu_dai_dead") then
				local rolled_value = cm:random_number( 0, 5 );
				CusLog("--Trying to Pass cao_cao_inherits_yan_provinceListener Delay, rolled a:"..rolled_value)
                 if rolled_value > 2 then 
					   local dong_region =cm:query_region(PUYANG) 
					   if (dong_region:owning_faction():is_human() ==false) then 
							return true
						elseif dong_region:owning_faction():name() == "3k_main_faction_yuan_shao" then 
							return true 
					   end
                 end		
			end
			 return false;
		end,
		function(context)
			CusLog("???Callback: cao_cao_inherits_yan_provinceListener Callback ###")
			YanCallBack()
		end,
		true
    )
end


local function CaoCaoChoiceMadeListener()
	CusLog("### CaoCaoChoiceMadeListener loading ###")
	core:remove_listener("DilemmaChoiceMadeCaoCaoYan")
    core:add_listener(
    "DilemmaChoiceMadeCaoCaoYan",
    "DilemmaChoiceMadeEvent",
    function(context)
        CusLog("..Listening for 3k_lua_caocao_yan_dilemma choice ")
        return context:dilemma() == "3k_lua_caocao_yan_dilemma"   
    end,
    function(context)
        CusLog("..! choice was:" .. tostring(context:choice()))
        if context:choice() == 0 then
            CaoCaoGivenYanProvince() -- chen gong puts together a deal for him with yuan shaos nomination to secure dong ?
        end
         core:remove_listener("DilemmaChoiceMadeCaoCaoYan");
    end,
    true
);
end

local function YuanShaoChoiceMadeListener()
	CusLog("### YuanShaoChoiceMadeListener loading ###")
	core:remove_listener("DilemmaChoiceMadeYuanShaoYan")
    core:add_listener(
    "DilemmaChoiceMadeYuanShaoYan",
    "DilemmaChoiceMadeEvent",
    function(context)
        CusLog("..Listening for 3k_lua_yuanshao_yan_dilemma choice ")
        return context:dilemma() == "3k_lua_yuanshao_yan_dilemma"   
    end,
    function(context)
        CusLog("..! choice was:" .. tostring(context:choice()))
        if context:choice() == 0 then
		   CaoCaoGivenYanProvince()
		else
			YuanShaoGivenYanProvince()
        end
         core:remove_listener("DilemmaChoiceMadeYuanShaoYan");
    end,
    true
);
end

local function Liu_Dai_DiesListener()
	CusLog("### Liu_Dai_DiesListener listener loading ###")
	core:remove_listener("Liu_Dai_DiesListener")
	core:add_listener(
		"Liu_Dai_DiesListener",
		"FactionTurnEnd",
		function(context)
			if context:query_model():date_in_range(191,194) and context:faction():is_human() == true  and cm:get_saved_value("liu_dai_dead")~=true then
				CusLog("..Checking if we need to kill liu dai")
				local liudai= getQChar("3k_main_template_historical_liu_dai_hero_water")
				if(liudai:is_null_interface()) then 
					return false
				end
				if liudai:is_dead() then 
					return false
				end
				CusLog("Liudai dead="..tostring(liudai:is_dead()))
				CusLog("Liudai faction="..tostring(liudai:faction():name()))
				local rolled_value = cm:random_number( 0, 5 );
				CusLog("--Trying to Pass Liu_Dai_DiesListener Delay, rolled a:"..rolled_value)
				 if rolled_value >= 2 then 
					KillLiuDai()
					cm:set_saved_value("liu_dai_dead", true);
					CusLog("!!!Passed, wont call back")
					return true
				 else
					CusLog("..didnt pass")
                 end		
			end
			 return false;
		end,
		function(context)
			CusLog("???Callback: Liu_Dai_DiesListener  ###")
			cm:set_saved_value("liu_dai_dead", true);
			--KillLiuDai() -- This works, but i think something is crashing
			--cao_cao_inherits_yan_provinceListener();
		end,
		true
    )
end

local function TeleportCaoCaoANDBUFF()
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
	CusLog("Finish Caocaos main army to global var CHENCITY")
end


local function CaoMiscVariables()
	CusLog("  CaoMisc liu_dai_dead= "..tostring(cm:get_saved_value("liu_dai_dead")))
    CusLog("  CaoMisc cao_given_yan= "..tostring(cm:get_saved_value("cao_given_yan")))
    CusLog("  CaoMisc caocao_buffed_turnlimit= "..tostring(cm:get_saved_value("caocao_buffed_turnlimit")))
	
	CusLog("  CaoMisc DianWei_check= "..tostring(cm:get_saved_value("DianWei_check")))

end




-- when the campaign loads run these functions:
cm:add_first_tick_callback(
	function(context)
		IniDebugger()
		CaoMiscVariables()
		local year= context:query_model():calendar_year()
        if year > 189 and year < 195 then
			if cm:get_saved_value("liu_dai_dead") ==nil then
				Liu_Dai_DiesListener()
			end
			if cm:get_saved_value("cao_cao_has_yan") ==nil then 
				cao_cao_inherits_yan_provinceListener()
			end
			CaoGetsDianWeiListener()
			CaoGetsYueJinListener()
			CaoGetsYuJinListener()
			CaoGetsYueJinListener()
			CaoGetsXuChuListener()
			CaoGetsGuoJiaListener()
			--XunYu and XunYou are handled by vanilla pack just fine
			--Xu Huang is from Emperor script
			--Zhang He is from yuan confederation
			--Zhang liao is from LuBu capture script

		end


		if cm:get_saved_value("caocao_buffed_turnlimit")~=nil then 
			CaoCaoBonusLimitedListener()
		end

		if year > 193 and year < 203 then 
			CaoCaovsLuBuListener()
			LiuBeiAndCaoFightLubuListener()
		end

		--CusLog("TMP TeleportCaoCaoANDBUFF")
		--TeleportCaoCaoANDBUFF()
		
		--CusLog("----TMP print officers------")

		--CleanOfficerList("3k_main_faction_cao_cao")
		--PrintOfficersInFaction("3k_main_faction_gongsun_zan")
		--TellMeAboutFaction("3k_main_faction_cao_cao")
		--TellMeAboutFaction("3k_main_faction_sun_jian")
		--TellMeAboutFaction("3k_main_faction_liu_bei")
		--TellMeAboutFaction("3k_main_faction_yuan_shao")
		--TellMeAboutFaction("3k_main_faction_lu_bu")
    end
)
