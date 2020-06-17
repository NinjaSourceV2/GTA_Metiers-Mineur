--||@SuperCoolNinja.||--

--> Variable :
local maxCuivreSlot = 31 --> Nombre maximum qu'il peut contenir dans son inventaire
local payeTotaleMineur = 2500 --> A changer ici la paye. (Je l'ai fait de manniere vraiment basic)


RegisterNetEvent("GTA:ShowMineurBlipPoint")
AddEventHandler('GTA:ShowMineurBlipPoint', function ()
    --Vestiaire :
    MineurVestiaire = AddBlipForCoord(966.029,-1931.31,31.1233)
    SetBlipSprite(MineurVestiaire,366)		
    SetBlipColour(MineurVestiaire, 16)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('VESTIAIRE')
    EndTextCommandSetBlipName(MineurVestiaire)

    --Sortie du camion :
    MineurCamion = AddBlipForCoord(978.145690917969,-1919.07055664063,31.1356315612793)
    SetBlipSprite(MineurCamion,318)		
    SetBlipColour(MineurCamion, 16)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('SORTIE CAMION')
    EndTextCommandSetBlipName(MineurCamion)

    --Mine :
    MineurChamps = AddBlipForCoord(2969.47827148438,2777.9873046875,38.5488739013672)
    SetBlipSprite(MineurChamps,78)		
    SetBlipColour(MineurChamps, 16)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('MINE DE CUIVRE')
    EndTextCommandSetBlipName(MineurChamps)

    --Traitement :
    MineurTraitement = AddBlipForCoord(2682.16967773438,2795.44555664063,40.6961441040039)
    SetBlipSprite(MineurTraitement,233)	
    SetBlipColour(MineurTraitement, 16)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('TRAITEMENT DE CUIVRE')
    EndTextCommandSetBlipName(MineurTraitement)

    --Revente :
    MineurRevente = AddBlipForCoord(1137.62316894531,2344.03442382813,54.3110084533691)
    SetBlipSprite(MineurRevente,277)	
    SetBlipColour(MineurRevente, 16)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('REVENTE DE CUIVRE')
    EndTextCommandSetBlipName(MineurRevente)    
end)


RegisterNetEvent("GTA:RemoveBlipPoint")
AddEventHandler("GTA:RemoveBlipPoint", function ()

    --On retire le blip vestiaire si la personne n'est plus mineur :
    if MineurVestiaire ~= nil and DoesBlipExist(MineurVestiaire) then
        Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(MineurVestiaire))
        MineurVestiaire = nil
    end

    --On retire le blip sortie de camion si la personne n'est plus mineur :
    if MineurCamion ~= nil and DoesBlipExist(MineurCamion) then
        Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(MineurCamion))
        MineurCamion = nil
    end

    --On retire le champ de mine si la personne n'est plus mineur :
    if MineurChamps ~= nil and DoesBlipExist(MineurChamps) then
        Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(MineurChamps))
        MineurChamps = nil
    end

    --On retire le blip traitement si la personne n'est plus mineur :
    if MineurTraitement ~= nil and DoesBlipExist(MineurTraitement) then
        Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(MineurTraitement))
        MineurTraitement = nil
    end

    --On retire le blip revente si la personne n'est plus mineur :
    if MineurRevente ~= nil and DoesBlipExist(MineurRevente) then
        Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(MineurRevente))
        MineurRevente = nil
    end
end)



