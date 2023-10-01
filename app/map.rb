class Map
    attr_accessor :cells, :x, :y, :delta, :fill_value


    def initialize(max_cells: 5, delta: 100, fill_value: {}, 
                   terrain: [{path: 'sprites/square/gray.png'}])
        @x = 0
        @y = 0
        @w = delta
        @h = delta

        @terrain = terrain

        @dir = [[0, 1], [1, 0], [-1, 0], [0, -1]]
        @fill_value = fill_value

        @fill_value.x = @x
        @fill_value.y = @y
        @fill_value.w = delta
        @fill_value.h = delta
        @fill_value.h_w = delta / 2
        @fill_value.h_h = delta / 2
        @fill_value.terrain = @terrain.sample 
        @fill_value.path = @fill_value.path 
        @fill_value.idx = [0, 0]
        @fill_value.entities = {}

        @flora_spawn_chance = 0.1
        
        @col = {entities: {}}
        @cells = {}
        @cells[[0, 0]] = @fill_value.copy()

        @max_cells = max_cells
    end


    def gen_map(get_idx)
        @cells = {}
        @cells[[0, 0]] = @fill_value.copy()
    
        used = {}
        queued = [[0,0]]

        @max_cells.times() do |time|
            next_cell = queued.shift() 

            @cells[next_cell] = @fill_value.copy()
            @cells[next_cell].x += @x + next_cell.x * @fill_value.w
            @cells[next_cell].y += @y + next_cell.y * @fill_value.h
            @cells[next_cell].idx = next_cell
            @cells[next_cell].terrain = @terrain.sample if(!@terrain.nil?)
            @cells[next_cell].path = @cells[next_cell].terrain.path

            @dir.each do |n_dir|
                to_queue = [next_cell.x + n_dir.x, next_cell.y + n_dir.y]
                if(!used.has_key?(to_queue))
                    queued << to_queue if(!used.has_key?(to_queue))
                    used[to_queue] = 1
                end
            end
            
            gen_resources(@cells[next_cell], get_idx) if(!@terrain.nil?)
            gen_features(@cells[next_cell], get_idx) if(!@terrain.nil?)
        end
    end


    def gen_features(cell, get_idx)
        cell.features = {}
        spawning = rand()

        cell.terrain.features.each() do |entity|
            next if(entity.chance < rand())
           
            max_add = entity._max - entity._min
            actual_count = entity._min + (rand() * max_add).round()
            
            w = entity.w_high
            h = entity.w_high
            h = entity.h_high if(entity.dim == :multi)

            puts "actual count: #{actual_count}"
            puts "-----------------------------"

            actual_count.times() do |count|
                idx = get_idx.call
                cell.features[get_idx.call] = {x: cell.x + rand() * cell.w, 
                                               w: w, h: h, 
                                               y: cell.y + rand() * cell.h, 
                                               path: entity.path, idx: idx, 
                                               type: entity.resource}

            end
        end
    end


    def gen_resources(cell, get_idx)
        cell.flora = {}
        spawning = rand()

        return if(spawning > @flora_spawn_chance)

        cell.terrain.flora.each() do |entity|
            n_flora = {x: cell.x + rand() * cell.w, y: cell.y + rand() * cell.h, 
                       w: 16, h: 16, path: entity.path, type: entity.resource}
            
            max_add = entity._max - entity._min
            actual_count = entity._min + (rand() * max_add).round()

            puts "actual count: #{actual_count}"
            puts "-----------------------------"

            actual_count.times() do |count|
                cell.flora[get_idx.call] = {x: cell.x + rand() * cell.w, 
                                            y: cell.y + rand() * cell.h, w: 16, 
                                            h: 16, path: entity.path, 
                                            type: entity.resource}.sprite!
            end
        end
    end


    def update(args)
        @col.entities.values.each() do |entity|
            remove_entity(calc_key([@x, @y]), @idx)
            entity.update(args)
            add_entity(entity)
        end
    end


    def add_entity(entity)
        _key = calc_key(entity)

        if(@cells.has_key?(_key))
            @cells[_key].entities[entity.idx] = entity
            @col[:entities][entity.idx] = entity
            entity.map_key = _key
        end
    end


    def remove_entity(_key, idx)
        if(@cells.has_key?(_key) && @cells[_key].entities.has_key?(idx))
            @cells[_key].entities[idx].map_key = nil
            @cells[_key].entities.delete(idx)
        end
    end


    def kill_entity(entity)
        @col[:entities].delete(entity.idx) 
    end


    def calc_key(entity)
        return [((entity.x - @x) / @w).floor(), 
                ((entity.y - @y) / @h).floor()]
    end


    def output()
        return @cells.values()
    end


    def output_aux()
        outputs = []
        
        @cells.values.each() do |cell|
            outputs << cell.flora.values
            outputs << cell.features.values
        end
           
        return outputs.flatten.sort {|a, b| 
            b.y <=> a.y
        }
    end


    def output_entities()
        outputs = []
        
        @cells.values.each() do |cell|
            outputs << cell.entities.values
        end

        return outputs
    end


    def serialize()
        { cells: @cells, x: @x, y: @y, delta: @delta }
    end


    def to_s()
        return serialize().to_s()
    end


    def inspect()
        return serialize().to_s()
    end
end
