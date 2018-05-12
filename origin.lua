crfile = require('crfile')

function move(cr, ox, oy)
    for id, r in pairs(cr) do
        if type(id) ~= 'number' then
            r.x = r.x -ox
            r.y = r.y -oy
        end
    end
end

if #arg > 0 then
    i = 1
    outfile = nil
    infile = nil
    plane = 0
    ox = nil
    oy = nil
    while i <= #arg do
        if arg[i]=='-p' then
            plane = tonumber(arg[i+1])
            i = i + 2
        elseif arg[i]=='-o' then
            outfile = arg[i+1]
            i = i + 2
        elseif arg[i]=='-i' then
            infile = arg[i+1]
            i = i + 2
        else
            ox = math.floor(arg[i])
            oy = math.floor(arg[i+1])
            i = i + 2
        end
    end
    cr = crfile.read(infile, plane)
    if cr and ox and oy then
        print("moving origin of " .. infile .. " to " .. ox .."," .. oy)
        move(cr, ox, oy)
        crfile.write(outfile, cr)
    end
end
