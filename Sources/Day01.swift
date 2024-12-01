struct Day01: AdventDay {

  var data: String

    let _entities: [[Int]]
    
    var entities: [[Int]] {
        _entities
  }

    init(data: String) {
        self.data = data
        
        let parts = data.components(separatedBy: "\n")
        var left = [Int?]()
        var right = [Int?]()

        parts.forEach {
            let ints = $0.components(separatedBy: "   ")
            
            guard ints.count == 2 else { return }
            left.append(Int(ints[0]))
            right.append(Int(ints[1]))
            
        }
        _entities = [left.compactMap(\.self), right.compactMap(\.self)]
    }
  func part1() -> Any {
      let left = entities[0].sorted()
      let right = entities[1].sorted()

      var result = 0
      for i in left.indices {
          result+=abs(left[i]-right[i])
      }
      
      return result
  }

  func part2() -> Any {
      let left = entities[0]
      var frequency = [Int: Int]()
      for num in entities[1] {
          if let count = frequency[num] {
              frequency[num] = count + 1
          } else {
              frequency[num] = 1
          }
      }
      return left.reduce(0) {
          $0 + $1 * (frequency[$1] ?? 0)
      }
  }
}
