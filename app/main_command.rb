class Main_Command < Entity
    def initialize(idx, **argv)
        super
    end


    def move(map, geometry)
        if(!@next.nil? && geometry.distance(@next, self))
            @dest = @next
        elsif(!@next.nil?)
            @dest = nil
        end

        return if(@dest.nil?)

        _turn_reduct = 1.0

        mov = [@dest.x - @x - @h_w,
               @dest.y - @y - @h_h]

        @to_angle = Math.atan2(mov.y, mov.x) * 180 / Math::PI
        @to_angle = @to_angle.abs if(@to_angle.abs >= 170)
        @angle = -180 if(180 < @angle)
        @angle = 180 if(-180 > @angle)

        puts "to_angle: #{@to_angle}"
        puts "angle: #{@angle}"

        if(@to_angle - 5 >= @angle || @to_angle + 5 <= @angle)
            if(@angle - @to_angle >= 0)
                @angle -= @speed 
            elsif(@angle - @to_angle < 0)
                @angle += @speed 
            end

            _turn_reduct = 0.2
        else
            @angle = @to_angle
        end
        
        map.remove_entity(map.calc_key([@x, @y]), @idx)
        @x += Math.cos(@angle * Math::PI / 180) * @speed * @mov * _turn_reduct
        @y += Math.sin(@angle * Math::PI / 180) * @speed * @mov * _turn_reduct
        map.add_entity(self)

        puts map.cells[map.calc_key([@x, @y])].entities

        char_mid = [@x + @h_w, 
                    @y + @h_h]

        if(!@dest.nil? &&
           geometry.distance(char_mid, @dest) <= @w / 2)
            @mov = 0 
            @dest = nil 
        end
    end
end
