ESX = nil

local currentPlayerJobName  = 'none'
local PlayerData = {}
local jobTitle = 'McDonalds'

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
        print("ESX.GetPlayerData().job = nil, waiting until not nil..")
		Citizen.Wait(100)
	end

    if ESX.GetPlayerData().job.name ~= nil then
        print(Config.Prefix.."ESX.GetPlayerData().job.name ~= nil setting Job Name")
        currentPlayerJobName = ESX.GetPlayerData().job.name
        print(Config.Prefix.."Job Name has been set to: "..currentPlayerJobName)
    else
        print(Config.Prefix.."^1ESX.GetPlayerData().job.name == nil Cannot set job name!")
    end

	PlayerData = ESX.GetPlayerData()
	refreshBlips()
end)

local isInMarker = false
local menuIsOpen = false
local vehcileMenuIsOpen = false
local hintToDisplay = _U('NoHintError')
local displayHint = false
local currentZone = 'none'
local currentJob = 'none'
local playerPed = PlayerPedId()

local invDrink = 0
local invBurger = 0
local invFries = 0
local invDesert = 0
local invMeal = 0

local payBonus = 0
local bonus = 1.25

local mealsMade = 0
local customersServed = 0
local ordersDelivered = 0

local paidDeposit = 0

local lastDelivery = 'none'

local showingBlips = false
local hasTakenOrder = false
local hasOrder = false
local isDelivering = false
local isDriveDelivering = false

local dHasTakenOrder = false
local dHasOrder = false
local dIsDelivering = false
local driverHasCar = false

local taskPoints = {}
local Blips = {}
local deliveryCoords
local dDeliveryCoords

local hasStartedBlips = false

local currentBurgerNum = 0
local currentBurgerID = ''
local currentBurgerName = ''
local burgerData = {}
local currentSideNum = 0
local currentSideID = ''
local currentSideName = ''
local sideData = {}
local currentDrinkNum = 0
local currentDrinkID = ''
local currentDrinkName = ''
local drinkData = {}
local currentDesertNum = 0
local currentDesertID = ''
local currentDesertName = ''
local desertData = {}

local holdingBurgerNum = 0
local holdingSideNum = 0
local holdingDrinkNum = 0
local holdingDesertNum = 0

local hasGeneratedOrder = false
local isMorning = false

local morningOrder = false

local playerBusy = false

--Press [E] Buttons
Citizen.CreateThread(function()
    if playerBusy == false then
	    while true do																
		    Citizen.Wait(2)					
		    if not menuIsOpen then
			    local playerCoords = GetEntityCoords(GetPlayerPed(-1))
                if currentPlayerJobName ~= nil then														
			        if  playerIsInside(playerCoords, Config.JobMenuCoords, Config.JobMarkerDistance) then 				
			            isInMarker = true
			            displayHint = true																
			            hintToDisplay = _U('JobListMarker')									
			            currentZone = 'JobList'	
                    elseif  playerIsInside(playerCoords, Config.CookBurgerCoords, Config.JobMarkerDistance) and currentJob == 'cook' then 				
			    	    isInMarker = true
			    	    displayHint = true																
			    	    hintToDisplay = _U('CookBurger')									
			    	    currentZone = 'Burger'																
			        elseif  playerIsInside(playerCoords, Config.CookFriesCoords, Config.JobMarkerDistance) and currentJob == 'cook' then 				
			    	    isInMarker = true
			    	    displayHint = true																
			    	    hintToDisplay = _U('CookFries')									
			    	    currentZone = 'Fries'																
			        elseif  playerIsInside(playerCoords, Config.CookDrinkCoords, Config.JobMarkerDistance) and currentJob == 'cook' then 				
			    	    isInMarker = true
			    	    displayHint = true																
			    	    hintToDisplay = _U('GetDrink')									
			    	    currentZone = 'Drink'
			        elseif  playerIsInside(playerCoords, Config.CookDesertCoords, Config.JobMarkerDistance) and currentJob == 'cook' then 				
			    	    isInMarker = true
			    	    displayHint = true																
			    	    hintToDisplay = _U('GetDrink')									
			    	    currentZone = 'Desert'	                     
			        elseif  playerIsInside(playerCoords, Config.CookPrepareCoords, Config.JobMarkerDistance) and currentJob == 'cook' and not Config.EnableAdvancedMode then 				
			    	    isInMarker = true
			    	    displayHint = true																
			    	    hintToDisplay = _U('MakeMeal')									
			    	    currentZone = 'Prepare'		    
			        elseif  playerIsInside(playerCoords, Config.CashTakeOrder, Config.JobMarkerDistance) and currentJob == 'cashier' then 				
                        isInMarker = true
			    	    displayHint = true
                        if hasGeneratedOrder == true then
                            hintToDisplay = "~b~Press ~INPUT_CONTEXT~ to Check Current Order"
                        else
			    	        hintToDisplay = _U('TakeOrder')		
                        end
			    	    currentZone = 'cOrder'	
                    elseif  playerIsInside(playerCoords, Config.CashTakeOrder1, Config.JobMarkerDistance) and currentJob == 'cashier' then 				
                        isInMarker = true
			    	    displayHint = true																
			    	    if hasGeneratedOrder == true then
                            hintToDisplay = "~b~Press ~INPUT_CONTEXT~ to Check Current Order"
                        else
			    	        hintToDisplay = _U('TakeOrder')		
                        end								
			    	    currentZone = 'cOrder'
                    elseif  playerIsInside(playerCoords, Config.CashTakeOrder2, Config.JobMarkerDistance) and currentJob == 'cashier' then 				
                        isInMarker = true
			    	    displayHint = true																
			    	    if hasGeneratedOrder == true then
                            hintToDisplay = "~b~Press ~INPUT_CONTEXT~ to Check Current Order"
                        else
			    	        hintToDisplay = _U('TakeOrder')		
                        end									
			    	    currentZone = 'cOrder'
                    elseif  playerIsInside(playerCoords, Config.CashTakeOrder3, Config.JobMarkerDistance) and currentJob == 'cashier' then 				
                        isInMarker = true
			    	    displayHint = true																
			    	    if hasGeneratedOrder == true then
                            hintToDisplay = "~b~Press ~INPUT_CONTEXT~ to Check Current Order"
                        else
			    	        hintToDisplay = _U('TakeOrder')		
                        end								
			    	    currentZone = 'cOrder'
                    elseif  playerIsInside(playerCoords, Config.CashTakeOrder4, Config.JobMarkerDistance) and currentJob == 'cashier' then 				
                        isInMarker = true
			    	    displayHint = true																
			    	    if hasGeneratedOrder == true then
                            hintToDisplay = "~b~Press ~INPUT_CONTEXT~ to Check Current Order"
                        else
			    	        hintToDisplay = _U('TakeOrder')		
                        end								
			    	    currentZone = 'cOrder'
			        elseif  playerIsInside(playerCoords, Config.CashCollectMeal, Config.JobMarkerDistance) and currentJob == 'cashier' and not Config.EnableAdvancedMode then 				
			    	    isInMarker = true
			    	    displayHint = true																
			    	    hintToDisplay = _U('PickupOrder')								
			    	    currentZone = 'cCollect'	
                    elseif  deliveryCoords ~= nil and playerIsInside(playerCoords, deliveryCoords, Config.JobExtendedDistance) and currentJob == 'cashier' and isDelivering then 				
			    	    isInMarker = true
			    	    displayHint = true																
			    	    hintToDisplay = _U('GiveOrder')									
			    	    currentZone = 'cDeliver'
                    elseif  playerIsInside(playerCoords, Config.DeliveryCheckOrder, Config.JobMarkerDistance) and currentJob == 'deliv' then 				
			    	    isInMarker = true
			    	    displayHint = true																
			    	    hintToDisplay = "~b~Press ~INPUT_CONTEXT~ to check online order for Delivery"							
			    	    currentZone = 'dCheck'
                    elseif  playerIsInside(playerCoords, Config.CashCollectMeal, Config.JobMarkerDistance) and currentJob == 'deliv' and Config.EnableAdvancedMode == false then 				
			    	    isInMarker = true
			    	    displayHint = true																
			    	    hintToDisplay = _U('TakeDeliv')									
			    	    currentZone = 'dCollect'
                    elseif  dDeliveryCoords ~= nil and playerIsInside(playerCoords, dDeliveryCoords, Config.JobExtendedDistance) and currentJob == 'deliv' then 				
			    	    isInMarker = true
			    	    displayHint = true																
			    	    hintToDisplay = _U('GiveDeliv')									
			    	    currentZone = 'dDeliver'
                    elseif  dDeliveryCoords == nil and currentJob == 'deliv' and dHasOrder then 				
			    	    isInMarker = true
			    	    displayHint = true																
			    	    hintToDisplay = _U('DelivError')								
			    	    currentZone = 'dDeliver'
                    elseif  playerIsInside(playerCoords, Config.DeliveryCarSpawnMarker, Config.JobMarkerDistance) and currentJob == 'deliv' then 				
			    	    isInMarker = true
			    	    displayHint = true																
			    	    hintToDisplay = _U('GetCar')									
			    	    currentZone = 'dCarSpawn'
                    elseif  playerIsInside(playerCoords, Config.DeliveryCarDespawn, Config.JobExtendedDistance) and currentJob == 'deliv' and driverHasCar then 				
			    	    isInMarker = true
			    	    displayHint = true																
			    	    hintToDisplay = _U('ReturnCar')									
			    	    currentZone = 'dCarDespawn'
                    else
			    	    isInMarker = false
			    	    displayHint = false
			    	    hintToDisplay = _U('NoHintError')
			    	    currentZone = 'none'
			        end
			        if IsControlJustReleased(0, 38) and isInMarker then
			    	    taskTrigger(currentZone)													
			    	    Citizen.Wait(500)
			        end
                end
		    end
	    end
    end
end)
--Start Blips
Citizen.CreateThread(function()
    if currentPlayerJobName ~= 'none' then
        if showingBlips == false then
            if Config.EnableBlips == true then
                refreshBlips()
            else
                deleteBlips()
            end
        else
            deleteBlips()
            if Config.EnableBlips == true then
                refreshBlips()
            end
        end
    end
end)
--Check if Morning (Checking every Minute)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        local hour = GetClockHours()
        local minute = GetClockMinutes()

        if hour >= 6 and hour <= 10 then
            isMorning = true
        else
            isMorning = false
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)		
    playerData = xPlayer
    PlayerData = xPlayer
    if Config == nil then
        print(Config.Prefix.."Couldnt Load Config")
    else
        if Config.EnableBlips == true then
            while PlayerData.job == jobTitle and jBlipsCreated == 0 do
                refreshBlips()
                Citizen.Wait(100)
            end
        end
    end								
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    currentPlayerJobName = job.name
    if job.name == jobTitle then 
        onDuty = true
    else
        onDuty = false
    end
    refreshBlips()						
