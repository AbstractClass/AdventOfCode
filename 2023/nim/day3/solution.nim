import ../utils
import std/sequtils, sets, strutils, sugar, tables, times

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
    # TODO: We can make this read as a stream so we don't read the whole file into memory, we just read 3 lines at a time, but we will have to do some extra work to handle the first and last lines
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


proc findNumberBounds(grid: seq[string], x, y: int): tuple[head: int, tail: int] =
    #[
        When we find a number, we need to find the start and end of it, so we search backwards and forwards from the current position
        until we find a non-number, and then we know the start and end of the number

        We could return the parsed number here, but we keep the head and tail so we can use it to keep track of the positions of the numbers and avoid duplicates
    ]#
    var i = y
    while i >= 0 and grid[x][i] in ints:
        i -= 1
    let head = i + 1

    i = y
    while i < grid[x].len and grid[x][i] in ints:
        i += 1
    let tail = i - 1

    return (head: head, tail: tail)

proc numberNeighbours(grid: seq[string], row, colStart, colStop: int): seq[int] =
    #[
        In the event that a gear has two adjacent numbers of the same value 
        we need to keep track of the positions of both of them because we often add the same number twice and dedupe later

        Consider the following grid:
            . . . 1 2 3 . . .
            . . . . * . . . .
            . . . 1 2 3 . . .
        
        This is the nightmare scenario, we have 2 adjacent numbers of the same value, 
        and they are both adjacent to the gear indicator, and they both have the same index in the grid

        We will be matching the first number 3 times, and the second number 3 times, because both share 3 adjacent cells with the gear indicator.
        Each adjacent number discovered will be searched forwards and backwards to find the start and end of the number.

        We use the HashSet[int] to keep track of the positions of the numbers, and dedupe based on the position of the
        row, head and tail of the number as a HashSet

        Tbh there is probably a better way to do this, but I don't know it
    ]#
    var lookup = initTable[HashSet[int], int]()
    for x in max(0, row-1) .. min(row+1, grid.len-1):
        for y in max(0, colStart-1) .. min(colStop+1, grid[x].len-1):
            if grid[x][y] in ints:
                let 
                    bounds = findNumberBounds(grid, x, y)
                    num = grid[x][bounds.head..bounds.tail].parseInt
                    key = @[x, bounds.head, bounds.tail].toHashSet
                if not lookup.hasKey(key) or lookup[key] != num:
                    lookup[key] = num
    result = lookup.values.toSeq

proc part2(): void =
    let grid = "input.txt".toStringSeq.mapIt(it.strip) # Creates an array of strings to iterate as a 2D array of chars
    var sum: int
    for x in 0 .. grid.len-1:
        for y in 0 .. grid[x].len-1:
            if grid[x][y] == '*': # gear indicator
                let nums = grid.numberNeighbours(x, y, y)
                if nums.len >= 2:
                    sum += nums.foldl(a*b)
    echo "Sum of gears: ", sum


if isMainModule:
    let start = cpuTime()
    part1()
    part2()
    echo "Finished in: ", cpuTime() - start, " seconds"