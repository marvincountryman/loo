--[[
                    The MIT License (MIT)

    Copyright (c) 2017 Marvin Countryman <marvincountryman@gmail.com>

    Permission is hereby granted, free of charge, to any person 
    obtaining a copy of this software and associated documentation 
    files (the "Software"), to deal in the Software without 
    restriction, including without limitation the rights to use, 
    copy, modify, merge, publish, distribute, sublicense, and/or 
    sell copies of the Software, and to permit persons to whom the 
    Software is furnished to do so, subject to the following 
    conditions:

    The above copyright notice and this permission notice shall be 
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
    OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
    HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
    OTHER DEALINGS IN THE SOFTWARE.
]]
local metamethods = {
    -- Logic
    "__eq", "__lt", "__le",

    -- Arithmatic
    "__add", "__sub", "__mul", 
    "__div", "__unm", "__mod",
    "__pow", "__concat",

    -- Special
    "__call", "__tostring", "__len",
    "__gc"
}

local function newInstance(klass, ...)
    local instance    = klass.__type.instance
    local instanceMt = klass.__type.instanceMt

    local base = klass.__type.base 
    local obj

    -- Populate base instance tree
    while base ~= nil do
        base.__type.baseInstance = 
            setmetatable(base.__type.instance,
                         base.__type.instanceMt)
        base = base.__type.base
    end

    obj = setmetatable(instance, instanceMt)

    if type(obj[klass.__type.name]) == "function" then
        obj[klass.__type.name](obj, ...)
    end

    return obj
end

function class(name, base)
    local klass       = {}
    local klassMt    = {}
    local instance    = {}
    local instanceMt = {}

    local static = {}
    
    -- Type object
    klass.__type = {
        name = name,
        base = base,
        class = nil,

        static = static,

        instance    = instance,
        instanceMt = instanceMt
    }
    
    klass.static = static

    function instance:isInstanceOf(obj)
        if isClass(obj) then
            if obj.__type.class == self.__type.class then
                return true
            end
        end

        return false
    end
    function instanceMt:__index(k)
        local v = rawget(self, k)
        
        if v == nil and self.__type.baseInstance ~= nil then
            v = self.__type.baseInstance[k]
        end

        return v
    end

    for _, metamethod in pairs(metamethods) do
        instanceMt[metamethod] = function(self, ...)
            local fn = self[metamethod]

            if type(fn) == "function" then
                return fn(self, ...)
            end

            return error("attempt to perform '"..metamethod.."' on '"..self.__type.name.."'")
        end
    end

    function klassMt:__call(...)
        return newInstance(self, ...)
    end
    function klassMt:__index(k)
        return static[k]
    end
    function klassMt:__newindex(k, v)
        if k == "__index"    then return end
        if k == "__newindex" then return end

        if base ~= nil and type(v) == "function" then
            if _ENV ~= nil then
                local ov = v
                v = function(...)
                    local ret
                    local base = _ENV["base"]
                    
                    _ENV["base"] = self.__type.base.__type.instance
                    ret = ov(...)
                    _ENV["base"] = base

                    return ret
                end
            end
        end

        instance[k] = v
    end
    function klassMt:__tostring()
        return "class: " .. self.__type.name
    end

    klass = setmetatable(klass, klassMt)
    klass.__type.class = klass
    klass.__type.instance.__type = {
        name = name,
        base = base,
        class = klass,

        instance    = instance,
        instanceMt = instanceMt
    }

    return klass
end

function isClass(obj)
    if type(obj) == "table" then
        if type(obj.__type) == "table" then
            if type(obj.__type.class) == "table" then
                return true
            end
        end
    end

    return false
end
function isInstance(obj)
    return isClass(obj)
end