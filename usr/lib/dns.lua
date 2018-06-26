local Instance = require("Instance")
local comp = require("component")
dns = Instance.new()
assert(pcall(comp.getPrimary("modem")))
local function dns.get()
comp.modem.broadcast(53, "dns ping")
comp.modem.open(53)
local _, _, sender = event.pull("modem_message", 10)
comp.modem.close(53)
return sender
end
function dns.lookup(hostname)
checkarg(1, hostname, "string")
local server
while not server do
server = dns.get()
end
comp.modem.open(53)
comp.modem.send(server, "dns lookup", hostname)
local _, _, sender, _, addr = event.pull("modem_message")
while sender ~= server do
comp.modem.send(server, "dns lookup", hostname)
local _, _, sender, _, addr = event.pull("modem_message")
end
comp.modem.close(53)
end