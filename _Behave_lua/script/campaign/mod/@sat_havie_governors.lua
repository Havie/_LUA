----------------------------------------------------------------------------------------
-------------------  TITLE: Governor Events   ----------------------------------------
------ Author: Havie 						  ------------------------------------------
------ Description: Written in lua to attempt ------------------------------------------
------ to make my events fire without interfering with other vanilla incidents --------
------ restricted by the 1 incident per turn db limit ----------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
--<table cellspacing="2" cellpadding="2" border="0" id="table1" align="center">   
local printStatements=false;


local function CusLog(text)
    if type(text) == "string" and printStatements then
        local file = io.open("@sat_havie_gov.txt", "a")
		--local temp = os.date("*t", 906000490)
		local temp = os.date("*t") -- now ?
        local time= ("["..tostring(temp.min)..":"..tostring(temp.sec)..tostring(os.clock() - startTime).."] ")
		local header=" (gov): "
		local line= time..header..text
		file:write(line.."\n")
		file:close()
		ModLog(header..text)
    end
end

local function IniDebugger()
	printStatements=true;
	local file = io.open("@sat_havie_gov.txt", "w+")
	CusLog("---Begin File----")
end

local function RNGHelperGOV(toBeat)
	--CusLog("RNG : "..tostring(debug.traceback()));
	local rolled_value = cm:random_number( 0, 9 );
	CusLog("$$(RNGHelperGOV):: Rolled a:"..tostring(rolled_value).. " , need to beat"..tostring(toBeat))
    return rolled_value > toBeat 
end

--Not sure how i'd do this without globals
local PLAYERGOVERNORS = {}
local TRAITFUNCTIONS = {}
local TRAITFUNCTIONS2 = {}


local function Agile(eventTable)
	--nothing?
end 

