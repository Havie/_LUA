
--> XU PEACE (194)
-- Responsible for knowing if PuYang can happen
-- Tracks what should happen if LuBu player/ai emerges
-- Fires dilemma for Human CaoCao to make peace or auto does for AI
-- Handles TaoQians death and Liu Beis confederation
local printStatements=false;



local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_xu_peace.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
		local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
		local header=" (xu_peace): "
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
	local file = io.open("@havie_xu_peace.txt", "w+")
	file:close()
	CusLog("---Begin File----")
end



local function confederateinXu() --feel like this needs some safe guards
    CusLog("Running confederateinXu")

    local q_taoqian = cm:query_faction("3k_main_faction_tao_qian")
    local q_caocao = cm:query_faction("3k_main_faction_cao_cao")
    local q_liubei = cm:query_faction("3k_main_faction_liu_bei")

	--get rid of any unwanted regions he may have earned 
	CusLog("Test abandon ")
	AbandonLands("3k_main_faction_liu_bei") 
	
    local taoqian_character = cm:query_model():character_for_template("3k_main_template_historical_tao_qian_hero_water")
    cm:modify_character(taoqian_character):kill_character(false)
    cm:force_confederation("3k_main_faction_liu_bei","3k_main_faction_tao_qian")

	--ToDo someday
	--Fire an event? globally.


	local q_dongfaction= cm:query_faction("3k_main_faction_dong_zhuo")
	if q_dongfaction:is_human() then -- 194 already past this
		--Trigger incident of thanks
		if cm:get_saved_value("lubu_took_puyang") then 
			CusLog("..trigger 3k_lua_liubei_thanks_lubu")
			cm:trigger_incident("3k_main_faction_dong_zhuo", "3k_lua_liubei_thanks_lubu", true)
		else
			CusLog("value lubu_took_puyang="..tostring(cm:get_saved_value("lubu_took_puyang")))
		end
	end


	--Get the chens ready (or could do when confederated)
	cm:set_saved_value("SpawnTwoChens",true)  --Move Ze Rong to Jian'An in south if possible
	register_twochens_emergent_faction_2()


    CusLog("Finished confederateinXu")

end

--Can use this for 194 AWB liu bei, OR just give him a dilemma to grant them guangling??
function SpawnChenGuiAndDeng()
	
	CusLog("Running SpawnChenGuiAndDeng")
	local qchar1= getQChar("3k_dlc_04_template_historical_chen_gui_water")
	local qchar2= getQChar("3k_dlc04_template_historical_chen_deng_yuanlong_water")
	local q_taoqian=getQChar("3k_main_template_historical_tao_qian_hero_water")
	local q_liubeiFaction=cm:query_faction("3k_main_faction_liu_bei")
	local chosenFaction="none"

	if not q_taoqian:is_null_interface() then 
		if not q_taoqian:is_dead() and not q_taoqian:faction():is_dead() then 
			chosenFaction= q_taoqian:faction():name()
			--Give TaoQian a satifaction bonus
			cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", q_taoqian:faction():name() , 25)
		end
	elseif not q_liubeiFaction:is_null_interface() then 
			if not q_liubeiFaction:is_dead() then 
				chosenFaction="3k_main_faction_liu_bei"
			end
	end

	if chosenFaction~="none" then 
		if not qchar1:is_null_interface() then 
			MoveCharToFactionHard(qchar1:generation_template_key(), chosenFaction)
		else 
			CusLog("@Warning: Couldnt find ".."3k_dlc_04_template_historical_chen_gui_water".." Spawning in:"..tostring(chosenFaction));
			cdir_events_manager:spawn_character_subtype_template_in_faction(chosenFaction, "3k_general_water", "3k_dlc_04_template_historical_chen_gui_water");
		
		end
		if not qchar2:is_null_interface() then 
			MoveCharToFactionHard(qchar2:generation_template_key(), chosenFaction)
		else 
			CusLog("@Warning: Couldnt find ".."3k_dlc04_template_historical_chen_deng_yuanlong_water".." Spawning in:"..tostring(chosenFaction));
			cdir_events_manager:spawn_character_subtype_template_in_faction(chosenFaction, "3k_general_water", "3k_dlc04_template_historical_chen_deng_yuanlong_water");
		
		end
		ChangeRelations("3k_dlc_04_template_historical_chen_gui_water", "3k_dlc04_template_historical_chen_deng_yuanlong_water", "3k_main_relationship_trigger_set_scripted_event_family_member") 
       
	end



	--Register them now for once liu bei confeds? or do elsewhere for AWB


	CusLog("Finish SpawnChenGuiAndDeng")
