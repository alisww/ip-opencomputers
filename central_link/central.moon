RoutingTable = require("router")
component = require("component")
net = component.modem

r = RoutingTable.from_file "central.cfg", "255.0.0.0" 
local_router = r.router["router"].to

while true
  _, _, _, _, fromIp, toIp, one, two, three, four, five, six = event.pull("modem_message")
  destination = r\find toIp
  if destination == nil
    print("routing message from " .. fromIp .. " to " .. toIp .. " through router")
    net.send local_router, 10, fromIp, toIp, one, two, three, four, five, six
  else
    print("routing message from " .. fromIp .. " to " .. toIp .. " through link card")
    component.invoke destination.to, "send", fromIp, toIp, one, two, three, four, five, six
