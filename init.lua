local F = core.formspec_escape
local nname_enable
core.register_on_punchnode(function(pos, node)
	if not nname_enable then return end
	core.show_formspec("nodename","size[5,1]field[0.3,0.3;5,1;nname;Punched node name is:;"..node.name.."]")
	nname_enable = nil
end)
core.register_chatcommand("nname", {
  description = "Check nodename",
  func = function(param)
	nname_enable = true
	return true, "Punch node to check its name"
end})

core.register_chatcommand("pos", {
  description = "Check unpointable nodename where you standing or specified pos",
  params = "[pos]",
  func = function(param)
	local pos = core.string_to_pos(param) or vector.round(core.localplayer:get_pos())
	local strpos = core.pos_to_string(pos)
	local node = core.get_node_or_nil(pos)
	if not node then
		return false, "No node!"
	end
	core.show_formspec("poscheck","size[5,4]field[0.3,0.4;5,1;pos;Position:;"..strpos:gsub("[%(%)]","").."]field[0.3,1.4;5,1;node;Node:;"..node.name.."]field[0.3,2.4;5,1;p1;Param1:;"..node.param1.." (light: "..math.floor(node.param1 / 16)..")]field[0.3,3.4;5,1;p2;Param2:;"..node.param2.."]")
end})

core.register_chatcommand("witem", {
  description = "View wielded item name",
  func = function(param)
	local witem = core.localplayer:get_wielded_item()
	if witem then
		local winame = witem:get_name()
		local wear = witem:get_wear()
		return true, "Wielded item is "..core.colorize("#FF0",winame..(wear and wear > 0 and " | Wear: "..tostring(wear).." / 65536" or ""))
	end
end})

local function rs(color,name)
	return color and core.colorize("#F00",name) or core.colorize("#0F0",name)
end

core.register_chatcommand("sinfo", {
  description = "View server info",
  func = function(param)
	local csmr = core.get_csm_restrictions()
	local si = core.get_server_info()
	local sinfo = core.colorize("#0FF","---Server info---\n"..si.address.."\n"..
		"IP: "..si.ip..":"..si.port.."\n"..
		"Protocol: "..si.protocol_version.."\n"..
		"CSM flags: ")..
		rs(csmr.load_client_mods,"LoadCSM ").."|"..
		rs(csmr.chat_messages," Chat ").."|"..
		rs(csmr.read_playerinfo," PlayerInfo ").."|"..
		rs(csmr.read_itemdefs," ItemDefs ").."|"..
		rs(csmr.read_nodedefs," NodeDefs ").."|"..
		rs(csmr.lookup_nodes," LookupNodes")
	return true, sinfo
end})

local function superconcat(t, delim, lvl)
	if type(t) ~= "table" then
		return "Invalid paramater #1: table expected, got "..type(t)
	end
	if not delim then delim = ",\n" end
	if not lvl then lvl = 1 end
	local out = {}
	for k,v in pairs(t) do
		if type(v) == "table" then
			v = superconcat(v, delim, lvl+1)
		elseif type(v) == "string" then
			v = '"'..v..'"'
		else
			v = tostring(v)
		end
		table.insert(out,("\t"):rep(lvl)..tostring(k).." = "..v)
	end
	if #out == 0 then
		return "{}"
	end
	table.sort(out)
	return "{"..delim:gsub(",","")..table.concat(out,delim)..delim:gsub(",","")..("\t"):rep(lvl-1).."}"
end

core.register_chatcommand("idef", {
  description = "View item definition",
  params = "[itemname]",
  func = function(param)
	local iname = param
	local wear
	if not param or param == "" then
		local witem = core.localplayer:get_wielded_item()
		iname = witem and witem:get_name()
		wear = witem and witem:get_wear()
	end
	local idef = core.get_item_def(iname)
	if not idef then
		return false, "Unknown item"
	end
	core.show_formspec("itemdef","size[10,10]textarea[0.3,0.3;10,11.2;idef;"..F(iname..(wear and wear > 0 and " | Wear: "..tostring(wear).." / 65536" or ""))..";"..F(superconcat(idef)).."]")
end})
core.register_chatcommand("ndef", {
  description = "View node definition",
  params = "[nodename]",
  func = function(param)
	local nname = param
	if not param or param == "" then
		local witem = core.localplayer:get_wielded_item()
		nname = witem and witem:get_name()
	end
	local ndef = core.get_node_def(nname)
	if not ndef then
		return false, "Unknown node"
	end
	core.show_formspec("nodedef","size[10,10]textarea[0.3,0.3;10,11.2;ndef;"..F(nname)..";"..F(superconcat(ndef)).."]")
end})

local function kbtoh(val)
	if type(val) ~= "number" then
		return
	end
	local lvls = {"K", "M", "G", "T"}
	local lvl = 1
	while val > 1024 do
		val = val/1024
		lvl = lvl + 1
	end
	local str = tostring(val):match("%d+%.%d%d")
	return (str or val).." "..lvls[lvl].."B"
end

minetest.register_chatcommand("luamem",{
  description = "Check Lua's memory consumption",
  func = function(param)
	local mem = collectgarbage("count")
	return true, kbtoh(mem)
end})
