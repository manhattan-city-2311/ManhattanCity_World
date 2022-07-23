/vector2
	var/x = 0
	var/y = 0

/vector2/New(nx, ny)
	x = nx
	y = ny

/proc/vector2(x, y)
	return new /vector2(x, y)

/proc/vector2_from_dir(dir)
	switch(dir)
		if(NORTH)
			return vector2(0, 1)
		if(SOUTH)
			return vector2(0, -1)
		if(EAST)
			return vector2(1, 0)
		if(WEST)
			return vector2(-1, 0)
		if(NORTHEAST)
			return vector2(0.5, 0.5)
		if(NORTHWEST)
			return vector2(-0.5, 0.5)
		if(SOUTHEAST)
			return vector2(0.5, -0.5)
		if(SOUTHWEST)
			return vector2(-0.5, -0.5)
	return null

/proc/vector2_from_angle(degrees)
	return vector2_from_dir(angle2dir(degrees))

/vector2/proc/operator-(vector2/b)
	return vector2(x - b.x, y - b.y)

/vector2/proc/operator+(vector2/b)
	return vector2(x + b.x, y + b.y)

/vector2/proc/operator*(vector2/other)
	if(istype(other, /vector2))
		var/vector2/b = other
		return vector2(x * b.x, y * b.y)
	else
		return vector2(x * other, y * other)

/vector2/proc/operator*=(vector2/b)
	x *= b.x
	y *= b.y

/vector2/proc/operator+=(vector2/b)
	x += b.x
	y += b.y

/vector2/proc/operator-=(vector2/b)
	x -= b.x
	y -= b.y

/vector2/proc/modulus()
	return sqrt(x ** 2 + y ** 2)

