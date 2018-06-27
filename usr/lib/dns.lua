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
repeat
server = dns.get()
until server
comp.modem.open(53)
comp.modem.send(server, 53, "dns lookup", hostname)
local _, _, sender, _, addr = event.pull("modem_message")
comp.modem.close(53)
end
function dns.register(hostname)
local server
repeat
server = dns.get()
until server
local modem = comp.modem
modem.send(server, 53, "dns register", modem.address, hostname)
end
function dns.new()
comp.modem.open(53)
while true do
local event, _, sender, _, func, arg1, arg2 = event.pullMultiple("modem_message", interrupt)
if event == "modem_message" then
if func == "dns ping" then
comp.modem.send(sender, 53, "dns pong")
elseif func == "dns lookup" then
local file = io.open("/etc/hosts", "r")
local domains = serialization.unserialize(file.read("*a"))
comp.modem.send(sender, 53, "dns lookup", domains[hostname])
elseif func == "dns register" then
local file = io.open("/etc/hosts", "r")
local domains = serialization.unserialize(file.read("*a"))
domains[arg2] = arg1
file = nil
local file = io.open("/etc/hosts", "w")
file.write(serialization.serialize(domains))
end
else
print("Closing dns...")
return
end
end
end