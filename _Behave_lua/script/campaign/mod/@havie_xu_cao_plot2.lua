-----> XU Cao Plot2 This Script is responsible for
--- The Tiger Wolf plot set up 
--(AI/Player) Cao Cao,  Liu Bei, Yuan Shu (but not more than 1 Player)
--Ultimate result is it puts liu bei and Yuan shu at war , 
--Places Zhang Fei alone in Xu and sets up lu bu to steal city 

--**If more than 1 human, a failsafe in Xu_lubu_post will catch this and have AI lu bu rebel against AI liu bei 
--**If Liu Bei is one of the humans, he will only trigger this is he leaves zhang fei alone in XiaPi.


local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_xu_cao_plot2.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
		local header=" (lubu_xu_cao_plot2): "
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
	local file = io.open("@havie_xu_cao_plot2.txt", "w+")
	file:close()
	CusLog("---Begin File----")
end


function MoveZhangFeisArmy()
	--set var for lu bu drunk zhang fei incident 
	CusLog("Begin MoveZhangFeisArmy")
	local qCommander= getQChar2("3k_main_template_historical_zhang_fei_hero_fire")
	if qCommander~=nil then 
		CusLog("Zhang fei is hopefully Deployable place by now,  try to spawn him")
		local unit_list="3k_main_unit_wood_ji_infantry_captain,3k_main_unit_metal_jian_swordguards,3k_main_unit_metal_sabre_infantry"
		SpawnAGeneralInRegion(qCommander, XIAPICITY, unit_list)
		--SpawnRealFaction("3k_main_faction_liu_bei", "3k_main_template_historical_zhang_fei_hero_fire", XIAPICITY, "3k_main_faction_yuan_shu", 573, 467)
		--Set some kind of variable for LuBu to betray?
		cm:set_saved_value("beef_ran",true) -- stop SetUpBeefFailSafe() from running 
		-- **Will create a listener for if zhang fei is in the right place on turn start to fire instead (In XuLubuPost)
	else
		CusLog("!!!..Zhang fei is somehow null??")
	end 
	CusLog("End MoveZhangFeisArmy")
	
end


function MoveLiuBeisArmy()
	CusLog("Begin MoveLiuBeisArmy")
	--local qFaction=cm:query_faction("3k_main_faction_liu_bei")
	--ToDo Find spot in woods
	local x=558; 			--ToDo Find loc in Xu Woods
	local y=438; 			--ToDo Find loc in Xu Woods
	--local WhoHadForce="neither"
	local qCommander= getQChar("3k_main_template_historical_liu_bei_hero_earth")
	if qCommander:has_military_force() then 
	   CusLog("..Teleporting Commander: "..tostring(qCommander:generation_template_key()))
	   cm:modify_model():get_modify_character(qCommander):teleport_to(x,y)
	   --WhoHadForce="3k_main_template_historical_liu_bei_hero_earth"
	else
		CusLog("Liu Bei had no force")
		qCommander= getQChar("3k_main_template_historical_guan_yu_hero_wood")
		if qCommander:has_military_force() and qCommander:faction():name()=="3k_main_faction_liu_bei" then 
			CusLog("..Teleporting Commander: "..tostring(qCommander:generation_template_key()))
		   cm:modify_model():get_modify_character(qCommander):teleport_to(x,y)
		    --WhoHadForce="3k_main_template_historical_guan_yu_hero_wood"
	   else
			CusLog("..Neither LiuBei or GuanYu Have Armies?")
		end
	end
	
	MoveZhangFeisArmy() -- Happens in the previous listener 
	-- need to allow time for lu bu to decide what to do 
	cm:set_saved_value("turnsNo_till_liuBei_can_flee", cm:query_model():turn_number() +6); -- start the ability for him to flee (liubei movement)
	CusLog("End MoveLiuBeisArmy")
end

