local RoutingTable = require("router")
local component = require("component")
local net = component.modem
local r = RoutingTable.from_file("central.cfg", "255.0.0.0")
local local_router = r.router["router"].to
while true do
  local _, fromIp, toIp, one, two, three, four, five, six
  _, _, _, _, fromIp, toIp, one, two, three, four, five, six = event.pull("modem_message")
  local destination = r:find(toIp)
  if destination == nil then
    print("routing message from " .. fromIp .. " to " .. toIp .. " through router")
    net.send(local_router, 10, fromIp, toIp, one, two, three, four, five, six)
  else
    print("routing message from " .. fromIp .. " to " .. toIp .. " through link card")
    component.invoke(destination.to, "send", fromIp, toIp, one, two, three, four, five, six)
  end
end
