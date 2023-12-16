local function githubError( title, result )
    local fileName, lineNumber, errorMessage = result:match( "([^:]+):(%d+):.(.*)" )

    local format = "::error file=%s,line=%s,title=%s::%s"
    local message = string.format( format, fileName, lineNumber, title, errorMessage )

    local stack = debug.traceback( errorMessage, 3 )
    print( stack, "\n" )
    print( message )
end

return function( f, title )
    xpcall( f, function( err )
        githubError( title, err )
    end )
end
