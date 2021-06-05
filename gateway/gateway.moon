ip_to_int = (ip) ->
  one, two, three, four = ip\match "(%d+)%.(%d+)%.(%d+)%.(%d+)"
  return (one << 24) | (two << 16) | (three << 8) | four

ip_from_int = (ip) ->
  return ((ip >> 24) & 0xFF) .. "." .. ((ip >> 16) & 0xFF) .. "." .. ((ip >> 8) & 0xFF) .. "." .. (ip & 0xFF)

RoutingTable = require("router")
text = require("text")
component = require("component")
net = component.modem

r = RoutingTable.from_file "relay.cfg", "255.255.255.255"

lan_id_to_ip = {}
lan_ip_to_id = {}

trans_table_f = io.open "lan.cfg"
for l in trans_table_f\lines!
  info = text.tokenize l
  lan_id_to_ip[info[1]] = info[0]
  lan_ip_to_id[ip_to_int(info[0])] = info[1]

relay = r.router["relay"].to

while true
  _, addr, _, _, toIp, one, two, three, four, five, six = event.pull("modem_message")
  toIp = ip_to_int toIp
  destination = lan_ip_to_id[toIp]
  if destination == nil
    print("routing message from " .. fromIp .. " to " .. toIp .. " through relay")
    net.send relay, 10, ip_to_int(lan_id_to_ip[addr]), toIp, one, two, three, four, five, six
  else
    print("routing message from " .. fromIp .. " to " .. toIp .. " through modem")
    net.send destination.to, 10, ip_from_int(fromIp), ip_from_int(toIp), one, two, three, four, five, six
