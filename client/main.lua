_Camera = false
_Loaded = false
_UIOpen = false
-- Init blips on player loaded
RegisterNetEvent('esx:playerLoaded', function()
    Utils.createBlips()
    _Loaded = true
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Utils.createBlips()
        print('[INFO] Resource started')
        _Loaded = true
    end
end)

-- Marker Thread
local mSleep = 500
CreateThread(function ()
    while true do
        for i = 1, #Config.Shops do
            local shop = Config.Shops[i]
            local ped = PlayerPedId()
            local playerPos = GetEntityCoords(ped)
            local markerPos = shop.pos
            distance = #(playerPos - markerPos)
            if distance < 3 then
                Utils.drawMarker(markerPos)
                mSleep = 5
                break
            else
                mSleep = 500
            end
        end
        Wait(mSleep)
    end
end)

RegisterNUICallback('selectCar', function(data, cb)
    if data then
        local vehicle = data.vehicle

        if vehicle then
            Utils.spawnShowcase(vehicle)
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterNUICallback('rotateVeh', function (body, resultCallback)
    if body.type then
        Utils.rotateVehicle(body.type)
        resultCallback(true)
    end
end)

RegisterNUICallback('closeShop', function (data, cb)
    _UIOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({type = 'close'})
    Utils.destroyCam()

    local delete = Utils.deleteVehicle()
    if not delete then
        print('[DEBUG] Could not delete vehicle!')
    end

    cb(true)
end)

RegisterNUICallback('purchase', function (data,cb)
    local plate = GeneratePlate()
    local shop = Utils.getShop()
    local sPos = shop.delivery.pos
    local sHeading = shop.delivery.heading

    ESX.TriggerServerCallback('h-vshop:buyCar', function(success)
        if success then
            cb(true)
        else
            cb(false)
        end
    end, {model = data.vehicle, plate = plate, pos = sPos, heading = sHeading})
end)

RegisterCommand('openCarShop', function()
    Utils.openShop()
end, false)

RegisterKeyMapping('openCarShop', 'Opens vehicle shop', 'keyboard', 'e')