/* Diffrent misc types of tiles
 * Contains:
 *		Prototype
 *		Grass
 *		Wood
 *		Carpet
 * 		Blue Carpet
 *		Linoleum
 *
 * Put your stuff in fifty_stacks_tiles.dm as well.
 */

/obj/item/stack/tile
	name = "tile"
	singular_name = "tile"
	icon = 'icons/obj/tiles.dmi'
	desc = "A non-descript floor tile"
	w_class = ITEMSIZE_NORMAL
	max_amount = 60

/obj/item/stack/tile/New()
	..()
	pixel_x = rand(-7, 7)
	pixel_y = rand(-7, 7)

/*
 * Grass
 */
/obj/item/stack/tile/grass
	name = "grass tile"
	singular_name = "grass floor tile"
	desc = "A patch of grass like they often use on golf courses."
	icon_state = "tile_grass"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	origin_tech = list(TECH_BIO = 1)
	no_variants = FALSE
/*
 * Wood
 */
/obj/item/stack/tile/wood
	name = "wood floor tile"
	singular_name = "wood floor tile"
	desc = "An easy to fit wooden floor tile."
	icon_state = "tile-wood"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	no_variants = FALSE
	color = WOOD_COLOR_GENERIC

/obj/item/stack/tile/wood/woodcheck
	name = "wood checkered tile"
	icon_state = "tile-woodcheck"

/obj/item/stack/tile/wood/woodtile
	name = "tiled wood floor tile"
	icon_state = "tile-woodtiled"

/obj/item/stack/tile/wood/mahogany
	name = "mahogany floor tile"
	singular_name = "mahogany floor tile"
	desc = "An easy to fit mahogany wood floor tile."
	matter = list(MATERIAL_WOOD = 450)
	icon_state = "tile-wood"
	color = WOOD_COLOR_RICH

/obj/item/stack/tile/wood/maple
	name = "maple floor tile"
	singular_name = "maple floor tile"
	desc = "An easy to fit maple wood floor tile."
	matter = list(MATERIAL_WOOD = 450)
	icon_state = "tile-wood"
	color = WOOD_COLOR_PALE

/obj/item/stack/tile/wood/ebony
	name = "ebony floor tile"
	singular_name = "ebony floor tile"
	desc = "An easy to fit ebony floor tile."
	matter = list(MATERIAL_WOOD = 450)
	icon_state = "tile-wood"
	color = WOOD_COLOR_BLACK

/obj/item/stack/tile/wood/walnut
	name = "walnut floor tile"
	singular_name = "walnut floor tile"
	desc = "An easy to fit walnut wood floor tile."
	matter = list(MATERIAL_WOOD = 450)
	icon_state = "tile-wood"
	color = WOOD_COLOR_CHOCOLATE

/obj/item/stack/tile/wood/bamboo
	name = "bamboo floor tile"
	singular_name = "bamboo floor tile"
	desc = "An easy to fit bamboo wood floor tile."
	matter = list(MATERIAL_WOOD = 450)
	icon_state = "tile-wood"
	color = WOOD_COLOR_PALE2

/obj/item/stack/tile/wood/yew
	name = "yew floor tile"
	singular_name = "yew floor tile"
	desc = "An easy to fit yew wood floor tile."
	matter = list(MATERIAL_WOOD = 450)
	icon_state = "tile-wood"
	color = WOOD_COLOR_YELLOW

/obj/item/stack/tile/wood/sif
	name = "alien wood tile"
	singular_name = "alien wood tile"
	desc = "An easy to fit wooden floor tile. It's blue!"
	color = "#0099cc"

/obj/item/stack/tile/wood/cyborg
	name = "wood floor tile synthesizer"
	desc = "A device that makes wood floor tiles."
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/wood
	build_type = /obj/item/stack/tile/wood

/*
 * Carpets
 */
