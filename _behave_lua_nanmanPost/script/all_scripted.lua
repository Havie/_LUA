

-- lib types for scripting libraries
__lib_type_battle = 0;
__lib_type_campaign = 1;
__lib_type_frontend = 2;
__lib_type_autotest = 3;

-- store the starting time of this session
lua_start_time = os.clock();

-- gets a timestamp string
function get_timestamp()
	return "<" .. string.format("%.1f", os.clock() - lua_start_time) .. "s>";
end;

-- script logging
__write_output_to_logfile = false;
__logfile_path = "";


if __write_output_to_logfile then
	-- create the logfile
	local filename = "script_log_" .. os.date("%d".."".."%m".."".."%y".."_".."%H".."".."%M") .. ".txt";
	
	_G.logfile_path = filename;
	
	
	local file, err_str = io.open(filename, "w");
	
	if not file then
		__write_output_to_logfile = false;
		script_error("ERROR: tried to create logfile with filename " .. filename .. " but operation failed with error: " .. tostring(err_str));
	else
		file:write("\n");
		file:write("creating logfile " .. filename .. "\n");
		file:write("\n");
		file:close();
		__logfile_path = _G.logfile_path;
	end;
end;

local all_scripted_core = nil;
function set_all_scripted_core(core)
	all_scripted_core = core;
end;

local all_scripted_campaign_ui = nil;
function set_all_scripted_campaign_ui(ui)
	all_scripted_campaign_ui = ui;
end;

-- report a script error to Lua spool and to CampaignUI if available
local error_id = 0;
function script_error(msg, stack_level)
	local ast_line = "********************";

	-- default to 2, 0 is the debug function used, 1 is this, we only care about the function calling this
	stack_level = stack_level or 2;
	local traceback = debug.traceback(stack_level);

	error_id = error_id + 1;
	-- do output
	print("");
	print(ast_line);
	print("SCRIPT ERROR, timestamp " .. get_timestamp());
	print(msg);
	print("");
	print("ERROR ID: " .. error_id);
	print("See Lua - Errors tab for details");
	print(ast_line);
	print("");

	out.errors("");
	out.errors(ast_line);
	out.errors("ERROR ID: " .. error_id);
	out.errors("SCRIPT ERROR, timestamp " .. get_timestamp());
	out.errors(msg);
	out.errors("");
	out.errors(traceback);
	out.errors(ast_line);
	out.errors("");

	-- logfile output
	if __write_output_to_logfile then
		local file = io.open(__logfile_path, "a");
		
		if file then
			file:write(ast_line .. "\n");
			file:write("SCRIPT ERROR, timestamp " .. get_timestamp() .. "\n");
			file:write(msg .. "\n");
			file:write("\n");
			file:write(traceback .. "\n");
			file:write(ast_line .. "\n");
			file:close();
		end;
	end;

	report_script_error_to_campaign_ui(msg, traceback);
end;

function report_script_error_to_campaign_ui(msg, traceback)
	if is_campaign_ui_available() then
		all_scripted_campaign_ui.ReportScriptError(msg, traceback);
	end;
end;

function is_campaign_ui_available()
	local ui_created = all_scripted_core and all_scripted_core:is_ui_created();

	return __game_mode == __lib_type_campaign and ui_created;
end;


--- @function out
--- @desc <code>out</code> is a table that provides multiple methods for outputting text to the various available debug console spools. It may be called as a function to output a string to the main <code>Lua</code> console spool, but the following table elements within it may also be called to output to different output spools:
--- @desc <li>autotest</li>
--- @desc <li>savegame</li>
--- @desc <li>ui</li>
--- @desc <li>traits</li>
--- @desc <li>help_pages</li>
--- @desc <li>interventions</li>
--- @desc <li>experience</li>
--- @desc <li>events</li>
--- @desc <li>random_army</li>
--- @desc <li>ai</li>
--- @desc <li>advice</li>
--- @desc <li>design</li>
--- @desc <li>errors</li></ul>
--- @desc 
--- @desc out supplies four additional functions that can be used to show tab characters at the start of lines of output:
--- @desc <table class="simple"><tr><td>Function</td><td>Description</td></tr><tr><td><strong><code>out.inc_tab</td><td>Increments the number of tab characters shown at the start of the line by one.</td></tr><tr><td><strong><code>out.dec_tab</td><td>Decrements the number of tab characters shown at the start of the line by one. Decrementing below zero has no effect.</td></tr><tr><td><strong><code>out.cache_tab</td><td>Caches the number of tab characters currently set to be shown at the start of the line.</td></tr><tr><td><strong><code>out.restore_tab</td><td>Restores the number of tab characters shown at the start of the line to that previously cached.</td></tr></table>
--- @desc Tab levels are managed per output spool. To each of these functions a string argument can be supplied which sets the name of the output spool to apply the modification to. Supply no argument or a blank string to modify the tab level of the main output spool.
--- @p string output
--- @new_example Standard output
--- @example out("Hello World")
--- @example out.inc_tab()
--- @example out("indented")
--- @example out.dec_tab()
--- @example out("no longer indented")
--- @result Hello World
--- @result 	indented
--- @result no longer indented
--- @new_example UI tab
--- @desc Output to the ui tab, with caching and restoring of tab levels
--- @example out.ui("Hello UI tab")
--- @example out.cache_tab("ui")
--- @example out.inc_tab("ui")
--- @example out.inc_tab("ui")
--- @example out.inc_tab("ui")
--- @example out.ui("very indented")
--- @example out.restore_tab("ui")
--- @example out.ui("not indented any more")
--- @result Hello UI tab
--- @result 			very indented
--- @result not indented any more


