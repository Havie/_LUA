local function gan_ning_huang_zu()
	core:remove_listener("ganinghaungzu")
	core:add_listener(
	"ganinghaungzu",
	"IncidentOccuredEvent",
	function(context)
     return context:incident() == "3k_main_historical_gan_ning_zu_npc_incident"
	end,
	function(context)
		--out("Havie: It Works!");
        local ganning_character = cm:query_model():character_for_template("3k_main_template_historical_gan_ning_hero_fire")
        if not ganning_character:is_null_interface() then
            ModLog("GanNing: Not Spawning character already exists")
		else
            cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_huang_zu", "3k_general_fire", "3k_main_template_historical_gan_ning_hero_fire");
			cm:apply_effect_bundle("3k_main_effect_bundle_civil_war_loyalists_won", "3k_main_faction_huang_zu" , 18)
			local ganing=cm:query_model():character_for_template("3k_main_template_historical_gan_ning_hero_fire")
			if(ganing:is_null_interface()==false) then 
				local mganing = cm:modify_character(ganing)
				mganing:add_loyalty_effect("extraordinary_success");  
			end
		end
    end,
	false
	)
end
-- when the game loads run these functions:
cm:add_first_tick_callback(
	function(context)
		if context:query_model():date_in_range(191,198) then
			gan_ning_huang_zu() 
		end
    end
)