end

local function AiGivesBackXu() --Need to test
    CusLog("Running AiGivesBackXu")
	local playersFactionsTable = cm:get_human_factions()
    local playerFaction = playersFactionsTable[1]
    local q_taoqian = cm:query_faction("3k_main_faction_tao_qian")
    local q_caocao = cm:query_faction("3k_main_faction_cao_cao")
    local q_liubei = cm:query_faction("3k_main_faction_liu_bei")

    local caocao_character = cm:query_model():character_for_template("3k_main_template_historical_cao_cao_hero_earth")
    local taoqian_character = cm:query_model():character_for_template("3k_main_template_historical_tao_qian_hero_water")

	if q_taoqian:is_human() == false and q_caocao:is_human() == false and q_liubei:is_human() == false then

            -- give regions to proper owners for further Xu Dilemmas 
            local pengcheng_region =cm:query_region(XIAOPEICITY)
            local pengcheng_region2 =cm:query_region("3k_main_penchang_resource_2")

            --set up pengcheng
            if pengcheng_region:owning_faction():name() == taoqian_character:faction():name() then
                CusLog("do nothing , tao qian owns peng cheng town")
            else
                CusLog("--Want to Transfer Region2--" )
                cm:modify_model():get_modify_region(pengcheng_region):settlement_gifted_as_if_by_payload(cm:modify_faction(taoqian_character:faction():name()))
                CusLog("--transferred Region2--")
            end

            --set up pengcheng farm
            if pengcheng_region2:owning_faction():name() == taoqian_character:faction():name() then
                CusLog("do nothing , tao qian owns peng cheng farm")
            else
                CusLog("--Want to Transfer Region3--" )
                cm:modify_model():get_modify_region(pengcheng_region2):settlement_gifted_as_if_by_payload(cm:modify_faction(taoqian_character:faction():name()))
                CusLog("--transferred Region3--")
            end

			cm:set_saved_value("time_to_confederate", true);
			
	end
	CusLog("Finished AiGivesBackXu")
end

local function confirmPeace()
	CusLog("Running ConfirmPeace")
    local q_taoqian = cm:query_faction("3k_main_faction_tao_qian")
	local q_liubei = cm:query_faction("3k_main_faction_liu_bei")
	local q_kongrong = cm:query_faction("3k_main_faction_kong_rong") -- just in case they were dragged in
    local q_caocao = cm:query_faction("3k_main_faction_cao_cao")

	--Does it matter if they have war?
	cm:modify_faction(q_caocao):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_taoqian, ""); 
	cm:modify_faction(q_caocao):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_liubei, "");
	cm:modify_faction(q_caocao):apply_automatic_diplomatic_deal("data_defined_situation_peace", q_kongrong, ""); 

	--Fail Safe
	cm:apply_automatic_deal_between_factions("3k_main_faction_cao_cao", q_taoqian:name(), "data_defined_situation_proposer_declares_peace_against_target", true);
	cm:apply_automatic_deal_between_factions("3k_main_faction_cao_cao", "3k_main_faction_liu_bei", "data_defined_situation_proposer_declares_peace_against_target", true);
	cm:apply_automatic_deal_between_factions("3k_main_faction_cao_cao", "3k_main_faction_kong_rong", "data_defined_situation_proposer_declares_peace_against_target", true);

	AiGivesBackXu()
	CusLog("Finished ConfirmPeace")

	--Need to register Zhang Ba at Dong iron Miene
	cm:set_saved_value("Spawnzangba",true) -- maybe a little RNG on his spawn 
	register_zangba_emergent_faction_2()

end



