HEIGHT = 600
WIDTH = 600
BACKGROUND = colorant"#f7f7f7"

board = fill(0,3,3)    # 3x3 matrix of the game_ongoing of each tile
game_ongoing = true    

circle = Actor("circle.png")
cross = Actor("cross.png")

function draw()
    fill(colorant"#f7f7f7")
    draw(Line(200, 0, 200, 600), colorant"black")
    draw(Line(400, 0, 400, 600), colorant"black")
    draw(Line(0, 200, 600, 200), colorant"black")
    draw(Line(0, 400, 600, 400), colorant"black")
    for i in 1:3
        for j in 1:3
            if board[i, j] == 1
                cross.center = (200j - 100, 200i - 100)
                draw(cross)
            elseif board[i, j] == -1
                circle.center = (200j - 100, 200i - 100)
                draw(circle)
            end
        end
    end
end

function on_mouse_down(g,pos)
    if game_ongoing
        x = pos[1]
        y = pos[2]
        if x < 200
            j = 1
        elseif x < 400
            j = 2
        else
            j = 3
        end

        if y < 200
            i = 1
        elseif y < 400
            i = 2
        else
            i = 3
        end

        if board[i, j] == 0
            board[i,j] = 1
            game_over()
            if game_ongoing
                random_ai()
                game_over()
            end
        else
            println("Invalid move")
            play_sound("eep.wav")
        end
    end
end

function update()

end

function game_over()
    if all(board.!=0)
        println("DRAW!")
        global game_ongoing = false
    end

    for i in 1:3
        if all(board[i,:].== 1) || all(board[:,i].== 1)
            println("PLAYER WINS!")
            global game_ongoing = false
        elseif all(board[i,:].== -1) || all(board[:,i].== -1)
            println("CPU WINS!")
            global game_ongoing = false
        end
    end
end

function random_ai()
    indices = findall(x -> x == 0, board)
    board[rand(indices)] = -1
end