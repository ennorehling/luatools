crfile = require('crfile')

local terrains = {
    ['Vulkan'] = 'volcano',
    ['Aktiver Vulkan'] = 'volcano',
    ['Ozean'] = 'ocean',
    ['Ebene'] = 'plain',
    ['Wüste'] = 'desert',
    ['Wueste'] = 'desert',
    ['Feuerwand'] = 'firewall',
    ['Berge'] = 'mountain',
    ['Hochland'] = 'highland',
    ['Sumpf'] = 'swamp',
    ['Gletscher'] = 'glacier',
    ['Dichter Nebel'] = 'thickfog',
    ['Nebel'] = 'fog',
    ['Gang'] = 'corridor',
    ['Wand'] = 'wall',
    ['Wald'] = 'forest',
    ['Eisberg'] = 'iceberg',
}

function terrain_name(crname)
    name = terrains[crname]
    if name == nil then
        return 'unknown'
    end
    return name
end

function dump_json(cr)
    for id, r in pairs(cr) do
        if type(id) ~= 'number' then
            line = string.format('{ "id": %d, "terrain": "%s", ', r.id, terrain_name(r.terrain))
            if r.name then
                line = line .. string.format('"name": "%s", ', r.name)
            end
            line = line .. string.format('"x": %d, "y": %d}', r.x, r.y)
            print(line)
        end
    end
end

if #arg > 0 then
    cr = crfile.read(arg[1], plane)
    if cr then
        dump_json(cr)
    end
end
