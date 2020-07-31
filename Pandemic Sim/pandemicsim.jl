HEIGHT = 600
WIDTH = 600
BACKGROUND = colorant"black"
num_humans = 40
chance_to_die = 0.25
movement_rate = 3

mutable struct Human       # Create new type to store each human and its attributes
    c::Circle              # Circle – part that is rendered on-screen, stores position
    state::Int             # State – 0 - normal, 1 - infected, 2 - recovered, 3 - dead
    timetocure::Int        # Timetocure – goes down if infected, recover when cure
end

humans = Human[]    # Array to store the population

for human_num in 1:num_humans   # Create population
    push!(humans, Human(
                Circle(rand(20:WIDTH - 20),rand(20:HEIGHT - 20), 5),    # Random position on-screen
                0,  # Start as normal
                2000    # 2000 frames to recover (or die)
                )
            )
end

humans[rand(1:num_humans)].state = 1    # Patient 0

function update()
    for i in 1:num_humans
        for j in 1:i
            if collide(humans[i].c, humans[j].c)    # Potential infection
                if humans[i].state == 1 && humans[j].state == 0     # One object in the circle must be infected, and the other must be normal
                    humans[j].state = 1 # Set the normal one to infected
                elseif humans[j].state == 1 && humans[i].state == 0
                    humans[i].state = 1 # Set the normal one to infected
                end
            end
        end
        if humans[i].state != 3     # Only move if not dead
            humans[i].c.x += rand(-movement_rate:3:movement_rate)
            humans[i].c.y += rand(-movement_rate:3:movement_rate)
        end
        if humans[i].state == 1    # Only reduce timetocure if infected
            humans[i].timetocure += -1
        end
        if humans[i].timetocure < 0 && humans[i].state == 1     # Recover or die
            if rand() > chance_to_die
                humans[i].state = 2     # Recover
            else
                humans[i].state = 3     # Die
            end
        end
        if humans[i].c.left <= 0 || humans[i].c.right >= WIDTH ||
                humans[i].c.top <= 0 || humans[i].c.bottom >= HEIGHT  # THEY MUST NOT LEAVE
            humans[i].c.x = rand(20:WIDTH - 20)     # Teleport to random x
            humans[i].c.y = rand(20:HEIGHT - 20)    # Teleport to random y
        end
    end
end

function draw()
    clear()
    for human in humans
        if human.state == 3
            draw(human.c, colorant"grey", fill=false)   # Dead – Grey ring
        elseif human.state == 2
            draw(human.c, colorant"green", fill=true)   # Recovered – Green circle
        elseif human.state == 1
            draw(human.c, colorant"red", fill=true)     # Infected – Red circle
        else
            draw(human.c, colorant"white", fill=true)   # Normal – White circle
        end
    end
end
