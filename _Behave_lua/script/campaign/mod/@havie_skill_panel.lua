---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			--Havies Skill button fix
----- Description: 	moves placement of buttons 
-----				
-----			
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------





function UIClickedListener() 
	--CusLog("### UIClickedListener loading ###") 
	core:remove_listener("UICLicked")
	core:add_listener(
		"UICLicked",
		"ComponentLClickUp", -- Campaign Event to listen for
		function(context)
			--CusLog(" UI Clicked:") 
			--CusLog("             :"..tostring(context.string)) 
			print_all_uicomponent_children(core:get_ui_root())
			--CusLog(print_all_uicomponent_children(core:get_ui_root()))
			return true;
		end,
		function(context) -- What to do if listener fires.
		--CusLog(" UIClickedListener callback:") 
		--CusLog("                     result:"..tostring(context.component)) 
		end,
		false
    )
end


function UIPanelOpened() 
	--CusLog("### UIPanelOpened loading ###") 
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
	--CusLog("### UIPanelClosed loading ###") 
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




cm:add_first_tick_callback(
	function(context)
		ModLog("Loaded Skill panel");
		UIPanelOpened()
		UIPanelClosed()
		UIClickedListener()

	end
)
