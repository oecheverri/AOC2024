struct Button {
    let cost: Int
    let deltaX: Int
    let deltaY: Int

    var dX: Double {
        Double(deltaX)
    }
    var dY: Double {
        Double(deltaY)
    }

    init?(_ string: String, cost: Int) {
        let components = string.split(separator: " ")
        let xStr = components[0][components[0].index(components[0].startIndex, offsetBy: 2)..<components[0].index(before: components[0].endIndex)]
        let yStr = components[1][components[1].index(components[1].startIndex, offsetBy: 2)..<components[1].endIndex]
        guard let x = Int(xStr), let y = Int(yStr) else { return nil }
        self.cost = cost
        self.deltaX = x
        self.deltaY = y
    }
}
extension Point {
    var dX: Double {
        Double(x)
    }
    var dY: Double {
        Double(y)
    }
}
struct Machine {
    let prize: Point
    let buttons: [Button]

    init (_ string: String) {
        let components = string.components(separatedBy: "\n")
        var buttonAStr = components[0]
        var buttonBStr = components[1]
        var prizeStr = components[2]

        buttonAStr = String(buttonAStr[buttonAStr.index(after: buttonAStr.firstIndex(of: ":")!)..<buttonAStr.endIndex])
        buttonBStr = String(buttonBStr[buttonBStr.index(after: buttonBStr.firstIndex(of: ":")!)..<buttonBStr.endIndex])
        prizeStr = String(prizeStr[prizeStr.index(after: prizeStr.firstIndex(of: ":")!)..<prizeStr.endIndex])
        buttons = [
            .init(buttonAStr, cost: 3),
            .init(buttonBStr, cost: 1)
        ].compactMap(\.self)

        let prizeComps = prizeStr.split(separator: " ")
        let xStr = prizeComps[0][prizeComps[0].index(prizeComps[0].startIndex, offsetBy: 2)..<prizeComps[0].index(before: prizeComps[0].endIndex)]
        let yStr = prizeComps[1][prizeComps[1].index(prizeComps[1].startIndex, offsetBy: 2)..<prizeComps[1].endIndex]

        prize = .init(
            Int(xStr)!,
            Int(yStr)!
        )

    }
}

struct Day13: AdventDay {

    var data: String

    var machines: [Machine] = []
    var entities: [Machine] {
        machines
    }

    init(data: String) {
        self.data = data
        machines = data.components(separatedBy: "\n\n")
            .map(Machine.init)
    }

    func solveCost(_ machine: Machine) -> Int {
        let buttonA = machine.buttons[0]
        let buttonB = machine.buttons[1]
        let xA = buttonA.dX
        let yA = buttonA.dY
        let xB = buttonB.dX
        let yB = buttonB.dY
        let xC = machine.prize.dX
        let yC = machine.prize.dY

        let pA = (xC * yB - xB * yC) / (xA * yB - yA * xB)
        let pB = (xC - pA * xA) / xB

        if pA > 100 || pB > 100 {
            return 0
        }
        return Int(pA * 3 + pB)
    }

    func part1() -> Any {
        machines.reduce(0) { $0 + solveCost($1)}
    }

    func part2() -> Any {
        0
    }
}

extension Array {
    func combinations(elementCount: Int, memoizer: inout [Int: [[Element]]]) -> [[Element]] {
        if let memoized = memoizer[elementCount] {
            return memoized
        }
        if elementCount == 0 {
            return []
        }
        if elementCount == 1 {
            return self.map {
                [$0]
            }
        }

        let partial = combinations(elementCount: elementCount - 1, memoizer: &memoizer)
        let result = self.flatMap { outer in
            partial.map {
                var inner = $0
                inner.append(outer)
                return inner
            }
        }
        memoizer[elementCount] = result
        return result
    }
}