local function checkCaoCaosLands()
	CusLog(" Run checkCaoCaosLands")
    local countLands=0;
	local yingchuan1_region =cm:query_region("3k_main_yingchuan_resource_1")
    local yingchuan2_region =cm:query_region(XUCHANG)
	local dong_region = cm:query_region(PUYANG)

	if (yingchuan1_region:owning_faction():name() == "3k_main_faction_cao_cao") then 
		countLands = countLands+1;
	elseif (yingchuan1_region:owning_faction():is_human()) then 
		return false; --if player is not cao cao and owns ying chuan farm, abort
	end

	if (yingchuan2_region:owning_faction():name() == "3k_main_faction_cao_cao") then 
		countLands = countLands+1;
	elseif not yingchuan2_region:owning_faction():is_human() and yingchuan2_region:owning_faction():name()~="3k_main_faction_liu_dai" and cm:get_saved_value("ported_cao")~=true  then 
		CusLog("lets move one of Cao Caos armies here")
		local qCaoCao= getQChar("3k_main_template_historical_cao_cao_hero_earth")
		if( not qCaoCao:faction():is_human()) then 
			local found_pos, x, y = qCaoCao:faction():get_valid_spawn_location_in_region(yingchuan2_region:name(), false);
			CusLog("we found locs:"..tostring(x).." , "..tostring(y))
			if qCaoCao:has_military_force() then 
				cm:modify_model():get_modify_character(qCaoCao):teleport_to(x,y) 
			end
			CusLog("...Lets also try to deploy some important generals: ")
			local yujin= getQChar("3k_main_template_historical_yu_jin_hero_metal")
			local dianwei= getQChar("3k_main_template_historical_dian_wei_hero_wood")
			local dun= getQChar("3k_main_template_historical_xiahou_dun_hero_wood")
			local yuan = getQChar("3k_main_template_historical_xiahou_yuan_hero_fire")
			local chu = getQChar("3k_main_template_historical_xu_chu_hero_wood")
			local spawned=0;
			local unit_list="3k_main_unit_fire_mercenary_cavalry_captain,3k_main_unit_fire_tiger_and_leopard_cavalry,3k_main_unit_wood_heavy_ji_infantry,3k_main_unit_metal_sabre_infantry"
			CusLog("..trying yujin "..tostring(spawned))
			if not yujin:is_null_interface() then 
				if not yujin:is_dead() and not yujin:faction():is_human() and not yujin:has_military_force() then 
					cm:create_force_with_existing_general(yujin:cqi(), "3k_main_faction_cao_cao", unit_list, XUCHANG, x+2, y-1,"3k__yu_jin_01",nil, 100);
					spawned= spawned+1;
				elseif not yujin:is_dead() and yujin:faction()~="3k_main_faction_cao_cao" then 
					MoveCharToFaction("3k_main_template_historical_yu_jin_hero_metal", "3k_main_faction_cao_cao") --Wont move if in player faction
				else
					CusLog("Cant, hes  in.."..tostring(yujin:faction():name()))
				end
			end
			CusLog("..trying dianwei "..tostring(spawned))
			if not dianwei:is_null_interface() and spawned<2 then 
				if not dianwei:is_dead() and not dianwei:faction():is_human() and not dianwei:has_military_force() then 
					cm:create_force_with_existing_general(dianwei:cqi(), "3k_main_faction_cao_cao", unit_list,  XUCHANG, x+3, y+1,"3k_dianwei_01",nil, 100);
					spawned= spawned+1;
				elseif not dianwei:is_dead() and dianwei:faction()~="3k_main_faction_cao_cao" then 
					MoveCharToFaction("3k_main_template_historical_dian_wei_hero_wood", "3k_main_faction_cao_cao")--Wont move if in player faction
				else
					CusLog("Cant, hes  in.."..tostring(dianwei:faction():name()))
				end
			end
			CusLog("..trying dun "..tostring(spawned))
			if not dun:is_null_interface() and spawned<2 then 
				if not dun:is_dead() and not dun:faction():is_human() and not dun:has_military_force() then 
					CusLog("Dun militry force="..tostring(dun:has_military_force()))
					cm:create_force_with_existing_general(dun:cqi(), "3k_main_faction_cao_cao", unit_list,  XUCHANG, x-2, y-2,"3k_dun_01",nil, 100);
					spawned= spawned+1;
				else
					CusLog("Cant, hes  in.."..tostring(dun:faction():name()))
				end
			end
			CusLog("..trying yuan "..tostring(spawned))
			if not yuan:is_null_interface() and spawned<2 then 
				if not yuan:is_dead() and not yuan:faction():is_human() and not yuan:has_military_force() then 
					cm:create_force_with_existing_general(yuan:cqi(), "3k_main_faction_cao_cao", unit_list,  XUCHANG, x+2, y+2,"3k_yuan_01",nil, 100);
					spawned= spawned+1;
				else
					CusLog("Cant, hes  in.."..tostring(yuan:faction():name()))
				end
			end
			if not chu:is_null_interface() and spawned<2 then 
				if not chu:is_dead() and not chu:faction():is_human() and not chu:has_military_force() then 
					cm:create_force_with_existing_general(chu:cqi(), "3k_main_faction_cao_cao", unit_list,  XUCHANG, x-3, y-4,"3k_chu_01",nil, 100);
					spawned= spawned+1;
				elseif not chu:is_dead() and chu:faction()~="3k_main_faction_cao_cao" then 
					MoveCharToFaction("3k_main_template_historical_xu_chu_hero_wood", "3k_main_faction_cao_cao")--Wont move if in player faction
				else
					CusLog("Cant, hes  in.."..tostring(yuan:faction():name()))
				end
			else 
				CusLog("maybe we should spawn XuChu in Cao Cao Faction?")
			end
			--Declare war on whoever owns it 
			if not cm:query_faction("3k_main_faction_cao_cao"):has_specified_diplomatic_deal_with("treaty_components_war",yingchuan2_region:owning_faction() ) then
				CusLog("Make War..")
				cm:modify_faction(cm:query_faction("3k_main_faction_cao_cao")):apply_automatic_diplomatic_deal("data_defined_situation_war", cm:query_faction(yingchuan2_region:owning_faction():name()), "");
				cm:modify_faction(cm:query_faction(yingchuan2_region:owning_faction():name())):apply_automatic_diplomatic_deal("data_defined_situation_war", cm:query_faction("3k_main_faction_cao_cao"), "");
				cm:apply_automatic_deal_between_factions("3k_main_faction_cao_cao", yingchuan2_region:owning_faction():name(), "data_defined_situation_war", false);
   
			end
			cm:set_saved_value("ported_cao",true) -- stop this from happening again 
		else 
			CusLog("...Cao Cao is human ?")
		end  
		--Move Other armies out of there:
		CusLog("..Moving whoevers armies are there away so cao cao doesnt run")
		local ownerFaction= yingchuan2_region:owning_faction();
		for i=0, ownerFaction:character_list():num_items()-1 do
			local qchara=ownerFaction:character_list():item_at(i);
			if(qchara:region():name() == XUCHANG and qchara:has_military_force()) then 
				--teleport army to louyang? lol... or chen..idfk Could move them to another faction and back too
				if( not qchara:is_faction_leader() and not qchara:is_armed_citizenry() ) then 
					CusLog("..Moving this character around:?.."..tostring(qchara:generation_template_key()))
					local mqchar = cm:modify_character(qchar) -- convert to a modifiable character
					mqchar:set_is_deployable(true) -- keep this here, CA does before 
					mqchar:move_to_faction_and_make_recruited("3k_main_faction_han_empire")
					mqchar:set_is_deployable(true)
					mqchar:move_to_faction_and_make_recruited(ownerFaction:name())
				elseif not qchara:is_armed_citizenry() then 
					CusLog("..Moving this char to Louyang:"..qchara:generation_template_key())
					found_pos, x, y = ownerFaction:get_valid_spawn_location_in_region("3k_main_luoyang_capital", false);
					cm:modify_model():get_modify_character(qchara):teleport_to(x,y);
				else
					CusLog("..! Didnt move becuz was armted citizen="..tostring(qchara:generation_template_key()))
				end
			end
		end
		cm:apply_effect_bundle("3k_main_payload_faction_debuff_lua", ownerFaction:name() , 16)  
		CusLog("..Debuffed faction:"..tostring(ownerFaction:name()))
	end

	if (dong_region:owning_faction():name() == "3k_main_faction_cao_cao") then 
		countLands = countLands+1;
	end
	
	CusLog("Finished checkCaoCaosLands="..tostring(countLands>0))
	return countLands>0