RegisterNetEvent("GTA:isPlayerMineurOnService")
AddEventHandler("GTA:isPlayerMineurOnService", function ()
    if config.enService == false then
        local homme = GetHashKey("mp_m_freemode_01")
        if(GetEntityModel(GetPlayerPed(-1)) == homme) then
            SetPedComponentVariation(LocalPed(), 11, 5, 0, 2)  -- Top
            SetPedComponentVariation(LocalPed(), 8, 59, 0, 2)   -- teeshirt
            SetPedComponentVariation(LocalPed(), 6, 25, 0, 2)   -- Chaussure
            SetPedComponentVariation(LocalPed(), 4, 0, 12, 2)   -- Pantalon
            SetPedComponentVariation(LocalPed(), 3, 34, 0, 2)   -- torsos
        else
            SetPedComponentVariation(GetPlayerPed(-1), 11, 11, 2, 2)  -- Top
            SetPedComponentVariation(GetPlayerPed(-1), 8, 36, 0, 2)   -- teeshirt
			SetPedComponentVariation(GetPlayerPed(-1), 6, 26, 0, 2)   -- Chaussure
			SetPedComponentVariation(GetPlayerPed(-1), 4, 35, 0, 2)   -- Pantalon
			SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 2)   -- torsos
        end
        TriggerEvent("GTA:ShowMineurBlipPoint")
    else
        TriggerServerEvent("GTA:LoadVetement")
        TriggerEvent("GTA:RemoveBlipPoint")
    end
        
    config.enService = not config.enService
end)


