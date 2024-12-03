import Foundation
struct Day03: AdventDay {
    var data: String

    private var _entities = [(Int,Int)]()
    
    init(data: String) {
        self.data = data
        let ranges = data.ranges(of: /mul\([0-9]{1,3},[0-9]{1,3}\)/)
        for range in ranges {
            let str = data[(data.index(range.lowerBound, offsetBy: 4))...(data.index(range.upperBound, offsetBy: -2))]
            let nums = str.components(separatedBy: ",")
            _entities.append((Int(nums[0])!, Int(nums[1])!))
        }
        
        
    }
    var entities: [(Int,Int)] {
        return _entities
    }

    func part1() -> Any {
        entities.reduce(0) {
            $0 + $1.0 * $1.1
        }
    }

    func part2() -> Any {
        0
    }
}