local function Ambitious(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_money_"..regionName.."_capital_Incident") --makes a good deal on trade 
	table.insert(eventTable, "3k_gov_good_corruption_"..regionName.."_capital_Incident") -- patrols hard and roots out corrupt officals 
	table.insert(eventTable, "3k_gov_good_po_"..regionName.."_capital_Incident") -- patrols towns
	table.insert(eventTable, "3k_gov_good_construction_"..regionName.."_capital_Incident")
end

local function Arrogant(eventTable, regionName)
	table.insert(eventTable, "3k_gov_bad_satisfaction_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_bad_income_"..regionName.."_capital_Incident") --doesnt listen to economists
	table.insert(eventTable, "3k_gov_bad_corruption_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_bad_po_"..regionName.."_capital_Incident") --generally feuding 
	table.insert(eventTable, "3k_gov_good_exp_"..regionName.."_capital_Incident")
end

local function Artful(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_money_"..regionName.."_capital_Incident") --sells art
	table.insert(eventTable, "3k_gov_good_po_"..regionName.."_capital_Incident") --local mural
	table.insert(eventTable, "3k_gov_good_exp_"..regionName.."_capital_Incident")
end
local function Ascentic(eventTable, regionName) -- Ascetic? 
--severe self-discipline and abstention from all forms of indulgence
end
local function Beautiful(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_po_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_good_job_"..regionName.."_capital_Incident") --job satisfaction reduction 
end

local function Brave(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_po_"..regionName.."_capital_Incident") --kills bandits 
	table.insert(eventTable, "3k_gov_good_pop_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_troop_replenish_"..regionName.."_capital_Incident") 
end

local function Bright(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_income_"..regionName.."_capital_Incident") --% based on commerce/industry 
	table.insert(eventTable, "3k_gov_local_exp_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_corruption_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_supply_reserve_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_officer_"..regionName.."_capital_Incident") 
end
local function Brilliant(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_income_"..regionName.."_capital_Incident") --% all income 
	table.insert(eventTable, "3k_gov_good_construction_"..regionName.."_capital_Incident") --% time and cost "idea for new project"
	table.insert(eventTable, "3k_gov_good_corruption_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_supply_reserve_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_troop_cost_"..regionName.."_capital_Incident") 
end
local function Careless(eventTable, regionName)
	table.insert(eventTable, "3k_gov_bad_income_"..regionName.."_capital_Incident") --% all income 
	table.insert(eventTable, "3k_gov_bad_construction_"..regionName.."_capital_Incident") -- time 
	table.insert(eventTable, "3k_gov_bad_supply_reserve_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_bad_troop_training_"..regionName.."_capital_Incident") 
end
local function Charismatic(eventTable, regionName)
	CusLog("Adding charismatic")
	table.insert(eventTable, "3k_gov_good_satisfaction_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_po_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_troop_cost_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_pop_"..regionName.."_capital_Incident") 
	CusLog("Adding charismatic")
end
local function Charitable(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_satisfaction_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_po_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_bad_income_"..regionName.."_capital_Incident") -- minus peasantry income and food produced  
end
local function Cheerful(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_satisfaction_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_po_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_good_pop_"..regionName.."_capital_Incident") 	
end
local function Clever(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_income_"..regionName.."_capital_Incident") --% based on commerce/industry 
	table.insert(eventTable, "3k_gov_good_local_exp_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_corruption_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_money_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_troop_cost_"..regionName.."_capital_Incident") 
end
local function Committed(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_troop_replenish_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_troop_training_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_troop_cost_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_money_"..regionName.."_capital_Incident") 
end
local function Concerned(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_supply_reserve_"..regionName.."_capital_Incident") 
end
local function Coordinated(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_supply_mil_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_construction_"..regionName.."_capital_Incident") 
end
local function Cordial(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_acquitance_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_officer_"..regionName.."_capital_Incident") 
end
local function Cowardly(eventTable, regionName)
	table.insert(eventTable, "3k_gov_bad_satisfaction_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_bad_corruption_"..regionName.."_capital_Incident") 
end
local function Creative(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_construction_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_good_weapon_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_armor_"..regionName.."_capital_Incident") 	
end
local function Cruel(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_both_construction_"..regionName.."_capital_Incident") --speed construction, but low PO
	table.insert(eventTable, "3k_gov_bad_satisfaction_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_both_income_"..regionName.."_capital_Incident") -- more income less PO 	
	table.insert(eventTable, "3k_gov_bad_pop_"..regionName.."_capital_Incident") 
end
local function Cunning(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_construction_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_good_anc_"..regionName.."_capital_Incident") 
end
local function Deceitful(eventTable, regionName)
	table.insert(eventTable, "3k_gov_bad_corruption_"..regionName.."_capital_Incident")
end
local function Defiant(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_attrition_"..regionName.."_capital_Incident") -- natural guerrila  + troop training ?
	--Could do troop exp per turn 
end
local function Determined(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_troop_training_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_supply_mil_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_troop_replenish_"..regionName.."_capital_Incident")
	--Could do faction wide redeployment? not if its wrong faction and this will be for AI too 
	-- If we can do region to faction then yes 
end
local function Direct(eventTable, regionName)
	CusLog("Adding Direct:")
	table.insert(eventTable, "3k_gov_good_troop_upkeep_"..regionName.."_capital_Incident") 
	CusLog("Finished adding direct");
end
local function Disciplinarian(eventTable, regionName)
	-- high PO , high military things 
	table.insert(eventTable, "3k_gov_good_po_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_troop_training_"..regionName.."_capital_Incident")  
	table.insert(eventTable, "3k_gov_good_supply_mil_"..regionName.."_capital_Incident") 
	table.insert(eventTable, "3k_gov_good_troop_training_"..regionName.."_capital_Incident")  
	table.insert(eventTable, "3k_gov_good_troop_cost_"..regionName.."_capital_Incident") 
end
local function Disloyal(eventTable, regionName)
	-- low income 
	table.insert(eventTable, "3k_gov_bad_income_"..regionName.."_capital_Incident") 
	-- low local  satisfaction 
	table.insert(eventTable, "3k_gov_bad_satisfaction_"..regionName.."_capital_Incident") 
	-- chance to trigger civil war?
end
local function Distinguished(eventTable, regionName)
	-- local satisfaction 
	table.insert(eventTable, "3k_gov_good_satisfaction_"..regionName.."_capital_Incident") 
end
local function Dutiful(eventTable, regionName)
	-- local PO 
	table.insert(eventTable, "3k_gov_good_po_"..regionName.."_capital_Incident") 
	-- anc 
	table.insert(eventTable, "3k_gov_good_anc_"..regionName.."_capital_Incident") 
	-- low building upkeep
	table.insert(eventTable, "3k_gov_good_building_upkeep_"..regionName.."_capital_Incident") 
end
local function Elusive(eventTable, regionName)
	-- catch spies 
	--Can we do region to faction spy cover? 
	table.insert(eventTable, "3k_gov_good_spies_"..regionName.."_capital_Incident") 
end
local function Energetic(eventTable, regionName)
	-- local army movement
	table.insert(eventTable, "3k_gov_good_movement_"..regionName.."_capital_Incident") 
end
local function Enigmatic(eventTable, regionName)
	--mysterious ???
end
local function Feared(eventTable, regionName)
	-- local enemy morale reduction
	table.insert(eventTable, "3k_gov_enemy_morale_"..regionName.."_capital_Incident") 	
end
local function Fertile(eventTable, regionName)
	-- pop growth 
	table.insert(eventTable, "3k_gov_good_pop_"..regionName.."_capital_Incident") 
end
local function Fiery(eventTable, regionName)
	-- nothing?
	table.insert(eventTable, "3k_gov_enemy_morale_"..regionName.."_capital_Incident") 	
end
local function Formidable(eventTable, regionName)
	-- increase reserves? capacity? morale when defending?
	table.insert(eventTable, "3k_gov_good_supply_reserve_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_good_morale_"..regionName.."_capital_Incident") 	
end
local function Fraternal(eventTable, regionName)
	--makes friends, hires officers 
	table.insert(eventTable, "3k_gov_good_relations_"..regionName.."_capital_Incident") -- improve relations TODO 
	table.insert(eventTable, "3k_gov_good_officer_"..regionName.."_capital_Incident")
end
local function Friendly(eventTable, regionName)
	--makes friends, hires officers 
	table.insert(eventTable, "3k_gov_good_acquitance_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_good_officer_"..regionName.."_capital_Incident")
end
local function Fulfilled(eventTable, regionName)
	-- nothing?
end
local function Graceful(eventTable, regionName)
	--nothing?
end
local function Gracious(eventTable, regionName)
	-- gives money to you (cant do because of region scope) ? cant give money unless cleverly done through a listener and a dummy UI 
	-- cant give money unless cleverly done through a listener and a dummy UI, might be the same for an anc 
	table.insert(eventTable, "3k_gov_good_money_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_good_anc_"..regionName.."_capital_Incident")
end
local function Greedy(eventTable, regionName)
	-- local corruption
	table.insert(eventTable, "3k_gov_bad_corruption_"..regionName.."_capital_Incident")
	-- local reduced income 
	table.insert(eventTable, "3k_gov_bad_income_"..regionName.."_capital_Incident")
end
local function Handsome(eventTable, regionName)
	--local satisfaction 
	table.insert(eventTable, "3k_gov_good_satisfaction_"..regionName.."_capital_Incident")
end
local function Humble(eventTable, regionName)
	--local satisfaction 
	table.insert(eventTable, "3k_gov_good_satisfaction_"..regionName.."_capital_Incident")
end
local function Impeccable(eventTable, regionName)
	--local satisfaction 
	table.insert(eventTable, "3k_gov_good_satisfaction_"..regionName.."_capital_Incident")
end
local function Incompetent(eventTable, regionName)
	-- local reduced income 
	table.insert(eventTable, "3k_gov_bad_income_"..regionName.."_capital_Incident")
	-- local military losses
	table.insert(eventTable, "3k_gov_bad_supply_mil_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_bad_supply_reserve_"..regionName.."_capital_Incident")
	-- replenishment times 
	table.insert(eventTable, "3k_gov_bad_troop_replenish_"..regionName.."_capital_Incident")
end
local function Intimidating(eventTable, regionName)
	-- lowered morale for enemies in region 
	table.insert(eventTable, "3k_gov_enemy_morale_"..regionName.."_capital_Incident")
	-- increase PO 
	table.insert(eventTable, "3k_gov_good_po_"..regionName.."_capital_Incident")
end
local function Intrepid(eventTable, regionName)
	--fearless? idk 
	-- horse?
end
local function KindHearted(eventTable, regionName)
	-- gives u money? -- give you items 
	table.insert(eventTable, "3k_gov_good_money_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_good_anc_"..regionName.."_capital_Incident")
	-- give peasants money 
	table.insert(eventTable, "3k_gov_good_peasantry_"..regionName.."_capital_Incident")
end
 
local function Kind(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_money_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_good_anc_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_good_peasantry_"..regionName.."_capital_Incident")
end
local function Loyal(eventTable, regionName)
	--give you items 
	table.insert(eventTable, "3k_gov_good_anc_"..regionName.."_capital_Incident")
end
local function Lumbering(eventTable, regionName)
	--reduce construction 
	table.insert(eventTable, "3k_gov_good_construction_"..regionName.."_capital_Incident")
end
local function Modest(eventTable, regionName)
	--?
end
local function Obstinate(eventTable, regionName)
	-- stubborn 
end
local function Pacifist(eventTable, regionName)
	table.insert(eventTable, "3k_gov_bad_supply_mil_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_bad_troop_replenish_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_bad_troop_cost_"..regionName.."_capital_Incident")
end
local function Patient(eventTable, regionName)
	-- ?
end
local function Perceptive(eventTable, regionName)
	-- spy bonus?
	-- LOS?
end
local function Philanthropic(eventTable, regionName)
	-- Give you money 
	table.insert(eventTable, "3k_gov_good_money_"..regionName.."_capital_Incident")
	--Higher chance for an anc 
	table.insert(eventTable, "3k_gov_good_anc_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_good_anc_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_good_anc_"..regionName.."_capital_Incident")
end
local function Populist(eventTable, regionName)
	--does something nice for peasants motivates them into % income ?
	table.insert(eventTable, "3k_gov_good_peasantry_"..regionName.."_capital_Incident")
	-- gives PO 
	table.insert(eventTable, "3k_gov_good_po_"..regionName.."_capital_Incident")
end
local function Quiet(eventTable, regionName)
	CusLog("Quiet_"..regionName.."_capital_Incident");
end
local function Reckless(eventTable, regionName)
	-- lost supplies 
	table.insert(eventTable, "3k_gov_bad_supply_mil_"..regionName.."_capital_Incident")
end
local function Relentless(eventTable, regionName)
	--?
	table.insert(eventTable, "3k_gov_good_attrition_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_good_troop_replenish_"..regionName.."_capital_Incident")
end
local function Resourceful(eventTable, regionName)
	-- gain mil supplies 
	table.insert(eventTable, "3k_gov_good_supply_mil_"..regionName.."_capital_Incident")
	-- gain reserves 
	table.insert(eventTable, "3k_gov_good_supply_reserve_"..regionName.."_capital_Incident")
	-- gain replenishment 
	table.insert(eventTable, "3k_gov_good_troop_replenish_"..regionName.."_capital_Incident")
end
local function Scholarly(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_exp_"..regionName.."_capital_Incident") 	-- extra exp locally 
end
local function Selfless(eventTable, regionName)
	--gives u gifts 
	table.insert(eventTable, "3k_gov_good_anc_"..regionName.."_capital_Incident") 
end
local function Sincere(eventTable, regionName)
	--gives you anc 
	table.insert(eventTable, "3k_gov_good_anc_"..regionName.."_capital_Incident") 
end
local function Solitary(eventTable, regionName)
	-- nothing?
end
local function Spiteful(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_attrition_"..regionName.."_capital_Incident")
end
local function Stalwart(eventTable, regionName)
	--hardworking reliable, loyal 
	table.insert(eventTable, "3k_gov_good_po_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_good_construction_"..regionName.."_capital_Incident") 	
end
local function Stern(eventTable, regionName)
	-- PO 
	table.insert(eventTable, "3k_gov_good_po_"..regionName.."_capital_Incident") 
end
local function Strong(eventTable, regionName)
	-- PO 
	table.insert(eventTable, "3k_gov_good_po_"..regionName.."_capital_Incident") 
end
local function Stubborn(eventTable, regionName)
	--local dissatisfaction
	table.insert(eventTable, "3k_gov_bad_satisfaction_"..regionName.."_capital_Incident") 	
end
local function Superstitious(eventTable, regionName)
	-- ?
end
local function Suspicious(eventTable, regionName)
	-- factionwide  spies caught 
end
local function Temperamental(eventTable, regionName)
	--local satisfaction reduction 
	table.insert(eventTable, "3k_gov_bad_satisfaction_"..regionName.."_capital_Incident") 	
end
local function Tolerant(eventTable, regionName)
	-- locla Po 
	table.insert(eventTable, "3k_gov_good_po_"..regionName.."_capital_Incident") 
	-- local satisfaction ? 
	table.insert(eventTable, "3k_gov_good_satisfaction_"..regionName.."_capital_Incident") 	
	-- low corruption raised 
	table.insert(eventTable, "3k_gov_bad_corruption_"..regionName.."_capital_Incident") 
end
local function Tough(eventTable, regionName)
	table.insert(eventTable, "3k_gov_enemy_morale_"..regionName.."_capital_Incident") 
end
local function Tranquil(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_pop_"..regionName.."_capital_Incident") 
end
local function Trusting(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_relations_"..regionName.."_capital_Incident") 
end
local function Trustworthy(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_relations_"..regionName.."_capital_Incident") 
end
local function Uncomplicated(eventTable, regionName)
	-- ??
end
local function Understanding(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_peasantry_"..regionName.."_capital_Incident") 
end
local function Unobservant(eventTable, regionName)
	table.insert(eventTable, "3k_gov_bad_corruption_"..regionName.."_capital_Incident") 
end
local function Vain(eventTable, regionName)
	table.insert(eventTable, "3k_gov_bad_satisfaction_"..regionName.."_capital_Incident") 
end
local function Vengeful(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_attrition_"..regionName.."_capital_Incident")
end
local function Vigilant(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_troop_replenish_"..regionName.."_capital_Incident")
end
local function Weak(eventTable, regionName)
	table.insert(eventTable, "3k_gov_bad_troop_cost_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_bad_troop_replenish_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_bad_troop_training_"..regionName.."_capital_Incident")
end
local function Wise(eventTable, regionName)
	table.insert(eventTable, "3k_gov_good_building_upkeep_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_good_construction_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_good_exp_"..regionName.."_capital_Incident")
	table.insert(eventTable, "3k_gov_good_income_"..regionName.."_capital_Incident")
end



--Missing traits
-- (gov): 3k_ytr_ceo_trait_personality_land_generous did not return a function 
-- (gov): 3k_main_ceo_trait_personality_cautious did not return a function 
-- (gov): 3k_ytr_ceo_trait_personality_land_composed did not return a function 
-- (gov): 3k_ytr_ceo_trait_personality_heaven_creative
--(gov): 3k_ytr_ceo_trait_personality_people_cheerful did not return a function  region:3k_main_bajun_capital
--(gov): 3k_ytr_ceo_trait_personality_heaven_creative did not return a function  region:3k_main_bajun_capital
--(gov): 3k_ytr_ceo_trait_personality_heaven_honest did not return a function  region:3k_main_bajun_capital
--(gov): 3k_ytr_ceo_trait_personality_people_amiable did not return a function  region:3k_main_bajun_capital
--[[
 (gov): 3k_main_ceo_trait_personality_pacifist did not return a function  region:3k_main_taiyuan_capital
 (gov): 3k_main_ceo_trait_personality_indecisive did not return a function  region:3k_main_taiyuan_capital
 (gov): 3k_ytr_ceo_trait_personality_people_stern did not return a function  region:3k_main_taiyuan_capital
]]

local function BuildMap()
	
	TRAITFUNCTIONS["agile"] = Agile -- the function  
	TRAITFUNCTIONS["ambitious"] = Ambitious
	TRAITFUNCTIONS["arrogant"] = Arrogant
	TRAITFUNCTIONS["artful"] = Artful
	TRAITFUNCTIONS["ascentic"] = Ascentic
	TRAITFUNCTIONS["beautiful "] = Beautiful 
	TRAITFUNCTIONS["brave"] = Brave
	TRAITFUNCTIONS["bright"] = Bright
	TRAITFUNCTIONS["brilliant"] = Brilliant
	TRAITFUNCTIONS["careless"] = Careless
	TRAITFUNCTIONS["cautious"] = Cautious  --TODO
	TRAITFUNCTIONS["charismatic"] = Charismatic
	TRAITFUNCTIONS["charitable"] = Charitable
	TRAITFUNCTIONS["cheerful"] = Cheerful
	TRAITFUNCTIONS["clever"] = Clever
	TRAITFUNCTIONS["clumsy"] = Clumsy
	TRAITFUNCTIONS["competitive"] = Competitive
	TRAITFUNCTIONS["composed"] = Composed
	TRAITFUNCTIONS["committed"] = Committed
	TRAITFUNCTIONS["concerned"] = Concerned
	TRAITFUNCTIONS["coordinated"] = Coordinated
	TRAITFUNCTIONS["cordial"] = Cordial
	TRAITFUNCTIONS["cowardly"] = Cowardly
	TRAITFUNCTIONS["creative"] = Creative
	TRAITFUNCTIONS["cruel"] = Cruel
	TRAITFUNCTIONS["cunning"] = Cunning
	TRAITFUNCTIONS["deceitful"] = Deceitful
	TRAITFUNCTIONS["defiant"] = Defiant
	TRAITFUNCTIONS["determined"] = Determined
	TRAITFUNCTIONS["direct"] = Direct
	TRAITFUNCTIONS["disciplinarian"] = Disciplinarian
	TRAITFUNCTIONS["disloyal"] = Disloyal
	TRAITFUNCTIONS["distinguished"] = Distinguished
	TRAITFUNCTIONS["dutiful"] = Dutiful
	TRAITFUNCTIONS["elusive"] = Elusive
	TRAITFUNCTIONS["energetic"] = Energetic
	TRAITFUNCTIONS["enigmatic"] = Enigmatic
	TRAITFUNCTIONS["feared"] = Feared
	TRAITFUNCTIONS["fertile"] = Fertile
	TRAITFUNCTIONS["fiery"] = Fiery
	TRAITFUNCTIONS["formidable"] = Formidable
	TRAITFUNCTIONS["fraternal"] = Fraternal
	TRAITFUNCTIONS["friendly"] = Friendly
	TRAITFUNCTIONS["fulfilled"] = Fulfilled
	TRAITFUNCTIONS["generous"] = Generous --TODO
	TRAITFUNCTIONS["graceful"] = Graceful
	TRAITFUNCTIONS["gracious"] = Gracious
	TRAITFUNCTIONS["greedy"] = Greedy
	TRAITFUNCTIONS["handsome"] = Handsome
	TRAITFUNCTIONS["healthy"] = Healthy
	TRAITFUNCTIONS["honest"] = Honest
	TRAITFUNCTIONS["honourable"] = Honourable
	TRAITFUNCTIONS["humble"] = Humble
end
local function BuildMap2()
	TRAITFUNCTIONS2["impeccable"] = Impeccable
	TRAITFUNCTIONS2["incompetent"] = Incompetent
	TRAITFUNCTIONS2["indecisive"] = Indecisive
	TRAITFUNCTIONS2["intimidating"] = Intimidating
	TRAITFUNCTIONS2["intrepid"] = Intrepid
	TRAITFUNCTIONS2["kind"] = Kind
	TRAITFUNCTIONS2["kind_hearted"] = KindHearted 
	TRAITFUNCTIONS2["loyal"] = Loyal
	TRAITFUNCTIONS2["lumbering"] = Lumbering 
	TRAITFUNCTIONS2["modest"] = Modest
	TRAITFUNCTIONS2["obstinate"] = Obstinate
	TRAITFUNCTIONS2["patient"] = Patient
	TRAITFUNCTIONS2["perceptive"] = Perceptive
	TRAITFUNCTIONS2["philanthropic"] = Philanthropic
	TRAITFUNCTIONS2["populist"] = Populist
	TRAITFUNCTIONS2["quiet"] = Quiet  --   HERE
	TRAITFUNCTIONS2["reckless"] = Reckless
	TRAITFUNCTIONS2["relentless"] = Relentless
	TRAITFUNCTIONS2["resourceful"] = Resourceful
	TRAITFUNCTIONS2["scholarly"] = Scholarly
	TRAITFUNCTIONS2["selfless"] = Selfless
	TRAITFUNCTIONS2["sincere"] = Sincere
	TRAITFUNCTIONS2["solitary"] = Solitary
	TRAITFUNCTIONS2["spiteful"] = Spiteful
	TRAITFUNCTIONS2["stalwart"] = Stalwart
	TRAITFUNCTIONS2["stern"] = Stern
	TRAITFUNCTIONS2["strong"] = Strong
	TRAITFUNCTIONS2["stubborn"] = Stubborn
	TRAITFUNCTIONS2["superstitious"] = Superstitious
	TRAITFUNCTIONS2["suspicious"] = Suspicious   ---HERE
	TRAITFUNCTIONS2["temperamental"] = Temperamental
	TRAITFUNCTIONS2["tolerant"] = Tolerant
	TRAITFUNCTIONS2["tough"] = Tough
	TRAITFUNCTIONS2["tranquil"] = Tranquil
	TRAITFUNCTIONS2["trusting"] = Trusting
	TRAITFUNCTIONS2["trustworthy"] = Trustworthy
	TRAITFUNCTIONS2["uncomplicated"] = Uncomplicated
	TRAITFUNCTIONS2["understanding"] = Understanding
	TRAITFUNCTIONS2["unobservant"] = Unobservant
	TRAITFUNCTIONS2["vain"] = Vain
	TRAITFUNCTIONS2["vengeful"] = Vengeful
	TRAITFUNCTIONS2["vigilant"] = Vigilant
	TRAITFUNCTIONS2["weak"] = Weak
	TRAITFUNCTIONS2["wise"] = Wise 
end


local function ParseTrait(eventNames, trait, regionName)
	--CusLog("Begin ParseTrait")
	--No point , wish i could call the function name via the trait name in a cleaner way,
	-- gonna be such a big if else statement 
	local index1, index2 = string.find(trait, "personality_")
	local key= string.sub(trait, index2+1, #trait)
	--CusLog("key is: "..tostring(key))
	
	--3k_main_yingchuan_capital ==> "yingchuan"
	index1, index2 = string.find(regionName, "3k_main_")
	if index2==nil then
		index1, index2 = string.find(regionName, "3k_dlc06_")
		if index2==nil then 
			CusLog("cant parse key?: "..tostring(regionName))
		end
	end
	local regionkey= string.sub(regionName, index2+1, #regionName);
	index1, index2 = string.find(regionkey, "_")
	regionkey= string.sub(regionkey, 0, index2-1);
	--CusLog("regionkey= "..tostring(regionkey))
	
	local func= TRAITFUNCTIONS[key]; 
	if type(func) == "function" then 
		func(eventNames, regionkey) 
	else 
		func= TRAITFUNCTIONS2[key]; 
		if type(func) == "function" then 
			func(eventNames, regionkey) 
		else
			CusLog(tostring(trait).." did not return a function  region:"..tostring(regionName))
		end
	end
	
	--CusLog("End ParseTrait")
end

local function TriggerIncident(qChar)

-- Could lazily fire randomly through them since it doesnt seem query model has access to the season?
-- Or i could write something more reliably on the turn # itself since some events are in windows?
-- Maybe some of these events are the more common ones, and the really good ones still only generate from db?
-- Seems like it would defeat the purpose though. Its kind of hard to set Var_chance reliably here, its just super random without weights 
-- Maybe the db will still honor the CND TURNS TILL NEXT setting at least?
-- However firing this way ignore CND_LAST_ROUND so i had to get creative. 
	
	--should be list of all generic events, that will be altered based on char personality
	local eventNames= { } --clear it to start fresh  
			local chances=3;
			local factionName= qChar:faction():name();
			local regionName= qChar:region():name();
			--Going to have to do something more complex here to verify his/her personality traits, or let the events do it??
			--I think i should do it here as well to really narrow down the chance it fires for the wrong character (not in garrison)
			local ceo_manager= qChar:ceo_management()
			for i=0, ceo_manager:all_ceos_for_category("3k_main_ceo_category_traits_personality"):num_items()-1 do
                   -- CusLog("looking at Ceo#"..tostring(i))
				local trait= ceo_manager:all_ceos_for_category("3k_main_ceo_category_traits_personality"):item_at(i):ceo_data_key()
				ParseTrait(eventNames, trait, regionName) -- set up our related events 
			end
			
			--Feel like i could write this with mod in 1 line 
			-- chances shouldn't be needed in governor event compared to search?
			-- should always fire on first?
			if cm:query_model():turn_number() >180 then 
				chances=chances+3;
			elseif cm:query_model():turn_number() >120 then 
				chances=chances+2;
			elseif cm:query_model():turn_number() >70 then 
				chances=chances+1;
			end
			
			CusLog("Size of event tree="..tostring(#eventNames))
			if #eventName==0 then
				return false
			end 
			for i=1, chances do 
				CusLog("i= "..tostring(i)) --see how many times we loop
				local rng= math.floor(cm:random_number(1, #eventNames))
				if RNGHelperGOV(3) then --Add some RNG to whos firing what
					local triggered= cm:trigger_incident(factionName, eventNames[rng],true)
					if triggered then 
						CusLog("Event TRIGGERED: "..eventNames[rng])
						return true;
					else
						CusLog(tostring(rng).." Failed to trigger:".. eventNames[rng].."  for :"..tostring(factionName))
					end 
				end
			end

	CusLog("Fell through TriggerIncident"..tostring(qChar:generation_template_key()))
	return false;

end




local function IsGoverning(qChar)
	--CusLog("Running IsGoverning")
	--Figure out if the character is a governor
	if not qChar:character_post():is_null_interface() then
		if qChar:character_post():ministerial_position_record_key() =="3k_main_court_offices_governor" then --check 
			--check that they are in a garrison in the region they are governing?
			--I need to try qChar:apply_effect_bundle() regions and factions have them...
			--CusLog(qChar:generation_template_key().."  SUCCESS GOV Found="..tostring(qChar:faction():name()));
			--local regionship= PLAYERGOVERNORS[tostring(qChar:cqi())]
			local regionship= cm:get_saved_value("Gov:"..tostring(qChar:cqi()));
			--CusLog("Stored Val="..tostring(cm:get_saved_value("Gov:"..tostring(qChar:cqi()))));
			--CusLog("regionship="..tostring(regionship))
			if regionship~=nil then 
				--CusLog("Return : "..tostring((qChar:region():name() == regionship and qChar:has_garrison_residence())))
				return (qChar:region():name() == regionship and qChar:has_garrison_residence())
			else
				--CusLog("regionship is not registered")
			end 
		end 
	end

	
	--CusLog("Fell through IsGoverning")	
	return false;	
end

-----------------------------------------------------------------------

-----------------------------------------------------------------------
------------------Separate Functions from Listeners--------------------
-----------------------------------------------------------------------

-----------------------------------------------------------------------


local function GovernorListener()  
	CusLog("### GovernorListener loading ###")
	core:remove_listener("Governor")
	core:add_listener(
		"Governor",
		"CharacterTurnStart", 
		function(context)
			if IsGoverning(context:query_character()) then 
				CusLog("FACTION:"..tostring(context:query_character():faction():name()).." cqi#"..tostring(context:query_character():cqi()) .."  Turn#:"..cm:get_saved_value("gov_turns"..tostring(context:query_character():cqi())))
				if cm:get_saved_value("gov_turns"..tostring(context:query_character():cqi())) == nil then 
					CusLog("   return true (1)")
					return true;
				elseif cm:get_saved_value("gov_turns"..tostring(context:query_character():cqi())) < context:query_model():turn_number() then 
					CusLog("   return true (2)")
					return true;
				else
					CusLog(tostring(cm:get_saved_value("gov_turns"..tostring(context:query_character():cqi()))).." < "..tostring(context:query_model():turn_number()).." ="..tostring(cm:get_saved_value("gov_turns"..tostring(context:query_character():cqi())) < context:query_model():turn_number()))
					CusLog("Not In Turn range.. Waiting"..tostring(context:query_character():generation_template_key()).. "(cqi):"..tostring(context:query_character():cqi()))
				end
			else 
				--CusLog("Failed for :"..tostring(context:query_character():faction():name()))
			end
			return false;
		end,
		function(context)
			CusLog("??? Callback: GovernorListener  ###")
			if TriggerIncident(context:query_character()) then 
				local rng= math.floor(cm:random_number(4,11));
				cm:set_saved_value("gov_turns"..tostring(context:query_character():cqi()), context:query_model():turn_number() +rng)
			end 
		end,
		true 
    )
end

local function GovernorAssignedListener()  
	CusLog("### GovernorAssignedListener loading ###")
	core:remove_listener("GovernorAssigned")
	core:add_listener(
		"GovernorAssigned",
		"GovernorAssignedCharacterEvent", 
		function(context)
			--CusLog("New Governor assigned!")
			--CusLog("character="..tostring(context:query_character():generation_template_key())); -- use cqi
			--CusLog("Region="..tostring(context:query_region():name()))
			--return context:query_character():faction():is_human() -- want this for AI too though...?
			return true 
		end,
		function(context)
			--Set the region hes governing 
			cm:set_saved_value("Gov:"..tostring(context:query_character():cqi()), context:query_region():name());
			--CusLog("Set region for : "..tostring(context:query_character():cqi()).. " is "..tostring(PLAYERGOVERNORS[tostring(context:query_character():cqi())]))
			--CusLog("Set VAL for ="..context:query_character():cqi().."  ="..tostring(cm:get_saved_value("Gov:"..tostring(context:query_character():cqi()))));
			local rng= math.floor(cm:random_number(1,3)); -- might want to raise higher for release
			--Set the turns till this gov can trigger an event 
			cm:set_saved_value("gov_turns"..tostring(context:query_character():cqi()), context:query_model():turn_number() +rng)
			CusLog("### Finished  Callback: GovernorAssignedListener  ###")
		end,
		true 
    )
end 

-- when the game loads run these functions:
cm:add_first_tick_callback(  --FirstTickAfterWorldCreated
	function(context) 
		IniDebugger()
		BuildMap()
		BuildMap2()
		--if GLOBALFUNCTIONS~=nil then 
			--CusLog("Player Gov Turn: "..tostring(cm:get_saved_value("gov_turns")..getPlayerFaction()))
		--end 
		GovernorAssignedListener() 
		GovernorListener()

		--local qChar= getQChar("3k_main_template_historical_zhang_liao_hero_metal")
		--PLAYERGOVERNORS[qChar:cqi()]= "3k_main_chenjun_capital"
		--CusLog("Tmp set zhangliaos governorship")
		
		--cm:trigger_incident(getPlayerFaction(), "3k_gov_good_money_xindu_capital_Incident", true)
		--cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_money_xindu_capital_Incident", true) -- No verify on treasury number @warning
		--cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_corruption_xindu_capital_Incident", true)
		--cm:trigger_incident(getPlayerFaction(), "3k_gov_good_corruption_xindu_capital_Incident", true)
		--cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_po_xindu_capital_Incident", true)
		--CusLog("3k_gov_good_po_xindu_capital_Incident"..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_po_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_construction_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_construction_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_construction_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_construction_xindu_capital_Incident", true)))
	
		-- AUTO
		--CusLog("3k_gov_bad_officer_exp_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_officer_exp_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_officer_exp_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_officer_exp_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_job_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_job_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_job_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_job_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_pop_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_pop_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_pop_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_pop_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_troop_replenish_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_troop_replenish_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_troop_replenish_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_troop_replenish_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_troop_training_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_troop_training_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_troop_training_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_troop_training_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_income_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_income_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_income_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_income_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_supply_reserve_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_supply_reserve_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_supply_reserve_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_supply_reserve_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_supply_mil_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_supply_mil_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_supply_mil_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_supply_mil_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_satisfaction_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_satisfaction_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_satisfaction_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_satisfaction_xindu_capital_Incident", true)))
			--CusLog("3k_gov_bad_officer_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_officer_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_officer_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_officer_xindu_capital_Incident", true)))
		--THESE need to only target the player, doesnt seem to work for other chars
		--CusLog("3k_gov_good_exp_ye_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_exp_ye_capital_Incident", true)))
		--CusLog("3k_gov_good_exp_xiangyang_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_exp_xiangyang_capital_Incident", true)))
		--CusLog("3k_gov_bad_exp_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_exp_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_exp_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_exp_xindu_capital_Incident", true)))
	
		----
		--CusLog("3k_gov_bad_both_income_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_both_income_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_both_income_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_both_income_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_attrition_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_attrition_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_attrition_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_attrition_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_building_upkeep_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_building_upkeep_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_building_upkeep_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_building_upkeep_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_spies_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_spies_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_spies_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_spies_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_movement_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_movement_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_movement_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_movement_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_morale_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_morale_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_morale_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_morale_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_peasantry_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_peasantry_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_peasantry_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_peasantry_xindu_capital_Incident", true)))

		--CusLog("3k_gov_good_food_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_food_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_food_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_food_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_both_construction_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_both_construction_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_both_construction_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_both_construction_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_troop_cost_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_troop_cost_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_troop_cost_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_troop_cost_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_troop_upkeep_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_troop_upkeep_xindu_capital_Incident", true)))
		--CusLog("3k_gov_bad_troop_upkeep_xindu_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_bad_troop_upkeep_xindu_capital_Incident", true)))
		--CusLog("3k_gov_good_troop_upkeep_poyang_capital_Incident =="..tostring(cm:trigger_incident(getPlayerFaction(), "3k_gov_good_troop_upkeep_poyang_capital_Incident", true)))
		



		TellMeAboutFaction("3k_main_faction_cao_cao")
		--PrintOfficersInFaction("3k_dlc05_faction_white_tiger_yan")
		--MoveCharToFactionHard("3k_main_template_historical_lu_bu_hero_fire", "3k_dlc05_faction_white_tiger_yan")
	
    end
)

--Some of these will be unused, like bad_horse, but auto generated 
--[[
_good_money
_good_corruption
_good_po
_good_construction
_good_exp
_good_job
_good_population
_good_troop_replenish
_good_income
_good_supply_reserve
_good_officer
_good_satisfaction
_good_local_exp  -- generals
_good_troop_training -- troops 
_good_supply_mil
_good_both_income
_good_attrition
_good_building_upkeep
_good_spies
_good_movement
_good_morale
_good_peasantry
_good_food
_good_both_construction 
_good_troop_cost 
_good_troop_upkeep 
_good_relations --OFF
_good_acquitance -- OFF
_enemy_morale --TODO
_good_anc --TODO
_good_horse  --TODO
_good_weapon --TODO
_good_armor -- TODO
---------
---------
Good from bad
---------
--------
_bad_money
_bad_corruption
_bad_po
_bad_construction
_bad_exp
_bad_job
_bad_population
_bad_troop_replenish
_bad_income
_bad_supply_reserve
_bad_officer
_bad_satisfaction
_bad_local_exp  -- generals
_bad_troop_training -- troops 
_bad_supply_mil
_bad_both_income
_bad_attrition
_bad_building_upkeep
_bad_spies
_bad_movement
_bad_morale
_bad_peasantry
_bad_food
_bad_both_construction 
_bad_troop_cost 
_bad_troop_upkeep 
_bad_relations --OFF
_bad_acquitance -- OFF
_bad_anc --TODO
_bad_horse  --TODO
_bad_weapon --TODO
_bad_armor -- TODO
--]]