RegisterNetEvent("GTA:isVehMineurOut")
AddEventHandler("GTA:isVehMineurOut", function ()
    if config.VehiculeSortie == false then  
        local carid = GetHashKey("rubble")
        RequestModel(carid) 
        while not HasModelLoaded(carid) do
            Citizen.Wait(0)
        end
        
        if(mineurVeh ~= nil) then	
            deleteCar(mineurVeh)
        end

        local playerCoords = GetEntityCoords(LocalPed())
        playerCoords = playerCoords + vector3(0, 2, 0)

        mineurVeh = CreateVehicle(carid, 978.145690917969,-1919.07055664063,31.1356315612793, 0.0, true, false)
        TaskWarpPedIntoVehicle(LocalPed(), mineurVeh, -1)
    else
        deleteCar(mineurVeh)
    end

    config.VehiculeSortie = not config.VehiculeSortie
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for _, pos in pairs(PositionMineur) do
            if (config.Job == "Mineur") then
                --Prise de Service :
                if GetDistanceBetweenCoords(pos.Vestiaire[1],pos.Vestiaire[2],pos.Vestiaire[3],GetEntityCoords(LocalPed()),true) < 5 then
                    if config.enService == true then
                        if GetLastInputMethod(0) then
                            Ninja_Core__DisplayHelpAlert("Appuyez sur ~INPUT_CONTEXT~ pour ~r~finir~w~ votre ~b~service~w~.")
                        else
                            Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_RIGHT~ pour ~r~finir~w~ votre ~b~service~w~.")
                        end
                    else
                        if GetLastInputMethod(0) then
                            Ninja_Core__DisplayHelpAlert("Appuyez sur ~INPUT_CONTEXT~ pour vous ~b~équiper~w~.")
                        else
                            Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_RIGHT~ pour vous ~b~équiper~w~.")
                        end
                    end
                    
                    if (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) then -->Prise de service
                        TriggerEvent("GTA:isPlayerMineurOnService")
                    end
                end
                
                if config.enService == true then
                    --Sortie de camion :
                    if GetDistanceBetweenCoords(pos.SpawnCamion[1],pos.SpawnCamion[2],pos.SpawnCamion[3],GetEntityCoords(LocalPed()),true) < 5 then
                        if config.VehiculeSortie == false then
                            if GetLastInputMethod(0) then
                                Ninja_Core__DisplayHelpAlert("Appuyez sur ~INPUT_CONTEXT~ pour ~b~sortir~w~ votre camion.")
                            else
                                Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_RIGHT~ pour ~b~sortir~w~ votre camion.")
                            end
                        else
                            if GetLastInputMethod(0) then
                                Ninja_Core__DisplayHelpAlert("Appuyez sur ~INPUT_CONTEXT~ pour ~r~ranger~w~ votre camion.")
                            else
                                Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_RIGHT~ pour ~r~ranger~w~ votre camion.")
                            end
                        end 

                        if (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175))  then --> Sortie de camion :
                            TriggerEvent("GTA:isVehMineurOut")
                        end
                    end


                    --Recolte Pos:
                    if GetDistanceBetweenCoords(pos.Recolte[1],pos.Recolte[2],pos.Recolte[3],GetEntityCoords(LocalPed()),true) > 20.0001 then
                        DrawMarker(1, pos.Recolte[1],pos.Recolte[2],pos.Recolte[3]-1.1001, 0, 0, 0, 0, 0, 0, 20.0, 20.0, 2.0, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
                        config.joueurProcheRecolte = false
                    else
                        config.joueurProcheRecolte = true
                        if (config.recolteEnCours == false) then
                            if GetLastInputMethod(0) then
                                Ninja_Core__DisplayHelpAlert("Appuyez sur ~INPUT_CONTEXT~ pour ~g~récolter ~w~.")
                            else
                                Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_RIGHT~ pour ~g~récolter ~w~.")
                            end
                        end
                        if (config.recolteEnCours == true) then
                            if GetLastInputMethod(0) then
                                Ninja_Core__DisplayHelpAlert("Appuyez sur ~INPUT_CONTEXT~ pour ~r~stopper ~w~ la ~g~récolte ~w~.")
                            else
                                Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_RIGHT~ pour ~r~stopper ~w~ la ~g~récolte ~w~.")
                            end
                        end
                    end


                    --Traitement Pos:
                    if GetDistanceBetweenCoords(pos.traitement[1],pos.traitement[2],pos.traitement[3],GetEntityCoords(LocalPed()),true) > 20.0001 then
                        DrawMarker(1, pos.traitement[1],pos.traitement[2],pos.traitement[3], 0, 0, 0, 0, 0, 0, 20.0, 20.0, 2.0, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
                        config.joueurProcheTraitement = false
                    else
                        config.joueurProcheTraitement = true
                        if (config.traitementEnCours == false) then
                            if GetLastInputMethod(0) then
                                Ninja_Core__DisplayHelpAlert("Appuyez sur ~INPUT_CONTEXT~ pour ~g~traiter ~w~.")
                            else
                                Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_RIGHT~ pour ~g~traiter ~w~.")
                            end
                        end
                        if (config.traitementEnCours == true) then
                            if GetLastInputMethod(0) then
                                Ninja_Core__DisplayHelpAlert("Appuyez sur ~INPUT_CONTEXT~ pour ~r~stopper ~w~ le ~g~traitement ~w~.")
                            else
                                Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_RIGHT~ pour ~r~stopper ~w~ le ~g~traitement ~w~.")
                            end
                        end
                    end
                    
                    --Revente Pos:
                    if GetDistanceBetweenCoords(pos.vente[1],pos.vente[2],pos.vente[3],GetEntityCoords(LocalPed()),true) > 20.0001 then
                        DrawMarker(1, pos.vente[1],pos.vente[2],pos.vente[3], 0, 0, 0, 0, 0, 0, 20.0, 20.0, 2.0, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
                        config.joueurProcheRevente = false
                    else
                        config.joueurProcheRevente = true
                        if (config.reventeEnCours == false) then
                            if GetLastInputMethod(0) then
                                Ninja_Core__DisplayHelpAlert("Appuyez sur ~INPUT_CONTEXT~ pour ~g~vendre ~w~.")
                            else
                                Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_RIGHT~ pour ~g~vendre ~w~.")
                            end
                        end
                        if (config.reventeEnCours == true) then
                            if GetLastInputMethod(0) then
                                Ninja_Core__DisplayHelpAlert("Appuyez sur ~INPUT_CONTEXT~ pour ~r~stopper ~w~ la ~g~vente ~w~.")
                            else
                                Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_RIGHT~ pour ~r~stopper ~w~ la ~g~vente ~w~.")
                            end
                        end
                    end

                    --Recolte Process:
                    if (config.recolteEnCours == true) then
                        if (config.joueurProcheRecolte == true) then
                            if (exports.nMenuPersonnel:getQuantity(13) >= 31) then
                                DrawMissionText("~h~~r~Inventaire Complet", 10000)
                                config.recolteEnCours = false
                            else
                                while (exports.nMenuPersonnel:getQuantity(13) < 31) and (config.recolteEnCours == true) and (config.joueurProcheRecolte == true) do
                                DrawMissionText("~h~~b~Récolte~w~ en cours...", 3000)
                                Wait(3000)
                                DrawMissionText("~h~~g~+1~w~ Cuivre...", 1000)
                                TriggerEvent("player:receiveItem", 13, 1)
                                Wait(1000)
                                CheckItemNumber(13)
                                Wait(1)
                                end
                            end
                        else
                            config.recolteEnCours = false
                        end
                    end

                    --Traitement Process:
                    if (config.traitementEnCours == true) then
                        if (config.joueurProcheTraitement == true) then
                            if (exports.nMenuPersonnel:getQuantity(13) <= 0) then
                                DrawMissionText("~h~~g~Traitement terminé", 10000)
                                config.traitementEnCours = false
                            else
                                while (exports.nMenuPersonnel:getQuantity(13) > 0) and (config.traitementEnCours == true) and (config.joueurProcheTraitement == true) do
                                DrawMissionText("~h~~b~Traitement~w~ en cours...", 3000)
                                Wait(3000)
                                DrawMissionText("~h~~g~+1~w~ Fil de Cuivre...", 1000)
                                TriggerEvent('player:looseItem', 13, 1)
                                TriggerEvent("player:receiveItem", 14, 1)
                                Wait(1000)
                                CheckItemNumber(13)
                                CheckItemNumber(14)
                                Wait(1)
                                end
                            end
                        else
                            config.traitementEnCours = false
                        end
                    end

                    --Revente Process:
                    if (config.reventeEnCours == true) then
                        if (config.joueurProcheRevente == true) then
                            if(exports.nMenuPersonnel:getQuantity(14) <= 0) then
                                DrawMissionText("~h~~g~Revente terminé", 10000)
                                config.reventeEnCours = false
                            else
                                while (exports.nMenuPersonnel:getQuantity(14) > 0) and (config.reventeEnCours == true) and (config.joueurProcheRevente == true) do
                                DrawMissionText("~h~~b~Revente~w~ en cours...", 3000)
                                Wait(3000)
                                DrawMissionText("~h~Vous avez vendu ~g~+1 fil de Cuivre~w~...", 1000)
                                TriggerEvent('player:looseItem', 14, 1)
                                TriggerServerEvent("GTA:RecevoirPayeMineur", tonumber(payeTotaleMineur))
                                Wait(1000)
                                CheckItemNumber(14)
                                Wait(1)
                                end
                            end
                        else
                            config.reventeEnCours = false
                        end
                    end
                end
            end
        end
    end
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if config.enService == true then
            --Recolte :
            if (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) and (config.joueurProcheRecolte == true) and (config.recolteEnCours == false) then
                if IsPedInAnyVehicle(LocalPed(), true) == false then
                    config.recolteEnCours = true
                else
                    DrawMissionText("~h~~r~Vous devez sortir du véhicule pour travailler.", 2000)
                end
            elseif (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) and (config.joueurProcheRecolte == true) and (config.recolteEnCours == true) then
                config.recolteEnCours = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if config.enService == true then
            --Traitement :
            if (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) and (config.joueurProcheTraitement == true) and (config.traitementEnCours == false) then
                if IsPedInAnyVehicle(LocalPed(), true) == false then
                    config.traitementEnCours = true
                else
                    DrawMissionText("~h~~r~Vous devez sortir du véhicule pour travailler.", 2000)
                end
            elseif (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) and (config.joueurProcheTraitement == true) and (config.traitementEnCours == true) then
                config.traitementEnCours = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if config.enService == true then
            --Revente :
            if (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) and (config.joueurProcheRevente == true) and (config.reventeEnCours == false) then
                if IsPedInAnyVehicle(LocalPed(), true) == false then
                    config.reventeEnCours = true
                else
                    DrawMissionText("~h~~r~Vous devez sortir du véhicule pour vendre.", 2000)
                end
            elseif (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) and (config.joueurProcheRevente == true) and (config.reventeEnCours == true) then
                config.reventeEnCours = false
            end
        end
    end
end)