function MoveYuanShusArmy()
	CusLog("Begin MoveYuanShusArmy")
	local x=555; 			--ToDo Find loc in Xu Woods2
	local y=434; 			--ToDo Find loc in Xu Woods2
	local qCommander= getQChar("3k_main_template_historical_yuan_shu_hero_earth")
	if qCommander:has_military_force() then 
	   CusLog("..Teleporting Commander: "..tostring(qCommander:generation_template_key()))
	   cm:modify_model():get_modify_character(qCommander):teleport_to(x,y)
	else
		CusLog("Yuan Shu had no force")
		qCommander= getQChar("3k_main_template_historical_ji_ling_hero_fire")
		if qCommander:has_military_force() and qCommander:faction():name()=="3k_main_faction_yuan_shu" then 
			CusLog("..Teleporting Commander: "..tostring(qCommander:generation_template_key()))
		   cm:modify_model():get_modify_character(qCommander):teleport_to(x,y)
		else
			CusLog("..Neither YuanShu or JiLing Have Armies, find a random one or make one for Jiling?")
			local qFaction = cm:query_faction("3k_main_faction_yuan_shu")
			local found=false;
			if(qFaction:is_human()==false) then
				CusLog(factionName.." has this many armies: "..qFaction:military_force_list():num_items())
				if not qFaction:military_force_list():is_empty() then -- this is not working..?
					for i=0 , qFaction:military_force_list():num_items() -1 do 
						local m_force= qFaction:military_force_list():item_at(i)
						if(m_force:is_armed_citizenry()) then        --if(qgeneral:is_armed_citizenry()) then  -_Error here --has_garrison_residence
							CusLog("..found a garrison, break..")
						else
							CusLog("..found army")
							local commander= m_force:character_list():item_at(0) 
							CusLog("..Teleporting Commander: "..tostring(commander:generation_template_key()))
							local randomness1 = math.floor(cm:random_number(-4, 4 ));
							local randomness2 = math.floor(cm:random_number(-4, 4 ));
							cm:modify_model():get_modify_character(commander):teleport_to(x+randomness1,y-randomness2) 
							i=qFaction:military_force_list():num_items()-2; -- Stop the looping 
						end
					end
				end
				cm:modify_faction(qFaction:name()):increase_treasury(1000) 
			end
		end
	end
	CusLog("End MoveYuanShusArmy")
end


function MoveYSLBArmies() 
	CusLog("Begin MoveYSLBArmies")
	CusLog("..! testing new getter for QFaction")

	--IF AI liu BEI
	-- move zhang fei out of faction, back in and station at Xu
	-- Move LiuBeis army to woods
	local qFaction=getQFaction("3k_main_faction_liu_bei")
	if qFaction~=nil then 
		if not qFaction:is_human() then 
			MoveLiuBeisArmy()
		else
			CusLog("LiuBei is human? do something like prompt dilemma to leave zhang fei behind (or guan yu)")
		end
	end
	
	
	--IF AI Yuan Shu
	-- Move JiLing army or someone elses to woods 
	local qFaction2=getQFaction("3k_main_faction_yuan_shu")
	if qFaction2~=nil then 
		if not qFaction2:is_human() then 
			MoveYuanShusArmy()
		else
		CusLog("YuanShu is human? do something?")
		end
	end


	CusLog("End MoveYSLBArmies")
end


local function LiubeiWarYuanshu() --This event needs move the AI armies towards eachother and leave zhang fei in Xu
	CusLog("Begin LiubeiWarYuanshu")

    local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
	local q_yuanshu_faction = cm:query_faction("3k_main_faction_yuan_shu")

	if not q_yuanshu_faction:has_specified_diplomatic_deal_with("treaty_components_war",qliubei_faction) then 
		cm:modify_faction(q_yuanshu_faction):apply_automatic_diplomatic_deal("data_defined_situation_war", qliubei_faction, ""); 
		cm:apply_automatic_deal_between_factions(q_yuanshu_faction:name(), qliubei_faction:name(), "data_defined_situation_proposer_declares_war_against_target", true);
		cm:apply_automatic_deal_between_factions(qliubei_faction:name(), q_yuanshu_faction:name(), "data_defined_situation_proposer_declares_war_against_target", true);
	end
	if qliubei_faction:has_specified_diplomatic_deal_with("treaty_components_peace",q_yuanshu_faction) then 
		cm:modify_faction(q_yuanshu_faction):apply_automatic_diplomatic_deal("data_defined_situation_war", qliubei_faction, ""); 
		cm:apply_automatic_deal_between_factions(q_yuanshu_faction:name(), qliubei_faction:name(), "data_defined_situation_proposer_declares_war_against_target", true); 
		cm:apply_automatic_deal_between_factions(qliubei_faction:name(), q_yuanshu_faction:name(), "data_defined_situation_proposer_declares_war_against_target", true);
	end
	local success= qliubei_faction:has_specified_diplomatic_deal_with("treaty_components_war",q_yuanshu_faction);
	CusLog("TIGERWOLF success="..tostring(success))
	--Theres always a chance diplo fails, so maybe this should trigger an incident that forces the war via db event
	if not success then 
		CusLog("trying to trigger some fail safe event?")
		local playersFactionsTable = cm:get_human_factions()
		local playerFaction = playersFactionsTable[1]
		success= cm:trigger_incident(playerFaction, "3k_lua_yuanshuliubei_war", true )
	end
	--Might want to ensure the 2 factions have proper land nearby 

	CusLog("why doesnt this come back as true? even though it works ")
	cm:set_saved_value("tigerwolf_success",success)
	

	MoveYSLBArmies()

	CusLog("Finish LiubeiWarYuanshu")
