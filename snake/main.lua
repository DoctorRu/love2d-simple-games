--
-- Created by IntelliJ IDEA.
-- User: doctorru
-- Date: 28/05/17
-- Time: 15:45
--

function love.load()
    cellSize = 18
    gridXCount = 18
    gridYCount = 18

    function reset()
        timer = 0
        directionQueue = { 'right' }
        snakeSegments = {
            { x = 3, y = 1 },
            { x = 2, y = 1 },
            { x = 1, y = 1 }
        }
        snakeAlive = true
    end

    reset()

    function moveFood()
        local possibleFoodPositions = {}

        for foodX = 1, gridXCount do
            for foodY = 1, gridYCount do
                local possible = true

                for segmentIndex, segment in ipairs(snakeSegments) do
                    if foodX == segment.x and foodY == segment.y then
                        possible = false
                    end
                end

                if possible then
                    table.insert(possibleFoodPositions, { x = foodX, y = foodY })
                end
            end
        end
        foodPosition = possibleFoodPositions[love.math.random(#possibleFoodPositions)]
    end

    moveFood()
end


function love.keypressed(key)
    if key == 'right'
            and directionQueue[#directionQueue] ~= 'right'
            and directionQueue[#directionQueue] ~= 'left' then
        table.insert(directionQueue, 'right')

    elseif key == 'left'
            and directionQueue[#directionQueue] ~= 'left'
            and directionQueue[#directionQueue] ~= 'right' then
        table.insert(directionQueue, 'left')

    elseif key == 'up'
            and directionQueue[#directionQueue] ~= 'up'
            and directionQueue[#directionQueue] ~= 'down' then
        table.insert(directionQueue, 'up')

    elseif key == 'down'
            and directionQueue[#directionQueue] ~= 'down'
            and directionQueue[#directionQueue] ~= 'up' then
        table.insert(directionQueue, 'down')
    end
end


function love.update(dt)
    timer = timer + dt

    if snakeAlive then
        local timerLimit = 0.15
        if timer >= timerLimit then
            timer = timer - timerLimit

            if #directionQueue > 1 then
                table.remove(directionQueue, 1)
            end

            local nextXPosition = snakeSegments[1].x
            local nextYPosition = snakeSegments[1].y

            if directionQueue[1] == 'right' then
                nextXPosition = nextXPosition + 1
                if nextXPosition > gridXCount then
                    nextXPosition = 1
                end
            elseif directionQueue[1] == 'left' then
                nextXPosition = nextXPosition - 1
                if nextXPosition < 1 then
                    nextXPosition = gridXCount
                end
            elseif directionQueue[1] == 'down' then
                nextYPosition = nextYPosition + 1
                if nextYPosition > gridYCount then
                    nextYPosition = 1
                end
            elseif directionQueue[1] == 'up' then
                nextYPosition = nextYPosition - 1
                if nextYPosition < 1 then
                    nextYPosition = gridYCount
                end
            end

            local canMove = true

            for segmentIndex, segment in ipairs(snakeSegments) do
                if segmentIndex ~= #snakeSegments
                        and nextXPosition == segment.x
                        and nextYPosition == segment.y then
                    canMove = false
                end
            end

            if canMove then
                table.insert(snakeSegments, 1, { x = nextXPosition, y = nextYPosition }) -- add new segment at first position

                if snakeSegments[1].x == foodPosition.x and snakeSegments[1].y == foodPosition.y then
                    moveFood()
                else
                    table.remove(snakeSegments) -- remove last position
                end

            else
                snakeAlive = false
            end
        end
    elseif timer >= 2 then
        reset()
    end
end


function love.draw()



    local function drawCell(x, y)
        love.graphics.rectangle('fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize,
            cellSize - 1,
            cellSize - 1)
    end

    -- background
    love.graphics.setColor(71, 31, 71)
    love.graphics.rectangle('fill', 0, 0,
        gridXCount * cellSize,
        gridYCount * cellSize)

    -- snake
    for segmentIndex, segment in ipairs(snakeSegments) do
        if snakeAlive then
            love.graphics.setColor(153, 255, 81)
        else
            love.graphics.setColor(126, 126, 126)
        end
        drawCell(segment.x, segment.y)
    end

    -- food
    love.graphics.setColor(255, 76, 76)
    drawCell(foodPosition.x, foodPosition.y)
end