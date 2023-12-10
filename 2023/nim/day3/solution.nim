import ../utils

const targets = "+-*@#$%^&*/="

proc hasAdjacentSymbol(grid: seq[string], point: tuple, t: string = targets): bool =
    let x, y = point
    return true

proc day1(): void =
    let grid = "input.txt".toStringSeq
    var sum = 0
    for x in countup(0, grid.len - 1):
        var currentNum = ""
        for y in countup(0, grid[0].len - 1):
            if currentNum != "":