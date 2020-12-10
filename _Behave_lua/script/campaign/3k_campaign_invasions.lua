-- #region Variables
campaign_invasions = {};

campaign_invasions.game_phase_mid_turns = 25; -- The turn number for forces to become 'middle' tier.
campaign_invasions.game_phase_late_turns = 75; -- The turn number for forces to become 'late' tier.

-- A list of weighted units, captains and num_units. Will randomly build an army our of these.
campaign_invasions.unit_group_default = {amount_group = "default", unit_list = "3k_main_chinese", commander_list = "3k_main_chinese"};

campaign_invasions.unit_group_lookups =
{
	--Example: {campaign = "", faction = "", subculture = "", culture = "", amount_group = "", unit_list = "", commander_list = ""}
	{campaign = "3k_dlc04_start_pos", 
		amount_group = "normal", unit_list = "3k_main_chinese", commander_list = "3k_main_chinese"},
	{campaign = "3k_dlc04_start_pos", subculture = "3k_main_subculture_yellow_turban",  
		amount_group = "normal", unit_list = "3k_main_subculture_yellow_turban", commander_list = "3k_main_subculture_yellow_turban"},
	{campaign = "3k_dlc04_start_pos", faction = "3k_dlc04_faction_liang_rebels",
	amount_group = "normal", unit_list = "3k_dlc04_faction_liang_rebels", commander_list = "3k_main_chinese"},
	{campaign = "3k_dlc05_start_pos", faction = "3k_main_faction_lu_bu",
	amount_group = "normal", unit_list = "3k_main_chinese", commander_list = "3k_main_chinese"},
	--3k_main_campaign_map FIX
	{campaign = "3k_main_campaign_map", faction = "3k_main_faction_zhang_yan",
	amount_group = "normal", unit_list = "3k_main_bandits", commander_list = "3k_main_chinese"},
	{campaign = "3k_main_campaign_map", faction = "3k_main_faction_rebels",
	amount_group = "normal", unit_list = "3k_main_bandits", commander_list = "3k_main_chinese"},
	{campaign = "3k_main_campaign_map", 
		amount_group = "normal", unit_list = "3k_main_chinese", commander_list = "3k_main_chinese"}
}

-- The amounts of units to spawn.
-- Sotored as - group -> phase -> strength
campaign_invasions.unit_amounts = {
	["normal"] = {
		["early"] = {["weak"] = 0, ["average"] = 3, ["strong"] = 6, ["very_strong"] = 9 },
		["middle"] = {["weak"] = 1, ["average"] = 4, ["strong"] = 7, ["very_strong"] = 10 },
		["late"] = {["weak"] = 2, ["average"] = 5, ["strong"] = 9, ["very_strong"] = 14 }
	},
	["default"] = {
		["early"] = {["weak"] = 0, ["average"] = 3, ["strong"] = 6, ["very_strong"] = 9 },
		["middle"] = {["weak"] = 1, ["average"] = 4, ["strong"] = 7, ["very_strong"] = 10 },
		["late"] = {["weak"] = 2, ["average"] = 5, ["strong"] = 9, ["very_strong"] = 14 }
	}
}
-- #endregion

