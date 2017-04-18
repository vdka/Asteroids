
import Asteroids

var memory = Asteroids.setup()

while !memory.assumingMemoryBound(to: Bool.self).pointee {

  Asteroids.update(memory)
}

print("Did quit cleanly!")
