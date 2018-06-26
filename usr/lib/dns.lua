comp = require("component")
dns = {}
assert(comp.isAvailable("modem"), "You need a network card to use the dns service")
local function dns.get()
comp.modem.broadcast(53, "dns ping")
event.pull( 