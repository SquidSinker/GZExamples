using Colors

WIDTH = 600
HEIGHT = 600
BACKGROUND=colorant"black"
BALL_SIZE = 10
MARGIN = 50
BRICKS_X = 10
BRICKS_Y = 5
BRICK_W = (WIDTH - 2 * MARGIN) ÷ BRICKS_X
BRICK_H = 25

ball = Circle(WIDTH / 2, HEIGHT / 2, BALL_SIZE/2)
ball_vel = (0,0)
bat = Rect(WIDTH / 2, HEIGHT - 50, 120, 12)

bricks = []

struct Brick
    brick::Rect
    brick_color
    highlight_color
end

function reset()
    deleteat!(bricks, 1:length(bricks))
    for x in 1:BRICKS_X
        for y in 1:BRICKS_Y
            hue = (x + y - 2) / BRICKS_X
            saturation = ( (y-1) / BRICKS_Y) * 0.5 + 0.5
            brick_color = HSV(hue*360, saturation, 0.8)
            highlight_color = HSV(hue*360, saturation * 0.7, 1.0)
            brick = Brick( Rect(
                ((x-1) * BRICK_W + MARGIN, (y-1) * BRICK_H + MARGIN),
                (BRICK_W - 1, BRICK_H - 1)
            ), brick_color, highlight_color )
            push!(bricks, brick)
        end
    end

    ball.center = (WIDTH / 2, HEIGHT / 3)  #should be centre
    global ball_vel = (rand(-200:200), 400)
end

reset()

function draw(g::Game)
    clear()
    for b in bricks
        draw(b.brick, b.brick_color, fill=true)
        draw(Line(b.brick.bottomleft, b.brick.topleft), b.highlight_color)
        draw(Line(b.brick.topleft, b.brick.topright), b.highlight_color)
    end
    draw(bat, colorant"pink", fill=true)
    draw(ball, colorant"white", fill=true)
end

function update(g::Game)
    # When you have fast moving objects, like the ball, a good trick
    # is to run the update step several times per frame with tiny time steps.
    # This makes it more likely that collisions will be handled correctly.
    for _ in 1:3
        update_step(1 / 180)
    end
    update_bat_vx()
end

function update_step(dt)
    x, y = ball.center  #should be centre
    global ball_vel
    vx, vy = ball_vel
    if ball.top > HEIGHT
        reset()
        return
    end
    x += vx * dt
    y += vy * dt
    ball.center = (x, y)  #should be centre
    if ball.left < 0
        vx = -vx
        ball.left = -ball.left
    elseif ball.right > WIDTH
        vx = -vx
        ball.right += -(2 * (ball.right - WIDTH))
    end

    if ball.top < 0
        vy = -vy
        ball.top = ball.top * -1
    end
    if collide(ball, bat)
        vy = -abs(vy)
        vx += -30 * bat_vx
    else
        collisions = [collide(ball, b.brick) for b in bricks]
        idx = findfirst(x->x==true, collisions)
        if idx ≠ nothing
            b = bricks[idx]
            dx = (ball.centerx - b.brick.centerx) / BRICK_W
            dy = (ball.centery - b.brick.centery) / BRICK_H
            if abs(dx) > abs(dy)
                vx = copysign(abs(vx), dx)
            else
                vy = copysign(abs(vy), dy)
            end
            deleteat!(bricks, idx)
        end
    end
    ball_vel = (vx, vy)
end

bat_recent_vxs = []
bat_vx = 0
bat_prev_centerx = bat.centerx

function update_bat_vx()
    global bat_prev_centerx
    x = bat.centerx
    dx = x - bat_prev_centerx
    bat_prev_centerx = x
    history = bat_recent_vxs
    if length(history) >= 5
        pop!(history)
    end
    push!(history, dx)
    vx = sum(history) / length(history)
    global bat_vx = min(10, max(-10, vx))
end

function on_mouse_move(g::Game, pos)
    x, y = pos
    bat.centerx = x
    if bat.left < 0
        bat.left = 0
    elseif bat.right > WIDTH
        bat.right = WIDTH
    end
end
