const input = "input.txt"

proc toStringSeq*(path: string = input): seq[string] =
    for line in path.lines:
        result.add(line)

proc reversed*(s: string): string = 
    for c in s:
        result = c & result
