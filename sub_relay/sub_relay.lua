local RoutingTable = require("router")
local component = require("component")
local net = component.modem
local r = RoutingTable.from_file("relay.cfg", "255.255.255.0")
local central = r.router["central"].to
while true do
  local _, fromIp, toIp, one, two, three, four, five, six
  _, _, _, _, fromIp, toIp, one, two, three, four, five, six = event.pull("modem_message")
  local destination = r:find(toIp)
  if destination == nil then
    print("routing message from " .. fromIp .. " to " .. toIp .. " through central")
    net.send(central, 10, fromIp, toIp, one, two, three, four, five, six)
  else
    print("routing message from " .. fromIp .. " to " .. toIp .. " through modem")
    net.send(destination.to, 10, fromIp, toIp, one, two, three, four, five, six)
  end
end
