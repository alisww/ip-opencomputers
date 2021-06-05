RoutingTable = require("router")
component = require("component")
net = component.modem

r = RoutingTable.from_file "relay.cfg", "255.255.255.0" 
central = r.router["central"].to

while true
  _, _, _, _, fromIp, toIp, one, two, three, four, five, six = event.pull("modem_message")
  destination = r\find toIp
  if destination == nil
    print("routing message from " .. fromIp .. " to " .. toIp .. " through central")
    net.send central, 10, fromIp, toIp, one, two, three, four, five, six
  else
    print("routing message from " .. fromIp .. " to " .. toIp .. " through modem")
    net.send destination.to, 10, fromIp, toIp, one, two, three, four, five, six
