local safeCall = require( "runner" )

local function loadConfig()
    local json = require( "lib/json" )

    -- If a config file is given, we use that instead of building a new one
    local CONFIG_FILE = arg[1]
    if CONFIG_FILE and CONFIG_FILE ~= "" then
        print( CONFIG_FILE )
        return
    end

    ---@param list string[]
    ---@return table<string, string>
    local function makeLookup( list )
        local newList = {}
        for _, v in ipairs( list ) do
            newList[v] = v
        end

        return newList
    end

    local TITLE = assert( arg[2], "No title given" )

    local TYPE = assert( arg[3], "No type given" )
    do
        local valid = makeLookup( {
            "ServerContent", "gamemode", "map", "weapon", "vehicle", "npc", "tool", "effects", "model", "entity"
        } )
        assert( valid[TYPE], "Invalid 'type' input: " .. TYPE )
    end

    local TAGS = {}
    do
        local valid = makeLookup( {
            "fun", "roleplay", "scenic", "movie", "realism", "cartoon", "water", "comic", "build"
        } )

        local added = {}
        local function addTag( tag )
            if not tag then return end
            if tag == "" then return end

            assert( valid[tag], "Invalid tag: " .. tag )
            if added[tag] then return end

            table.insert( TAGS, tag )
            added[tag] = true
        end

        addTag( arg[4] )
        addTag( arg[5] )
        addTag( arg[6] )

        assert( #TAGS > 0, "No tags given" )
    end

    local path = os.time() .. ".json"

    local config = {
        title = TITLE,
        type = TYPE,
        tags = TAGS,
        ignore = { path, ".git/*", ".github/*", "addon.txt" }
    }

    local newContents = json.encode( config )

    local handle = assert( io.open( path, "wb" ), "Failed to open file for writing: " .. path )
    handle:write( newContents )
    handle:close()

    print( path )
end

safeCall( loadConfig, "Failed to process addon config" )
