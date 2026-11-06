--[[#######################################################################
##  app.lua                                                              ##
##                BattUseView - app                                      ##
##                                                                       ##
## Author: BeGab                                                         ##
##                                                                       ##
## URL   : https://github.com/Be-Gab/BattUseView                         ##
##                                                                       ##
##                      Copyright (C) "BeGab"                            ##
##                                                                       ##
###########################################################################
## License GNU General Public License v3.0                               ##
#########################################################################]] 
local app = ...
local A = {}

-- NOTE: syncronise definition in BattUse/loadable.lua 
local LOG_PATHS		=	{	[1]	=	"/LOGS/" ,
									[2]	=	app.appFolder .. "LOGS/" }

app.STATE = {}
	app.STATE.INIT						=	1		-- Check BattUse is installed; Search *.cfg files


	app.STATE.PROCESS_LOG_MONTHSLIST_VIEW			= 101		-- Napok kiválasztása
	app.STATE.PROCESS_LOG_MONTHSLIST_VIEW_WAIT	= 102
	
	app.STATE.PROCESS_LOG_LINE_VIEW					= 103		
	app.STATE.PROCESS_LOG_LINE_VIEW_WAIT			= 104
	
	app.STATE.PROCESS_LOG_DAY_VIEW					= 105		-- Egy nap repülései "és egy repülés részletesen(??)"
	app.STATE.PROCESS_LOG_DAY_VIEW_WAIT				= 106


	app.STATE.ASK_MODEL_FORM		=	2
	app.STATE.ASK_MODEL_FORM_WAIT	=	3

	app.STATE.PROCESS_LOG_PERIOD_WAIT_FORM			= 10	-- Show "Collecting Data..." 
	app.STATE.PROCESS_LOG_PERIOD_COLLECT_LOGS		= 11
	app.STATE.PROCESS_LOG_PERIOD_AGGREGATE			= 12
	
	app.STATE.PROCESS_LOG_PERIOD_VIEW_DATA						= 13
	app.STATE.PROCESS_LOG_PERIOD_VIEW_DATA_WAIT				= 14
	app.STATE.PROCESS_LOG_PERIOD_VIEW_BATDATA					= 15
	app.STATE.PROCESS_LOG_PERIOD_VIEW_BATDATA_WAIT			= 16
	app.STATE.PROCESS_LOG_PERIOD_VIEW_BATDETAILDATA			= 17
	app.STATE.PROCESS_LOG_PERIOD_VIEW_BATDETAILDATA_WAIT	= 18
	
	
	app.STATE.PROCESS_LOG_PERIOD_COLLECT_LOGDATA_WAIT		= 19
	app.STATE.PROCESS_LOG_PERIOD_COLLECT_LOGDATA				= 20
	app.STATE.PROCESS_LOG_PERIOD_VIEW_LOGDATA					= 21
	app.STATE.PROCESS_LOG_PERIOD_VIEW_LOGDATA_WAIT			= 22

	app.STATE.PROCESS_LOG_PERIOD_VIEW_LOGLINE					= 23
	app.STATE.PROCESS_LOG_PERIOD_VIEW_LOGLINE_WAIT			= 24
	
	app.STATE.PROCESS_BATTERY_LIST_VIEW							= 40
	app.STATE.PROCESS_BATTERY_LIST_VIEW_WAIT					= 41

	app.STATE.PROCESS_BATTERY_ADD									= 42
	app.STATE.PROCESS_BATTERY_ADD_WAIT							= 43
	app.STATE.PROCESS_BATTERY_EDIT								= 44
	app.STATE.PROCESS_BATTERY_EDIT_WAIT							= 45
	app.STATE.PROCESS_BATTERY_ASSIGN								= 46
	app.STATE.PROCESS_BATTERY_ASSIGN_WAIT						= 47
	app.STATE.PROCESS_BATTERY_RETIRE								= 48
	app.STATE.PROCESS_BATTERY_RETIRE_WAIT						= 49


	app.STATE.ERROR_NO_MODEL	= 60
	app.STATE.ERROR_NO_BATTUSE	= 61
	app.STATE.ERROR_NO_BATFILES= 62

	app.STATE.QUIT	= 99

app.state = app.STATE.INIT

--====================================
	-- TODO: just for debug
	-- app.state_lastState = 0
	-- app.state_Name = {}
	-- for key , value in pairs( app.STATE ) do
		-- app.state_Name[value]	=	key
	-- end

--====================================
app.selectedCfgModel_Name		= ""
app.selectedFromPeriod	= 0
app.selectedToPeriod		= 0
app.selectedBattery = ""
app.selectedLogFile_ID = 0
app.selectedLogLine_ID = 0

app.modelList	= {}

app.editedBatId	=	nil

-------------------------
app.STATE_FILTER	= {}
app.STATE_FILTER.ALL			=	1
app.STATE_FILTER.INUSE		=	2
app.STATE_FILTER.RETIRED	=	3

app.batFilter		= {}
app.batFilter.cell	= 0		-- = All
app.batFilter.state	= app.STATE_FILTER.INUSE

--====================================
app.cfg	=	{}
app.cfg.logPath	= "" 
app.cfg.dateFormatID = 3

--====================================
app.logFiles	=	{}							--	[1] = model all logFileNames
app.logDates	=	{}							-- [1] =	{	"YYYYMM" , "DD" }, by logFileNames
app.logSelected_logDatesIDX	=	0		-- id of app.logDates

--====================================

local	SWIPE_NONE	=	0	
local	SWIPE_LEFT	=	1
local	SWIPE_RIGHT	=	2

-- ================= Stat ===========

app.stat	= {}
app.stat.from_y	=	0
app.stat.from_m	=	0
app.stat.from_d	=	0

app.stat.to_y		=	0
app.stat.to_m		=	0
app.stat.to_d		=	0

app.stat.logList	=	{}						-- log files for Stat, aggregate 
app.stat.logData	=	{}						--	data lines from log files

-- ==================================

local cfgFiles = ""

local modelLogList		= {}

local logAggregated		= {}
-- local logMonthData		= {}

local periodMonthsList	= {}
local selectedFromPeriod= 1
local selectedToPeriod	= 1
local procModelLogList	= {}

local radioType = ""

local function getModelsTable()
    local models = {}

    for fname in dir("/MODELS") do
        -- Csak a modelXX.yml fájlokat vesszük
        local num = string.match( fname , "^model(%d+)%.yml$" )
        if num then
            local id = tonumber(num)
            local modelName = fname          -- fallback a fájlnévre

            -- Megpróbáljuk kiolvasni a valódi nevet a YAML-ból
            local f = io.open("/MODELS/" .. fname, "r")
            if f then
                while true do
                    local line = io.read(f, 120)
                    if not line or #line == 0 then break end

                    -- Keresés: name: "Valami név"  vagy  name: Valami név
                    local found = string.match( line , 'name:%s*"?([^"\r\n]+)"?' )
                    if found then
                        modelName = string.match( found , "^%s*(.-)%s*$" )  -- trim
                        break
                    end
                end
                io.close(f)
            end

            models[id] = modelName
        end
    end

    return models
end

local function isFileExist(fileName)
    if type(fileName) ~= "string" or fileName == "" then
        return false
    end

    local fileName = io.open(fileName, "r")  
    if fileName then
        io.close(fileName)
        return true
    end
    return false
end

local function time2Sec( t )
	return ( tonumber( string.sub( t, 1, 2 ) ) * 60 ) + tonumber( string.sub( t, 4, 5 ) )
end

function sec2Time(seconds, with_hours)
    seconds = math.floor(seconds)
	 
	 -- app.d.log( "seconds" ,seconds  , "sec2Time()" )
		  
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60

    if with_hours then
        return string.format("%02d:%02d:%02d", h, m, s)
    else
        local total_minutes = math.floor(seconds / 60)
		  -- app.d.log( "total_minutes" ,total_minutes  , "sec2Time()" )
        return string.format("%02d:%02d", total_minutes, s)
    end
end

local function getDateFormatYMD( yr, mh ,dy ) -- d optional
	local	df = app.cfg.dateFormatID 

	dy = dy or ""
	if dy == "" then
		df = df + 10
	end



	if df == 1 then
		--	MM/DD/YYYY 
		f = string.format( "%02d/%02d/%04d" , mh , dy, yr   )

	elseif df == 2 then
		-- DD.MM.YYYY 
		f = string.format( "%02d.%02d.%04d"  , dy , mh, yr )
		
	elseif df == 3 then
		-- YYYY/MM/DD 
		f = string.format( "%04d/%02d/%02d" , yr	, mh , dy 	 )

	elseif df == 4 then
		-- YYYY.MM.DD. 
		f = string.format( "%04d.%02d.%02d." , yr	, mh , dy 	 )


	--=========== WO Day
	
	elseif df == 11 then
		--	MM/YYYY 
		f = string.format( "%02d/%04d" , mh , yr   )

	elseif df == 12 then
		-- MM.YYYY 
		f = string.format( "%02d.%04d"  , mh, yr )
		
	elseif df == 13 then
		-- YYYY/MM
		f = string.format( "%04d/%02d" , yr	, mh  )

	elseif df == 14 then
		-- YYYY.MM.
		f = string.format( "%04d.%02d." , yr , mh 	 )
	
	else
		f = df .. ":DateFormat missing"
	end

end

local function getDateTimeStr( s , without_sec )
	local dt = {}
	local	df = app.cfg.dateFormatID 
	
	if s == "" or not s then
		return "BadFormat"
	end
	
	without_sec = without_sec or false
	
	if without_sec then
		df = df + 10
	end
	
	dt.year	= tonumber( string.sub( s, 1, 4 ) )
	dt.month = tonumber( string.sub( s, 5, 6 ) )		
	dt.day	= tonumber( string.sub( s, 7, 8 ) )
	dt.hour	= tonumber( string.sub( s, 9,10 ) )
	dt.min	= tonumber( string.sub( s,11,12 ) )
	dt.sec	= tonumber( string.sub( s,13,14 ) )


	if df == 1 then
		--	MM/DD/YYYY HH:MM:SS
		f = string.format( "%02d/%02d/%04d %02d:%02d:%02d" ,  dt.month , dt.day , dt.year , dt.hour	, dt.min	, dt.sec	 )

	elseif df == 2 then
		-- DD.MM.YYYY HH:MM:SS
		f = string.format( "%02d.%02d.%04d %02d:%02d:%02d"  , dt.day , dt.month, dt.year , dt.hour	, dt.min	, dt.sec	 )
		
	elseif df == 3 then
		-- YYYY/MM/DD HH:MM:SS
		f = string.format( "%04d/%02d/%02d %02d:%02d:%02d" , dt.year	, dt.month , dt.day , dt.hour	, dt.min	, dt.sec	 )

	elseif df == 4 then
		-- YYYY.MM.DD. HH:MM:SS
		f = string.format( "%04d.%02d.%02d. %02d:%02d:%02d" , dt.year	, dt.month , dt.day , dt.hour	, dt.min	, dt.sec	 )
	
	-- Without SEC:
		
	elseif df == 11 then
		--	MM/DD/YYYY HH:MM:SS
		f = string.format( "%02d/%02d/%04d %02d:%02d" ,  dt.month , dt.day , dt.year , dt.hour	, dt.min	 )

	elseif df == 12 then
		-- DD.MM.YYYY HH:MM:SS
		f = string.format( "%02d.%02d.%04d %02d:%02d"  , dt.day , dt.month, dt.year , dt.hour	, dt.min	 )
		
	elseif df == 13 then
		-- YYYY/MM/DD HH:MM:SS
		f = string.format( "%04d/%02d/%02d %02d:%02d" , dt.year	, dt.month , dt.day , dt.hour	, dt.min	 )

	elseif df == 14 then
		-- YYYY.MM.DD. HH:MM:SS
		f = string.format( "%04d.%02d.%02d. %02d:%02d" , dt.year	, dt.month , dt.day , dt.hour	, dt.min	 )
	else
		f = df .. ":DateFormat missing"
	end
	
	return f
end
  
local function getFilesByExtension(path, extension)
    if type(path) ~= "string" or path == "" then
        return {}
    end

    local result = {}
	 local extLen = -1 * #extension

    for fname in dir(path) do
			-- app.d.log( "fname" , fname , "getFilesByExtension()" )
		  if string.sub( fname, extLen ) == extension then
            table.insert(result, fname)
        end
    end
	 
	 -- app.d.printAssoc( "getFilesByExtension() :: result" ,  result )

    return result
end 

local function openBatteryFile()
	-- id,maxCapacity,product,cells,maxVolt,earlyCount,count,firstStartDate,retireDate,lastStartDate,capacity
	-- "H12345",4900,"HRB uj",12,4.2,100,1,"20190909000000","20260901222759","20260502164024",4800
	
	batFile  =	loadScript( app.appFolder .. "csvfile.lua")()
	
	--  1=Numeric , 2=String
	batFile.setFieldDataType( 1, 2 )			-- id
	batFile.setFieldDataType( 2, 1 )			-- maxCapacity
	batFile.setFieldDataType( 3, 2 )			-- product
	batFile.setFieldDataType( 4, 1 )			-- cells
	batFile.setFieldDataType( 5, 1 )			-- maxVolt
	batFile.setFieldDataType( 6, 1 )			-- earlyCount
	batFile.setFieldDataType( 7, 1 )			-- count
	batFile.setFieldDataType( 8, 2 )			-- firstStartDate
	batFile.setFieldDataType( 9, 2 )			-- retireDate
	batFile.setFieldDataType(10, 2 )			-- lastStartDate
	batFile.setFieldDataType(11, 1 )			-- capacity
		
	return batFile 
end

-- Az összes modelban kersem a sajat model cfg állományokat, hogy a törölt modelekhez tartozókat kihagyhassam.
local function modelsNamesForCfgFiles( aCfgFiles, aAllModel )	 
	local cfgModels	= {}, id
	
	-- app.d.printAssoc( "modelsNamesForCfgFiles() - aAllModel" , aAllModel )
	-- app.d.printAssoc( "modelsNamesForCfgFiles() - aCfgFiles" , aCfgFiles )
	
	for k , cfgFileName in ipairs( cfgFiles ) do
	
		for key , mName in pairs( aAllModel ) do
		
			if ( mName .. ".cfg" )  == cfgFileName then
				cfgModels[ #cfgModels +1 ] =	
										{	["name"]		= mName	,
											["cfgFile"]	= cfgFileName
										}	
				break
			end
		end
		
	end

	-- app.d.printAssoc( "modelsNamesForCfgFiles() - Return" , cfgModels )

	return cfgModels
end

-- read LOG path, dateformat from model config file, Return read is success, set global variables
local function readModelConfigFile( modelName )
	local modelConfigFile = string.format( "%smodels/%s.cfg"   , app.appFolder , modelName )
	local cfgFound = false
	local cfgFile  = loadScript(  app.appFolder .. "csvfile.lua" )()
	local data = {}
	
	-- app.d.log( "fileName" , modelConfigFile , "readModelConfigFile()" )

	app.cfg.logPath	=  "/"
	app.cfg.dateFormatID = 1

	if isFileExist( modelConfigFile ) then

		cfgFile.readCsv( modelConfigFile  )
		data			= cfgFile.getRow( 1 )
	
		app.cfg.logPath	=  LOG_PATHS[ data.logPath ]
		app.cfg.dateFormatID = data.dtFormat
		
		cfgFound	=	true

	end

	-- app.d.log( "app.cfg.logPath" , app.cfg.logPath , "readModelConfigFile()" )
	-- app.d.log( "app.cfg.dateFormatID" , app.cfg.dateFormatID , "readModelConfigFile()" )

	return cfgFound
		
end

local function collectModelLogFiles( logDir , modelName )
	local y, m, d, logDates	
	-- app.d.log( "logDir" , logDir , "collectModelLogFiles()" )
	-- app.d.log( "modelName" , modelName , "collectModelLogFiles()" )

	if type(logDir) ~= "string" or logDir == "" then
		return
	end

	-- app.logFiles	=	{}		--	[1] = FileName
	-- app.logDates	=	{}		-- [1] =	{	y = "YYYY" , m = "MM" , d = "DD" }

	app.logFiles = {}
	app.logDates = {}
	---------------------------------------
	
	for fname in dir( logDir ) do

		-- app.d.log( "fname=modelname" , string.sub( fname, 17 , -5 ) , "collectModelLogFiles()" )
		-- example log name: FlyLog_20260314_TRex 700X.csv
		
		if string.sub( fname, -4 )			== ".csv" and
			string.sub( fname,  1 ,  7 )	== "FlyLog_" and
			string.sub( fname, 17 , -5 )	== modelName then
				
			-- app.d.log( "fname Added" , fname , "collectModelLogFiles()" )
			app.logFiles[ #app.logFiles + 1 ]	= fname 
				
		end
		
	end	
	
	-- ÉVHÓ csökkenő, nap növekvő
	table.sort(	app.logFiles , 
					function(a, b)
						function getDate(fname)
							local y	=	tonumber ( string.sub( fname,   8 ,  11 ) ) 
							local	m	=	tonumber ( string.sub( fname,  12 ,  13 ) )
							local	d	=	tonumber ( string.sub( fname,  14 ,  15 ) )
							return y,m,d
						end

						 local ay, am, ad = getDate(a)
						 local by, bm, bd = getDate(b)
						 
						 if ay ~= by then		-- Year Desc
							  return ay > by
						 end
						 
						 if am ~= bm then		-- Month Desc
							  return am > bm
						 end
						 
						 return ad < bd		-- Day ASC
					end				 
				 )
	-- -------------------------------------

	for k, fname in pairs( app.logFiles ) do

		app.logDates[ #app.logDates + 1 ]	=	{	["y"]	=	tonumber ( string.sub( fname,   8 ,  11 ) ) ,
																["m"]	=	tonumber ( string.sub( fname,  12 ,  13 ) ) ,
																["d"]	=	tonumber ( string.sub( fname,  14 ,  15 ) )
															}

	end
	
	-- app.d.log( "#app.logDates : " , #app.logDates , "collectModelLogFiles()" )
	-- app.d.log( "#app.logFiles : " , #app.logFiles , "collectModelLogFiles()" )
	-- app.d.printAssoc( "collectModelLogFiles() : app.logDates" , app.logDates )
		
	return app.logFiles

end


-- app.stat.from_y	= 0
-- app.stat.from_m	= 0
-- app.stat.from_d	= 0

-- app.stat.to_y		= 0
-- app.stat.to_m		= 0
-- app.stat.to_d		= 0
local function collectLogFiles()
	local collectedLogs = {}
	local fromDate, toDate 
	
	fromDate	= string.format( "%04d%02d%02d" , app.stat.from_y , app.stat.from_m, app.stat.from_d )
	toDate	= string.format( "%04d%02d%02d" , app.stat.to_y , app.stat.to_m, app.stat.to_d )
	
	-- app.d.log( "fromDate" , fromDate , "collectLogFiles()" )
	-- app.d.log( "toDate" , toDate , "collectLogFiles()" )
	-- app.d.log( "#app.logFiles" , #app.logFiles , "collectLogFiles()" )
	
	for id , fileName in pairs( app.logFiles ) do

		fileDate	=	string.sub( fileName,   8 , 15 )
	
		if fileDate >= fromDate and fileDate <= toDate then
			-- app.d.log( "ADD fileName" , fileName , "collectLogFiles()" )	
			table.insert( collectedLogs , app.logFiles[ id ] )
		end
	end


	-- app.d.log( "#collectedLogss" , #collectedLogs , "collectLogFiles()" )

	return collectedLogs
end

-- ====================================================================================================================

local function showErrorMessage( s )

	dispErrorMsg(  s )

	app.state = app.STATE.ASK_MODEL_FORM_WAIT

	return 0
end

local function state_INIT()
	local _ , radioType = getVersion()
	
	if string.sub( radioType, -5 ) == "-simu" then
		radioType = string.sub( radioType, 1, -6 )
	end
	
	local dispFile = app.otsFolder .. "disp" .. radioType .. ".lua"

	if not isFileExist( dispFile ) then
		dispFile = app.otsFolder .. "disptx16s.lua"
	end
	
	loadScript(  dispFile  , "tbd" )( app )
	
	-- -----------------------------------------------------------------------
	
	if not isFileExist( app.appFolder .. "csvfile.lua" ) or
		not isFileExist( app.appFolder .. "d.lua" ) or
		not isFileExist( app.appFolder .. "cbm.lua" ) or
		not isFileExist( app.appFolder .. "main.lua" ) or
		-- TODO : Csak a hibaüzenet tesztelésére
		-- not isFileExist( app.appFolder .. "main-error-test.lua" ) or		
		not isFileExist( app.appFolder .. "fd.lua" ) then
	
		app.state	=	app.STATE.ERROR_NO_BATTUSE
		
	elseif 
		not isFileExist( app.appFolder .. "batfiles/batteries.csv" ) or
		not isFileExist( app.appFolder .. "batfiles/batmodel.csv" ) then
	
		app.state	=	app.STATE.ERROR_NO_BATFILES
		
	else	
	
	
		app.d	=	loadScript( app.appFolder .. "d.lua"   , "tbd" )( app.shortname )
		-- app.dt=	loadScript( app.appFolder .. "dt.lua"  , "tbd" )( app )

		-- TODO : Set AppLog file.
		-- app.d.setLogFile( "BUV" )
		-- app.d.log( "setLogFile()" ,  "BUV ..." , "state_INIT()" )
		
		-- -----------------------------------------------------------------------
		app.cbm = loadScript( app.appFolder .. "cbm.lua"   , "tbd" )( app )
		
		app.cbm.load(	app.appFolder .. "/csvfile.lua" , 
							app.appFolder .. "/batfiles/" .. "batmodel.csv" )
		
		
		-- app.cbm.test()
		

		app.modelList = getModelsTable()		-- All model on the radio
		app.d.printAssoc( "state_INIT() :: getModelsTable() ->" ,  app.modelList )


		-- Search Model name for all models\*.cfg
		cfgFiles = getFilesByExtension( app.appFolder .. "/models" , ".cfg")
		app.aCfgModels	= modelsNamesForCfgFiles( cfgFiles, app.modelList )	 

		app.d.printAssoc( "state_INIT() :: cfgFiles" , cfgFiles )
		app.d.printAssoc( "state_INIT() :: app.aCfgModels" , app.aCfgModels )

		local currentModel		= model.getInfo()
		local currentModelName	= currentModel.name		
		
		if readModelConfigFile( currentModelName  )then
		
			app.selectedCfgModel_Name	= currentModelName
		
		else
			
			app.d.log( "Model have not cfg file: " 	,  currentModel.name 	, "state_INIT()" )
		

			currentModelName	= app.aCfgModels[1].name
			currentModelID		= tonumber( string.match( cfgFiles[1] , "^model(%d+)%.cfg$" ) )
			
			app.selectedCfgModel_ID	= currentModelID
			
			-- No one model use BattUse Widget => Stop.
			app.state = app.STATE.ERROR_NO_MODEL
			return 0
			
		end


		-- app.d.log( "currentModelID" 	,  currentModelID 	, "state_INIT()" )
		-- app.d.log( "currentModelName" ,  currentModelName	, "state_INIT()" )
		
		-- app.d.printAssoc( "state_INIT() : cfgFiles" , cfgFiles )		
		
		
		
		app.d.printAssoc( "state_INIT() : app.aCfgModels" ,  app.aCfgModels )
		
		app.state = app.STATE.PROCESS_LOG_MONTHSLIST_VIEW	
	end

	
	return 0
	
end 

local function state_ASK_MODEL_FORM()

	-- app.d.log( "state_ASK_MODEL_FORM() :: " , "s t ar t" , "state_ASK_MODEL_FORM()" )
	
	if #app.aCfgModels == 0 then
		app.state = app.STATE.ERROR_NO_MODEL
		return 0
	end

	readModelConfigFile( app.selectedCfgModel_Name )
	collectModelLogFiles( app.cfg.logPath , app.selectedCfgModel_Name )
	
	-- Set Date From To defaults
	if #app.logDates > 0 then

		-- app.d.log( "#app.logFiles" , "Van log files." , "state_ASK_MODEL_FORM()" )

		if app.stat.from_y == 0 then
			app.stat.from_y	= app.logDates[#app.logDates].y;
			app.stat.from_m	= app.logDates[#app.logDates].m;
			app.stat.from_d	= 1;
		end

		if app.stat.to_y == 0 then
			app.stat.to_y	= app.logDates[1].y;
			app.stat.to_m	= app.logDates[1].m;
			app.stat.to_d	= 1;
		end
		
	end

	dispAskModelAndPeriod( modelLogList, app.aCfgModels )
	
	app.state = app.STATE.ASK_MODEL_FORM_WAIT

	return 0
end
 
local function state_ASK_MODEL_FORM_WAIT()
	return 0
end

-- #############################################################

local function state_PROCESS_LOG_PERIOD_WAIT_FORM()

	dispWaitForm ( "Collecting Data ... " )

	app.state = app.STATE.PROCESS_LOG_PERIOD_COLLECT_LOGS

	return 0
end

local function state_PROCESS_LOG_PERIOD_COLLECT_LOGS()

	app.stat.logList = collectLogFiles()
	
	app.state = app.STATE.PROCESS_LOG_PERIOD_AGGREGATE
	
	return 0
end

local function state_PROCESS_LOG_PERIOD_AGGREGATE()
	local startFlyDT, sec
	
	logAggregated = {}

		-- flyCount : count
		--	countWithMah:
		-- countWithMaxAmp:
		-- mAh 		: Összes: mAhSum,  átlagos: mAhAvg,   legtöbb: mAhMax  , mikor legtöbb: mAhMaxDate
		-- flyTime	: Összes: timeSum, átlagos: timeAvg , legtöbb: timeMax , mikor legtöbb: timeMaxDate
		-- maxAmp	: legkevesebb: ampMin , legtöbb: ampMax , legtöbb mikor: ampMaxDate , átlag : ampAvg, ampCount
		
	logAggregated.count = 0	-- rekordok száma
	-- mAh
	logAggregated.countWithMah = 0
	logAggregated.mAhSum = 0
	logAggregated.mAhAvg = 0
	logAggregated.mAhMax = 0
	logAggregated.mAhMaxDate = ""
	-- flyTime, in sec
	logAggregated.countFly = 0
	logAggregated.timeSumSec = 0				-- össz idő másodpercben
	logAggregated.timeSum = 0					-- legvégén másodpercből ÓÓ:PP:SS
	logAggregated.timeAvg = 0
	logAggregated.timeMax = 0
	logAggregated.timeMaxDate = ""
	-- maxAmp
	logAggregated.countWithMaxAmp = 0		-- ez kell az átlaghoz
	logAggregated.ampMin = 99999
	logAggregated.ampMax = 0
	logAggregated.ampMaxDate = ""
	logAggregated.ampAvg = 0
	logAggregated.ampSum = 0
	
	--logAggregated.ampCount = 0					-- de ez minek?
	
	-- Calculated on the end
	logAggregated.maxBatteryFlyCount = 0
	logAggregated.batteryCount = 0

	logAggregated.Batteries = {}		-- Count, SummAh, mAhCount, SumTime, AvgTime, AvgmAh
	
	-- ============================================================
	
	logFile = loadScript( app.appFolder .. "csvfile.lua" )()
		
	for c = 1 , #app.stat.logList do
	
		-- app.d.log( "app.stat.logList[ c ] " ,app.stat.logList[ c ]  , "state_PROCESS_LOG_PERIOD_AGGREGATE()" )
	
		logData = logFile.readCsv( app.cfg.logPath .. app.stat.logList[ c ] )
		
	-- maxAmp => 384
	-- mAmpFly => 1061
	-- flyTime => 00:03
	-- startCount => 248
	-- endFly => 20260312143939
	-- startBatPercent => 0
	-- batteryID => A12345
	-- batteryProduct => HRB1234567
	-- endBatPercent => 0
	-- endBatVolt => 0.0
	-- startBatVolt => 0.0
	-- startFly => 20260312143935
		
		for logC = 1 , #logData do

			logLine = logData[ logC ]
				
			if logLine.flyTime ~= "00:00" then			

				sec = time2Sec( logLine.flyTime )
				startFlyDT = getDateTimeStr( logLine.startFly, true ) 
			
				-- app.d.printAssoc( "logLine" , logLine )
				
				if logLine.batteryID == "" then
					batID = "N/A"
				else
					batID = logLine.batteryID
				end
			
				if not logAggregated.Batteries[ batID ] then
				
					-- New Battery in the list
				
					logAggregated.Batteries[ batID ] = {}
					
					logAggregated.Batteries[ batID ].count = 0
					logAggregated.Batteries[ batID ].countFly = 0
					logAggregated.Batteries[ batID ].countWithMah = 0
					logAggregated.Batteries[ batID ].countWithMaxAmp = 0
					logAggregated.Batteries[ batID ].timeSumSec = 0
					logAggregated.Batteries[ batID ].maxBatteryFlyCount = 0
					-- mAh
					logAggregated.Batteries[ batID ].mAhSum = 0
					logAggregated.Batteries[ batID ].mAhAvg = 0
					logAggregated.Batteries[ batID ].mAhMax = 0
					logAggregated.Batteries[ batID ].mAhMaxDate = ""
					-- flyTime, in sec
					logAggregated.Batteries[ batID ].timeSum = 0
					logAggregated.Batteries[ batID ].timeAvg = 0
					logAggregated.Batteries[ batID ].timeMax = 0
					logAggregated.Batteries[ batID ].timeMaxDate = ""
					-- maxAmp
					logAggregated.Batteries[ batID ].ampMin = 99999
					logAggregated.Batteries[ batID ].ampMax = 0
					logAggregated.Batteries[ batID ].ampMaxDate = ""
					logAggregated.Batteries[ batID ].ampAvg = 0
					logAggregated.Batteries[ batID ].ampSum = 0

					
				end

			
				-- flyTime, in sec
					-- logAggregated.countFly = 0
					-- logAggregated.timeSumSec = 0
					-- logAggregated.timeMax = 0
					-- logAggregated.timeMaxDate = ""

				-- if logLine.endFly > "" then

				logAggregated.count = logAggregated.count + 1 		-- records
				logAggregated.Batteries[ batID ].count 	= logAggregated.Batteries[ batID ].count +1
		
				logAggregated.countFly = logAggregated.countFly + 1
				logAggregated.timeSumSec  = logAggregated.timeSumSec + sec
				
				if sec > logAggregated.timeMax then
					logAggregated.timeMax = sec
					logAggregated.timeMaxDate = startFlyDT
				end
				
				-- Bat

				logAggregated.Batteries[ batID ].countFly = logAggregated.Batteries[ batID ].countFly + 1
				logAggregated.Batteries[ batID ].timeSumSec  = logAggregated.Batteries[ batID ].timeSumSec + sec
				
				if sec > logAggregated.Batteries[ batID ].timeMax then
					logAggregated.Batteries[ batID ].timeMax = sec
					logAggregated.Batteries[ batID ].timeMaxDate = startFlyDT
				end

				-- mAmp Fly  
					-- logAggregated.countWithMah = 0
					-- logAggregated.mAhSum = 0
					-- logAggregated.mAhMax = 0
					-- logAggregated.mAhMaxDate = ""
				if logLine.mAmpFly  > 0 then
				
					logAggregated.mAhSum = 	logAggregated.mAhSum + logLine.mAmpFly
					logAggregated.countWithMah	= logAggregated.countWithMah + 1
					
					if logAggregated.mAhMax < logLine.mAmpFly then
						logAggregated.mAhMax = logLine.mAmpFly
						logAggregated.mAhMaxDate = startFlyDT
					end
					
					-- bat
					logAggregated.Batteries[ batID ].mAhSum	= logAggregated.Batteries[ batID ].mAhSum + logLine.mAmpFly
					logAggregated.Batteries[ batID ].countWithMah	= logAggregated.Batteries[ batID ].countWithMah + 1
					
					if logAggregated.Batteries[ batID ].mAhMax < logLine.mAmpFly then
						logAggregated.Batteries[ batID ].mAhMax = logLine.mAmpFly
						logAggregated.Batteries[ batID ].mAhMaxDate = startFlyDT
					end

				end	

			-- maxAmp
				-- logAggregated.countWithMaxAmp = 0	
				-- logAggregated.ampMin = 0
				-- logAggregated.ampMax = 0
				-- logAggregated.ampMaxDate = ""
				
				
				-- app.d.log( "logLine.maxAmp " ,logLine.maxAmp  , "state_PROCESS_LOG_PERIOD_AGGREGATE()" )
				-- Ha itt szar van ellenőrizd hogy a log file sorvég jele Unixos LF!
				
				if logLine.maxAmp > 0 then
				
					logAggregated.countWithMaxAmp = logAggregated.countWithMaxAmp + 1
					logAggregated.ampSum = logAggregated.ampSum + logLine.maxAmp
				
					if logAggregated.ampMin > logLine.maxAmp then
						logAggregated.ampMin = logLine.maxAmp
					end

					if logAggregated.ampMax < logLine.maxAmp then
						logAggregated.ampMax = logLine.maxAmp
						logAggregated.ampMaxDate = startFlyDT
					end
					
					-- bat
					logAggregated.Batteries[ batID ].countWithMaxAmp = logAggregated.Batteries[ batID ].countWithMaxAmp + 1
					logAggregated.Batteries[ batID ].ampSum = logAggregated.Batteries[ batID ].ampSum + logLine.maxAmp
				
					if logAggregated.Batteries[ batID ].ampMin > logLine.maxAmp then
						logAggregated.Batteries[ batID ].ampMin = logLine.maxAmp
					end

					if logAggregated.Batteries[ batID ].ampMax < logLine.maxAmp then
						logAggregated.Batteries[ batID ].ampMax = logLine.maxAmp
						logAggregated.Batteries[ batID ].ampMaxDate = startFlyDT
					end
					
					
				end
				
			end		-- IfEnd logLine.flyTime ~= "00:00"
			
		end		-- end :: for	#logData
		
	end		-- end :: for	app.stat.logList
		

	-- Kiszmolni:
	-- app.d.log( "0/0" , ( 0 / 0 ) , "state_PROCESS_LOG_PERIOD_AGGREGATE()" )
	if logAggregated.countWithMaxAmp == 0 then
		logAggregated.ampAvg = 0
	else
		logAggregated.ampAvg = math.floor( logAggregated.ampSum / logAggregated.countWithMaxAmp )
	end
	if logAggregated.countWithMah == 0 then
		logAggregated.mAhAvg = 0
	else
		logAggregated.mAhAvg = math.floor( logAggregated.mAhSum / logAggregated.countWithMah )
	end
	
	if logAggregated.countFly == 0 then
		logAggregated.timeAvg = sec2Time( 0 )
	else
		logAggregated.timeAvg = sec2Time( logAggregated.timeSumSec / logAggregated.countFly  )
	end
	logAggregated.timeMax = sec2Time( logAggregated.timeMax )
	

	for r in pairs( logAggregated.Batteries ) do
	
		if logAggregated.maxBatteryFlyCount < logAggregated.Batteries[r].count then
			logAggregated.maxBatteryFlyCount = logAggregated.Batteries[r].count 
		end

		-- Count Used Batteries
		logAggregated.batteryCount = logAggregated.batteryCount + 1	
		
		logAggregated.Batteries[ r ].timeSum = sec2Time( logAggregated.Batteries[ r ].timeSumSec , true )

		if logAggregated.Batteries[ r ].countWithMaxAmp == 0 then
			logAggregated.Batteries[ r ].ampAvg = 0
		else
			logAggregated.Batteries[ r ].ampAvg = math.floor( logAggregated.Batteries[ r ].ampSum  / logAggregated.Batteries[ r ].countWithMaxAmp )
		end
		
		if logAggregated.Batteries[ r ].countWithMah == 0 then
			logAggregated.Batteries[ r ].mAhAvg = 0
		else
			logAggregated.Batteries[ r ].mAhAvg = math.floor( logAggregated.Batteries[ r ].mAhSum / logAggregated.Batteries[ r ].countWithMah )
		end
		
		logAggregated.Batteries[ r ].timeMax = sec2Time( logAggregated.Batteries[ r ].timeMax )
		
		if logAggregated.Batteries[ r ].countFly == 0 then
			logAggregated.Batteries[ r ].timeAvg = sec2Time( 0 )
		else
			logAggregated.Batteries[ r ].timeAvg = sec2Time( logAggregated.Batteries[ r ].timeSumSec / logAggregated.Batteries[ r ].countFly  )
		end
		
	end
	
	logAggregated.timeSum = sec2Time( logAggregated.timeSumSec, true )

	app.state = app.STATE.PROCESS_LOG_PERIOD_VIEW_DATA
	
	return 0
end

local function state_PROCESS_LOG_PERIOD_VIEW_DATA()

	dispAggregatedData(	logAggregated, 
								app.selectedCfgModel_Name	,  
								app.stat.from_y	,
								app.stat.from_m	,
								app.stat.from_d	,
								app.stat.to_y		,
								app.stat.to_m		,
								app.stat.to_d		 )

	app.state = app.STATE.PROCESS_LOG_PERIOD_VIEW_DATA_WAIT
	
	return 0
end

local function state_PROCESS_LOG_PERIOD_VIEW_BATDATA()

	dispAggregatedBatData(	logAggregated, 
									app.selectedCfgModel_Name	,  
									app.stat.from_y	,
									app.stat.from_m	,
									app.stat.from_d	,
									app.stat.to_y		,
									app.stat.to_m		,
									app.stat.to_d		 )

	app.state = app.STATE.PROCESS_LOG_PERIOD_VIEW_BATDATA_WAIT
	
	return 0
end

local function state_PROCESS_LOG_PERIOD_VIEW_BATDETAILSDATA()

	dispAggregatedBatDetailsData(	logAggregated, 
											app.selectedCfgModel_Name	,  
											app.stat.from_y	,
											app.stat.from_m	,
											app.stat.from_d	,
											app.stat.to_y		,
											app.stat.to_m		,
											app.stat.to_d		,
											app.selectedBattery )

	app.state = app.STATE.PROCESS_LOG_PERIOD_VIEW_BATDETAILDATA_WAIT
	
	return 0
end

local function state_PROCESS_LOG_PERIOD_COLLECT_LOGDATA_WAIT()

	dispWaitForm ( "Reading Flight Log ... " )

	app.state = app.STATE.PROCESS_LOG_PERIOD_COLLECT_LOGDATA

	return 0

end

local function state_PROCESS_LOG_PERIOD_COLLECT_LOGDATA()
	-- local logFilecollectLogFiles = collectLogFiles()
	
	app.stat.logList = collectLogFiles()
	
	-- app.d.log( "#app.stat.logList" , #app.stat.logList , "state_PROCESS_LOG_PERIOD_COLLECT_LOGDATA()" )
	
	if #app.stat.logList == 0 then
		-- TODO: üres, stop
		error( "app.stat.logList üres" )
	end
	-- Data collect first time.
	-- if #procModelLogList == 0 then
		-- collectLogFiles()
		-- -- app.d.log( " #procModelLogList MAX" ,  #procModelLogList , "state_PROCESS_LOG_PERIOD_COLLECT_LOGDATA()" )
		-- app.selectedLogFile_ID = #procModelLogList
	-- end
	
	-- app.d.log( "app.selectedLogFile_ID" , 
					-- app.selectedLogFile_ID  , 
					-- "state_PROCESS_LOG_PERIOD_COLLECT_LOGDATA()" )
					
	-- app.d.log(	"procModelLogList[ app.selectedLogFile_ID ]" , 
					-- procModelLogList[ app.selectedLogFile_ID ] , 
					-- "state_PROCESS_LOG_PERIOD_COLLECT_LOGDATA()" )

	logFile = loadScript( app.appFolder .. "csvfile.lua" )()

	-- error( "readcsv state_PROCESS_LOG_PERIOD_COLLECT_LOGDATA" )

	app.d.log( "logFile" , "scriptloaded()" , "state_PROCESS_LOG_PERIOD_COLLECT_LOGDATA()" )
	
	
	-- app.stat.logData	=	{}
	
	-- for k , logDailyFile in pairs( app.stat.logList ) do
	
		-- local logOneDay = {}
		-- logOneDay = logFile.readCsv( app.cfg.logPath .. logDailyFile )
		
		-- for keyLine , statDataValues in pairs( logOneDay ) do
			-- table.insert( app.stat.logData , statDataValues )
		-- end
		
	-- end
	
	
	-- logMonthData = logFile.readCsv( procModelLogList[ app.selectedLogFile_ID ] )

	-- app.d.log( "logFile" , "scriptloaded()" , "state_PROCESS_LOG_PERIOD_COLLECT_LOGDATA()" )

	-- app.d.log( "#app.stat.logData" , #app.stat.logData , "state_PROCESS_LOG_PERIOD_COLLECT_LOGDATA()" )

	-- error( "For elött: state_PROCESS_LOG_PERIOD_COLLECT_LOGDATA" )

											-- TODO: Ez máshova kell ahol a log egyesével kerül feldolgozásra.
	-- for c = 1 , #logMonthData do
		-- if logMonthData[c].endFly == "" then
			-- logMonthData[c].endFly	= "-"
		-- else
			-- logMonthData[c].endFly	= getDateTimeStr( logMonthData[c].endFly )
		-- end
		-- logMonthData[c].startFly	= getDateTimeStr( logMonthData[c].startFly )
	-- end
	
	-- log fields: 
	-- maxAmp => 384
	-- mAmpFly => 1061
	-- flyTime => 00:03
	-- startCount => 248
	-- endFly => 20260312143939
	-- startBatPercent => 0
	-- batteryID => A12345
	-- batteryProduct => HRB1234567
	-- endBatPercent => 0
	-- endBatVolt => 0.0
	-- startBatVolt => 0.0
	-- startFly => 20260312143935
	
	
	-- app.d.log( "END::" , "", "state_PROCESS_LOG_PERIOD_COLLECT_LOGDATA()" )


	app.state = app.STATE.PROCESS_LOG_PERIOD_VIEW_LOGDATA
	
	-- error( "END: state_PROCESS_LOG_PERIOD_COLLECT_LOGDATA" )
	
	return 0
	
end 

-- #############################################################

local function state_ASK_LOG_PERIOD_FORM()

	-- app.d.printAssoc( "state_ASK_MODEL_FORM() - cfgModels" ,  app.aCfgModels )

	app.d.log( "app.selectedCfgModel_Name" , app.selectedCfgModel_Name , "state_ASK_MODEL_FORM()" )	
	
	if #app.aCfgModels == 0 then
		app.state = app.STATE.ERROR_NO_MODEL
		return 0
	end

	readModelConfigFile( app.selectedCfgModel_Name )
	collectModelLogFiles( app.cfg.logPath , app.selectedCfgModel_Name )
	
	if #periodMonthsList == 0 then
		periodMonthsList	= { " " }
		app.selectedFromPeriod = 1
		app.selectedToPeriod	 = 1
	end
	
	
	-- app.d.printAssoc( "state_ASK_MODEL_FORM() - periodMonthsList" ,  periodMonthsList )
	-- app.d.printAssoc( "state_ASK_MODEL_FORM() - app.aCfgModels" ,  app.aCfgModels )
	
	dispAskModelAndPeriod( modelLogList, app.aCfgModels, periodMonthsList )
	
	app.state = app.STATE.ASK_MODEL_FORM_WAIT
	
	return 0
end

local function state_PROCESS_LOG_PERIOD_VIEW_LOGDATA()

	--collectLogFiles()
	-- app.selectedLogFile_ID = #procModelLogList
	-- app.d.log( "Start" , ""  , "state_PROCESS_LOG_PERIOD_VIEW_LOGDATA()" )

	-- app.d.log( "#procModelLogList" , #procModelLogList  , "state_PROCESS_LOG_PERIOD_VIEW_LOGDATA()" )

	-- hónapok kiválasztó képernyőre :: app.selectedLogFile_ID
	
	
	dispLogList(	app.stat.logData , 
						periodMonthsList ,
						app.aCfgModels[   app.selectedCfgModel_Name	 ] ,  
						periodMonthsList[ app.selectedFromPeriod] , 
						periodMonthsList[ app.selectedToPeriod	 ] )
	
	app.state = app.STATE.PROCESS_LOG_PERIOD_VIEW_LOGDATA_WAIT
	
	return 0
	
end

local function state_PROCESS_LOG_PERIOD_VIEW_LOGLINE()

	dispLogLine(	logMonthData[ app.selectedLogLine_ID ] , 
						app.aCfgModels[  app.selectedCfgModel_Name	] ,  
						periodMonthsList[selectedFromPeriod		] , 
						periodMonthsList[selectedToPeriod		] )

	app.state = app.STATE.PROCESS_LOG_PERIOD_VIEW_LOGLINE_WAIT
	
	return 0
end

-- #############################################################

local function state_PROCESS_LOG_MONTHSLIST_VIEW()
	local logDates
	
	if #app.aCfgModels == 0 then
		app.state = app.STATE.ERROR_NO_MODEL
		return 0
	end	
	
	readModelConfigFile( app.selectedCfgModel_Name )
	
	collectModelLogFiles( app.cfg.logPath , app.selectedCfgModel_Name )
	
	dispLog_MonthsList(	app.logDates , app.aCfgModels )
	
	app.state = app.STATE.PROCESS_LOG_MONTHSLIST_VIEW_WAIT
	
	return 0
end
local function state_PROCESS_LOG_MONTHSLIST_VIEW_WAIT()
	return 0
end

local function state_PROCESS_LOG_DAY_VIEW()

	if #app.aCfgModels == 0 then
		app.state = app.STATE.ERROR_NO_MODEL
		return 0
	end	

	if app.logSelected_logDatesIDX == 0 then
		app.state = app.STATE.PROCESS_LOG_MONTHSLIST_VIEW
		return 0
	end	

	-- app.d.printAssoc( "state_PROCESS_LOG_DAY_VIEW() - app.logDates" ,  app.logDates )
	-- app.d.printAssoc( "state_PROCESS_LOG_DAY_VIEW() - app.logFiles" ,  app.logFiles )
	-- app.d.log( "app.logFiles 20 " , app.logFiles[20] , "state_PROCESS_LOG_DAY_VIEW()" )

	
	local logFileName = app.cfg.logPath .. app.logFiles[ app.logSelected_logDatesIDX ]
	
	-- app.d.log( "logFileName" , logFileName , "state_PROCESS_LOG_DAY_VIEW()" )

	logFile = loadScript( app.appFolder .. "csvfile.lua" )()
	logFile.readCsv( logFileName )
	
	-- -- Prev/Next ----
	local aLogDay	= {} 
	local aPrevDay = {} 
	local aNextDay = {} 


	-- app.d.printAssoc( "state_PROCESS_LOG_DAY_VIEW() - app.logDates" ,  app.logDates )	
	-- app.d.log( "app.logSelected_logDatesIDX" , app.logSelected_logDatesIDX , "state_PROCESS_LOG_DAY_VIEW()" )
	
	aLogDay.id	= app.logSelected_logDatesIDX
	aLogDay.y	= app.logDates[ app.logSelected_logDatesIDX ].y
	aLogDay.m	= app.logDates[ app.logSelected_logDatesIDX ].m
	aLogDay.d	= app.logDates[ app.logSelected_logDatesIDX ].d

	if app.logDates[ app.logSelected_logDatesIDX -1 ] ~= nil then
		aPrevDay.id = app.logSelected_logDatesIDX -1
		aPrevDay.y = app.logDates[ app.logSelected_logDatesIDX -1 ].y
		aPrevDay.m = app.logDates[ app.logSelected_logDatesIDX -1 ].m
		aPrevDay.d = app.logDates[ app.logSelected_logDatesIDX -1 ].d
	end
	if app.logDates[ app.logSelected_logDatesIDX +1 ] ~= nil then
		aNextDay.id = app.logSelected_logDatesIDX +1
		aNextDay.y = app.logDates[ app.logSelected_logDatesIDX +1 ].y
		aNextDay.m = app.logDates[ app.logSelected_logDatesIDX +1 ].m
		aNextDay.d = app.logDates[ app.logSelected_logDatesIDX +1 ].d
	end

	-- app.d.printAssoc( "logFile.getTable()" , logFile.getTable() )
	
	app.selectedLogLine_ID	= 0
	
	dispLog_Day( logFile.getTable(), app.selectedCfgModel_Name, aPrevDay, aNextDay, aLogDay )
	
	app.state = app.STATE.PROCESS_LOG_DAY_VIEW_WAIT
	
	return 0
end
local function state_PROCESS_LOG_DAY_VIEW_WAIT()
	return 0
end


local function state_PROCESS_LOG_LINE_VIEW()
	local logLine
	local logFileName = app.cfg.logPath .. app.logFiles[ app.logSelected_logDatesIDX ]	

	-- app.d.log( "logFileName" , logFileName , "state_PROCESS_LOG_DAY_VIEW()" )


	if app.selectedLogLine_ID == 0 then
		app.state = app.STATE.PROCESS_LOG_MONTHSLIST_VIEW
		return 0
	end

	logFile = loadScript( app.appFolder .. "csvfile.lua" )()
	logFile.readCsv( logFileName )	
	
	logLine = logFile.getRow( app.selectedLogLine_ID )

	disp_LogLine( logLine, app.selectedCfgModel_Name )
	
	app.state = app.STATE.PROCESS_LOG_DAY_VIEW_WAIT
	
	return 0
end
local function state_PROCESS_LOG_LINE_VIEW_WAIT()
	return 0
end

-- #############################################################

local function state_PROCESS_BATTERY_LIST_VIEW()


	batFile = openBatteryFile()

	--batFile  =	loadScript( app.appFolder .. "csvfile.lua")()

	batFile.readCsv( app.appFolder .. "batfiles/batteries.csv" )	
	
	
	-- app.d.printAssoc( "batFile" , batFile.getTable(), "state_PROCESS_BATTERY_LIST_VIEW()" )

	dispBatList( batFile.getTable() )

	app.state = app.STATE.PROCESS_BATTERY_LIST_VIEW_WAIT
	
	return 0
end

local function state_PROCESS_BATTERY_ADD()

	aBat	= {}
	
	aBat.id	= ""

	aBat.firstStartDate	= ""
	aBat.earlyCount		= 0
	aBat.maxCapacity		= 2500
	aBat.count				= 0
	aBat.retireDate		= ""
	aBat.capacity			= 2500
	aBat.maxVolt			= 4.2
	aBat.product			= ""
	aBat.lastStartDate	= ""
	aBat.cells				= 3
	
	-- app.d.printAssoc( "aBat" , aBat, "state_PROCESS_BATTERY_EDIT()" )

	dispBat_AddEdit( aBat, 0 )
	
	app.state = app.STATE.PROCESS_BATTERY_ADD_WAIT
	
	return 0
end

local function state_PROCESS_BATTERY_EDIT()

	if not app.editedBatId then
		app.state =	app.STATE.PROCESS_BATTERY_LIST_VIEW
		return 0
	end

	batFile  =	loadScript( app.appFolder .. "csvfile.lua")()

	batFile.readCsv( app.appFolder .. "/batfiles/batteries.csv" )	
	
	rowID = batFile.getRowIdByField( "id", app.editedBatId )
	-- app.d.log( "rowID" , rowID , "state_PROCESS_BATTERY_EDIT()"  )
	
	aBat	= batFile.getRow( rowID )
	
	-- app.d.printAssoc( "aBat" , aBat, "state_PROCESS_BATTERY_EDIT()" )

	dispBat_AddEdit( aBat, rowID )
	
	app.state = app.STATE.PROCESS_BATTERY_EDIT_WAIT
	
	return 0
end

local function state_PROCESS_BATTERY_RETIRE()

	if not app.editedBatId then
		app.state =	app.STATE.PROCESS_BATTERY_LIST_VIEW
		return 0
	end
	
	batFile  =	loadScript( app.appFolder .. "csvfile.lua")()

	batFile.readCsv( app.appFolder .. "/batfiles/batteries.csv" )	
	
	rowID = batFile.getRowIdByField( "id", app.editedBatId )
	-- app.d.log( "rowID" , rowID , "state_PROCESS_BATTERY_RETIRE()"  )
	
	aBat	= batFile.getRow( rowID )
	
	-- app.d.printAssoc( "aBat" , aBat, "state_PROCESS_BATTERY_RETIRE()" )

	dispBat_ToggleRetire( rowID , aBat )
	
	app.state = app.STATE.PROCESS_BATTERY_RETIRE_WAIT
	
	return 0
end

local function state_PROCESS_BATTERY_ASSIGN()
	
	if not app.editedBatId then
		app.state =	app.STATE.PROCESS_BATTERY_LIST_VIEW
		return 0
	end
	
	-- === Battery Data
	
	local batFile
	
	batFile  =	loadScript( app.appFolder .. "csvfile.lua")()
	batFile.readCsv( app.appFolder .. "/batfiles/batteries.csv" )	
	
	rowID = batFile.getRowIdByField( "id", app.editedBatId )
	aBat	= batFile.getRow( rowID )
	
	


	-- === Selectable Models  (models/*.cfg)
	-- app.d.printAssoc( "..ASSIGN() - app.aCfgModels" , app.aCfgModels )
	
	-- Battery Data
	--	Models conneted to the batteryCount
	-- All model
			-- ??
			-- Minden a rádión létező model vagy csak azok amelyeknél a widget képernyőn van ( létezik ./BattUse/models/model[id].cfg )
			-- Kell az aktuális battery főbb adatai : ( ID, prod, mah , cells)

	dispBat_Assign( aBat, app.modelList )

	app.state = app.STATE.PROCESS_BATTERY_ASSIGN_WAIT

	
	return 0
end

-- #############################################################

function A.init()
	-- app.d.log( "Read *.cfg files" , "Start" , "A.init()" )
	
	state_INIT()
   return 0
end

function A.run(event, touchState)
	local swipeDirection = SWIPE_NONE

	-- if app.state and app.state_lastState  ~= app.state then
		-- app.state_lastState = app.state
		-- app.d.log( "run event : ", app.state_Name[ app.state ] .. " -> " .. app.state , "A.run()" )
	-- end

	-- app.d.log( "state", app.state, "A.run()" )

	if event == nil then
		error( "Cannot be run as a model script!" )
		return 2
	end
	
	if touchState then
		-- app.d.printAssoc( "touchState" , touchState )
		if touchState.swipeLeft then
			swipeDirection = SWIPE_LEFT
			-- app.d.log( "swipeDirectionL" , swipeDirection , "A.run()" )
			
		elseif touchState.swipeRight then
			swipeDirection = SWIPE_RIGHT
			-- app.d.log( "swipeDirectionR" , swipeDirection , "A.run()" )
			
		end
	end
	
	-- PAGE gombok kezelése
	if event == EVT_PAGE_BREAK or event == EVT_VIRTUAL_NEXT_PAGE  then
		swipeDirection = SWIPE_LEFT
	end

	if event == EVT_PAGEUP_BREAK or event == EVT_VIRTUAL_PREVIOUS_PAGE then
		swipeDirection = SWIPE_RIGHT
	end	

	-- ========== Swipe =====================================================================
	
	if swipeDirection == SWIPE_RIGHT then	-- Previous Page
		if     app.state == app.STATE.ASK_MODEL_FORM_WAIT then
		
			-- logAggregated = {}
			app.state = app.STATE.PROCESS_LOG_MONTHSLIST_VIEW
			
		elseif app.state == app.STATE.PROCESS_BATTERY_LIST_VIEW_WAIT then
		
			app.state = app.STATE.ASK_MODEL_FORM
			
		elseif app.state == app.STATE.PROCESS_LOG_MONTHSLIST_VIEW_WAIT then
		
			app.state = app.STATE.PROCESS_BATTERY_LIST_VIEW
			
		end
	end
	
	-- ==========
	
	if swipeDirection == SWIPE_LEFT then	-- Next Page
	
		if     app.state == app.STATE.ASK_MODEL_FORM_WAIT then
		
			-- logAggregated = {}
			app.state = app.STATE.PROCESS_BATTERY_LIST_VIEW
			
		elseif app.state == app.STATE.PROCESS_BATTERY_LIST_VIEW_WAIT then
		
			app.state = app.STATE.PROCESS_LOG_MONTHSLIST_VIEW
			
		elseif app.state == app.STATE.PROCESS_LOG_MONTHSLIST_VIEW_WAIT then
		
			app.state = app.STATE.ASK_MODEL_FORM
			
		end
	
	
	
		-- if     app.state == app.STATE.PROCESS_LOG_PERIOD_VIEW_DATA_WAIT then
			-- app.state = app.STATE.PROCESS_LOG_PERIOD_VIEW_BATDATA
		-- elseif app.state == app.STATE.PROCESS_LOG_PERIOD_VIEW_BATDATA_WAIT then
			-- app.state = app.STATE.PROCESS_LOG_PERIOD_COLLECT_LOGDATA_WAIT
		-- end
	end
	-- ======================================================================================

	-- Alap eseménykezelés
	if event == EVT_VIRTUAL_EXIT then
		return 1
	end

	if app.state == app.STATE.INIT then
		return state_INIT()

	-- BatEdit States ------------------------------
		
	elseif app.state == app.STATE.PROCESS_BATTERY_LIST_VIEW then
		return state_PROCESS_BATTERY_LIST_VIEW()
		
	elseif app.state == app.STATE.PROCESS_BATTERY_ADD then
		return state_PROCESS_BATTERY_ADD()
		
	elseif app.state == app.STATE.PROCESS_BATTERY_EDIT then
		return state_PROCESS_BATTERY_EDIT()
		
	elseif app.state == app.STATE.PROCESS_BATTERY_ASSIGN then
		return state_PROCESS_BATTERY_ASSIGN()
		
	-- Log Process States ------------------------------
	
	elseif app.state == app.STATE.PROCESS_LOG_MONTHSLIST_VIEW then
		return state_PROCESS_LOG_MONTHSLIST_VIEW()

	elseif app.state == app.STATE.PROCESS_LOG_DAY_VIEW then
		return state_PROCESS_LOG_DAY_VIEW()
		
		
	elseif app.state == app.STATE.PROCESS_LOG_LINE_VIEW then
		return state_PROCESS_LOG_LINE_VIEW()
		
		
	-- =================

	elseif app.state == app.STATE.ASK_MODEL_FORM then
	
		-- TODO: csak teszt idejére, hogy ne kelljen minden alkalommal végig kattintani a teljes folyamatot	
		if 2 == 1 then
						-- state_ASK_MODEL_FORM()
						-- state_PROCESS_LOG_PERIOD_COLLECT_LOGS()
						-- state_PROCESS_LOG_PERIOD_AGGREGATE()
						-- return state_PROCESS_LOG_PERIOD_VIEW_BATDATA()
						
			-- state_PROCESS_BATTERY_LIST_VIEW()
			-- app.editedBatId = "H12345"
			-- app.state = app.STATE.PROCESS_BATTERY_EDIT
			
			app.editedBatId = nil
			app.state = app.STATE.PROCESS_BATTERY_ADD
			
			
			return state_PROCESS_BATTERY_ADD()					
						
		else
			return state_ASK_MODEL_FORM()
		end
		-- =============================
		
	elseif app.state == app.STATE.ASK_MODEL_FORM_WAIT or 
			 app.state == app.STATE.PROCESS_LOG_PERIOD_VIEW_DATA_WAIT or 
			 app.state == app.STATE.PROCESS_LOG_PERIOD_VIEW_BATDATA_WAIT or 
			 app.state == app.STATE.PROCESS_LOG_PERIOD_VIEW_BATDETAILDATA_WAIT or
			 app.state == app.STATE.PROCESS_LOG_PERIOD_VIEW_LOGDATA_WAIT or
			 app.state == app.STATE.PROCESS_LOG_PERIOD_VIEW_LOGLINE_WAIT or
			 app.state == app.STATE.PROCESS_BATTERY_LIST_VIEW_WAIT or
			 app.state == app.STATE.PROCESS_BATTERY_ADD_WAIT or
			 app.state == app.STATE.PROCESS_BATTERY_EDIT_WAIT or
			 app.state == app.STATE.PROCESS_BATTERY_ASSIGN_WAIT or
			 app.state == app.STATE.PROCESS_BATTERY_RETIRE_WAIT or
			 app.state == app.STATE.PROCESS_LOG_MONTHSLIST_VIEW_WAIT or
			 app.state == app.STATE.PROCESS_LOG_LINE_VIEW_WAIT	or	
			 app.state == app.STATE.PROCESS_LOG_DAY_VIEW_WAIT			
			 then
		
		return state_ASK_MODEL_FORM_WAIT()

	elseif app.state == app.STATE.PROCESS_LOG_PERIOD_WAIT_FORM then
		return state_PROCESS_LOG_PERIOD_WAIT_FORM()

	elseif app.state == app.STATE.PROCESS_LOG_PERIOD_COLLECT_LOGS then
		return state_PROCESS_LOG_PERIOD_COLLECT_LOGS()

	elseif app.state == app.STATE.PROCESS_LOG_PERIOD_AGGREGATE then
		return state_PROCESS_LOG_PERIOD_AGGREGATE()
		
	elseif app.state == app.STATE.PROCESS_LOG_PERIOD_VIEW_DATA then
		return state_PROCESS_LOG_PERIOD_VIEW_DATA()		
		
	elseif app.state == app.STATE.PROCESS_LOG_PERIOD_VIEW_BATDATA then
		return state_PROCESS_LOG_PERIOD_VIEW_BATDATA()

	elseif app.state == app.STATE.PROCESS_LOG_PERIOD_VIEW_BATDETAILDATA then
		return state_PROCESS_LOG_PERIOD_VIEW_BATDETAILSDATA()
	


	elseif app.state == 	app.STATE.PROCESS_LOG_PERIOD_COLLECT_LOGDATA_WAIT then		
		return state_PROCESS_LOG_PERIOD_COLLECT_LOGDATA_WAIT()
			
	elseif app.state == 	app.STATE.PROCESS_LOG_PERIOD_COLLECT_LOGDATA	 then
		return state_PROCESS_LOG_PERIOD_COLLECT_LOGDATA()
		
	elseif app.state == 	app.STATE.PROCESS_LOG_PERIOD_VIEW_LOGDATA	 then		
		return state_PROCESS_LOG_PERIOD_VIEW_LOGDATA()
	
	elseif app.state == 	app.STATE.PROCESS_LOG_PERIOD_VIEW_LOGLINE	 then		
		return state_PROCESS_LOG_PERIOD_VIEW_LOGLINE()
	
	elseif app.state == 	app.STATE.PROCESS_BATTERY_RETIRE	 then		
		return state_PROCESS_BATTERY_RETIRE()

	
			
	elseif app.state == app.STATE.ERROR_NO_BATTUSE then
		return showErrorMessage( "You have to install BattUse Widget." )		
		
		
	elseif app.state == app.STATE.ERROR_NO_MODEL then
		return showErrorMessage( "You have to model settings in BattUse Widget.    (Have to be .cfg file there.)" )	


	elseif app.state == app.STATE.ERROR_NO_BATFILES then
		return showErrorMessage( "Missing file(s) from batfiles dir." )	

	elseif app.state == app.STATE.ASK_MODEL_FORM_WAIT then
		return 0
		
	elseif app.state == app.STATE.QUIT then
		return 1
		
		
		
		
	else
		error( "state not exist : " .. app.state )
		return 2
		
	end

   return 0
end


return A
