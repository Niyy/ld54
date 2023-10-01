class Entity_Group
    def initialize(get_idx, entities, x: 0, y: 0, w: 64, h: 64, group_count: 10)
        @entities = {}
        @group_count = group_count

        @group_count.times() do |inc|
            entity = Entity.new(get_idx.call(), x: @x + (rand() * @w).round,
                                y: @y + (rand() * @h).round, 
                                path: 'sprites/circle/red.png')
            @entities[entity.idx] = entity
        end
    
        entities.merge(@entities)
    end


    def move_group()

    end
end
