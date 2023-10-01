class Entity 
    attr_sprite
    attr_accessor :x, :y, :w, :h, :path, :speed, :mov, :h_w, :h_h, :dest, 
                  :angle, :to_angle, :idx, :prev, :next, :map_key


    def initialize(idx, x: 0, y: 0, w: 32, h: 32, 
                   path: 'sprites/oh-no.png', speed: 2)
        @idx = idx
        @x = x
        @y = y
        @w = w
        @h = h
        @a = 255
        @angle = 0
        @to_angle = 0
        @path = path

        @map_key = nil

        @h_w = @w / 2
        @h_h = @h / 2
        @speed = 2 
        @mov = 0 

        @next = nil 
        @prev = nil 
    end


    def update(args)
        move(args.geometry)
    end


    def follow()
    end


    def move(geometry)
        buffer = 2

        if(!@next.nil? && geometry.distance(@next, self) > @w * buffer)
            @dest = @next
            @mov = 1
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

        if(@to_angle - 5 >= @angle || @to_angle + 5 <= @angle)
            if(@angle - @to_angle > 180)
                @angle += @speed 
                _turn_reduct = 0.5
            elsif(@angle - @to_angle < -180)
                @angle -= @speed 
                _turn_reduct = 0.5
            elsif(@angle - @to_angle >= 0)
                @angle -= @speed 
            elsif(@angle - @to_angle < 0)
                @angle += @speed 
            end

            _turn_reduct = 0.2
        else
            @angle = @to_angle
        end
        
        @x += Math.cos(@angle * Math::PI / 180) * @speed * @mov * _turn_reduct
        @y += Math.sin(@angle * Math::PI / 180) * @speed * @mov * _turn_reduct

        char_mid = [@x + @h_w, 
                    @y + @h_h]

        if(!@dest.nil? &&
           geometry.distance(char_mid, @dest) <= @w / 2)
            @mov = 0 
            @dest = nil 
        end
    end


    def output()
        return { x: @x, y: @y, w: @w, h: @h, angle: @angle, 
                 path: @path }.sprite!()
    end


    def serialize()
        return { x: @x, y: @y, w: @w, h: @h, path: @path, speed: @speed, 
                 mov: @mov }
    end

    
    def to_s()
        return serialize().to_s()
    end


    def inspect()
        return serialize().to_s()
    end
end
