local RoutingTable = require("router")
local component = require("component")
local net = component.modem
local links = RoutingTable.from_file("central.cfg", "255.0.0.0")
local relays = RoutingTable.from_file("relays.cfg", "255.255.0.0")
while true do
  local _, fromIp, toIp, one, two, three, four, five, six
  _, _, _, _, fromIp, toIp, one, two, three, four, five, six = event.pull("modem_message")
  local destination = links:find(toIp)
  if destination == nil then
    print("couldn't find route for msg from " .. fromIp .. " to " .. toIp)
  elseif destination == "self" then
    destination = relays:find(toIp)
    if destination ~= nil then
      net.send(destination.to, 10, fromIp, toIp, one, two, three, four, five, six)
      print("routing message from " .. fromIp .. " to " .. toIp .. " through relay")
    else
      print("couldn't find route for msg from " .. fromIp .. " to " .. toIp)
    end
  else
    print("routing message from " .. fromIp .. " to " .. toIp .. " through link card")
    component.invoke(destination.to, "send", fromIp, toIp, one, two, three, four, five, six)
  end
end