end
local function SetUpPuyangEvent()-- CaoCao is at war with tao qian for sure here cant be DLC05 
	CusLog("Running SetUpPuyangEvent")
    --Need a check to see if the player is Dong Zhuo and has Lu Bu
	local playersFactionsTable = cm:get_human_factions()
	local playerFaction = playersFactionsTable[1]
    local q_dongfaction = cm:query_faction("3k_main_faction_dong_zhuo")
    local lu_bu_character = cm:query_model():character_for_template("3k_main_template_historical_lu_bu_hero_fire")
	
	if lu_bu_character:is_null_interface() or q_dongfaction:is_null_interface() then
		CusLog("..how the fuck is something null?")
		return;
	end
	

	CusLog("..did lu bu follow story?")

	if(cm:get_saved_value("lubu_knows_zhangmiao") == true) then  -- player followed story everything should be in place
		CusLog("..Triggering Dilemma for LuBu to Take PuYang (1)")
		LuBu4ChoiceMadeListener()
		FireDilemma("3k_lua_lubu_take_puyang_dilemma");
		CusLog("Finished SetUpPuyangEvent=true")
		return true;
	elseif q_dongfaction:is_human() and lu_bu_character:faction():name() == "3k_main_faction_dong_zhuo" then --player messed up story
		CusLog("..didnt follow story, check other conditions")
		--can check certain conditions are met
		--Cao Cao owns Enough lands in area:
		if(checkCaoCaosLands() and lu_bu_character:is_faction_leader() and not cm:get_saved_value("lu_bu_fire_zhang_yang_accepts") and not cm:get_saved_value("lubu_meet_zhangmiao") ) then -- dont want to interrupt story also 
			-- Cao Cao has chen gong to invite lu bu in 
			local qchengong= getQChar("3k_main_template_historical_chen_gong_hero_water")
			if qchengong:is_null_interface() then 
				CusLog("..chen gong is null")
				CusLog("Finished SetUpPuyangEvent=false")
				return false;
			elseif  qchengong:is_dead() then 
				CusLog("..chen gong is dead")
				CusLog("Finished SetUpPuyangEvent=true")
				return false;
			end
			if(qchengong:faction():name()== "3k_main_faction_cao_cao" or qchengong:faction():name()== "3k_main_faction_liu_dai") then --Should be from 193 yan dilemma
				CusLog("..Good, Chen Going is with CaoCao or Zhang Miao")
				local qzhang_miao = getQChar("3k_main_template_historical_zhang_miao_hero_water")
				if( not qzhang_miao:is_null_interface() and not qzhang_miao:is_dead() ) then 
					CusLog("..Triggering Dilemma for LuBu to Take PuYang (2)")
					--Fire Secondary dilemma ? or same?
					LuBu4ChoiceMadeListener()
					 cm:trigger_dilemma(q_dongfaction, "3k_lua_lubu_take_puyang_dilemma", true);
					 CusLog("Finished SetUpPuyangEvent =true")
					return true; -- dont return the dilemma, doesnt work right
				else
					CusLog("..zhang miao isnt around") 
				end
			else
				CusLog("..chen gong isnt with Cao Cao")
			end
		end 
    elseif not lu_bu_character:is_faction_leader() and lu_bu_character:faction():name() ~= q_dongfaction():name()  then  -- if player isnt dong zhuo, move lu bu even if the player has lu bu , event line = priority , wont occur in dlc05 cuz year
		CusLog(".. Lu Bu will be rebelling in yingchuan")
		cm:set_saved_value("lu_bu_to_yingchuan", true);  -- move Lu Bu to Ying Chuan 
		register_lu_bu_emergent_faction_2() -- hope this works asap, and what if its already been registered?
		CusLog("Finished SetUpPuyangEvent=true")
		return true;
	else
		CusLog("@@@..Weve hit an odd issue,Happens when LuBu is under yuan shu/yuan shao as players")
		CusLog("Finished SetUpPuyangEvent=false")
		return false;
    end

	CusLog("Finished SetUpPuyangEvent???")