-- #region Unit Lists
-- Stored as - group -> phase -> strength
campaign_invasions.unit_lists = { 
	["3k_main_chinese"] = {  -- Han Empire
		["early"] = {
			captains = {
				{unit = "3k_main_unit_earth_jian_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_fire_lance_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_metal_jian_infantry_captain", weight = 1},
				{unit = "3k_main_unit_water_archer_captain", weight = 1},
				{unit = "3k_main_unit_wood_ji_infantry_captain", weight = 1}
			},
			units = {
				{unit = "3k_main_unit_earth_mounted_sabre_militia", weight = 5},
				{unit = "3k_main_unit_fire_mounted_lancer_militia", weight = 5},
				{unit = "3k_main_unit_fire_peasant_raiders", weight = 5},
				{unit = "3k_main_unit_fire_raider_cavalry", weight = 5},
				{unit = "3k_main_unit_metal_axe_band", weight = 5},
				{unit = "3k_main_unit_metal_sabre_militia", weight = 5},
				{unit = "3k_main_unit_water_archer_militia", weight = 5},
				{unit = "3k_main_unit_water_trebuchet", weight = 5},
				{unit = "3k_main_unit_wood_ji_militia", weight = 5},
				{unit = "3k_main_unit_wood_peasant_band", weight = 5},
				{unit = "3k_main_unit_wood_spear_warriors", weight = 5},
				{unit = "3k_main_unit_earth_jian_swordguard_cavalry", weight = 4},
				{unit = "3k_main_unit_earth_sabre_cavalry", weight = 4},
				{unit = "3k_main_unit_fire_lance_cavalry", weight = 4},
				{unit = "3k_main_unit_metal_jian_swordguards", weight = 4},
				{unit = "3k_main_unit_metal_sabre_infantry", weight = 4},
				{unit = "3k_main_unit_water_archers", weight = 4},
				{unit = "3k_main_unit_water_crossbowmen", weight = 4},
				{unit = "3k_main_unit_water_mounted_archers", weight = 4},
				{unit = "3k_main_unit_water_repeating_crossbowmen", weight = 4},
				{unit = "3k_main_unit_wood_ji_infantry", weight = 4},
				{unit = "3k_main_unit_wood_spear_guards", weight = 4}
			}
		},
		["middle"] = {
			captains = {
				{unit = "3k_main_unit_earth_jian_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_fire_lance_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_metal_jian_infantry_captain", weight = 1},
				{unit = "3k_main_unit_water_archer_captain", weight = 1},
				{unit = "3k_main_unit_wood_ji_infantry_captain", weight = 1}
			},
			units = {
				{unit = "3k_main_unit_earth_jian_swordguard_cavalry", weight = 4},
				{unit = "3k_main_unit_earth_sabre_cavalry", weight = 4},
				{unit = "3k_main_unit_fire_lance_cavalry", weight = 4},
				{unit = "3k_main_unit_metal_jian_swordguards", weight = 4},
				{unit = "3k_main_unit_metal_sabre_infantry", weight = 4},
				{unit = "3k_main_unit_water_archers", weight = 4},
				{unit = "3k_main_unit_water_crossbowmen", weight = 4},
				{unit = "3k_main_unit_water_mounted_archers", weight = 4},
				{unit = "3k_main_unit_water_repeating_crossbowmen", weight = 4},
				{unit = "3k_main_unit_wood_ji_infantry", weight = 4},
				{unit = "3k_main_unit_wood_spear_guards", weight = 4},
				{unit = "3k_main_unit_metal_black_mountain_marauders", weight = 3},
				{unit = "3k_main_unit_water_black_mountain_hunters", weight = 3},
				{unit = "3k_main_unit_water_heavy_crossbowmen", weight = 3},
				{unit = "3k_main_unit_water_heavy_repeating_crossbowmen", weight = 3},
				{unit = "3k_main_unit_water_yi_archers", weight = 3},
				{unit = "3k_main_unit_wood_black_mountain_outlaws", weight = 3},
				{unit = "3k_main_unit_wood_heavy_ji_infantry", weight = 3},
				{unit = "3k_main_unit_wood_heavy_spear_guards", weight = 3}
			}
		},
		["late"] = {
			captains = {
				{unit = "3k_main_unit_earth_jian_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_fire_lance_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_metal_jian_infantry_captain", weight = 1},
				{unit = "3k_main_unit_water_archer_captain", weight = 1},
				{unit = "3k_main_unit_wood_ji_infantry_captain", weight = 1}
			},
			units = {
				{unit = "3k_main_unit_metal_black_mountain_marauders", weight = 3},
				{unit = "3k_main_unit_water_black_mountain_hunters", weight = 3},
				{unit = "3k_main_unit_water_heavy_crossbowmen", weight = 3},
				{unit = "3k_main_unit_water_heavy_repeating_crossbowmen", weight = 3},
				{unit = "3k_main_unit_water_yi_archers", weight = 3},
				{unit = "3k_main_unit_wood_black_mountain_outlaws", weight = 3},
				{unit = "3k_main_unit_wood_heavy_ji_infantry", weight = 3},
				{unit = "3k_main_unit_wood_heavy_spear_guards", weight = 3},
				{unit = "3k_main_unit_fire_mercenary_cavalry", weight = 2},
				{unit = "3k_main_unit_metal_mercenary_infantry", weight = 2},
				{unit = "3k_main_unit_water_mercenary_archers", weight = 2}
			}
		}
	},  -- Han Empire
	["3k_main_subculture_yellow_turban"] = { -- Yellow Turban
		["early"] = {
			captains = {
				{unit = "3k_ytr_unit_metal_yellow_turban_warriors_captain", weight = 1},
				{unit = "3k_ytr_unit_water_yellow_turban_archers_captain", weight = 1},
				{unit = "3k_ytr_unit_wood_yellow_turban_spearmen_captain", weight = 1}
			},
			units = {
				{unit = "3k_dlc04_unit_metal_peasant_volunteers", weight = 5},
				{unit = "3k_dlc04_unit_water_poachers", weight = 5},
				{unit = "3k_dlc04_unit_earth_mounted_sabre_defectors", weight = 4},
				{unit = "3k_dlc04_unit_fire_mounted_lancer_defectors", weight = 4},
				{unit = "3k_dlc04_unit_metal_redeemed_outlaws", weight = 4},
				{unit = "3k_dlc04_unit_metal_sabre_defectors", weight = 4},
				{unit = "3k_dlc04_unit_water_archer_defectors", weight = 4},
				{unit = "3k_dlc04_unit_water_archer_gang", weight = 4},
				{unit = "3k_dlc04_unit_wood_ji_defectors", weight = 4},
				{unit = "3k_dlc04_unit_wood_spearmen_gang", weight = 4}
			}
		},
		["middle"] = {
			captains = {
				{unit = "3k_ytr_unit_metal_yellow_turban_warriors_captain", weight = 1},
				{unit = "3k_ytr_unit_water_yellow_turban_archers_captain", weight = 1},
				{unit = "3k_ytr_unit_wood_yellow_turban_spearmen_captain", weight = 1}
			},
			units = {
				{unit = "3k_dlc04_unit_earth_mounted_sabre_defectors", weight = 4},
				{unit = "3k_dlc04_unit_fire_mounted_lancer_defectors", weight = 4},
				{unit = "3k_dlc04_unit_metal_redeemed_outlaws", weight = 4},
				{unit = "3k_dlc04_unit_metal_sabre_defectors", weight = 4},
				{unit = "3k_dlc04_unit_water_archer_defectors", weight = 4},
				{unit = "3k_dlc04_unit_water_archer_gang", weight = 4},
				{unit = "3k_dlc04_unit_wood_ji_defectors", weight = 4},
				{unit = "3k_dlc04_unit_wood_spearmen_gang", weight = 4},
				{unit = "3k_dlc04_unit_wood_ascetics_of_the_way", weight = 3},
				{unit = "3k_dlc04_unit_wood_fervent_defenders", weight = 3},
				{unit = "3k_dlc04_unit_wood_stalwart_shields", weight = 3},
			}
		},
		["late"] = {
			captains = {
				{unit = "3k_ytr_unit_metal_yellow_turban_warriors_captain", weight = 1},
				{unit = "3k_ytr_unit_water_yellow_turban_archers_captain", weight = 1},
				{unit = "3k_ytr_unit_wood_yellow_turban_spearmen_captain", weight = 1}
			},
			units = {
				{unit = "3k_dlc04_unit_earth_messengers_of_heaven", weight = 2},
				{unit = "3k_dlc04_unit_fire_righteous_vanguards", weight = 2},
				{unit = "3k_dlc04_unit_metal_bringers_of_peace", weight = 2},
				{unit = "3k_dlc04_unit_metal_exemplars_of_the_tao", weight = 2},
				{unit = "3k_dlc04_unit_metal_huanglao_s_paragons", weight = 2},
				{unit = "3k_dlc04_unit_water_the_land_s_chosen", weight = 2},
				{unit = "3k_dlc04_unit_water_yaoguai_hunters", weight = 2},
				{unit = "3k_dlc04_unit_earth_jaizi_raiders", weight = 1},
				{unit = "3k_dlc04_unit_fire_tyrant_slayers", weight = 1},
				{unit = "3k_dlc04_unit_metal_chosen_of_the_eight_immortals", weight = 1},
				{unit = "3k_dlc04_unit_wood_gallants_of_the_people", weight = 1},
				{unit = "3k_dlc04_unit_wood_zealots_of_the_way", weight = 1}
			}
		} -- Yellow Turban
	},
	["3k_dlc04_faction_liang_rebels"] = { -- Liang Rebels
		["early"] = {
			captains = {
				{unit = "3k_main_unit_earth_jian_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_fire_lance_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_metal_jian_infantry_captain", weight = 1},
				{unit = "3k_main_unit_water_archer_captain", weight = 1},
				{unit = "3k_main_unit_wood_ji_infantry_captain", weight = 1}
			},
			units = {
				{unit = "3k_dlc04_unit_metal_qiang_warriors", weight = 1},
				{unit = "3k_dlc04_unit_water_qiang_archers", weight = 1},
				{unit = "3k_dlc04_unit_wood_qiang_polearms", weight = 1},
				{unit = "3k_main_unit_earth_qiang_raiders", weight = 1},
				{unit = "3k_main_unit_fire_qiang_marauders", weight = 1},
				{unit = "3k_main_unit_water_qiang_hunters", weight = 1}
			}
		},
		["middle"] = {
			captains = {
				{unit = "3k_main_unit_earth_jian_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_fire_lance_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_metal_jian_infantry_captain", weight = 1},
				{unit = "3k_main_unit_water_archer_captain", weight = 1},
				{unit = "3k_main_unit_wood_ji_infantry_captain", weight = 1}
			},
			units = {
				{unit = "3k_dlc04_unit_metal_qiang_warriors", weight = 1},
				{unit = "3k_dlc04_unit_water_qiang_archers", weight = 1},
				{unit = "3k_dlc04_unit_wood_qiang_polearms", weight = 1},
				{unit = "3k_main_unit_earth_qiang_raiders", weight = 1},
				{unit = "3k_main_unit_fire_qiang_marauders", weight = 1},
				{unit = "3k_main_unit_water_qiang_hunters", weight = 1}
			}
		},
		["late"] = {
			captains = {
				{unit = "3k_main_unit_earth_jian_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_fire_lance_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_metal_jian_infantry_captain", weight = 1},
				{unit = "3k_main_unit_water_archer_captain", weight = 1},
				{unit = "3k_main_unit_wood_ji_infantry_captain", weight = 1}
			},
			units = {
				{unit = "3k_dlc04_unit_metal_qiang_warriors", weight = 1},
				{unit = "3k_dlc04_unit_water_qiang_archers", weight = 1},
				{unit = "3k_dlc04_unit_wood_qiang_polearms", weight = 1},
				{unit = "3k_main_unit_earth_qiang_raiders", weight = 1},
				{unit = "3k_main_unit_fire_qiang_marauders", weight = 1},
				{unit = "3k_main_unit_water_qiang_hunters", weight = 1}
			}
		} -- Liang Rebels
	},
	["3k_main_bandits"] = {
		["early"] = {
			captains = {
				{unit = "3k_main_unit_earth_jian_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_fire_mercenary_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_metal_mercenary_infantry_captain", weight = 1},
				{unit = "3k_main_unit_water_mercenary_archers_captain", weight = 1},
				{unit = "3k_main_unit_wood_ji_infantry_captain", weight = 1}
			},
			units = {
				{unit = "3k_main_unit_wood_black_mountain_outlaws", weight = 1},
				{unit = "3k_main_unit_water_black_mountain_hunters", weight = 1},
				{unit = "3k_main_unit_water_black_mountain_hunters", weight = 1},
				{unit = "3k_main_unit_metal_black_mountain_marauders", weight = 1},
				{unit = "3k_main_unit_metal_sabre_militia", weight = 1},
				{unit = "3k_main_unit_wood_ji_militia", weight = 1}
			}
		},
		["middle"] = {
			captains = {
				{unit = "3k_main_unit_earth_jian_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_fire_mercenary_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_metal_mercenary_infantry_captain", weight = 1},
				{unit = "3k_main_unit_water_mercenary_archers_captain", weight = 1},
				{unit = "3k_main_unit_wood_ji_infantry_captain", weight = 1}
			},
			units = {
				{unit = "3k_main_unit_wood_black_mountain_outlaws", weight = 1},
				{unit = "3k_main_unit_water_black_mountain_hunters", weight = 1},
				{unit = "3k_main_unit_metal_black_mountain_marauders", weight = 1},
				{unit = "3k_main_unit_wood_black_mountain_outlaws", weight = 1},
				{unit = "3k_main_unit_metal_sabre_infantry", weight = 1},
				{unit = "3k_main_unit_water_black_mountain_hunters", weight = 1}
			}
		},
		["late"] = {
			captains = {
				{unit = "3k_main_unit_earth_jian_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_fire_mercenary_cavalry_captain", weight = 1},
				{unit = "3k_main_unit_metal_mercenary_infantry_captain", weight = 1},
				{unit = "3k_main_unit_water_archer_captain", weight = 1},
				{unit = "3k_main_unit_wood_ji_infantry_captain", weight = 1}
			},
			units = {
				{unit = "3k_main_unit_metal_black_mountain_marauders", weight = 1},
				{unit = "3k_main_unit_metal_black_mountain_marauders", weight = 1},
				{unit = "3k_main_unit_metal_black_mountain_marauders", weight = 1},
				{unit = "3k_main_unit_water_black_mountain_hunters", weight = 1},
				{unit = "3k_main_unit_water_black_mountain_hunters", weight = 1},
				{unit = "3k_main_unit_wood_black_mountain_outlaws", weight = 1}
			}
		} -- Liang Rebels
	}
}
-- #endregion