/obj/item/stack/tile/carpet
	name = "red carpet"
	singular_name = "carpet"
	desc = "A piece of carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-carpet"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	no_variants = FALSE

	stack_color = COLOR_RED

/obj/item/stack/tile/carpet/browcarpet
	name = "brown carpet"
	icon_state = "tile-carpet"
	stack_color = COLOR_BROWN

/obj/item/stack/tile/carpet/teal
	name = "teal carpet"
	no_variants = FALSE
	stack_color = COLOR_TEAL

// TODO - Add descriptions to these
/obj/item/stack/tile/carpet/bcarpet
	name = "blue carpet"
	icon_state = "tile-carpet"
	stack_color = COLOR_TEAL

/obj/item/stack/tile/carpet/blucarpet
	name = "blue and gold carpet"
	icon_state = "tile-carpet"
	stack_color = COLOR_BLUE

/obj/item/stack/tile/carpet/turcarpet
	icon_state = "tile-carpet"
	stack_color = COLOR_FOREST_GREEN
	name = "forest green carpet"

/obj/item/stack/tile/carpet/sblucarpet
	icon_state = "tile-carpet"
	stack_color = COLOR_CYAN
	name = "light blue carpet"

/obj/item/stack/tile/carpet/gaycarpet
	icon_state = "tile-carpet"
	stack_color = COLOR_PALE_RED_GRAY
	name = "pink carpet"

/obj/item/stack/tile/carpet/purcarpet
	icon_state = "tile-carpet"
	stack_color = COLOR_PURPLE
	name = "purple carpet"

/obj/item/stack/tile/carpet/oracarpet
	icon_state = "tile-carpet"
	stack_color = COLOR_ORANGE
	name = "orange carpet"

/obj/item/stack/tile/carpet/blackcarpet
	icon_state = "tile-carpet"
	stack_color = COLOR_GRAY
	name = "black carpet"

/obj/item/stack/tile/carpet/whitecarpet
	icon_state = "tile-carpet"
	stack_color = COLOR_WHITE
	name = "white carpet"


/obj/item/stack/tile/floor
	name = "floor tile"
	singular_name = "floor tile"
	desc = "A metal tile fit for covering a section of floor."
	icon_state = "tile"
	force = 6.0
	matter = list(DEFAULT_WALL_MATERIAL = SHEET_MATERIAL_AMOUNT / 4)
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	flags = CONDUCT
	no_variants = FALSE

/obj/item/stack/tile/floor/red
	name = "red floor tile"
	singular_name = "red floor tile"
	color = COLOR_RED_GRAY
	icon_state = "tile_white"
	no_variants = FALSE

/obj/item/stack/tile/floor/techgrey
	name = "grey techfloor tile"
	singular_name = "grey techfloor tile"
	icon_state = "techtile_grey"
	no_variants = FALSE

/obj/item/stack/tile/floor/techgrid
	name = "grid techfloor tile"
	singular_name = "grid techfloor tile"
	icon_state = "techtile_grid"
	no_variants = FALSE

