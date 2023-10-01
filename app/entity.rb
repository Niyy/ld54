class Entity 
    attr_sprite
    attr_accessor :x, :y, :w, :h, :path, :speed, :mov, :h_w, :h_h, :dest, 
                  :angle, :to_angle, :idx, :prev, :next, :map_key, :fighters,
                  :freefolk


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

        @stock = {food: 0, wood: 0}
        @fighters = []
        @freefolk = 100 

        @orders = {}

        @map_key = nil

        @h_w = @w / 2
        @h_h = @h / 2
        @speed = 2 
        @mov = 0 

        @next = nil 
        @prev = nil 

        @forage_base = 10 * 60
    end


    def update(args, map = nil)
        move(args.geometry)
        if(args.tick_count % (@forage_base * (10 / @freefolk)).floor() == 0)
            forage(map) 
        end
        consume()
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


    def take(stock, amount)
        actual_amount = amount

        @stock[stock] -= amount

        if(@stock[stock] < 0)
            actual_amount += @stock[stock]
            @stock[stock] = 0
        end

        return actual_amount
    end


    def hit(fighters)
        attack_roll = rand() 
        defend_roll = rand() 

        if(attack_roll > defend_roll)
            choice_f = fighters.sample()
            choice_d = @fighters.sample()

            choice_d.health -= rand() * choice.f.damage
        end

        if(attack_roll < defend_roll)
            choice_d = fighters.sample()
            choice_f = @fighters.sample()

            choice_d.health -= rand() * choice.f.damage
        end
    end


    def train(amount, immediate = false)
        if(immediate)
            @fighters << { health: 3, damage: 1 }
        end

        return false if(@freefolk - amount <= 50)

        @orders << {action: :train, count: amount}
        @freefolk - amount
    end


    def forage(map)
        return if(@mov > 0 || @freefolk <= 0 || !map.cells.has_key?(@map_key) ||
                  !map.cells[@map_key].has_key?(:flora) || 
                  map.cells[@map_key].flora.length <= 0)

        (@freefolk / 10).ceil().times() do |folk|
            what_key = map.cells[@map_key].flora.keys.sample
            what = map.cells[@map_key].flora[what_key]

            puts "trying to forage: #{what}"

            if(what.resource == :food)
                @stock[:food] += 10
                map.cells[@map_key].flora.delete(what_key)
            end
        end
    end


    def consume()
        @stock[:food] -= (@freefolk / 20) - @fighters.length
    end


    def handle_orders(tick_count)
        @orders.each() do |order|
             
        end
    end


    def has?(stock)
        return true if(@stock.has_key?(stock))
        return false
    end


    def output()
        return { x: @x, y: @y, w: @w, h: @h, angle: @angle, 
                 path: @path }.sprite!()
    end


    def serialize()
        return { x: @x, y: @y, w: @w, h: @h, path: @path, speed: @speed, 
                 mov: @mov, dest: @dest, map_key: @map_key }
    end

    
    def to_s()
        return serialize().to_s()
    end


    def inspect()
        return serialize().to_s()
    end
end
