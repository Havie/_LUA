---> Fall of Tyrant

-- listens for the fall of the empire incident (dong zhuos death)


local printStatements=false;



local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_fallofTyrant.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
		local header=" (fallofTyrant)): "
		local line= time..header..text
		file:write(line.."\n")
		file:close()
		ModLog(header..text)
    end
end

local function IniDebugger()
	printStatements=true;
	local file = io.open("@havie_fallofTyrant.txt", "w+")
	file:close()
	CusLog("---Begin File----")
end


local function PeaceForZhangMiao()
		CusLog("Begin PeaceForZhangMiao")
	--forced peace 
		local qfaction= cm:query_faction("3k_main_faction_liu_dai")
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

		CusLog("END PeaceForZhangMiao")
end

-- Provides a fail safe if AI dongzhuo doesnt die and player is a faction dependent on his storyline
function KillDong()
	CusLog("..killDong")
	getModifyChar("3k_main_template_historical_dong_zhuo_hero_fire"):kill_character(false)

	local playersFactionsTable = cm:get_human_factions()
	local playerFaction = playersFactionsTable[1]
	local triggered=cm:trigger_incident(playerFaction,"3k_main_historical_dong_fall_of_empire_npc_incident", true )
	local q_dz_faction = cm:query_faction("3k_main_faction_dong_zhuo")
	if(not q_dz_faction:is_human()) then
		CusLog("...Players not Dong, proceed AI path") 
		cm:set_saved_value("fall_of_empire", true);  -- Handled in emergent_factions i swear i need to set this true regardless??
		register_li_jue_emergent_faction_2() -- player is not dong zhuo so take the AI path by default
	else	
		if not triggered then -- really not sure about whats going on here
			cm:set_saved_value("dz_civil_war_dilemma", true); -- we want Li Jue to undeploy so we can spawn him. 
		end
	end

	

	PeaceForZhangMiao()
	CusLog("..Finished Kill Dong")
end

function ProgressAfterMath()
	if cm:get_saved_value("AfterMath_occurred") ~=true then 
		--  cdir_events_manager:trigger_civil_war_in_faction("3k_main_faction_dong_zhuo", {"3k_main_template_historical_li_jue_hero_fire","3k_main_template_historical_guo_si_hero_fire"})
		local q_dz_faction = cm:query_faction("3k_main_faction_dong_zhuo")
		if q_dz_faction:is_human() then
			-- tell other script to fire dilemma for player 
			cm:set_saved_value("dz_civil_war_dilemma", true);
			-- turn off this value so this call back stops?
			CusLog("..Tmp Turn off LiJues Spawn Cond, till we know player choice")
			cm:set_saved_value("fall_of_empire", false) -- Turns off Li Jues Emergent Spawn Condition
		else
		-- AI is dong zhuo 
		register_li_jue_emergent_faction_2()
		cm:set_saved_value("fall_of_empire", true);  -- Turns on Li Jues Emergent Spawn Condition 
		end
		cm:set_saved_value("AfterMath_occurred",true)
	end
end


function EnsureDongDiesListener()
	CusLog("### EnsureDongDiesListener loading ###")
	core:remove_listener("EnsureDongDies")
	core:add_listener(
		"EnsureDongDies",
		"FactionTurnEnd",
		function(context)
			if context:faction():is_human() and context:query_model():calendar_year() > 191 then 
				local qdong= getQChar("3k_main_template_historical_dong_zhuo_hero_fire")
				if qdong:is_dead() then 
					return false
				end
				CusLog("..Checking if we need to kill DongZhuo")
				if(context:faction():name() == "3k_main_faction_liu_bei"
					or context:faction():name() == "3k_main_faction_cao_cao"
					or context:faction():name() == "3k_main_faction_yuan_shu"
					or context:faction():name() == "3k_main_faction_yuan_shao"
					) then 
						CusLog("..player is a relevant faction in dongs storyline, and he hasnt died yet")
						if cm:get_saved_value("fall_of_empire") ~=true then
							
							local q_dz_faction = cm:query_faction("3k_main_faction_dong_zhuo")						
							CusLog("..checking its not a 2P game..")
							--return not q_dz_faction:is_human();
							if( not q_dz_faction:is_human()) then 
								if context:query_model():calendar_year() ==192 then 
									return RNGHelper(5) --5
								else
									return true;
								end
							end
				
						end
				elseif context:faction():is_human() and context:faction():name() == "3k_main_faction_dong_zhuo" then
					CusLog("Player is DZ..going tocheck if he took diao chan")
					local diaochan_character = cm:query_model():character_for_template("3k_main_template_historical_lady_diao_chan_hero_water")
						CusLog("...Why wont this return :"..tostring(diaochan_character:faction():name() == "3k_main_faction_dong_zhuo" ))
						if diaochan_character:faction():name() == "3k_main_faction_dong_zhuo" then 
							--Undeploy Li Jue so he can be spawned?!
							CusLog("..Undeploying LiJue Around:")
							local mqchar = getModifyChar("3k_main_template_historical_li_jue_hero_fire")
							local post= getQChar("3k_main_template_historical_li_jue_hero_fire"):character_post()
							
							mqchar:set_is_deployable(true) 
							mqchar:move_to_faction_and_make_recruited("3k_main_faction_han_empire") --CA grabs the Modify char again before moving
							--mqchar:add_loyalty_effect("extraordinary_success");  -- get a more accurate effect?
							CusLog("..Moved li jue  ..to the Han")
							mqchar:set_is_deployable(true)
							mqchar:move_to_faction_and_make_recruited("3k_main_faction_dong_zhuo")
							mqchar:set_is_deployable(true) 
							mqchar:add_loyalty_effect("lua_loyalty"); -- is this enough to prevent him leaving and undeploying
							mqchar:add_loyalty_effect("defection_bonus"); -- is this enough to prevent him leaving and undeploying
							if not post:is_null_interface() then  --What the heck this was set to if post is null?
								mqchar:assign_to_post(post);
								CusLog("Assigned bak to post"..post:ministerial_position_record_key())
							end
							CusLog("..Moved li jue  ..back")
							return true
						end
				else
					CusLog("wtf is going on")
				end
			
			end
			 return false
		end,
		function(context)
			CusLog("??Callback: Passed EnsureDongDies ###")
			KillDong() 
			CusLog("### Finished EnsureDongDies Callback ###")
		end,
		false
    )