-- #region Commander Lists
-- The commanders to spawn in the army.
-- Stored as - group -> phase -> strength
campaign_invasions.commander_lists = {
	["3k_main_chinese"] = { -- Han Empire
		["early"] = { -- early
			["weak"] = {  -- weak
				{subtype = "3k_general_earth", 	template = "3k_dlc04_template_scripted_han_chinese_earth_weak_early"},
				{subtype = "3k_general_fire", 	template = "3k_dlc04_template_scripted_han_chinese_fire_weak_early"},
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_han_chinese_metal_weak_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_han_chinese_water_weak_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_han_chinese_wood_weak_early"}
			}, -- weak
			["average"] = {  -- average
				{subtype = "3k_general_earth", 	template = "3k_dlc04_template_scripted_han_chinese_earth_average_early"},
				{subtype = "3k_general_fire", 	template = "3k_dlc04_template_scripted_han_chinese_fire_average_early"},
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_han_chinese_metal_average_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_han_chinese_water_average_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_han_chinese_wood_average_early"}
			}, -- average
			["strong"] = { -- strong
				{subtype = "3k_general_earth", 	template = "3k_dlc04_template_scripted_han_chinese_earth_strong_early"},
				{subtype = "3k_general_fire", 	template = "3k_dlc04_template_scripted_han_chinese_fire_strong_early"},
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_han_chinese_metal_strong_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_han_chinese_water_strong_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_han_chinese_wood_strong_early"}
			}, -- strong
			["very_strong"] = { -- very_strong
				{subtype = "3k_general_earth", 	template = "3k_dlc04_template_scripted_han_chinese_earth_strong_early"},
				{subtype = "3k_general_fire", 	template = "3k_dlc04_template_scripted_han_chinese_fire_strong_early"},
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_han_chinese_metal_strong_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_han_chinese_water_strong_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_han_chinese_wood_strong_early"}
			} -- very_strong
		}, -- early
		["middle"] = { -- middle
			["weak"] = {  -- weak
				{subtype = "3k_general_earth", 	template = "3k_dlc04_template_scripted_han_chinese_earth_weak_early"},
				{subtype = "3k_general_fire", 	template = "3k_dlc04_template_scripted_han_chinese_fire_weak_early"},
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_han_chinese_metal_weak_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_han_chinese_water_weak_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_han_chinese_wood_weak_early"}
			}, -- weak
			["average"] = {  -- average
				{subtype = "3k_general_earth", 	template = "3k_dlc04_template_scripted_han_chinese_earth_average_early"},
				{subtype = "3k_general_fire", 	template = "3k_dlc04_template_scripted_han_chinese_fire_average_early"},
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_han_chinese_metal_average_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_han_chinese_water_average_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_han_chinese_wood_average_early"}
			}, -- average
			["strong"] = { -- strong
				{subtype = "3k_general_earth", 	template = "3k_dlc04_template_scripted_han_chinese_earth_strong_early"},
				{subtype = "3k_general_fire", 	template = "3k_dlc04_template_scripted_han_chinese_fire_strong_early"},
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_han_chinese_metal_strong_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_han_chinese_water_strong_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_han_chinese_wood_strong_early"}
			}, -- strong
			["very_strong"] = { -- very_strong
				{subtype = "3k_general_earth", 	template = "3k_dlc04_template_scripted_han_chinese_earth_strong_early"},
				{subtype = "3k_general_fire", 	template = "3k_dlc04_template_scripted_han_chinese_fire_strong_early"},
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_han_chinese_metal_strong_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_han_chinese_water_strong_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_han_chinese_wood_strong_early"}
			} -- very_strong
		}, -- middle
		["late"] = { -- late
			["weak"] = {  -- weak
				{subtype = "3k_general_earth", 	template = "3k_dlc04_template_scripted_han_chinese_earth_weak_early"},
				{subtype = "3k_general_fire", 	template = "3k_dlc04_template_scripted_han_chinese_fire_weak_early"},
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_han_chinese_metal_weak_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_han_chinese_water_weak_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_han_chinese_wood_weak_early"}
			}, -- weak
			["average"] = {  -- average
				{subtype = "3k_general_earth", 	template = "3k_dlc04_template_scripted_han_chinese_earth_average_early"},
				{subtype = "3k_general_fire", 	template = "3k_dlc04_template_scripted_han_chinese_fire_average_early"},
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_han_chinese_metal_average_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_han_chinese_water_average_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_han_chinese_wood_average_early"}
			}, -- average
			["strong"] = { -- strong
				{subtype = "3k_general_earth", 	template = "3k_dlc04_template_scripted_han_chinese_earth_strong_early"},
				{subtype = "3k_general_fire", 	template = "3k_dlc04_template_scripted_han_chinese_fire_strong_early"},
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_han_chinese_metal_strong_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_han_chinese_water_strong_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_han_chinese_wood_strong_early"}
			}, -- strong
			["very_strong"] = { -- very_strong
				{subtype = "3k_general_earth", 	template = "3k_dlc04_template_scripted_han_chinese_earth_strong_early"},
				{subtype = "3k_general_fire", 	template = "3k_dlc04_template_scripted_han_chinese_fire_strong_early"},
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_han_chinese_metal_strong_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_han_chinese_water_strong_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_han_chinese_wood_strong_early"}
			} -- very_strong
		} -- late
	},  -- Han Empire
	["3k_main_subculture_yellow_turban"] = { -- YT
		["early"] = { -- early
			["weak"] = {  -- weak
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_yellow_turban_metal_weak_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_yellow_turban_water_weak_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_yellow_turban_wood_weak_early"}
			}, -- weak
			["average"] = {  -- average
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_yellow_turban_metal_average_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_yellow_turban_water_average_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_yellow_turban_wood_average_early"}
			}, -- average
			["strong"] = { -- strong
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_yellow_turban_metal_strong_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_yellow_turban_water_strong_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_yellow_turban_wood_strong_early"}
			}, -- strong
			["very_strong"] = { -- very_strong
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_yellow_turban_metal_strong_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_yellow_turban_water_strong_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_yellow_turban_wood_strong_early"}
			} -- very_strong			
		}, -- early
		["middle"] = { -- middle
			["weak"] = {  -- weak
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_yellow_turban_metal_weak_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_yellow_turban_water_weak_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_yellow_turban_wood_weak_early"}
			}, -- weak
			["average"] = {  -- average
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_yellow_turban_metal_average_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_yellow_turban_water_average_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_yellow_turban_wood_average_early"}
			}, -- average
			["strong"] = { -- strong
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_yellow_turban_metal_strong_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_yellow_turban_water_strong_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_yellow_turban_wood_strong_early"}
			}, -- strong
			["very_strong"] = { -- very_strong
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_yellow_turban_metal_strong_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_yellow_turban_water_strong_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_yellow_turban_wood_strong_early"}
			} -- very_strong	
		}, -- middle
		["late"] = { -- late
			["weak"] = {  -- weak
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_yellow_turban_metal_weak_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_yellow_turban_water_weak_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_yellow_turban_wood_weak_early"}
			}, -- weak
			["average"] = {  -- average
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_yellow_turban_metal_average_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_yellow_turban_water_average_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_yellow_turban_wood_average_early"}
			}, -- average
			["strong"] = { -- strong
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_yellow_turban_metal_strong_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_yellow_turban_water_strong_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_yellow_turban_wood_strong_early"}
			}, -- strong
			["very_strong"] = { -- very_strong
				{subtype = "3k_general_metal", 	template = "3k_dlc04_template_scripted_yellow_turban_metal_strong_early"},
				{subtype = "3k_general_water", 	template = "3k_dlc04_template_scripted_yellow_turban_water_strong_early"},
				{subtype = "3k_general_wood", 	template = "3k_dlc04_template_scripted_yellow_turban_wood_strong_early"}
			} -- very_strong	
		} -- late
	} -- YT
};
-- #endregion

