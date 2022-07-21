/vector2
	var/x = 0
	var/y = 0

/vector2/New(nx, ny)
	x = nx
	y = ny

/vector2/operator-()
	x = -x
	y = -y


/proc/vector2(x, y)
	return new /vector2(x, y)

/proc/vector2_from_angle(degrees)
	return vector2(cos(TORADIANS(degrees)), sin(TORADIANS(degrees)))

/vector2/operator-(b)
	return vector2(x - b.x, y - b.y)

/vector2/operator+(b)
	return vector2(x + b.x, y + b.y)

/vector2/operator*(b)
	return vector2(x * b.x, y * b.y)

/vector2/operator*=(b)
	x *= b.x
	y *= b.y

/vector2/operator+=(b)
	x += b.x
	y += b.y

/vector2/operator-=(b)
	x -= b.x
	y -= b.y

/vector2/proc/modulus()
	return sqrt(x ** 2 + y ** 2)