/obj/item/stack/tile/floor/steel_dirty
	name = "steel floor tile"
	singular_name = "steel floor tile"
	icon_state = "tile_steel"
	matter = list("plasteel" = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/steel
	name = "steel floor tile"
	singular_name = "steel floor tile"
	icon_state = "tile_steel"
	matter = list("plasteel" = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/white
	name = "white floor tile"
	singular_name = "white floor tile"
	icon_state = "tile_white"
	matter = list("plastic" = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/yellow
	name = "yellow floor tile"
	singular_name = "yellow floor tile"
	color = COLOR_BROWN
	icon_state = "tile_white"
	no_variants = FALSE

/obj/item/stack/tile/floor/lime
	name = "lime floor tile"
	singular_name = "lime floor tile"
	color = COLOR_PALE_GREEN_GRAY
	icon_state = "tile_white"
	no_variants = FALSE

/obj/item/stack/tile/floor/paleblue
	name = "pale blue floor tile"
	singular_name = "pale blue floor tile"
	color = COLOR_PALE_BLUE_GRAY
	icon_state = "tile_white"
	no_variants = FALSE

/obj/item/stack/tile/floor/blue
	name = "blue floor tile"
	singular_name = "blue floor tile"
	color = COLOR_BLUE_GRAY
	icon_state = "tile_white"
	no_variants = FALSE

/obj/item/stack/tile/floor/dark
	name = "dark floor tile"
	singular_name = "dark floor tile"
	icon_state = "tile_steel"
	matter = list(DEFAULT_WALL_MATERIAL = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/pave_tilemoz
	name = "pavement tile"
	singular_name = "pavement tile"
	icon_state = "tile-pavemoz"
	matter = list(DEFAULT_WALL_MATERIAL = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/brickstairs
	name = "brickstairs tile"
	singular_name = "brickstairs tile"
	icon_state = "tile-brickstair"
	matter = list(DEFAULT_WALL_MATERIAL = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/dark_monotile
	name = "dark monotile floor tile"
	singular_name = "dark monotile floor tile"
	icon_state = "tile_steel"
	matter = list(DEFAULT_WALL_MATERIAL = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/monotile
	name = "monotile floor tile"
	singular_name = "monotile floor tile"
	icon_state = "tile_steel"
	matter = list(DEFAULT_WALL_MATERIAL = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/freezer
	name = "freezer floor tile"
	singular_name = "freezer floor tile"
	icon_state = "tile_freezer"
	matter = list("plastic" = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/cyborg
	name = "floor tile synthesizer"
	desc = "A device that makes floor tiles."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/floor
	build_type = /obj/item/stack/tile/floor

/obj/item/stack/tile/linoleum
	name = "linoleum"
	singular_name = "linoleum"
	desc = "A piece of linoleum. It is the same size as a normal floor tile!"
	icon_state = "tile-linoleum"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	no_variants = FALSE

/obj/item/stack/tile/roofing
	name = "roofing"
	singular_name = "roofing"
	desc = "A section of roofing material. You can use it to repair the ceiling, or expand it."
	icon_state = "techtile_grid"

/obj/item/stack/tile/road
	name = "road tile"
	singular_name = "road tile"
	desc = "A section of road. You can use it to repair or expand roads."
	icon_state = "tile-road"
	origin_tech = list(TECH_BIO = 1)
	no_variants = FALSE

/obj/item/stack/tile/pavement
	name = "pavement tile"
	singular_name = "pavement tile"
	desc = "A section of pavement. It is the same size as a normal floor tile!"
	icon_state = "tile-pavement"
	origin_tech = list(TECH_BIO = 1)
	no_variants = FALSE

/obj/item/stack/tile/pavement/stairs
	name = "pavement tile"
	singular_name = "pavement tile"
	desc = "A section of pavement. It is the same size as a normal floor tile!"
	icon_state = "tile-pavement"
	origin_tech = list(TECH_BIO = 1)
	no_variants = FALSE

/obj/item/stack/tile/brick_paving
	name = "brick pavement tile"
	singular_name = "brickpavement tile"
	desc = "A section of brick pavement. It is the same size as a normal floor tile!"
	icon_state = "tile-brickpavement"
	no_variants = FALSE


/obj/item/stack/tile/pave_tiling
	name = "street pavement tile"
	singular_name = "street pavement tile"
	desc = "A section of pavement tiling. It is the same size as a normal floor tile!"
	icon_state = "tile-pavetiling"
	no_variants = FALSE

/obj/item/stack/tile/diamond
	name = "black diamond design tile"
	singular_name = "black diamond design tile"
	desc = "A diamond shaped design is on this tile. It is the same size as a normal floor tile!"
	icon_state = "tile-diamond"
	origin_tech = list(TECH_BIO = 1)
	no_variants = FALSE