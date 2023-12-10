import std/sequtils, strutils, tables

proc toGameFormat(s: string): Table[string, int] = 
    let rounds = s.split(':')[^1].split(';')
    result = {
        "red": 0,
        "green": 0,
        "blue": 0
    }.toTable
    for round in rounds:
        let diceCount = round.split(',')
        for die in diceCount:
            let 
                components = die.split(' ')
                colour = components[^1]
                count = parseInt(components[^2])
            #[ 
                I initially did it this way to be clever (only caring about the max value of any colour), 
                but as it turns out day2 requires this 
            ]#
            if count > result[colour]:
                result[colour] = count

proc isWinnable(game, target: Table[string, int]): bool =
    result = true
    for k, v in target.pairs:
        if game[k] > target[k]:
            result = false
            break


const goal = {
    "red": 12,
    "green": 13,
    "blue": 14
}.toTable

proc day1(): void =
    var formattedGames: seq[Table[string, int]]
    for game in "input.txt".lines:
        formattedGames.add(game.toGameFormat)
    var winnableGames = 0
    for i in countup(0, formattedGames.len-1):
        if isWinnable(formattedGames[i], goal):
            winnableGames += i+1
    echo winnableGames

proc day2(): void =
    var
        sum = 0
    for game in "input.txt".lines:
        let formattedGame = game.toGameFormat
        sum += formattedGame.values.toSeq.foldl(a * b)
    
    echo sum

if isMainModule:
    day1()
    day2()
