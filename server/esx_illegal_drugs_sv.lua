ESX = nil

local CopsConnected = 0
local PlayersHarvestingCoke, PlayersTransformingCoke, PlayersSellingCoke, PlayersHarvestingMeth, PlayersTransformingMeth, PlayersSellingMeth, PlayersHarvestingWeed, PlayersTransformingWeed, PlayersSellingWeed, PlayersHarvestingOpium, PlayersTransformingOpium, PlayersSellingOpium = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

function CountCops()
	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i = 1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

-- Weed
local function HarvestWeed(source)
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if CopsConnected < Config.RequiredCopsWeed then
		xPlayer.showNotification(_U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToFarmWeed, function()
		if PlayersHarvestingWeed[source] == true then
			local weed = xPlayer.getInventoryItem('weed')

			if not xPlayer.canCarryItem('weed', weed.weight) then
				xPlayer.showNotification(_U('inv_full_weed'))
			else
				xPlayer.addInventoryItem('weed', 1)
				HarvestWeed(source)
			end

		end
	end)
end

RegisterServerEvent('esx_illegal_drugs:startHarvestWeed')
AddEventHandler('esx_illegal_drugs:startHarvestWeed', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	PlayersHarvestingWeed[_source] = true
	xPlayer.showNotification(_U('pickup_in_prog'))
	HarvestWeed(_source)
end)

RegisterServerEvent('esx_illegal_drugs:stopHarvestWeed')
AddEventHandler('esx_illegal_drugs:stopHarvestWeed', function()
	local _source = source

	PlayersHarvestingWeed[_source] = false
end)

local function TransformWeed(source)
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if CopsConnected < Config.RequiredCopsWeed then
		xPlayer.showNotification(_U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToProcessWeed, function()
		if PlayersTransformingWeed[source] == true then
			local weedQuantity = xPlayer.getInventoryItem('weed').count
			local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

			if poochQuantity > 15 then
				xPlayer.showNotification(_U('too_many_pouches'))
			elseif weedQuantity < 28 then
				xPlayer.showNotification(_U('not_enough_weed'))
			else
				xPlayer.removeInventoryItem('weed', 28)
				xPlayer.addInventoryItem('weed_pooch', 1)
				
				TransformWeed(source)
			end
		end
	end)
end

RegisterServerEvent('esx_illegal_drugs:startTransformWeed')
AddEventHandler('esx_illegal_drugs:startTransformWeed', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	PlayersTransformingWeed[_source] = true
	xPlayer.showNotification(_U('packing_in_prog'))
	TransformWeed(_source)
end)

RegisterServerEvent('esx_illegal_drugs:stopTransformWeed')
AddEventHandler('esx_illegal_drugs:stopTransformWeed', function()
	local _source = source

	PlayersTransformingWeed[_source] = false
end)

local function SellWeed(source)
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if CopsConnected < Config.RequiredCopsWeed then
		xPlayer.showNotification(_U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToSellWeed, function()
		if PlayersSellingWeed[source] == true then
			local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

			if poochQuantity == 0 then
				xPlayer.showNotification(_U('no_pouches_weed_sale'))
			else
				xPlayer.removeInventoryItem('weed_pooch', 1)
					
				if CopsConnected == 0 then
					xPlayer.addAccountMoney('black_money', 100)
					xPlayer.showNotification(_U('sold_one_weed'))
				elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('black_money', 1000)
					xPlayer.showNotification(_U('sold_one_weed'))
				elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('black_money', 1100)
					xPlayer.showNotification(_U('sold_one_weed'))
				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('black_money', 1200)
					xPlayer.showNotification(_U('sold_one_weed'))
				elseif CopsConnected >= 4 then
					xPlayer.addAccountMoney('black_money', 1300)
					xPlayer.showNotification(_U('sold_one_weed'))
				elseif CopsConnected >= 5 then
					xPlayer.addAccountMoney('black_money', 1400)
					xPlayer.showNotification(_U('sold_one_weed'))
                elseif CopsConnected >= 6 then
					xPlayer.addAccountMoney('black_money', 1500)
					xPlayer.showNotification(_U('sold_one_weed'))
                elseif CopsConnected >= 7 then
					xPlayer.addAccountMoney('black_money', 1600)
					xPlayer.showNotification(_U('sold_one_weed'))
                elseif CopsConnected >= 8 then
					xPlayer.addAccountMoney('black_money', 1700)
					xPlayer.showNotification(_U('sold_one_weed'))
                elseif CopsConnected >= 9 then
					xPlayer.addAccountMoney('black_money', 1800)
					xPlayer.showNotification(_U('sold_one_weed'))
                elseif CopsConnected >= 10 then
					xPlayer.addAccountMoney('black_money', 1900)
					xPlayer.showNotification(_U('sold_one_weed'))			
				end
				
				SellWeed(source)
			end
		end
	end)
