---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			Havie Commander Satisfaction
----- Description: 	Adds a loyalty modifier to those who wish to command an army, and those who already are
-----				
-----			Had to use global table to do so
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

 local commander_personalities  = {
    ["3k_main_ceo_trait_personality_ambitious"] = true,
    ["3k_main_ceo_trait_personality_determined"] = true,
    ["3k_main_ceo_trait_personality_greedy"] = true,
    ["3k_main_ceo_trait_personality_brave"] = true,
    ["3k_main_ceo_trait_personality_competative"] = true,
    ["3k_main_ceo_trait_personality_direct"] = true,
    ["3k_main_ceo_trait_personality_distinguished"] = true,
    ["3k_main_ceo_trait_personality_reckless"] = true,
    ["3k_main_ceo_trait_personality_dutiful"] = true,
    ["3k_main_ceo_trait_personality_vengeful"] = true -- remove when done testing

}

local startTime1=os.clock() --can put in CM:val if needed ?




local function CusLog(text)
    if type(text) == "string" then
        local file = io.open("@sat_havie_commander.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime1).."] ")
		local line= time..text
        local header=" (sat_commander): "
        local line= time..header..text
        file:write(line.."\n")
        file:close()
        ModLog(header..text)
    end
end

local printStatements=false;


local function IniDebugger()
	printStatements=true;
	local file = io.open("@sat_havie_commander.txt", "w+")
	file:close()
	CusLog("---Begin File----")
end

local function WhosCommandingListener()
    CusLog("### WhosCommandingListener loading ###")
	core:add_listener(
		"WhosCommanding",
		"FactionTurnEnd",
		function(context)
          -- CusLog("!!!..Factions End Turns::"..context:faction():name())
            return context:faction():military_force_list():num_items() >1
            --return context:faction():is_human()
           -- CusLog(".......... The Size of the force list="..tostring(context:faction():military_force_list():num_items()))
           -- CusLog("............ the faction is human="..tostring(context:faction():is_human()))
           -- return true;
		end,
		function(context)
           -- CusLog("### Passed WhosCommandingListener ###")
            local desires_command = {}
            local commanders = {}
            if(context:faction():is_human()) then
               -- CusLog("The Military Force List size=:"..tostring(context:faction():military_force_list():num_items()))
            end
            --First we get all the current commanders
            for i=0 , context:faction():military_force_list():num_items() -1 do 
               -- CusLog("found force #"..tostring(i).." in faction "..context:faction():name())
                local m_force= context:faction():military_force_list():item_at(i)
                if(m_force:is_armed_citizenry()) then        --if(qgeneral:is_armed_citizenry()) then  -_Error here --has_garrison_residence
                    if(context:faction():is_human()) then
                       -- CusLog("found a garrison, do nothing")
                    end
                else
                   -- CusLog("passed is_armed_citizenry")
                   local qgeneral= m_force:character_list():item_at(0)
                    if(context:faction():is_human()) then
                    -- CusLog("found Commander:"..tostring(qgeneral:generation_template_key().." ID: "..tostring(qgeneral:cqi())))
                    -- CusLog("               .... In region:"..tostring(qgeneral:region():name()).."  at L POS:"..tostring(qgeneral:logical_position_x().." , "..tostring(qgeneral:logical_position_y())))
                    -- CusLog("               .... In region:"..tostring(qgeneral:region():name()).."  at L POS:"..tostring(qgeneral:display_position_x().." , "..tostring(qgeneral:display_position_y())))
                    end
                    --this guys a commander, so add him to the list of total commanders
                    commanders[tostring(qgeneral:cqi())] =true
                end
            end
            --Second we find who desires command
            for i=0, context:faction():character_list():num_items()-1 do 
                --CusLog("looking through character #"..tostring(i))
                local qgeneral= context:faction():character_list():item_at(i)
                local ceo_manager= qgeneral:ceo_management()
                for i=0, ceo_manager:all_ceos_for_category("3k_main_ceo_category_traits_personality"):num_items()-1 do
                   -- CusLog("looking at Ceo#"..tostring(i))
                    local trait= ceo_manager:all_ceos_for_category("3k_main_ceo_category_traits_personality"):item_at(i):ceo_data_key()
                    if(context:faction():is_human()) then
                       -- CusLog("    Trait: "..tostring(trait))
                       -- CusLog("  category: "..tostring(ceo_manager:all_ceos_for_category("3k_main_ceo_category_traits_personality"):item_at(i):category_key()))
                    
                        --CusLog("Scope of Commander Table: "..tostring(commander_personalities["3k_main_ceo_trait_personality_ambitious"]))
                        --CusLog("Second check: "..tostring(desires_command[tostring(qgeneral:cqi())] ~= true))
                    end
                    local should_add=false;
                    if commander_personalities[tostring(trait)] and desires_command[tostring(qgeneral:cqi())] ~= true then 
                        should_add=true
                    elseif qgeneral:character_subtype_key() =="3k_general_earth" and desires_command[tostring(qgeneral:cqi())] ~= true then
                        -- chance they auto desire command
                        local rolled_value = cm:random_number( 0, 6 );
                        local to_beat=2;
                        if rolled_value > to_beat then 
                            should_add=true
                         end
                    end

                    if should_add then 
                        desires_command[tostring(qgeneral:cqi())] =true; --add this commander to our list
                        if(context:faction():is_human()) then
                          --  CusLog("(Commanders): added desires_command: "..qgeneral:generation_template_key().." with Id:"..tostring(qgeneral:cqi()).." to the list of desire to lead")
                        end
                    end
                end

            end
           -- CusLog("XXXXX....")
           -- CusLog("XXXXX....Enter next phase-Calculation:")
           -- CusLog("XXXXX....")
            --Next we parse out who's content or upset
            for key, v in pairs(desires_command) do
               -- CusLog("key="..tostring(key))
                if commanders[tostring(key)] then 
                    --CusLog("(Commanders):found a match")
					--apply buff
                    local mchar = cm:modify_character(tonumber(key))
                    if(mchar:is_null_interface()) then
                     --   CusLog("@@..Mod char key is null ")
                    else
                       if(context:faction():is_human()) then --Debugging
                        --    CusLog("(Commanders):Adding POS to CQi:"..key)
                        --    CusLog("(Commanders): Key:"..tostring(cm:query_character(tonumber(key)):generation_template_key()))
                       end
                        mchar:add_loyalty_effect("command_pos");
                    end
                else
					--CusLog("not a match")
                    --apply debuff
                    local mchar = cm:modify_character(tonumber(key))
                    if(mchar:is_null_interface()) then
                      --  CusLog("@@..Mod char key is null ")
                    else
                        if(context:faction():is_human()) then --Debugging
                        --    CusLog("(Commanders):Adding NEG to CQi:"..key)
                         --   CusLog("(Commanders): Key:"..tostring(cm:query_character(tonumber(key)):generation_template_key()))
                       end
                        mchar:add_loyalty_effect("command_neg");
                    end
                    
                end
            end

			--CusLog("sssss...finished callback")
		end,
		true
    )
end


-- when the game loads run these functions:
cm:add_first_tick_callback(
    function(context)
        IniDebugger()
        WhosCommandingListener()
    end
)