-- this function re-maps all output functions so that they support timestamps
function remap_outputs(out_impl, suppress_new_session_output)

	-- Do not proceed if out_impl already has a metatable. This can happen if we're running in autotest mode and the game scripts have preconfigured the out table
	if getmetatable(out_impl) then
		return out_impl;
	end;

	-- construct a table to return	
	local out = {};
	
	-- construct an indexed list of output functions
	local output_functions = {};
	for key in pairs(out_impl) do
		table.insert(output_functions, key);
	end;

	-- sort the indexed list (just for output purposes)
	table.sort(output_functions);
	
	-- create a tab level record for each output function, and store it at out.tab_levels
	local tab_levels = {};
	for i = 1, #output_functions do
		tab_levels[output_functions[i]] = 0;
	end;
	tab_levels["out"] = 0;			-- default tab
	out.tab_levels = tab_levels;

	local svr = ScriptedValueRegistry:new();
	local game_uptime = os.clock();
		
	-- map each output function
	for i = 1, #output_functions do
		local current_func_name = output_functions[i];
		
		out[current_func_name] = function(str_from_script)		
			str_from_script = tostring(str_from_script) or "";
		
			-- get the current time at point of output
			local timestamp = get_timestamp();

			-- we construct our output string as a table - the first two entries are the timestamp and some whitespace
			local output_str_table = {timestamp, string.format("%" .. 11 - string.len(timestamp) .."s", " ")};

			-- add in all required tab chars
			for i = 1, out["tab_levels"][current_func_name] do
				table.insert(output_str_table, "\t");
			end;

			-- finally add the intended output
			table.insert(output_str_table, str_from_script);

			-- turn the table of strings into a string
			local output_str = table.concat(output_str_table);
			
			-- print the output
			out_impl[current_func_name](output_str);

			-- log that this output tab has been touched
			svr:SavePersistentBool("out." .. current_func_name .. "_touched", true);
			
			-- logfile output
			if __write_output_to_logfile then
				local file = io.open(__logfile_path, "a");
				if file then
					file:write("[" .. current_func_name .. "] " .. output_str .. "\n");
					file:close();
				end;
			end;
		end;

		-- if this tab has been touched in a previous session then write some new lines to it to differentiate this session's output
		if not suppress_new_session_output then
			if svr:LoadPersistentBool("out." .. current_func_name .. "_touched") then
				for i = 1, 10 do
					out_impl[current_func_name]("");
				end;
				out_impl[current_func_name]("* NEW SESSION, current game uptime: " .. game_uptime .. "s *");
				out_impl[current_func_name]("");
			end;
		end;
	end;
	
	-- also allow out to be directly called
	setmetatable(
		out, 
		{
			__call = function(t, str_from_script) 
				str_from_script = tostring(str_from_script) or "";
			
				-- get the current time at point of output
				local timestamp = get_timestamp();

				-- we construct our output string as a table - the first two entries are the timestamp and some whitespace
				local output_str_table = {timestamp, string.format("%" .. 11 - string.len(timestamp) .."s", " ")};

				-- add in all required tab chars
				for i = 1, out.tab_levels["out"] do
					table.insert(output_str_table, "\t");
				end;

				-- finally add the intended output
				table.insert(output_str_table, str_from_script);

				-- turn the table of strings into a string
				local output_str = table.concat(output_str_table);
				
				-- print the output
				print(output_str);

				-- log that this output tab has been touched
				svr:SavePersistentBool("out_touched", true);
				
				-- logfile output
				if __write_output_to_logfile then
					local file = io.open(__logfile_path, "a");
					if file then
						file:write("[out] " .. output_str .. "\n");
						file:close();
					end;
				end;
			end
		}
	);

	-- if the main output tab has been touched in a previous session then write some new lines to it to differentiate this session's output
	if not suppress_new_session_output then
		for i = 1, 10 do
			print("");
		end;
		
		print("* NEW SESSION, current game uptime: " .. game_uptime .. "s *");

		if not svr:LoadPersistentBool("out_touched") then
			print("  available output spools:");
			print("\tout");
			for j = 1, #output_functions do
				print("\tout." .. output_functions[j]);
			end;
			print("");
			print("");
		end;
		
		print("");
	end;
	
	-- add on functions inc, dec, cache and restore tab levels
	function out.inc_tab(func_name)
		func_name = func_name or "out";
		
		local current_tab_level = out.tab_levels[func_name];
		
		if not current_tab_level then
			script_error("ERROR: inc_tab() called but supplied output function name [" .. tostring(func_name) .. "] not recognised");
			return false;
		end;
		
		out.tab_levels[func_name] = current_tab_level + 1;
	end;
	
	function out.dec_tab(func_name)
		func_name = func_name or "out";
		
		local current_tab_level = out.tab_levels[func_name];
		
		if not current_tab_level then
			script_error("ERROR: dec_tab() called but supplied output function name [" .. tostring(func_name) .. "] not recognised");
			return false;
		end;
		
		if current_tab_level > 0 then
			out.tab_levels[func_name] = current_tab_level - 1;
		end;
	end;
	
	function out.cache_tab(func_name)
		func_name = func_name or "out";
		
		local current_tab_level = out.tab_levels[func_name];
		
		if not current_tab_level then
			script_error("ERROR: cache_tab() called but supplied output function name [" .. tostring(func_name) .. "] not recognised");
			return false;
		end;
		
		-- store cached tab level elsewhere in the tab_levels table
		out.tab_levels["cached_" .. func_name] = current_tab_level;
		out.tab_levels[func_name] = 0;
	end;
	
	function out.restore_tab(func_name)
		func_name = func_name or "out";
		
		local cached_tab_level = out.tab_levels["cached_" .. func_name];
		
		if not cached_tab_level then
			script_error("ERROR: restore_tab() called but could find no cached tab value for supplied output function name [" .. tostring(func_name) .. "]");
			return false;
		end;
		
		-- restore tab level, and clear the cached value
		out.tab_levels[func_name] = cached_tab_level;
		out.tab_levels["cached_" .. func_name] = nil;
	end;
	
	return out;
