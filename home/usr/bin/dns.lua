local comp = require("component")
local event = require("event")
local shell = require("shell")
local dns = require("dns")
local Instance = require("Instance")
local args, ops = shell.parse(...)
assert(comp.isAvailable("modem"))
if not ops["h"] and not ops["r"]then
lookup(args[1])
elseif not ops["h"] and ops["r"]then
register(comp.getPrimary("modem").address, args[1])
end