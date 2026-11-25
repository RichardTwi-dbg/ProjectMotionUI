local prefix = "[PMUI] "

function PLog(text, type)
    if not type then
        type = "normal"
    end
    
    if type == "normal" then
        print(prefix .. "info: " .. tostring(text))
    elseif type == "error" then
        print(prefix .. "error: " .. tostring(text))
    end
end