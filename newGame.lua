
local composer = require( "composer" )

local scene = composer.newScene()

local tiled = require "com.ponywolf.ponytiled"

local json = require "json"

local persistence = require "persistence"

local sceneTransition = require "sceneTransition"

local fitScreen = require "fitScreen"


-- -----------------------------------------------------------------------------------
-- Declaração das variáveis
-- -----------------------------------------------------------------------------------
local textField
local playButton

-- -----------------------------------------------------------------------------------
-- Funções
-- -----------------------------------------------------------------------------------
-- Cria um novo arquivo de jogo 
local function createFile()	
	if ( ( textField.text ~= nil ) and ( not tostring( textField.text ):find( "^%s*$" ) ) ) then 
		persistence.newGameFile(textField.text)
		sceneTransition.gotoHouse()
	end
end
 
-- -----------------------------------------------------------------------------------
-- Listeners
-- -----------------------------------------------------------------------------------
local function textListener( event )
 
    if ( event.phase == "began" ) then
 
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        textField.string = event.target.text
 
    elseif ( event.phase == "editing" ) then
    end
end


-- -----------------------------------------------------------------------------------
-- Cenas
-- -----------------------------------------------------------------------------------
-- create()
function scene:create( event )
	local sceneGroup = self.view

	display.setDefault("magTextureFilter", "nearest")
  	display.setDefault("minTextureFilter", "nearest")
	local newGameData = json.decodeFile(system.pathForFile("tiled/newGame.json", system.ResourceDirectory))  -- load from json export

	newGame = tiled.new(newGameData, "tiled")

	playButton = newGame:findObject("play")

	sceneGroup:insert( newGame )

	textField = native.newTextField( 3*display.contentCenterX/4, display.contentCenterY/2, display.contentWidth/2, 30 )

	textField.inputType = "default"
	textField.string = " "
	sceneGroup:insert( textField )

	textField:addEventListener( "userInput", textListener )
	playButton:addEventListener( "tap", createFile )

	native.setKeyboardFocus( textField )

	--fitScreen:fitBackground( newGame )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
	
	elseif ( phase == "did" ) then
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then 
		native.setKeyboardFocus( nil )
		display.remove(textField)
		textField = nil		
	elseif ( phase == "did" ) then
		composer.removeScene( "newGame" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
