---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			--Havies Core Officers
----- Description: 	Will apply a satisfaction bonus to AI Major factions important characters
----- in hopes that the AI doesnt dismiss them. 		
-----			
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

local printStatements=false;



local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@havie_coreofficers.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec).."] ")
		local header=" (CoreOfficers)): "
		local line= time..header..text
		file:write(line.."\n")
		file:close()
		ModLog(header..text)
    end
end

local function IniDebugger()
	printStatements=true;
	local file = io.open("@havie_coreofficers.txt", "w+")
	file:close()
	CusLog("---Begin File----")
end

local function CheckCore(coreList, factionName, isPlayer) 
--	CusLog("Checking core for : "..tostring(factionName))

	for i, key in ipairs(coreList) do
		local qChar= getQChar2(coreList[i])
		if qChar~=nil then 
			if qChar:faction():name() == factionName and not qChar:is_faction_leader() and qChar:age()>17 then 
				local mchar=cm:modify_character(qChar)
				if not isPlayer and qChar:is_character_is_faction_recruitment_pool() then 
					--CusLog(coreList[i].." was in recruitment pool, ..recruiting for "..factionName)
					mchar:move_to_faction_and_make_recruited(factionName)
				end
				if not isPlayer then 
					mchar:add_loyalty_effect("extraordinary_success");	--pick a diff one? past_experience_fondness
					mchar:add_loyalty_effect("past_experience_fondness");
				elseif RNGHelper(8) then 
					mchar:add_loyalty_effect("past_experience_fondness"); --allow the player to keep his chars he should have?
				end
				
				--CusLog(" Added Loyalty to "..coreList[i])
			elseif not qChar:is_faction_leader() and qChar:age()>17 then 
				--CusLog("Warning: "..coreList[i].."  is in wrong faction: "..qChar:faction():name())
			end
		end
	end
	--CusLog("Finished Checking core for : "..tostring(factionName))
end


