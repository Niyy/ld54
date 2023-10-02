class Main_UI
    def initialize(geometry)
        @camp_buttons = ['sprites/icon/camp_button.png', 
                         'sprites/icon/decamp_button.png']
        @current_camp_button = camp_icon()
        @order_list = []
        @order_list_add_entry = ['sprites/icon/add_order.png']
    end


    def open_camp_icon(geometry)
        return {x: geometry.right - 68, y: 8, w: 64, h: 64, cur: 0,
                path: 'sprites/icon/camp'}
    end


    def add_order_form_open()

    end


    def update(mouse)
        if(mouse.inside_rect?( 
    end
end
