--> Cao Cao Post
-- responsible for after Lu Bu emerges in PuYang 
-- Handles zhang xiu emergence 
-- handle Dian Weis Death


local startTime=os.clock() --can put in CM:val if needed ?




local function CusLog(text)
    if type(text) == "string" then
        local file = io.open("@havie_cao_post.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
		local header=" (cao_post): "
		local line= time..header..text
		file:write(line.."\n")
        file:close()
		ModLog(header..text)
    end
end
local function IniDebugger()
	printStatements=true;
	local file = io.open("@havie_cao_post.txt", "w+")
	CusLog("---Begin File----")
end

function KillDianWei()
	CusLog("Running KillDianWei")
	-- kill him
	
	-- trigger global incident vagueness is key because he doesnt have to be in cao cao faction
	CusLog("Finished KillDianWei")
end

function GiveZhangJiLand()

	--local ZhangJiFaction=getQFaction("3k_main_faction_shangyong")
	local qRegion1=cm:query_region("3k_main_nanyang_capital")
	if not qRegion1:owning_faction():is_human() then 
		if qRegion1:owning_faction():name()~="3k_main_faction_cao_cao" then 
			--Doesnt work..........
			ForceADeal("3k_main_faction_shangyong", qRegion1:owning_faction():name(), "data_defined_situation_non_aggression_pact")
			ForceADeal(qRegion1:owning_faction():name(), "3k_main_faction_shangyong", "data_defined_situation_military_access")
			ForceADeal(qRegion1:owning_faction():name(), "3k_main_faction_shangyong", "data_defined_situation_trade")
		end
		cm:modify_model():get_modify_region(qRegion1):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_shangyong"))
	end 

end 


function caocao_backstabbed_zhangxiuListener() -- will only spawn for player CAOCAO if peace w  lubu, spawns for AI regardless
	CusLog("### caocao_backstabbed_zhangxiuListener listener loading ###")
	core:add_listener(
		"caocao_backstabbed_zhangxiu",
		"FactionTurnEnd",
		function(context)
			if context:faction():is_human() and context:query_model():date_in_range(195,198) and cm:get_saved_value("Spawned_zhangxiu")~=true then
			CusLog("..In Range for ZhangXiu")
			local qlubu =getQChar("3k_main_template_historical_lu_bu_hero_fire")
			local caocao_faction = cm:query_faction("3k_main_faction_cao_cao")
				if qlubu:is_faction_leader() and not caocao_faction:is_human() then --playing lu bus story line we want to delay this
					-- Check if CaoCao is at peace , forget about liu bei, too much to handle
					CusLog(".. lubu is a faction leader and cao cao is not human")
					if not cm:query_faction("3k_main_faction_cao_cao"):has_specified_diplomatic_deal_with("treaty_components_war",qlubu:faction()) then
						return RNGHelper(3); --Not being at war w lu bu will trigger a logical dilemma for human cao cao, or just spawn zhang xiu for ai cao cao
					else
						return RNGHelper(6); -- 8 , might spawn sooner
					end -- this is intended, the elseif is for lubu being faction leader or not
				elseif not caocao_faction:is_human() then 
					return RNGHelper(4); 	--If the Ai is cao cao emerge zhang xiu anyway (lower chance)
				elseif caocao_faction:is_human() then 
					return RNGHelper(6)
				end
			end
			return false;
		end,
		function(context)
			CusLog("???Callback: caocao_backstabbed_zhangxiuListener Callback ###")
			if context:query_model():campaign_name()=="3k_dlc05_start_pos" then 
				GiveZhangJiLand()
			else
				register_zhang_xiu_emergent_faction_2()
			end
			cm:set_saved_value("Spawnzhang_xiu",true) -- do outside so listener stops 
		end,
		true
    )
end

function CaoCaoChoiceMade4Listener()
    CusLog("### CaoCaoChoiceMadeListener loading ###")
    core:add_listener(
    "DilemmaChoiceMadeCaocao4",
    "DilemmaChoiceMadeEvent",
    function(context)
        CusLog("..Listening for 3k_lua_caocao_zhangxiu_dilemma choice ")
        return context:dilemma() == "3k_lua_caocao_zhangxiu_dilemma"   
    end,
    function(context)
        CusLog("..! choice was:" .. tostring(context:choice()))
        if context:choice() == 0 then
             --Fight Zhang xiu and promote lu bu
		else
			 -- Ignore zhang xiu and fight lu bu
        end
         
    end,
    false
);
end

function DianWeiDiesListener()
	CusLog("### DianWeiDiesListener listener loading ###")
	core:remove_listener("DianWeiDies")
	core:add_listener(
		"DianWeiDies",
		"CampaignBattleLoggedEvent",
		function(context)
			if context:log_entry():losing_characters():num_items()>1 and  context:query_model():date_in_range(195,200) and cm:get_saved_value("Spawned_zhangxiu")==true then
				--CusLog("..Checking if Dian Wei Fought Zhang Xiu")
				local qdianwei =getQChar("3k_main_template_historical_dian_wei_hero_wood")
				local qzhangxiu = getQChar("3k_main_template_historical_zhang_xiu_hero_fire")
				if  qzhangxiu:is_null_interface() or qdianwei:is_null_interface() then 
					return false
				elseif qzhangxiu:is_dead() or qdianwei:is_dead() then 
					--core:remove_listener("DianWeiDies")
					return false;
				end
		
				
				local dianWeiLost=false;
				local zhangxiuWasThere=false;
				local zhangxiu_faction = qzhangxiu:faction()
				CusLog("..Checking if Dian Wei was on losing side")
				--local caocao_faction = cm:query_faction("3k_main_faction_cao_cao")
				for i = 0, context:log_entry():losing_characters():num_items()-1 do
					local qchar= context:log_entry():losing_characters():item_at(i)
					if( qchar:generate_template_key() == "3k_main_template_historical_dian_wei_hero_wood") then 
						dianWeiLost=true
					end
				end
				if not dianWeiLost then 
					return false
				end
				CusLog("..DianWei Lost, checking if Zhang Xiu was involved")
				if not qzhangxiu:is_faction_leader() then --find out if he was physically in battle 
					for i = 0, context:log_entry():winning_characters():num_items()-1 do
						local qchar= context:log_entry():winning_characters():item_at(i)
						if( qchar:generate_template_key() == qzhangxiu:generate_template_key()) then 
							return true;
						end
					end
				else -- find out if his faction won 
					for i=0, context:log_entry():winning_faction():num_items() -1 do
						local qfaction = context:log_entry():winning_faction():item_at(i)
						if qfaction():name() == zhangxiu_faction:name() then 
							return true;
						end
					end
				end
				
			end
			return false;
		end,
		function(context)
			CusLog("???Callback: DianWeiDies Callback ###")
			--KillDianWei()
		end,
		false
    )
end



-- when the campaign loads run these functions:
cm:add_first_tick_callback(
	function(context)
		
		IniDebugger()
        if context:query_model():date_in_range(194,198) then --start listening 1 yr early 
			if cm:get_saved_value("Spawned_zhangxiu") == nil then
				caocao_backstabbed_zhangxiuListener()
			end
		end
		if context:query_model():date_in_range(194,205) then
			DianWeiDiesListener()
		end
		--TMP 

		--GiveZhangJiLand()
    end
)
