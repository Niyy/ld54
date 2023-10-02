class Button
    attr_sprite


    def initialize(x: 0, y: 0, w: 64, h: 64, 
                   sprites: ['sprites/icon/camp_button.png',
                             'sprites/icon/decamp_button.png'])
        @x = x
        @y = y
        @w = w
        @h = h
        @sprites = sprites
        @index = 0
    end


    def check_for_input(mouse)
        puts "inside? #{mouse.click}"

        if(mouse.inside_rect?(self) && mouse.button_left && 
           mouse.click)
            @index += 1

            @index = @sprites.length % @index
        end
    end


    def output()
        return {x: @x, y: @y, w: @w, h: @h, path: @sprites[@index]}.sprite!()
    end


    def serialize()
        return {x: @x, y: @y, w: @w, h: @h, path: @sprites[@index]}.sprite!()
    end


    def to_s()
        return serialize().to_s()
    end

    def inspect()
        return serialize().to_s()
    end
end
