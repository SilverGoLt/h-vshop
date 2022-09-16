local shop = {}

local inUseBuckets = {}

ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function(source, cb, plate)
	MySQL.scalar('SELECT plate FROM owned_vehicles WHERE plate = ?', {plate},
	function(result)
		cb(result ~= nil)
	end)
end)

ESX.RegisterServerCallback('h-vshop:buyCar', function (source, cb, model, plate)
	if source ~= nil and source ~= -1 then
		local result = shop.purchaseCar(source, model, plate)

		if result then
			cb(true)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('h-vshop:setOwned', function(source, cb, props)
	if source ~= nil and source ~= -1 then
		if not props then return end

		local result = shop.setOwned(source, props)

		if result then
			cb(true)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('h-vshop:testDrive', function (source, cb, model)
	local bucketSet = shop.testDrive(source, model)
	
	if bucketSet then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('h-vshop:removeBucket', function (source, cb, bucket)
	if source ~= nil and source ~= -1 then
		local bucket = GetPlayerRoutingBucket(source)

		if bucket ~= 0 then
			SetPlayerRoutingBucket(source, 0)
			inUseBuckets[bucket] = nil
			cb(true)
		else
			cb(false)
		end
	end
end)

function shop.setOwned(source, props)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local result = MySQL.insert.await('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (?,?,?)', {
			xPlayer.identifier,
			props.plate,
			json.encode(props)
		})

		if result then return true else return false end
	end
end

function shop.purchaseCar(source,model, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local vehicle = findCarByModel(model)

	if vehicle then
		local vPrice = vehicle.price
		if Config.Payment == 'bank' then
			local balance = xPlayer.getAccount('bank').money
			if balance >= vPrice then
				xPlayer.removeAccountMoney('bank', vPrice)
				TriggerClientEvent('esx:showNotification', source, 'You have purchased a ' .. vehicle.name .. ' for $' .. vPrice)
				return true
			else
				TriggerClientEvent('esx:showNotification', source, 'Sorry but you need: $' .. vPrice .. ' to purchase a ' .. vehicle.name)
				return false
			end
		end
	else
		print('Issues finding the vehicle from the config.lua file!')
	end
end

function shop.testDrive(source, model)
	local car = findCarByModel(model)
	if source ~= -1 or source ~= nil and car then
		local bucket = GetPlayerRoutingBucket(source)

		if bucket == 0 then
			local r = math.random(400, 900)
			if not inUseBuckets[r] then
				inUseBuckets[r] = true
				SetPlayerRoutingBucket(source, r)
				Player(source).state.bucket = r
				return true
			else
				return false
			end
		else
			return false
		end
	end
end

function findCarByModel(model)
	for i = 1, #Config.Vehicles do
		local car = Config.Vehicles[i]
		if car.model == model then
			return car
		end
	end

	return false
end

local Debug = false

if Debug then
	RegisterCommand('getPlayerBucket', function(source)
		local bucket = GetPlayerRoutingBucket(source)
		print('Bucket: ' .. bucket)
	end)

	RegisterCommand('resetPlayerBucket', function (source)
		SetPlayerRoutingBucket(source, 0)
	end)
end