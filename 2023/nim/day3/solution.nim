import ../utils
import std/sequtils, strutils, sugar

const ints = "0123456789"

proc neighbours(grid: seq[string], row, colStart, colStop: int): string =
    let # Adjust for grid floor, ceiling, and walls
        minRow = max(0, row-1)
        maxRow = min(grid.len-1, row+1)

    # fuck it, brute force the indexes available because fuck walls
    for line in grid[minRow .. maxRow]:
        for x in countup(colStart-1, colStop+1):
            try:
                if not ints.contains($line[x]):
                    result.add($line[x])
            except IndexDefect:
                continue


proc part1(): void =
    let grid = "input.txt".toStringSeq
    var sum: int
    for x in countup(0, grid.len-1):
        var currentNum: string
        var head, tail: int
        for y in countup(0, grid[x].len-1):
            if grid[x][y] in ints:
                if currentNum == "":
                    head = y
                currentNum = currentNum & $grid[x][y]
            elif currentNum != "":
                #echo currentNum
                tail = y-1
                #echo "x: ", x, " y: ", y
                #echo "head: ", head, " tail: ", tail
                let neighboursString = grid.neighbours(x, head, tail)
                if not neighboursString.all((c: char) => c == '.'):
                    #echo "Valid: ", currentNum
                    sum += currentNum.parseInt
                else:
                    echo neighboursString
                    echo "Invalid: ", currentNum
                currentNum = ""
    echo "Sum: ", sum

if isMainModule:
    part1()