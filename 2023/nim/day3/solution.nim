import ../utils
import std/sequtils, sets, strutils, sugar, times

const emptyCell = '.'
const ints = toHashSet(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'])

proc getNeighbouringCells(grid: seq[string], row, colStart, colStop: int): string =
    for x in max(0, row-1) .. min(row+1, grid.len-1):
        for y in max(0, colStart-1) .. min(colStop+1, grid[x].len-1):
            if not ints.contains(grid[x][y]):
                result.add($grid[x][y])

proc isValid(grid: seq[string], row, head, tail: int): bool =
    let neighboursString = grid.getNeighbouringCells(row, head, tail)
    result = neighboursString.any((c: char) => c != emptyCell)

proc processNumber(grid: seq[string], x: int, head: int, tail: int, currentNum: string, sum: var int) =
    let valid = grid.isValid(x, head, tail)
    if valid:
        sum += currentNum.parseInt

proc part1(): void =
    let grid = "input.txt".toStringSeq.mapIt(it.strip) # Creates an array of strings to iterate as a 2D array of chars
    var sum: int
    for x in countup(0, grid.len-1):
        var currentNum = newStringOfCap(10)
        var head: int
        for y in countup(0, grid[x].len-1):
            if grid[x][y] in ints:
                if currentNum.len == 0:
                    head = y
                currentNum.add($grid[x][y])
                if y == grid[x].len-1:
                    processNumber(grid, x, head, y-1, currentNum, sum)
            elif currentNum.len > 0:
                processNumber(grid, x, head, y-1, currentNum, sum)
                currentNum.setLen(0)
    echo "Sum: ", sum

if isMainModule:
    let start = cpuTime()
    part1()
    echo "Finished in: ", cpuTime() - start, " seconds"