end


function FollowUpInsuranceListener() -- if the fall of the tyrant doesnt occur, but DZ died 
	CusLog("### FollowUpInsuranceListener loading ###")
	core:remove_listener("FollowUpInsurance")
	core:add_listener(
		"FollowUpInsurance",
		"FactionTurnEnd",
		function(context)
			if context:faction():is_human() and context:query_model():turn_number() == cm:get_saved_value("DongDiedTurn") then 
				if cm:get_saved_value("fall_of_empire")==nil  then 
					return true;
				end
			end
			 return false
		end,
		function(context)
			CusLog("??Callback: Passed FollowUpInsuranceListener ###")
			ProgressAfterMath()
			core:remove_listener("FollowUpInsurance");
			CusLog("### Finished FollowUpInsuranceListener Callback ###")
		end,
		false
    )
end


function louyang_rebel()
	CusLog("### louyang_rebel loading ###")
	core:remove_listener("louyang_rebel")
	core:add_listener(
		"louyang_rebel",
		"IncidentOccuredEvent",
		function(context)
			 return context:incident() == "3k_main_historical_dong_fall_of_empire_npc_incident"
		end,
		function(context)
			CusLog("??? Callback: louyang_rebel ###")
          --  cm:set_saved_value("rebellion_launched", true);
			  ProgressAfterMath()
			CusLog("### Finished louyang_rebel ###")
		end,
		false
    )
end


function DongDiedVanillaListener()
	CusLog("### DongDiedVanillaListener loading ###")
	core:remove_listener("DongDiedVanilla")
	core:add_listener(
		"DongDiedVanilla",
		"IncidentOccuredEvent",
		function(context)
			 return context:incident() == "3k_main_historical_dong_chain_plot_npc_02_incident"
		end,
		function(context)
			CusLog("??? Callback: DongDiedVanillaListener ###")
			cm:set_saved_value("DongDiedTurn", context:query_model():turn_number()+2);
			PeaceForZhangMiao()
		
			CusLog("### Finished DongDiedVanillaListener ###")
		end,
		false
    )
end

    
function DZEarlyIni() --if yuan shu is player initialize the script variables
   
    local curr_faction =cm:query_faction("3k_main_faction_dong_zhuo")
	
	if(curr_faction:is_null_interface()) then
		return;
	end
	
	if curr_faction:is_human() then
		cm:set_saved_value("dong_zhuo_is_human",true) -- might be useful to use this check
	else
		cm:set_saved_value("dong_zhuo_is_human",false)	 
	end
end

function FallOfTyrantVariables()
		CusLog("Debug: FallOfTyrantVariables")
		CusLog("  FallofTyrant fall_of_empire= "..tostring(cm:get_saved_value("fall_of_empire")))
		CusLog("  FallofTyrant dz_civil_war_dilemma= "..tostring(cm:get_saved_value("dz_civil_war_dilemma")))
		CusLog("  FallofTyrant AfterMath_occurred= "..tostring(cm:get_saved_value("AfterMath_occurred")))

		CusLog("Passed: FallOfTyrantVariables")
end

-- when the campaign loads run these functions:
cm:add_first_tick_callback(
	function(context)
		IniDebugger()
		FallOfTyrantVariables()
		if context:query_model():turn_number() == 1 then 
			DZEarlyIni()
		end
        if context:query_model():calendar_year() > 189 and context:query_model():calendar_year() < 195 then
			louyang_rebel()
			DongDiedVanillaListener()
			EnsureDongDiesListener()
			FollowUpInsuranceListener()
		end

		--OFF
		CusLog(" TMP setting :: AfterMath_occurred")
		cm:set_saved_value("AfterMath_occurred",true)
	end
)


