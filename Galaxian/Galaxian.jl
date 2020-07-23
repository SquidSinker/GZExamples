WIDTH = 300
HEIGHT = 600
BACKGROUND = colorant"black"

DIVE_WOBBLE_SPEED = 2

DIVE_WOBBLE_AMOUNT = 100

function dive_path(t)
    if t < 0.5
        return (50 * (1 - cos(2 * t * π)), -50 * (sin(2 * t* π)))
    end

    t += -0.5
    return (DIVE_WOBBLE_AMOUNT * cos(t * DIVE_WOBBLE_SPEED), t * 350)
end

function make_individual_dive(start_pos, flip_x=false)
    dir = flip_x ? -1 : 1
    sx, sy = start_pos

    function _dive_path(t)
        x, y = dive_path(t)
        return sx + x * dir, sy + y
    end

    return _dive_path
end

function ship_controller_pan(ship, dt)
    ship.x += ship.vx * dt
    if ship.right > WIDTH - 50
        ship.vx = -ship.vx
        ship.right = WIDTH - 50
    elseif ship.left < 50
        ship.vx = -ship.vx
        ship.left = 50
    end
end

function ship_controller_dive(ship, dt)
    ship.t += dt
    ship.pos = ship.dive_path(ship.t)

    ship.angle = angle(ship, ship.dive_path(ship.t + EPSILON))

    if ship.top > HEIGHT
        ship.controller_function = ship_controller_pan
        ship.pos = ship.dive_path(0)
        ship.angle = 90
        schedule_once(start_dive, 3)
    end
end

EPSILON = 0.001

ship = Actor("ship"; pos=(100, 100), angle=90)
ship.angle = 90  # Face upwards
ship.controller_function = ship_controller_pan
ship.vx = 100

function draw(g::Game)
    clear()
    draw(ship)
end

function update(g::Game, dt)
    ship.controller_function(ship, dt)
end

function start_dive()
    flip_x = ship.x < (WIDTH ÷ 2)
    ship.controller_function = ship_controller_dive
    ship.dive_path = make_individual_dive(ship.pos, flip_x)
    ship.t = 0
end

schedule_once(start_dive, 3)