local function CheckOfficers(qFaction)
	--CusLog("Begin CheckOfficers")
	--local qFaction= getQFaction(qFactionName)
	--if qFaction==nil then 
	--	CusLog("@@@.!.!.!.. finding nil/dead factions??")
	--	return;
	--	end
	local factionName=qFaction:name();
	local coreList= {}
	
	if qFaction:name()=="3k_main_faction_cao_cao" then 
		table.insert(coreList, "3k_main_template_historical_xiahou_dun_hero_wood");
		table.insert(coreList, "3k_main_template_historical_xiahou_yuan_hero_fire");
		table.insert(coreList, "3k_main_template_historical_xun_yu_hero_water");
		table.insert(coreList, "3k_main_template_historical_guo_jia_hero_water");
		table.insert(coreList, "3k_main_template_historical_sima_yi_hero_water");
		table.insert(coreList, "3k_main_template_historical_xun_yun_hero_earth");
		table.insert(coreList, "3k_main_template_historical_dian_wei_hero_wood");
		--table.insert(coreList, "3k_main_template_historical_dian_wei_hero_wood");
		table.insert(coreList, "3k_main_template_historical_xu_chu_hero_wood");
		table.insert(coreList, "3k_main_template_historical_xu_huang_hero_metal");
		table.insert(coreList, "3k_main_template_historical_yue_jin_hero_metal");
		table.insert(coreList, "3k_main_template_historical_yu_jin_hero_metal");
		table.insert(coreList, "3k_mtu_template_historical_cao_ren_hero_metal"); -- mtu? 
		table.insert(coreList, "3k_main_template_historical_cao_ren_hero_metal");
		table.insert(coreList, "3k_main_template_historical_cao_chun_hero_fire");
		table.insert(coreList, "3k_main_template_historical_cao_pi_hero_earth");
		table.insert(coreList, "3k_main_template_historical_zhang_he_hero_fire");
		CheckCore(coreList, qFaction:name(), qFaction:is_human())
	elseif qFaction:name()=="3k_main_faction_liu_bei" then 
		table.insert(coreList, "3k_main_template_historical_guan_yu_hero_wood");
		table.insert(coreList, "3k_main_template_historical_zhang_fei_hero_fire");
		table.insert(coreList, "3k_main_template_historical_zhuge_liang_hero_water");
		table.insert(coreList, "3k_main_template_historical_mi_zhu_hero_water"); 
		table.insert(coreList, "3k_mtu_template_historical_mi_zhu_hero_water"); -- MTU mi zhu?
		table.insert(coreList, "3k_main_template_historical_zhao_yun_hero_metal"); 
		table.insert(coreList, "3k_main_template_historical_ma_chao_hero_fire");
		table.insert(coreList, "3k_main_template_historical_wei_yan_hero_fire");
		table.insert(coreList, "3k_main_template_historical_huang_zhong_hero_metal");
		table.insert(coreList, "3k_dlc04_template_historical_chen_deng_yuanlong_water");
		CheckCore(coreList, qFaction:name(), qFaction:is_human())
	elseif qFaction:name()=="3k_main_faction_sun_jian" then 
		table.insert(coreList, "3k_main_template_historical_zhou_tai_hero_fire");
		table.insert(coreList, "3k_main_template_historical_jiang_qin_hero_fire");
		table.insert(coreList, "3k_main_template_historical_taishi_ci_hero_metal");
		table.insert(coreList, "3k_main_age_fixed_historical_zhang_zhao_hero_water");
		table.insert(coreList, "3k_main_template_historical_zhang_hong_hero_water");
		table.insert(coreList, "3k_main_template_historical_lu_fan_hero_water");
		table.insert(coreList, "3k_main_template_historical_cheng_pu_hero_metal");
		table.insert(coreList, "3k_cp01_template_historical_huang_gai_hero_fire");
		table.insert(coreList, "3k_main_template_historical_zhou_yu_hero_water");
		table.insert(coreList, "3k_main_template_historical_han_dang_hero_fire");
		table.insert(coreList, "3k_main_template_historical_zhu_ran_hero_fire");
		table.insert(coreList, "3k_main_template_historical_sun_ce_hero_fire");
		table.insert(coreList, "3k_main_template_historical_sun_quan_hero_earth");
		table.insert(coreList, "3k_main_template_historical_lady_da_qiao_hero_earth");
		table.insert(coreList, "3k_main_template_historical_lady_xiao_qiao_hero_metal");
		table.insert(coreList, "3k_main_template_historical_lady_sun_shangxiang_hero_fire");
		table.insert(coreList, "3k_main_template_historical_gan_ning_hero_fire");
		table.insert(coreList, "3k_main_template_historical_lu_su_hero_water");
		table.insert(coreList, "3k_mtu_template_historical_lady_wu_minyu_hero_earth");
		table.insert(coreList, "3k_main_template_historical_lu_meng_hero_metal");
		table.insert(coreList, "3k_main_template_historical_lu_xun_hero_water");
		CheckCore(coreList, qFaction:name(), qFaction:is_human())
	elseif qFaction:name()=="3k_dlc05_faction_sun_ce" then 
		table.insert(coreList, "3k_main_template_historical_zhou_tai_hero_fire");
		table.insert(coreList, "3k_main_template_historical_jiang_qin_hero_fire");
		table.insert(coreList, "3k_main_template_historical_taishi_ci_hero_metal");
		table.insert(coreList, "3k_main_age_fixed_historical_zhang_zhao_hero_water");
		table.insert(coreList, "3k_main_template_historical_zhang_hong_hero_water");
		table.insert(coreList, "3k_main_template_historical_lu_fan_hero_water");
		table.insert(coreList, "3k_main_template_historical_cheng_pu_hero_metal");
		table.insert(coreList, "3k_cp01_template_historical_huang_gai_hero_fire");
		table.insert(coreList, "3k_main_template_historical_zhou_yu_hero_water");
		table.insert(coreList, "3k_main_template_historical_han_dang_hero_fire");
		table.insert(coreList, "3k_main_template_historical_zhu_ran_hero_fire");
		table.insert(coreList, "3k_main_template_historical_sun_ce_hero_fire");
		table.insert(coreList, "3k_main_template_historical_sun_quan_hero_earth");
		table.insert(coreList, "3k_main_template_historical_lady_da_qiao_hero_earth");
		table.insert(coreList, "3k_main_template_historical_lady_xiao_qiao_hero_metal");
		table.insert(coreList, "3k_main_template_historical_lady_sun_shangxiang_hero_fire");
		table.insert(coreList, "3k_main_template_historical_gan_ning_hero_fire");
		table.insert(coreList, "3k_main_template_historical_lu_su_hero_water");
		table.insert(coreList, "3k_mtu_template_historical_lady_wu_minyu_hero_earth");
		table.insert(coreList, "3k_main_template_historical_lu_meng_hero_metal");
		table.insert(coreList, "3k_main_template_historical_lu_xun_hero_water");
		CheckCore(coreList, qFaction:name(), qFaction:is_human())
	elseif qFaction:name()=="3k_main_faction_liu_biao" then 
		table.insert(coreList, "3k_main_template_historical_wei_yan_hero_fire");
		table.insert(coreList, "3k_main_template_historical_huang_zhong_hero_metal");
		CheckCore(coreList, qFaction:name(), qFaction:is_human())
	elseif qFaction:name()=="3k_main_faction_yuan_shu" then 
		table.insert(coreList, "3k_main_template_historical_ji_ling_hero_fire");
		table.insert(coreList, "3k_main_template_historical_yang_feng_hero_wood");
		table.insert(coreList, "3k_mtu_template_historical_zhang_xun_hero_earth"); 
		table.insert(coreList, "3k_mtu_template_historical_yang_yao_hero_earth");
		table.insert(coreList, "3k_main_template_historical_hua_xin_hero_water");
		--table.insert(coreList, "3k_mtu_template_historical_zhang_xun_hero_earth");
		CheckCore(coreList, qFaction:name(), qFaction:is_human())
	elseif qFaction:name()=="3k_main_faction_lu_bu" then 
		table.insert(coreList, "3k_main_template_historical_zhang_liao_hero_metal");
		table.insert(coreList, "3k_main_template_historical_lady_diao_chan_hero_water");
		table.insert(coreList, "3k_main_template_historical_gao_shun_hero_fire");
		table.insert(coreList, "3k_main_template_historical_chen_gong_hero_water");
		table.insert(coreList, "3k_main_template_historical_zhang_miao_hero_water");
		table.insert(coreList, "3k_dlc05_template_historical_hou_cheng_hero_wood");
		table.insert(coreList, "3k_main_template_historical_hao_meng_hero_fire"); --3k_mtu_template_historical_lady_lu_ji_hero_wood
		table.insert(coreList, "3k_main_template_historical_cao_xing_hero_metal"); 
		table.insert(coreList, "3k_mtu_template_historical_lady_lu_ji_hero_wood");
		table.insert(coreList, "3k_dlc05_template_historical_lu_lingqi_hero_metal");
		CheckCore(coreList, qFaction:name(), qFaction:is_human())
	elseif qFaction:name()=="3k_main_faction_ma_teng" then
		table.insert(coreList, "3k_main_template_historical_ma_chao_hero_fire");
		table.insert(coreList, "3k_main_template_historical_pang_de_hero_wood"); --3k_main_template_historical_ma_dai_hero_fire
		table.insert(coreList, "3k_main_template_historical_ma_dai_hero_fire");
		table.insert(coreList, "3k_main_template_historical_ma_xiu_hero_fire");
		table.insert(coreList, "3k_mtu_template_historical_lady_ma_lanli_hero_metal");
		table.insert(coreList, "3k_main_template_historical_ma_qiu_hero_water");
		CheckCore(coreList, qFaction:name(), qFaction:is_human())
	elseif qFaction:name()=="3k_main_faction_yuan_shao" then
		table.insert(coreList, "3k_mtu_template_historical_wen_chou_hero_wood"); -- mtu yan liang
		table.insert(coreList, "3k_mtu_template_historical_yan_liang_hero_fire"); --mtu wen chou
		table.insert(coreList, "3k_main_template_historical_wen_chou_hero_wood");
		table.insert(coreList, "3k_main_template_historical_yan_liang_hero_fire");
		table.insert(coreList, "3k_main_template_historical_yuan_tan_hero_earth");
		table.insert(coreList, "3k_main_template_historical_zhang_he_hero_fire");
		table.insert(coreList, "3k_main_template_historical_yuan_shang_hero_earth");
		table.insert(coreList, "3k_main_template_historical_tian_feng_hero_water"); --advisor 1  dude w the stick in TK 
		table.insert(coreList, "3k_main_template_historical_gu_lan_hero_water"); --advisor 2 gu lan?
		CheckCore(coreList, qFaction:name(), qFaction:is_human())
	elseif qFaction:name()=="3k_main_faction_dong_zhuo" then --Tricky with li jue split , oh well just a few extra checks
		table.insert(coreList, "3k_main_template_historical_guo_si_hero_fire");
		table.insert(coreList, "3k_main_template_historical_li_jue_hero_fire");
		table.insert(coreList, "3k_main_template_historical_niu_fu_hero_fire");
		table.insert(coreList, "3k_main_template_historical_jia_xu_hero_water");
		table.insert(coreList, "3k_main_template_historical_li_ru_hero_water");
		table.insert(coreList, "3k_mtu_template_historical_li_ru_hero_water");
		table.insert(coreList, "3k_main_template_historical_dong_min_hero_earth");
		table.insert(coreList, "3k_mtu_template_historical_dong_min_hero_earth");
		table.insert(coreList, "3k_main_template_historical_lady_dong_peishan_hero_earth");
		table.insert(coreList, "3k_mtu_template_historical_lady_dong_peishan_hero_earth");
		table.insert(coreList, "3k_main_template_historical_wang_yun_hero_earth");
		table.insert(coreList, "3k_main_template_historical_lu_bu_hero_fire");
		table.insert(coreList, "3k_main_template_historical_zhang_liao_hero_metal");
		table.insert(coreList, "3k_main_template_historical_lady_diao_chan_hero_water");
		table.insert(coreList, "3k_main_template_historical_gao_shun_hero_fire");
		CheckCore(coreList, qFaction:name(), qFaction:is_human())
	end
	
	--CusLog("Finished CheckOfficers")
end



-----------------------------------------------------------------------
------------------Separate Functions from Listeners--------------------
-----------------------------------------------------------------------


function CoreOfficersListener() --Will work for both 190/AWB AI
	CusLog("### CoreOfficersListener loading ###") 
	core:remove_listener("CoreOfficers")
	core:add_listener(
		"CoreOfficers",
		"FactionTurnStart",
		function(context)
			--return context:faction():is_human()==false;
			return true; -- low chance player adds "faction fondess" to his officers (20% chance per char per turn.)
		end,
		function(context)
			--CusLog("??Callback: Passed CoreOfficersListener ###")
			CheckOfficers(context:faction())
			--CusLog("### Finished CoreOfficersListener Callback ###")
		end,
		true
    )
end





-- when the campaign loads run these functions:
cm:add_first_tick_callback(
	function(context)
		IniDebugger()
		CoreOfficersListener() 
	end
)


