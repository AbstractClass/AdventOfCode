import ../utils
import std/math, sequtils, sets, strutils, sugar, times

type
    Card = ref object
        id: int
        winningNumbers: HashSet[string]
        chosenNumbers: HashSet[string]
        copiesWon: int = 1

proc winnings(card: Card): seq[string] =
    result = toSeq(card.chosenNumbers * card.winningNumbers)

proc points(winningNumbers: seq[string]): int =
    result = 1
    for _ in 0 ..< winningNumbers.len:
        result *= 2

proc part1(): void =
    let rawCards = "input.txt".toStringSeq
    var cards: seq[Card]
    for i, rawCards in rawCards:
        let numbers = rawCards.split(":")[1].split("|")
        cards.add(Card(id: i,
                       winningNumbers: numbers[0].split(" ").filter((it) => it.len > 0).toHashSet,
                       chosenNumbers: numbers[1].split(" ").filter((it) => it.len > 0).toHashSet))
    echo "Sum of points: ", cards.map((it) => it.winnings.points).sum

proc part2(): void =
    let rawCards = "input.txt".toStringSeq
    var cards: seq[Card]
    for i, rawCard in rawCards:
        let numbers = rawCard.split(":")[1].split("|")
        cards.add(Card(id: i,
                       winningNumbers: numbers[0].split(" ").filter((it) => it.len > 0).toHashSet,
                       chosenNumbers: numbers[1].split(" ").filter((it) => it.len > 0).toHashSet))
    for idx, card in cards:
        let winningNumbers = card.winnings
        for _ in 1 .. card.copiesWon:
            for winningBonus in 1 .. winningNumbers.len:
                cards[idx + winningBonus].copiesWon.inc

    let totalCards = cards.map((it) => it.copiesWon).sum
    
    echo "Total cards won: ", totalCards

if isMainModule:
    let start = cpuTime()
    part1()
    part2()
    echo "Finished in: ", cpuTime() - start, " seconds"