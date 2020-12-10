-- #region Emergent Factions
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- EMERGENT FACTIONS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
dlc04_emergent_factions = {};

function dlc04_emergent_factions:register()
	-- "3k_main_faction_yuan_shao"
	local yuan_shao_faction = emergent_faction:new("yuan_shao", "3k_main_faction_yuan_shao", "3k_main_template_historical_yuan_shao_hero_earth", "3k_general_earth", "3k_main_weijun_capital", true);
	yuan_shao_faction:add_emergence_dilemma("3k_dlc04_emergence_global_emergence_spawn_yuan_shao_dilemma");
	yuan_shao_faction:add_leave_incident("3k_dlc04_emergence_global_emergence_leave_yuan_shao_incident");
	yuan_shao_faction:add_on_spawned_callback( function() out.design("Yuan Shao Army Spawned") end );
	yuan_shao_faction:add_spawn_dates(188, 192);
	yuan_shao_faction:add_spawn_condition(
		function()
			-- Only leave if He Jin is dead or has left the Empire. Most likely scenario is if he is killed by the Eunuchs.
			local he_jin = cm:query_model():character_for_template("3k_dlc04_template_historical_he_jin_metal");
			if he_jin:is_null_interface() or he_jin:is_dead() or he_jin:faction():name() ~= "3k_dlc04_faction_empress_he" then
				return true;
			end;
			return false;
		end);
	emergent_faction_manager:add_emergent_faction(yuan_shao_faction);

	-- "3k_main_faction_kong_rong"
	local kong_rong_faction = emergent_faction:new("kong_rong", "3k_main_faction_kong_rong", "3k_main_template_historical_kong_rong_hero_water", "3k_general_water", "3k_main_beihai_capital", true);
	kong_rong_faction:add_emergence_dilemma("3k_dlc04_emergence_global_emergence_spawn_kong_rong_dilemma");
	kong_rong_faction:add_leave_incident("3k_dlc04_emergence_global_emergence_leave_kong_rong_incident");
	kong_rong_faction:add_on_spawned_callback( function() out.design("Kong Rong Army Spawned") end );
	kong_rong_faction:add_spawn_dates(187, 187);
	emergent_faction_manager:add_emergent_faction(kong_rong_faction);

	-- Zhang Yan - 3k_main_faction_zhang_yan
	local zhang_yan_faction = emergent_faction:new("zhang_yan", "3k_main_faction_zhang_yan", "3k_main_template_historical_zhang_yan_hero_wood", "3k_general_wood", "3k_main_yanmen_capital", false);
	zhang_yan_faction:add_emergence_dilemma("3k_dlc04_emergence_global_emergence_spawn_zhang_yan_dilemma");
	zhang_yan_faction:add_leave_incident("3k_dlc04_emergence_global_emergence_leave_zhang_yan_incident");
	zhang_yan_faction:add_on_spawned_callback( function() out.design("Zhang Yan Army Spawned") end );
	zhang_yan_faction:add_spawn_dates(185, 185);
	emergent_faction_manager:add_emergent_faction(zhang_yan_faction);

	-- Zheng Jiang -- 3k_main_faction_zheng_jiang
	local zheng_jiang_faction = emergent_faction:new("zheng_jiang", "3k_main_faction_zheng_jiang", "3k_main_template_historical_lady_zheng_jiang_hero_wood", "3k_general_wood", "3k_main_taiyuan_capital", false);
	zheng_jiang_faction:add_emergence_dilemma("3k_dlc04_emergence_global_emergence_spawn_zheng_jiang_dilemma");
	zheng_jiang_faction:add_leave_incident("3k_dlc04_emergence_global_emergence_leave_zheng_jiang_incident");
	zheng_jiang_faction:add_on_spawned_callback( function() out.design("Zheng Jiang Army Spawned") end );
	zheng_jiang_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(zheng_jiang_faction);

	-- Lu Bu -- 3k_main_faction_lu_bu
	local lu_bu_faction = emergent_faction:new("lu_bu", "3k_main_faction_lu_bu", "3k_main_template_historical_lu_bu_hero_fire", "3k_general_fire", "3k_main_yingchuan_capital", false);
	lu_bu_faction:add_emergence_dilemma("3k_dlc04_emergence_global_emergence_spawn_lu_bu_dilemma");
	lu_bu_faction:add_leave_incident("3k_dlc04_emergence_global_emergence_leave_lu_bu_incident");
	lu_bu_faction:add_on_spawned_callback( function() out.design("Lu Bu Army Spawned") end );
	lu_bu_faction:add_spawn_dates(192, 194);
	lu_bu_faction:add_spawn_condition(
		function()
			-- leave if dong zhuo died and not leader.
			local dz_char = cm:query_model():character_for_template("3k_main_template_historical_dong_zhuo_hero_fire");
			ModLog("checkingDLC04???")
			if dz_char and not dz_char:is_null_interface() then
				if dz_char:is_dead() then
					return true;
				end;
			end;

			return false;
		end);
	emergent_faction_manager:add_emergent_faction(lu_bu_faction);
end;
-- #endregion