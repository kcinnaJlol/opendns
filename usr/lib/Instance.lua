Instance = {}
function Instance:new()
if not self then
return Instance:new()
elseif type(self) == "table" then
obj = {}
setmetatable(obj, {__index=self})
end
end
setmetatable(Instance, {__index=Instance})
return Instance