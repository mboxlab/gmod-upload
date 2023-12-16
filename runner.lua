local function githubError( title, errorMessage )
    local format = "::error title=%s::%s"
    local message = string.format( format, title, errorMessage )

    print( message )
    error( errorMessage, 3 )
end

return function( f, title )
    local ok, result = pcall( f )
    if ok then return result end

    githubError( title, result )
end
