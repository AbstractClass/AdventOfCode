import ../utils
import std/sequtils, strutils, sugar

const ints = "0123456789"

proc neighbours(grid: seq[string], row, colStart, colStop: int): string =
    # fuck it, brute force the indexes available because fuck walls
    for x in row-1 .. row+1:
        for y in countup(colStart-1, colStop+1):
            try:
                if not ints.contains($grid[x][y]):
                    result.add($grid[x][y])
            except IndexDefect:
                continue


proc part1(): void =
    let grid = "input.txt".toStringSeq.mapIt(it.strip)
    var sum: int
    for x in countup(0, grid.len-1):
        var currentNum: string
        var head, tail: int
        for y in countup(0, grid[x].len-1):
            if grid[x][y] in ints:
                if currentNum == "":
                    head = y
                currentNum = currentNum & $grid[x][y]
                if y == grid[x].len-1:
                    tail = y-1
                    let neighboursString = grid.neighbours(x, head, tail)
                    if not neighboursString.all((c: char) => c == '.'):
                        #echo "Valid: ", currentNum
                        sum += currentNum.parseInt
            elif currentNum != "":
                tail = y-1
                let neighboursString = grid.neighbours(x, head, tail)
                if not neighboursString.all((c: char) => c == '.'):
                    #echo "Valid: ", currentNum
                    sum += currentNum.parseInt
                    #echo currentNum
                else:
                    echo neighboursString
                    echo "Invalid: ", currentNum, " ", grid[x][head .. tail]
                currentNum = ""
    echo "Sum: ", sum

if isMainModule:
    part1()