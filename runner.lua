local function githubError( title, result )
    local fileName, lineNumber, errorMessage = result:match( "([^:]+):(%d+):.(.*)" )

    local format = "::error file=%s,line=%s,title=%s::%s"
    local message = string.format( format, fileName, lineNumber, title, errorMessage )

    local stack = debug.traceback( nil, 3 )
    print( stack, "\n" )
    print( message )
end

return function( f, title )
    local ok = xpcall( f, function( err )
        githubError( title, err )
    end )

    if ok then return end

    os.exit( 1 )
end
