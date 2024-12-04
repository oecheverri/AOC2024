import Algorithms

struct Day04: AdventDay {

    var data: String

    private let _entities: [[Character]]

    var entities: [[Character]] {
        _entities
    }

    init(data: String) {
        self.data = data
        self._entities = data.components(separatedBy: .newlines).compactMap {
            if $0.isEmpty { return nil }
            return Array($0)
        }
    }

    func findXmas(startR: Int, startC: Int) -> Int {
        guard entities[startR][startC] == "X" else { return 0 }
        var count = 0
        // UP
        if startR >= 3 {
            if entities[startR-1][startC] == "M",
               entities[startR-2][startC] == "A",
               entities[startR-3][startC] == "S" {
                count+=1
            }
        }

        // DOWN
        if startR < entities.count - 3 {
            if entities[startR+1][startC] == "M",
               entities[startR+2][startC] == "A",
               entities[startR+3][startC] == "S" {
                count+=1
            }
        }

        // LEFT
        if startC >= 3 {
            if entities[startR][startC-1] == "M",
               entities[startR][startC-2] == "A",
               entities[startR][startC-3] == "S" {
                count+=1
            }
        }

        // RIGHT
        if startC < entities[startR].count - 3 {
            if entities[startR][startC+1] == "M",
               entities[startR][startC+2] == "A",
               entities[startR][startC+3] == "S" {
                count+=1
            }
        }

        // UPLEFT
        if startC >= 3 && startR >= 3 {
            if entities[startR-1][startC-1] == "M",
               entities[startR-2][startC-2] == "A",
               entities[startR-3][startC-3] == "S" {
                count+=1
            }
        }
        // UPRIGHT
        if startC < entities[startR].count - 3 && startR >= 3 {
            if entities[startR-1][startC+1] == "M",
               entities[startR-2][startC+2] == "A",
               entities[startR-3][startC+3] == "S" {
                count+=1
            }
        }
        // DOWNLEFT
        if startC >= 3 && startR < entities.count - 3 {
            if entities[startR+1][startC-1] == "M",
               entities[startR+2][startC-2] == "A",
               entities[startR+3][startC-3] == "S" {
                count+=1
            }
        }
        // DOWNRIGHT
        if startC < entities[startR].count - 3 && startR < entities.count - 3 {
            if entities[startR+1][startC+1] == "M",
               entities[startR+2][startC+2] == "A",
               entities[startR+3][startC+3] == "S" {
                count+=1
            }
        }

        return count
    }

    func findMas(row: Int, col: Int) -> Int {
        guard row > 0, row < entities.count - 1,
              col > 0, col < entities[row].count - 1,
              entities[row][col] == "A" else { return 0 }
        var count = 0

        if ((entities[row-1][col-1] == "M" && entities[row+1][col+1] == "S") ||
            (entities[row-1][col-1] == "S" && entities[row+1][col+1] == "M")) &&

            ((entities[row-1][col+1] == "M" && entities[row+1][col-1] == "S") ||
                (entities[row-1][col+1] == "S" && entities[row+1][col-1] == "M")) {
            count+=1
        }

        return count
    }

    func part1() -> Any {
        var count = 0
        for row in 0..<entities.count {
            for col in 0..<entities[row].count {
                count+=findXmas(startR: row, startC: col)
            }
        }

        return count
    }

    func part2() -> Any {
        var count = 0
        for row in 0..<entities.count {
            for col in 0..<entities[row].count {
                count+=findMas(row: row, col: col)
            }
        }

        return count
    }
}
