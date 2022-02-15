local toggle
minetest.register_on_punchnode(function(pos, node)
if not toggle then return end
core.show_formspec('nodename','size[5,1]textarea[0,0;5,1;;Punched node name is:;\n'..node.name..']')
toggle = nil
end)
minetest.register_chatcommand("nname", {
    description = "Check nodename",
    func = function(param)
toggle = 1
return true, 'Punch node to check its name'
end})
minetest.register_chatcommand("witem", {
  description = "View wielded item name",
  func = function()
core.display_chat_message('Wielded item is '..minetest.colorize('#FF0',core.localplayer:get_wielded_item():get_name()))
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

minetest.register_chatcommand("sinfo", {
  description = "View server info",
  func = function()
core.display_chat_message(sinfo)
end})
