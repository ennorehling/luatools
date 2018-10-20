crfile = require('crfile')

local clean = false

function read_map(filename, plane)
    return crfile.read(filename, plane)
end

function write_map(filename, cr)
    return crfile.write(filename, cr)
end

function find_offset(c1, c2)
    for id, r2 in pairs(c2) do
        if type(id) == 'number' and c1[id] then
            r1 = c1[id]
            return r1.x - r2.x, r1.y - r2.y
        end
    end
    return nil
end

function clean_map(cr)
    for id, r in pairs(cr) do
        if r.terrain == 'Ozean' then
            r.name = nil
            r.desc = nil
        end
    end
end

function merge_map(cr, cm, xo, yo)
    for id, r in pairs(cm) do
        if type(id) ~= 'number' then
            if xo and yo then
                r.x = r.x + xo
                r.y = r.y + yo
            end
            noid = crfile.mkid(r)
            r2 = cr[noid]
            if r2 then
                for k, v in pairs(r) do
                   r2[k] = v
                end
            else
                cr[noid] = r
                if r.id then
                    cr[r.id] = r
                end
            end
        end
    end
end

if #arg > 0 then
    cr = nil
    i = 1
    outfile = 'output.cr'
    plane = 0
    while i <= #arg do
        if arg[i]=='-p' then
            plane = tonumber(arg[i+1])
            i = i + 2
        elseif arg[i]=='-o' then
            outfile = arg[i+1]
            i = i + 2
        elseif arg[i]=='-c' then
            clean = true
            i = i + 1
        else
            cm = read_map(arg[i], plane)
            i = i + 1
            if cr then
                x, y = find_offset(cr, cm)
                if x and y then
                    merge_map(cr, cm, x, y)
                else
                    print("cannot merge", line)
                end
            else
                cr = cm
            end
        end
    end
    if clean then
        clean_map(cr)
    end
    write_map(outfile, cr)
end


