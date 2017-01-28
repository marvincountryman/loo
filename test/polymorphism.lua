require "../class"

local Animal = class("Animal")

function Animal:Animal()
end 
function Animal:Rawr()
    print(self.__type.name .. " says rawr")
end
function Animal:__add(other)
    return 69
end
function Animal:__tostring()
    return "ARWARAWJRQILN"
end

local Dog = class("Dog", Animal)

function Dog:Rawr()
    base.Rawr(self)
end

local animal = Animal()
animal:Rawr()
local dog = Dog()
dog:Rawr()

print(tostring(dog))
print(tostring(Dog))