end



local function TigerWolf()
	CusLog("Begin TigerWolf")
	
	if cm:get_saved_value("tigerwolf_started")~=true then -- was incase i ran this from a diff script (but thats off fornow)
		local triggered=true;
		local q_caocao_faction = cm:query_faction("3k_main_faction_cao_cao")
		local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
		local q_yuanshu_faction = cm:query_faction("3k_main_faction_yuan_shu")
		
		local playercount=0;
		--if both players are liubei and caocao this will get weird, abort it?
		if q_caocao_faction:is_human() then 
			playercount=playercount+1;
		end
		if qliubei_faction:is_human() then 
			playercount=playercount+1;
		end
		if q_yuanshu_faction:is_human() then 
			playercount=playercount+1;
		end
		
		if playercount>1 then 
			CusLog("aborting tigerplot .. too many players");
			 cm:set_saved_value("tigerwolf_success",false)
			return true; -- will allow other scripts to move on 
			--Set some other value for lubu vs zhang feis betrayal to happen naturally?
		end
		
		
		if q_caocao_faction:is_human() then -- Yuan Shu and LiuBei declare war 
			--Dilemma to fabricate letter between liu bei and yuan shu
			CusLog(" Cao cao requires Xun Yu")
			local qXunYu=getQChar("3k_main_template_historical_xun_yu_hero_water")
			if qXunYu:is_null_interface() then 
				return false;
			elseif qXunYu:is_dead() then 
				return false;
			elseif qXunYu:faction():name() ~="3k_main_faction_cao_cao" then 
				return false
			end
			triggered=cm:trigger_dilemma("3k_main_faction_cao_cao", "3k_lua_caocao_tiger_wolf_dilemma", true);
		elseif qliubei_faction:is_human() then --ask if u want to declare war on yuan shu 
			--dilemma on how to respond to cao caos letter
			triggered=cm:trigger_dilemma("3k_main_faction_liu_bei", "3k_lua_liubei_tiger_wolf_dilemma", true);
		elseif q_yuanshu_faction:is_human() then --ask if u want to declare war on liu bei
			triggered=cm:trigger_dilemma("3k_main_faction_yuan_shu", "3k_lua_yuanshu_tiger_wolf_dilemma", true);
		else
			--liubei and yuan shu declare war 
			LiubeiWarYuanshu()
		end
		CusLog("Finish TigerWolf triggered="..tostring(triggered))
		return triggered;
	end

	CusLog("Already started tigerplot")
	return false;
end

-----------------------------------------------------------------------
-----------Separate Functions from Listeners---------------------------
-----------------------------------------------------------------------


local function YuanShuTigerWolfChoiceListener()
	CusLog("### YuanShuTigerWolfChoiceListener loading ###")
	core:remove_listener("YuanShuTigerWolfChoiceMade");
    core:add_listener(
    "YuanShuTigerWolfChoiceMade",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_yuanshu_tiger_wolf_dilemma" 
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! choice was:" .. tostring(context:choice()))
        if choice == 0 then 
			LiubeiWarYuanshu()
			--Move along SunCe wanting the seal 
			cm:set_saved_value_("YuanShu_ahead",true)
        end    
			
    end,
    false -- does not persist
 );
end

local function LiuBeiTigerWolfChoiceListener()
	CusLog("### LiuBeiTigerWolfChoiceListener loading ###")
	core:remove_listener("LiuBeiTigerWolfChoiceMade");
    core:add_listener(
    "LiuBeiTigerWolfChoiceMade",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_liubei_tiger_wolf_dilemma" 
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! choice was:" .. tostring(context:choice()))
        if choice == 0 then 
            LiubeiWarYuanshu()
        end    
			
    end,
    false -- does not persist
 );
