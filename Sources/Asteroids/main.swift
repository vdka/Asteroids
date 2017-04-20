
var memory = setup()

while memory.pointee.currStateSize != 0 {

  update(memory)
}

print("Did quit cleanly!")

