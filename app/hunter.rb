class Hunter < Entity
    def initialize(idx, **args)
        super

        @hunting = nil
        @desire = :land
        @move_state = :sailing

        @speed = 2 #0.5
    end


    def update(args, map)
        move(args.geometry)
        reach_dest()
        search_for_target(map, args.geometry)
    end


    def recalibrate_hunt()
        @dest = [@hunting.x, @hunting.y]
    end

    
    def search_for_target(map, geometry)
        return if(!@dest.nil?())
        @hunting = nil
        dist = nil

        if(@desire != :land)
            @speed = 2

            map.col.entities.values.each() do |entity|
                cdist = geometry.distance(entity, self)

                if(entity.has?(@desire) && (dist.nil? || cdist < dist) &&
                   @idx != entity.idx)
                    @hunting = entity
                    dist = geometry.distance(entity, self)
                end
            end
        else
            map.cells.values().each() do |cell|
                cdist = geometry.distance(cell, self)

                if((dist.nil? || cdist < dist))
                    @dest = [cell.x, cell.y]
                    dist = geometry.distance(cell, self)
                end
            end

            @desire = :food
        end

        @dest = [@hunting.x, @hunting.y] if(@dest.nil?)
        @mov = 1
    end


    def reach_dest()
        return if(@hunting.nil?)

        if(self.intersect_rect?(@hunting))
            fight()
            pillage()
        end
    end


    def fight()
        return if(@hunting.fighters.length <= 0 || @fighters.length <= 0)

        @hunting.hit(@fighters)
    end


    def pillage()
        return if(@hunting.fighters.length > 0 || @fighters.length <= 0)

        if(@hunting.stock[@desire] <= 0)
            @hunting.freefolk = 0
            @hunting = nil
            @dest = nil
        end

        @fighters.each do |fighter|
            @hunting.take((rand() * fighter.carry).floor())
        end
    end


    def serialize()
        super().merge({ desire: @desire })
    end
            
end
