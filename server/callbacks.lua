local shop = {}

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

function findCarByModel(model)
	for i = 1, #Config.Vehicles do
		local car = Config.Vehicles[i]
		if car.model == model then
			return car
		end
	end

	return false
end
