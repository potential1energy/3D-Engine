mat4_mt = {}
math.sind = function (x)
    return math.sin(math.rad(x))
end
math.cosd = function (x)
    return math.cos(math.rad(x))
end

function math.newM(m)
	m = m or {
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0
	}
	m._m = m
	return setmetatable(m, mat4_mt)
end

function math.from_perspective(fovy, aspect, near, far)
	assert(aspect ~= 0)
	assert(near   ~= far)

	local t   = math.tan(math.rad(fovy) / 2)
	local out = math.newM()
	out[1]    =  1 / (t * aspect)
	out[6]    =  1 / t
	out[11]   = -(far + near) / (far - near)
	out[12]   = -1
	out[15]   = -(2 * far * near) / (far - near)
	out[16]   =  0

	return out
end

function math.distance(x,y,z)
    return math.sqrt((x * x) + ((y * y) + (z * z)))
end