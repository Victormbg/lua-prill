-- utils.lua
-- Módulo utilitário com funções para conversão de HEX e manipulação de strings JSON

-- Converte uma string hexadecimal (ex: "48656C" ou "48 65 6C") para texto
local function hex_to_text(hex)
    if type(hex) ~= "string" then
        return nil, "Entrada inválida: esperado string hexadecimal."
    end

    -- Remove espaços em branco para aceitar formatos como "48 65 6C"
    hex = hex:gsub("%s+", "")

    if #hex % 2 ~= 0 then
        return nil, "A string hexadecimal deve ter um número par de caracteres."
    end

    local err = nil
    -- O gsub com pattern ".." pega de 2 em 2 caracteres de forma nativa e muito rápida
    local text = hex:gsub("..", function(cc)
        local num = tonumber(cc, 16)
        if not num then
            err = "Entrada hexadecimal inválida: '" .. cc .. "'"
            return ""
        end
        return string.char(num)
    end)

    if err then return nil, err end
    return text, nil
end

-- Tabela de mapeamento para escapar caracteres JSON em uma única passada
local escape_map = {
    ["\\"] = "\\\\",
    ["\""] = "\\\"",
    ["/"]  = "\\/",
    ["\b"] = "\\b",
    ["\f"] = "\\f",
    ["\n"] = "\\n",
    ["\r"] = "\\r",
    ["\t"] = "\\t"
}

-- Escapa caracteres especiais de uma string para uso seguro em JSON
local function json_escape(str)
    if type(str) ~= "string" then
        return nil, "Entrada inválida: esperado string para escapar."
    end

    -- Busca qualquer um dos caracteres especiais e substitui usando a tabela
    return (str:gsub('[\"\\/\b\f\n\r\t]', escape_map)), nil
end

-- Tabela de mapeamento reverso
local unescape_map = {
    ["\\\\"] = "\\",
    ["\\\""] = "\"",
    ["\\/"]  = "/",
    ["\\b"]  = "\b",
    ["\\f"]  = "\f",
    ["\\n"]  = "\n",
    ["\\r"]  = "\r",
    ["\\t"]  = "\t"
}

-- Desescapa uma string JSON para o formato original
local function json_unescape(str)
    if type(str) ~= "string" then
        return nil, "Entrada inválida: esperado string para desescapar."
    end

    -- Busca uma barra seguida de qualquer caractere e tenta substituir pela tabela
    local unescaped = str:gsub('\\.', function(match)
        return unescape_map[match] or match
    end)
    return unescaped, nil
end

-- Conta a quantidade de caracteres de uma string (suporta acentos e UTF-8)
local function count_characters(str)
    if type(str) ~= "string" then
        return nil, "Entrada inválida: esperado string."
    end

    -- Se o Lua for 5.3+ e tiver a biblioteca utf8 nativa, conta corretamente os acentos
    if utf8 and utf8.len then
        local len = utf8.len(str)
        if len then 
            return len, nil 
        end
    end

    -- Fallback caso seja um Lua mais antigo (5.1 ou 5.2) ou contenha bytes inválidos
    -- Conta quantos inícios de caracteres UTF-8 existem
    local _, count = str:gsub("[%z\1-\127\194-\244][\128-\191]*", "")
    return count, nil
end

-- Alfabeto padrão do Base64
local b64_chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

-- Converte um texto comum para Base64
local function text_to_base64(str)
    if type(str) ~= "string" then
        return nil, "Entrada inválida: esperado string."
    end
    
    local result = ((str:gsub('.', function(x) 
        local r, b = '', x:byte()
        for i = 8, 1, -1 do r = r .. (b % 2^i - b % 2^(i-1) > 0 and '1' or '0') end
        return r
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c = 0
        for i = 1, 6 do c = c + (x:sub(i,i) == '1' and 2^(6-i) or 0) end
        return b64_chars:sub(c+1, c+1)
    end)..({ '', '==', '=' })[#str%3+1])
    
    return result, nil
end

-- Converte uma string Base64 de volta para texto
local function base64_to_text(b64)
    if type(b64) ~= "string" then
        return nil, "Entrada inválida: esperado string."
    end
    
    -- Limpa qualquer caractere que não pertença ao Base64
    b64 = string.gsub(b64, '[^'..b64_chars..'=]', '')
    
    local result = (b64:gsub('.', function(x)
        if (x == '=') then return '' end
        local r, f = '', (b64_chars:find(x) - 1)
        for i = 6, 1, -1 do r = r .. (f % 2^i - f % 2^(i-1) > 0 and '1' or '0') end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c = 0
        for i = 1, 8 do c = c + (x:sub(i,i) == '1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
    
    return result, nil
end

-- Exporta as funções
return {
    hex_to_text = hex_to_text,
    json_escape = json_escape,
    json_unescape = json_unescape,
    count_characters = count_characters,
    text_to_base64 = text_to_base64,
    base64_to_text = base64_to_text
}