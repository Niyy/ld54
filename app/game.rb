class Game
    attr_gtk


    @@idx_file = 0


    def initialize()
        @character = gen_obj()

        @character.x = 1280 / 2
        @character.y = 720 / 2
        @character.speed = 2 
        @character.path = 'sprites/circle/violet.png'

        @keyboard = {
            mouse: {
                left_button: [-1, :up]
            }
        }

        @col = {}
        @col[:cities] = {}
    end


    def tick()
        output()
        update()
        input()
    end


    def output()
        outputs.sprites << @col[:cities].values
        outputs.sprites << @character 
    end


    def update()
        if(@keyboard.mouse.left_button[0] == state.tick_count &&
                @keyboard.mouse.left_button[1] == :up)
#            new_city = gen_obj()
#            new_city.x = @keyboard.mouse_pos.x - (new_city.w / 2)
#            new_city.y = @keyboard.mouse_pos.y - (new_city.h / 2)
#            new_city.path = 'sprites/circle/orange.png'
#
#            @col[:cities][new_city.idx] = new_city
            mov = [
                @keyboard.mouse_pos.x - @character.x,
                @keyboard.mouse_pos.y - @character.y
            ]
            angle = Math.atan2(mov.y, mov.x)
            mov.x = Math.cos(angle) * @character.speed
            mov.y = Math.sin(angle) * @character.speed

            @character.mov = mov
        end

#       Character move
        @character.x += @character.mov.x
        @character.y += @character.mov.y
    end


    def input()
        if(inputs.mouse.button_left && 
                @keyboard.mouse.left_button[1] == :up)
            @keyboard.mouse.left_button = [state.tick_count, :down]
            puts "#{@keyboard.mouse.left_button}"
        elsif(!inputs.mouse.button_left &&
                @keyboard.mouse.left_button[1] == :down)
            @keyboard.mouse.left_button = [state.tick_count, :up]
            puts "#{@keyboard.mouse.left_button}"
        end

        @keyboard.mouse_pos = [inputs.mouse.x, inputs.mouse.y]
    end


    def gen_obj()
        idx = @@idx_file
        @@idx_file += 1

        return { x: 0, y: 0, w: 32, h: 32, idx: idx }
    end
end


def tick(args)
    $game ||= Game.new()

    $game.args = args
    $game.tick()
end
