class Game
    attr_gtk
    attr_accessor :map, :hunters


    @@idx_file = 0


    def initialize(args)
        loaded_terrain = args.gtk.deserialize_state('data/terrain.data').terrain
        puts loaded_terrain

# Map set up
        @map = Map.new(max_cells: 100, delta: 64, terrain: loaded_terrain)
        @map.x = 1280 / 2 - @map.fill_value.h_w
        @map.y = 720 / 2 - @map.fill_value.h_h
        @map.gen_map(->{gen_idx})

        @keyboard = {
            mouse: {
                left_button: [-2, :up]
            }
        }

        @col = {}
        @col[:cities] = {}

        @character = Entity.new(gen_idx(), x: 1280 / 2, y: 720 / 2, 
                                      speed: 1, 
                                      path: 'sprites/square/orange.png')
        follower = Entity.new(gen_idx(), x: 1280 / 2 - 100, y: 720 / 2 - 100,
                              path: 'sprites/square/orange.png', speed: 1)

        @character.prev = follower
        follower.next = @character

        @map.add_entity(follower)
        @map.add_entity(@character)

<<<<<<< Updated upstream
        # Add a squad of hunters
        @hunters = []
        @hunters << Hunter.new(gen_idx(), x: -100, y: 720 * rand(),
                               path: 'sprites/square/orange.png', speed: 1)
        @hunters[0].train(10)

        @map.add_entity(@hunters[0])

        @ui_elements = []
        @ui_elements << Button.new()
    end


    def tick()
        output()
        update()
        input()
    end


    def output()
        outputs.background_color = [90, 166, 196]

        outputs.sprites << @map.output()
        outputs.sprites << @col[:cities].values
        outputs.sprites << @map.output_entities()
        outputs.sprites << @map.output_aux()

# UI    
        outputs.sprites << @ui_elements.map do |elem| elem.output() end
    end


    def update()
        @ui_elements.map do |elem|
            elem.check_for_input(inputs.mouse)
        end

        if(@keyboard.mouse.left_button[0] + 1 == state.tick_count &&
                @keyboard.mouse.left_button[1] == :up)
#            new_city = gen_obj()
#            new_city.x = @keyboard.mouse_pos.x - (new_city.w / 2)
#            new_city.y = @keyboard.mouse_pos.y - (new_city.h / 2)
#            new_city.path = 'sprites/circle/orange.png'
#
#            @col[:cities][new_city.idx] = new_city
            mov = [@keyboard.mouse_pos.x - @character.x - @character.h_w,
                   @keyboard.mouse_pos.y - @character.y - @character.h_h]

            angle = Math.atan2(mov.y, mov.x)

            @character.to_angle = angle * 180 / Math::PI
            @character.mov = 1
            @character.dest = [@keyboard.mouse_pos.x, @keyboard.mouse_pos.y]
        end
    
        @map.update(args)
    end


    def input()
        if(inputs.mouse.button_left && 
           @keyboard.mouse.left_button[1] == :up)
            @keyboard.mouse.left_button = [state.tick_count, :down]
        elsif(!inputs.mouse.button_left &&
              @keyboard.mouse.left_button[1] == :down)
            @keyboard.mouse.left_button = [state.tick_count, :up]
        end

        @keyboard.mouse_pos = [inputs.mouse.x, inputs.mouse.y]
    end


    def gen_obj()
        idx = @@idx_file
        @@idx_file += 1

        return { x: 0, y: 0, w: 32, h: 32, idx: idx }
    end


    def gen_idx()
        idx = @@idx_file
        @@idx_file += 1

        return idx
    end
end


def tick(args)
    $game ||= Game.new(args)

    $game.args = args
    $game.tick()
end
