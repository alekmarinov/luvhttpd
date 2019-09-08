local uv = require "luv"

require "luvhttpd".create(8080, "0.0.0.0")
    .handle("GET", "^/hello/(.*)$", function(req, res)
        res.write(string.format("Hello %s!\r\n", req.params[1]))
        res.close()
    end)
    .handle("GET", "^/form$", function(req, res)
        res.headers["content-type"] = "text/html"
        res.write([[
            <body>
            <form action="/submit" method="POST">
                <textarea name="text"></textarea>
                <br>
                <input type="submit"/>
            </form>
            </body>
        ]])
        res.close()
    end)
    .handle("POST", "^/submit$", function(req, res)
        local filename = "postdata.txt"
        local fd = assert(uv.fs_open(filename, "w", 438))
        req.ondata = function(data)
            if data then
                print(string.format("Writing '%s'", data))
                uv.fs_write(fd, data, -1)
            else
                print(string.format("closing file %s", filename))
                uv.fs_close(fd)
                res.close("Thank you!")
            end
        end
    end)
    .handle("GET", "^/beep$", function(req, res)
        local s = "Beeeeeep\r\n"
        local timer = uv.new_timer()
        local times = 100
        timer:start(0, 100, function ()
            times = times - 1
            res.write(s)
            if times == 0 then
                res.close()
                timer:stop()
                timer:close()
            end
        end)
    end)
    .start()
