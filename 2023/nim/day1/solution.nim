import std/sequtils, strutils
import ../utils

proc firstInt(s: string): int =
    for c in s:
        try:
            return parseInt($c)
        except ValueError:
            continue
    
    raise newException(ValueError, "string contains no parseable ints")

proc wordToInt(s: string): string =
    const 
        wordIntTable = @[
            ("one", "1"),
            ("two", "2"),
            ("three", "3"),
            ("four", "4"),
            ("five", "5"),
            ("six", "6"),
            ("seven", "7"),
            ("eight", "8"),
            ("nine", "9"),
            ("ten", "10")
        ]
        # Jank? Maybe. A good solution? 100%
        replacements = @[
            ("zerone", "zeroone"),
            ("oneight", "oneeight"),
            ("twone", "twoone"),
            ("sevenine", "sevennine"),
            ("eightwo", "eighttwo"),
            ("eighthree", "eightthree"),
            ("nineight", "nineeight")
        ]
    result = s
        .multiReplace(replacements)
        .multiReplace(wordIntTable)


proc part1(): void =
    let lines = "input.txt".toStringSeq
    var sum: int
    for line in lines:
        let 
            first = line.firstInt
            last = line.reversed.firstInt
        sum += first*10 + last
    
    echo sum

proc part2(): void =
    let lines = "input.txt".toStringSeq.map(wordToInt)
    var sum: int
    for line in lines:
        let
            first = line.firstInt
            last = line.reversed.firstInt
        sum += first*10 + last
    
    echo sum

if isMainModule:
    part1()
    part2()