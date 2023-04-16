hs.loadSpoon("EmmyLua")

local test = {}

table.insert(test, 1)
table.insert(test, 2)
table.insert(test, 3)
table.insert(test, 4)
table.insert(test, 5)

print("before")
for k, v in pairs(test) do
  print(k, v)
end

local item = table.remove(test, 3)
table.insert(test, 2, item)

print("after")
for k, v in pairs(test) do
  print(k, v)
end

local item = table.remove(test, 2)
table.insert(test, 3, item)

print("undone")
for k, v in pairs(test) do
  print(k, v)
end

-- Wm = require("wm")
-- Wm:start()
