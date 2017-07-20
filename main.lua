function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
debug = true
enemyMove = 5 -- enemyMove initially set to 5, which is outside of possible number range to be generated (0-4); this ensures enemies do not move as soon as they spawn
enemySpawn = 0 -- enemySpawn set to 4 so we begin with an enemy onscreen
enemyImg = nil
enemies = {
    grid_x = 0,
    grid_y = 0,
    act_x = 0,
    act_y = 0
}


-- Boots up variables and functions which the game will reference later on in the code.
function love.load(arg)
	enemyImg = love.graphics.newImage('assets/cat.png')
	-- Table for the player variable to store additional variables related to said class.
	-- Used to call back to when referenced later on in code.
		-- love.graphics.rectangle("fill, 0, 0, 32, 32")
		-- becomes
		-- love.graphics.rectangle("fill, player.x, player.y, 32, 32")
		-- player.x and player.y
			-- player = class
			-- .x/.y = member
			-- calls back to player table in function love.load(), pulls x and y
	player = {
		grid_x = 64,
		grid_y = 128,
		act_x = 64,
		act_y = 128,
		speed = 25
	}

	map = {
			{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
			{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
			{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
			{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
			{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
			{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
			{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
	}
end

function love.update(dt)
	-- Functions that create smooth transitions
	-- Dynamic calculations so that the player visibly moves from one coordinate to the next.
	-- Creates fluid movement (instead of instant 'teleportation')
	player.act_y = player.act_y - ((player.act_y - player.grid_y) * player.speed * dt)
	player.act_x = player.act_x - ((player.act_x - player.grid_x) * player.speed * dt)

    --commented out due to issues with smooth transitions not working for enemies
    --[[for i, enemy in ipairs(enemies) do
        enemy.act_y = enemy.act_y - ((enemy.act_y - enemy.grid_y) * enemy.speed * dt)
	    enemy.act_x = enemy.act_x - ((enemy.act_x - enemy.grid_x) * enemy.speed * dt)
    end]]

	-- Function that tests whether or not player can move over a space.
	function testMap(x, y)
		if map[(player.grid_y / 32) + y][(player.grid_x / 32) + x] == 1 then
			return false
		end
		return true
	end

    if enemySpawn == 4 then
        enemyMove = 4
        enemySpawn = 0
    	-- Create an enemy
    	-- Still futzing about with the code here. See "horizontal enemy spawn" for non-fucked code to-
    	-- generate left-moving enemies.
    	randomNumber = 64+32*math.floor(5*math.random())
    	-- Julian's solution: 32*Floor(5*Rand())
    	-- adjusted here to fit the lua syntax
    	enemy = { y = randomNumber, x = 384, img = enemyImg }
    	table.insert(enemies, enemy)
    end

    -- Gives the player movement. If statements that receive keyboard inputs and transform player position.
    -- In LOVE, coordinates are based off a 0,0 origin in the top left corner of the game's screen.
	function love.keypressed(key)

    	if key == "up" then
    		if testMap(0, -1) then
    			player.grid_y = player.grid_y - 32
    		end
    	elseif key == "down" then
    		if testMap(0, 1) then
    			player.grid_y = player.grid_y + 32
    		end
    	elseif key == "left" then
    		if testMap(-1, 0) then
    			player.grid_x = player.grid_x - 32
    		end
    	elseif key == "right" then
    		if testMap(1, 0) then
    			player.grid_x = player.grid_x + 32
    		end
    		-- the elseif keywords are technically a part of the original if statement, so only one "end" keyword is needed
        end


    -- after receiving player input, generates 0, 1, 2,or 3 which will in turn dictate enemy movement left, up, or down respectively
    -- enemies will move left on either 0 or 1, such that movement is weighted more towards the left
    -- fixed issue where only 'right' input was outputting enemyMove; look into why having it nested under love.keypressed(key) resulted in that issue
    if love.keyboard.isDown('up','down','left', 'right') then
        enemyMove = math.floor(4*math.random())
        print('enemyMove = ')
        print(enemyMove)
    end

-- beginning of enemy code
    if love.keyboard.isDown('up','down','left', 'right') then
        enemySpawn = math.floor(5*math.random())
        print('enemySpawn = ')
        print(enemySpawn)
    end



--Updates position of enemies.
    if enemies ~= nil then
        for i, enemy in ipairs(enemies) do
            function testMapEnemy(x, y)
                if map[(enemy.y / 32) + y][(enemy.x / 32) + x] == 1 then
                    return false
                end
                return true
            end

        	if (enemyMove == 0 or enemyMove == 1) then
                if testMapEnemy(-1, 0) then
                enemyMove = 5
                enemy.x = enemy.x - 32
                end
                --commented out due to issues with grid_x/y returning nil values; look into why
                --[[if testMapEnemy(-1, 0) then
                    enemy.grid_x = enemy.grid_x - 32
                    enemyMove = 5
                end
                --resets to 5 otherwise enemies zooooooom offscreen]]
        	elseif (enemyMove == 2) then
                if testMapEnemy(0, -1) then
                enemyMove = 5
                enemy.y = enemy.y - 32
                end
                --[[if testMapEnemy(0, -1) then
                    enemy.grid_y = enemy.grid_y - 32
                    enemyMove = 5
                end]]
            elseif (enemyMove == 3) then
                if testMapEnemy(0, 1) then
                enemyMove = 5
                enemy.y = enemy.y + 32
                end
                  --[[if testMapEnemy(0, 1) then
                      enemy.grid_y = enemy.grid_y + 32
                      enemyMove = 5
                  end]]
        	end

        	if enemy.x < 64 then -- remove enemies when they reach the wall
        		table.remove(enemies, i)
        	end

        end
    end

    -- reset game state; restrict reset once win/lose conditions are implemented
	if love.keyboard.isDown('r') then
		player.grid_x = 64
		player.grid_y = 128
    	player.act_x = 64
    	player.act_y = 128

        enemies = {}
    end

    -- Couple lines that create an easy way to close game by pressing ESC.
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

end
-- closes out function love.keypressed(key)
-- this 'end' is placed at the bottom of love.update() because of issues arising from love.keyboard.isDown()
-- when love.update() was closed higher up and only containing player movement, other keyboard functions would be run through repeatedly
-- unsure if this is the exact cause, but from what I can guess love.keypressed(key) prevents functions from receiving more than a single input at a timers
-- double check to verify this conclusion

end
-- closes out function love.update()

function love.draw(dt)
	--draws enemies
	for i, enemy in ipairs(enemies) do
    	love.graphics.draw(enemy.img, enemy.x, enemy.y)
    end

	love.graphics.rectangle("fill", player.act_x, player.act_y, 32, 32)

	for y=1, #map do
		for x=1, #map[y] do
			if map[y][x] == 1 then
				love.graphics.setColor(255, 0, 0, alpha)
				love.graphics.rectangle("fill", x * 32, y * 32, 32, 32)
			end
		end
	end

	love.graphics.setColor(255, 255, 255, alpha)

	--Horizontal lines
    local x1 = 64
    local y1 = 96
    local x2 = 416
    local y2 = 96
    for i = 0, 3, 1
    do
        love.graphics.line(x1, y1, x2, y2)
        y1 = y1+32
        y2 = y2+32
    end

    --Vertical lines
    local x1 = 96
    local y1 = 64
    local x2 = 96
    local y2 = 224
    for i = 0, 9, 1
    do
        love.graphics.line(x1, y1, x2, y2)
        x1 = x1+32
        x2 = x2+32
    end


end
