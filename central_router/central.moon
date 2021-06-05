RoutingTable = require("router")
component = require("component")
net = component.modem

links = RoutingTable.from_file "central.cfg", "255.0.0.0" 
relays = RoutingTable.from_file "relays.cfg", "255.255.0.0"

while true
  _, _, _, _, fromIp, toIp, one, two, three, four, five, six = event.pull("modem_message")
  destination = links\find toIp
  if destination == nil
    print("couldn't find route for msg from " .. fromIp .. " to " .. toIp)
  elseif destination == "self" -- destination is subrelay of this network
    destination = relays\find toIp
    if destination != nil
      net.send destination.to, 10, fromIp, toIp, one, two, three, four, five, six
      print("routing message from " .. fromIp .. " to " .. toIp .. " through relay")
    else
      print("couldn't find route for msg from " .. fromIp .. " to " .. toIp)
  else
    print("routing message from " .. fromIp .. " to " .. toIp .. " through link card")
    component.invoke destination.to, "send", fromIp, toIp, one, two, three, four, five, six
