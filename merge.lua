crfile = require('crfile')

function read_map(filename)
    return crfile.read(filename)
end

function write_map(filename, cr)
    return crfile.write(filename, cr)
end

function find_offset(c1, c2)
    for id, r in pairs(c2) do
        if c1[id] then
            r2 = c1[id]
            return r.x - r2.x, r.y - r2.y
        end
    end
    return nil
end

function merge_map(c1, c2, xo, yo)
    for id, r in pairs(c2) do
        if xo and yo then
            r.x = r.x - xo
            r.y = r.y - yo
        end
        if c1[id] then
            r2 = c1[id]
            for k, v in pairs(r) do
               r2[k] = v
            end
        else
            c1[id] = r
        end
    end
end

if #arg > 0 then
    cr = nil
    for line in io.lines(arg[1]) do
        print(line)
        cm = read_map(line)
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
    output = 'output.cr'
    if #arg > 1 then
        output = arg[2]
    end
    write_map(output, cr)
end


