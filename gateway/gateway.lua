local ip_to_int
ip_to_int = function(ip)
  local one, two, three, four = ip:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
  return (one << 24) | (two << 16) | (three << 8) | four
end
local ip_from_int
ip_from_int = function(ip)
  return ((ip >> 24) & 0xFF) .. "." .. ((ip >> 16) & 0xFF) .. "." .. ((ip >> 8) & 0xFF) .. "." .. (ip & 0xFF)
end
local RoutingTable = require("router")
local text = require("text")
local component = require("component")
local net = component.modem
local r = RoutingTable.from_file("relay.cfg", "255.255.255.255")
local lan_id_to_ip = { }
local lan_ip_to_id = { }
local trans_table_f = io.open("lan.cfg")
for l in trans_table_f:lines() do
  local info = text.tokenize(l)
  lan_id_to_ip[info[1]] = info[0]
  lan_ip_to_id[ip_to_int(info[0])] = info[1]
end
local relay = r.router["relay"].to
while true do
  local _, addr, toIp, one, two, three, four, five, six
  _, addr, _, _, toIp, one, two, three, four, five, six = event.pull("modem_message")
  toIp = ip_to_int(toIp)
  local destination = lan_ip_to_id[toIp]
  if destination == nil then
    print("routing message from " .. fromIp .. " to " .. toIp .. " through relay")
    net.send(relay, 10, ip_to_int(lan_id_to_ip[addr]), toIp, one, two, three, four, five, six)
  else
    print("routing message from " .. fromIp .. " to " .. toIp .. " through modem")
    net.send(destination.to, 10, ip_from_int(fromIp), ip_from_int(toIp), one, two, three, four, five, six)
  end
end
