local function mkid(r)
    noid = r.x .. ',' .. r.y
    if r.z then
        noid = noid .. ',' .. r.z
    end
    return noid
end

local function add_region(cr, r)
    if r.id then
        cr[r.id] = r
    end
    noid = mkid(r)
    cr[noid] = r
end

local self = { ['mkid'] = mkid }

function self.read(filename, plane)
    local cr = {}
    local r = nil
    plane = plane or 0
    for line in io.lines(filename) do
        if r then
            ch = string.sub(line, 1, 1)
            if ch == '"' then
                -- a string value
                lhs, rhs = string.match(line, '"(.+)";(%a+)')
                if lhs and rhs then
                    if rhs == 'Terrain' then
                        r.terrain = lhs
                    elseif rhs == 'Name' then
                        r.name = lhs
                    elseif rhs == 'Beschr' then
                        r.desc = lhs
                    end
                end
            elseif ((ch >= '0') and (ch <= '9')) or (ch == '-') then
                -- some integer value
                lhs, rhs = string.match(line, '(-?%d+);(%a+)')
                if rhs == 'id' then
                    r.id = tonumber(lhs)
                end
            elseif (ch >= 'A') and (ch <= 'Z') then
                -- a new block
                add_region(cr, r)
                r = nil
            end
        end
        if not r then
            -- check for new region
            x, y, z = string.match(line, "REGION (-?%d+) (-?%d+) (-?%d+)")
            if not z and plane==0 then
                x, y = string.match(line, "REGION (-?%d+) (-?%d+)")
                z = 0
            end
            if plane == z then
                if x and y then
                    r = {}
                    r.x = x
                    r.y = y
                    if z ~= 0 then
                        r.z = z
                    end
                end
            end
        end
    end
    if r then
        -- in case this region is the final block in the file (pure maps)
        add_region(cr, r)
    end
    return cr
end

local function write_region(f, r)
    f:write("REGION " .. r.x .. " " .. r.y)
    if r.z then
        f:write(" " .. r.z)
    end
    f:write("\n")
    if r.id then
        f:write(r.id .. ";id\n")
    end
    if not r.terrain then
        print("no terrain", r.x, r.y)
    else
        f:write('"' .. r.terrain .. '";Terrain\n')
    end
    if r.desc then
        f:write('"' .. r.desc .. '";Beschr\n')
    end
    if r.name then
        f:write('"' .. r.name .. '";Name\n')
    end
end

function self.write(filename, cr)
    local f = io.open(filename, "wb")
    if f then
        f:write(string.char(0xef, 0xbb, 0xbf))
        f:write("VERSION 66\n")
        for id, r in pairs(cr) do
            if type(id) == 'number' then
                write_region(f, r)
            elseif not r.id then
                write_region(f, r)
            end
        end
        f:close()
    end
end

return self

