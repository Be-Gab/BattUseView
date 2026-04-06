-- TNS|BattUse Log Viewer|TNE
--[[#######################################################################
##  main.lua                                                             ##
##                BattUseView - main                                     ##
##                                                                       ##
## Author: BeGab                                                         ##
## Date:    2026-11-02                                                   ##
## Version: 1.0.0 RC1                                                    ## 
## URL   : https://github.com/Be-Gab/BattUseView                         ##
##                                                                       ##
##                      Copyright (C) "BeGab"                            ##
##                                                                       ##
###########################################################################
## License GNU General Public License v3.0                               ##
#########################################################################]]

-- /(.:BULogView.|.:BULogView.^f_stat|filerw|error^f_stat|warning|^f_stat|-(E|W)-)/i

local app	= {}
		app.ver			= "1.0.0 RC1"
		app.shortname	= "BULogView"
		app.name			= "BattUse Log Viewer"
		app.appFolder	= "/WIDGETS/BattUse/"
		app.otsFolder	= "/SCRIPTS/TOOLS/BattUseView/"		-- One-Time-Script Path


print( "Loading " .. app.name .. " ver: " .. app.ver )

app.prg	=	loadScript( app.otsFolder .. "app.lua" , "tbd" )( app )


return { init		=	app.prg.init , 
			run		=	app.prg.run , 
			useLvgl	=	true }