end


local function liubeiConfedTaoqianListener()
	CusLog("### liubeiConfedTaoqianListener listener loading ###")
	core:remove_listener("liubeiConfedTaoqian")
	core:add_listener(
		"liubeiConfedTaoqian",
		"FactionTurnEnd",
        function(context)
            if context:faction():is_human() == true then  --Does Liu Bei Player get a dilemma or an incident?? --ToDo Investigate
                 if cm:get_saved_value("time_to_confederate") then
                    if context:query_model():calendar_year() <= 199 then
						local rolled_value = cm:random_number( 0, 5 );
						local to_beat=2;
						CusLog("LiuBei Confederate TaoQian Rolled a "..rolled_value.." needs "..to_beat.." to pass")
						if rolled_value > to_beat then 
							return true
						end
                    end
                 end
             end
            return false
		end,
		function()
			CusLog("??? Callback: liubeiConfedTaoqianListener ###")
			confederateinXu()
			cm:set_saved_value("time_to_confederate",false)
            core:remove_listener("liubeiConfedTaoqian");
           CusLog("### Finished liubeiConfedTaoqianListener ")
		end,
		true
    )
end

local function PlayerLiuBeiThanksLuBuListener() -- Need to test
	CusLog("### PlayerLiuBeiThanksLuBuListener listener loading ###")
	core:remove_listener("AWBLiuBeiThanksLuBu")
	core:add_listener(
		"AWBLiuBeiThanksLuBu",
		"FactionTurnEnd",
        function(context)
            if context:faction():is_human() and context:faction():name()=="3k_main_faction_liu_bei" then  
                 if cm:get_saved_value("ai_lubu_emerged") and cm:get_saved_value("liubei_thanks_lubu")~=true  then
					if context:query_model():calendar_year() <= 199 then
						return true --190
					end
				elseif context:query_model():turn_number()<10 and cm:get_saved_value("liubei_thanks_lubu")~=true then 
					return true; --AWB
                 end
             end
            return false
		end,
		function()
			CusLog("??? Callback: PlayerLiuBeiThanksLuBuListener ###")
			cm:trigger_incident("3k_main_faction_liu_bei", "3k_lua_liubei_thanks_lubu2", true )
			cm:set_saved_value("liubei_thanks_lubu",true)
			core:remove_listener("AWBLiuBeiThanksLuBu");
			
           CusLog("removed listener")
		end,
		true
    )
