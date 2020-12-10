---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			Havie Commander Satisfaction
----- Description: 	Adds a loyalty modifier to those who wish to command an army, and those who already are
-----				
-----			Had to use global table to do so
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

local function CusLog(text)
    if type(text) == "string" then
        local file = io.open("@sat_havie_commander.txt", "a")
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
    ["3k_main_ceo_trait_personality_vengeful"] = true 

}

local startTime1=os.clock() 





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
            return context:faction():military_force_list():num_items() >1
		end,
		function(context)
            local desires_command = {}
            local commanders = {}
            --First we get all the current commanders
            for i=0 , context:faction():military_force_list():num_items() -1 do 
                local m_force= context:faction():military_force_list():item_at(i)
                if not (m_force:is_armed_citizenry()) then 
                   local qgeneral= m_force:character_list():item_at(0) --this guys a commander, so add him to the list of total commanders
                    commanders[tostring(qgeneral:cqi())] =true
                end
            end
            --Second we find who desires command
            for i=0, context:faction():character_list():num_items()-1 do 
                local qgeneral= context:faction():character_list():item_at(i)
                local ceo_manager= qgeneral:ceo_management()
                for i=0, ceo_manager:all_ceos_for_category("3k_main_ceo_category_traits_personality"):num_items()-1 do
                    local trait= ceo_manager:all_ceos_for_category("3k_main_ceo_category_traits_personality"):item_at(i):ceo_data_key()
                    local should_add=false;
                    if commander_personalities[tostring(trait)] and desires_command[tostring(qgeneral:cqi())] ~= true then 
                        should_add=true
                    elseif qgeneral:character_subtype_key() =="3k_general_earth" and desires_command[tostring(qgeneral:cqi())] ~= true then
                        -- chance earth generals auto desire command
                        local rolled_value = cm:random_number( 0, 6 );
                        should_add= rolled_value >2
                    end
                    if should_add then 
                        table.insert(desires_command,tostring(qgeneral:cqi())); --add this commander to our list
                     end
                end

            end

            for key, v in pairs(desires_command) do
                local mchar = cm:modify_character(tonumber(key))
                if commanders[tostring(key)] then 
                    if not (mchar:is_null_interface()) then
                        mchar:add_loyalty_effect("command_pos");
                    end
                else
                    if not (mchar:is_null_interface()) then
                        mchar:add_loyalty_effect("command_neg");
                    end
                    
                end
            end
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
