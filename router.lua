local ip_to_int
ip_to_int = function(ip)
  local one, two, three, four = ip:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
  return (one << 24) | (two << 16) | (three << 8) | four
end
local cfgparse = require("configparse")
local RoutingTable
do
  local _class_0
  local _base_0 = {
    from_file = function(file, mask)
      local f = io.open(file)
      local cfg = cfgparse.parse(f:read("*a"))
      f:close()
      return RoutingTable(cfg, mask)
    end,
    find = function(self, addr)
      return self.router[addr & self.netmask]
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, cfg, mask)
      self.router = { }
      self.netmask = ip_to_int((mask))
      for opt in cfg:each() do
        for addr in opt.sub:each() do
          local i = (ip_to_int(addr.name)) & self.netmask
          self.router[i] = {
            kind = opt.name,
            to = addr.args[1]
          }
        end
      end
    end,
    __base = _base_0,
    __name = "RoutingTable"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  RoutingTable = _class_0
end
return RoutingTable
