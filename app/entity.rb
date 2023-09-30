class Entity 
    attr_accessor :x, :y, :w, :h, :path, :speed, :mov, :h_w, :h_h, :dest, :angle


    def initialize(idx, x: 0, y: 0, w: 32, h: 32, 
                   path: 'sprites/oh-no.png', speed: 2)
        @x = x
        @y = y
        @w = w
        @h = h
        @angle = 0
        @path = path

        @h_w = @w / 2
        @h_h = @h / 2
        @speed = 2 
        @mov = [0, 0]

        @next = nil 
        @prev = nil 
    end


    def follow()
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
