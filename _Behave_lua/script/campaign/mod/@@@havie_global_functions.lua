---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			--Havies Global Functions and resources
----- Description: 	Global Helper Functions and keys i reuse often
-----				
-----			
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
--Important names to keep in one place, if CA makes map changes, only have to update in 1 place 
CHENLIU= "3k_main_yingchuan_resource_1"
XUCHANG= "3k_main_yingchuan_capital"
DONGIRONMINE= "3k_main_dongjun_resource_1"
PENGCHENGTEMPLE= "3k_main_penchang_resource_1"
PENGCHENGFARM = "3k_main_penchang_resource_2"
XIAOPEICITY = "3k_main_penchang_capital"
CHENCITY= "3k_main_chenjun_capital"
XIAPICITY = "3k_main_donghai_capital"
LUOYANGLUMBER = "3k_main_chenjun_resource_3"
XUFISHPORT = "3k_main_donghai_resource_1"
PUYANG="3k_main_dongjun_capital"
MTU=false;
--cm:modify_character(qchar)

startTime=os.clock() --can put in CM:val if needed ?
local printStatements=false;

GLOBALFUNCTIONS=true;

local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_globalFunctions.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
		local header=" ($$ globalFunctions): "
		local line= time..header..text
		file:write(line.."\n")
		file:close()
		ModLog(header..text)
    end
end

local function IniDebugger()
	printStatements=true;
	local file = io.open("@havie_globalFunctions.txt", "w+")
	file:close()
	CusLog("---Begin File----")
end

function ForceADeal(Factionkey1, Factionkey2, dealKey)
	cm:modify_faction(Factionkey1):apply_automatic_diplomatic_deal(dealKey, Factionkey2, ""); 
	cm:apply_automatic_deal_between_factions(Factionkey1, Factionkey2, dealKey, true);
	cm:modify_faction(Factionkey1):apply_automatic_diplomatic_deal(dealKey, Factionkey2, ""); 
	cm:apply_automatic_deal_between_factions(Factionkey1, Factionkey2, dealKey, true);
	cm:apply_automatic_deal_between_factions(Factionkey1, Factionkey2, dealKey, false);
	cm:modify_faction(Factionkey1):apply_automatic_diplomatic_deal(dealKey, Factionkey2, ""); 
	cm:modify_faction(Factionkey2):apply_automatic_diplomatic_deal(dealKey, Factionkey1, ""); 
	CusLog("Ran force a Deal")	
end

function BreakDeal(modifed_faction, recipient , cqi)
	--Breaks an deal with the recipient
	function campaign_mercenary_treaties:break_treaty(modifed_faction,recipient,cqi)
		local deal_key="data_defined_situation_break_deal"

		modifed_faction:apply_automatic_diplomatic_deal(deal_key, cm:query_faction(recipient),"deal_cqi:"..tostring(cqi));	
	end
end

function LuBuJoinsYou(factionName)
	CusLog("Begin LuBuJoinsYou")
	local qChar=getQChar2("3k_main_template_historical_lu_bu_hero_fire")
	if qChar~=nil then 
		MoveCharToFaction(qChar:generation_template_key(), factionName)
	else --if hes dead hes gotta spawn in again cuz of the event logic 
		cdir_events_manager:spawn_character_subtype_template_in_faction(factionName, "3k_general_fire", "3k_main_template_historical_lu_bu_hero_fire");
	end
	qChar=getQChar2("3k_main_template_historical_zhang_liao_hero_metal")
	if qChar~=nil then 
		--pointless cause guanxi events will move him right back lol
		--if RNGHelper(5) or factionName~="3k_main_faction_yuan_shu" then --50/50 chance he goes to Cao Cao from yuanshu event
			MoveCharToFaction(qChar:generation_template_key(), factionName)
		--else
		--	MoveCharToFaction(qChar:generation_template_key(), "3k_main_faction_cao_cao")
		--end
	else
		CusLog("Zhamgliao dead?")
		if RNGHelper(7) then 
			--cdir_events_manager:spawn_character_subtype_template_in_faction(factionName, "3k_general_metal", "3k_main_template_historical_zhang_liao_hero_metal");
		end
	end
	qChar=getQChar2("3k_main_template_historical_chen_gong_hero_water")
	if qChar~=nil then 
		MoveCharToFaction(qChar:generation_template_key(), factionName)
	else
		CusLog("Chengong dead?")
		if RNGHelper(7) then 
			--cdir_events_manager:spawn_character_subtype_template_in_faction(factionName, "3k_general_water", "3k_main_template_historical_chen_gong_hero_water");
		end
	end
	qChar=getQChar2("3k_main_template_historical_lady_diao_chan_hero_water")
	if qChar~=nil then 
		MoveCharToFaction(qChar:generation_template_key(), factionName)
	else
		CusLog("DiaoChans dead?")
		if RNGHelper(8) then 
		--	cdir_events_manager:spawn_character_subtype_template_in_faction(factionName, "3k_general_water", "3k_main_template_historical_diao_chan_hero_water");
		end
	end
	qChar=getQChar2("3k_main_template_historical_gao_shun_hero_fire")
	if qChar~=nil then 
		MoveCharToFaction(qChar:generation_template_key(), factionName)
	else
		CusLog("Gaoshun dead?")
		if RNGHelper(8) then 
			--cdir_events_manager:spawn_character_subtype_template_in_faction(factionName, "3k_general_fire", "3k_main_template_historical_gao_shun_hero_fire");
		end
	end
	qChar=getQChar2("3k_main_template_historical_zhang_miao_hero_water")
	if qChar~=nil then 
		MoveCharToFaction(qChar:generation_template_key(), factionName)
	else
		CusLog("Zhangmiao dead?")
		if RNGHelper(8) then 
			--cdir_events_manager:spawn_character_subtype_template_in_faction(factionName, "3k_general_water", "3k_main_template_historical_zhang_miao_hero_water");
		end
	end
	qChar=getQChar2("3k_dlc05_template_historical_hou_cheng_hero_wood")
	if qChar~=nil then 
		MoveCharToFaction(qChar:generation_template_key(), factionName)
	end
	qChar=getQChar2("3k_main_template_historical_hao_meng_hero_fire")
	if qChar~=nil then 
		MoveCharToFaction(qChar:generation_template_key(), factionName)
	end

	CusLog("End LuBuJoinsYou")
