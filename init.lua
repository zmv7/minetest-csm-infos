local toggle
core.register_on_punchnode(function(pos, node)
if not toggle then return end
core.show_formspec('nodename','size[5,1]field[0.3,0.3;5,1;nname;Punched node name is:;'..node.name..']')
toggle = nil
end)
core.register_chatcommand("nname", {
    description = "Check nodename",
    func = function(param)
toggle = 1
return true, 'Punch node to check its name'
end})

core.register_chatcommand("pos", {
    description = "Check unpointable nodename where you standing",
    func = function(param)
local node = core.get_node_or_nil(core.localplayer:get_pos())
if not node then return false, 'No node!' end
local pos = core.pos_to_string(vector.round(core.localplayer:get_pos()))
core.show_formspec('poscheck','size[5,4]field[0.3,0.3;5,1;pos;Position:;'..pos:gsub('[%(%)]','')..']field[0.3,1.3;5,1;node;Node:;'..node.name..']field[0.3,2.3;5,1;p1;Param1:;'..node.param1..']field[0.3,3.3;5,1;p2;Param2:;'..node.param2..']')
end})

core.register_chatcommand("witem", {
  description = "View wielded item name",
  func = function()
core.display_chat_message('Wielded item is '..core.colorize('#FF0',core.localplayer:get_wielded_item():get_name()))
end})

local function rs(color,name) return color and core.colorize('#F00',name) or core.colorize('#0F0',name) end
local csmr = core.get_csm_restrictions()
local si = core.get_server_info()
local sinfo = core.colorize('#0FF','---Server info---\n'..si.address..'\n'
..'IP: '..si.ip..':'..si.port..'\n'
..'Protocol: '..si.protocol_version..'\n'
..'CSM flags: ')
..rs(csmr.load_client_mods,'LoadCSM ')..'|'
..rs(csmr.chat_messages,' Chat ')..'|'
..rs(csmr.read_playerinfo,' PlayerInfo ')..'|'
..rs(csmr.read_itemdefs,' ItemDefs ')..'|'
..rs(csmr.read_nodedefs,' NodeDefs ')..'|'
..rs(csmr.lookup_nodes,' LookupNodes')

core.register_chatcommand("sinfo", {
  description = "View server info",
  func = function()
core.display_chat_message(sinfo)
end})
