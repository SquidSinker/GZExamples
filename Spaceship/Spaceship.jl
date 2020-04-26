WIDTH = 900
HEIGHT = 600

space_pod = Actor("Space_pod.png")
space_pod.pos = 5, 300

pod_laser = Actor("laser.png")
pod_laser.x = 75
shot_charged = false
shoot_frame = 0
pod_laser_visible = false

enemy_1 = Actor("enemy.png")
enemy_1.pos = 800, 300
enemy_1_health = 5
enemy_1_alive = true

function shoot_animation()
    global shoot_frame
    if shoot_frame < 16
        space_pod.image = "space_pod_shoot" * string(shoot_frame) * ".png"
        shoot_frame += 1
        schedule_once(shoot_animation, 1/16)
    else
        space_pod.image = "space_pod.png"
    end
end

function on_key_down(g::Game, key)
    global shoot_frame, shot_charged, pod_laser_visible
    if shot_charged == false
        if key == Keys.SPACE
            shoot_frame = 0
            shoot_animation()
            shot_charged = true
        end
    else
        if key == Keys.SPACE
            pod_laser_visible = true
            shot_charged = false
            pod_laser.y = round(Int, space_pod.y + (space_pod.h)/2)
        end
    end
end


function update(g::Game)
    global pod_laser_visible, enemy_1_health, enemy_1_alive
    #space_pod move
    if g.keyboard.DOWN
        space_pod.y += 2
    elseif g.keyboard.UP
        space_pod.y += -2
    end
    if pod_laser_visible == true
        pod_laser.x += 3
        if pod_laser.x > 800
            pod_laser_visible = false
            pod_laser.x = 150
        end
    end
    if collide(enemy_1, pod_laser) == true
        enemy_1_health += -5
        if enemy_1_health == 0
            enemy_1_alive = false
        end
    end
end

function draw(g::Game)
    if enemy_1_alive == true
        draw(enemy_1)
    end
    if pod_laser_visible == true
        draw(pod_laser)
    end
    draw(space_pod)
end
