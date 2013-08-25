--==============================================================================
-- Conky NXG -- heavily modified lunatico_rungs.lua
-- Date  : 07/06/2013
-- Author: twitter.com/textbox37
-- License: GPL v2 or later
--==============================================================================
--lunatico_rings.lua
--
--Date: 22/06/2011
--Author: DCM
--Version : v0.2
--License : Distributed under the terms of GNU GPL version 2 or later
--This version is a modification of conky_orange.lua found at
--http://gnome-look.org/content/show.php?content=137503&forumpage=0
--
--==============================================================================

require 'cairo'

textfields = {
{
	x=26, y=55,
	value='CPU0'
},
{
	x=106, y=55,
	value='CPU1'
},
{
	x=188, y=55,
	value='RAM'
},
{
	x=265, y=55,
	value='SWAP'
},
{
	x=350, y=55,
	value='WIFI'
},
{
	x=430, y=55,
	value='LAN'
},
{
	x=508, y=55,
	value='DISK'
},
}

--------------------------------------------------------------------------------
--gauge DATA
gauge = {
{
	name='cpu',arg='cpu1',
	max_value=100,
	x=40,y=50,
	graph_radius=20,
	graph_thickness=2,
	graph_start_angle=75,
	graph_unit_angle=1, graph_unit_thickness=1,
	graph_bg_colour=0xffffff,graph_bg_alpha=0.1,
	graph_fg_colour=0xFFFFFF,graph_fg_alpha=0.0,
},
{
	name='cpu',arg='cpu2',
	max_value=100,
	x=120, y=50,
	graph_radius=20,
	graph_thickness=2,
	graph_start_angle=75,
	graph_unit_angle=2.7, graph_unit_thickness=2.7,
	graph_bg_colour=0xffffff,graph_bg_alpha=0.1,
	graph_fg_colour=0xFFFFFF,graph_fg_alpha=0.0,
},
{
	name='memperc',
	arg='',
	max_value=100,
	x=200, y=50,
	graph_radius=20,
	graph_thickness=2,
	graph_start_angle=75,
	graph_unit_angle=2.7, graph_unit_thickness=2.7,
	graph_bg_colour=0xffffff,graph_bg_alpha=0.1,
	graph_fg_colour=0xFFFFFF,graph_fg_alpha=0.0,
},
{
	name='swapperc',
	arg='',
	max_value=100,
	x=280, y=50,
	graph_radius=20,
	graph_thickness=2,
	graph_start_angle=75,
	graph_unit_angle=2.7, graph_unit_thickness=2.7,
	graph_bg_colour=0xffffff,graph_bg_alpha=0.1,
	graph_fg_colour=0xFFFFFF,graph_fg_alpha=0.0,
},
{
	name='downspeedf',
	arg='wlan0',
	max_value=100,
	x=360, y=50,
	graph_radius=20,
	graph_thickness=2,
	graph_start_angle=75,
	graph_unit_angle=2.7, graph_unit_thickness=2.7,
	graph_bg_colour=0xffffff,graph_bg_alpha=0.1,
	graph_fg_colour=0xFFFFFF,graph_fg_alpha=0.0,
},
{
	name='upspeedf',
	arg='wlan0',
	max_value=100,
	x=360, y=50,
	graph_radius=17,
	graph_thickness=2,
	graph_start_angle=75,
	graph_unit_angle=2.7, graph_unit_thickness=2.7,
	graph_bg_colour=0xffffff,graph_bg_alpha=0.1,
	graph_fg_colour=0xFFFFFF,graph_fg_alpha=0.0,
},
{
	name='downspeedf',
	arg='p3p1',
	max_value=100,
	x=440, y=50,
	graph_radius=20,
	graph_thickness=2,
	graph_start_angle=75,
	graph_unit_angle=2.7, graph_unit_thickness=2.7,
	graph_bg_colour=0xffffff,graph_bg_alpha=0.1,
	graph_fg_colour=0xFFFFFF,graph_fg_alpha=0.0,
},
{
	name='upspeedf',
	arg='p3p1',
	max_value=100,
	x=440, y=50,
	graph_radius=17,
	graph_thickness=2,
	graph_start_angle=75,
	graph_unit_angle=2.7, graph_unit_thickness=2.7,
	graph_bg_colour=0xffffff,graph_bg_alpha=0.1,
	graph_fg_colour=0xFFFFFF,graph_fg_alpha=0.0,
},
{
	name='fs_used_perc',
	arg='/',
	max_value=100,
	x=520, y=50,
	graph_radius=20,
	graph_thickness=2,
	graph_start_angle=75,
	graph_unit_angle=2.7, graph_unit_thickness=2.7,
	graph_bg_colour=0xffffff,graph_bg_alpha=0.1,
	graph_fg_colour=0xFFFFFF,graph_fg_alpha=0.0,
}
}

