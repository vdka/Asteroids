
/// Generates 32 bit Psuedo Random numbers in a reproducible way using a (PCG)[http://www.pcg-random.org/] RNG
public struct PCGRand32 {
    public var state: UInt64
    public var increment: UInt64

    /// Create a new RNG with a given state
    public init(state: UInt64 = Constant.defaultSeed, increment: UInt64 = Constant.defaultIncrement) {
        self.state = state
        self.increment = increment
    }

    private enum Constant {
        static let multiplier: UInt64 = 6364136223846793005
        static let defaultSeed: UInt64 = 0x853c49e6748fea9b
        static let defaultIncrement: UInt64  = 0xda3e39cb94b95bdb
    }

    public mutating func boundedNext(_ bound: UInt32) -> UInt32 {

        /// From PCG-C-Basic

        // To avoid bias, we need to make the range of the RNG a multiple of
        // bound, which we do by dropping output less than a threshold.
        // A naive scheme to calculate the threshold would be to do
        //
        //     uint32_t threshold = 0x100000000ull % bound;
        //
        // but 64-bit div/mod is slower than 32-bit div/mod (especially on
        // 32-bit platforms).  In essence, we do
        //
        //     uint32_t threshold = (0x100000000ull-bound) % bound;
        //
        // because this version will calculate the same modulus, but the LHS
        // value is less than 2^32.
        let threshold = (~bound + 1) % bound

        // Uniformity guarantees that this loop will terminate.  In practice, it
        // should usually terminate quickly; on average (assuming all bounds are
        // equally likely), 82.25% of the time, we can expect it to require just
        // one iteration.  In the worst case, someone passes a bound of 2^31 + 1
        // (i.e., 2147483649), which invalidates almost 50% of the range.  In
        // practice, bounds are typically small and only a tiny amount of the range
        // is eliminated.
        repeat {
            let r = next()
            if r >= threshold {
                return r % bound
            }
        } while true
    }

    /// Returns the next Psuedo random number from this RNG
    public mutating func next() -> UInt32 {

        // get the old state
        let oldState = state

        /// Advance internal state
        state = nextState(state)

        // get a xorShift?
        let xorShifted = UInt32(truncatingBitPattern: ((oldState >> 18) ^ oldState) >> 27)

        // get a rot?
        let rot = UInt32(truncatingBitPattern: oldState >> 59)

        //// Calculate output function (XSH RR), uses old state for max ILP
        let transform = (xorShifted >> rot) | (xorShifted << ((~rot &+ 1) & 31))
        
        // return the transform
        return transform
    }
    
    /// :nodoc:
    private func nextState(_ input: UInt64) -> UInt64 {
        return state &* Constant.multiplier &+ increment
    }

    mutating func boundedNext(_ bound: Float) -> Float {
        let val = next()

        return (Float(val) / Float(UInt32.max)) * bound
    }
}