-- #region Invasion Creation Encapsulation

-- Creates a generic invasion with no target.
-- Selects the general for the army, from the list above and the units in the army.
function campaign_invasions:create_invasion(invasion_faction_key, spawn_region, difficulty_rating, opt_delay_start, opt_target_faction, opt_suppress_event_feed, opt_x, opt_y)

	ModLog("creating an Invasion")
	if not is_string(invasion_faction_key) then
		ModLog("ERROR: create_invasion() called but supplied faction value [" .. tostring(invasion_faction_key) .. "] is not nil or a boolean");
		return false;
	end;

	if not is_string(spawn_region) then
		ModLog("ERROR: create_invasion() called but supplied region value [" .. tostring(spawn_region) .. "] is not nil or a boolean");
		return false;
	end;

	if not is_number(difficulty_rating) then
		ModLog("ERROR: create_invasion() called but supplied difficulty value [" .. tostring(difficulty_rating) .. "] is not nil or a boolean");
		return false;
	end;

	if opt_delay_start and not is_boolean(opt_delay_start) then
		ModLog("ERROR: create_invasion() called but supplied delay_start value [" .. tostring(opt_delay_start) .. "] is not nil or a boolean");
		return false;
	end;

	if opt_target_faction and not is_string(opt_target_faction) then
		ModLog("ERROR: create_invasion() called but supplied target faction value [" .. tostring(opt_target_faction) .. "] is not nil or a boolean");
		return false;
	end;

	if opt_suppress_event_feed and not is_boolean(opt_suppress_event_feed) then
		ModLog("ERROR: create_invasion() called but supplied opt_suppress_event_feed value [" .. tostring(opt_suppress_event_feed) .. "] is not nil or a boolean");
		return false;
	end;

	if opt_x and not is_number(opt_x) then
		ModLog("ERROR: create_invasion() called but supplied opt_x value [" .. tostring(opt_x) .. "] is not nil or a boolean");
		return false;
	end;

	if opt_y and not is_number(opt_y) then
		ModLog("ERROR: create_invasion() called but supplied opt_y value [" .. tostring(opt_y) .. "] is not nil or a boolean");
		return false;
	end;
	ModLog("Passed all the error checks thus far")
	-- Get the invasion faction (which may be dead)
	local invasion_query_faction = cm:query_faction(invasion_faction_key);

	if not invasion_query_faction or invasion_query_faction:is_null_interface() then
		ModLog("ERROR: create_invasion() called but cannot find an invasion faction for key [" .. tostring(invasion_faction_key) .. "]");
		return false;
	end;
	ModLog("Passed 1 more check")

	-- Get the phase data
	local key = "campaign_invasion_" .. self:get_unique_key();
	local game_phase = self:get_game_phase();
	difficulty_rating = self:get_difficulty_rating(difficulty_rating);


	-- Pick a unit group
	local unit_group = self:impl_get_best_unit_group(invasion_faction_key, cm:query_model():campaign_name(), invasion_query_faction:culture(), invasion_query_faction:subculture());
	ModLog("I13")
	if not unit_group then
		ModLog("Force Generation Failed: Valid unit group.");
		return false;
	end;
		ModLog("I13-14")

	-- Find a general to lead the force
	general_subtype, general_template = self:get_general_subtype_template(unit_group.commander_list, difficulty_rating, game_phase);
		ModLog("I15")
	if not general_subtype then
		ModLog("Force Generation Failed: No General");
		return false;
	end;
	
	if not game_phase then
			ModLog("NOGamePhase");
	end
		if not difficulty_rating then
			ModLog("NOdifficulty_rating");
	end
		if not unit_group then
			ModLog("NOunit_group");
	end
	
	ModLog("phase: "..tostring(game_phase))
	ModLog("difficulty_rating: "..tostring(difficulty_rating))
	ModLog("unit_group: "..tostring(unit_group))