end)
--Hint to Display
Citizen.CreateThread(function()
    if playerBusy == false then
        while true do											
        Citizen.Wait(1)
            if displayHint then							
                SetTextComponentFormat("STRING")				
                AddTextComponentString(hintToDisplay)			
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)	
            end
        end
    else
        displayHint = false
    end
end)
--Display Markers
Citizen.CreateThread(function()
    if playerBusy == false then
	    while true do																				
		    Citizen.Wait(1)
		    local playerCoords = GetEntityCoords(GetPlayerPed(-1))
		    if currentPlayerJobName == 'McDonalds' and playerIsInside(playerCoords, Config.JobMenuCoords, 20) then 
			    displayMarker(Config.JobMenuCoords)
		    end
		    if onDuty and currentJob == 'cook' and playerIsInside(playerCoords, Config.JobMenuCoords, 100) and Config.EnableAdvancedMode == true then			
			    if invBurger < 1 then
                    displayMarker(Config.CookBurgerCoords)
                end
                if invDrink < 1 then
                    displayMarker(Config.CookDrinkCoords)
                end
                if invFries < 1 then
                    displayMarker(Config.CookFriesCoords)
                end
                if invDesert < 1 then
                    displayMarker(Config.CookDesertCoords)
                end
		    elseif onDuty and currentJob == 'cook' and playerIsInside(playerCoords, Config.JobMenuCoords, 100) and Config.EnableAdvancedMode == false then			
			    if invBurger < 2 then
                    displayMarker(Config.CookBurgerCoords)
                end
                if invDrink < 2 then
                    displayMarker(Config.CookDrinkCoords)
                end
                if invFries < 2 then
                    displayMarker(Config.CookFriesCoords)
                end
                if invBurger > 0 and invDrink > 0 and invFries > 0 then
                    displayMarker(Config.CookPrepareCoords)
                end
            end
		    if onDuty and currentJob == 'cashier' and playerIsInside(playerCoords, Config.JobMenuCoords, 100) then 			
			    if Config.EnableAdvancedMode == true then
                    if hasTakenOrder == false then
                        displayMarker(Config.CashTakeOrder)
                        displayMarker(Config.CashTakeOrder1)
                        displayMarker(Config.CashTakeOrder2)
                        displayMarker(Config.CashTakeOrder3)
                        displayMarker(Config.CashTakeOrder4)
                    end
                else
                    if hasTakenOrder == false then
                        displayMarker(Config.CashTakeOrder)
                        displayMarker(Config.CashTakeOrder1)
                        displayMarker(Config.CashTakeOrder2)
                        displayMarker(Config.CashTakeOrder3)
                        displayMarker(Config.CashTakeOrder4)
                        displayMarker(Config.CashTakeOrder5)
                    elseif hasTakenOrder and hasOrder == false then
                        displayMarker(Config.CashCollectMeal)
                    end
                end
                if isDelivering == true then
                    local temp = vector3(deliveryCoords.x,deliveryCoords.y,deliveryCoords.z)
                    deliveryMarker(temp)
                end
		    end
            if onDuty and currentJob == 'deliv' and playerIsInside(playerCoords, Config.JobMenuCoords, 10000) then
                if Config.EnableAdvancedMode == true then
                    if dHasTakenOrder == false then
                        displayMarker(Config.DeliveryCheckOrder)
                    end
                    if isDriveDelivering == true then
                        if dDeliveryCoords ~= nil then
                            local temp = vector3(dDeliveryCoords.x,dDeliveryCoords.y,dDeliveryCoords.z - 1)
                            deliveryDMarker(temp)
                        else
                            print(Config.Prefix.."^2dDeliveryCoords are NIL! Cannot create Marker!")
                        end
                    end
                    displayMarker(Config.DeliveryCarSpawnMarker)
                    if driverHasCar == true then
                        destroyMarker(Config.DeliveryCarDespawn)
                    end
                else
                    if dHasOrder == false then
                        displayMarker(Config.CashCollectMeal)
                    end
                    if isDriveDelivering == true then
                        if dDeliveryCoords ~= nil then
                            local temp = vector3(dDeliveryCoords.x,dDeliveryCoords.y,dDeliveryCoords.z - 1)
                            deliveryDMarker(temp)
                        else
                            print(Config.Prefix.."^2dDeliveryCoords are NIL! Cannot create Marker!")
                        end
                    end
                    displayMarker(Config.DeliveryCarSpawnMarker)
                    if driverHasCar == true then
                        destroyMarker(Config.DeliveryCarDespawn)
                    end
                end
            end
	    end
    end
end)

function playerIsBusy(bool)
    if bool == true then
        playerBusy = true
        FreezeEntityPosition(playerPed, true)
    else
        playerBusy = false
        FreezeEntityPosition(playerPed, false)
    end
end

function playerIsInside(playerCoords, coords, distance) 	
	local vecDiffrence = GetDistanceBetweenCoords(playerCoords, coords.x, coords.y, coords.z, false)
	return vecDiffrence < distance		
end
--Zones
function taskTrigger(zone)				
	if zone == 'JobList' then				
		openMenu()
	elseif zone == 'Burger' then				
        getBurger()
	elseif zone == 'Fries' then	
        getSide()
	elseif zone == 'Drink' then
        getDrink()
    elseif zone == 'Prepare' then
       prepareMeal() 
    elseif zone == 'cOrder' then
        if Config.EnableAdvancedMode == true then
            if hasGeneratedOrder == false then
                takeOrder()
            else
                getCurrentOrder()
            end
        else
            takeOrder()
        end
    elseif zone == 'cCollect' then
        if Config.EnableAdvancedMode == true then
            
        else
            pickupOrder()
        end
    elseif zone == 'dCheck' then
        checkOrder()
    elseif zone == 'cDeliver' then
        deliverOrder()
    elseif zone == 'dCollect' then

        pickupDelivery()
    elseif zone == 'dDeliver' then
        driveFromDelivery()
    elseif zone == 'dCarSpawn' then
        openWorkVehicleMenu()
    elseif zone == 'dCarDespawn' then
        deleteCar()
    end
end

