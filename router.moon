ip_to_int = (ip) ->
  one, two, three, four = ip\match "(%d+)%.(%d+)%.(%d+)%.(%d+)"
  return (one << 24) | (two << 16) | (three << 8) | four

cfgparse = require("configparse")

class RoutingTable
  new: (cfg, mask) =>
    @router = {}
    @netmask = ip_to_int (mask)
    for opt in cfg\each!
      for addr in opt.sub\each!
        i = (ip_to_int addr.name) & @netmask
        @router[i] = {
          kind: opt.name,
          to: addr.args[1]
        }

  from_file: (file, mask) ->
    f = io.open file
    cfg = cfgparse.parse f\read "*a"
    f\close!
    return RoutingTable cfg, mask

  find: (addr) =>
    return @router[addr & @netmask]

return RoutingTable
