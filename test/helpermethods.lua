require "../class"

local A = class "A"
local AA = class("AA", A)

local a = A()
local aa = AA()

assert(isClass(A), 
    "isClass(A:class) returned false expected true",
    "isClass(A:class) returned true")
assert(isInstance(a),
    "isInstance(a:class: A) returned false expected true",
    "isInstance(a:class: A) returned true")
assert(a:isInstanceOf(A),
    "a:isInstanceOf(A) returned false expected true",
    "a:isInstanceOf(A) returned true")
assert(not a:isInstanceOf(AA),
    "a:isInstanceOf(AA) returned true expected false",
    "a:isInstanceOf(AA) returned false")

print "Test successful"