function generateOrder()
    if hasGeneratedOrder == false then
        currentBurgerNum = 0
        if currentBurgerNum == 0 then
            if isMorning then
                currentBurgerNum = math.random(1, #Config.Items.Burgers.Morning)
                burgerData = Config.Items.Burgers.Morning[currentBurgerNum]
            
            else
                currentBurgerNum = math.random(1, #Config.Items.Burgers.Day)
                burgerData = Config.Items.Burgers.Day[currentBurgerNum]
            end
        
            if currentBurgerNum > 0 then
                if burgerData ~= nil then
                    if burgerData.id ~= nil then
                        if burgerData.name ~= nil then
                            --dPrint("Generated Burger Number is: ^2"..currentBurgerNum.."^4 Which is a: ^2"..burgerData.name.."^4 with an ID of: ^2"..burgerData.id.."^4")
                            currentBurgerName = burgerData.name
                            currentBurgerID = burgerData.id
                        else
                            dPrint("^1Burger Name is = nil - unable to get Burger Name")
                        end
                    else
                        dPrint("^1Burger ID is = nil - unable to get Burger ID")
                    end

                else
                    dPrint("^1BurgerData is = nil - unable to get BurgerData")
                end
            else

            end
        else
            dPrint("^1Already Has Generated Burger")
        end

        currentSideNum = 0
        if currentSideNum == 0 then
            if isMorning then
                currentSideNum = math.random(1, #Config.Items.Sides.Morning)
                sideData = Config.Items.Sides.Morning[currentSideNum]
            else
                currentSideNum = math.random(1, #Config.Items.Sides.Day)
                sideData = Config.Items.Sides.Day[currentSideNum]
            end
        
        
            if currentSideNum > 0 then
                if sideData ~= nil then
                    if sideData.id ~= nil then
                        if sideData.name ~= nil then
                            --dPrint("Generated Side Number is: ^2"..currentSideNum.."^4 Which is a: ^2"..sideData.name.."^4 with an ID of: ^2"..sideData.id.."^4")
                            currentSideName = sideData.name
                            currentSideID = sideData.id
                        else
                            dPrint("^1Side Name is = nil - unable to get Side Name")
                        end
                    else
                        dPrint("^1Side ID is = nil - unable to get Side ID")
                    end
                else
                    dPrint("^1SideData is = nil - unable to get SideData")
                end
            else
                dPrint("^1Failed To Generate Side")
            end
        else
             dPrint("^1Already Has Generated Side")
        end

        currentDrinkNum = 0
        if currentDrinkNum == 0 then
            if isMorning then
                currentDrinkNum = math.random(1, #Config.Items.Drinks.Morning)
                drinkData = Config.Items.Drinks.Morning[currentDrinkNum]
            else
                currentDrinkNum = math.random(1, #Config.Items.Drinks.Day)
                drinkData = Config.Items.Drinks.Day[currentDrinkNum]
            end

            if currentDrinkNum > 0 then
                if drinkData ~= nil then
                    if drinkData.id ~= nil then
                        if drinkData.name ~= nil then
                            --dPrint("Generated Drink Number is: ^2"..currentDrinkNum.."^4 Which is a: ^2"..drinkData.name.."^4 with an ID of: ^2"..drinkData.id.."^4")
                            currentDrinkName = drinkData.name
                            currentDrinkID = drinkData.id
                        else
                            dPrint("^1Drink Name is = nil - unable to get Drink Name")
                        end
                    else
                        dPrint("^1Drink ID is = nil - unable to get Drink ID")
                    end
                else
                    dPrint("^1DrinkData is = nil - unable to get DrinkData")
                end
            else
                dPrint("^1Failed To Generate Drink")
            end
        else
             dPrint("^1Already Has Generated Drink")
        end

        currentDesertNum = 0
        if Config.DesertRarity > 0 then
            local temp = math.random(0, 100)
            if temp >= Config.DesertRarity then
                desertData = Config.Items.Deserts.Day[1]
                currentDesertNum = 1
                if desertData ~= nil then
                    if desertData.id ~= nil then
                        if desertData.name ~= nil then
                            --dPrint("Generated Desert Number is: ^2"..currentDesertNum.."^4 Which is a: ^2"..desertData.name.."^4 with an ID of: ^2"..desertData.id.."^4")
                            currentDesertName = desertData.name
                            currentDesertID = desertData.id
                        else
                            dPrint("^1Desert Name is = nil - unable to get Desert Name")
                        end
                    else
                        dPrint("^1Desert ID is = nil - unable to get Desert ID")
                    end
                else
                    dPrint("^1DesertData is = nil - unable to get DesertData")
                end
            else
                --dPrint("No Desert this time thank you")
            end
        end
        if currentDesertNum >= 1 then
            dPrint("Customer Wants a ^2"..burgerData.name.."^4 with ^2"..sideData.name.."^4, a ^2"..drinkData.name.."^4 and also a ^2"..desertData.name.."^4")
            exports.pNotify:SendNotification({text = "REMEMBER: Tell the Cook the Order. You can check the Order again by going to the register.", type = "info", timeout = 10000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            ESX.ShowNotification('~b~Order: ~g~'..burgerData.name..'~b~, ~g~'..sideData.name..'~b~, ~g~'..drinkData.name..'~b~, ~g~'..desertData.name..'~b~.')
        else
            dPrint("Customer Wants a ^2"..burgerData.name.."^4 with ^2"..sideData.name.."^4 and a ^2"..drinkData.name.."^4")
            exports.pNotify:SendNotification({text = "REMEMBER: Tell the Cook the Order. You can check the Order again by going to the register.", type = "info", timeout = 10000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            ESX.ShowNotification('~b~Order: ~g~'..burgerData.name..'~b~, ~g~'..sideData.name..'~b~, ~g~'..drinkData.name..'~b~.')
        end
        hasGeneratedOrder = true
        if isMorning == true then
            morningOrder = true
        else
            morningOrder = false
        end
    else
        dPrint("^1 Order Already Taken!")
    end
end

function getCurrentOrder()
    if currentBurgerName ~= nil then
        if currentSideName ~= nil then
            if currentDrinkName ~= nil then
                if currentDesertName ~= nil then
                    ESX.ShowNotification('~b~Order: ~g~'..currentBurgerName..'~b~, ~g~'..currentSideName..'~b~, ~g~'..currentDrinkName..'~b~, ~g~'..currentDesertName..'~b~.')
                else
                    ESX.ShowNotification('~b~Order: ~g~'..currentBurgerName..'~b~, ~g~'..currentSideName..'~b~, ~g~'..currentDrinkName..'~b~.')
                end
            else
                dPrint("^1 Drink Data Array is broken: Tell Developer")
            end
        else
            dPrint("^1 Side Data Array is broken: Tell Developer")
        end
    else
        dPrint("^1 Burger Data Array is broken: Tell Developer")
    end
end

function getBurger()
    if Config.EnableAdvancedMode == true then
        menuIsOpen = true
        playerIsBusy(true)
        ESX.UI.Menu.CloseAll()	
        if isMorning == false then
            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'JobList',			
                {
                title    = "McDonalds Burgers - Day",	
                description = "Created by DefectGaming's FuryFight3r",
                elements = {
                    {label = "Cheese Burger", value = '1'},
                    {label = "Big Tasty", value = '2'},
                    {label = "Spicy Chicken", value = '3'},
                    {label = "Quater Pounder", value = '4'},
                    {label = "Big Mac", value = '5'},
                    {label = "Double Cheese Burger", value = '6'},
                    {label = "Beef Burger", value = '7'},
                    {label = "Filet o' Fish", value = '8'},
                    {label = "Chicken Mac", value = '9'},
                    {label = "Mc Nuggets", value = '10'},
                    {label = "Wrap", value = '11'},
                    {label = "[P] BBQ Angus", value = '12'},
                    {label = "[P] McRoyal", value = '13'},
                    {label = "[P] Chicken Special", value = '14'}
                }
            },
            function(data, menu)
                local d = tonumber(data.current.value)
                if data.current.value == '1' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("misscarsteal2fixer", "confused_a")
                        exports['progressBars']:startUI(Config.CookBurgerTime, "Cooking and making Burger..")
	                    FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookBurgerTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Burgers.Day[1].id)
                        holdingBurgerNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.BurgerPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invBurger = invBurger + 1
                    end             
                end
                if data.current.value == '2' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("misscarsteal2fixer", "confused_a")
                        exports['progressBars']:startUI(Config.CookBurgerTime, "Cooking and making Burger..")
	                    FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookBurgerTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Burgers.Day[2].id)
                        holdingBurgerNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.BurgerPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invBurger = invBurger + 1
                    end 
                end
                if data.current.value == '3' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("misscarsteal2fixer", "confused_a")
                        exports['progressBars']:startUI(Config.CookBurgerTime, "Cooking and making Burger..")
	                    FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookBurgerTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Burgers.Day[3].id)
                        holdingBurgerNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.BurgerPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invBurger = invBurger + 1
                    end
                end
                if data.current.value == '4' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("misscarsteal2fixer", "confused_a")
                        exports['progressBars']:startUI(Config.CookBurgerTime, "Cooking and making Burger..")
	                    FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookBurgerTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Burgers.Day[4].id)
                        holdingBurgerNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.BurgerPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invBurger = invBurger + 1
                    end
                end
                if data.current.value == '5' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("misscarsteal2fixer", "confused_a")
                        exports['progressBars']:startUI(Config.CookBurgerTime, "Cooking and making Burger..")
	                    FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookBurgerTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Burgers.Day[5].id)
                        holdingBurgerNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.BurgerPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invBurger = invBurger + 1
                    end
                end
                if data.current.value == '6' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("misscarsteal2fixer", "confused_a")
                        exports['progressBars']:startUI(Config.CookBurgerTime, "Cooking and making Burger..")
	                    FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookBurgerTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Burgers.Day[6].id)
                        holdingBurgerNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.BurgerPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invBurger = invBurger + 1
                    end
                end
                if data.current.value == '7' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("misscarsteal2fixer", "confused_a")
                        exports['progressBars']:startUI(Config.CookBurgerTime, "Cooking and making Burger..")
	                    FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookBurgerTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Burgers.Day[7].id)
                        holdingBurgerNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.BurgerPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invBurger = invBurger + 1
                    end
                end
                if data.current.value == '8' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("misscarsteal2fixer", "confused_a")
                        exports['progressBars']:startUI(Config.CookBurgerTime, "Cooking and making Burger..")
	                    FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookBurgerTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Burgers.Day[8].id)
                        holdingBurgerNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.BurgerPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invBurger = invBurger + 1
                    end
                end
                if data.current.value == '9' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("misscarsteal2fixer", "confused_a")
                        exports['progressBars']:startUI(Config.CookBurgerTime, "Cooking and making Burger..")
	                    FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookBurgerTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Burgers.Day[9].id)
                        holdingBurgerNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.BurgerPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invBurger = invBurger + 1
                    end
                end
                if data.current.value == '10' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("misscarsteal2fixer", "confused_a")
                        exports['progressBars']:startUI(Config.CookBurgerTime, "Cooking and making Burger..")
	                    FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookBurgerTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Burgers.Day[10].id)
                        holdingBurgerNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.BurgerPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invBurger = invBurger + 1
                    end
                end
                if data.current.value == '11' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("misscarsteal2fixer", "confused_a")
                        exports['progressBars']:startUI(Config.CookBurgerTime, "Cooking and making Burger..")
	                    FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookBurgerTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Burgers.Day[11].id)
                        holdingBurgerNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.BurgerPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invBurger = invBurger + 1
                    end
                end
                if data.current.value == '12' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("misscarsteal2fixer", "confused_a")
                        exports['progressBars']:startUI(Config.CookBurgerTime, "Cooking and making Burger..")
	                    FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookBurgerTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Burgers.Day[12].id)
                        holdingBurgerNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.BurgerPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invBurger = invBurger + 1
                    end
                end
                if data.current.value == '13' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("misscarsteal2fixer", "confused_a")
                        exports['progressBars']:startUI(Config.CookBurgerTime, "Cooking and making Burger..")
	                    FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookBurgerTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Burgers.Day[13].id)
                        holdingBurgerNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.BurgerPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invBurger = invBurger + 1
                    end
                end
                if data.current.value == '14' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("misscarsteal2fixer", "confused_a")
                        exports['progressBars']:startUI(Config.CookBurgerTime, "Cooking and making Burger..")
	                    FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookBurgerTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Burgers.Day[14].id)
                        holdingBurgerNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.BurgerPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invBurger = invBurger + 1
                    end
                end
                menu.close()
	            menuIsOpen = false
            end,
                function(data, menu)
                menu.close()
	            menuIsOpen = false
            end)
        else
            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'JobList',			
                {
                title    = "McDonalds Burgers - Morning",	
                description = "Created by DefectGaming's FuryFight3r",
                elements = {
                    {label = "Sausage McMuffin", value = '1'},
                    {label = "Egg McMuffin", value = '2'}
                }
            },
            function(data, menu)
                local d = tonumber(data.current.value)
                if data.current.value == '1' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("misscarsteal2fixer", "confused_a")
                        exports['progressBars']:startUI(Config.CookBurgerTime, "Cooking and making Burger..")
	                    FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookBurgerTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Burgers.Morning[1].id)
                        holdingBurgerNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.BurgerPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invBurger = invBurger + 1
                    end  
                end
                if data.current.value == '2' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("misscarsteal2fixer", "confused_a")
                        exports['progressBars']:startUI(Config.CookBurgerTime, "Cooking and making Burger..")
	                    FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookBurgerTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Burgers.Morning[2].id)
                        holdingBurgerNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.BurgerPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invBurger = invBurger + 1
                    end 
                end               
                menu.close()
	            menuIsOpen = false
            end,
                function(data, menu)
                menu.close()
	            menuIsOpen = false
            end)
        end
    else
        if invBurger >= 2 then
            exports.pNotify:SendNotification({text = _U('BurgerError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        else
            --Alerts | alert | notice | info | success | error 
            playerIsBusy(true)
            startAnim("misscarsteal2fixer", "confused_a")
            exports.pNotify:SendNotification({text = _U('BurgerNotifStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            exports['progressBars']:startUI(Config.CookBurgerTime, _U('BurgerBar'))
	        FreezeEntityPosition(playerPed, true)
            Citizen.Wait(Config.CookBurgerTime)
            FreezeEntityPosition(playerPed, false)
            ClearPedTasks(PlayerPedId())
            playerIsBusy(false)
            TriggerServerEvent("dgrp_mcdonalds:addItem", 'mcdonalds_burger')
            exports.pNotify:SendNotification({text = _U('BurgerNotifFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
            invBurger = invBurger + 1
        end
    end
end

function getSide()
    if Config.EnableAdvancedMode == true then
        playerIsBusy(true)
        menuIsOpen = true
        ESX.UI.Menu.CloseAll()	
        if isMorning == false then
            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'JobList',			
                {
                title    = "McDonalds Sides - Day",	
                description = "Created by DefectGaming's FuryFight3r",
                elements = {
                    {label = "Fries", value = '1'},
                    {label = "McNuggets", value = '2'}
                }
            },
            function(data, menu)
                local d = tonumber(data.current.value)
                if data.current.value == '1' then
                    if invFries >= 1 then
                        exports.pNotify:SendNotification({text = "Already have Fries/McNuggets!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("mp_common", "givetake1_a")
                        exports['progressBars']:startUI(Config.CookFriesTime, "Cooking Fries..")
                        FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookFriesTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Sides.Day[1].id)
                        holdingSideNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.SidePrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invFries = invFries + 1
                    end             
                end
                if data.current.value == '2' then
                    if invFries >= 1 then
                        exports.pNotify:SendNotification({text = "Already have McNuggets/Fries!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("mp_common", "givetake1_a")
                        exports['progressBars']:startUI(Config.CookFriesTime, "Cooking McNuggets..")
                        FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookFriesTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Sides.Day[2].id)
                        holdingSideNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.SidePrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invFries = invFries + 1
                    end 
                end
                menu.close()
	            menuIsOpen = false
            end,
                function(data, menu)
                menu.close()
	            menuIsOpen = false
            end)
        else
            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'JobList',			
                {
                title    = "McDonalds Sides - Morning",	
                description = "Created by DefectGaming's FuryFight3r",
                elements = {
                    {label = "Hot Cakes", value = '1'},
                    {label = "Hash Brown", value = '2'}
                }
            },
            function(data, menu)
                local d = tonumber(data.current.value)
                if data.current.value == '1' then
                    if invFries >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Hot Cake!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("mp_common", "givetake1_a")
                        exports['progressBars']:startUI(Config.CookFriesTime, "Cooking Hot Cakes..")
                        FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookFriesTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Sides.Morning[1].id)
                        holdingSideNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.SidePrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invFries = invFries + 1
                    end  
                end
                if data.current.value == '2' then
                    if invFries >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Hash Brown!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("mp_common", "givetake1_a")
                        exports['progressBars']:startUI(Config.CookFriesTime, "Cooking Hash Brown..")
                        FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookFriesTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Burgers.Morning[2].id)
                        holdingSideNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.SidePrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invFries = invFries + 1
                    end 
                end               
                menu.close()
	            menuIsOpen = false
            end,
                function(data, menu)
                menu.close()
	            menuIsOpen = false
            end)
        end
    else
        if invFries >= 2 then
            exports.pNotify:SendNotification({text = _U('FriesError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        else
            --Alerts | alert | notice | info | success | error 
            playerIsBusy(true)
            startAnim("mp_common", "givetake1_a")
            exports.pNotify:SendNotification({text = _U('FriesNotifStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            exports['progressBars']:startUI(Config.CookFriesTime, _('FriesBar'))
            FreezeEntityPosition(playerPed, true)
            Citizen.Wait(Config.CookFriesTime)
            FreezeEntityPosition(playerPed, false)
            ClearPedTasks(PlayerPedId())
            playerIsBusy(false)
            TriggerServerEvent("dgrp_mcdonalds:addItem", 'mcdonalds_fries')
            exports.pNotify:SendNotification({text = _U('FriesNotifFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
            invFries = invFries + 1
        end
    end
end

function getDrink()
    if Config.EnableAdvancedMode == true then
        playerIsBusy(true)
        menuIsOpen = true
        ESX.UI.Menu.CloseAll()	
        if isMorning == false then
            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'JobList',			
                {
                title    = "McDonalds Drinks - Day",	
                description = "Created by DefectGaming's FuryFight3r",
                elements = {
                    {label = "Coka Cola", value = '1'},
                    {label = "Orange Juice", value = '2'},
                    {label = "Fanta", value = '3'},
                    {label = "Milk Shake", value = '4'}
                }
            },
            function(data, menu)
                local d = tonumber(data.current.value)
                if data.current.value == '1' then
                    if invDrink >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Drink!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("mp_common", "givetake1_a")
                        exports['progressBars']:startUI(Config.CookDrinkTime, "Pouring Drink..")
                        FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookDrinkTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Drinks.Day[1].id)
                        holdingDrinkNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.DrinkPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invDrink = invDrink + 1
                    end             
                end
                if data.current.value == '2' then
                    if invDrink >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Drink!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("mp_common", "givetake1_a")
                        exports['progressBars']:startUI(Config.CookDrinkTime, "Pouring Drink..")
                        FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookDrinkTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Drinks.Day[2].id)
                        holdingDrinkNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.DrinkPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invDrink = invDrink + 1
                    end 
                end
                if data.current.value == '3' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Drink!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("mp_common", "givetake1_a")
                        exports['progressBars']:startUI(Config.CookDrinkTime, "Pouring Drink..")
                        FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookDrinkTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Drinks.Day[3].id)
                        holdingDrinkNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.DrinkPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invDrink = invDrink + 1
                    end
                end
                if data.current.value == '4' then
                    if invBurger >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        playerIsBusy(true)
                        startAnim("mp_common", "givetake1_a")
                        exports['progressBars']:startUI(Config.CookDrinkTime, "Pouring Drink..")
                        FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookDrinkTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        playerIsBusy(false)
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Drinks.Day[4].id)
                        holdingDrinkNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.DrinkPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invDrink = invDrink + 1
                    end
                end
                menu.close()
	            menuIsOpen = false
            end,
                function(data, menu)
                menu.close()
	            menuIsOpen = false
            end)
        else
            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'JobList',			
                {
                title    = "McDonalds Drinks - Morning",	
                description = "Created by DefectGaming's FuryFight3r",
                elements = {
                    {label = "Coffee", value = '1'},
                    {label = "Latte", value = '2'},
                    {label = "Americano", value = '3'},
                    {label = "Mocha", value = '4'},
                    {label = "Hot Chocolate", value = '5'}
                }
            },
            function(data, menu)
                local d = tonumber(data.current.value)
                if data.current.value == '1' then
                    if invDrink >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Drink!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        startAnim("mp_common", "givetake1_a")
                        exports['progressBars']:startUI(Config.CookDrinkTime, "Pouring Drink..")
                        FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookDrinkTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Drinks.Morning[1].id)
                        holdingDrinkNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.DrinkPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invDrink = invDrink + 1
                    end  
                end
                if data.current.value == '2' then
                    if invDrink >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        startAnim("mp_common", "givetake1_a")
                        exports['progressBars']:startUI(Config.CookDrinkTime, "Pouring Drink..")
                        FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookDrinkTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Drinks.Morning[2].id)
                        holdingDrinkNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.DrinkPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invDrink = invDrink + 1
                    end 
                end
                if data.current.value == '3' then
                    if invDrink >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        startAnim("mp_common", "givetake1_a")
                        exports['progressBars']:startUI(Config.CookDrinkTime, "Pouring Drink..")
                        FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookDrinkTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Drinks.Morning[3].id)
                        holdingDrinkNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.DrinkPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invDrink = invDrink + 1
                    end 
                end
                if data.current.value == '4' then
                    if invDrink >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        startAnim("mp_common", "givetake1_a")
                        exports['progressBars']:startUI(Config.CookDrinkTime, "Pouring Drink..")
                        FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookDrinkTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Drinks.Morning[4].id)
                        holdingDrinkNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.DrinkPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invDrink = invDrink + 1
                    end 
                end
                if data.current.value == '5' then
                    if invDrink >= 1 then
                        exports.pNotify:SendNotification({text = "Already have a Burger!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        menu.close()
	                    menuIsOpen = false
                        startAnim("mp_common", "givetake1_a")
                        exports['progressBars']:startUI(Config.CookDrinkTime, "Pouring Drink..")
                        FreezeEntityPosition(playerPed, true)
                        Citizen.Wait(Config.CookDrinkTime)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Drinks.Morning[5].id)
                        holdingDrinkNum = d
                        if Config.EnableCookPays == true then
                            local temp = Config.DrinkPrice / 5
                            TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                        end
                        invDrink = invDrink + 1
                    end 
                end
                
                menu.close()
	            menuIsOpen = false
            end,
                function(data, menu)
                menu.close()
	            menuIsOpen = false
            end)
        end
    else
        if invDrink >= 2 then
            exports.pNotify:SendNotification({text = _U('DrinkError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        else
            playerIsBusy(true)
            --Alerts | alert | notice | info | success | error 
            startAnim("mp_common", "givetake1_a")
            exports.pNotify:SendNotification({text = _U('DrinkNotifStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            exports['progressBars']:startUI(Config.CookDrinkTime, _U('DrinkBar'))
            FreezeEntityPosition(playerPed, true)
            Citizen.Wait(Config.CookDrinkTime)
            FreezeEntityPosition(playerPed, false)
            ClearPedTasks(PlayerPedId())
            playerIsBusy(false)
            TriggerServerEvent("dgrp_mcdonalds:addItem", 'mcdonalds_drink')
            exports.pNotify:SendNotification({text = _U('DrinkNotifFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
            invDrink = invDrink + 1
        end
    end
end

function getDesert()
    menuIsOpen = true
    playerIsBusy(true)
    ESX.UI.Menu.CloseAll()	
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'JobList',			
        {
        title    = "McDonalds Deserts - Day",	
        description = "Created by DefectGaming's FuryFight3r",
        elements = {
            {label = "McFlurry", value = '1'}
        }
    },
    function(data, menu)
        local d = tonumber(data.current.value)
        if data.current.value == '1' then
            if invDesert >= 1 then
                exports.pNotify:SendNotification({text = "Already have a McFlurry!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            else
                menu.close()
	            menuIsOpen = false
                playerIsBusy(true)
                startAnim("mp_common", "givetake1_a")
                exports['progressBars']:startUI(Config.CookDesertTime, "Making McFlurry..")
                FreezeEntityPosition(playerPed, true)
                Citizen.Wait(Config.CookDesertTime)
                FreezeEntityPosition(playerPed, false)
                ClearPedTasks(PlayerPedId())
                playerIsBusy(false)
                TriggerServerEvent("dgrp_mcdonalds:addItem", Config.Items.Deserts.Day[1].id)
                holdingDesertNum = d
                if Config.EnableCookPays == true then
                    local temp = Config.DesertPrice / 5
                    TriggerServerEvent("dgrp_mcdonalds:payDeposit", temp)
                end
                invDesert = invDesert + 1
            end             
        end
        menu.close()
	    menuIsOpen = false
    end,
        function(data, menu)
        menu.close()
	    menuIsOpen = false
    end)
end

function prepareMeal()
    if Config.EnableAdvancedMode == true then
        
    else
        if invBurger > 0 and invDrink > 0 and invFries > 0 then
            --Alerts | alert | notice | info | success | error 
            startAnim("misscarsteal2fixer", "confused_a")
            exports.pNotify:SendNotification({text = _U('MealNotifStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            exports['progressBars']:startUI(Config.CookPrepareTime, _U('MealBar'))
            FreezeEntityPosition(playerPed, true)
            Citizen.Wait(Config.CookPrepareTime)
            FreezeEntityPosition(playerPed, false)
            ClearPedTasks(PlayerPedId())
            exports.pNotify:SendNotification({text = _U('MealNotifFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
            invBurger = invBurger - 1
            invDrink = invDrink - 1
            invFries = invFries - 1
            mealsMade = mealsMade + 1
            TriggerServerEvent("dgrp_mcdonalds:removeItem", 'mcdonalds_burger')
            TriggerServerEvent("dgrp_mcdonalds:removeItem", 'mcdonalds_drink')
            TriggerServerEvent("dgrp_mcdonalds:removeItem", 'mcdonalds_fries')
            if Config.EnableMoreWorkMorePay == true then
                bonus = 1 * mealsMade
                payBonus = Config.CashJobPay * bonus
                TriggerServerEvent("dgrp_mcdonalds:getPaid", payBonus)
                if mealsMade > 1 then
                    ESX.ShowNotification('~b~You received a ~g~bonus~b~ for consecutive work. keep it up! Bonus: ~g~x'..bonus)
                end
                ESX.ShowNotification('~b~You were paid ~g~+$'..payBonus..'~b~.')
            else
                TriggerServerEvent("dgrp_mcdonalds:getPaid", Config.CookJobPay)
                ESX.ShowNotification('~b~You were paid ~g~+$'..Config.CookJobPay..'~b~.')
            end
        else
            exports.pNotify:SendNotification({text = _U('MealError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            exports.pNotify:SendNotification({text = "You Currently have x"..invBurger.." Fresh Burger(s), x"..invDrink.." Fresh Drink(s) and x"..invFries.." Fresh Fries", type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end
end

function takeOrder()
    if Config.EnableAdvancedMode == true then
        playerIsBusy(true)
        exports.pNotify:SendNotification({text = _U('CashStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        exports['progressBars']:startUI(Config.CashOrderTime, _U('CashBar'))
        FreezeEntityPosition(playerPed, true)
        startAnim("mp_common", "givetake1_a")
        local tempTime = Config.CashOrderTime / 2
        Citizen.Wait(tempTime)
        ClearPedTasks(PlayerPedId())
        startAnim("mp_take_money_mg", "stand_cash_in_bag_loop")
        Citizen.Wait(tempTime)
        FreezeEntityPosition(playerPed, false)
        ClearPedTasks(PlayerPedId())
        generateOrder()
        playerIsBusy(false)
        setDelivery()
    else
        if hasTakenOrder == false then
            --Alerts | alert | notice | info | success | error 
            playerIsBusy(true)
            exports.pNotify:SendNotification({text = _U('CashStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            exports['progressBars']:startUI(Config.CashOrderTime, _U('CashBar'))
            FreezeEntityPosition(playerPed, true)
            startAnim("mp_common", "givetake1_a")
            local tempTime = Config.CashOrderTime / 2
            Citizen.Wait(tempTime)
            ClearPedTasks(PlayerPedId())
            startAnim("mp_take_money_mg", "stand_cash_in_bag_loop")
            Citizen.Wait(tempTime)
            FreezeEntityPosition(playerPed, false)
            ClearPedTasks(PlayerPedId())
            exports.pNotify:SendNotification({text = _U('CashFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})        
            hasTakenOrder = true
            playerIsBusy(false)
        else
            exports.pNotify:SendNotification({text = _U('CashError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})       
        end
    end   
end

function cancelOrder()
    hasGeneratedOrder = false
    currentBurgerNum = 0
    currentBurgerID = ''
    currentBurgerName = ''
    burgerData = {}
    currentSideNum = 0
    currentSideID = ''
    currentSideName = ''
    sideData = {}
    currentDrinkNum = 0
    currentDrinkID = ''
    currentDrinkName = ''
    drinkData = {}
    currentDesertNum = 0
    currentDesertID = ''
    currentDesertName = ''
    desertData = {}
    invBurger = 0
    invFries = 0
    invDrink = 0
    invMeal = 0
    RemoveBlip(Blips['deliver'])
    dHasOrder = false
    isDriveDelivering = false
    dDeliveryCoords = nil
    hasOrder = false
    isDelivering = false
    deliveryCoords = nil
    playerIsBusy(false)
end

function pickupOrder()
    if hasOrder == false and hasTakenOrder == true then
        exports.pNotify:SendNotification({text = _U('PickupStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        exports['progressBars']:startUI(Config.CashMealTime, _U('PickupBar'))
        FreezeEntityPosition(playerPed, true)
        startAnim("mp_am_hold_up", "purchase_beerbox_shopkeeper")
        Citizen.Wait(4000)
        ClearPedTasks(PlayerPedId())
        startAnim("misscarsteal2fixer", "confused_a")
        Citizen.Wait(Config.CashMealTime - 4000)
        ClearPedTasks(PlayerPedId())
        FreezeEntityPosition(playerPed, false)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent("dgrp_mcdonalds:addItem", 'mcdonalds_meal')
        exports.pNotify:SendNotification({text = _U('PickupFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
        invMeal = invMeal + 1
        hasOrder = true
        setDelivery()
    elseif hasOrder == true and hasTakenOrder == true then
        exports.pNotify:SendNotification({text = _U('PickupError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    elseif hasTakenOrder == false and hasOrder == false then
        exports.pNotify:SendNotification({text = _U('PickupError1'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        exports.pNotify:SendNotification({text = _U('PickupError2'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end

local display = false

RegisterNetEvent("nui:CheckOrder_On")
AddEventHandler("nui:CheckOrder_On", function()
    SendNUIMessage({
        type = "ui",
        display = true
	})
end)

RegisterNetEvent("nui:CheckOrder_Off")
AddEventHandler("nui:CheckOrder_Off", function()
    SendNUIMessage({
        type = "ui",
        display = false
	})
end)

local hasTurnedOff = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not hasTurnedOff then
            TriggerEvent("nui:CheckOrder_Off")
            hasTurnedOff = true
        end
        if currentZone == 'dCheck' then
            if IsControlJustReleased(0, 18) then
                playerIsBusy(false)
                TriggerEvent("nui:CheckOrder_Off")
		        pickupDelivery()												
		        Citizen.Wait(500)
            end
	        if IsControlJustReleased(0, 238) then
                playerIsBusy(false)
                TriggerEvent("nui:CheckOrder_Off")												
		        Citizen.Wait(500)
	        end
        end
    end
end)

function checkOrder()
    TriggerEvent("nui:CheckOrder_On")
    playerIsBusy(true)
end

function setDelivery()
    if Config.EnableAdvancedMode == true then
        repeat
        deliveryPoint = math.random(1, #Config.cashDeliveryPoints)
	    until deliveryPoint ~= lastDelivery
	    deliveryCoords = Config.cashDeliveryPoints[deliveryPoint]
  	    taskPoints['delivery'] = { x = deliveryCoords.x, y = deliveryCoords.y, z = deliveryCoords.z}
	    lastDelivery = deliveryPoint
        isDelivering = true
        setGPS(deliveryCoords)
    else
        repeat
        deliveryPoint = math.random(1, #Config.cashDeliveryPoints)
	    until deliveryPoint ~= lastDelivery
	    deliveryCoords = Config.cashDeliveryPoints[deliveryPoint]
  	    taskPoints['delivery'] = { x = deliveryCoords.x, y = deliveryCoords.y, z = deliveryCoords.z}
	    lastDelivery = deliveryPoint
        isDelivering = true
        setGPS(deliveryCoords)
        exports.pNotify:SendNotification({text = _U('Table')..deliveryPoint, type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end

function deliverOrder()
    if Config.EnableAdvancedMode == true then
        
    else
        local tempTime = Config.CashDelivTime / 2
        exports.pNotify:SendNotification({text = _U('GiveStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        exports['progressBars']:startUI(Config.CashDelivTime, _U('GiveBar'))
        FreezeEntityPosition(playerPed, true)
        startAnim("mp_am_hold_up", "purchase_beerbox_shopkeeper")
        Citizen.Wait(tempTime)
        ClearPedTasks(PlayerPedId())
        startAnim("mp_common", "givetake1_a")
        Citizen.Wait(tempTime)
        ClearPedTasks(PlayerPedId())

        FreezeEntityPosition(playerPed, false)
        ClearPedTasks(PlayerPedId())
        exports.pNotify:SendNotification({text = _U('GiveFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
        customersServed = customersServed + 1
        RemoveBlip(Blips['deliver'])
        TriggerServerEvent("dgrp_mcdonalds:removeItem", 'mcdonalds_meal')
        if Config.EnableMoreWorkMorePay == true then
            bonus = 1 * customersServed
            payBonus = Config.CashJobPay * bonus
            TriggerServerEvent("dgrp_mcdonalds:getPaid", payBonus)
            if customersServed > 1 then
                ESX.ShowNotification('~b~You received a ~g~bonus~b~ for consecutive work. keep it up! Bonus: ~g~x'..bonus)
            end
            ESX.ShowNotification('~b~You were paid ~g~+$'..payBonus..'~b~.')
        else
            TriggerServerEvent("dgrp_mcdonalds:getPaid", Config.CashJobPay)
            ESX.ShowNotification('~b~You were paid ~g~+$'..Config.CashJobPay..'~b~.')
        end

        hasOrder = false
        hasTakenOrder = false
        isDelivering = false
        deliveryCoords = nil
    end
end

function pickupDelivery()
    if Config.EnableAdvancedMode == true then
        playerIsBusy(true)
        exports.pNotify:SendNotification({text = "Checking Online Orders for outbound Delivery", type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        exports['progressBars']:startUI(Config.CashOrderTime, "Checking Online Orders")
        FreezeEntityPosition(playerPed, true)
        startAnim("misscarsteal2fixer", "confused_a")
        local tempTime = Config.CashOrderTime / 2
        Citizen.Wait(tempTime)
        ClearPedTasks(PlayerPedId())
        startAnim("mp_take_money_mg", "stand_cash_in_bag_loop")
        Citizen.Wait(tempTime)
        FreezeEntityPosition(playerPed, false)
        ClearPedTasks(PlayerPedId())
        generateOrder()
        playerIsBusy(false)
        setDriveDelivery()
    else
        if dHasOrder == false then
            startAnim("misscarsteal2fixer", "confused_a")
            exports.pNotify:SendNotification({text = _U('PickupStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            exports['progressBars']:startUI(Config.CashMealTime, "Collecting McDonalds Order")
            FreezeEntityPosition(playerPed, true)
            Citizen.Wait(Config.CashMealTime)
            FreezeEntityPosition(playerPed, false)
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent("dgrp_mcdonalds:addItem", 'mcdonalds_meal')
            exports.pNotify:SendNotification({text = _U('PickupFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
            invMeal = invMeal + 1
            dHasOrder = true
            setDriveDelivery()
        elseif dHasOrder == true then
            exports.pNotify:SendNotification({text = _U('PickupError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        else
            exports.pNotify:SendNotification({text = _U('PickupError2'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end
end

function setDriveDelivery()
    repeat
    deliveryPoint = math.random(1, #Config.driveDeliveryPoints)
	until deliveryPoint ~= lastDelivery
	dDeliveryCoords = Config.driveDeliveryPoints[deliveryPoint]
	lastDelivery = deliveryPoint
    isDriveDelivering = true
    setGPS(dDeliveryCoords)
    exports.pNotify:SendNotification({text = _U('DelivNotif'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
end

function isMyCar()
	return currentPlate == GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
end

function openWorkVehicleMenu()
    playerIsBusy(true)
    if driverHasCar == true then
        replaceLostCar(true)
        exports.pNotify:SendNotification({text = _U('CarError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        openVehicleMenu()
        exports.pNotify:SendNotification({text = _U('CarChoose'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end

function replaceLostCar(bool)
    if bool == true then
        ESX.Game.DeleteVehicle(currentCar)			
        driverHasCar = false
        exports.pNotify:SendNotification({text = _U('CarError1'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        ESX.UI.CloseAll()
    end
    playerIsBusy(false)
end

function openVehicleMenu()
    playerIsBusy(true)
    vehicleMenuIsOpen = true
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'VehicleList',			
        {
        title    = _U('CarTitle'),	
        elements = {
            {label = _U('CarVan')..Config.VanDepositAmount, value = 'van'},		
            {label = _U('CarBike')..Config.BikeDepositAmount, value = 'bike'}
        }
    },
    function(data, menu)									
        if data.current.value == 'van' then	
            playerIsBusy(false)
            menu.close()
	        vehicleMenuIsOpen = false
            spawnVehicle(Config.CarToSpawn, Config.VanDepositAmount)  
            if Config.PayDeposit == true then
                exports.pNotify:SendNotification({text = _U('DepositNotif'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
                paidDeposit = Config.VanDepositAmount
            else
                exports.pNotify:SendNotification({text = _U('SpawnedNotif'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
            end

        end
        if data.current.value == 'bike' then
            menu.close()
            playerIsBusy(false)
	        vehicleMenuIsOpen = false
            spawnVehicle(Config.BikeToSpawn, Config.BikeDepositAmount)  
            if Config.PayDeposit == true then
                exports.pNotify:SendNotification({text = _U('DepositNotif'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
                paidDeposit = Config.BikeDepositAmount
            else
                exports.pNotify:SendNotification({text = _U('SpawnedNotif'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
            end
        end
        menu.close()
	    vehicleMenuIsOpen = false
    end,
        function(data, menu)
        menu.close()
	    vehicleMenuIsOpen = false
    end)
end

function spawnVehicle(carToSpawn, depositAmount)
    if Config.PayDeposit == true then
        TriggerServerEvent("dgrp_mcdonalds:payDeposit", depositAmount)
    end
	local vehicleModel = GetHashKey(carToSpawn)	
	RequestModel(vehicleModel)				
	while not HasModelLoaded(vehicleModel) do	
		Citizen.Wait(0)
	end
	currentCar = CreateVehicle(vehicleModel, Config.DeliveryCarSpawn.x, Config.DeliveryCarSpawn.y, Config.DeliveryCarSpawn.z, Config.DeliveryCarSpawn.h, true, false)
	SetVehicleHasBeenOwnedByPlayer(currentCar,  true)														
	SetEntityAsMissionEntity(currentCar,  true,  true)														
	SetVehicleNumberPlateText(currentCar, "MACCAS")								
	local id = NetworkGetNetworkIdFromEntity(currentCar)													
	SetNetworkIdCanMigrate(id, true)																																																
	TaskWarpPedIntoVehicle(GetPlayerPed(-1), currentCar, -1)
    driverHasCar = true
	local props = {																							
		modEngine       = 0,
		modTransmission = 0,
		modSuspension   = 3,
		modTurbo        = true,																				
	}
	ESX.Game.SetVehicleProperties(currentCar, props)
	Wait(1000)																							
	currentPlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
end

function deleteCar()
    if isMyCar() == true then
        if Config.PayDeposit == true then
            TriggerServerEvent("dgrp_mcdonalds:returnDeposit", paidDeposit)
            ESX.ShowNotification('~b~Your deposit has been returned ~g~+$'..paidDeposit..'~b~.')
            paidDeposit = 0
        end
    	local entity = GetVehiclePedIsIn(GetPlayerPed(-1), false)	
	    ESX.Game.DeleteVehicle(entity)			
        driverHasCar = false
        exports.pNotify:SendNotification({text = _U('DespawnedNotif'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        exports.pNotify:SendNotification({text = _U('ReturnError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end

function setGPS(coords)
	if Blips['deliver'] ~= nil then 	
		RemoveBlip(Blips['deliver'])	
		Blips['deliver'] = nil			
	end
	if coords ~= 0 then
		Blips['deliver'] = AddBlipForCoord(coords.x, coords.y, coords.z)		
		SetBlipRoute(Blips['deliver'], true)								
	end
end

function driveFromDelivery()
 startAnim("mp_am_hold_up", "purchase_beerbox_shopkeeper")
    exports.pNotify:SendNotification({text = _U('GiveStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    exports['progressBars']:startUI(Config.CashDelivTime, _U('GiveBar'))
    FreezeEntityPosition(playerPed, true)
    Citizen.Wait(Config.CashDelivTime)
    FreezeEntityPosition(playerPed, false)
    ClearPedTasks(PlayerPedId())
    exports.pNotify:SendNotification({text = _U('GiveFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
    ordersDelivered = ordersDelivered + 1
    RemoveBlip(Blips['deliver'])
    TriggerServerEvent("dgrp_mcdonalds:removeItem", 'mcdonalds_meal')
    if Config.EnableMoreWorkMorePay == true then
        bonus = 1 * ordersDelivered
        payBonus = Config.DelivJobPay * bonus
        TriggerServerEvent("dgrp_mcdonalds:getPaid", payBonus)
        if customersServed > 1 then
            ESX.ShowNotification('~b~You received a ~g~bonus~b~ for consecutive work. keep it up! Bonus: ~g~x'..bonus)
        end
        ESX.ShowNotification('~b~You were paid ~g~+$'..payBonus..'~b~.')
    else
        TriggerServerEvent("dgrp_mcdonalds:getPaid", Config.DelivJobPay)
        ESX.ShowNotification('~b~You were paid ~g~+$'..Config.DelivJobPay..'~b~.')
    end

    dHasOrder = false
    isDriveDelivering = false
    dDeliveryCoords = nil
end

local mBlipsCreated = 0
local jBlipsCreated = 0

function deleteBlips()
    if mBlipsCreated > 0 or blipM ~= nil then
        RemoveBlip(blipM)
        mBlipsCreated = mBlipsCreated - 1
        Citizen.Wait(100)
    end
    if jBlipsCreated > 0 or blipJ ~= nil then
        RemoveBlip(blipJ)
        jBlipsCreated = jBlipsCreated - 1
        Citizen.Wait(100)
    end
    showingBlips = false
    if Config.EnableBlips == true and showingBlips == false and mBlipsCreated == 0 and jBlipsCreated == 0 then
        refreshBlips()
    elseif showingBlips == false and mBlipsCreated > 0 or jBlipsCreated > 0 and showingBlips == false then
        deleteBlips()
    end
end

function refreshBlips()
    if showingBlips == false then
        if mBlipsCreated == 0 then
            local blipM = AddBlipForCoord(Config.blipLocationM.x, Config.blipLocationM.y)

            SetBlipSprite(blipM, Config.blipIDM)
            SetBlipDisplay(blipM, 6)
            SetBlipScale(blipM, Config.blipScaleM)
            SetBlipColour(blipM, Config.blipColorM)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(_U('McDonaldsBlip'))
            EndTextCommandSetBlipName(blipM)
            mBlipsCreated = mBlipsCreated + 1
        end
        if currentPlayerJobName ~= nil then
            if currentPlayerJobName == jobTitle and Config.EnableJobBlip == false then
                if jBlipsCreated == 0 then
                    local blipJ = AddBlipForCoord(Config.blipLocationJ.x, Config.blipLocationJ.y)
                    jBlipsCreated = jBlipsCreated + 1
                    SetBlipSprite(blipJ, Config.blipIDJ)
                    SetBlipDisplay(blipJ, 6)
                    SetBlipScale(blipJ, Config.blipScaleJ)
                    SetBlipColour(blipJ, Config.blipColorJ)
                    SetBlipAsShortRange(blip, true)

                    BeginTextCommandSetBlipName('STRING')
                    AddTextComponentString(_U('McDonaldsJobBlip'))
                    EndTextCommandSetBlipName(blipJ)
                end
            elseif Config.EnableJobBlip == true then
                if jBlipsCreated == 0 then
                    local blipJ = AddBlipForCoord(Config.blipLocationJ.x, Config.blipLocationJ.y)
                    mBlipsCreated = mBlipsCreated + 1
                    SetBlipSprite(blipJ, Config.blipIDJ)
                    SetBlipDisplay(blipJ, 6)
                    SetBlipScale(blipJ, Config.blipScaleJ)
                    SetBlipColour(blipJ, Config.blipColorJ)
                    SetBlipAsShortRange(blip, true)

                    BeginTextCommandSetBlipName('STRING')
                    AddTextComponentString(_U('McDonaldsJobBlip'))
                    EndTextCommandSetBlipName(blipJ)
                end
            end
        end
        showingBlips = true
    else
        deleteBlips()
    end
end

function displayMarker(coords)
            --Type  |X|         Y|      Z|      dX|  dY|  dZ| rX| rY|  rZ|  sX|  sY|  sZ|          R|                          G|                      B|                      A|            Animate|FC| P19|  rot|texDict|texName|ents
	DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.JobMarkerColor.r, Config.JobMarkerColor.g, Config.JobMarkerColor.b, Config.JobMarkerColor.a, true, true, 2, false, false, false, false) 
end

function deliveryMarker(coords)
    DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.0, Config.JobMarkerColor.r, Config.JobMarkerColor.g, Config.JobMarkerColor.b, Config.JobMarkerColor.a, true, true, 2, false, false, false, false)
    DrawMarker(29, coords.x, coords.y, coords.z + 1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.DeliveryMarkerColor.r, Config.DeliveryMarkerColor.g, Config.DeliveryMarkerColor.b, Config.JobMarkerColor.a, true, true, 2, false, false, false, false)
end

function deliveryDMarker(coords)
    DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.5, Config.JobMarkerColor.r, Config.JobMarkerColor.g, Config.JobMarkerColor.b, Config.JobMarkerColor.a, true, true, 2, false, false, false, false)
    DrawMarker(29, coords.x, coords.y, coords.z + 1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.DeliveryMarkerColor.r, Config.DeliveryMarkerColor.g, Config.DeliveryMarkerColor.b, Config.JobMarkerColor.a, true, true, 2, false, false, false, false)
end

function destroyMarker(coords)
    DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 255, 0, 0, 200, true, true, 2, false, false, false, false)
    DrawMarker(36, coords.x, coords.y, coords.z + 1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.CarDespawnMarkerColor.r, Config.CarDespawnMarkerColor.g, Config.CarDespawnMarkerColor.b, Config.CarDespawnMarkerColor.a, true, true, 2, false, false, false, false)
end

--Select McDonalds Job
function openMenu()
    playerIsBusy(true)
    menuIsOpen = true
    ESX.UI.Menu.CloseAll()										
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'JobList',			
        {
        title    = _U('ListingTitle'),	
        description = "Created by DefectGaming's FuryFight3r",
        elements = {
            {label = _U('Cashier'), value = 'cashier'},
            {label = _U('Cook'), value = 'cook'},
            {label = _U('Deliv'), value = 'deliv'}
        }
    },
    function(data, menu)									
        if data.current.value == 'cashier' then
            if Config.EnablePlayerCashier == true then
                if currentJob == 'cashier' then
                    exports.pNotify:SendNotification({text = _U('CashierError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                else
                    currentJob = 'cashier'
                    --Change Job Grade Here
                    exports.pNotify:SendNotification({text = _U('CashierSuccess'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
                    onDuty = true
                    cancelOrder()
                    playerIsBusy(false)
                end
            else
                exports.pNotify:SendNotification({text = "The Cashier Position is closed to Players on this server. If you beleive this is an error please contact an admin.", type = "error", timeout = 5000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end
        if data.current.value == 'cook' then
            if Config.EnablePlayerCook == true then
                if currentJob == 'cook' then
                    exports.pNotify:SendNotification({text = _U('CookError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                else
                    currentJob = 'cook'
                    --Change Job Grade Here
                    exports.pNotify:SendNotification({text = _U('CookSuccess'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
                    onDuty = true
                    cancelOrder()
                    playerIsBusy(false)
                end 
            else
                exports.pNotify:SendNotification({text = "The Cook Position is closed to Players on this server. If you beleive this is an error please contact an admin.", type = "error", timeout = 5000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end
        if data.current.value == 'deliv' then
            if Config.EnablePlayerDriver == true then 
                if currentJob == 'deliv' then
                    exports.pNotify:SendNotification({text = _U('DriverError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                else
                    currentJob = 'deliv'
                    --Change Job Grade Here
                    exports.pNotify:SendNotification({text = _U('DriverSuccess'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
                    onDuty = true
                    cancelOrder()
                    playerIsBusy(false)
                end
            else
                exports.pNotify:SendNotification({text = "The Delivery Driver Position is closed to Players on this server. If you beleive this is an error please contact an admin.", type = "error", timeout = 5000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end
        menu.close()
	    menuIsOpen = false
        playerIsBusy(false)
    end,
        function(data, menu)
        menu.close()
	    menuIsOpen = false
        playerIsBusy(false)
    end)
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
	end)
end

--Commands

RegisterCommand("giveorder", function(source, receiverID)
    Citizen.CreateThread(function()
        if onDuty and currentJob == 'cook' and Config.EnableAdvancedMode == true then
            local receiver = tonumber(receiverID[1])
            if invBurger > 0 and invDrink > 0 and invFries > 0 then
                if holdingBurgerNum > 0 and holdingDrinkNum > 0 and holdingSideNum > 0 then
                    if receiver ~= nil then
                        if morningOrder == true then
                            dPrint("(CLIENT) Receiver is NOT nil - Gave Order to Player ID: "..receiver)
                            TriggerServerEvent('dgrp_mcdonalds:giveOrder', source, receiver, Config.Items.Burgers.Morning[holdingBurgerNum].id, Config.Items.Drinks.Morning[holdingDrinkNum].id, Config.Items.Sides.Morning[holdingSideNum].id)
                        else
                            dPrint("(CLIENT) Receiver is NOT nil - Gave Order to Player ID: "..receiver)
                            TriggerServerEvent('dgrp_mcdonalds:giveOrder', source, receiver, Config.Items.Burgers.Day[holdingBurgerNum].id, Config.Items.Drinks.Day[holdingDrinkNum].id, Config.Items.Sides.Day[holdingSideNum].id)
                        end  
                    else
                        dPrint("Receiver IS NIL! Unable to send Client Side.")
                    end
                else
                    dPrint("Could not Identify the Items you Gathered!")
                end
            else
                dPrint("You do not have a Burger, Drink and Side to give to Cashier")
            end
        else
            dPrint("You are not a cook")
        end
    end)
end)

--Testing Commands
RegisterCommand("cook", function()
    Citizen.CreateThread(function()
        currentJob = 'cook'
        --Change Job Grade Here
        exports.pNotify:SendNotification({text = _U('CookSuccess'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
        onDuty = true
        isDelivering = false
        invMeal = 0
        invBurger = 0
        invDrink = 0
        invFries = 0
        hasOrder = false
        hasTakenOrder = false
    end)
end)

RegisterCommand("driver", function()
    Citizen.CreateThread(function()
        currentJob = 'deliv'
        --Change Job Grade Here
        exports.pNotify:SendNotification({text = _U('CookSuccess'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
        onDuty = true
        isDelivering = false
        invMeal = 0
        invBurger = 0
        invDrink = 0
        invFries = 0
        hasOrder = false
        hasTakenOrder = false
    end)
end)

RegisterCommand("cash", function()
    Citizen.CreateThread(function()
        currentJob = 'cashier'
        --Change Job Grade Here
        exports.pNotify:SendNotification({text = _U('CookSuccess'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
        onDuty = true
        isDelivering = false
        invMeal = 0
        invBurger = 0
        invDrink = 0
        invFries = 0
        hasOrder = false
        hasTakenOrder = false
    end)
end)

RegisterCommand("order", function()
    Citizen.CreateThread(function()
        takeOrder()
        TriggerEvent("chat:addMessage", {args={Config.Prefix.."Ordering Meal"}}) 
    end)
end)

RegisterCommand("stuck", function()
    Citizen.CreateThread(function()
        playerIsBusy(false)
    end)
end)

RegisterCommand("cancelorder", function()
    Citizen.CreateThread(function()
        TriggerEvent("chat:addMessage", {args={Config.Prefix.."Canceling Current Order"}}) 
        cancelOrder()
    end)
end)

function dPrint(msg)
    print(""..Config.Prefix..""..msg..".")
end