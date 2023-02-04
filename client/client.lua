ESX = exports["es_extended"]:getSharedObject()  

local PlayerPed = false
local PlayerPos = false
local PlayerLastPos = 0

 

local Anim = 'sit' 

Citizen.CreateThread(function()
    while true do
        PlayerPed = PlayerPedId()
        PlayerPos = GetEntityCoords(PlayerPedId())
        Citizen.Wait(500)
    end
end)

 

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		for i = 1, #Config.objects.locations do
			local current = Config.objects.locations[i]
            object = GetClosestObjectOfType(PlayerPos, 1.0, GetHashKey(current.objName), false, false, false)
            if object ~= 0 then
                current.object = object
			end
		end
	end
end)

 

function Animation(dict, anim, ped)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
    
    TaskPlayAnim(ped, dict, anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
end


RegisterNetEvent('ChairBedSystem:Client:Animation')
AddEventHandler('ChairBedSystem:Client:Animation', function(v, coords)
    local object = v.objName
    local vertx = v.verticalOffsetX
    local verty = v.verticalOffsetY
    local vertz = v.verticalOffsetZ
    local dir = v.direction
    local isBed = v.bed
    local objectcoords = coords
    
    local ped = PlayerPed
    PlayerLastPos = GetEntityCoords(ped)
    FreezeEntityPosition(object, true)
    FreezeEntityPosition(ped, true)
 
 
 
        if Anim == 'sit' then
            if Config.objects.BedSitAnimation.dict ~= nil then
                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
                local dict = Config.objects.BedSitAnimation.dict
                local anim = Config.objects.BedSitAnimation.anim
                
                Animation(dict, anim, ped)
           
            end
        end
 
 
end)
local options = {
    {
        name = 'bed:Enter',
        event = 'bed:che',
        icon = 'fa-solid fa-suitcase',
        label = '躺床',
        distance = 1,
   
    } 
}

local optionNames = { 'bed:Enter' }
local models = {'v_med_bed2'}
a = true

exports.ox_target:addModel(models, options)


RegisterNetEvent('bed:che')
AddEventHandler('bed:che', function()
 

    ESX.TriggerServerCallback('checking:yy', function(data)
     
    end) 
end)    

RegisterNetEvent('bed:moneyche')
AddEventHandler('bed:moneyche', function()
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    local maxHealth = GetEntityMaxHealth(playerPed)
    local health = GetEntityHealth(playerPed)
    if health == maxHealth then
        lib.notify({
       
            description = '你是健康状态',
            type = 'inform'
        })
    else
        TriggerServerEvent('checking:money')
    end

 
      
end)   

 
RegisterNetEvent('bed:open')
AddEventHandler('bed:open', function()
    

    local playerPed = PlayerPedId()
    local maxHealth = GetEntityMaxHealth(playerPed)
    local health = GetEntityHealth(playerPed)
    local inRange = false
    for i = 1, #Config.objects.locations do         
        local current = Config.objects.locations[i]
    local coordsObject = GetEntityCoords(current.object)
    local dist = #(PlayerPos - vector3(coordsObject.x, coordsObject.y, coordsObject.z))
    if (current.bed == true) then
       
            if (Anim == 'sit') then
            TriggerServerEvent('ChairBedSystem:Server:Enter', current, coordsObject)
    
        end    
    end
  end
    lib.progressBar({
        duration = 10000,
        label = '治疗中',
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            mouse = true,
        
        },
    })  

    TriggerServerEvent('ChairBedSystem:Server:Leave')
    ClearPedTasksImmediately(PlayerPed)
    FreezeEntityPosition(PlayerPed, false)
    local x, y, z = table.unpack(PlayerLastPos)
    local dist = #(PlayerPos - vector3(x, y, z))
    SetEntityCoords(PlayerPed, PlayerLastPos)
    SetEntityHealth(playerPed,maxHealth )
 
end)    


 