end
function FindFreeGeneral(factionName)
		CusLog("Start FindFreeGeneral for "..tostring(factionName))
		local qFaction= cm:query_faction(factionName)
		if not qFaction:is_null_interface() then 
			local generals ={}
			--CusLog("size ="..tostring(qFaction:military_force_list():num_items() -1))
			
			for i=0 , qFaction:military_force_list():num_items() -1 do 
				--CusLog("found force #"..tostring(i).." in faction "..qFaction:name())
				local m_force= qFaction:military_force_list():item_at(i)
				if not m_force:is_armed_citizenry() then      
				--	CusLog("Looking through Army # "..tostring(i))
					for j=0, m_force:character_list():num_items()-1 do 
						local qgeneral= m_force:character_list():item_at(j)
						generals[tostring(qgeneral:cqi())] =true --eilimate the deployed generals 
					end
				end
			end
			--CusLog("see whos left")
			local available ={}
			for i=0, qFaction:character_list():num_items()-1 do 
					local qChar= qFaction:character_list():item_at(i);
				--	CusLog("grabbed a character")
					if not generals[tostring(qChar:cqi())] and (qChar:active_assignment():is_idle_assignment() or qChar:active_assignment():is_null_interface())  then 
						if #available>1 then 
							if not string.find(qChar:generation_template_key(), "generic") then
							--	CusLog("Found someone non generic to spawn!"..tostring(qChar:generation_template_key()))
								table.insert(available, qChar:cqi()); --proritize non generics
							end
						else
							--CusLog("Found someone to spawn!"..tostring(qChar:generation_template_key()))
							table.insert(available, qChar:cqi());
						end
					end
			end
			if #available >0 then 
				local random= math.floor(cm:random_number(1, #available))
				--CusLog("random="..tostring(random));
				local target_character = cm:query_character(available[random]);
				if not target_character:is_null_interface() then 
					CusLog("chosen Character="..tostring(target_character:generation_template_key()))
					return target_character;
				end 
			end 
		end
	CusLog("End FindFreeGeneral =failed")
	return nil;
end

function FindRandomRegionOwned(factionName)
	CusLog("Finding random region for "..tostring(factionName))
	local qfaction= cm:query_faction(factionName)

	local regions ={}
	if not qfaction:is_null_interface()  then  
		for i = 0,qfaction:faction_province_list():num_items() - 1 do -- Go through each Province
			local province_key = qfaction:faction_province_list():item_at(i);
			 -- CusLog("$looking at Province #:"..tostring(i).."  ="..tostring(province_key))
			for i = 0, province_key:region_list():num_items() - 1 do -- Go through each region in that province
				-- CusLog("$$looping: x" ..tostring(i))
				local region_key = province_key:region_list():item_at(i);
				if(not region_key:is_null_interface()) then 
					local region_name = region_key:name()
					table.insert(regions, region_name)
				end
			end	
		end
	end

	if #regions >0 then 
		local random= math.floor(cm:random_number(1, #regions))
		local target_region = cm:query_region(regions[random]);
		if target_region~= nil and not target_region:is_null_interface() then 
			CusLog("chosen Region="..tostring(regions[random]))
			return target_region;
		end 

	end 
	CusLog("Failed to find region")
	return nil;
end

function CheckCharacterListForAnc(factionName, ancName,  category )
	

		local qFaction=cm:query_faction(factionName)
		for i=0, qFaction:character_list():num_items()-1 do 
			local qchar=qFaction:character_list():item_at(i);
			CusLog("looking at:"..tostring(qchar:generation_template_key()))
			--if not qchar:is_dead() then 
				--CusLog("not dead or armed citizen")
				local ceo_manager= qchar:ceo_management()
				for j=0, ceo_manager:all_ceos():num_items()-1 do
					--CusLog(" in j loop")
					local ceo= ceo_manager:all_ceos():item_at(j);
					if ceo:category_key() == category then 
						CusLog(qchar:generation_template_key().." has:"..tostring(ceo:ceo_data_key()).."  category:"..tostring(ceo:category_key()))
					end
					if ceo:ceo_data_key()==ancName then 
						CusLog("FOUND!!"..qchar:generation_template_key().." has "..ancName);
					end
				end
			--end
		end

end

function FindAncAccessory(ancName, category)
	CusLog("Running FindAncAccessory"..ancName.."  "..category)
	--3k_main_ceo_category_ancillary_accessory
	--3k_main_ceo_category_traits_personality
	--3k_main_ceo_category_childhood
	--3k_main_ceo_category_class
	--3k_main_ceo_category_career
	--3k_main_ceo_category_gender
	--3k_main_ceo_category_potential
	--3k_main_ceo_category_protagonist
	--3k_main_ceo_category_wealth
	--3k_main_ceo_category_traits_physical
	--3k_main_ceo_category_equipment_permissions
	--3k_main_ceo_category_ancillary_weapon
	--3k_main_ceo_category_ancillary_armour
	--3k_main_ceo_category_ancillary_mount
	--3k_dlc04_ceo_category_political_support

	local factionName=""
	
	local world = cm:query_model():world()
	if not world:is_null_interface() then 
		for i=0, world:faction_list():num_items()-1 do
			local qFaction = world:faction_list():item_at(i)
			--CusLog("enter faction")
			--if not qFaction:is_human() then --Dont destroy players seal
				-- ceo_manager:all_ceos_for_category("3k_main_ceo_category_ancillary_accessory"):num_items()-1 do
				for j=0, qFaction:ceo_management():all_ceos_for_category(category):num_items()-1 do-- Need to query by category
					local anc= qFaction:ceo_management():all_ceos_for_category(category):item_at(j)
					--CusLog("ANC !"..tostring(anc:ceo_data_key()))
					if anc:ceo_data_key() ==ancName then 
						CusLog(qFaction:name().." Had ".. ancName);
						--anc:equipped_in_slot() --QUERY_CEO_EQUIPMENT_SLOT_SCRIPT_INTERFACE
						factionName=qFaction:name();
						--BREAK
						--j=qFaction:ceo_management():all_ceos_for_category(category):num_items();
						return qFaction:name();
					end
				end
			--end	
		end
	end 
--[[

	if ancName == "3k_main_ancillary_mount_red_hare" then 
		local qchar = cm:query_model():character_for_template("3k_main_template_historical_lu_bu_hero_fire")
		if not qchar:is_null_interface() then   
			if(not qchar:is_dead()) then
				local ceo_manager= qchar:ceo_management()
				for i=0, ceo_manager:all_ceos():num_items()-1 do
					local ceo= ceo_manager:all_ceos():item_at(i);
					--CusLog("Lubu has:"..tostring(ceo:ceo_data_key()).."  category:"..tostring(ceo:category_key()))
				end
				local mlubu= cm:modify_character(qchar) 
				local ceoManager= mlubu:ceo_management();
				--ceoManager:equip_ceo_in_slot()
				--local valid_equipment_slot_for_ceo_category = ancillaries:get_valid_slot_for_category(qchar, "3k_main_ceo_category_ancillary_mount");
				CusLog("equipping redhare")
				ancillaries:equip_ceo_on_character( qchar, "3k_main_ancillary_mount_red_hare", "3k_main_ceo_category_ancillary_mount" )
				CusLog("doesnt.. work ..try to spawn in faction"..tostring(qchar:faction():name()))
				local myFaction = cm:modify_faction(qchar:faction():name())
				local qFaction= cm:modify_faction(factionName) 
				--myFaction:ceo_management():add_ceo("3k_main_ancillary_mount_red_hare") ancName
				qFaction:ceo_management():remove_ceos(ancName)
				CusLog("remove ")
				myFaction:ceo_management():add_ceo(ancName)
				CusLog('add to faction?') 
			end
		end
	else
		CusLog("skipped Lu Bu why?")
	end
	--]]
	CusLog("Finished FindAncAccessory = failed")
	return "unknown"

end


function FindAndDestroySeal()
	CusLog("Running FindAndDestroySeal")
	local factionName= FindAncAccessory("3k_main_ancillary_accessory_imperial_jade_seal" , "3k_main_ceo_category_ancillary_accessory")
	if factionName~="unknown" then 
		local modify_faction = cm:modify_faction(factionName);
		modify_faction:ceo_management():remove_ceos("3k_main_ancillary_accessory_imperial_jade_seal")
		CusLog("Finished and Destroyed Seal!")
		return true;
	end
	--[[
	local world = cm:query_model():world()
	if not world:is_null_interface() then 
		for i=0, world:faction_list():num_items()-1 do
			local qFaction = world:faction_list():item_at(i)
			--if not qFaction:is_human() then --Dont destroy players seal
				-- ceo_manager:all_ceos_for_category("3k_main_ceo_category_ancillary_accessory"):num_items()-1 do
				for j=0, qFaction:ceo_management():all_ceos_for_category("3k_main_ceo_category_ancillary_accessory"):num_items()-1 do-- Need to query by category
					local anc= qFaction:ceo_management():all_ceos_for_category("3k_main_ceo_category_ancillary_accessory"):item_at(j)
					--CusLog("ANC !"..tostring(anc:ceo_data_key()))
					if anc:ceo_data_key() =="3k_main_ancillary_accessory_imperial_jade_seal" then 
						CusLog(qFaction:name().." Had Seal");
						--CusLog("Found Seal!"..tostring(anc:category_key())) 
						local modify_faction = cm:modify_faction(qFaction:name());
						modify_faction:ceo_management():remove_ceos("3k_main_ancillary_accessory_imperial_jade_seal")
						CusLog("Destroyed Seal!")
						return true;
					end
				end
			--end	
		end
	else
		CusLog("@@@@!... the world is null? in FindAndDestroySeal")
	end --]]
	
	CusLog("Finished FindAndDestroySeal = false")
	return false;
end


function TellMeAboutFaction(factionName)
	CusLog(" --------------------------------------------------------------")
	CusLog(" Telling you about faction:" ..factionName)
	local qfaction= cm:query_faction(factionName)
	if not qfaction:is_null_interface() then 
		CusLog("    "..factionName.." has gold="..tostring(qfaction:treasury()))
		for i=0, qfaction:character_posts():num_items()-1 do 
			local post= qfaction:character_posts():item_at(i)
			CusLog("    "..post:ministerial_position_record_key().." held by: ")
			if post:current_post_holders() > 0 then 
				--CusLog(tostring(post:ministerial_position_record_key()).." size: "..tostring(post:current_post_holders()))
				local qcharList=post:post_holders();
				for j=0, qcharList:num_items()-1 do 
					local qgeneral= qcharList:item_at(j)
					CusLog("         : "..tostring(qgeneral:generation_template_key()))
				end
			else
				CusLog("         : empty")
			end
		end
	end
	CusLog(" --------------------------------------------------------------")
end

--and not context:query_character():active_assignment():is_null_interface() and not context:query_character():active_assignment():is_idle_assignment() then
function VassalizeSomeone(overLordKey, vassalKey)
	CusLog("Begin VassalizeSomeone")
		local vFaction=cm:query_faction(vassalKey)
		if not vFaction:is_null_interface() then 
			if not vFaction:is_dead() and not vFaction:factions_we_have_specified_diplomatic_deal_with("treaty_components_vassalage"):is_empty()  then 
				for i=0, vFaction:factions_we_have_specified_diplomatic_deal_with("treaty_components_vassalage"):num_items()-1 do
				--CusLog("There will be an old overlord: ")
				--CusLog("SIZE="..tostring(vFaction:factions_we_have_specified_diplomatic_deal_with("treaty_components_vassalage"):num_items()))
				-- You apparently have no way of telling whos the master, and whos the vassal... 
				local OldOverlord = vFaction:factions_we_have_specified_diplomatic_deal_with("treaty_components_vassalage"):item_at(i)
					cm:apply_automatic_deal_between_factions(vassalKey,OldOverlord:name(), "data_defined_situation_vassal_declares_independence") -- how do i not need the true?
					--cm:apply_automatic_deal_between_factions("3k_main_faction_liu_bei","3k_main_faction_guangling", "data_defined_situation_vassal_declares_independence",true)
					--CusLog("forcing war.."..tostring(OldOverlord:name()))
					cm:force_declare_war(vassalKey, OldOverlord:name(), true)
					cm:force_declare_war(OldOverlord:name(), vassalKey, true)
					--CusLog("forcing peace..")
					cm:apply_automatic_deal_between_factions(vassalKey, OldOverlord:name(), "data_defined_situation_proposer_declares_peace_against_target", true);
					cm:apply_automatic_deal_between_factions(OldOverlord:name(), vassalKey, "data_defined_situation_proposer_declares_peace_against_target", true);
				end
			end
			CusLog("2")
			--Make peace before we vassalize just incase things get fucky 
			if cm:query_faction(overLordKey):has_specified_diplomatic_deal_with("treaty_components_war",vFaction) then
					cm:apply_automatic_deal_between_factions(vassalKey, overLordKey, "data_defined_situation_proposer_declares_peace_against_target", true);
					CusLog("...peace1")
					cm:apply_automatic_deal_between_factions(overLordKey, vassalKey, "data_defined_situation_peace", true);
				end
			--Vassalize 
			 cm:apply_automatic_deal_between_factions(overLordKey, vassalKey, "data_defined_situation_vassalise_recipient_forced", false)
			CusLog(overLordKey.."  vassalized "..vassalKey)
		end
	
	CusLog("End VassalizeSomeone")
end

function FindAndAppointSomeoneRandom(factionName)
	CusLog(" FindAndAppointSomeoneRandom to lead: "..tostring(factionName))
	local qFaction= cm:query_faction("3k_main_faction_han_empire")
	for i=0, qFaction:character_list():num_items()-1 do 
		--CusLog("looking through character #"..tostring(i))
		local qgeneral= qFaction:character_list():item_at(i)
		if not qgeneral:has_garrison_residence() then 
			if  qgeneral:character_post():is_null_interface() then
				CusLog("Trying to move: "..tostring(qgeneral:generation_template_key()))
			   -- MoveCharToFaction(qgeneral:cqi(), qlubu:faction():name());
				local mNewLeader = cm:modify_character(qgeneral) -- convert to a modifiable character
				mNewLeader:set_is_deployable(true) -- keep this here, CA does before 
				mNewLeader:move_to_faction_and_make_recruited(factionName) --CA grabs the Modify char again before moving
				mNewLeader:assign_to_post("faction_leader");
				if qgeneral:faction():name() == factionName then 
					CusLog("Move succeeded")
					return qgeneral:cqi();
				else
					CusLog(" Did not work ?")
					return false;
				end
			end
		end
	end

end

function CleanOfficerList(factionName)
	local qfaction= cm:query_faction(factionName)

	CusLog(factionName.." Cleaning OfficerList  # of character="..tostring(qfaction:character_list():num_items()-1))
	local removed=0;
	for i=0, qfaction:character_list():num_items()-1 do 
		i=i-removed;
		local qgeneral= qfaction:character_list():item_at(i)
		--CusLog("  #"..tostring(i).." Found"..tostring(qgeneral:generation_template_key()))
		if not qgeneral:has_garrison_residence() and qgeneral:age() >18 --[[ and qgeneral:active_assignment():is_null_interface()--]]  then --can do armed citizen?
			local key=qgeneral:generation_template_key();
			if string.find(key, "generic") then
				--CusLog(factionName.." #"..tostring(i).." Getting rid of  :"..tostring(qgeneral:generation_template_key()))
				--table.insert(charList, qgeneral:cqi())
				local mchar= cm:modify_character(qgeneral);
				if not mchar:is_null_interface() then 
					mchar:set_is_deployable(true) -- keep this here, CA does before 
					mchar:move_to_faction_and_make_recruited("3k_main_faction_han_empire") --CA grabs the Modify char again before moving
					--CusLog("..success ")
					removed= removed+1;
				end
			end
		end
	end

	CusLog("Done Cleaning Officer List")


	cm:apply_effect_bundle("3k_main_payload_faction_emergent_bonus", factionName , 2)  --50% off redeployment
	cm:apply_effect_bundle("3k_main_payload_faction_lua_satisfaction", factionName , 4)    

end

function PrintOfficersInFaction(factionName)
	CusLog("---------- OFFICER LIST FOR "..factionName.." ---------- ")
	
	local qfaction= cm:query_faction(factionName)
	if qfaction==nil or qfaction:is_null_interface() then 
		return 
	end
	--CusLog("# of character="..tostring(qfaction:character_list():num_items()-1))
	for i=0, qfaction:character_list():num_items()-1 do 
		--CusLog("looking through character #"..tostring(i))
	local qgeneral= qfaction:character_list():item_at(i)
	CusLog("#"..tostring(i).." "..factionName.." has :"..tostring(qgeneral:generation_template_key().."  , loy:"..tostring(qgeneral:loyalty()).."  , is spy: "..tostring(qgeneral:is_spy())))

	end
	CusLog("----------------------------------------------------------------- ")
end

function TelportAllFactionArmies(factionName,RegionName)

	 local qFaction = cm:query_faction(factionName)
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
						local found_pos, x, y = qFaction:get_valid_spawn_location_in_region(RegionName, false);
						local randomness1 = math.floor(cm:random_number(-4, 4 ));
						local randomness2 = math.floor(cm:random_number(-4, 4 ));
						cm:modify_model():get_modify_character(commander):teleport_to(x+randomness1,y-randomness2) 
					end
				end
            end
			cm:modify_faction(qFaction:name()):increase_treasury(1000) -- always give money to help AI get thru the move
		end
end

function RNGHelper(toBeat)
	--CusLog("RNG : "..tostring(debug.traceback()));
	local rolled_value = cm:random_number( 0, 9 );
	CusLog("$$(RNGHelper):: Rolled a:"..tostring(rolled_value).. " , need to beat"..tostring(toBeat))
    return rolled_value > toBeat 	
end
-- This function will take in a list of possible regions and try to give one to the faction if the giver owns it. No check for human
function GiveSomeoneLand(landArray, Receiver, Giver, teleportBool)
	CusLog("trying to give"..tostring(Receiver).. " some land")
	local receiverFaction= getQFaction(Receiver)
	if #landArray ==0 then 
		CusLog("landArray too small?")
		return false;
	elseif receiverFaction==nil then 
		CusLog("receiver is null or dead")
		return false;
	end
	
	for i, key in ipairs(landArray) do
		local region= cm:query_region(key)
		if not region:is_null_interface() then 
			if region:owning_faction():name() == Giver then 
				cm:modify_model():get_modify_region(region):settlement_gifted_as_if_by_payload(cm:modify_faction(Receiver))
				if teleportBool then 
					TelportAllFactionArmies(Receiver,key)
				end
				CusLog(key.." was found, returning true")
				return true;
			end
		
		end
	end
	CusLog("didnt find region..returning false")
	return false;
end
function getPlayerFaction()
	local playersFactionsTable = cm:get_human_factions()
	return  playersFactionsTable[1]
end
function FireDilemma(dilemmaName)
    local playersFactionsTable = cm:get_human_factions()
    local playerFaction = playersFactionsTable[1]

	--Look up difference between 
	-- cm:get_human_factions() return type and 
	--	local all_factions = cm:query_model():world():faction_list();
	--for i=1 in #playersFactionsTable do
	--	
	--end

    cm:trigger_dilemma(playerFaction, dilemmaName, true) 
end
function FireIncident(incidentName) -- needs testing seems like a bad idea
    local playersFactionsTable = cm:get_human_factions()
    local playerFaction = playersFactionsTable[1]


	--for i=1 , #playersFactionsTable do
		cm:trigger_incident(playerFaction, incidentName, true) 
	--end

    
end

function NotInPlayerFaction(qchar) -- check null before passed in 
   local human_factions = cm:get_human_factions()
   for i, faction_key in ipairs( human_factions ) do  
		if(faction_key == qchar:faction():name()) then
			return false;
		end
	 end
	return true;
end

function NotAPlayerFaction(factionName) -- check null before passed in 
	CusLog("$$ testing NotAPlayerFaction"..factionName)
	local human_factions = cm:get_human_factions()
	for i, faction_key in ipairs( human_factions ) do  
		 if(faction_key == factionName) then
			CusLog("$$$returnfalse")
			 return false;
		 end
	  end
	  CusLog("$$$returntrue")
	 return true;
end

 	--@ params: are strings (banditfactionName,regionName,enemyfactionName)
 	--@ params: are ints (intLocX,intLocY)
 	--@ wrap the prints in tostring to prevent nil errors in lua
function SpawnBandits(banditfactionName, regionName, enemyfactionName, intLocX, intLocY)
    CusLog("$$ trying to spawn bandits  "..tostring(banditfactionName).." in: "..tostring(regionName).." at: "..tostring(intLocX).." , "..tostring(intLocY))
	--example
	--local invasion = campaign_invasions:create_invasion("3k_main_faction_zhang_yan", "3k_main_chenjun_resource_2", 1, true, "3k_main_cao_cao", true, 361, 481);
	local banditFaction = cm:query_faction(banditfactionName);
	local found_pos, x, y = banditFaction:get_valid_spawn_location_near(intLocX, intLocY, 4, false);

	local invasion = campaign_invasions:create_invasion(banditfactionName, regionName, 1, true, enemyfactionName, true, x, y);
	invasion:set_force_retreated();
    invasion:start_invasion();
    

	-- Spawn an army                                                 -- not sure what the 2nd region name is for?
   campaign_invasions:create_invasion_attack_region(banditfactionName, regionName, 2, regionName, true, x, y);
	-- 442, 421); --chenjun farm/nanyang area
    CusLog("$$ made an invasion in: "..regionName)
	-- Force the rebels to be at war with whoever.
	local enemyfaction=cm:query_faction(enemyfactionName)
	if not cm:query_faction(banditfactionName):has_specified_diplomatic_deal_with("treaty_components_war",enemyfaction) then
		cm:force_declare_war(banditfactionName, enemyfactionName, true);
	end
    CusLog("$$ done spawning bandits")
end

--Cant create multiple of the same invasion..iidk? Could always try to spawn from existing general pool (or court)
function SpawnBanditsYuan(banditfactionName, regionName, enemyfactionName, intLocX, intLocY)
	local banditFaction = cm:query_faction(banditfactionName);
	local newx=0;
	local newy=0;
	if intLocX ~=nil and intLocY ~=nil then 
		local found_pos, x, y = banditFaction:get_valid_spawn_location_near(intLocX, intLocY, 4, false);
		newy=y;
		newx=x;
	else
		local found_pos, x, y = zyFact:get_valid_spawn_location_in_region(regionName, true);
		newy=y;
		newx=x;
	end

	CusLog("$$..Try to spawn Yuan bandits at:  "..tostring(banditfactionName).." in:"..tostring(regionName).."at: "..tostring(newx).." , "..tostring(newy))
	campaign_invasions:create_invasion_attack_region(banditfactionName, regionName, 2, regionName, false, newx, newy);
	CusLog("$$.. spawned bandits")
end

function SpawnRealFaction(factionName, leaderGenTemplate, regionName, enemyfactionName, intLocX, intLocY)
    CusLog("$$ trying to SpawnRealFaction"..tostring(factionName))
	--example
	--local invasion = campaign_invasions:create_invasion("3k_main_faction_zhang_yan", "3k_main_chenjun_resource_2", 1, true, "3k_main_cao_cao", true, 361, 481);
	local q_faction = cm:query_faction(factionName);
	local found_pos, x, y = q_faction:get_valid_spawn_location_near(intLocX, intLocY, 4, false);
	CusLog("$$  found pos="..tostring(x)..","..tostring(y))
	
	local invasion = campaign_invasions:create_invasion(factionName, regionName, 1, true, enemyfactionName, true, intLocX+1, intLocY-1);
	CusLog("$$  Made an Invasion")
	
	
	invasion:set_force_retreated();
	--invasion:add_respawn(false) -- we dont want them respawning
	CusLog("$$  ..Starting Invasion")
    invasion:start_invasion();
    

	-- Spawn an army                                                 -- not sure what the 2nd region name is for?
  --	campaign_invasions:create_invasion_attack_region(factionName, regionName, 2, regionName, true, intLocX+2, intLocY+1, unit_list);
	-- 442, 421); --chenjun farm/nanyang area
    CusLog("$$ made an invasion in: "..regionName)
	-- Force the rebels to be at war with the han.
	cm:force_declare_war(factionName, enemyfactionName, true);
	
	local qLeader = getQChar(leaderGenTemplate)
	if not qLeader:is_null_interface() then 
		CusLog("$$..Assigning new leader: "..leaderGenTemplate)
		local mLeader = getModifyChar(leaderGenTemplate)  --cm:modify_character(qLeader)
		if( not mLeader:is_null_interface()) then 
		if(qLeader:faction():name()~=factionName) then 
			mLeader:move_to_faction(factionName);
			CusLog("$$..Leader wasnt in faction,moved")
		else
			CusLog("$$He wasnt in faction???")
		end
			mLeader:set_is_deployable(true)
			mLeader:assign_to_post("faction_leader");
			CusLog("$$..Make leader")
			--invasion:assign_general(qLeader:cqi()); --:cqi() ?
			CusLog("$$.Create the general force")
			--invasion:add_character_experience(1000) -- level up our new leader!
			--mLeader:create_force(regionName, "", 284, 493, "ffs"..qfaction..qLeader, 50);
			cm:create_force_with_existing_general(qLeader:cqi(), factionName, unit_list, regionName, x, y, tostring(factionName..01),
			nil, 100);
		else
			CusLog("..hes null?")
		end
		
	else 
		CusLog("$$@@Warning!.. leader not found")
		--Can use str.find() to figure general type
		invasion:create_general(true, "3k_general_earth", leaderGenTemplate); -- this.. will always be an earth general?..
		CusLog("$$Creating a Sketchy Earth general!")
	end

	CusLog("what is this key:"..tostring(factionName.."01"))


	
 	--	CusLog("Finally just try to make lijue spawn cqi"..tostring(qLeader:cqi()))
 	--	mLeader:create_force_with_existing_general(qLeader:cqi(), factionName, unit_list, regionName, intLocX, intLocY, tostring(factionName..01),
 	--		nil, 100);




    CusLog("$$ done SpawnRealFaction")
	
	CusLog("..Lets test get_general() :"..tostring(invasion:get_general()))
	CusLog("..Lets test get_commander() :"..tostring(invasion:get_commander()))
end

--Doesnt seem to work
function SpawnAGeneralInRegion(qchar, regionName, unit_list)
	CusLog("Begin SpawnAGeneralInRegion "..tostring(regionName))	
	if qchar:is_null_interface() or qchar==nil then 
		CusLog("sent a null qchar")
		return false;
	end
	CusLog("Tryng to spawn "..qchar:generation_template_key().." in "..regionName)
	local found_pos, x, y = qchar:faction():get_valid_spawn_location_in_region(regionName, false);
    local rng1 = math.floor(cm:random_number(-3, 3 ));
	local rng2 = math.floor(cm:random_number(-3, 3 ));   
	x=x+rng1;
	y=y-rng2;
	--CusLog("X="..tostring(x))
	--CusLog("Y="..tostring(y))
	--CusLog("KEY="..tostring(qchar:cqi()+x+y))
	--CusLog("Faction="..tostring( qchar:faction():name()))
	--CusLog("UNITS="..tostring(unit_list))
    cm:create_force_with_existing_general(qchar:cqi(), qchar:faction():name(), unit_list, regionName, x, y, tostring(qchar:cqi()+x+y),nil, 100);
		
	CusLog("Finished SpawnAGeneralInRegion")
	return true;
end

function MoveCharToFaction(charTemplate, factionName) -- wont move if in player faction 


 	local qfaction = cm:query_faction(factionName)

 --If modifyChar has the same methods, we could replace most this code with getModifyChar()
 -- would still need to call NotInPlayerFaction()
  	if not qfaction:is_null_interface() then
    local qchar = cm:query_model():character_for_template(charTemplate)
		if not qchar:is_null_interface() then
			if(not qchar:is_dead()) then
				if NotInPlayerFaction(qchar) or qchar:is_character_is_faction_recruitment_pool()  then     -- move char only if hes not in the player faction
					local mqchar = cm:modify_character(qchar) -- convert to a modifiable character
					mqchar:set_is_deployable(true) -- keep this here, CA does before 
					mqchar:move_to_faction_and_make_recruited(factionName) --CA grabs the Modify char again before moving
					mqchar:add_loyalty_effect("extraordinary_success");  -- get a more accurate effect?
					CusLog("$$Moved " ..qchar:generation_template_key())
					return true;
				else
					CusLog("$$In player faction (wont move) ".. qchar:generation_template_key())
				end
			else
				CusLog("$$dead ".. qchar:generation_template_key())
			end
		else
			CusLog("$$..!!..cant find qchar to move?")
		end
	end
	return false;
end

function MoveCharToFactionHard(charTemplate, factionName) -- Will move if in player faction 

	CusLog("$$ Doing Hard Faction move for:"..tostring(charTemplate))
	local qfaction = cm:query_faction(factionName)
   
	--If modifyChar has the same methods, we could replace most this code with getModifyChar()
	-- would still need to call NotInPlayerFaction()
	 if not qfaction:is_null_interface() then
	   local qchar = cm:query_model():character_for_template(charTemplate)
		   if not qchar:is_null_interface() then
			   if(not qchar:is_dead()) then
					   local mqchar = cm:modify_character(qchar) -- convert to a modifiable character
					   mqchar:set_is_deployable(true) -- keep this here, CA does before 
					   mqchar:move_to_faction_and_make_recruited(factionName) --CA grabs the Modify char again before moving
					   mqchar:add_loyalty_effect("extraordinary_success");  -- get a more accurate effect?
					   CusLog("$$Moved " ..qchar:generation_template_key())
			   else
				   CusLog("$$dead ".. qchar:generation_template_key())
			   end
		   else
			   CusLog("$$..!!..cant find qchar to move?")
		   end
	 end
   
end


  --Unfortunately this doesnt work reliably (use from db instead )
function ChangeRelations(charTemplate1, charTemplate2, relationParameter) 

	--triggers gotten from character_relationships.character_spawn_relationship_triggers
	--3k_main_relationship_trigger_set_event_negative_generic_large
	--3k_main_relationship_trigger_set_event_negative_dilemma_large
	--3k_main_relationship_trigger_set_event_negative_insulted
	--3k_main_relationship_trigger_set_event_negative_betrayed

	--3k_main_relationship_trigger_set_event_positive_dilemma_large
	--3k_main_relationship_trigger_set_event_positive_generic_extreme
	--3k_main_relationship_trigger_set_event_positive_good_omen
	--3k_main_relationship_trigger_set_ministerial_appointed_heir
	--3k_main_relationship_trigger_set_ministerial_appointed_general
	--3k_main_relationship_trigger_set_ministerial_appointed_governor
	--3k_main_relationship_trigger_set_politics_adopted

	--3k_main_relationship_trigger_set_scripted_unique_vassal_master
	--3k_main_relationship_trigger_set_startpos_event_negative_betrayed
	--3k_main_relationship_trigger_set_startpos_event_positive_joined
	--3k_main_relationship_trigger_set_startpos_family_member
	
	--Can also try: character_relationship_trigger_sets_tables in db for more keys

	-- should be able to convert to modify characters and apply here 
	local modify_character= getModifyChar(charTemplate1)
	local target_character = getQChar(charTemplate2)

	if(modify_character:is_null_interface() == false and target_character:is_null_interface()==false ) then 
		CusLog("..adding relationship:"..relationParameter.." to "..charTemplate1.." and "..charTemplate2)
		modify_character:apply_relationship_trigger_set( target_character,  relationParameter);
		CusLog("..Success!")
		return true;
	end
	CusLog("something went wrong with add relationshop between:"..charTemplate1.." and "..charTemplate2.." for:"..relationParameter)
	return false;
end

-- 50/50 chance it goes to han empire so we dont have to resettle for 8k and AI wont bug out. 
-- although it was nice how it put things in the area on pause, kinda worked 
function AbandonLands(factionName) -- Create a Dummy effect for event front end display
 
 local qfaction = cm:query_faction(factionName)
 local regionList = { };
 if qfaction:region_list() then
	 CusLog(qfaction:name().." Provinces Owned="..qfaction:faction_province_list():num_items())
	 for i = 0, qfaction:faction_province_list():num_items() - 1 do -- Go through each Province
		 local province_key = qfaction:faction_province_list():item_at(i);
		-- CusLog("$looking at Province #:"..tostring(i).."  ="..tostring(province_key))
		 for i = 0, province_key:region_list():num_items() - 1 do -- Go through each region in that province
			-- CusLog("$$looping: x" ..tostring(i))
			 local region_key = province_key:region_list():item_at(i);
			 if(not region_key:is_null_interface()) then 
				 local region_name = region_key:name()
				-- CusLog("$$Adding@: " .. region_name)
				 table.insert(regionList, region_name)
			 end
		 end	
	 end
 end

 -- CusLog("$$trying to get rid of old regions:")
 for i=1, #regionList do
	 local region = cm:query_region(regionList[i])
		 if RNGHelper(5) then 
			cm:modify_region(region):raze_and_abandon_settlement_without_attacking();
		else
			cdir_events_manager:transfer_region_to_faction(region, "3k_main_faction_han_empire");
		 end
		 CusLog("$$"..tostring(factionName).." Abandoned: " .. region:name())
	 end
   
end

function CountRegions(factionName)
	CusLog("$$..Begin CountRegions:: "..tostring(factionName))
	local qfaction = cm:query_faction(factionName)
	local regionCount=0;
	if qfaction:region_list() then
		--CusLog(qfaction:name().." Provinces Owned="..qfaction:faction_province_list():num_items())
		for i = 0, qfaction:faction_province_list():num_items() - 1 do -- Go through each Province
			local province_key = qfaction:faction_province_list():item_at(i);
			--CusLog("$looking at Province #:"..tostring(i).."  ="..tostring(province_key))
			for i = 0, province_key:region_list():num_items() - 1 do -- Go through each region in that province
				--CusLog("$$looping: x" ..tostring(i))
				local region_key = province_key:region_list():item_at(i);
				if(not region_key:is_null_interface()) then 
					local region_name = region_key:name()
				--	CusLog("$$Counting@: " .. region_name)
					regionCount= regionCount+1;
				end
			end	
		end
	end
	CusLog("$$.."..factionName.."  Regions owned="..tostring(regionCount))
	return regionCount;
end

function CheckAlive(factionName)
	CusLog(" Checking if Faction alive:"..factionName)
	local qFaction= cm:query_faction(factionName) 
		if not qFaction:is_null_interface() then  
			if not qFaction:is_dead() then
				CusLog(" alive")	
				return true
			end
		end		
		CusLog(" not alive")				
	return false
end

function getModifyChar(charTemplate)
   local qchar = cm:query_model():character_for_template(charTemplate)
    if not qchar:is_null_interface() then   -- query_model() will always return an interface, even if empty
		if(not qchar:is_dead()) then
            return cm:modify_character(qchar) -- convert to a modifiable character
		end
	else
		return nil; 
	end
end
function getQChar(charTemplate)
	return cm:query_model():character_for_template(charTemplate)
end
--WillReturn nil trick if nullinterface or dead 
function getQChar2(charTemplate)
	--CusLog("Checking getQChar2  "..tostring(charTemplate))
	
	local qchar=cm:query_model():character_for_template(charTemplate)
	if qchar:is_null_interface() then
		return nil;
	elseif qchar:is_dead() then
		return nil;
	end
		
	--CusLog("getQChar2 found")
	return qchar;

end
-- returns null if factions nullinterface or dead 
function getQFaction(factionName)
	CusLog("Checking QFaction  "..tostring(factionName))
	local qFaction=cm:query_faction(factionName)
	if qFaction:is_null_interface() then 
		return nil
	elseif qFaction:is_dead() then 
		return nil;
	end
	CusLog("qFaction found")
	return qFaction;

end


function MakeDeployable(charTemplate)
			CusLog("Making Deployable: "..charTemplate)
			local qchar=getQChar2(charTemplate)
			if qchar~=nil then 
				local oldfactionName= qchar:faction():name();
				local post= qchar:character_post()	
				local mchar= cm:modify_character(qchar)
				mchar:set_is_deployable(true) 
				mchar:move_to_faction_and_make_recruited("3k_main_faction_han_empire")
				mchar:set_is_deployable(true) 
				mchar:move_to_faction_and_make_recruited(oldfactionName)
				mchar:add_loyalty_effect("lua_loyalty"); 
				mchar:add_loyalty_effect("extraordinary_success"); 	
				mchar:set_is_deployable(true) 
				if(not post:is_null_interface()) then --What the heck this was set to if post is null?
					mchar:assign_to_post(post);
					CusLog("Assigned back to post"..post:ministerial_position_record_key())
				end
			else
				CusLog("Failed")
				return false;
			end

			CusLog("..Moved "..charTemplate.."  back to"..qchar:faction():name())
			return true;
end

function SpawnCharacter(charTemplate, charType,  factionName)
	CusLog("Spawning :"..tostring(charTemplate).. " in .."..tostring(factionName));
	cdir_events_manager:spawn_character_subtype_template_in_faction(factionName, charType, charTemplate);
end

function TestGlobals()
	CusLog("$$$$$$$$ Testing Global Function $$$$$$$$$$")
	local modchar= getModifyChar("3k_main_template_historical_xu_huang_hero_metal")
	CusLog("   $Test: Modchar  "..modchar:query_character():generation_template_key())

	AbandonLands("3k_main_faction_cao_cao")
	MoveCharToFaction("3k_main_template_historical_xu_huang_hero_metal", "3k_main_faction_dong_zhuo")
	FireDilemma("3k_lua_dz_civil_war_dilemma")

	CusLog("changeR1's:"..tostring(
		ChangeRelations("3k_main_template_historical_xu_huang_hero_metal",
		 "3k_main_template_historical_lu_bu_hero_fire",
		  "3k_main_relationship_trigger_set_scripted_round_start_same_region" )))

		  
	CusLog("changeR2's:"..tostring(
		ChangeRelations("3k_main_template_historical_xu_huang_hero_metal",
		 "3k_main_template_historical_lu_bu_hero_fire",
		  "3k_main_relationship_trigger_set_battle_high_kills" )))


end


function UIClickedListener() 
	CusLog("### UIClickedListener loading ###") 
	core:remove_listener("UICLicked")
	core:add_listener(
		"UICLicked",
		"ComponentLClickUp", -- Campaign Event to listen for
		function(context)
			CusLog(" UI Clicked:") 
			CusLog("             :"..tostring(context.string)) 
			print_all_uicomponent_children(core:get_ui_root())
			--CusLog(print_all_uicomponent_children(core:get_ui_root()))
			return true;
		end,
		function(context) -- What to do if listener fires.
		CusLog(" UIClickedListener callback:") 
		CusLog("                     result:"..tostring(context.component)) 
		end,
		false
    )
end


function UIPanelOpened() 
	CusLog("### UIPanelOpened loading ###") 
	core:remove_listener("UiPanelOpen")
	core:add_listener(
		"UiPanelOpen",
		"PanelOpenedCampaign", -- Campaign Event to listen for
		function(context)
			if cm:get_saved_value("panel_open") ~=true then 
				return context:component_id() == "character_details"
			end
			return false;
		end,
		function(context) -- What to do if listener fires.
			cm:set_saved_value("panel_open", true)
			--CusLog(" Character Panel opened")
			local uic = find_uicomponent(core:get_ui_root(), "character_details", "holder_character", "holder_details", "holder_tabs", "tabs", "tab_skills" , "holder_skill_buttons" )
			--CusLog("uic="..tostring(uic))
			local x, y = uic:Position()
			 y= y +y*0.09
			uic:MoveTo(x,y)

		end,
		true
    )
end

function UIPanelClosed() 
	CusLog("### UIPanelClosed loading ###") 
	core:remove_listener("UiPanelClosed")
	core:add_listener(
		"UiPanelClosed",
		"PanelClosedCampaign", -- Campaign Event to listen for
		function(context)
			return context:component_id() == "character_details"
		end,
		function(context) -- What to do if listener fires.
			cm:set_saved_value("panel_open", false)
		end,
		true
    )
end


function DebuggTurnNosListener() 
	CusLog("### DebuggTurnNosListener loading ###") 
	core:remove_listener("DebuggTurnNos")
	core:add_listener(
		"DebuggTurnNos",
		"WorldStartOfRoundEvent", -- Campaign Event to listen for
		function(context)
			return true;
		end,
		function(context) -- What to do if listener fires.
		CusLog("|------------------------------------------------------------|")
		CusLog("|------------------ Start Of Round "..tostring(context:query_model():turn_number()).." ------------------|") 
		CusLog("|------------------------------------------------------------|")

		end,
		false
    )
end


function DebuggMovementLocs() 
    CusLog("### DebuggMovementLocs 2 loading ###")
    core:remove_listener("DebuggMovementLocs") -- prevent duplicates
	core:add_listener(
		"DebuggMovementLocs",
		"CharacterFinishedMovingEvent",
        function(context)
            local qgeneral = context:query_character();
            if qgeneral:faction():is_human() then
				CusLog(qgeneral:generation_template_key().."          .... In region:"..tostring(qgeneral:region():name()).."  at L POS:"..tostring(qgeneral:logical_position_x().." , "..tostring(qgeneral:logical_position_y())))
			elseif qgeneral:faction():name() == "3k_main_faction_liu_bei" then 
				CusLog(qgeneral:generation_template_key().."          .... In region:"..tostring(qgeneral:region():name()).."  at L POS:"..tostring(qgeneral:logical_position_x().." , "..tostring(qgeneral:logical_position_y())))
				end
             
             return false
		end,
		function(context)

		end,
		true
    )
end

local function DetermineMTU()
	local mtuchar= getQChar2("3k_mtu_template_historical_wen_chou_hero_wood")
	if mtuchar~=nil then 
		CusLog("mtu true")
		MTU=true;
	end

end


cm:add_first_tick_callback(
	function(context)
		if context:query_model():turn_number()>=1 then  --tmp > 
			DetermineMTU()
		end
		IniDebugger()
		DebuggTurnNosListener()
		--UIPanelOpened()
		--UIPanelClosed()
		--UICreationListener()
		--UIClickedListener()
		--TestGlobals()
		--DebuggMovementLocs()
		--PrintOfficersInFaction("3k_main_faction_sun_jian")
		--PrintOfficersInFaction(Factionkey2)
		--PrintOfficersInFaction("3k_main_faction_lu_bu")
		--TellMeAboutFaction("3k_main_faction_lu_bu")
		--PrintOfficersInFaction("3k_main_faction_guangling")
		--TellMeAboutFaction("3k_main_faction_guangling")
		--TellMeAboutFaction("3k_main_faction_cao_cao")
		TellMeAboutFaction("3k_main_faction_liu_bei")
		--TellMeAboutFaction("3k_main_faction_yuan_shao")
		PrintOfficersInFaction("3k_main_faction_liu_bei")
		local qlubu=getQChar2("3k_main_template_historical_lu_bu_hero_fire")
		CusLog("LUBU is in faction:"..tostring(qlubu:faction():name()))
		CusLog("LUBU DEAD="..tostring(qlubu:is_dead()))
		CusLog("LUBU POST=="..tostring(qlubu:character_post():is_null_interface())) --:ministerial_position_record_key()
		--TellMeAboutFaction("3k_main_faction_ma_teng")
		--TellMeAboutFaction("3k_main_faction_liu_biao")
		--TellMeAboutFaction("3k_main_faction_sun_jian")
		--PrintOfficersInFaction("3k_main_faction_sun_jian")
		--PrintOfficersInFaction("3k_main_faction_yuan_shu")
		--FindAncAccessory("3k_main_ancillary_mount_red_hare", "3k_main_ceo_category_ancillary_mount")

			--Write something for search that triggers a random anc for player from time to time. 
			--local triggered=cm:trigger_incident(getPlayerFaction(), "3k_lua_test_job_sat", true)
			--CusLog("(1)="..tostring(triggered))
			--local triggered=cm:trigger_incident(getPlayerFaction(), "3k_search_gives_supply2", true)
			--CusLog("(2)="..tostring(triggered))
			--triggered=cm:trigger_incident(getPlayerFaction(), "3k_search_gives_supply", true)
			--CusLog("(3)="..tostring(triggered))
			--cm:modify_faction(getPlayerFaction()):increase_treasury(26000)
			--TellMeAboutFaction("3k_dlc05_faction_sun_ce")
			--PrintOfficersInFaction("3k_dlc05_faction_sun_ce")
	end
)
