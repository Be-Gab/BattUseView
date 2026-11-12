--[[#######################################################################
##  disptx16s.lua                                                        ##
##                BattUseView - TX16S Display functions  - Default       ##
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
local PAGE_HEAD_HEIGH	= 44 --32              ?? * lvgl.LCD_SCALE ??

local DTF = {}
	DTF.FORMAT_DATE_TIME_SEC=  0
	DTF.FORMAT_DATE_TIME		= 20
	DTF.FORMAT_TIME_SEC		= 40
	DTF.FORMAT_TIME			= 60
	DTF.FORMAT_YMD				= 80
	DTF.FORMAT_YM				= 90 

local function getDateTimeStr( s , dt_format )
	local dt = {}
	local	df = app.cfg.dateFormatID 
	
	if s == "" or not s then
		return ""
	end
	
	without_sec = without_sec or false
	
	dt_format = dt_format or 0
	df = df + dt_format
	
	dt.year	= tonumber( string.sub( s, 1, 4 ) )
	dt.month = tonumber( string.sub( s, 5, 6 ) )		
	dt.day	= tonumber( string.sub( s, 7, 8 ) )
	dt.hour	= tonumber( string.sub( s, 9,10 ) )
	dt.min	= tonumber( string.sub( s,11,12 ) )
	dt.sec	= tonumber( string.sub( s,13,14 ) )



	-- DTF.FORMAT_DATE_TIME_SEC=  0
	-- DTF.FORMAT_DATE_TIME		= 20
	-- DTF.FORMAT_TIME_SEC		= 40
	-- DTF.FORMAT_TIME			= 60
	-- DTF.FORMAT_YMD				= 80
	-- DTF.FORMAT_YM				= 90

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
	
	-- DT_FORMAT_DATE_TIME   (Without SEC):
		
	elseif df == 21 then
		--	MM/DD/YYYY HH:MM:SS
		f = string.format( "%02d/%02d/%04d %02d:%02d" ,  dt.month , dt.day , dt.year , dt.hour	, dt.min	 )

	elseif df == 22 then
		-- DD.MM.YYYY HH:MM:SS
		f = string.format( "%02d.%02d.%04d %02d:%02d"  , dt.day , dt.month, dt.year , dt.hour	, dt.min	 )
		
	elseif df == 23 then
		-- YYYY/MM/DD HH:MM:SS
		f = string.format( "%04d/%02d/%02d %02d:%02d" , dt.year	, dt.month , dt.day , dt.hour	, dt.min	 )

	elseif df == 24 then
		-- YYYY.MM.DD. HH:MM:SS
		f = string.format( "%04d.%02d.%02d. %02d:%02d" , dt.year	, dt.month , dt.day , dt.hour	, dt.min	 )

	-- DT_FORMAT_TIME_SEC		= 40

	elseif df == 41 then
		--	HH:MM:SS
		f = string.format( "%02d:%02d:%02d" ,  dt.hour	, dt.min, dt.sec		 )

	elseif df == 42 then
		--	HH:MM:SS
		f = string.format( "%02d:%02d:%02d" ,  dt.hour	, dt.min, dt.sec		 )
		
	elseif df == 43 then
		--	HH:MM:SS
		f = string.format( "%02d:%02d:%02d" ,  dt.hour	, dt.min, dt.sec		 )

	elseif df == 44 then
		--	HH:MM:SS
		f = string.format( "%02d:%02d:%02d" ,  dt.hour	, dt.min, dt.sec		 )

	-- DT_FORMAT_TIME				= 60

	elseif df == 61 then
		--	HH:MM
		f = string.format( "%02d:%02d" ,  dt.hour	, dt.min )

	elseif df == 62 then
		--	HH:MM
		f = string.format( "%02d:%02d" ,  dt.hour	, dt.min )
		
	elseif df == 63 then
		--	HH:MM
		f = string.format( "%02d:%02d" ,  dt.hour	, dt.min )

	elseif df == 64 then
		--	HH:MM
		f = string.format( "%02d:%02d" ,  dt.hour	, dt.min )

	-- DTF.FORMAT_YMD				= 80
	elseif df == 81 then
		--	MM/DD/YYYY
		f = string.format( "%02d/%02d/%04d" ,  dt.month , dt.day , dt.year )

	elseif df == 82 then
		-- DD.MM.YYYY
		f = string.format( "%02d.%02d.%04d"  , dt.day , dt.month, dt.year )
		
	elseif df == 83 then
		-- YYYY/MM/DD
		f = string.format( "%04d/%02d/%02d" , dt.year	, dt.month , dt.day )

	elseif df == 84 then
		-- YYYY.MM.DD.
		f = string.format( "%04d.%02d.%02d." , dt.year	, dt.month , dt.day  )



	-- DTF.FORMAT_YM				= 90
	
	elseif df == 91 then
		--	MM/YYYY 
		f = string.format( "%02d/%04d" , dt.month , dt.year )

	elseif df == 92 then
		-- MM.YYYY 
		f = string.format( "%02d.%04d"  , dt.month , dt.year )
		
	elseif df == 93 then
		-- YYYY/MM
		f = string.format( "%04d/%02d" , dt.year	, dt.month )

	elseif df == 94 then
		-- YYYY.MM.
		f = string.format( "%04d.%02d." , dt.year	, dt.month	 )

	else
		f = df .. ":DateFormat missing"
	end
	
	return f
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
	
	return f

end

local function YM_Days( yr, mth )
    local dys = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31  }

    -- February 
    if mth == 2 then
        if (yr % 400 == 0) or (yr % 4 == 0 and yr % 100 ~= 0) then
            return 29
        end
    end

    return dys[mth]
end 

-- #################### --- ####################

function pageHead( screenType, subUi )
	local s = lvgl.LCD_SCALE
	local headButtons, iconFile, subTitle
	local title 		= "BattUse Log View"
	local headHeight	= PAGE_HEAD_HEIGH * s
	local btnHeigh		= headHeight - ( 16 * s )
	local picWidth		= headHeight
	local titleWidth	= 140 * s
	local BTN_WIDTH	=  64 * s
	

	local btnBatteries=	{ type = "button", text = "Batteries" ,
									w = 72*s, h = btnHeigh ,
									press = (function() app.state = app.STATE.PROCESS_BATTERY_LIST_VIEW; end)
								}

	local btnLog		=	{ type = "button", text = "Log" ,
									w = 50 * s , h = btnHeigh ,
									-- w = BTN_WIDTH, h = btnHeigh ,
									press = (function() app.state = app.STATE.PROCESS_LOG_MONTHSLIST_VIEW; end)
								}

	local btnSum		=	{ type = "button", text = "Total" ,
									w = BTN_WIDTH, h = btnHeigh ,
									press = (function() app.state = app.STATE.PROCESS_LOG_PERIOD_VIEW_DATA; end)
								}
								
	local btnBat		=	{ type = "button", text = "BatStat" ,
									w = BTN_WIDTH, h = btnHeigh ,
									press		= (function() app.state = app.STATE.PROCESS_LOG_PERIOD_VIEW_BATDATA; end)
								}
	
	local btnStat		=	{ type = "button", text = "Stat" ,
									w = 50 * s , h = btnHeigh ,
									-- w = BTN_WIDTH, h = btnHeigh ,
									press = (function() app.state = app.STATE.ASK_MODEL_FORM; end)
								}


	local btnClose		=	{ type = "button", text = "Close" ,
									w = BTN_WIDTH, h = btnHeigh ,
									press = (function()  app.state = app.STATE.QUIT; end)
								}


	-- app.d.log( "screenType" , screenType , "pageHead()" )



--##################### LOG
	if	screenType == app.STATE.PROCESS_LOG_MONTHSLIST_VIEW then
	
		headButtons = 	{	btnStat, btnBatteries , btnClose	}
		subTitle		=	"Flight log"
		iconFile		= app.otsFolder .. "icon/" .. "log.png"	
		
	elseif	screenType == app.STATE.PROCESS_LOG_DAY_VIEW then
	
		headButtons = 	{	btnStat, btnLog, btnBatteries , btnClose	}
		subTitle		=	"Daily log"
		iconFile		= app.otsFolder .. "icon/" .. "log.png"			

	elseif	screenType == app.STATE.PROCESS_LOG_LINE_VIEW then
	
		headButtons = 	{	btnLog, btnBatteries , btnClose	}
		subTitle		=	"Flight data"
		iconFile		= app.otsFolder .. "icon/" .. "log.png"			
		
--##################### Aggregate

	elseif		screenType == app.STATE.ASK_MODEL_FORM 	then

		headButtons = 	{	btnLog, btnBatteries , btnClose	}
		subTitle		=	"Select stat date range"
		iconFile		= app.otsFolder .. "icon/" .. "select.png"
		
	elseif	screenType == app.STATE.PROCESS_LOG_PERIOD_VIEW_DATA then
	
		headButtons = 	{	btnStat, btnLog,	btnBat, btnClose	}
		subTitle		=	"Aggregated data"
		iconFile		= app.otsFolder .. "icon/" .. "data.png"	
		
	elseif	screenType == app.STATE.PROCESS_LOG_PERIOD_VIEW_BATDATA	 then
	
		headButtons = 	{	btnLog,	btnSum , btnClose	}
		subTitle		=	"Batteries stat"
		iconFile		= app.otsFolder .. "icon/" .. "bat.png"	

	elseif	screenType == app.STATE.PROCESS_LOG_PERIOD_VIEW_BATDETAILDATA	 then
	
		headButtons = 	{	btnLog,	btnSum , btnBat, btnClose	}
		subTitle		=	"Battery details stat"
		iconFile		= app.otsFolder .. "icon/" .. "bat.png"	
		
	elseif	screenType == app.STATE.PROCESS_LOG_PERIOD_VIEW_LOGDATA	 then
	
		headButtons = 	{	btnLog, btnClose	}
		subTitle		=	"Flight log"
		iconFile		= app.otsFolder .. "icon/" .. "log.png"	

	elseif	screenType == app.STATE.PROCESS_LOG_PERIOD_VIEW_LOGLINE then
	
		headButtons = 	{	btnLog,	btnLog , btnClose	}
		subTitle		=	"Flight log entry"
		iconFile		= app.otsFolder .. "icon/" .. "log.png"	

	elseif	screenType == app.STATE.PROCESS_LOG_PERIOD_WAIT_FORM or
				screenType == app.STATE.PROCESS_LOG_PERIOD_COLLECT_LOGDATA_WAIT then
	
		headButtons = 	{	btnClose	}
		subTitle		=	"Please Wait..."
		iconFile		= app.otsFolder .. "icon/" .. "bat.png"	
		
--##################### BATTERY
		
	elseif	screenType == app.STATE.PROCESS_BATTERY_LIST_VIEW or
				screenType == app.STATE.PROCESS_BATTERY_LIST_VIEW_WAIT then
	
		headButtons =	{	btnStat, btnLog , btnClose	}
		subTitle		=	"Battery list"
		iconFile		=	app.otsFolder .. "icon/" .. "bat.png"		

	elseif	screenType == app.STATE.PROCESS_BATTERY_EDIT or
				screenType == app.STATE.PROCESS_BATTERY_EDIT_WAIT then
	
		headButtons =	{	btnStat,  btnLog, btnBatteries, btnClose	}
		subTitle		=	"Edit battery"
		iconFile		=	app.otsFolder .. "icon/" .. "bat.png"		

	elseif	screenType == app.STATE.PROCESS_BATTERY_ADD or
				screenType == app.STATE.PROCESS_BATTERY_ADD_WAIT then
	
		headButtons =	{	btnStat,  btnLog, btnBatteries, btnClose	}
		subTitle		=	"Add battery"
		iconFile		=	app.otsFolder .. "icon/" .. "bat.png"		

	elseif	screenType == app.STATE.PROCESS_BATTERY_RETIRE or
				screenType == app.STATE.PROCESS_BATTERY_RETIRE_WAIT then
	
		headButtons =	{	btnStat,  btnLog, btnBatteries, btnClose	}
		subTitle		=	"!! Change battery state!!"
		iconFile		=	app.otsFolder .. "icon/" .. "bat.png"	
		
	elseif	screenType == app.STATE.PROCESS_BATTERY_ASSIGN or
				screenType == app.STATE.PROCESS_BATTERY_ASSIGN_WAIT then
	
		headButtons =	{	btnStat,  btnLog, btnBatteries,  btnClose	}
		subTitle		=	"Assign Battery to model"
		iconFile		=	app.otsFolder .. "icon/" .. "bat.png"		

	end
	
	local zw = LCD_W -- 480
	local zh = LCD_H

	local base =	{
							{	type = "box", -- id = "fullScreen" ,
								color = WHITE ,
								x = 0 , 
								y = 0 ,
								w = zw , 
								h = zh , --widget.zone.h , 
								children = {
									{	type = "rectangle" , -- id = "head" ,
										thickness = 0 ,
										color = COLOR_THEME_SECONDARY1 , filled = true,  
										x = 0, 
										y = 0,
										w = zw, --widget.zone.w , 
										h = headHeight ,
										children =	{
											{	type = "box" , -- id = "pic" ,
												x = 0, 
												y = 0 ,
												w = picWidth , 
												h = headHeight, 
												children = {
													{  type = "image" ,
														w = picWidth , h = headHeight,
														file = iconFile,
														fill = true , -- False = NO resize
													}
												}
											} -- pic
											,
											{	type = "box" , -- id = "title" ,
												flexFlow = lvgl.FLOW_COLUMN , 
												flexPad =  0 , 
												scrollBar = false, scrollDir = 0,
												x = picWidth , 
												y = 0 ,
												w = titleWidth , 
												h = headHeight ,
												children = {
													{	type = "label" ,
														text = title ,
														color = COLOR_THEME_PRIMARY2,
													}
													,
													{	type = "label" ,
														text = subTitle ,
														color = COLOR_THEME_PRIMARY2,
														font	= SMLSIZE , 
													}
												}
											} -- title
											,
											{	type = "rectangle" , -- id = "menu" ,
												thickness = 0 ,
												flexFlow = lvgl.FLOW_ROW , 
												flexPad =  lvgl.PAD_SMALL , 
												x = picWidth + titleWidth ,
												y = 0 ,
												align = VCENTER + CENTER,
												w = zw - picWidth - titleWidth , 
												h = headHeight , 
												children = headButtons
											} -- menu
											
										}
									}	-- head
									,
									{ type = "rectangle" , -- id = "body" ,
										y = headHeight ,  
										x = 0 ,
										w = zw,	--widget.zone.w , 
										h = zh - headHeight ,
										color = COLOR_THEME_SECONDARY3 , filled = true, 
										children =	
											{
												{ type = "box" , -- id = "subbody" ,
													flexFlow = lvgl.FLOW_COLUMN , flexPad = 0 , 
													scrollBar = true, scrollDir = lvgl.SCROLL_VER,
													w = zw, --widget.zone.w , 
													children =	subUi
												} -- subbody
											}
									} -- body
								}								
							}	--	fullScreen
						}

	lvgl.clear()
	
	return lvgl.build( base )	
		
end
 
function dispErrorMsg( s )

	lvgl.clear()
	
	ui =	{
				{	type = "rectangle" ,
					thickness= 3 ,
					rounded	= 12 ,
					flexFlow = lvgl.FLOW_ROW , 
					children	=	{
						{	type	= "label", 
							h		= LCD_H * .75,
							w		= LCD_W * .9,
							font	= DBLSIZE ,
							text	= s ,
							align = CENTER + VCENTER
						} ,
					}
				}
			}

	pageHead( app.state , ui )

end

function dispWaitForm ( msg )

	lvgl.clear()
	
	ui =	{
				{	type = "rectangle" ,
					thickness= 2 ,
					rounded	= 20 ,
					flexFlow = lvgl.FLOW_ROW , 
					children	=	{
						{	type	= "label", 
							h		= LCD_H * .5,
							w		= LCD_W * .9,
							font	= DBLSIZE ,
							text	= msg ,
							align = CENTER + VCENTER
						} ,
					}
				}
			}

	pageHead( app.state , ui )
	
end

-- #################### Aggregate

function dispAskModelAndPeriod( modelLogList, cfgModels )
	local s = lvgl.LCD_SCALE
	
	-- app.d.printAssoc( "dispAskModelAndPeriod() modelLogList " , modelLogList  )
	-- app.d.printAssoc( "dispAskModelAndPeriod() cfgModels " , cfgModels  )
	

	local aModelNames = {}
	local aModelSorsz2Name	= {} 
	local aName2ModelSorsz = {} 
	local sorsz = 0
	
	for k ,v  in pairs( cfgModels	) do
		table.insert( aModelNames	, v.name )
		
		sorsz = sorsz + 1
		aName2ModelSorsz[ v.name ]	= sorsz
		aModelSorsz2Name[ sorsz ]	= v.name
		
	end
	
	-- YM_Days( yr, mth)

	local function getMonthDaysList( y, m )
		local aDays = {}
		local lastDay = YM_Days( y , m )	-- last day of the year,month
		
		if y + m == 0 then
			lastDay = 1
		end
		
		for i = 1 , lastDay do
			table.insert( aDays, i )
		end
		
		return aDays
	end	
	
	-- INP : app.logDates			[id] =	{	y = "YYYY" , m = "MM" , d = "DD" }
	-- OUT : aYearMonths  			[id] => "YYYYMM" (in user format)
	--			aYearMonthsControl	[id] => { year, month }
	local function getYearsMonts()
		local aYearMonths	=	{}
		local aYearMonthsControl	=	{}
		local id = 0
		local uniqYM	=	{}, ymKey

		-- app.d.printAssoc( "getYearsMonts() - app.logDates" , app.logDates  )
		
		for k , aLogDT in pairs( app.logDates ) do
			
			ymKey = string.format( "%04d%02d" , aLogDT.y , aLogDT.m )
			
			-- if uniqYM[ ymKey ] == nil then
			if not uniqYM[ ymKey ] then
			
				-- app.d.log( "aLogDT.y, aLogDT.n" , id .. "=" .. aLogDT.y .. "," .. aLogDT.m , "getYearsMonts()" )
				
				id = id + 1
			
				aYearMonths[ id ] 			= getDateFormatYMD( aLogDT.y , aLogDT.m )
				aYearMonthsControl[ id ]	= { ["year"] = aLogDT.y , ["month"] = aLogDT.m }
				
				uniqYM[ ymKey ] = true 
			
			end
		end
		
		-- app.d.printAssoc( "getYearsMonts() - aYearMonths" , aYearMonths  )
		-- app.d.printAssoc( "getYearsMonts() - aYearMonthsControl" , aYearMonthsControl  )
		
		return aYearMonths, aYearMonthsControl
	end
	
	local function getYearsMonthID ( aYM_List , y, m )
		local id = 1
		
		for k ,v  in pairs( aYM_List ) do
			if v.year == y and v.month == m then
				id = k
				break
			end
		end
		
		return id
	end
	
	local fromYM_List, fromYM_ListID
	
	dateYM_List, dateYM_ListID = getYearsMonts()

	-- app.d.log( "==============" , "" , "dispAskModelAndPeriod()" )
	-- app.d.printAssoc( "aModelNames" , aModelNames )
	-- app.d.printAssoc( "aModelSorsz2ID"   , aModelSorsz2ID )
	-- app.d.printAssoc( "aId2ModelSorsz"   , aId2ModelSorsz )

	ui =	{
				{	type = "box" ,		-- model select
					flexFlow = lvgl.FLOW_ROW , 
					align		= CENTER ,
					children	=	{
						{	type	= "label", 
							w		= 95 * s ,
							text	= "Model name " 
						} ,
						{	type	= "choice",  
							w		= 260 * s,
							title = "Select model name",
							values=	aModelNames ,
							get	=	function() 
											return aName2ModelSorsz[ app.selectedCfgModel_Name ]; 
										end , 
							set	=	function(s)
											app.selectedCfgModel_Name = aModelSorsz2Name[ s ];
											app.state = app.STATE.ASK_MODEL_FORM;
										end
						} 
					}
				} ,
				
				{	type = "box" , 	-- buttons : presetted date periods
					flexFlow = lvgl.FLOW_ROW , 
					align		= CENTER ,
					w 			= LCD_W * 0.8 ,
					children	=	{			
						{	type = "button" ,
							text = "This year" ,
							press=	function()
											local dt = getDateTime();
											
											app.stat.from_y	= dt.year;
											app.stat.from_m	= 1;
											app.stat.from_d	= 1;

											app.stat.to_y		= dt.year;
											app.stat.to_m		= 12;
											app.stat.to_d		= 31;
																							
											app.state = app.STATE.PROCESS_LOG_PERIOD_WAIT_FORM;
										end ,
							active=	function()
											return ( #app.logFiles > 0 ); 
										end
						} ,
						{	type = "button" ,
							text = "This month" ,
							press=	function()
											local dt = getDateTime();
											
											app.stat.from_y	= dt.year;
											app.stat.from_m	= dt.mon;
											app.stat.from_d	= 1;

											app.stat.to_y		= dt.year;
											app.stat.to_m		= dt.mon;
											app.stat.to_d		= 31;
																							
											app.state = app.STATE.PROCESS_LOG_PERIOD_WAIT_FORM;
										end ,
							active=	function() 
											return ( #app.logFiles > 0 ); 
										end
						} ,
						{	type = "button" ,
							text = "Previous month" ,
							press=	function()
											local dt = getDateTime();
											local fm = dt.mon -1;
											local fy = dt.year;
											if fm < 1 then;
												fm = 12;
												fy = fy -1;
											end;
											
											
											app.stat.from_y	= fy;
											app.stat.from_m	= fm;
											app.stat.from_d	= 1;

											app.stat.to_y		= fy;
											app.stat.to_m		= fm;
											app.stat.to_d		= 31;
																							
											app.state = app.STATE.PROCESS_LOG_PERIOD_WAIT_FORM;
										end ,
							active=	function() 
											return ( #app.logFiles > 0 );
										end
						} 
						
					}
				} ,

				{	type = "box" ,  -- just space
					-- flexFlow = lvgl.FLOW_ROW ,
					h		= 20 * s
				}, 
				
				{	type = "box" ,  -- period
					flexFlow = lvgl.FLOW_ROW , 
					align		= CENTER ,
					children	=	{
						{	type	=	"label", 
							w		=	90 * s ,
							text	=	"Date range" 
						},
						{	type	=	"choice",  
							w		=	90 * s,
							title =	"From Year, Month",
							values=	dateYM_List ,
							active=	function() 
											return ( #app.logFiles > 0 ); 
										end ,
							get	=	function() ;
											return getYearsMonthID ( dateYM_ListID , app.stat.from_y, app.stat.from_m )
										end , 
							set	=	function(s)
											app.stat.from_y = dateYM_ListID[s].year;
											app.stat.from_m = dateYM_ListID[s].month;
										end
						},
						
											-- app.stat.from_y	= dt.year;
											-- app.stat.from_m	= 1;
											-- app.stat.from_d	= 1;
											
											
						{	type	=	"choice" ,  
							w		=	50 * s ,
							title =	"From Day" ,
							values=	getMonthDaysList( app.stat.from_y , app.stat.from_m ) ,
							active=	function() 
											return ( #app.logFiles > 0 ); 
										end ,
							get	=	function() 
											return math.max( 1, app.stat.from_d ); 
										end , 
							set	=	function(s)
											app.stat.from_d = s;
										end
						},
						{	type	=	"label", 
							text	=	" - " 
						},
						{	type	=	"choice",  
							w		=	90 * s,
							title =	"From Year, Month",
							values=	dateYM_List ,
							active=	function() 
											return ( #app.logFiles > 0 ); 
										end ,
							get	=	function() ;
											return getYearsMonthID ( dateYM_ListID , app.stat.to_y, app.stat.to_m )
										end , 
							set	=	function(s)
											app.stat.to_y = dateYM_ListID[s].year;
											app.stat.to_m = dateYM_ListID[s].month;
										end
						},
						{	type	=	"choice" ,  
							w		=	50 * s ,
							title =	"To Day" ,
							values=	getMonthDaysList( app.stat.to_y , app.stat.to_m ) ,
							active=	function() 
											return ( #app.logFiles > 0 ); 
										end ,
							get	=	function() 
											return math.max( 1, app.stat.to_d ); 
										end , 
							set	=	function(s)
											app.stat.to_d = s;
										end
						}
					}
				}						
				,
				{	type = "box" , 		-- button :: Aggregate
					flexFlow = lvgl.FLOW_ROW , 
					align		= CENTER ,
					w 			= LCD_W * 0.8 ,
					children	=	{			
						{	type = "button" ,
							text = "Flights aggregate" ,
							press=	function()
											app.state = app.STATE.PROCESS_LOG_PERIOD_WAIT_FORM;
										end ,
							active=	function() 
											return ( #app.logFiles > 0 ); 
										end						
						}
					}
				},

				{	type = "box" ,
					children	=	{
						{	type	= "label" ,	-- version number
							align = RIGHT ,
							w		= LCD_W * 0.8 ,
							text	= app.version ,
							color	=	function ()
											if string.find( app.version , "RC" ) == 0 then;
												return COLOR_THEME_PRIMARY2;
											else;
												return COLOR_THEME_WARNING;
											end;
										end,
							font	= SMLSIZE 
						}				
					}
				}
				
				
			}
			
	lvgl.clear()
	
	pageHead( app.STATE.ASK_MODEL_FORM, ui )
	
end

function dispAggregatedData(	logAggregated, modelName , 
										from_y	,	from_m	,	from_d	,
										to_y		,	to_m		,	to_d		 )
	local detailsBatID = "";
	local detailsVisible = false;							

	local function dataBox( label, value )
		local ui 
		local IN_A_ROW = 3
		
		ui	=	{	type		= "box" ,
					flexFlow	= lvgl.FLOW_COLUMN , 
					flexPad	= lvgl.PAD_TINY ,
					w			= ( LCD_W /  IN_A_ROW ) -4 ,
					scrollBar= false, scrollDir = lvgl.SCROLL_OFF, 
					children = {
						{	type	= "rectangle" ,
							thickness= 1 ,
							rounded	= 3 ,
							w			= ( LCD_W /  IN_A_ROW ) - 8 ,
							flexFlow = lvgl.FLOW_COLUMN, flexPad = 0 , 
							scrollBar= false, scrollDir = lvgl.SCROLL_OFF, 
							children	=	{
								{	type	= "label" ,
									text	= label   ,
									align = CENTER  ,
									w		= ( LCD_W /  IN_A_ROW ) - 8 ,
									font	= SMLSIZE
								}
								,
								{	type	= "label" ,
									text	= tostring( value  ) ,
									align = CENTER  ,
									w		= ( LCD_W /  IN_A_ROW ) - 8 ,
									font	= 0
								}
							}
						}
					}
				}
				
		return ui
	end

	lvgl.clear()
		
	ui	=	{
				{	type	= "box" ,		-- head Source
					w		= LCD_W ,
					x		= PAGE_HEAD_HEIGH ,
					y		= 0,
					h		= LCD_H - PAGE_HEAD_HEIGH  ,
					flexFlow	= lvgl.FLOW_COLUMN , flexPad = 0 , 
					scrollBar= true, scrollDir = lvgl.SCROLL_VER, 
					children	=	{
						{	type	= "box" ,
							w		= LCD_W ,
							h		= 20 * lvgl.LCD_SCALE ,
							flexFlow = lvgl.FLOW_ROW , flexPad = 0 , 
							scrollBar= false, 
							align	= CENTER,
							children	=	{
								{	type	= "label" ,
									text	= "Model name : " ,
									font	= SMLSIZE
								}
								,
								{	type	= "label" ,
									text	= modelName .. ",  " ,
									font	= SMLSIZE
								}
								,
								{	type	= "label" ,
									text	= getDateFormatYMD(	from_y,	from_m,	from_d ) .. " - " ..
											  getDateFormatYMD(	  to_y,	  to_m,	  to_d ) ,
									font	= SMLSIZE
								}						
							}
							
							
						}
						,

	-- .countFly
	-- .timeSum
	-- .batteryCount	
						{	type	= "box" ,			-- Data boxes
							w		= LCD_W ,
							-- h		= 60 ,
							flexFlow = lvgl.FLOW_ROW , 
							flexPad	= 0 , 
							scrollBar= false , 
							align	= CENTER ,
							children	=	{
								dataBox( "Flight Count"			, logAggregated.countFly ) ,
								dataBox( "Total flight time"	, logAggregated.timeSum ) ,
								dataBox( "Batteries used"		, logAggregated.batteryCount ) ,  -- AvgFlyTime, AvgMah
							}
						} 						
						,
	-- .timeAvg
	-- .timeMax
	-- .timeMaxDate
						{	type	= "box" ,
							w		= LCD_W ,
							-- h		= 60 ,
							flexFlow = lvgl.FLOW_ROW , 
							flexPad	= 0 , 
							scrollBar= false , 
							align	= CENTER ,
							children	=	{
								dataBox( "Avg flight time"						, logAggregated.timeAvg ) ,
								dataBox( "Longest flight time"				, logAggregated.timeMax ) ,
								dataBox( "Longest flight time date/time"	, logAggregated.timeMaxDate ) 
							}
						} 						
						,
	-- 				.ampSum
	--					.ampMin
	-- .ampAvg
	-- .ampMax
	-- .ampMaxDate
						{	type	= "box" ,
							w		= LCD_W ,
							-- h		= 60 ,
							flexFlow = lvgl.FLOW_ROW , 
							flexPad	= 0 , 
							scrollBar= false , 
							align	= CENTER ,
							children	=	{
								dataBox( "Avg current (A)"				, logAggregated.ampAvg ) ,
								dataBox( "Peak current (A)"			, logAggregated.ampMax ) ,
								dataBox( "Peak current date/time"	, logAggregated.ampMaxDate ) 
							}
						} 						
						,
	-- .mAhSum
	-- .mAhAvg
	
						{	type	= "box" ,
							w		= LCD_W ,
							-- h		= 60 ,
							flexFlow = lvgl.FLOW_ROW , 
							flexPad	= 0 , 
							scrollBar= false , 
							align	= CENTER ,
							children	=	{
								dataBox( "Total used (mAh)"	, logAggregated.mAhSum ) ,
								dataBox( "Avg used (mAh)"	, logAggregated.mAhAvg ) ,
							}
						}
						,
	-- .mAhMax
	-- .mAhMaxDate
						{	type	= "box" ,
							w		= LCD_W ,
							-- h		= 60 ,
							flexFlow = lvgl.FLOW_ROW , 
							flexPad	= 0 , 
							scrollBar= false , 
							align	= CENTER ,
							children	=	{
								dataBox( "Peak current draw (mAh)"	, logAggregated.mAhMax ) ,
								dataBox( "Peak current date/time"		, logAggregated.mAhMaxDate ) 
							}
						} 						


						
	-- KiMaradék
	-- .count
	-- .countWithMaxAmp
	-- .maxBatteryFlyCount
	-- .countWithMah
	-- .timeSumSec
						
					}
				} 

				
			}
	
	pageHead( app.state , ui )
end

function dispAggregatedBatData(	logAggregated, modelName , 
											from_y	,	from_m	,	from_d	,
											to_y		,	to_m		,	to_d		 )

	local	function batLine( batL , batName, maxBatFly )
		local ui 
		local PERCENT_BORDER =  2 * lvgl.LCD_SCALE
		local PERCENT_HEIGHT = 16 * lvgl.LCD_SCALE
		local PERCENT_WIDTH  = 80 * lvgl.LCD_SCALE
		
		ui	=	{	type	=	"box" ,
					scrollBar= false,  scrollDir = lvgl.SCROLL_OFF , 
					flexFlow	= lvgl.FLOW_ROW ,
					align 	= LEFT ,
					flexPad	= lvgl.PAD_SMALL ,
					children	=	{
						{	type	=	"button" ,
							h		=	60 * lvgl.LCD_SCALE,
							press	= 	function(s)
											app.selectedBattery = batName;
											app.state = app.STATE.PROCESS_LOG_PERIOD_VIEW_BATDETAILDATA	;
										end ,
							children = {
								{	type	=	"box" ,	-- Battery box with Line
									scrollBar= false,  scrollDir = lvgl.SCROLL_OFF ,
									flexFlow	= lvgl.FLOW_COLUMN ,
									children = {
										{	type	=	"label"	,
											x		= 40 * lvgl.LCD_SCALE,
											text	=	batName ,
											font	= 0
										}
										,
										{	type	=	"box"	,
											scrollBar= false,  scrollDir = lvgl.SCROLL_OFF ,
											children	= {
												{	type	= "rectangle" ,
													filled= true, 
													thickness= 0 ,
													w			= PERCENT_WIDTH ,
													h			= PERCENT_HEIGHT ,
													color		= WHITE
												}
												,
												{	type	= "rectangle" ,
													filled= false, 
													thickness= PERCENT_BORDER ,
													w			= PERCENT_WIDTH ,
													h			= PERCENT_HEIGHT ,
													color		= BLACK ,
													children	= {
														{	type	= "rectangle" ,
															filled= true, 
															thickness= 0 ,
															w			= ( PERCENT_WIDTH  - PERCENT_BORDER - PERCENT_BORDER ) 
																			/ maxBatFly * batL.count ,
															h			= PERCENT_HEIGHT - PERCENT_BORDER - PERCENT_BORDER ,
															color		= GREEN
														}
													}
												}	
											}
										}
									}
								}	
							}
						}
						,
						{	type	= "box" ,
							scrollBar= false,  scrollDir = lvgl.SCROLL_OFF ,
							flexFlow	= lvgl.FLOW_COLUMN ,
							align		= VCENTER ,
							children = {
								{	type	=	"label"	,
									text	=	"Flight count :" .. batL.countFly ,
									font	= 0
								}
								,
								{	type	=	"label"	,
									text	=	"Flight time :" .. batL.timeSum,
									font	= 0
								}
							}
						
						}
						,
						{	type	= "box" ,
							scrollBar= false,  scrollDir = lvgl.SCROLL_OFF ,
							flexFlow	= lvgl.FLOW_COLUMN ,
							align		= VCENTER ,
							children = {
								{	type	=	"label"	,
									text	=	"Peak current: " .. batL.mAhMax .. " mAh" ,
									font	= 0
								}
								,
								{	type	=	"label"	,
									text	=	"Total usage: " .. batL.mAhSum .. " mAh" ,
									font	= 0
								}
							}
						
						}
					}
					
				}

		
				-- maxAmpDate [string]  => 2026.04.01. 15:02:56
				-- maxAmp [number]  => 230
				-- sumSec [number]  => 52
				-- count [number]  => 4
				-- sumMah [number]  => 1869					
				-- countMah [number]  => 2		
				
				-- avgmAh()
				-- avgTime()
		-- app.d.printAssoc( "batLine ( " .. batName .. ")" , ui )

		return ui
	end
	
	local batUi	= {}
	
	for batName , batData in pairs( logAggregated.Batteries ) do
						
		table.insert(	batUi , 
							batLine( batData , batName , logAggregated.maxBatteryFlyCount  )
						)

	end
	
	lvgl.clear()
		
	ui	=	{
				{	type	= "box" ,				-- Head : DataSource
					w		= LCD_W ,
					x		= PAGE_HEAD_HEIGH ,
					y		= 0,
					h		= LCD_H - PAGE_HEAD_HEIGH  ,
					flexFlow	= lvgl.FLOW_COLUMN , flexPad = 0 , 
					scrollBar= true, scrollDir = lvgl.SCROLL_VER, 
					visible	=	function()
										return not detailsVisible;
									end ,
					children	=	{
						{	type	= "box" ,
							w		= LCD_W ,
							h		= 20  * lvgl.LCD_SCALE,
							flexFlow = lvgl.FLOW_ROW , flexPad = 0 , 
							scrollBar= false, 
							align	= CENTER,
							children	=	{
								{	type	= "label" ,
									text	= "Model name : " ,
									font	= SMLSIZE
								}
								,
								{	type	= "label" ,
									text	= modelName .. ",  " ,
									font	= SMLSIZE
								}
								,
								{	type	= "label" ,
									text	= getDateFormatYMD(	from_y,	from_m,	from_d ) .. " - " ..
											  getDateFormatYMD(	  to_y,	  to_m,	  to_d ) ,
									font	= SMLSIZE
								}						
							}

						}
						,
						{	type	= "box" ,			-- Battery list
							w		= LCD_W ,
							-- h		= 60 ,
							flexFlow = lvgl.FLOW_COLUMN , 
							flexPad	= lvgl.PAD_TINY , 
							scrollBar= false , 
							-- align		= CENTER ,
							children	=	batUi
						} 						
					}
					
				} 				
			}
	
	pageHead( app.state, ui )
end

function dispAggregatedBatDetailsData( logAggregated, modelName , 
													from_y	,	from_m	,	from_d	,
													to_y		,	to_m		,	to_d		,		 
													detailsBatID )
	-- local detailsBatID = "";
	-- local detailsVisible = false;							

	local function dataBox( label, value )
		local ui 
		local IN_A_ROW = 3
		
		ui	=	{	type		= "box" ,
					flexFlow	= lvgl.FLOW_COLUMN , 
					flexPad	= lvgl.PAD_TINY ,
					w			= ( LCD_W /  IN_A_ROW ) -4 ,
					scrollBar= false, scrollDir = lvgl.SCROLL_OFF, 
					children =	{
						{	type	= "rectangle" ,
							thickness= 1 ,
							rounded	= 3 ,
							w			= ( LCD_W /  IN_A_ROW ) - 8 ,
							flexFlow = lvgl.FLOW_COLUMN, flexPad = 0 , 
							scrollBar= false, scrollDir = lvgl.SCROLL_OFF, 
							children	=	{
								{	type	= "label" ,
									text	= label   ,
									align = CENTER  ,
									w		= ( LCD_W /  IN_A_ROW ) - 8 ,
									font	= SMLSIZE
								}
								,
								{	type	= "label" ,
									text	= tostring( value  ) ,
									align = CENTER  ,
									w		= ( LCD_W /  IN_A_ROW ) - 8 ,
									font	= 0
								}
							}
						}
					}
				}
				
		return ui
	end

	
			--- Collected Battery Data --------------
	
				-- NO:ampSum             [number]  => 0
				-- NO:countWithMaxAmp    [number]  => 0
				-- NO:count              [number]  => 1  :: Összes log sor

			-- batName			
			-- countFly           [number]  => 1
			-- ampAvg             [number]  => 0

			-- ampMin             [number]  => 0
			-- ampMax             [number]  => 0
			-- ampMaxDate         [string]  => 

			
			-- mAhAvg             [number]  => 0
			-- mAhMax             [number]  => 0
			-- mAhMaxDate         [string]  => 
			
				-- NO:mAhSum             [number]  => 0
			
				-- NO:countWithMah       [number]  => 0
			
			-- timeAvg            [number]  => 0
			-- timeSum            [string]  => 00:00:05
			
			-- timeMax            [number]  => 5	
			-- timeMaxDate        [string]  => 2026.05.04. 15:41
			
				-- NO:timeSumSec         [number]  => 5
			
				-- NO:maxBatteryFlyCount [number]  => 0
			
			
	batDetailUi =	{
							{	type		= "box" ,
								flexFlow	= lvgl.FLOW_COLUMN , 
								flexPad	= lvgl.PAD_TINY ,								
								-- h			= boxWith -4 ,
								children = {
									{	type	= "box" ,
										flexFlow = lvgl.FLOW_ROW , 
										flexPad	= 0 , 
										scrollBar= false , 
										align	= CENTER ,
										children	=	{
											dataBox( "Battery Id"		, detailsBatID ),
											dataBox( "Flight count"		, logAggregated.Batteries[ detailsBatID ].countFly ) ,
											dataBox( "Avg current"		, logAggregated.Batteries[ detailsBatID ].ampAvg ) 
										}
									} 					
									,
									{	type	= "box" ,
										flexFlow = lvgl.FLOW_ROW , 
										flexPad	= 0 , 
										scrollBar= false , 
										align	= CENTER ,
										children	=	{
											dataBox( "Lowest peak current"	, logAggregated.Batteries[ detailsBatID ].ampMin ),
											dataBox( "Highest peak current"	, logAggregated.Batteries[ detailsBatID ].ampMax ) ,
											dataBox( "Highest current date"	, logAggregated.Batteries[ detailsBatID ].ampMaxDate ) 
										}
									} 					
									,
									{	type	= "box" ,
										flexFlow = lvgl.FLOW_ROW , 
										flexPad	= 0 , 
										scrollBar= false , 
										align	= CENTER ,
										children	=	{
											dataBox( "Avg current draw"	, logAggregated.Batteries[ detailsBatID ].mAhAvg ),
											dataBox( "Peak current"			, logAggregated.Batteries[ detailsBatID ].mAhMax ) ,
											dataBox( "Peak current date"	, logAggregated.Batteries[ detailsBatID ].mAhMaxDate ) 
										}
									}									
									,
									{	type	= "box" ,
										flexFlow = lvgl.FLOW_ROW , 
										flexPad	= 0 , 
										scrollBar= false , 
										align	= CENTER ,
										w 			= LCD_W - 8 ,
										children	=	{
											dataBox( "Avg flight duration"		, logAggregated.Batteries[ detailsBatID ].timeAvg ),
											dataBox( "Total flight duration"	, logAggregated.Batteries[ detailsBatID ].timeSum ) 
										}
									}									-- {	type	= "box" ,
									,
									{	type	= "box" ,
										flexFlow = lvgl.FLOW_ROW , 
										flexPad	= 0 , 
										scrollBar= false ,
										w 			= LCD_W - 8 ,
										align	= CENTER ,
										children	=	{
											dataBox( "Longest flight"				, logAggregated.Batteries[ detailsBatID ].timeMax ),
											dataBox( "Date of longest flight"	, logAggregated.Batteries[ detailsBatID ].timeMaxDate ) 
										}
									}	
 					
								}
							}	
						}
								

	lvgl.clear()

		
	ui	=	{
				{	type	= "box" ,				-- Head : DataSource
					w		= LCD_W ,
					x		= PAGE_HEAD_HEIGH ,
					y		= 0,
					h		= LCD_H - PAGE_HEAD_HEIGH  ,
					flexFlow	= lvgl.FLOW_COLUMN , flexPad = 0 , 
					scrollBar= true, scrollDir = lvgl.SCROLL_VER, 
					-- visible	=	function()
										-- return not detailsVisible;
									-- end ,
					children	=	{
						{	type	= "box" ,
							w		= LCD_W ,
							-- h		= 20 ,
							flexFlow = lvgl.FLOW_ROW , flexPad = 0 , 
							scrollBar= false, 
							align	= CENTER,
							children	=	{
								{	type	= "label" ,
									text	= "Model name : " ,
									font	= SMLSIZE
								}
								,
								{	type	= "label" ,
									text	= modelName .. ",  " ,
									font	= SMLSIZE
								}
								,
								{	type	= "label" ,
									text	= getDateFormatYMD(	from_y,	from_m,	from_d ) .. " - " ..
											  getDateFormatYMD(	  to_y,	  to_m,	  to_d ) ,
									font	= SMLSIZE
								}						
							}
							
							
						}
						,
						{	type	= "box" ,			-- Battery list
							w		= LCD_W ,
							-- h		= 60 ,
							flexFlow = lvgl.FLOW_COLUMN , 
							flexPad	= lvgl.PAD_TINY , 
							scrollBar= false , 
							-- align		= CENTER ,
							children	=	batDetailUi
						} 						
					}
				} 

				
			}
	
	pageHead( app.state , ui )
end

-- #################### Log Views 

function dispLog_MonthsList( logDates , cfgModels )
	local DAYS_IN_ROW = 4
	local ui
	local uiYMD	= {}
	
	-- app.d.printAssoc( "dispLog_MonthsList() - logDates"  , logDates )
	-- app.d.printAssoc( "dispLog_MonthsList() - cfgModels" , cfgModels )
	
	app.logSelected_logDatesIDX = 0
	
	-- ************** for model select ***********************************
	local aModelNames = {}
	local aModelSorsz2Name	= {} 
	local aName2ModelSorsz = {} 
	local sorsz = 0
	
	for k ,v  in pairs( cfgModels	) do
		table.insert( aModelNames	, v.name )
		
		sorsz = sorsz + 1
		aName2ModelSorsz[ v.name ]	= sorsz
		aModelSorsz2Name[ sorsz ]	= v.name
		
	end
	-- *******************************************************************
	-- app.logFiles	=	{}		--	[1] = FileName
	-- app.logDates	=	{}		-- [1] =	{	ym = "YYYYMM" , d = "DD" }
	
	local function YM( aDate )
		return string.format( "%04d-%02d",  aDate.y,  aDate.m )
	end
	local function isYM_Equal( aA_Day , aB_Day )
		return ( aA_Day.y == aB_Day.y and aA_Day.m == aB_Day.m ) 
	end


	-- Ha nincs log file, akkor hiba üzenet készül.
	if #app.logFiles == 0 then
	
		-- app.d.printAssoc( "dispLog_MonthsList(), #app.logFiles" , app.logFiles )
	
		uiYMD	=	{{	type	= "label" ,
						w		= LCD_W * .95 ,
						align = CENTER ,
						text	= "This model does not have any log file."
					}}
	else
		

	-- ************************************************************************************************	
	-- ************************************************************************************************	

		local wYM
		local cdID

		showYM	= {}
		
		uiRow		= {}
		aDaysRow = {}
		uiMonth_DayLines	= {}

		countAllDays	= 0
		countMonthDays = 0
		currentDayID	= 1

		wYM	=	app.logDates[ 1 ]
		
		repeat

			-- ###################### Days ##################

			wM = app.logDates[ currentDayID ]	-- ymd
			
			-- app.d.log( "currentDayID" , currentDayID , "dispLog_MonthsList()" )
			-- app.d.printAssoc( "app.logDates[ currentDayID ]" , app.logDates[ currentDayID ] )
			
			countMonthDays = 0
			repeat				-- Napok a hónapban
			
			

				-- Create Button --
				local cdID = currentDayID
				uiB =	{	type	= "button" ,
							w		= ( LCD_W * .9 ) / 4,
							h		= 40 * lvgl.LCD_SCALE ,
							cornerRadius	= 8,
							text	=	getDateFormatYMD(	app.logDates[ currentDayID ].y , 
																app.logDates[ currentDayID ].m ,
																app.logDates[ currentDayID ].d  ) ,
							press	=	function()
											-- app.logSelectedDate.y = app.logDates[ currentDayID ].y
											-- app.logSelectedDate.m = app.logDates[ currentDayID ].m
											-- app.logSelectedDate.d = app.logDates[ currentDayID ].d
											app.logSelected_logDatesIDX = cdID
											
											app.state = app.STATE.PROCESS_LOG_DAY_VIEW
											
										end
						}

				countMonthDays	= countMonthDays + 1
				table.insert( aDaysRow , uiB )

				-- ROW full, make a new LineInMonth		
				if #aDaysRow == DAYS_IN_ROW then										-- Row Full
					
					uiRow	=	{	type	=	"box", flexFlow	= lvgl.FLOW_ROW , flexPad = 0 , 
									w		= LCD_W * .95 ,
									align	=	CENTER,
									children	=	aDaysRow
								}
					
					table.insert( uiMonth_DayLines , uiRow )
					aDaysRow = {}
					
				end

				currentDayID	= currentDayID + 1

			until app.logDates[ currentDayID ] == nil or  
					not isYM_Equal( wM , app.logDates[ currentDayID ] )	-- adott hónap napjai

			-- Maradt nap amit nem írtam fel a ... nincs még sora..
			if #aDaysRow > 0 then

				uiRow	=	{	type	=	"box", flexFlow	= lvgl.FLOW_ROW , flexPad = 0 , 
								w		= LCD_W * .95 ,
								align	=	CENTER,
								children	=	aDaysRow
							}
				
				table.insert( uiMonth_DayLines , uiRow )
				aDaysRow = {}
				
			end

			-- #################### END Days ##################
			-- NEW of month,
				
			local ym	=	string.format( "%04d-%02d" ,	wYM.y	, wYM.m 	 )
			showYM[ ym ] = false
			
			uiYearMonth	=	{	type		=	"box", flexFlow	= lvgl.FLOW_COLUMN , flexPad = 0 , 
									w			= LCD_W ,
									children	=	{
										{	type		=	"button" ,
											cornerRadius = 4,
											w			=	LCD_W * .95 ,
											children	=	{
												{	type	=	"label" ,
													x		= 100 * lvgl.LCD_SCALE ,
													w		= 120 * lvgl.LCD_SCALE ,
													align	= LEFT ,
													text	=	getDateFormatYMD( wYM.y, wYM.m ) ,
												},
												{	type	=	"label" ,
													x		= 200 * lvgl.LCD_SCALE ,
													w		= 120 * lvgl.LCD_SCALE ,
													text	=	"Flight days : " ,
												},
												{	type	=	"label" ,
													x		= 280 * lvgl.LCD_SCALE ,
													w		= 30 * lvgl.LCD_SCALE ,
													align	= RIGHT ,
													text	=	countMonthDays 
												},
											} ,
											press		=	function()
																showYM[ym] = not showYM[ym];
															end
										},
										{	type		=	"box", flexFlow	= lvgl.FLOW_COLUMN , flexPad = 0 , 
											align		=	CENTER,
											visible	=	function()
																return ( showYM[ym] );
															end,
											children	=	uiMonth_DayLines
										}
									}
								}	

			
			table.insert( uiYMD , uiYearMonth )

			wYM = app.logDates[ currentDayID ]
			uiMonth_DayLines = {}

		until app.logFiles[ currentDayID ] == nil
		
	end	-- END : app.logFiles is not empty


-- ************************************************************************************************	
-- ************************************************************************************************	

	-- error( "dispLog_MonthsList " )
	
	-- app.d.printAssoc( "dispLog_MonthsList() - aModelNames" , aModelNames )
	-- app.d.printAssoc( "dispLog_MonthsList() - aName2ModelSorsz" , aName2ModelSorsz )
	-- app.d.printAssoc( "dispLog_MonthsList() - aModelSorsz2Name" , aModelSorsz2Name )
	
	ui	=	{
				{	type = "box" ,		-- model select
					flexFlow = lvgl.FLOW_ROW , 
					w			= LCD_W * .95 ,
					align		= CENTER ,
					children	=	{
						{	type	= "label", 
							w		= 95 * lvgl.LCD_SCALE ,
							text	= "Model name " 
						} ,
						{	type	= "choice",  
							w		= 260 * lvgl.LCD_SCALE,
							title = "Select model",
							values=	aModelNames ,
							get	=	function() 
											return aName2ModelSorsz[ app.selectedCfgModel_Name ]; 
										end , 
							set	=	function(s)
											app.selectedCfgModel_Name = aModelSorsz2Name[ s ];
											app.state = app.STATE.PROCESS_LOG_MONTHSLIST_VIEW;
										end
						} 
					}
				} ,
				{	type	= "box" ,
					-- w		= LCD_W * .96,
					x		= PAGE_HEAD_HEIGH ,
					y		= 0,
					flexFlow	= lvgl.FLOW_COLUMN , flexPad = 0 , 
					-- scrollBar= true, scrollDir = lvgl.SCROLL_VER, 
					children	=	uiYMD
				}
			}

	lvgl.clear()
	
	pageHead( app.state , ui )
end

function dispLog_Day( logTable, modelName, aPrevDay, aNextDay, aLogDay )
	local sPrevDay = "" 
	local sNextDay = ""
	local sLogDay = ""

	-- app.d.printAssoc( "aLogDay" , aLogDay  )
	-- app.d.log( "modelName" ,modelName  , "dispLog_Day()" )
	
	sLogDay	= getDateFormatYMD( aLogDay.y, aLogDay.m, aLogDay.d )

	if aPrevDay.id ~= nill then
		sPrevDay	= "< " .. getDateFormatYMD( aPrevDay.y, aPrevDay.m, aPrevDay.d )
	end
	if aNextDay.id ~= nill then
		sNextDay	= getDateFormatYMD( aNextDay.y, aNextDay.m, aNextDay.d ) .. " >"
	end

	-- app.d.log( "sPrevDay" , sPrevDay , "dispLog_Day()" )
	-- app.d.log( "sNextDay" , sNextDay , "dispLog_Day()" )
	-- app.d.printAssoc( "aPrevDay" , aPrevDay  )
	-- app.d.printAssoc( "aNextDay" , aNextDay  )
		
	local function logLineButton_Create( logLine, logLineID )
		local BTN_HEIGHT = 32 * lvgl.LCD_SCALE	
		local BTN_WIDTH = LCD_W * 0.9	
		
		
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
	
		-- app.d.log( " logLine.startFly" , logLine.endFly  , "dispLogList" )
		ui =	{
					type	= "button",
					w		= BTN_WIDTH , 
					h		= BTN_HEIGHT, 
					press	=	(	
									function() 
										app.state = app.STATE.PROCESS_LOG_LINE_VIEW;
										app.selectedLogLine_ID = logLineID;

									end
								) ,
					children	=	{
										{
											type	= "box" , -- full Button
											-- x		= 0 , 
											-- y		= 0 , 
											w		= ( BTN_WIDTH	- 15 ) * lvgl.LCD_SCALE , 
											h		= ( BTN_HEIGHT	-  5 ) * lvgl.LCD_SCALE	, 
											align = LEFT ,
											flexFlow	= lvgl.FLOW_ROW	,
											flexPad	= 0 ,
											scrollBar= false,  scrollDir = lvgl.SCROLL_OFF ,
											-- clickable= false	,
											children	=	{
																{	type	= "label", 
																	w		= 40 * lvgl.LCD_SCALE,
																	text	= logLineID .. ". ",
																} ,
																{	type	= "label", 
																	w		= 80 * lvgl.LCD_SCALE,
																	text	= getDateTimeStr( logLine.startFly , DTF.FORMAT_TIME )
																} ,
																{	type	= "label", 
																	w		= 90 * lvgl.LCD_SCALE,
																	text	= logLine.batteryID 
																} ,
																{	type	= "label", 
																	w		= 40 * lvgl.LCD_SCALE,
																	text	= logLine.flyTime
																} ,
																{	type	= "label", 
																	w		= 80 * lvgl.LCD_SCALE,
																	align	= RIGHT,
																	text	= logLine.mAmpFly .. " mA"
																} ,
																{	type	= "label", 
																	w		= 80 * lvgl.LCD_SCALE,
																	align	= RIGHT,
																	text	= logLine.maxAmp .. " Amp"
																} 
											}
												
										}
					}
				} 		
	
		return ui
	end

	local logLinesUI	= {}
	local logID			= 0

	for _, logLine in ipairs( logTable ) do
		logID = logID + 1
		table.insert( logLinesUI ,logLineButton_Create( logLine, logID ) )

	end	

	local btnH, btnW
	
	btnH =  28 * lvgl.LCD_SCALE
	btnW = 100 * lvgl.LCD_SCALE

	ui	=	{
				{	type = "box" ,		-- model name & buttons
					flexFlow = lvgl.FLOW_ROW , 
					-- w			= LCD_W , --  * .95 ,
					align		= CENTER ,
					children	=	{
						{	type	= "rectangle" ,
							w		= LCD_W  ,
							h		= 40 ,
							flexFlow = lvgl.FLOW_ROW , flexPad = 0 , 
							scrollBar= false , 
							align		= CENTER ,
							children	=	{
								{	type	= "button" ,
									w		= btnW ,
									h		= btnH ,
									text	= sPrevDay ,
									font	= 	SMLSIZE ,
									visible	=	function()
														return sPrevDay ~= "";
													end ,
									press		=	function()
														app.logSelected_logDatesIDX = aPrevDay.id;
														app.state = app.STATE.PROCESS_LOG_DAY_VIEW;
													end
									--press
								},
								{	type	= "label" ,
									w		= 240 * lvgl.LCD_SCALE ,
									text	= modelName .. " at " .. sLogDay,
									align	= CENTER,
									font	= SMLSIZE
								},
								{	type	= "button" ,
									w		= btnW ,
									h		= btnH ,
									text	= sNextDay ,
									font	= 	SMLSIZE ,
									visible	=	function()
														return sNextDay ~= "";
													end ,
									press		=	function()
														app.logSelected_logDatesIDX = aNextDay.id;
														app.state = app.STATE.PROCESS_LOG_DAY_VIEW;
													end
								}	
							}
						}			
					}
				} ,
				{	type	= "box" ,			-- Log Flights list
					w		= LCD_W ,
					-- h		= 60 ,
					flexFlow = lvgl.FLOW_COLUMN , 
					flexPad	= lvgl.PAD_TINY , 
					scrollBar= false , 
					-- align		= CENTER ,
					children	=	logLinesUI
				} 		
				
			}	

	lvgl.clear()
	
	pageHead( app.state , ui )
end

function disp_LogLine( logLine , modelName )

	local function dataBox( label, value, inRow )
		local ui 
		local calcW = ( ( LCD_W -8 ) /  inRow ) - ( inRow * 2 )
		
		ui	=	{	type		= "box" ,
					flexFlow	= lvgl.FLOW_COLUMN , 
					flexPad	= lvgl.PAD_TINY ,
					w			= ( ( LCD_W - 8 ) /  inRow ) - ( inRow ) ,
					scrollBar= false, scrollDir = lvgl.SCROLL_OFF, 
					children =	{
						{	type	= "rectangle" ,
							thickness= 1 ,
							rounded	= 3 ,
							w			= calcW ,
							flexFlow = lvgl.FLOW_COLUMN, flexPad = 0 , 
							scrollBar= false, scrollDir = lvgl.SCROLL_OFF, 
							children	=	{
								{	type	= "label" ,
									text	= label   ,
									align = CENTER  ,
									w		= calcW -2 ,
									font	= SMLSIZE
								}
								,
								{	type	= "label" ,
									text	= tostring( value  ) ,
									align = CENTER  ,
									w		= calcW -2 ,
									font	= 0
								}
							}
						}
					}
				}
				
		return ui
	end

	-- == log fields ==
	-- 	maxAmp => 384
	-- 	mAmpFly => 1061
	-- 	flyTime => 00:03
	-- 	startCount => 248
	-- 	endFly => 20260312143939
	-- 	startBatPercent => 0
	-- 	batteryID => A12345
	-- 	batteryProduct => HRB1234567
	-- 	endBatPercent => 0
	-- 	endBatVolt => 0.0
	--		startBatVolt => 0.0
	-- 	startFly => 20260312143935
			
	flightUi =	{
							{	type		= "box" ,
								flexFlow	= lvgl.FLOW_COLUMN , 
								flexPad	= lvgl.PAD_TINY ,								
								-- h			= boxWith -4 ,
								children = {
									{	type	= "box" ,
										flexFlow = lvgl.FLOW_ROW , 
										flexPad	= 0 , 
										scrollBar= false , 
										align	= LEFT ,
										children	=	{
											dataBox( "Begin of flight"	, getDateTimeStr( logLine.startFly , DTF.FORMAT_DATE_TIME_SEC ) , 2 ),
											dataBox( "Duration"			, logLine.flyTime, 4 ) ,
											dataBox( "Initial charge"	, logLine.startBatPercent .."%", 4 ) ,
										}
									} 					
									,
									{	type	= "box" ,
										flexFlow = lvgl.FLOW_ROW , 
										flexPad	= 0 , 
										scrollBar= false , 
										align	= LEFT ,
										children	=	{
											dataBox( "End of flight"	, getDateTimeStr( logLine.endFly , DTF.FORMAT_DATE_TIME_SEC ) , 2 ) ,
											dataBox( "Peak current"		, logLine.maxAmp  , 4 ) ,
											dataBox( "Final charge"		, logLine.endBatPercent.."%", 4 ) 
										}
									} 					
									,
									{	type	= "box" ,
										flexFlow = lvgl.FLOW_ROW , 
										flexPad	= 0 , 
										scrollBar= false , 
										align	= LEFT ,
										children	=	{
											dataBox( "Used charge (mAh)"		, logLine.mAmpFly , 3 ) ,
											dataBox( "Initial level (V)"		, logLine.startBatVolt .. " V" , 3 ) ,
											dataBox( "Final level (V)"			, logLine.endBatVolt .. " V" , 3 ) 
										}
									} 					
									,
									{	type	= "box" ,
										flexFlow = lvgl.FLOW_ROW , 
										flexPad	= 0 , 
										scrollBar= false , 
										align	= LEFT ,
										children	=	{
											dataBox( "Battery Id"		, logLine.batteryID , 3 ) ,
											dataBox( "Manufacturer"		, logLine.batteryProduct  , 3 ) ,
											dataBox( "Flight count"		, logLine.startCount , 3 ) 
										}
									} 					

								}
							}
						}
								

	lvgl.clear()

		
	ui	=	{
				{	type	= "box" ,				-- Head : DataSource
					w		= LCD_W ,
					-- x		= PAGE_HEAD_HEIGH  * lvgl.LCD_SCALE,
					-- y		= 0,
					h		= LCD_H - ( PAGE_HEAD_HEIGH  * lvgl.LCD_SCALE ) ,
					flexFlow	= lvgl.FLOW_COLUMN , flexPad = 0 , 
					scrollBar= true, scrollDir = lvgl.SCROLL_VER, 
					children	=	{
						{	type	= "box" ,
							w		= LCD_W ,
							-- h		= 20 ,
							flexFlow = lvgl.FLOW_ROW , flexPad = 0 , 
							scrollBar= false, 
							scrollBar= false, 
							align	= CENTER,
							children	=	{
								{	type	= "button" ,
									text	= "<< Back " ,
									w		= 100 * lvgl.LCD_SCALE ,
									font	= SMLSIZE ,
									press	=	(	
													function() 
														app.state = app.STATE.PROCESS_LOG_DAY_VIEW;
														app.selectedLogLine_ID = 0;
													end
												) ,									
								}
								,
								{	type	= "label" ,
									text	= "    Model name: " ,
									font	= SMLSIZE
								}
								,
								{	type	= "label" ,
									text	= modelName,
									font	= SMLSIZE
								}
							}
						}
						,
						{	type	= "box" ,			-- Flight data
							w		= LCD_W ,
							-- h		= 60 ,
							flexFlow = lvgl.FLOW_COLUMN , 
							flexPad	= lvgl.PAD_TINY , 
							scrollBar= false , 
							children	= flightUi
						} 						
					}
				} 

				
			}

	lvgl.clear()
	pageHead( app.state , ui )
end

-- #################### Batteries 

function dispBatList( batList )
	local ui, batUi
	local cellList	=	{}
	local cL = {}
	local batState = { "All" , "In Use" , "Retired" }
	
	batUi = {}
	
	local function batLine( aBat )
		local ui
		
		-- earlyCount [number]  => 20
		-- id [string]  => C1-001
		-- product [string]  => RASEP
		-- firstStartDate [string]  => 20190909000000
		-- maxVolt [number]  => 4.2
		-- capacity [number]  => 5000
		-- lastStartDate [string]  => 20260817152112
		-- retireDate [string]  => 
		-- cells [number]  => 12
		-- maxCapacity [number]  => 5600
		-- count [number]  => 25
		
		local btnH = 26 * lvgl.LCD_SCALE

		ui	=	{	type	= "rectangle" ,
					flexFlow = lvgl.FLOW_ROW , flexPad	= 0 , 
					scrollBar= false , scrollDir= 0,
					h		= 66 * lvgl.LCD_SCALE ,
					align	= LEFT + VCENTER,
					
					thickness = 2 ,
					color = COLOR_THEME_PRIMARY1,
					-- , filled = true,  
					rounded	= 6, 
					-- color		= COLOR_THEME_PRIMARY2, COLOR_THEME_SECONDARY1
					children	=	{
						{	type	= "box" , flexFlow	= lvgl.FLOW_COLUMN,	flexPad	= 0 , align	= LEFT,
							children	=	{
								{	type	= "box" , flexFlow	= lvgl.FLOW_ROW,	flexPad	= 0 ,align	= LEFT,
									children	=	{
										{	type	= "label" ,
											w 		= 80 * lvgl.LCD_SCALE ,
											align	= LEFT,
											text	= aBat.id
										},
										{	type	= "label" ,
											w 		= 110 * lvgl.LCD_SCALE ,
											align	= RIGHT,
											text	= aBat.maxCapacity .. " mAh " 
										}
									}
								} ,
								{	type	= "box" , flexFlow	= lvgl.FLOW_ROW,	flexPad	= 0 ,	align	= LEFT,
									children	=	{
										{	type	= "label" ,
											text	= aBat.product ,
											w 		= 120 * lvgl.LCD_SCALE ,
											align	= LEFT,
										},
										{	type	= "label" ,
											w 		= 40 * lvgl.LCD_SCALE ,
											align	= RIGHT,
											text	= aBat.cells .. " S" 
										}
									}
								} 
							}
						},
						{	type	= "box" , flexFlow	= lvgl.FLOW_COLUMN,	flexPad	= 0 ,	align	= LEFT,
							children	=	{
								{	type	= "box" , flexFlow	= lvgl.FLOW_ROW,	flexPad	= 0 ,	align	= LEFT,
									children	=	{
										{	type	= "button" ,
											text	= "Edit" ,
											h		= btnH,
											press=	function()
															app.state = app.STATE.PROCESS_BATTERY_EDIT;
															app.editedBatId = aBat.id;
														end
										},
										{	type	= "button" ,
											text	= "Assign to models" ,
											h		= btnH,
											press=	function()
															app.state = app.STATE.PROCESS_BATTERY_ASSIGN;
															app.editedBatId = aBat.id;
														end
										}
									}	
								},
								{	type	= "box" , flexFlow	= lvgl.FLOW_ROW,	flexPad	= 0 ,	align	= CENTER ,
									children	=	{
								
										{	type	= "button" ,			-- Retire
											y		= 80 * lvgl.LCD_SCALE ,
											text	= "Retire battery (Delete)" ,
											h		= btnH,
											visible	=	function()
																if aBat.retireDate == "" then;
																	return true;
																else;
																	return false;
																end;
															end,							
											press	=	function()
															app.state = app.STATE.PROCESS_BATTERY_RETIRE;
															app.editedBatId = aBat.id ;
														end,
											
										},
										{	type	= "button" ,			-- Retire
											y		= 80 * lvgl.LCD_SCALE ,
											text	= "Back To Use (UnDelete)" ,
											visible	=	function()
																if aBat.retireDate ~= "" then;
																	return true;
																else;
																	return false;
																end;
															end,							
											press	=	function()
															app.state = app.STATE.PROCESS_BATTERY_RETIRE;
															app.editedBatId = aBat.id;
														end,
											
										}
									}
								}
								
							}
						}
					}
				}
				
		return ui
	end

	-- Filters
	for _, aBat in ipairs( batList ) do

		if ( app.batFilter.state == app.STATE_FILTER.INUSE and aBat.retireDate == ""  ) or 
			( app.batFilter.state == app.STATE_FILTER.RETIRED and aBat.retireDate ~= ""  ) or 
			( app.batFilter.state == app.STATE_FILTER.ALL ) then

			cL[ aBat.cells ] = aBat.cells 

			if (	app.batFilter.cell == 0 or		-- 0 = All
					app.batFilter.cell == aBat.cells )	then
				
				table.insert( batUi , batLine( aBat ) )
				
			end
			
		end

	end

	table.insert( cellList, "All" )		
	for _, v in pairs(cL) do
		table.insert( cellList, v )
	end

	ui	= 	{
				{	type	= "box" ,
					w		= LCD_W ,
					x		= PAGE_HEAD_HEIGH  * lvgl.LCD_SCALE,
					y		= 0,
					h		= LCD_H - ( PAGE_HEAD_HEIGH  * lvgl.LCD_SCALE ) ,
					flexFlow	= lvgl.FLOW_COLUMN , flexPad = 0 , 
					scrollBar= true, scrollDir = lvgl.SCROLL_VER, 
					children	=	{
						{	type	=	"rectangle", flexFlow	=	lvgl.FLOW_ROW,
							thickness = 0 ,
							h		= 40 * lvgl.LCD_SCALE,
							w		=	LCD_W * .98,
							align	=	CENTER,
							children	=	{
								{	type	=	"label",
									text	=	"Cells: "
								},
								{
									type	=	"choice" ,
									values=	cellList ,
									title = "Select cell filter" , 
									get	=	function()
													return app.batFilter.cell + 1; 
												end , 
									set	= 	function(v)
													if v == 1 then;		-- = All
														app.batFilter.cell = 0;
													else;
														app.batFilter.cell = cellList[ v ];
													end;
													app.state = app.STATE.PROCESS_BATTERY_LIST_VIEW;
												end
								},
								{	type	=	"label",
									text	=	"  Status: "
								},
								{
									type	=	"choice" ,
									values=	batState ,
									title	=	"Battery status filter" ,
									get	=	function()
													return app.batFilter.state; 
												end , 
									set	= 	function(v)
													app.batFilter.state = v;
													app.state = app.STATE.PROCESS_BATTERY_LIST_VIEW;
												end;								
								},
								{	type	=	"label",
									text	=	string.format( "  Listed: %2d/%2d" ,#batUi , #batList )
								},
								{	type = "button", 
									text = "Add Battery" ,
									w = 100 * lvgl.LCD_SCALE , 
									-- h = btnHeigh ,
									press =	function() 
													app.state = app.STATE.PROCESS_BATTERY_ADD; 
												end
								}
								
							}
						},
						-- Batteries
						{	type	= "box" ,			 
							w		= LCD_W ,
							-- h		= 60 ,
							flexFlow = lvgl.FLOW_COLUMN , 
							flexPad	= lvgl.PAD_TINY , 
							scrollBar= false , 
							children	= batUi
						} 						
					}
				} 
	
			}
			
	lvgl.clear()
	
	pageHead( app.state , ui )
end

function dispBat_AddEdit( aBat , rowID )
	local ui, voltDec
	local labelWidth, lineHeight, labelY, buttonW

	errorList	=	{}
	errorList.product	= false
	
	local function isError()

		for k , v in pairs( errorList ) do
--			app.d.log( "isError() in " .. k , v , "dispBatEdit()" )
			if v then
				return true
			end
		end

	end

	-- Volt Table
	voltTable = { 4.2 , 4.35, 4.40 }
	local function table2Volt( id )
		return voltTable[ id ]
	end	
	local function volt2Table( volt )
		for i , v in pairs( voltTable ) do
			if v == volt then
				return i
			end
		end
		return 0
	end

	local function saveBat()

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
		
		batFile.readCsv( app.appFolder .. "batfiles/batteries.csv" )	
		batFile.updateRow( rowID , aBat )
		batFile.writeCsv()
		
	end
	local function addBat()

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
		
		batFile.readCsv( app.appFolder .. "batfiles/batteries.csv" )	
		batFile.addRow( aBat )
		batFile.writeCsv()
		
	end

	-- ID check
	
	batList  = {}
	if rowID == 0 then
	
		local batFile
	
		batFile  =	loadScript( app.appFolder .. "csvfile.lua")()
		batFile.readCsv( app.appFolder .. "batfiles/batteries.csv" )	
		batList	= batFile.getTable()
	
	end

	local function chkID( newID )

		errorList.id	= false
							
		if string.len( aBat.id ) < 1 then
			errorList.id	= true
		else
		
			for i , v in pairs( batList ) do
				if v.id == newID then
					errorList.id	= true
					break
				end
			end
		
		end
		
		return errorList.id
		
	end
	
	-- Label Width
	labelWidth	= 100 * lvgl.LCD_SCALE
	lineHeight	=  36 * lvgl.LCD_SCALE
	labelY		=   8 * lvgl.LCD_SCALE
	buttonW		=  42 * lvgl.LCD_SCALE
	buttonH		=  28 * lvgl.LCD_SCALE
	buttonY		=   2 * lvgl.LCD_SCALE
	
	ui	=	{
				{	type		= "rectangle" ,
					flexFlow = lvgl.FLOW_COLUMN , 
					flexPad	= 0 , 
					scrollBar= false , 
					w			= LCD_W *.9 ,
					align		= LEFT ,
					rounded	= 5,
					children	=	{	
										-- ID
						{	type	= "box" , h	= lineHeight ,	align	= LEFT,
							children	=	{				
										{	type	= "label" ,
											w 		= labelWidth ,
											y		= labelY ,
											text	= "Battery ID"
										},
										{	type	= "textEdit" , 
											w		= 70 * lvgl.LCD_SCALE,
											x		= labelWidth,
											active=	function()
															if rowID == 0 then;
																return true;
															else
																return false;
															end;
														end,
											length= 6,
											value	= aBat.id,
											set	=	function(v)
															aBat.id = v;
														end
										}										
							}
						} 
						,				-- ID ERROR
						{	type	= "box" , align	= LEFT,
							visible =	function()		
												return chkID( aBat.id );
											end ,
							children	=	{
										{	type	= "label" ,
											x		= labelWidth,
											font	= SMLSIZE ,
											color	= COLOR_THEME_WARNING ,
											text	= "ID can't be empty and must be unique!"
										}
							}
						}
						,				-- Product
						{	type	= "box" , h	= lineHeight, align	= LEFT,
							children	=	{
										{	type	= "label" ,
											w 		= labelWidth ,
											y		= labelY ,
											text	= "Product"
										},
										{	type	= "textEdit" , 
											w		= 130 * lvgl.LCD_SCALE,
											x		= labelWidth,
											length= 12,
											value	= aBat.product,
											set	=	function(v)
															aBat.product = v;
														end
										}
							}
						}
						,				-- Product ERROR
						{	type	= "box" , align	= LEFT,
							visible =	function()		
												-- app.d.log( "string.len( aBat.product )" , string.len( aBat.product ) , "dispBatEdit()" )
												if string.len( aBat.product ) < 1 then
													errorList.product	= true;
													return true;
												else;
													errorList.product	= false;
													return false;
												end;
											end ,
							children	=	{
										{	type	= "label" ,
											x		= labelWidth,
											font	= SMLSIZE ,
											color	= COLOR_THEME_WARNING ,
											text	= "Product name can't be empty!"
										}
							}
						}
						,				-- maxCapacity
						{	type	= "box" , h	= lineHeight, align	= LEFT,
							children	=	{
										{	type	= "label" ,
											w 		= labelWidth ,
											y		= labelY ,
											text	= "Capacity"
										},
										{	type	=	"button" ,
											text	=	"-1000",
											font	= 	SMLSIZE ,
											x		=	labelWidth ,
											y		=	buttonY ,
											w		=	buttonW,
											h		=	buttonH ,
											press	=	function()
															if ( aBat.maxCapacity - 1000 ) > 0 then;
																aBat.maxCapacity = aBat.maxCapacity - 1000;
															end;
														end;
										},
										{	type	=	"button" ,
											text	=	"-100",
											font	= 	SMLSIZE ,
											x		=	labelWidth + buttonW ,
											y		=	buttonY ,
											w		=	buttonW ,
											h		=	buttonH ,
											press	=	function()
															if ( aBat.maxCapacity - 100 ) > 0 then;
																aBat.maxCapacity = aBat.maxCapacity - 100;
															end;
														end;
										},
										{	type	= "numberEdit" , 
											w		= 60 * lvgl.LCD_SCALE,
											x		= labelWidth + ( buttonW * 2 ),
											min	= 1 ,
											max	= 99999 ,
											get	=	function()
															return aBat.maxCapacity;
														end,
											edited=	function( newValue )
															aBat.maxCapacity = newValue;
														end,
											set	=	function( newValue )
															aBat.maxCapacity = newValue;
														end
										},
										{	type	= "label" ,
											x		= labelWidth + ( buttonW * 2 ) + 60 * lvgl.LCD_SCALE,
											w		= 45 * lvgl.LCD_SCALE,
											y		= labelY ,
											font	= 	SMLSIZE ,
											text	= "mAmp"
										},
										{	type	=	"button" ,
											text	=	"+100",
											font	= 	SMLSIZE ,
											x		=	labelWidth + ( buttonW * 2 ) + ( (60+45) * lvgl.LCD_SCALE ) ,
											y		=	buttonY ,
											w		=	buttonW ,
											h		=	buttonH ,
											press	=	function()
															if ( aBat.maxCapacity + 100 ) < 99999 then;
																aBat.maxCapacity = aBat.maxCapacity + 100;
															end;
														end;
										},
										{	type	=	"button" ,
											text	=	"+1000",
											font	= 	SMLSIZE ,
											x		=	labelWidth + ( buttonW * 3 ) + ( (60+45) * lvgl.LCD_SCALE ) ,
											y		=	buttonY ,
											w		=	buttonW ,
											h		=	buttonH ,
											press	=	function()
															if ( aBat.maxCapacity + 1000 ) < 99999 then;
																aBat.maxCapacity = aBat.maxCapacity + 1000;
															end;
														end;
										},
										
							}
						} 
						,				-- capacity => Usable capacity
						{	type	= "box" , h	= lineHeight, align	= LEFT,
							children	=	{
										{	type	= "label" ,
											w 		= labelWidth ,
											y		= labelY ,
											text	= "Use Capacity"
										},
										{	type	=	"button" ,
											text	=	"-1000",
											font	= 	SMLSIZE ,
											x		=	labelWidth ,
											y		=	buttonY ,
											w		=	buttonW,
											h		=	buttonH ,
											press	=	function()
															if ( aBat.capacity - 1000 ) > 0 then;
																aBat.capacity = aBat.capacity - 1000;
															end;
														end;
										},
										{	type	=	"button" ,
											text	=	"-100",
											font	= 	SMLSIZE ,
											x		=	labelWidth + buttonW ,
											y		=	buttonY ,
											w		=	buttonW ,
											h		=	buttonH ,
											press	=	function()
															if ( aBat.capacity - 100 ) > 0 then;
																aBat.capacity = aBat.capacity - 100;
															end;
														end;
										},
										{	type	= "numberEdit" , 
											w		= 60 * lvgl.LCD_SCALE,
											x		= labelWidth + ( buttonW * 2 ),
											min	= 1 ,
											max	= 99999 ,
											-- length= 5,
											-- align = RIGHT,
											get	=	function()
															return aBat.capacity;
														end,
											edited=	function( newValue )
															aBat.capacity = newValue;
														end,
											set	=	function( newValue )
															aBat.capacity = newValue;
														end
										},
										{	type	= "label" ,
											x		= labelWidth + ( buttonW * 2 ) + 60 * lvgl.LCD_SCALE,
											w		= 45 * lvgl.LCD_SCALE,
											y		= labelY ,
											font	= 	SMLSIZE ,
											text	= "mAmp"
										},
										{	type	=	"button" ,
											text	=	"+100",
											font	= 	SMLSIZE ,
											x		=	labelWidth + ( buttonW * 2 ) + ( (60+45) * lvgl.LCD_SCALE ) ,
											y		=	buttonY ,
											w		=	buttonW ,
											h		=	buttonH ,
											press	=	function()
															if ( aBat.capacity + 100 ) < 99999 then;
																aBat.capacity = aBat.capacity + 100;
															end;
														end;
										},
										{	type	=	"button" ,
											text	=	"+1000",
											font	= 	SMLSIZE ,
											x		=	labelWidth + ( buttonW * 3 ) + ( (60+45) * lvgl.LCD_SCALE ) ,
											y		=	buttonY ,
											w		=	buttonW ,
											h		=	buttonH ,
											press	=	function()
															if ( aBat.capacity + 1000 ) < 99999 then;
																aBat.capacity = aBat.capacity + 1000;
															end;
														end;
										},

							}
						} 
						,				-- Capacity ERROR
						{	type	= "box" , align	= LEFT,
							visible =	function()		
												-- app.d.log( "string.len( aBat.product )" , string.len( aBat.product ) , "dispBatEdit()" )
												if aBat.capacity > aBat.maxCapacity then
													errorList.capacity	= true;
													return true;
												else;
													errorList.capacity	= false;
													return false;
												end;
											end ,
							children	=	{
										{	type	= "label" ,
											x		= labelWidth,
											font	= SMLSIZE ,
											color	= COLOR_THEME_WARNING ,
											text	= "Can't be heigher than Capacity!"
										}
							}
						}
						,				-- cell
						{	type	= "box" , h	= lineHeight, align	= LEFT,
							children	=	{
										{	type	= "label" ,
											w 		= labelWidth ,
											y		= labelY ,
											text	= "Cell Count"
										},
										{	type	= "numberEdit" , 
											w		= 36 * lvgl.LCD_SCALE,
											x		= labelWidth,
											min	= 1 ,
											max	= 14 ,
											-- length= 2,
											-- align = RIGHT,
											get	=	function()
															-- app.d.log( "aBat.cells" , aBat.cells , "()" )
															return aBat.cells;
														end,
											edited=	function( newValue )
															aBat.cells = newValue;
														end,
											set	=	function( newValue )
															aBat.cells = newValue;
														end
										}
							}
						} 
						,				-- maxVolt [number]  => 4.2
						{	type	= "box" , h	= lineHeight, align	= LEFT,
							children = {
										{	type	= "label" ,
											w 		= labelWidth ,
											y		= labelY ,
											text	= "Cell Volt"
										},
										{	type	= "choice", 
											w		= 60 * lvgl.LCD_SCALE,
											x		= labelWidth,
											title	= "Select cell volt" ,
											values= voltTable ,
											get	=	function()
															return volt2Table( aBat.maxVolt ); 
														end , 
											set	= 	function(v)
															aBat.maxVolt = table2Volt( v ); 
															end;
													 
										}
							}
						}
						,				-- earlyCount [number]  => 20
						{	type	= "box" , h	= lineHeight, align	= LEFT,
							children	=	{
										{	type	= "label" ,
											w 		= labelWidth ,
											y		= labelY ,
											text	= "Before flight"
										},
										{	type	= "numberEdit" , 
											w		= 50 * lvgl.LCD_SCALE,
											x		= labelWidth,
											min	= 0 ,
											max	= 9999,
											get	=	function()
															return aBat.earlyCount ;
														end,
											edited=	function( newValue )
															aBat.earlyCount = newValue;
														end,
											set	=	function( newValue )
															aBat.earlyCount = newValue;
														end
										},
							}
						} 
						,				-- count [number]  => 25						
						{	type	= "box" , h	= lineHeight, align	= LEFT,
							children	=	{
										{	type	= "label" ,
											w 		= labelWidth ,
											y		= labelY ,
											text	= "Flight Count"
										},
										{	type	= "numberEdit" , 
											w		= 50 * lvgl.LCD_SCALE,
											x		= labelWidth,
											min	= 0 ,
											max	= 9999,
											get	=	function()
															return aBat.count ;
														end,
											edited=	function( newValue )
															aBat.count = newValue;
														end,
											set	=	function( newValue )
															aBat.count = newValue;
														end
										},
										{	type	= "label" ,
											x		= labelWidth + ( 50 + 2 ) * lvgl.LCD_SCALE,
											y		= labelY ,
											font	= SMLSIZE ,
											text	=	function()
															return "Sum flight : " .. ( aBat.count + aBat.earlyCount )
														end
										},
							}
						} ,
										-- Retire date
						{	type	= "box" , h	= lineHeight ,	align	= LEFT,
							visible	=	function()
												if aBat.retireDate ~= "" then;
													return true;
												else
													return false;
												end;
											end,							
							children	=	{				
										{	type	= "label" ,
											w 		= labelWidth ,
											y		= labelY ,
											text	= "Retire date"
										},
										{	type	= "label" ,
											y		= labelY ,
											x		= labelWidth,
											text	= getDateTimeStr( aBat.retireDate )
										}										
							}
						} 						
					}
				}
				,
				{	type		= "box" ,			-- Buttons
					flexFlow = lvgl.FLOW_ROW , 
					flexPad	= 0 , 
					scrollBar= false , 
					w			= LCD_W *.90 ,
					align		= CENTER ,
					children	=	{
						-- Save/Cancel
						{	type	= "box" , 	
							flexFlow	= lvgl.FLOW_ROW,	
							w			= LCD_W *.44 ,
							align		= RIGHT,
							children	=	{
								{	type	= "button" ,			-- Save
									text	= "Save" ,
									press	=	function()
													if rowID == 0 then;
														addBat();
													else;
														saveBat();
													end;
													app.state = app.STATE.PROCESS_BATTERY_LIST_VIEW;
													app.editedBatId = nil;
												end ,
									active=	function() 
													return not isError(); 
												end
								},
								{	type	= "button" ,			-- Cancel
									text	= "Cancel" ,
									press=	(
													function()
														app.state = app.STATE.PROCESS_BATTERY_LIST_VIEW;
														app.editedBatId = nil;
													end
												) 
								}
							
							}
						}
					}
					
				}
			}

	lvgl.clear()
	
	pageHead( app.state , ui )
end

function dispBat_Assign( aBat, aModels )
	local modelsUi	= {}
	local labelWidth, lineHeight, labelY, buttonW

	-- === BatModels Connections
	local aBatModels
	
	aBatModels	=	app.cbm.getBatteryModels( app.editedBatId  )
	
	
	-- All item set to unselected
	for modelID, _ in pairs( app.aCfgModels ) do
		app.aCfgModels[ modelID ]["selected"]	= 0
	end
	
	-- Selected model set "selected"
	for modelName, _ in pairs( aBatModels ) do
		-- app.d.log( "modelName" , modelName , "dispBat_Assign()" )		-- 

		for mID , aM  in pairs( app.aCfgModels ) do
			
			if aM.name == modelName then				-- If the model deleted, leave out
				app.aCfgModels[ mID ]["selected"]	= 1
				break
			end
	
		end
	end


	-- app.d.printAssoc( "dispBat_Assign::app.aCfgModels - " , app.aCfgModels )
	
	local function modelLine( modelID )
		local ui
		
		--	.name
		-- .selected
		--	.bitmap

		ui	=	{	type	= "box" , flexFlow = lvgl.FLOW_ROW , flexPad	= 0 , 
					scrollBar= false , 
					-- h		= 40 * lvgl.LCD_SCALE ,
					align	= LEFT + VCENTER,
					children	=	{
						{	type	= "toggle" ,
							w 		= 80 * lvgl.LCD_SCALE ,
							get	=	function()
											return app.aCfgModels[ modelID ]["selected"];
										end ,
							set	=	function( v )
											app.aCfgModels[ modelID ]["selected"] = v;
										end
						},
						{	type	= "label" ,
							w 		= 210 * lvgl.LCD_SCALE ,
							h		= 40 * lvgl.LCD_SCALE ,
							align	= LEFT + VCENTER,
							text	= app.aCfgModels[ modelID ].name,
						}
					}
				}
				
		return ui
	end

	-- app.d.printAssoc( "dispBat_Assign() => aModels" , aModels )
	-- app.modelList  =>	models[id] = modelName
	
	for modelID, aModel in pairs( app.aCfgModels ) do
		table.insert( modelsUi , modelLine( modelID ) ) 
	end


	ui	=	{
				{	type = "rectangle" , flexFlow = lvgl.FLOW_ROW , flexPad	= 0 , 
					w		= LCD_W ,
					h		= 40 * lvgl.LCD_SCALE ,
					align	= CENTER + VCENTER,
					rounded	= 4 * lvgl.LCD_SCALE ,
					children	=	{
						{	type	=	"label" ,
							text  =	"Battery ID: " .. aBat.id
						},
						{	type	=	"label" ,
							text  =	"  /  " .. aBat.product
						},
						{	type	=	"label" ,
							text  =	", " .. aBat.maxCapacity .. " mAh"
						},
						{	type	=	"label" ,
							text  =	", " .. aBat.cells .."S  "
						},
						{	type	= "button",
							text	= "Save" ,
							press	=	function()
											local b = {};
											for mID , aModel in pairs( app.aCfgModels ) do;
												if aModel.selected == 1 then;
													b[aModel.name] = true
												end;
											end;
											-- app.d.printAssoc( "b" , b  )
											app.cbm.setBatteryModels( aBat.id , b );
											app.cbm.save();
							
											app.state = app.STATE.PROCESS_BATTERY_LIST_VIEW;
											app.editedBatId = nil;
										end
						}
						
					}
				},
				{	type = "box" ,flexFlow = lvgl.FLOW_COLUMN , flexPad	= 0 , 
					w			= LCD_W ,
					align		= CENTER + VCENTER,
					scrollDir= lvgl.SCROLL_VER,
					children	= modelsUi
				},
			}


	lvgl.clear()
	
	pageHead( app.state , ui )
end
	
function dispBat_ToggleRetire( rowID , aBat )
	local ui
	local title , message, btnText
	local labelX, dataX
	
	labelX	=	 40 * lvgl.LCD_SCALE
	dataX		=	150 * lvgl.LCD_SCALE
	
	if aBat.retireDate == "" then
		-- kérdés, 
		-- címsor
		title		=	"Retire Battery (Delete)"
		btnText	=	"Retire"
		-- Aksi adatok: id, prod, mah, cell, last start, flights
		-- Valóban törölni szeretnéd ezt az akkumulátort?   / Do you really want to retire this battery?
		-- "Retire", "Cancel" gomb
	else
		title		=	"Battery to work (UnDelete)"
		btnText	=	"To Work"
	end

	ui	= 	{
				{	type	= "box" ,		
					w		= LCD_W ,
					x		= PAGE_HEAD_HEIGH  * lvgl.LCD_SCALE,
					y		= 0,
					h		= LCD_H - ( PAGE_HEAD_HEIGH  * lvgl.LCD_SCALE ) ,
					flexFlow	= lvgl.FLOW_COLUMN , flexPad = 0 , 
					scrollBar= true, scrollDir = lvgl.SCROLL_VER, 
					children	=	{
						-- border
						{	type	=	"rectangle", flexFlow	=	lvgl.FLOW_COLUMN,
							scrollBar	= false, scrollDir	=	lvgl.SCROLL_OFF,
							thickness	= 3 ,
							rounded		= 10,
							-- h		= 40 * lvgl.LCD_SCALE,
							w		=	LCD_W * .90,
							align	=	CENTER,
							children	=	{
								-- head
								{	type	=	"rectangle", flexFlow	=	lvgl.FLOW_ROW, 
									thickness = 1,	rounded		= 5,
									children	= {
										{	type	= "label",
											w		= LCD_W * .90,
											text	= title,
											align	= CENTER
										},
									}
								},
								-- fields
								{	type	=	"box", flexFlow	=	lvgl.FLOW_ROW,
									children	= {
										{	type	=	"box", flexFlow	=	lvgl.FLOW_COLUMN,
											children	= {
												{	type	=	"box",
													children	=	{
														{	type	=	"label",
															x		=	labelX,
															text	=	"ID:"
														},
														{	type	=	"label",
															x		=	dataX,
															text	=	aBat.id
														}
													}
												},	
												{	type	=	"box",
													children	=	{
														{	type	=	"label",
															x		=	labelX,
															text	=	"Product:" 
														},
														{	type	=	"label",
															x		=	dataX,
															text	=	aBat.product
														}
													}	
												},
												{	type	=	"box",
													children	=	{
														{	type	=	"label",
															x		=	labelX,
															text	=	"Capacity:" 
														},
														{	type	=	"label",
															x		=	dataX,
															text	=	aBat.capacity .. " mAh,  " .. aBat.cells .. "S"
														}
													}	
												},
												{	type	=	"box",
													children	=	{
														{	type	=	"label",
															x		=	labelX,
															text	=	"Last start:" 
														},
														{	type	=	"label",
															x		=	dataX,
															text	=	getDateTimeStr( aBat.lastStartDate )
														}
													}	
												},
												{	type	=	"box",
													children	=	{
														{	type	=	"label",
															x		=	labelX,
															text	=	"Flight count:" 
														},
														{	type	=	"label",
															x		=	dataX,
															text	=	aBat.count + aBat.earlyCount
														}
													}	
												},
												{	type	=	"box",
													visible	=	function()
																		return ( aBat.retireDate ~= "" )
																	end,
													children	=	{
														{	type	=	"label",
															x		=	labelX,
															text	=	"Retire Date:" 
														},
														{	type	=	"label",
															x		=	dataX,
															text	=	getDateTimeStr( aBat.retireDate )
														}
													}	
												}
											}
										} ,	
									}
								} ,
								-- Buttons
								{	type	=	"box", flexFlow	=	lvgl.FLOW_ROW,
									w		=	LCD_W * .9 ,
									align	= CENTER,
									children	=	{
										{	type	=	"button",
											text	=	btnText, 
											w		=	80 * lvgl.LCD_SCALE ,
											press	=	function()
															
															batFile  =	loadScript( app.appFolder .. "csvfile.lua")();
															batFile.readCsv( app.appFolder .. "batfiles/batteries.csv" )	;
															
															if aBat.retireDate == "" then;
																-- Retire
																local dt = getDateTime();
																local rD = string.format( "%04d%02d%02d%02d%02d%02d" , 
																			  dt.year, dt.mon, dt.day, dt.hour, dt.min, dt.sec ) 
																
																batFile.setField( rowID, "retireDate", rD );
															else;
																-- To Work
																batFile.setField( rowID, "retireDate", "" );
															end;
															
															batFile.writeCsv();

															app.state = app.STATE.PROCESS_BATTERY_LIST_VIEW;
															app.editedBatId = nil;

														end 
										},
										{	type	=	"button",
											text	=	"Cancel" ,
											w		=	80 * lvgl.LCD_SCALE ,
											press	=	function()
															app.state = app.STATE.PROCESS_BATTERY_LIST_VIEW;
															app.editedBatId = nil;
														end
										}
									}
								},

									
							}
						}
					}
				} 
			}


	lvgl.clear()
	
	pageHead( app.state , ui )

end