ModLog("I16")
	-- Get the num units.
	ModLog("unit_group.amount_group"..tostring(unit_group.amount_group))
	ModLog("game_phase"..tostring(game_phase))
	ModLog("difficulty_rating"..tostring(difficulty_rating))
	local num_units = self.unit_amounts[unit_group.amount_group][game_phase][difficulty_rating];
ModLog("I17")
	if not num_units then
ModLog("Force Generation Failed: Unable to find unit amount.");
		return false;
	end;
ModLog("I18")
	local units = self:get_units(unit_group.unit_list, game_phase, num_units); -- This can be nil

ModLog("I19")
	-- Find a spawn location
	local found_spawn, spawn_x, spawn_y = invasion_query_faction:get_valid_spawn_location_in_region(spawn_region, true);
	ModLog("I19")
	if opt_x and opt_y then	
		found_spawn = true;
		spawn_x = opt_x;
		spawn_y = opt_y;
	end;
ModLog("I20")
	if not found_spawn then
		ModLog("Force Generation Failed: No valid spawn location found");
		return false;
	end;
ModLog("I21")
	-- Generate invasion and variables.
	local invasion = invasion_manager:new_invasion(
		key,
		invasion_faction_key,
		units,
		{spawn_x, spawn_y}
	);
ModLog("I22")
ModLog("general_subtype: ".. tostring(general_subtype))
ModLog("general_template: ".. tostring(general_template))

	invasion:create_general(false, general_subtype, general_template);