end

RegisterServerEvent('esx_illegal_drugs:startSellWeed')
AddEventHandler('esx_illegal_drugs:startSellWeed', function()
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

	PlayersSellingWeed[_source] = true
	xPlayer.showNotification(_U('sale_in_prog'))
	SellWeed(_source)
end)

RegisterServerEvent('esx_illegal_drugs:stopSellWeed')
AddEventHandler('esx_illegal_drugs:stopSellWeed', function()
	local _source = source

	PlayersSellingWeed[_source] = false
end)
-- Weed

-- Opium
local function HarvestOpium(source)
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
		
	if CopsConnected < Config.RequiredCopsOpium then
		xPlayer.showNotification(_U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
		return
	end

	SetTimeout(Config.TimeToFarmOpium, function()
		if PlayersHarvestingOpium[source] == true then
			local opium = xPlayer.getInventoryItem('opium')

			if not xPlayer.canCarryItem('opium', opium.weight) then
				xPlayer.showNotification(_U('inv_full_opium'))
			else
				xPlayer.addInventoryItem('opium', 1)
				HarvestOpium(source)
			end
		end
	end)
end

RegisterServerEvent('esx_illegal_drugs:startHarvestOpium')
AddEventHandler('esx_illegal_drugs:startHarvestOpium', function()
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

	PlayersHarvestingOpium[_source] = true
	xPlayer.showNotification(_U('pickup_in_prog'))
	HarvestOpium(_source)
end)

RegisterServerEvent('esx_illegal_drugs:stopHarvestOpium')
AddEventHandler('esx_illegal_drugs:stopHarvestOpium', function()
	local _source = source

	PlayersHarvestingOpium[_source] = false
end)

local function TransformOpium(source)
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
		
	if CopsConnected < Config.RequiredCopsOpium then
		xPlayer.showNotification(_U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
		return
	end

	SetTimeout(Config.TimeToProcessOpium, function()
		if PlayersTransformingOpium[source] == true then
			local opiumQuantity = xPlayer.getInventoryItem('opium').count
			local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

			if poochQuantity > 15 then
				xPlayer.showNotification(_U('too_many_pouches'))
			elseif opiumQuantity < 28 then
				xPlayer.showNotification(_U('not_enough_opium'))
			else
				xPlayer.removeInventoryItem('opium', 28)
				xPlayer.addInventoryItem('opium_pooch', 1)
			
				TransformOpium(source)
			end
		end
	end)
end

RegisterServerEvent('esx_illegal_drugs:startTransformOpium')
AddEventHandler('esx_illegal_drugs:startTransformOpium', function()
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

	PlayersTransformingOpium[_source] = true
	xPlayer.showNotification(_U('packing_in_prog'))
	TransformOpium(_source)
end)

RegisterServerEvent('esx_illegal_drugs:stopTransformOpium')
AddEventHandler('esx_illegal_drugs:stopTransformOpium', function()
	local _source = source

	PlayersTransformingOpium[_source] = false
end)

local function SellOpium(source)
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
		
	if CopsConnected < Config.RequiredCopsOpium then
		xPlayer.showNotification(_U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
		return
	end

	SetTimeout(Config.TimeToSellOpium, function()
		if PlayersSellingOpium[source] == true then
			local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

			if poochQuantity == 0 then
				xPlayer.showNotification(_U('no_pouches_opium_sale'))
			else
				xPlayer.removeInventoryItem('opium_pooch', 1)
						
				if CopsConnected == 0 then
					xPlayer.addAccountMoney('black_money', 200)
					xPlayer.showNotification(_U('sold_one_opium'))
				elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('black_money', 2000)
					xPlayer.showNotification(_U('sold_one_opium'))
				elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('black_money', 2100)
					xPlayer.showNotification(_U('sold_one_opium'))
				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('black_money', 2200)
					xPlayer.showNotification(_U('sold_one_opium'))
				elseif CopsConnected == 4 then
					xPlayer.addAccountMoney('black_money', 2300)
					xPlayer.showNotification(_U('sold_one_opium'))
				elseif CopsConnected >= 5 then
					xPlayer.addAccountMoney('black_money', 2400)
					xPlayer.showNotification(_U('sold_one_opium'))
                elseif CopsConnected >= 6 then
					xPlayer.addAccountMoney('black_money', 2500)
					xPlayer.showNotification(_U('sold_one_opium'))
                elseif CopsConnected >= 7 then
					xPlayer.addAccountMoney('black_money', 2600)
					xPlayer.showNotification(_U('sold_one_opium'))
                elseif CopsConnected >= 8 then
					xPlayer.addAccountMoney('black_money', 2700)
					xPlayer.showNotification(_U('sold_one_opium'))
                elseif CopsConnected >= 9 then
					xPlayer.addAccountMoney('black_money', 2800)
					xPlayer.showNotification(_U('sold_one_opium'))
                elseif CopsConnected >= 10 then
					xPlayer.addAccountMoney('black_money', 2900)
					xPlayer.showNotification(_U('sold_one_opium'))		
				end
				
				SellOpium(source)
			end
		end
	end)
end

RegisterServerEvent('esx_illegal_drugs:startSellOpium')
AddEventHandler('esx_illegal_drugs:startSellOpium', function()
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

	PlayersSellingOpium[_source] = true
	xPlayer.showNotification(_U('sale_in_prog'))
	SellOpium(_source)
end)

RegisterServerEvent('esx_illegal_drugs:stopSellOpium')
AddEventHandler('esx_illegal_drugs:stopSellOpium', function()
	local _source = source

	PlayersSellingOpium[_source] = false
end)
-- Opium

-- Coke
local function HarvestCoke(source)
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
		
	if CopsConnected < Config.RequiredCopsCoke then
		xPlayer.showNotification(_U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
		return
	end

	SetTimeout(Config.TimeToFarmCoke, function()
		if PlayersHarvestingCoke[source] == true then
			local coke = xPlayer.getInventoryItem('coke')

			if not xPlayer.canCarryItem('coke', coke.weight) then
				xPlayer.showNotification(_U('inv_full_coke'))
			else
				xPlayer.addInventoryItem('coke', 1)
				HarvestCoke(source)
			end
		end
	end)
end

RegisterServerEvent('esx_illegal_drugs:startHarvestCoke')
AddEventHandler('esx_illegal_drugs:startHarvestCoke', function()
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

	PlayersHarvestingCoke[_source] = true
	xPlayer.showNotification(_U('pickup_in_prog'))
	HarvestCoke(_source)
end)

RegisterServerEvent('esx_illegal_drugs:stopHarvestCoke')
AddEventHandler('esx_illegal_drugs:stopHarvestCoke', function()
	local _source = source

	PlayersHarvestingCoke[_source] = false
end)

local function TransformCoke(source)
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
		
	if CopsConnected < Config.RequiredCopsCoke then
		xPlayer.showNotification(_U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
		return
	end

	SetTimeout(Config.TimeToProcessCoke, function()
		if PlayersTransformingCoke[source] == true then
			local cokeQuantity = xPlayer.getInventoryItem('coke').count
			local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

			if poochQuantity > 15 then
				xPlayer.showNotification(_U('too_many_pouches'))
			elseif cokeQuantity < 28 then
				xPlayer.showNotification(_U('not_enough_coke'))
			else
				xPlayer.removeInventoryItem('coke', 28)
				xPlayer.addInventoryItem('coke_pooch', 1)
			
				TransformCoke(source)
			end
		end
	end)
end

RegisterServerEvent('esx_illegal_drugs:startTransformCoke')
AddEventHandler('esx_illegal_drugs:startTransformCoke', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	PlayersTransformingCoke[_source] = true
	xPlayer.showNotification(_U('packing_in_prog'))
	TransformCoke(_source)
end)

RegisterServerEvent('esx_illegal_drugs:stopTransformCoke')
AddEventHandler('esx_illegal_drugs:stopTransformCoke', function()
	local _source = source

	PlayersTransformingCoke[_source] = false
end)

local function SellCoke(source)
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
		
	if CopsConnected < Config.RequiredCopsCoke then
		xPlayer.showNotification(_U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
		return
	end

	SetTimeout(Config.TimeToSellCoke, function()
		if PlayersSellingCoke[source] == true then
			local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

			if poochQuantity == 0 then
				xPlayer.showNotification(_U('no_pouches_coke_sale'))
			else
				xPlayer.removeInventoryItem('coke_pooch', 1)
						
				if CopsConnected == 0 then
					xPlayer.addAccountMoney('black_money', 300)
					xPlayer.showNotification(_U('sold_one_coke'))
				elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('black_money', 3000)
					xPlayer.showNotification(_U('sold_one_coke'))
				elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('black_money', 3100)
					xPlayer.showNotification(_U('sold_one_coke'))
				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('black_money', 3200)
					xPlayer.showNotification(_U('sold_one_coke'))
				elseif CopsConnected == 4 then
					xPlayer.addAccountMoney('black_money', 3300)
					xPlayer.showNotification(_U('sold_one_coke'))
				elseif CopsConnected >= 5 then
					xPlayer.addAccountMoney('black_money', 3400)
					xPlayer.showNotification(_U('sold_one_coke'))
                elseif CopsConnected >= 6 then
					xPlayer.addAccountMoney('black_money', 3500)
					xPlayer.showNotification(_U('sold_one_coke'))
                elseif CopsConnected >= 7 then
					xPlayer.addAccountMoney('black_money', 3600)
					xPlayer.showNotification(_U('sold_one_coke'))
                elseif CopsConnected >= 8 then
					xPlayer.addAccountMoney('black_money', 3700)
					xPlayer.showNotification(_U('sold_one_coke'))
                elseif CopsConnected >= 9 then
					xPlayer.addAccountMoney('black_money', 3800)
					xPlayer.showNotification(_U('sold_one_coke'))
                elseif CopsConnected >= 10 then
					xPlayer.addAccountMoney('black_money', 3900)
					xPlayer.showNotification(_U('sold_one_coke'))	
				end
				
				SellCoke(source)
			end
		end
	end)
end

RegisterServerEvent('esx_illegal_drugs:startSellCoke')
AddEventHandler('esx_illegal_drugs:startSellCoke', function()
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

	PlayersSellingCoke[_source] = true
	xPlayer.showNotification(_U('sale_in_prog'))
	SellCoke(_source)
end)

RegisterServerEvent('esx_illegal_drugs:stopSellCoke')
AddEventHandler('esx_illegal_drugs:stopSellCoke', function()
	local _source = source

	PlayersSellingCoke[_source] = false
end)
-- Coke

-- Meth
local function HarvestMeth(source)
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
		
	if CopsConnected < Config.RequiredCopsMeth then
		xPlayer.showNotification(_U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end
	
	SetTimeout(Config.TimeToFarmMeth, function()
		if PlayersHarvestingMeth[source] == true then
			local meth = xPlayer.getInventoryItem('meth')

			if not xPlayer.canCarryItem('meth', meth.weight) then
				xPlayer.showNotification(_U('inv_full_meth'))
			else
				xPlayer.addInventoryItem('meth', 1)
				HarvestMeth(source)
			end
		end
	end)
end

RegisterServerEvent('esx_illegal_drugs:startHarvestMeth')
AddEventHandler('esx_illegal_drugs:startHarvestMeth', function()
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

	PlayersHarvestingMeth[_source] = true
	xPlayer.showNotification(_U('pickup_in_prog'))
	HarvestMeth(_source)
end)

RegisterServerEvent('esx_illegal_drugs:stopHarvestMeth')
AddEventHandler('esx_illegal_drugs:stopHarvestMeth', function()
	local _source = source

	PlayersHarvestingMeth[_source] = false
end)

local function TransformMeth(source)
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
		
	if CopsConnected < Config.RequiredCopsMeth then
		xPlayer.showNotification(_U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end

	SetTimeout(Config.TimeToProcessMeth, function()
		if PlayersTransformingMeth[source] == true then
			local methQuantity = xPlayer.getInventoryItem('meth').count
			local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

			if poochQuantity > 28 then
				xPlayer.showNotification(_U('too_many_pouches'))
			elseif methQuantity < 15 then
				xPlayer.showNotification(_U('not_enough_meth'))
			else
				xPlayer.removeInventoryItem('meth', 28)
				xPlayer.addInventoryItem('meth_pooch', 1)
				
				TransformMeth(source)
			end
		end
	end)
end

RegisterServerEvent('esx_illegal_drugs:startTransformMeth')
AddEventHandler('esx_illegal_drugs:startTransformMeth', function()
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

	PlayersTransformingMeth[_source] = true
	xPlayer.showNotification(_U('packing_in_prog'))
	TransformMeth(_source)
end)

RegisterServerEvent('esx_illegal_drugs:stopTransformMeth')
AddEventHandler('esx_illegal_drugs:stopTransformMeth', function()
	local _source = source

	PlayersTransformingMeth[_source] = false
end)

local function SellMeth(source)
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
		
	if CopsConnected < Config.RequiredCopsMeth then
		xPlayer.showNotification(_U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end

	SetTimeout(Config.TimeToSellMeth, function()
		if PlayersSellingMeth[source] == true then
			local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

			if poochQuantity == 0 then
				xPlayer.showNotification(_U('no_pouches_meth_sale'))
			else
				xPlayer.removeInventoryItem('meth_pooch', 1)
					
				if CopsConnected == 0 then
					xPlayer.addAccountMoney('black_money', 400)
					xPlayer.showNotification(_U('sold_one_meth'))
				elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('black_money', 4000)
					xPlayer.showNotification(_U('sold_one_meth'))
				elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('black_money', 4100)
					xPlayer.showNotification(_U('sold_one_meth'))
				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('black_money', 4200)
					xPlayer.showNotification(_U('sold_one_meth'))
				elseif CopsConnected == 4 then
					xPlayer.addAccountMoney('black_money', 4300)
					xPlayer.showNotification(_U('sold_one_meth'))
				elseif CopsConnected == 5 then
					xPlayer.addAccountMoney('black_money', 4400)
					xPlayer.showNotification(_U('sold_one_meth'))
				elseif CopsConnected >= 6 then
					xPlayer.addAccountMoney('black_money', 4500)
					xPlayer.showNotification(_U('sold_one_meth'))
                elseif CopsConnected >= 7 then
					xPlayer.addAccountMoney('black_money', 4600)
					xPlayer.showNotification(_U('sold_one_meth'))
                elseif CopsConnected >= 8 then
					xPlayer.addAccountMoney('black_money', 4700)
					xPlayer.showNotification(_U('sold_one_meth'))
                elseif CopsConnected >= 9 then
					xPlayer.addAccountMoney('black_money', 4800)
					xPlayer.showNotification(_U('sold_one_meth'))
                elseif CopsConnected >= 10 then
					xPlayer.addAccountMoney('black_money', 4900)
					xPlayer.showNotification(_U('sold_one_meth'))	
				end
				
				SellMeth(source)
			end
		end
	end)
end

RegisterServerEvent('esx_illegal_drugs:startSellMeth')
AddEventHandler('esx_illegal_drugs:startSellMeth', function()
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

	PlayersSellingMeth[_source] = true
	xPlayer.showNotification(_U('sale_in_prog'))
	SellMeth(_source)
end)

RegisterServerEvent('esx_illegal_drugs:stopSellMeth')
AddEventHandler('esx_illegal_drugs:stopSellMeth', function()
	local _source = source

	PlayersSellingMeth[_source] = false
end)

-- Meth
RegisterServerEvent('esx_illegal_drugs:GetUserInventory')
AddEventHandler('esx_illegal_drugs:GetUserInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
		
	TriggerClientEvent('esx_illegal_drugs:ReturnInventory', _source, xPlayer.getInventoryItem('coke').count, xPlayer.getInventoryItem('coke_pooch').count,xPlayer.getInventoryItem('meth').count, xPlayer.getInventoryItem('meth_pooch').count, xPlayer.getInventoryItem('weed').count, xPlayer.getInventoryItem('weed_pooch').count, xPlayer.getInventoryItem('opium').count, xPlayer.getInventoryItem('opium_pooch').count,xPlayer.job.name, currentZone)
end)

ESX.RegisterUsableItem('weed', function(source)
	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('weed', 1)

	TriggerClientEvent('esx_illegal_drugs:onPot', _source)
	xPlayer.showNotification(_U('used_one_weed'))
end)

ESX.RegisterUsableItem('meth', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('meth', 1)

	TriggerClientEvent('esx_illegal_drugs:onMeth', _source)
	xPlayer.showNotification(_U('used_one_meth'))
end)

ESX.RegisterUsableItem('opium', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('opium', 1)

	TriggerClientEvent('esx_illegal_drugs:onOpium', _source)
	xPlayer.showNotification(_U('used_one_opium'))
end)

ESX.RegisterUsableItem('coke', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('coke', 1)

	TriggerClientEvent('esx_illegal_drugs:onCoke', _source)
	xPlayer.showNotification(_U('used_one_coke'))
end)
