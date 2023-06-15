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
	if not node then return false, "No node!" end
	core.show_formspec("poscheck","size[5,4]field[0.3,0.3;5,1;pos;Position:;"..strpos:gsub("[%(%)]","").."]field[0.3,1.3;5,1;node;Node:;"..node.name.."]field[0.3,2.3;5,1;p1;Param1:;"..node.param1.."]field[0.3,3.3;5,1;p2;Param2:;"..node.param2.."]")
end})

core.register_chatcommand("witem", {
  description = "View wielded item name",
  func = function(param)
	core.display_chat_message("Wielded item is "..core.colorize("#FF0",core.localplayer:get_wielded_item():get_name()))
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
	core.display_chat_message(sinfo)
end})

local function superconcat(def, lvl)
	if not lvl then lvl = 1 end
	local out = {}
	for k,v in pairs(def) do
		if type(v) == "table" then
			v = superconcat(v, lvl+1)
		end
		table.insert(out,("\t"):rep(lvl)..tostring(k).." = "..tostring(v))
	end
	table.sort(out)
	return "{\n"..table.concat(out,"\n").."\n"..("\t"):rep(lvl-1).."}"
end

core.register_chatcommand("idef", {
  description = "View item definition",
  params = "[itemname]",
  func = function(param)
	local iname = param
	if not param or param == "" then
		iname = core.localplayer:get_wielded_item():get_name()
	end
	local idef = core.get_item_def(iname)
	if not idef then
		return false, "Unknown item"
	end
	core.show_formspec("itemdef","size[10,10]textarea[0.3,0.3;10,11.2;idef;"..F(iname)..";"..F(superconcat(idef)).."]")
end})
core.register_chatcommand("ndef", {
  description = "View node definition",
  params = "[nodename]",
  func = function(param)
	local nname = param
	if not param or param == "" then
		nname = core.localplayer:get_wielded_item():get_name()
	end
	local ndef = core.get_node_def(nname)
	if not ndef then
		return false, "Unknown node"
	end
	core.show_formspec("nodedef","size[10,10]textarea[0.3,0.3;10,11.2;ndef;"..F(nname)..";"..F(superconcat(ndef)).."]")
end})

