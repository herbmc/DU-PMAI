 script = {}

 function script.onStart ()
    --[[
        Pure Status Display
        Refactored thanks to Dorian Gray
        1. Copy & paste this script into your Programming Board, into slot "unit" and filter "start()"
        2. Add a "stop()" filter and enter "displayOff()" into the Lua editor for this filter
        3. Add a "tick()" filter and enter the parameter "updateTick, so "tick(updateTick)". In the Lua editor for the filter enter "processTick()"
        4. Link the core this setup is placed on to your Programming Board and rename the slot to "core"
        5. Link up to 5 screens to your Programming Board, preferably S or larger, and name the slots "displayT1", "displayT2", etc. Tiers you don't have can be ommited by leaving that screen out.
        6. Rename your pure storage boxes you want this script to observe. Pures must be named "Pure <purename>", e.g. "Pure Alumnium". Any wrongly named container will not be observed.You can rename the searchString under Advanced->Edit Lua Parameters, You MUST include spaces not in the actual substance name. You can have more than one container for a single substance, if you have e.g. three large containers for Aluminum, name all of them "Pure Aluminum". The script does not support multiple substances in one container.
        7. On your Programming Board choose Advanced->Edit Lua Parameters and enter your Container Proficiency Bonus in percent (0 to 50) and your Container Optimization Bonus in percent (0-25)
        8. Activate the Programming Board.
    ]]

    unit.hide()
    if displayT1a then displayT1a.activate() end
    if displayT1b then displayT1b.activate() end
    if displayT2a then displayT2a.activate() end
    if displayT2b then displayT2b.activate() end
    if displayT3a then displayT3a.activate() end
    if displayT3b then displayT3b.activate() end
    if displayT4a then displayT4a.activate() end
    if displayT4b then displayT4b.activate() end
    if displayT5a then displayT5a.activate() end
    if displayT5b then displayT5b.activate() end
    if displayFuels then displayFuels.activate() end


    function displayOff()
        if displayT1a then displayT1a.clear() end
        if displayT1b then displayT1b.clear() end
        if displayT2a then displayT2a.clear() end
        if displayT2b then displayT2b.clear() end
        if displayT3a then displayT3a.clear() end
        if displayT3b then displayT3b.clear() end
        if displayT4a then displayT4a.clear() end
        if displayT4b then displayT4b.clear() end
        if displayT5a then displayT5a.clear() end
        if displayT5b then displayT5b.clear() end
        if displayFuels then displayFuels.clear() end
    end

    function round(number,decimals)
        local power = 10^decimals
        return math.floor((number/1000) * power) / power
    end 

    PlayerContainerProficiency = 40 --export Your Container Proficiency bonus in total percent (Skills->Mining and Inventory->Inventory Manager)
    PlayerContainerOptimization = 0 --export Your Container Optimization bonus in total percent (Skills->Mining and Inventory->Stock Control)
    MinimumYellowPercent = 25 --export At which percent level do you want bars to be drawn in yellow (not red anymore)
    MinimumGreenPercent = 50 --export At which percent level do you want bars to be drawn in green (not yellow anymore)
    searchString = "Pure " --export Your identifier for Pure Storage Containers (e.g. "Pure Aluminum"). Include the spaces if you change this!
    headerFontSize = 6 --export Header font-size in em
    fontSize = 4 --export font-size in em
    font = "sans-serif" --export font-family Must be in "". Capitalization matters.

    function processTick()

        elementsIds = core.getElementIdList()
        outputData = {}

        substanceMass = {
            Acanthite=7.2;
            AdvGlass=2.6;
            AgLiGlass=2.8;
            AlFe=7.5;
            AlLi=2.5;
            Aluminum=2.7;
            Bauxite=1.28;
            CaCu=8.1;
            Calcium=1.55;
            Carbon=2.27;
            Chromite=4.54;
            Chromium=7.19;
            Coal=1.35;
            Cobalt=8.9;
            Cobaltite=6.33;
            Columbite=1; -- fix me
            Copper=8.96;
            Cryolite=2.95;
            CuAg=9.2;
            Duralumin=2.8;
            Fluorine=1.7;
            Fluoropolymer=1.65;
            Garnierite=2.6;
            Glass=2.5;
            Gold=19.3;
            GoldCoated=3;
            GoldNuggets=19.3;
            Hematite=5.04;
            Hydrogen=0.07;
            Illmenite=4.55;
            Inconel=8.5;
            Iron=7.85;
            Kergon=6;
            Kolbeckite=1; -- fix me
            Limestone=2.71;
            Lithium=0.53;
            Malachite=4;
            Mangalloy=7.83;
            Manganese=7.21;
            Maraging=8.23;
            MnGlass=2.9;
            Natron=1.55;
            Nickel=8.91;
            Niobium=8.57;
            Nitron=4;
            Oxygen=1;
            Petalite=1; -- fix me
            Polycalcite=1.5;
            Polycarbonate=1.4;
            Polysulfide=1.6;
            Pyrite=5.01;
            Quartz=2.65;
            RedGold=14.13;
            Rhodonite=1; -- fix me
            ScAl=2.85;
            Scandium=2.98;
            Silicon=2.33;
            Silumin=3;
            Silver=10.49;
            Sodium=0.97;
            Stainless=7.75;
            Steel=8.05;
            Sulfur=1.82;
            TiNb=10.1;
            Titanium=4.51;
            TitaniumAlloy=4.43;
            Vanadinite=6.95;
            Vanadium=6;
            Vanamer=1.57;
            WarpCells=100;
            Xeron=0.8;    
        }

        function processSubstanceContainer(_id)
            local ContainerName = core.getElementNameById(_id)
            local ContainerTotalMass = core.getElementMassById(_id)
            local ContainerMaxHP = core.getElementMaxHitPointsById(_id)
            local SubstanceName = string.sub(ContainerName, 1, -3)
    --        system.print(SubstanceName)
    
            if SubstanceName~="" then
                SubstanceSingleMass=substanceMass[SubstanceName]
                if SubstanceSingleMass~=nil then
                    if string.match(ContainerName, " H$") then
                        ContainerSelfMass = 55.8
                        CapacityForSubstance = 179200 * 2
                    elseif string.match(ContainerName, " XS$") then
                        ContainerSelfMass = 229.09
                        CapacityForSubstance = (1000+(1000*(PlayerContainerProficiency/100)))
                    elseif string.match(ContainerName, " S$") then
                        ContainerSelfMass = 1280
                        CapacityForSubstance = (8000+(8000*(PlayerContainerProficiency/100)))
                    elseif string.match(ContainerName, " M$") then
                        ContainerSelfMass = 7420
                        CapacityForSubstance = (64000+(64000*(PlayerContainerProficiency/100)))
                    elseif string.match(ContainerName, " L$ ")then
                        ContainerSelfMass = 14840
                        CapacityForSubstance = (128000+(128000*(PlayerContainerProficiency/100)))
                    else
                        ContainerSelfMass = 0
                        CapacityForSubstance = 0
                    end

    --                system.print(SubstanceName .. "/" .. ContainerTotalMass .. "/" .. ContainerSelfMass)
                    local ContentMass=ContainerTotalMass-ContainerSelfMass
                    local OptimizedContentMass = ContentMass+ContentMass*(PlayerContainerOptimization/100)
    --                local ContentAmount = round((OptimizedContentMass/SubstanceSingleMass),1)
                    local ContentAmount = OptimizedContentMass/SubstanceSingleMass
    --                system.print(SubstanceName .. "/" .. ContentMass .. "/" .. ContentAmount)
                    
    --                system.print(ContentMass)

                    if outputData[SubstanceName]~=nil then
    --                    system.print("Adding to " .. SubstanceName)
                        outputData[SubstanceName] = {
                            name = SubstanceName;
                            amount = outputData[SubstanceName]["amount"]+ContentAmount;
                            capacity = outputData[SubstanceName]["capacity"]+CapacityForSubstance;
                        }
                    else
    --                    system.print("New entry for " .. SubstanceName)
    --                    system.print(SubstanceName .. "/" ..  ContainerTotalMass .. "/" .. ContentMass .. "/" .. ContentAmount .. "/" .. CapacityForSubstance)
                        local entry = {
                            name = SubstanceName;
                            amount = ContentAmount;
                            capacity = CapacityForSubstance;
                        }
                        outputData[SubstanceName]=entry
                    end
                end
            end
        end

        function shouldProcess (_id)
            if string.match(core.getElementTypeById(_id), "ontainer") then
                if string.match(core.getElementNameById(_id), " [SMLH]$") then
                    if substanceMass[string.sub(core.getElementNameById(_id), 1, -3)] ~= nil then
    --                    system.print(core.getElementNameById(_id))
                        return true
                    end
                end
            end
            return false
        end
        
        for i = 1, #elementsIds do
            if shouldProcess(elementsIds[i]) then
                processSubstanceContainer(elementsIds[i])
            end
        end
        
        

        function BarGraph(percent)
            if percent <= 25 then return [[
                background: rgb(27,0,0);
                background: linear-gradient(90deg, rgba(27,0,0,.8) 0%, rgba(129,23,23,.8) 25%, rgba(251,0,0,.8) 100%);
                ]]
            elseif percent > 25 and percent < 60 then return [[
            background: rgb(27,0,0);
                background: linear-gradient(90deg, rgba(27,0,0,.8) 0%, rgba(129,101,23,.8) 25%, rgba(251,202,0,.8) 100%);
                ]]
            else return [[
                background: rgb(5,27,0);
                background: linear-gradient(90deg, rgba(5,27,0,.8) 0%, rgba(38,129,23,.8) 25%, rgba(34,251,0,.8) 100%);
                ]]
            end
        end

        function AddHTMLEntry(_id1)
            local id1amount = 0
            local id1percent = 0
            if outputData[_id1]~=nil then 
                id1amount = outputData[_id1]["amount"]
                id1percent = (outputData[_id1]["amount"])/outputData[_id1]["capacity"]*100
            end

            if _id1 == "WarpCells" then
                id1amount = math.floor(id1amount)
                id1percent = ((id1amount/2.5)*100)/outputData[_id1]["capacity"]*100
                id1unit = "  "
            else
                if id1amount >= 1000000 then
                    id1amount = id1amount/1000000
                    id1unit = "ML"
                elseif id1amount >= 1000 then
                    id1amount = id1amount/1000
                    id1unit = "KL"
                else
                    id1unit = " L"
                end
            end

            resHTML =
                [[<tr>
                    <th align=right>]].._id1..[[:</th>
                    <th align=right style="font-family: monospace">]]..string.format("%02.2f", id1amount)..[[&nbsp;]]..id1unit..[[&nbsp;</th>
                    <td class="bar" style="]]..BarGraph(id1percent)..[[; background-repeat: repeat-y; background-size:]]..((30/100)*id1percent)..[[vw">]]..string.format("%02.2f", id1percent)..[[%</td>
                </tr>]]
            return resHTML
        end

        htmlHeader = [[<head><style>td.bar {border-style: solid; border-right-width: 1vw; text-align: left; vertical-align: top; font-weight:bold; font-family:]]..font..[[;}</style></head>]]
        d1 = [[<div class="bootstrap" style="text-align: left; vertical-align: text-top;">]]
        d2 = [[<span style="text-transform: capitalize; font-family:]]..font..[[; font-size:]]..headerFontSize..[[em;">&nbsp;]]
        t1 = [[&nbsp;</span>
            
            <table style="text-transform: capitalize; font-family:]]..font..[[; font-size:]]..fontSize..[[em; table-layout: auto; width: 100vw;">
            <tr style="width:100vw; background-color: blue; color: white;">]]
        t2 = [[ <th style="width:35vw; text-align:right;">Type</th>
                <th style="width:25vw; text-align:center;">Vol</th>
                <th style="width:30vw;text-align:left;">Levels</th>
            </tr>]]
        c1 = [[</table></div> ]]

        if displayT1a then
            html=htmlHeader
            html=html..d1..d2.."T1 Ores & Ingots"..t1..t2
            html=html..AddHTMLEntry("Bauxite")
            html=html..AddHTMLEntry("Aluminum")
            html=html..AddHTMLEntry("Coal")
            html=html..AddHTMLEntry("Carbon")
            html=html..AddHTMLEntry("Hematite")
            html=html..AddHTMLEntry("Iron")
            html=html..AddHTMLEntry("Quartz")        
            html=html..AddHTMLEntry("Silicon")
            html=html..c1
            displayT1a.setHTML(html)
        end
        if displayT1b then
            html=htmlHeader
            html=html..d1..d2.."T1 Etc."..t1..t2
            html=html..AddHTMLEntry("Silumin")
            html=html..AddHTMLEntry("Steel")        
            html=html..AddHTMLEntry("AlFe")
            html=html..AddHTMLEntry("Polycarbonate")
            html=html..AddHTMLEntry("Glass")
            html=html..AddHTMLEntry("Hydrogen")
            html=html..AddHTMLEntry("Oxygen")
            html=html..c1
            displayT1b.setHTML(html)
        end
        if displayT2a then
            html=htmlHeader
            html=html..d1..d2.."T2 Ores & Ingots"..t1..t2
            html=html..AddHTMLEntry("Chromite")
            html=html..AddHTMLEntry("Chromium")
            html=html..AddHTMLEntry("Limestone")
            html=html..AddHTMLEntry("Calcium")
            html=html..AddHTMLEntry("Malachite")
            html=html..AddHTMLEntry("Copper")
            html=html..AddHTMLEntry("Natron")
            html=html..AddHTMLEntry("Sodium")
            html=html..c1
            displayT2a.setHTML(html)
        end
        if displayT2b then
            html=htmlHeader
            html=html..d1..d2.."T2 Etc."..t1..t2
            html=html..AddHTMLEntry("Duralumin")
            html=html..AddHTMLEntry("Stainless")
            html=html..AddHTMLEntry("CaCu")
            html=html..AddHTMLEntry("Polycalcite")
            html=html..AddHTMLEntry("AdvGlass")
            html=html..c1
            displayT2b.setHTML(html)
        end
        if displayT3a then
            html=htmlHeader
            html=html..d1..d2.."T3 Ores & Ingots"..t1..t2
            html=html..AddHTMLEntry("Acanthite")
            html=html..AddHTMLEntry("Silver")
            html=html..AddHTMLEntry("Garnierite")
            html=html..AddHTMLEntry("Nickel")
            html=html..AddHTMLEntry("Petalite")
            html=html..AddHTMLEntry("Lithium")
            html=html..AddHTMLEntry("Pyrite")
            html=html..AddHTMLEntry("Sulfur")
            html=html..c1
            displayT3a.setHTML(html)
        end
        if displayT3b then
            html=htmlHeader
            html=html..d1..d2.."T3 Etc."..t1..t2
            html=html..AddHTMLEntry("AlLi")
            html=html..AddHTMLEntry("Inconel")
            html=html..AddHTMLEntry("CuAg")
            html=html..AddHTMLEntry("Polysulfide")
            html=html..AddHTMLEntry("AgLiGlass")
            html=html..c1
            displayT3b.setHTML(html)
        end
            if displayT4a then
            html=htmlHeader
            html=html..d1..d2.."T4 Ores & Ingots"..t1..t2
            html=html..AddHTMLEntry("Cobaltite")
            html=html..AddHTMLEntry("Cobalt")
            html=html..AddHTMLEntry("Cryolite")
            html=html..AddHTMLEntry("Fluorine")
            html=html..AddHTMLEntry("GoldNuggets")
            html=html..AddHTMLEntry("Gold")
            html=html..AddHTMLEntry("Kolbeckite")
            html=html..AddHTMLEntry("Scandium")
            html=html..c1
            displayT4a.setHTML(html)
        end
        if displayT4b then
            html=htmlHeader
            html=html..d1..d2.."T4 Etc."..t1..t2
            html=html..AddHTMLEntry("ScAl")
            html=html..AddHTMLEntry("Maraging")
            html=html..AddHTMLEntry("RedGold")
            html=html..AddHTMLEntry("Fluoropolymer")
            html=html..AddHTMLEntry("GoldCoated")
            html=html..c1
            displayT4b.setHTML(html)
        end
        if displayT5a then
            html=htmlHeader
            html=html..d1..d2.."T5 Ores & Ingots"..t1..t2
            html=html..AddHTMLEntry("Columbite")
            html=html..AddHTMLEntry("Niobium")
            html=html..AddHTMLEntry("Illmenite")
            html=html..AddHTMLEntry("Titanium")
            html=html..AddHTMLEntry("Rhodonite")
            html=html..AddHTMLEntry("Manganese")
            html=html..AddHTMLEntry("Vanadinite")
            html=html..AddHTMLEntry("Vanadium")
            html=html..c1
            displayT5a.setHTML(html)
        end
        if displayT5b then
            html=htmlHeader
            html=html..d1..d2.."T5 Etc."..t1..t2
            html=html..AddHTMLEntry("TiNb")
            html=html..AddHTMLEntry("Mangalloy")
            html=html..AddHTMLEntry("TitaniumAlloy")
            html=html..AddHTMLEntry("Vanamer")
            html=html..AddHTMLEntry("MnGlass")
            html=html..c1
            displayT5b.setHTML(html)
        end
        if displayFuels then
            html=htmlHeader
            html=html..d1..d2.."Fuels"..t1..t2
            html=html..AddHTMLEntry("WarpCells")
            html=html..AddHTMLEntry("Kergon")
            html=html..AddHTMLEntry("Nitron")
            html=html..AddHTMLEntry("Xeron")
            html=html..c1
            displayFuels.setHTML(html)
        end
    end

    processTick()
    unit.setTimer('updateTick', 5)
end

function script.onStop ()
    displayOff()
end

function script.onTick (updateTick)
    processTick()
end


script.onStart()