-------------------------------------------------------------------------------
-- rgb_to_r_g_b
-- converts color in hexa to decimal

function rgb_to_r_g_b(colour, alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

-------------------------------------------------------------------------------
--angle_to_position
-- convert degree to rad and rotate (0 degree is top/north)

function angle_to_position(start_angle, current_angle)
	local pos = current_angle + start_angle
	return ( ( pos * (2 * math.pi / 360) ) - (math.pi / 2) )
end


-------------------------------------------------------------------------------
--draw_gauge_ring
-- displays gauges

function draw_gauge_ring(display, data, value)
	local max_value = data['max_value']
	local x, y = data['x'], data['y']
	local graph_radius = data['graph_radius']
	local graph_thickness, graph_unit_thickness = data['graph_thickness'], data['graph_unit_thickness']
	local graph_start_angle = data['graph_start_angle']
	local graph_unit_angle = data['graph_unit_angle']
	local graph_bg_colour, graph_bg_alpha = data['graph_bg_colour'], data['graph_bg_alpha']
	local graph_fg_colour, graph_fg_alpha = data['graph_fg_colour'], data['graph_fg_alpha']
	local graph_end_angle = max_value*300/100
	local graph_value = (value/max_value)*300

	if value > max_value then
		value = max_value
		graph_value = 300
	end

	-- background ring
	cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, 0), angle_to_position(graph_start_angle, graph_end_angle))
	cairo_set_source_rgba(display, rgb_to_r_g_b(graph_bg_colour, graph_bg_alpha))
	cairo_set_line_width(display, graph_thickness)
	cairo_stroke(display)
	
	-- foreground ring
	cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, 0), angle_to_position(graph_start_angle, graph_value))
	cairo_set_source_rgba(display, 255, 255, 255, 0.8)
	cairo_set_line_width(display, graph_thickness)
	cairo_stroke(display)
end

function draw_text(display, data)
	local x, y = data['x'], data['y']
	local text = conky_parse(data['value'])
	cairo_select_font_face(display, "Open Sans", CAIRO_FONT_SLANT_NORMAL, 0.9)
	cairo_set_font_size(display, 11)
	cairo_set_source_rgba(display, 255,255,255,0.8)
	cairo_move_to(display, x, y)
	cairo_show_text(display, text)
	cairo_stroke(display)
end

-------------------------------------------------------------------------------
-- go_gauge_rings
-- loads data and displays gauges
--
function go_gauge_rings(display)
	local function load_gauge_rings(display, data)
		local str, value = '', 0
		str = string.format('${%s %s}',data['name'], data['arg'])
		str = conky_parse(str)
		value = tonumber(str)
		draw_gauge_ring(display, data, value)
	end

	for i in pairs(gauge) do
		load_gauge_rings(display, gauge[i])
	end
end

function go_text_fields(display)
	for i in pairs(textfields) do
		draw_text(display, textfields[i])
	end
end

-------------------------------------------------------------------------------
-- MAIN
function conky_main()
	if conky_window == nil then 
		return
	end
	local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
	local display = cairo_create(cs)
	local updates = conky_parse('${updates}')
	update_num = tonumber(updates)
	if update_num > 5 then
		go_gauge_rings(display)
		go_text_fields(display)
	end
	cairo_surface_destroy(cs)
	cairo_destroy(display)
end

