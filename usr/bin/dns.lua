local comp = require("component")
local event = require("event")
local shell = require("shell")
local dns = require("dns")
local Instance = require("Instance")
local args, ops = shell.parse(...)
assert(comp.isAvailable("modem"), "You need a network card to use the dns service")
if not ops["h"] and not ops["r"]then
dns.lookup(args[0])
elseif ops["h"] and not ops["r"]then
dns.new()
elseif not ops["h"] and ops["r"]then
dns.register(comp.getPrimary("modem").address, args[0])
end