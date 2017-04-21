
struct Arena<Element>: MutableCollection {

    var count: Int
    var buffer: UnsafeMutableBufferPointer<Element>

    init(capacity: Int = 0) {
        self.count = 0

        assert(capacity > 0)

        let ptr = UnsafeMutablePointer<Element>.allocate(capacity: capacity)

        self.buffer = UnsafeMutableBufferPointer(start: ptr, count: capacity)
    }

    var underestimatedCount: Int {
        return count
    }

    func makeIterator() -> AnyIterator<Element> {

        var index = buffer.startIndex
        return AnyIterator {
            guard index < self.count else {
                return nil
            }

            defer {
                index = self.buffer.index(after: index)
            }

            return self.buffer[index]
        }
    }

    var startIndex: Int {
        return buffer.startIndex
    }

    var endIndex: Int {
        return buffer.startIndex.advanced(by: count)
    }

    subscript(position: Int) -> Element {
        get {
            return buffer[position]
        }
        set {
            buffer[position] = newValue
        }
    }

    func index(after i: Int) -> Int {
        guard i < count else {
            fatalError()
        }
        return buffer.index(after: i)
    }

    mutating func append(_ newElement: Element) {
        self.buffer[count] = newElement
        count += 1
    }

    @discardableResult
    mutating func remove(at index: Int) -> Element {
        guard self.indices.contains(index) else {
            fatalError("Out of bounds")
        }
        let entity = self.buffer[index]
        self.buffer[index] = self.buffer[count - 1]
        count -= 1

        return entity
    }
}