end


function CaoCaoPeaceChoiceMadeListener()
	CusLog("### CaoCaoPeaceChoiceMadeListener loading ###")
	core:remove_listener("DilemmaChoiceMadeCaoCaoPeace")
    core:add_listener(
    "DilemmaChoiceMadeCaoCaoPeace",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_lua_cao_cao_puyang_dilemma"
    end,
    function(context)
        CusLog("..! choice was:" .. tostring(context:choice()))
        if context:choice() == 0 then
           confirmPeace()  
	    end
         core:remove_listener("DilemmaChoiceMadeCaoCaoPeace");
    end,
    true
 );
end

function LuBuEmergesListener() -- Handles making peace between CaoCao and TaoQian, and starts confederation
	CusLog("### LuBuEmergesListener loading ###")
	core:remove_listener("LuBuEmerges")
	core:add_listener(
		"LuBuEmerges",
		"FactionTurnEnd",
		function(context)
			 return cm:get_saved_value("peace_needed")==true
		end,
		function(context)
			CusLog("### Passed LuBuEmergesListener ###")
			CusLog(" ..NEXT TIME THRU VERIFY TRIGGERED")
			local caoFaction = cm:query_faction("3k_main_faction_cao_cao")
			local liuFaction = cm:query_faction("3k_main_faction_liu_bei")	
			local triggered=true;
			if caoFaction:is_human() then 
				CaoCaoPeaceChoiceMadeListener()
				triggered=cm:trigger_dilemma(caoFaction, "3k_lua_caocao_puyang_dilemma", true) -- TO:DO create in pack 
			else
				confirmPeace()
			end 
			 if liuFaction:is_human() then 
				triggered=cm:trigger_incident(liuFaction, "3k_lua_liubei_appreciates_lubu", true) -- TO:DO create in pack 
			 end 
			 local taoqian_character = cm:query_model():character_for_template("3k_main_template_historical_tao_qian_hero_water")
			 local taoqian_faction = taoqian_character:faction();
			 if not taoqian_faction:is_human() then 
				 --time to confed    
				 CusLog("Time to confederate")
				cm:set_saved_value("time_to_confederate", true);				 
			 end
			 CusLog("NEXT TIME ARROUND TRIGGERED Better=rue, it ="..tostring(triggered))
			cm:set_saved_value("peace_needed",triggered)
			CusLog("### Fnished LuBuEmergesListener ###")
		end,
		false -- does not persist
    )
end

