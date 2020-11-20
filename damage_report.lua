unit.setTimer("dmgRpt", 1)
screen.activate()

function update()
    elements = core.getElementIdList()
    local text = [[<html><head></head><body><table style="font-size:3em">]]
    text = text .. [[<tr><th>ElementId</th><th>ElementType</th><th>ElementName</th><th>Remaining Hit Points</th><tr>]]
    for i = 1, #elements do
        elementInfo = database.getElement(core, elements[i])
        if elementInfo['hitPoints'] < elementInfo['maxHitPoints'] then
            text = text .. [[<tr>]]
            text = text .. [[<td>]] .. elementInfo['id'] .. [[</td>]]
            text = text .. [[<td>]] .. elementInfo['type'] .. [[</td>]]
            text = text .. [[<td>]] .. elementInfo['name'] .. [[</td>]]
            text = text .. [[<td align="right" style="font-family: monospace">]] .. string.format('%0.2f', elementInfo['hitPoints']/elementInfo['maxHitPoints']*100) .. [[%</td>]]
            text = text .. [[</tr>]]
        end    
    end
    text = text .. [[</table></body></html>]]
    screen.setHTML(text)
end

update()
