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
        //UP
        if startR >= 3 {
            if entities[startR-1][startC] == "M",
               entities[startR-2][startC] == "A",
               entities[startR-3][startC] == "S" {
                count+=1
            }
        }
        
        //DOWN
        if startR < entities.count - 3 {
            if entities[startR+1][startC] == "M",
               entities[startR+2][startC] == "A",
               entities[startR+3][startC] == "S" {
                count+=1
            }
        }
        
        //LEFT
        if startC >= 3 {
            if entities[startR][startC-1] == "M",
               entities[startR][startC-2] == "A",
               entities[startR][startC-3] == "S" {
                count+=1
            }
        }
        
        //RIGHT
        if startC < entities[startR].count - 3 {
            if entities[startR][startC+1] == "M",
               entities[startR][startC+2] == "A",
               entities[startR][startC+3] == "S" {
                count+=1
            }
        }
        
        //UPLEFT
        if startC >= 3 && startR >= 3 {
            if entities[startR-1][startC-1] == "M",
               entities[startR-2][startC-2] == "A",
               entities[startR-3][startC-3] == "S" {
                count+=1
            }
        }
        //UPRIGHT
        if startC < entities[startR].count - 3 && startR >= 3 {
            if entities[startR-1][startC+1] == "M",
               entities[startR-2][startC+2] == "A",
               entities[startR-3][startC+3] == "S" {
                count+=1
            }
        }
        //DOWNLEFT
        if startC >= 3 && startR < entities.count - 3 {
            if entities[startR+1][startC-1] == "M",
               entities[startR+2][startC-2] == "A",
               entities[startR+3][startC-3] == "S" {
                count+=1
            }
        }
        //DOWNRIGHT
        if startC < entities[startR].count - 3 && startR < entities.count - 3 {
            if entities[startR+1][startC+1] == "M",
               entities[startR+2][startC+2] == "A",
               entities[startR+3][startC+3] == "S" {
                count+=1
            }
        }
        
        return count
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        // Calculate the sum of the first set of input data
        var count = 0
        for row in 0..<entities.count {
            for col in 0..<entities[row].count {
                count+=findXmas(startR: row, startC: col)
            }
        }
        
        return count
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        // Sum the maximum entries in each set of data
        0
    }
}
