struct Day01: AdventDay {

  var data: String

    var entities: [[Int]] {
        let parts = data.split(separator: "\n")
        var left = [Int?]()
        var right = [Int?]()

        parts.forEach {
            let ints = $0.split(separator: "   ")
            left.append(Int(ints[0]))
            right.append(Int(ints[1]))
        }
        return [left.compactMap(\.self), right.compactMap(\.self)]
  }

  func part1() -> Any {
      let values = entities
      let left = values[0].sorted()
      let right = values[1].sorted()

      var result = 0
      for i in left.indices {
          result+=abs(left[i]-right[i])
      }
      return result
  }

  func part2() -> Any {
      let values = entities
      let left = values[0]
      var frequency = [Int: Int]()
      for num in values[1] {
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