end


local function CaoCaoTigerWolfChoiceListener()
	CusLog("### CaoCaoTigerWolfChoiceListener loading ###")
	core:remove_listener("CaoCaoTigerWolfChoiceMade");
    core:add_listener(
    "CaoCaoTigerWolfChoiceMade",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_caocao_tiger_wolf_dilemma" -- one option deepen relation with xun yu
    end,
    function(context)
        local choice=context:choice()
        CusLog("..! choice was:" .. tostring(context:choice()))
        if choice == 0 then
            LiubeiWarYuanshu()
        end
    end,
    false -- does not persist
 );
end



function TigersWolfPlotListener() --Tiger Against Wolf  (could add a listener for if zhangfei doesnt have military force)
	CusLog("### TigersWolfPlotListener  loading ###")
	core:remove_listener("TigersWolfPlot");
	core:add_listener(
		"TigersWolfPlot",
		"FactionTurnEnd",
		function(context) -- do player turn so teleport zhangfei works 
			if( context:faction():is_human() and  cm:get_saved_value("rivaltigers_started") ~= -1 and  cm:get_saved_value("tigerwolf_started")~=true ) then  
				if cm:get_saved_value("rivaltigers_started")then
					CusLog("RivalTigers in motion, were waiting")
					return false
				end
				local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
                local qlubu_faction = qlubu:faction();
                local qliubei_faction = cm:query_faction("3k_main_faction_liu_bei")
				local q_yuanshu_faction= cm:query_faction("3k_main_faction_yuan_shu")
				local q_caocao_faction= cm:query_faction("3k_main_faction_cao_cao")
				if( qlubu:is_faction_leader() and not q_yuanshu_faction:is_dead() and cm:query_faction(qlubu_faction:name()):has_specified_diplomatic_deal_with("treaty_components_vassalage",qliubei_faction) ) then
					if not qliubei_faction:has_specified_diplomatic_deal_with("treaty_components_war",q_yuanshu_faction) then 
						if not q_caocao_faction:is_human()    then --probably cant be dead cuz its his end turn
							if not qliubei_faction:is_human() then 
								return MakeDeployable("3k_main_template_historical_zhang_fei_hero_fire") 
							else
								return true;
							end
						elseif (cm:get_saved_value("rival_plot_exposed")==true ) then --human cao cao 
							if not qliubei_faction:is_human() then 
								return MakeDeployable("3k_main_template_historical_zhang_fei_hero_fire") 
							else
								return true;
							end
						end
					else
					CusLog("..LiuBei and Yuan shu at war??");
					end
				end
            end
            return false
        end,
		function()
			CusLog("??? Callback TigersWolfPlotListener ###")
			local triggered = TigerWolf()
			CusLog(" setting tigerwolf_started :"..tostring(triggered))
            cm:set_saved_value("tigerwolf_started", triggered);
		end,
		false
    )
end



local function XuPlot2Variables()
	CusLog("  XuCaoPlot2 tigerwolf_started= "..tostring(cm:get_saved_value("tigerwolf_started")))
    CusLog("  XuCaoPlot2 tigerwolf_success= "..tostring(cm:get_saved_value("tigerwolf_success"))) -- unused really?
	 CusLog(" *XuCaoPlot2 beef_ran= "..tostring(cm:get_saved_value("beef_ran"))) --from xu lubu post
	 CusLog(" XuCaoPlot2 YuanShu_ahead= "..tostring(cm:get_saved_value("YuanShu_ahead"))) --for SunCe
end


-- when the game loads run these functions:
cm:add_first_tick_callback(
	function(context)
		IniDebugger()
		XuPlot2Variables()
        if context:query_model():calendar_year() > 193 and context:query_model():calendar_year() < 201 then
			TigersWolfPlotListener()
			CaoCaoTigerWolfChoiceListener()
			LiuBeiTigerWolfChoiceListener()
			YuanShuTigerWolfChoiceListener()
		end


		--TMP
		--CusLog("TMPPPP MakeDeployable")
		--MakeDeployable("3k_main_template_historical_zhang_fei_hero_fire") 
	end
)

