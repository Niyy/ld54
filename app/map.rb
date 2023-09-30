class Map
    attr_accessor :cells, :x, :y, :delta, :fill_value


    def initialize(max_cells: 5, delta: 100, fill_value: {}, 
                   terrain: [{path: 'sprites/square/gray.png'}])
        @x = 0
        @y = 0

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

        @cells = {}
        @cells[[0, 0]] = @fill_value.clone()

        @max_cells = max_cells
    end


    def gen_map(get_idx)
        @cells = {}
        @cells[[0, 0]] = @fill_value.clone()
    
        used = {}
        queued = [[0,0]]

        @max_cells.times() do |time|
            next_cell = queued.shift() 

            @cells[next_cell] = @fill_value.clone()
            @cells[next_cell].x += @x + next_cell.x * @fill_value.w
            @cells[next_cell].y += @y + next_cell.y * @fill_value.h
            @cells[next_cell].idx = next_cell
            @cells[next_cell].terrain = @terrain.sample
            @cells[next_cell].path = @cells[next_cell].terrain.path

            @dir.each do |n_dir|
                to_queue = [next_cell.x + n_dir.x, next_cell.y + n_dir.y]
                if(!used.has_key?(to_queue))
                    queued << to_queue if(!used.has_key?(to_queue))
                    used[to_queue] = 1
                end
            end

            gen_resources(@cells[next_cell], get_idx)
        end
    end


    def gen_resources(cell, get_idx)
        cell.flora = {}

        cell.terrain.flora.each() do |entity|
            n_flora = {x: cell.x + rand() * cell.w, y: cell.y + rand() * cell.h, 
                       w: 16, h: 16, path: entity.path, type: entity.resource}
            
            max_add = entity._max - entity._min
            actual_count = entity._min + (rand() * max_add).round()

            actual_count.times() do |count|
                puts get_idx
                cell.flora[get_idx.call] = n_flora.clone().sprite()
            end
        end
    end


    def output()
        return @cells.values()
    end


    def output_flora()
        outputs = []
        
        @cells.values.each() do |cell_flora|
            outputs << cell_flora.flora.values
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