ModLog("I22")
	local exp_to_give = 0;
	if game_phase == "late" then
		exp_to_give = cm:modify_model():random_number(88000, 206000) -- Level 7 - 9
	elseif game_phase == "middle" then
		exp_to_give = cm:modify_model():random_number(16000, 53000) -- Level 4 - 6
	else
		exp_to_give = cm:modify_model():random_number(0, 8000) -- Level 1 - 3
	end;
ModLog("I23")
	invasion:add_character_experience(exp_to_give);
ModLog("I24")
	if opt_target_faction then
		invasion:set_target("NONE", nil, opt_target_faction);
	end;
ModLog("I25")
	if opt_suppress_event_feed then
		invasion:suppress_event_feed(true);
	end;
ModLog("I26")
	if not opt_delay_start then
		ModLog("..Started Invasion here")
		invasion:start_invasion();
	end;
ModLog("I27")
	return invasion;
end;

function campaign_invasions:create_invasion_attack_region(invasion_faction_key, spawn_region, difficulty_rating, target_region, opt_suppress_event_feed, opt_x, opt_y)
	ModLog("We are creating an invasion in campaign_invasions:create_invasion_attack_region")
	local invasion = self:create_invasion(invasion_faction_key, spawn_region, difficulty_rating, true, nil, opt_suppress_event_feed, opt_x, opt_y);
	ModLog("passed initial create")
	local target_owner = cm:query_region(target_region):owning_faction():name();
	invasion:set_target("REGION", target_region, target_owner);
	ModLog("..Passed, set target"..tostring(target_region).." . "..tostring(target_owner))
	invasion:start_invasion();
	ModLog("..Passed, Start Invasion")
