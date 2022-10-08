fx_version 'adamant'

game 'gta5'

lua54 'yes'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

client_scripts {
    'client/*.lua',
}

shared_scripts {
    '@es_extended/imports.lua',
    'shared/config.lua',
}

ui_page 'web/dist/index.html'
--ui_page 'http://localhost:3000/'

files {
    'web/dist/**'
}
