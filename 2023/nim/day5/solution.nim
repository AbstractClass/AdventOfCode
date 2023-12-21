import ../utils
import std/sequtils, strformat, strutils, sugar, tables

type
    Unit = object
        category: string
        number: int
    FarmMap = object
        sourceName: string
        destName: string
        conversionTable: Table[(int, int), int] # range -> conversion modifier

proc doMapConversion(map: FarmMap, unit: Unit): int =
    result = unit.number
    for (targetRange, modifier) in map.conversionTable.pairs:
        if targetRange[0] <= result and result < targetRange[1]:
            result += modifier
            break
    #echo &"converted {unit.category} {unit.number} to {map.destName} {result}"

proc parseInputData(rawData: seq[string]): (seq[int], Table[string, FarmMap]) =
    var 
        unitConversionTable: Table[string, FarmMap]
        currentMap: FarmMap
        seeds: seq[int]
    for line in rawData:
        if line.contains("seeds"):
            seeds = line.split(" ")[1..^1].map(parseInt)
        elif line.contains("-to-"):
            let parsedLine = line.split(" ")[0].split("-") # chop the ` map`
            let (sourceName, destName) = (parsedLine[0], parsedLine[2])
            currentMap = FarmMap(
                sourceName: sourceName,
                destName: destName)
            unitConversionTable[currentMap.sourceName] = currentMap
        elif line.contains(" "):
            let 
                parsedLine = line.split(" ").map(parseInt)
                (dest, source, length) = (parsedLine[0], parsedLine[1], parsedLine[2])
                targetRange = (source, source + length)
                conversionModifier = dest - source
            unitConversionTable[currentMap.sourceName]
                .conversionTable[targetRange] = conversionModifier
    (seeds, unitConversionTable)

proc walk(mapTable: Table[string, FarmMap], unit: Unit, destination: string = "location"): Unit =
    var walkingUnit = unit
    while walkingUnit.category != destination:
        let 
            targetMap = mapTable[walkingUnit.category]
            newAmount = targetMap.doMapConversion(walkingUnit)
        walkingUnit = Unit(category: targetMap.destName, number: newAmount)
    walkingUnit

proc part1(): void =
    let rawData = "input.txt".toStringSeq
    let (seeds, unitConversionTable) = parseInputData(rawData)
    #dump unitConversionTable
    let locations = collect:
        for seed in seeds:
            let
                unit = Unit(category: "seed", number: seed)
                locationUnit = unitConversionTable.walk(unit)
            locationUnit.number

    echo locations.min
if isMainModule:
    part1()