end;

function campaign_invasions:create_invasion_attack_character(invasion_faction_key, spawn_region, difficulty_rating, target_character_cqi, opt_suppress_event_feed, opt_x, opt_y)
	local invasion = self:create_invasion(invasion_faction_key, spawn_region, difficulty_rating, true, nil, opt_suppress_event_feed, opt_x, opt_y);

	local target_character = cm:query_character(target_character_cqi);
	invasion:set_target("CHARACTER", target_character_cqi, target_character:faction():name());

	invasion:start_invasion();
end;

function campaign_invasions:create_invasion_attack_force(invasion_faction_key, spawn_region, difficulty_rating, target_character_cqi, opt_suppress_event_feed, opt_x, opt_y)
	local invasion = self:create_invasion(invasion_faction_key, spawn_region, difficulty_rating, true, nil, opt_suppress_event_feed, opt_x, opt_y);

	local target_force = cm:query_military_force(target_character_cqi);
	invasion:set_target("FORCE", target_force:command_queue_index(), target_force:faction():name());

	invasion:start_invasion();
end;

function campaign_invasions:create_invasion_patrol(invasion_faction_key, spawn_region, difficulty_rating, patrol_points)
	local invasion = self:create_invasion(invasion_faction_key, spawn_region, difficulty_rating, true);

	-- Fix up the format of the patrol points.
	for i = 1, #patrol_points do
		local patrol_point = patrol_points[i];

		-- If patrol is missing X/Y we assume it's just a normal array.
		if not patrol_point.x or not patrol_point.y then
			if #patrol_point < 2 then
				script_error("Patrol point item has less than 2 values (x & y). Exiting.");
				return false;
			end;
		
			patrol_point.x = patrol_point[1];
			patrol_point.y = patrol_point[2];

			patrol_point[1] = nil;
			patrol_point[2] = nil;
		end;
	end;

	invasion:set_target("PATROL", patrol_points);

	invasion:start_invasion();
end;

-- #endregion

-- #region Invastion Data Getters
function campaign_invasions:get_unique_key()
	local invasions_spawned = 0;

	if cm:saved_value_exists("num_invasions_spawned", "campaign_invasions") then
		invasions_spawned = cm:get_saved_value("num_invasions_spawned", "campaign_invasions");
	end;

	invasions_spawned = invasions_spawned + 1;

	cm:set_saved_value("num_invasions_spawned", invasions_spawned, "campaign_invasions");

	return invasions_spawned;
end;


