struct Day02: AdventDay {

  var data: String

    let _entities: [[Int]]
    
    var entities: [[Int]] {
        _entities
  }

    init(data: String) {
        self.data = data.trimmingCharacters(in: .newlines)
        
        _entities = data
            .components(separatedBy: "\n")
            .map {
                $0.components(separatedBy: " ")
                    .compactMap(Int.init)
            }
    }

    func resolve(_ report: [Int]) -> Bool {

        var attemptedIndex = 0
        while(attemptedIndex < report.count) {
            var dampenedReport = report
            dampenedReport.remove(at: attemptedIndex)
            if determineSafety(dampenedReport) { return true }
            attemptedIndex+=1
        }
        return false
    }
    func determineSafety(_ report: [Int], dampened: Bool = false) -> Bool {
        guard report[0] != report[1], abs(report[0] - report[1]) <= 3 else {
            if dampened {
                return resolve(report)
            }
            return false
        }
        let initialDirection = (report[1] - report[0]) / abs(report[1] - report[0])
        for i in 1..<report.count {
            guard report[i] != report[i-1], abs(report[i] - report[i-1]) <= 3 else {
                if dampened {
                    return resolve(report)
                }
                return false
            }
            let currentDirection = (report[i] - report[i-1]) / abs(report[i] - report[i-1])
            guard initialDirection / currentDirection == 1 else {
                if dampened {
                    return resolve(report)
                }
                return false
            }
        }

        return true
    }
    
    
    
  func part1() -> Any {
      entities.map{self.determineSafety($0)}.count(where: \.self)
  }

  func part2() -> Any {
      entities.map{self.determineSafety($0, dampened: true)}.count(where: \.self)
  }
}
