fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description "Simle PSR-Core Admin Menu & Dev Tools Using PSR-Menu & PSR-Input || Thrasherrr#9224"
version '1.1.0'

shared_scripts {
	-- '@psr-core/shared/locale.lua',
	-- 'locales/en.lua',
  'config.lua'
}

client_scripts {
  'client/*.lua',
}

server_script 'server/*.lua'

dependencies {
	'psr-menu',
	'psr-input'
}