function CanPuyangHappenListener()
	CusLog("### CanPuyangHappenListener listener loading ###")
	core:remove_listener("CanPuyangHappen")
	core:add_listener(
		"CanPuyangHappen",
		"FactionTurnEnd",
        function(context)
            if context:faction():is_human() == true then 
                 if cm:get_saved_value("xu_at_war")==true then
					CusLog("Xu was at war")
					if context:query_model():calendar_year() >= 194 and context:query_model():calendar_year() <= 197 then
						local taoqian_character = cm:query_model():character_for_template("3k_main_template_historical_tao_qian_hero_water")
						local taoqian_faction = taoqian_character:faction();
						local qlubu= getQChar("3k_main_template_historical_lu_bu_hero_fire")
						if cm:query_faction("3k_main_faction_cao_cao"):has_specified_diplomatic_deal_with("treaty_components_war",taoqian_faction) then
						   if qlubu:is_faction_leader() then 
								CusLog("..right conditions for XuStory to Continue")
								return SetUpPuyangEvent()
						   elseif not cm:query_faction("3k_main_faction_dong_zhuo"):is_human() then --Idk ab AI lubu/LiJue?
								return SetUpPuyangEvent()
							end
						else -- the AI made peace ?
							CusLog("..the AI CaoCao is no longer at war w taoQian, create alternate path") 
							local qlubu = cm:query_model():character_for_template("3k_main_template_historical_lu_bu_hero_fire")
							if qlubu:is_faction_leader() and qlubu:faction():is_human() then 
								cm:set_saved_value("xu_at_war",false) --end this listener 
								cm:trigger_dilemma(qlubu:faction():name(), "3k_lua_lubu_take_puyang_dilemma_alt", true); --ToDo
							end
                        end
                    end
				else
					CusLog("xu_at_war="..tostring(cm:get_saved_value("xu_at_war")))
				end
             end
            return false
		end,
		function()
			CusLog("??? Callback: CanPuyangHappenListener  ###")
			cm:set_saved_value("xu_at_war",false)
            core:remove_listener("CanPuyangHappen");
		end,
		true
    )
end

function XuEventPeaceListener() -- Called from Xu war 
	CusLog("### XuEventPeaceListener listener loading ###")
	core:remove_listener("XuEventPeace")
	core:add_listener(
		"XuEventPeace",
		"IncidentOccuredEvent",
		function(context)
			 return context:incident() == "3k_main_historical_cao_father_killed_npc_incident_havie"
		end,
		function()
			CusLog("### Saving custom variable ###")
            cm:set_saved_value("xu_at_war", true);
			peace194Listener() -- incase we somehow play from 190 to now with all auto resolves?
            core:remove_listener("XuEventPeace");
		end,
		true
    )
end


local function XuPeaceVariables()
	CusLog("  XuPeace chens_set= "..tostring(cm:get_saved_value("chens_set")))
	CusLog("  XuPeace xu_at_war= "..tostring(cm:get_saved_value("xu_at_war")))
    CusLog("  XuPeace peace_needed= "..tostring(cm:get_saved_value("peace_needed")))   
	CusLog("  XuPeace time_to_confederate= "..tostring(cm:get_saved_value("time_to_confederate")))
	CusLog("  XuPeace AWBLiuBeiThanksLuBu= "..tostring(cm:get_saved_value("AWBLiuBeiThanksLuBu")))
end




-- when the game loads run these functions:
cm:add_first_tick_callback(
	function(context)
		IniDebugger()
		XuPeaceVariables()
		 if context:query_model():turn_number()==1 and cm:get_saved_value("chens_set")~=true then 
			if context:query_model():calendar_year()==190 then 
				--Move ChengDeng/Gui into tao qian faction 
				SpawnChenGuiAndDeng()
			elseif context:query_model():calendar_year()==194 then 
				--SetUpChenDeng/ChenGui as a faction 
				CusLog("trying to spawn 2 chens")
				cm:set_saved_value("TwoChensSpawned",true)
				register_twochens_emergent_faction_2() --Crashes in 194.. IDK???
			end
			cm:set_saved_value("chens_set",true)
		 end
		 CusLog("Passed")
		if context:query_model():calendar_year() > 189  and context:query_model():calendar_year() < 196 then
			XuEventPeaceListener()  --listens for Cao Songs death- knowing war over xu has probably begun (humans?)
			CanPuyangHappenListener()
			PlayerLiuBeiThanksLuBuListener()
        end
		 if context:query_model():calendar_year() > 192  and context:query_model():calendar_year() < 198 then
            LuBuEmergesListener()
			liubeiConfedTaoqianListener()
			PlayerLiuBeiThanksLuBuListener()
		end


		--TMP
		--CusLog("TMP setting peace_needed and time_to_confederate to False")
		--cm:set_saved_value("peace_needed",false)
		--cm:set_saved_value("time_to_confederate",false)
    end
)