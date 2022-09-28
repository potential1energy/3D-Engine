local jsonformat = { _version = 0.1 }

local format

format = function(t)
    local s = ''
    local indentC = 0
    local indent = '   '
    local shouldFormat
    local instring
    for i=1, #t do

        if instring == false then
            if (string.sub(t, i, i) == "'" or '"') then
                instring = true
            end
        elseif instring == true then
            if (string.sub(t, i, i) == "'" or '"') then
                instring = false
            end
        end

        if instring == true then
            shouldFormat = false
        else
            shouldFormat = true
        end

        if shouldFormat == true then
            if string.sub(t, i, i) == '{' then
                indentC = indentC + 1
                s = s..'{'..'\n'..string.rep(indent, indentC)
            elseif string.sub(t, i, i) == '}' then
                indentC = indentC - 1
                s = s..'\n'..string.rep(indent, indentC)..'}'
            elseif string.sub(t, i, i) == '[' then
                indentC = indentC + 1
                s = s..'['..'\n'..string.rep(indent, indentC)
            elseif string.sub(t, i, i) == ']' then
                indentC = indentC - 1
                s = s..'\n'..string.rep(indent, indentC)..']'
            elseif string.sub(t, i, i) == ',' then
                s = s..','..'\n'..string.rep(indent, indentC)
            elseif string.sub(t, i, i) == ':' then
                s = s..':'..' '
            else
                s = s..string.sub(t, i, i)
            end
        else
            s = s..string.sub(t, i, i)
        end
        -- print(i, #t, '%'..(i/#t)*100, " - Procesed")
    end
    return s
end

function jsonformat.format(t)
    return format(t)
end

return jsonformat