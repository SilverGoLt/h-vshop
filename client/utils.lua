Utils = {}
local Blips = {}
local currentVeh = false

Utils.createCamera = function (pos, heading, distance)
    if not _Camera and currentVeh then
        local forward = GetOffsetFromEntityInWorldCoords(currentVeh, -0.0, distance, 0.0)

        _Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        RenderScriptCams(true, true, 500, 1, 0)
        SetCamActive(_Camera, true)
        SetCamRot(_Camera, -3.0, 0.0, heading - 180)
        SetCamFov(_Camera, 60.0)
        SetCamCoord(_Camera, forward.x, forward.y, forward.z + 0.5)
    end
end

Utils.destroyCam = function()
    if _Camera then
        DestroyCam(_Camera)
        RenderScriptCams(false, true, 500, 1, 0)
        _Camera = false
    end
end

Utils.createBlips = function ()
    if #Blips < 1 then
        for k,v in pairs(Config.Shops) do
            local blip = AddBlipForCoord(v.pos.x, v.pos.y, v.pos.z)
            SetBlipSprite(blip, v.blip.sprite)
            SetBlipDisplay(blip, 2)
            SetBlipScale(blip, 0.6)
            SetBlipColour(blip, v.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.name)
            EndTextCommandSetBlipName(blip)
            Blips[#Blips+1] = blip
        end
    end
end

Utils.drawMarker = function (pos)
    DrawMarker(1, pos.x, pos.y, pos.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.3, 255, 255, 255, 100, false, true, 2, false, false, false, false)
end

Utils.openShop = function ()
    local shop = Utils.getShop()

    -- Cancels opening the shop since the UI is open?
    if _UIOpen then return end

    if shop then
        local cars = Utils.getShopVehicles(shop.category)
        if cars then
            local spawn = false
            Utils.spawnShowcase()

            SendNUIMessage({
                type = 'open',
                shop = shop,
                cars = cars,
                translation = Config.Translation
            })
            SetNuiFocus(true, true)
        end
    end
end

Utils.deleteVehicle = function()
    if currentVeh then
        ESX.Game.DeleteVehicle(currentVeh)
        currentVeh = false
        return true
    else
        return false
    end
end

Utils.spawnShowcase = function(vehicle)
    local shop = Utils.getShop()
    local pos = shop.preview
    local heading = shop.previewHeading
    local distance = shop.cameraDistance or 5.0

    local cars = Utils.getShopVehicles(shop.category)

    if not cars then return end

    if pos then
        if not currentVeh and not vehicle then
            ESX.Game.SpawnLocalVehicle(cars[1].model, vector3(pos.x, pos.y, pos.z), heading, function(vehicle)
               currentVeh = vehicle
               Utils.createCamera(pos, heading, distance)
            end)
        else
            ESX.Game.DeleteVehicle(currentVeh)

            ESX.Game.SpawnLocalVehicle(vehicle, vector3(pos.x, pos.y, pos.z), heading, function(vehicle)
               currentVeh = vehicle
               return true
            end)
        end
        return false
    end

end

Utils.getShop = function ()
    local ped = PlayerPedId()
    local playerPos = GetEntityCoords(ped)

    for k,v in pairs(Config.Shops) do
        local shopPos = v.pos
        local distance = #(playerPos - shopPos)
        if distance < 3 then
            return v
        end
    end

    return false
end

Utils.spawnVehicle = function(model, plate)
    local shop = Utils.getShop()
    if shop then
        local sPos = shop.delivery.pos
        local sHeading = shop.delivery.heading
        local isClear = ESX.Game.IsSpawnPointClear(sPos, 3)
        
        while not isClear do
            Citizen.Wait(100)
            isClear = ESX.Game.IsSpawnPointClear(sPos, 3)
        end

        ESX.Game.SpawnVehicle(model, sPos, sHeading, function(vehicle)
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            local props = ESX.Game.GetVehicleProperties(vehicle)
            props.plate = plate
            SetVehicleNumberPlateText(vehicle, plate)

            ESX.TriggerServerCallback('h-vshop:setOwned', function(success)
                if not success then print('Issues with setOwned callback!') end
            end, props)

        end)
    end
end

Utils.getShopVehicles = function (category)
    local vehicles = {}
    for k,v in pairs(Config.Vehicles) do
        if v.category == category then
            vehicles[#vehicles+1] = v
        end
    end

    return vehicles
end