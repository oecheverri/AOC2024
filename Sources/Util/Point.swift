struct Point: Equatable, Hashable, Comparable, CustomDebugStringConvertible {
    let x: Int
    let y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    init (x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    var debugDescription: String {
        "(\(x),\(y))"
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.y == rhs.y {
            return lhs.x < rhs.x
        }
        return lhs.y < rhs.y

    }
}