function campaign_invasions:get_units(unit_group, game_phase, num_units)
	local unit_data = nil;

	if self.unit_lists[unit_group][game_phase] then
		unit_data = self.unit_lists[unit_group][game_phase];
	end;

	local selected_units = {};

	-- Validation
	if not unit_data or not num_units then
		script_error("Unable to find unit_list with data- group=[" .. tostring(unit_group) .. "] phase=[".. tostring(game_phase) .. "]");
		return false;
	end;

	-- Calculate total weight
	local captain_total_weight = 0;
	local unit_total_weight = 0;

	for i, v in ipairs(unit_data.captains) do
		captain_total_weight = captain_total_weight + v.weight;
	end;

	for i, v in ipairs(unit_data.units) do
		unit_total_weight = unit_total_weight + v.weight;
	end;


	-- Add our units.
	local is_captain = false; -- Are we trying to spawn a captain.
	local r = 0; -- Random number used for weighting.
	
	for i = 1, num_units do

		-- Check if we're a captain. the 1st and 8th unit are captains.
		is_captain = false;
		if i == 1 or i == 8 then 
			is_captain = true;
		end;

		-- Use a weighted random to select which unit we spawn.
		if is_captain then
			-- Roll a weighted random
			r = cm:modify_model():random_number(0, captain_total_weight);

			-- Use our modified values from above to work out the weighting.
			for i, captain_data in ipairs( unit_data.captains ) do
			
				r = r - captain_data.weight; -- Subtract the weighting from our random total above.

				if r <= 0 then -- If we're below 0 then we fall within that attribute's values.
					table.insert(selected_units, captain_data.unit);
					break;
				end;
				
			end;
		else
			-- Roll a weighted random
			r = cm:modify_model():random_number(0, unit_total_weight);

			-- Use our modified values from above to work out the weighting.
			for i, unit_data in ipairs( unit_data.units ) do
			
				r = r - unit_data.weight; -- Subtract the weighting from our random total above.

				if r <= 0 then -- If we're below 0 then we fall within that attribute's values.
					table.insert(selected_units, unit_data.unit);
					break;
				end;
				
			end;
		end;
	end;

	-- Get Units
	return table.concat( selected_units, "," );
end;

function campaign_invasions:get_general_subtype_template(general_group, strength, game_phase)
	local general_subtype, general_template;
	local general_datas = self.commander_lists[general_group][game_phase][strength];
	local selected_general_data = nil;

	if not general_datas or #general_datas < 1 then
		script_error("Unable to find general with data- general_group=[" .. tostring(general_group) .. "] phase=[".. tostring(game_phase) .. "]");
		return false, false;
	end;

	-- Select a random general from those we got.
	local r = cm:modify_model():random_number(0, #general_datas);

	for i, gd in ipairs(general_datas) do
		r = r - 1;

		if r <= 0 then
			selected_general_data = gd;
			break;
		end;
	end;

	general_subtype = selected_general_data.subtype;
	general_template = selected_general_data.template;

	return general_subtype, general_template;
end;

function campaign_invasions:get_difficulty_rating(difficulty_rating)
	if difficulty_rating == 1 then
		return "weak";
	elseif difficulty_rating == 2 then
		return "average";
	elseif difficulty_rating == 3 then
		return "strong";
	else
		return "very_strong";
	end;
end;

function campaign_invasions:get_game_phase()
	local turn_number = cm:query_model():turn_number();

	if turn_number >= self.game_phase_late_turns  then
		return "late";
	elseif turn_number >= self.game_phase_mid_turns then
		return "middle";
	else
		return "early";
	end
end;

--- @function impl_get_best_unit_group
--- @desc Gets the best patch progression group based on faction_key, campaign_key, culture_key, subculture_key
--- @p string faction_key
--- @p string campaign_key
--- @p string culture_key
--- @p string subculture_key
--- @return progression_group
function campaign_invasions:impl_get_best_unit_group(faction_key, campaign_key, culture_key, subculture_key)
	local highest_scoring_group = self.unit_group_default; -- the group to return if we matched nothing.
	local highest_score = -1;
	
	ModLog("CAMPAIGN:" .. tostring(campaign_key) )
	ModLog("something called campaign_invasions:impl_get_best_unit_group" )
	
	for index, lookup in ipairs(self.unit_group_lookups) do
		local score = -1;

		if lookup.faction == faction_key then -- We matched our value
			score = score + 1000;
		elseif lookup.faction and lookup.faction ~= "" then -- It has a different value
			score = score - 10000;
		end;

		if lookup.campaign == campaign_key then -- We matched our value
			score = score + 100;
			ModLog("lookup1")
		elseif lookup.campaign and lookup.campaign ~= "" then -- It has a different value
			score = score - 10000;
			ModLog("lookup2")
		end;

		if lookup.subculture == subculture_key then -- We matched our value
			score = score + 10;
		elseif lookup.subculture and lookup.subculture ~= "" then -- It has a different value
			score = score - 10000;
		end;

		if lookup.culture == culture_key then -- We matched our value
			score = score + 1;
		elseif lookup.culture and lookup.subculture ~= "" then -- It has a different value
			score = score - 10000;
		end;
		
		ModLog("Score= " .. tostring(score))
		-- Test if we got a higher value.
		if score > highest_score then
			ModLog("Score is higher than highest" .. tostring(highest_score) )
			highest_scoring_group = lookup;
		end;
	end;

	
	local retVal = highest_scoring_group;
	ModLog("FinalRet= " .. tostring(retVal))

	if retVal then
		return retVal;
	end;

	ModLog("Error unable to find group match on the following criteria. [faction: " .. tostring(faction_key) .. "] [campaign: " .. tostring(campaign_key) .. "] [subculture: " .. tostring(subculture_key) .. "] [culture_key: " .. tostring(culture_key) .. "]");
	return nil;
end;

-- #endregion

-- #region Helpers
function campaign_invasions:create_patrol(start_x, start_y)
	local patrol = {};
	
	self:add_patrol_point(start_x, start_y);
	
	return patrol;
end;

function campaign_invasions:add_patrol_point(patrol, x, y)
	table.insert( patrol, {x, y} );
end;

function campaign_invasions:print(text)
	out.random_army("[503] 3K Invasions: " .. tostring(text));
end;
-- #endregion

