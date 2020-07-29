HEIGHT = 600
WIDTH = 600
BACKGROUND = colorant"black"
num_humans = 40

mutable struct Human
    c::Circle
    state::Int
    timetocure::Int
end

humans = Human[]

for human_num in 1:num_humans
    push!(humans, Human(
                Circle(rand(20:WIDTH - 20),rand(20:HEIGHT - 20), 5),
                0,
                2000
                )
            )
end

humans[rand(1:num_humans)].state = 1

function update()
    for i in 1:num_humans
        for j in 1:i
            if collide(humans[i].c, humans[j].c)
                if humans[i].state == 1 && humans[j].state == 0
                    humans[j].state = 1
                elseif humans[j].state == 1 && humans[i].state == 0
                    humans[i].state = 1
                end
            end
        end
        humans[i].c.x += rand(-3:3:3)
        humans[i].c.y += rand(-3:3:3)
        if humans[i].state == 1
            humans[i].timetocure += -1
        end
        if humans[i].timetocure < 0
            humans[i].state = 2
        end
    end
end

function draw()
    clear()
    for human in humans
        if human.state == 2
            draw(human.c, colorant"green", fill=true)
        elseif human.state == 1
            draw(human.c, colorant"red", fill=true)
        else
            draw(human.c, colorant"white", fill=true)
        end
    end
end
