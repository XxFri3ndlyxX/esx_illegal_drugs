description 'esx_illegal_drugs'

version '1.0.0'

server_scripts {

  '@es_extended/locale.lua',
	'locales/en.lua',
  'server/esx_illegal_drugs_sv.lua',
  'config.lua'

}

client_scripts {

  '@es_extended/locale.lua',
	'locales/en.lua',
  'config.lua',
  'client/esx_illegal_drugs_cl.lua'

}