end;


-- call the remap function so that timestamped output is available immediately (script in other environments will have to re-call it)
out = remap_outputs(out, __is_autotest);





-- forceably clears and then requires a file
function force_require(file)
	package.loaded[file] = nil;
	require (file);
end;




-- set up the lua random seed
-- use script-generated random numbers sparingly - it's always better to ask the game for a random number
math.randomseed(os.time() + os.clock() * 1000);
math.random(); math.random(); math.random(); math.random(); math.random();










----------------------------------------------------------------------------
--- @section Loading Script Libraries
----------------------------------------------------------------------------


--- @function force_require
--- @desc Forceably unloads and requires a file by name.
--- @p string filename
function force_require(file)
	package.loaded[file] = nil;
	return require(file);
end;


--- @function load_script_libraries
--- @desc One-shot function to load the script libraries.
function load_script_libraries()
	-- path to the script folder
	package.path = package.path .. ";data/script/_lib/?.lua";

	-- loads in the script library header file, which queries the __game_mode and loads the appropriate library files
	force_require("lib_header");
end;

-- functions to add event callbacks
-- inserts the callback in the events[event] table (the events table being a collection of event tables, each of which contains a list
-- of callbacks to be notified when that event occurs). If a user_defined_list is supplied, then an entry for this event/callback is added
-- to that. This allows areas of the game to clear their listeners out on shutdown (the events table itself is global).
function add_event_callback(event, callback, user_defined_list)

	if type(event) ~= "string" then
		script_error("ERROR: add_event_callback() called but supplied event [" .. tostring(event) .. "] is not a string");
		return false;
	end;
	
	if type(events[event]) ~= "table" then
		events[event] = {};
	end;
	
	if type(callback) ~= "function" then
		script_error("ERROR: add_event_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	table.insert(events[event], callback);
	
	-- if we have been supplied a user-defined table, add this event callback to that
	if type(user_defined_list) == "table" then
		local user_defined_event = {};
		user_defined_event.event = event;
		user_defined_event.callback = callback;
		table.insert(user_defined_list, user_defined_event);
	end;
end;


-- function to clear callbacks in the supplied user defined list from the global events table. This can be called by areas of the game
-- when they shutdown.
function clear_event_callbacks(user_defined_list)
	if not type(user_defined_list) == "table" then
		script_error("ERROR: clear_event_callbacks() called but supplied user defined list [" .. tostring(user_defined_list) .. "] is not a table");
		return false;
	end;
	
	local count = 0;

	-- for each entry in the supplied user-defined list, look in the relevant event table
	-- and try to find a matching callback event. If it's there, remove it.
	for i = 1, #user_defined_list do	
		local current_event_name = user_defined_list[i].event;
		local current_event_callback = user_defined_list[i].callback;
		
		for j = 1, #events[current_event_name] do
			if events[current_event_name][j] == current_event_callback then
				count = count + 1;
				table.remove(events[current_event_name], j);
				break;
			end;
		end;
	end;

	-- overwrite the user defined list
	user_defined_list = {};
	
	return count;
end;



events = force_require("script.events");


