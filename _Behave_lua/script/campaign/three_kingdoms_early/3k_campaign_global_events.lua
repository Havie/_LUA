main_global_events = {};

cm:add_first_tick_callback(function() main_global_events:initialise() end); --Self register function

function main_global_events:initialise()
	-- Disable the Yellow Turban Fervour pooled resource, and its UI display as it is not used in the main campaign.
	cm:disable_world_pooled_resource("3k_dlc04_pooled_resource_fervour");
	cm:disable_regional_pooled_resource("3k_dlc04_pooled_resource_fervour_regional", nil);
end;

