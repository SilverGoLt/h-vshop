local testDriving = false
local testVehicle
local testShop

RegisterNUICallback('testDrive', function(data, cb)
    ESX.TriggerServerCallback('h-vshop:testDrive', function(success)
        if success then
            testDriving = true
            local shop = Utils.getShop()
            testShop = shop

            if shop then
                local sPos = shop.delivery.pos
                local sHeading = shop.delivery.heading
                ESX.Game.SpawnLocalVehicle(data.vehicle, sPos, heading, function(vehicle)
                    testVehicle = vehicle
                end)
                Wait(100)
                SetPedIntoVehicle(PlayerPedId(), testVehicle, -1)
                StartTestTimer()
            end
            cb(true)
        else
            cb(false)
        end
    end, data.vehicle)
end)

RegisterNUICallback('stopTestDrive', function(data, cb)
    if testDriving then
        testDriving = false
        SendNUIMessage({
            type = 'stopTimer',
        })
        ESX.Game.DeleteVehicle(testVehicle)
        SetEntityCoords(PlayerPedId(), testShop.pos)
        ESX.TriggerServerCallback('h-vshop:removeBucket', function(success)
            if not success then
                print('Failed to remove bucket')
            end
        end)
        cb(true)
    else
        cb(false)
    end
end)

local testTime = Config.TestTime
StartTestTimer = function ()
    SendNUIMessage({
        type = 'startTimer',
        time = testTime
    })
end