# luvhttpd

Small [Lua](https://www.lua.org/) http server based on the [luv](https://github.com/luvit/luv) library.

## Example
      
```lua
require "luvhttpd"
	.create(8080, "0.0.0.0")
	.handle("GET", "^/hello/(.*)$", function(req, res)
		res.write(string.format("Hello %s!\r\n", req.params[1]))
		res.close()
	end)
	.handle("POST", "^/submit$", function(req, res)
		local postdata = {}
		req.ondata  =  function(data)
			if data then
				table.insert(postdata, data)
			else
				res.close(string.format("Got this `%s'", table.concat(postdata)))
			end
		end
	end)
```
