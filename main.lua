-- main.lua
-- Importa o módulo de utilitários
local utils = require("utils")

-- Limpa a tela dependendo do sistema operacional
local function clear_screen()
    if package.config:sub(1,1) == '\\' then
        os.execute("cls")
    else
        os.execute("clear")
    end
end

-- Lê a entrada do usuário com segurança (trata EOF/Ctrl+C)
local function safe_read()
    local input = io.read()
    if not input then
        print("\nEntrada interrompida. Saindo...")
        os.exit(0)
    end
    return input
end

-- Exibe o menu principal e lê a escolha do usuário
local function show_menu()
    print("\n==== MENU ====")
    print("1. Converter HEX para texto")
    print("2. Escapar string para JSON")
    print("3. Desescapar string JSON")
    print("4. Contar caracteres")
    print("5. Converter texto para Base64")
    print("6. Converter Base64 para texto")
    print("0. Sair")
    io.write("Escolha uma opção: ")
    io.flush() -- Garante que o texto seja impresso antes de pausar para ler
    return safe_read()
end

-- Pausa o programa até que o usuário pressione Enter e depois limpa a tela
local function pause_and_clear()
    print("\nPressione Enter para continuar...")
    io.read() 
    clear_screen()
end

-- Lê múltiplas linhas até o usuário dar enter numa linha vazia
local function read_multiline()
    local lines = {}
    while true do
        local line = safe_read()
        if line == "" then break end
        table.insert(lines, line)
    end
    return table.concat(lines, "\n")
end

-- Função principal que executa o loop do menu
local function main()
    while true do
        clear_screen()
        local choice = show_menu()

        if choice == "1" then
            clear_screen()
            io.write("Digite o valor HEX: ")
            io.flush()
            local hex = safe_read()
            local result, err = utils.hex_to_text(hex)
            
            if result then
                print("\nTexto convertido: \n" .. result)
            else
                print("\nErro: " .. err)
            end
            pause_and_clear()

        elseif choice == "2" then
            clear_screen()
            print("Cole o conteúdo JSON (digite uma linha vazia para terminar):")
            local input = read_multiline()
            local escaped, err = utils.json_escape(input)
            
            if escaped then
                print("\nEscapado para JSON:\n" .. escaped)
            else
                print("\nErro: " .. err)
            end
            pause_and_clear()

        elseif choice == "3" then
            clear_screen()
            io.write("Digite a string JSON escapada: ")
            io.flush()
            local input = safe_read()
            local unescaped, err = utils.json_unescape(input)
            
            if unescaped then
                print("\nDesescapado: \n" .. unescaped)
            else
                print("\nErro: " .. err)
            end
            pause_and_clear()
        elseif choice == "4" then
            clear_screen()
            io.write("Digite o texto para contar os caracteres: ")
            io.flush()
            local input = safe_read()
            local count, err = utils.count_characters(input)
            
            if count then
                print("\nO texto digitado possui " .. count .. " caractere(s).")
            else
                print("\nErro: " .. err)
            end
            pause_and_clear()
        elseif choice == "5" then
            clear_screen()
            io.write("Digite o texto para converter em Base64: ")
            io.flush()
            local input = safe_read()
            local b64, err = utils.text_to_base64(input)
            
            if b64 then
                print("\nBase64 gerado: \n" .. b64)
            else
                print("\nErro: " .. err)
            end
            pause_and_clear()

        elseif choice == "6" then
            clear_screen()
            io.write("Digite a string Base64: ")
            io.flush()
            local input = safe_read()
            local texto, err = utils.base64_to_text(input)
            
            if texto then
                print("\nTexto decodificado: \n" .. texto)
            else
                print("\nErro: " .. err)
            end
            pause_and_clear()
        elseif choice == "0" then
            clear_screen()
            print("Saindo do programa.")
            break
        else
            clear_screen()
            print("Opção inválida. Tente novamente.")
            pause_and_clear()
        end
    end
end

-- Inicia o programa
main()