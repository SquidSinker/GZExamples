WIDTH = 600
HEIGHT = 600
BACKGROUND = colorant"#636363"

game_ongoing = true

score = 0

wall_width_size = 50
#borders
top_border = Rect(0, 0, HEIGHT, wall_width_size)
bottom_border = Rect(0, HEIGHT - wall_width_size, HEIGHT, wall_width_size)
left_border = Rect(0, 0, wall_width_size, HEIGHT)
right_border = Rect(WIDTH - wall_width_size, 0, wall_width_size, HEIGHT)
borders = [top_border, bottom_border, left_border, right_border]

#walls
wall1 = Rect(
    WIDTH / 2 - wall_width_size, 
    wall_width_size, 
    wall_width_size, 
    HEIGHT / 3
)
wall2 = Rect(
    wall_width_size * 2, 
    HEIGHT / 3 - wall_width_size, 
    WIDTH / 1.5, 
    wall_width_size
)
wall3 = Rect(
    WIDTH / 2 - wall_width_size,
    HEIGHT / 1.5 - wall_width_size,
    wall_width_size,
    wall_width_size
)
wall4 = Rect(
    wall_width_size * 2,
    HEIGHT / 2 - wall_width_size,
    wall_width_size,
    160
)
wall5 = Rect(
    WIDTH / 1.5 - wall_width_size,
    HEIGHT / 1.5 - wall_width_size,
    wall_width_size * 5,
    wall_width_size
)
walls = [wall1, wall2, wall3, wall4, wall5]

#starts
start1 = Rect(
    wall_width_size, 
    0, 
    wall_width_size, 
    wall_width_size
)

#exits
exit1 = Rect(
    WIDTH - wall_width_size * 2,
    HEIGHT - wall_width_size,
    wall_width_size,
    wall_width_size
)

player_size = 50
player = Rect(start1.x, start1.y, player_size, player_size)

#grid lines
hline = Line(0, 300, 600, 300)
vline = Line(300, 0, 300, 600)

function draw(g::Game)
    #borders
    for b in borders
        draw(b, colorant"blue", fill = true)
    end

    #walls
    for w in walls 
        draw(w, colorant"blue", fill = true)
    end

    #starts
    draw(start1, colorant"#636363", fill = true)

    #exits
    draw(exit1, colorant"#636363", fill = true)

    #player
    draw(player, colorant"red", fill = true)

    #grid
    draw(hline, colorant"black")
    draw(vline, colorant"black")

    if game_ongoing == true
        display = "Make it to the exit!"
    else
        display = "You Win"
        #play again instructions
        replay = TextActor("Click to play again", "comicbd", font_size = 43, color = Int[255, 0, 0, 0])
        replay.pos = (WIDTH / 2 - replay.w / 2, HEIGHT / 2 - replay.h / 2)
        draw(replay)
    end

    txt = TextActor(display, "comicbd", font_size = 36, color = Int[255, 255, 255, 255])
    txt.pos = (0, HEIGHT - txt.h)
    draw(txt)
end

function on_key_down(g::Game)
    coll_rect = Rect(player.x, player.y, player.w, player.h)

    speed = 50

    if game_ongoing == true
        if g.keyboard.W
            coll_rect.y -= speed
            if !check_for_collision(coll_rect)
                player.y -= speed
            end
        elseif g.keyboard.A
            coll_rect.x -= speed
            if !check_for_collision(coll_rect)
                player.x -= speed
            end
        elseif g.keyboard.S
            coll_rect.y += speed
            if !check_for_collision(coll_rect)
                player.y += speed
            end
        elseif g.keyboard.D
            coll_rect.x += speed
            if !check_for_collision(coll_rect)
                player.x += speed
            end
        end
    end
end

function on_mouse_down(g::Game)
    if game_ongoing == false
        reset()
    end
end

function check_for_collision(rect)
    for w in walls 
        if rect.x == start1.x && rect.y == start1.y 
            return false
        elseif rect.x == exit1.x && rect.y == exit1.y
            global game_ongoing = false
            return false
        elseif collide(rect, w)
            return true
        end
    end

    for b in borders
        if rect.x == start1.x && rect.y == start1.y 
            return false
        elseif rect.x == exit1.x && rect.y == exit1.y
            global game_ongoing = false
            return false
        elseif collide(rect, b)
            return true
        end
    end

    return false
end

function reset()
    global game_ongoing = true

    player.x, player.y = start1.x, start1.y
end