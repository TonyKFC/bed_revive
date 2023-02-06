ESX = exports["es_extended"]:getSharedObject()  

local oArray = {}
local oPlayerUse = {}


AddEventHandler('playerDropped', function()
    local oSource = source
    if oPlayerUse[oSource] ~= nil then
        oArray[oPlayerUse[oSource]] = nil
        oPlayerUse[oSource] = nil
    end
end)


RegisterServerEvent('ChairBedSystem:Server:Enter')
AddEventHandler('ChairBedSystem:Server:Enter', function(object, objectcoords)
    local oSource = source
    if oArray[objectcoords] == nil then
       oPlayerUse[oSource] = objectcoords
--oArray[objectcoords] = true
        TriggerClientEvent('ChairBedSystem:Client:Animation', oSource, object, objectcoords)
    end
end)


RegisterServerEvent('ChairBedSystem:Server:Leave')
AddEventHandler('ChairBedSystem:Server:Leave', function(objectcoords)
    local oSource = source

    oPlayerUse[oSource] = nil
  --  oArray[objectcoords] = nil
end)




ESX.RegisterServerCallback('checking:yy', function(source, cb,amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
   
	local cops = 0
	for i=1, #xPlayers, 1 do
	 local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
	 if xPlayer.job.name == Config.job then
			cops = cops + 1
		end
	end

	if cops >= 1 then
		 
        TriggerClientEvent('ox_lib:notify', xPlayer.source, {type = 'error', description = '有医生在'})

 
	else
        TriggerClientEvent('bed:moneyche',source)
         
	end

	 
end)

RegisterServerEvent('checking:money')
AddEventHandler('checking:money', function()
	
    local xPlayer = ESX.GetPlayerFromId(source)
	local xMoney = xPlayer.getAccount('money').money
    local price = 2000
	if xMoney >= price then
 
    xPlayer.removeAccountMoney('money', price) 
    TriggerClientEvent('bed:open',source)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)  
        account.addMoney(price)
    end)
 
	else
    TriggerClientEvent('ox_lib:notify', xPlayer.source, {type = 'error',      description = '你没有足够的现金'})
	end
 
 
end)
