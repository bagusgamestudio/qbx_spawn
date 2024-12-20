lib.versionCheck('Qbox-project/qbx_spawn')

lib.callback.register('qbx_spawn:server:getLastLocation', function(source)
    local player = exports.qbx_core:GetPlayer(source)
    local queryResult = MySQL.single.await('SELECT position FROM players WHERE citizenid = ?',
        { player.PlayerData.citizenid })
    local position = json.decode(queryResult.position)
    local currentPropertyId = player.PlayerData.metadata.currentPropertyId

    return position, currentPropertyId
end)

lib.callback.register('qbx_spawn:server:getProperties', function(source)
    local player = exports.qbx_core:GetPlayer(source)
    local houseData = {}
    local playerHouses = exports.bcs_housing:GetOwnedHomeKeys(player.PlayerData.citizenid)
    for i = 1, #playerHouses do
        local house = playerHouses[i]
        local entry = house.entry
        houseData[#houseData + 1] = {
            label = house.name,
            coords = vec4(entry.x, entry.y, entry.z, entry.w),
            propertyId = house.identifier
        }
    end
    return houseData
end)