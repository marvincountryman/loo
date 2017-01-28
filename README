# loo
Simple somewhat non-intrusive oop library for lua.  Created
due to my need for an oop library that allows for static fields,
localized class storage, helper stuff, and metamethod hooks.

### Example

```lua
require "class"

local Pet = class("Pet")
local Dog = class("Dog", Pet)
local Cat = class("Cat", Pet)

-- Instance fields
Pet.Noise = "..."

-- Static fields
Pet.static.Count = 1

-- Constructor
function Pet:Pet()
    Pet.static.Count = Pet.static.Count + 1

    if Pet.static.Count > 10 then
        print "That's a bunch of pets.."
    end
end
function Pet:MakeNoise()
    print("The "..self.__type.name.." says "..self.Noise)
end

Dog.Noise = "Bark"

function Cat:MakeNoise()
    self:KnockShitOffCounter()
    self:StareAt(me)
end

local dog = Dog()
local cat = Cat()

dog:MakeNoise()
cat:MakeNoise()
```

### Documentation

todo