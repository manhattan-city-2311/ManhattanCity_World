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
	return vector2(0, 0)

/proc/vector2_from_angle(degrees)
	return vector2_from_dir(angle2dir(degrees))
	//return vector2(cos(degrees), sin(degrees))

/vector2/proc/operator-(vector2/b)
	return vector2(x - b.x, y - b.y)

/vector2/proc/operator+(vector2/b)
	return vector2(x + b.x, y + b.y)

/vector2/proc/operator*(vector2/other)
	if(istype(other, /vector2))
		return vector2(x * other.x, y * other.y)
	else
		return vector2(x * other, y * other)

/vector2/proc/operator/(vector2/other)
	if(istype(other, /vector2))
		return vector2(x / other.x, y / other.y)
	else
		return vector2(x / other, y / other)

/vector2/proc/operator*=(vector2/b)
	x *= b.x
	y *= b.y

/vector2/proc/operator+=(vector2/b)
	x += b.x
	y += b.y

/vector2/proc/operator-=(vector2/b)
	x -= b.x
	y -= b.y

/vector2/proc/rotate(degrees)
	var/x1 = x 
	var/y1 = y
	x = x1 * cos(degrees) + y1 * sin(degrees)
	y = x1 * sin(degrees) + y1 * cos(degrees)

/vector2/proc/modulus()
	return sqrt(x ** 2 + y ** 2)

/vector2/proc/round_components(res = 0.1)
	x = round(x, res)
	y = round(y, res)

#define VECTOR_DEBUG(vec) to_world(#vec + " = \[[vec.x], [vec.y]\]")