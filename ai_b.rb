require "xmlrpc/server"
require "socket"

s = XMLRPC::Server.new(ARGV[0])
MAX_NUMBER = 16000

class MyAlggago
  def calculate(positions)

    #Codes here
    my_position = positions[0]
    your_position = positions[1]

    current_stone_number = 0
    index = 0
    min_length = MAX_NUMBER
    x_length = MAX_NUMBER
    y_length = MAX_NUMBER






    # gathered : 2~7   g_* : gathered ~
    min_distance = MAX_NUMBER
    target_x = 0 #x value that ai attack
    target_y = 0 #y value that ai attack
    is_gathered = 1 #how many stones gathered
    max_gathered = 1 #max gathered count
    g_plus_distance = 0 #sum of g_distance
    min_2_distance = MAX_NUMBER #min distance of gathered two stones
    g_count = 1 #gathered count




    # too close and power isn't enough. distance from mid_point(350, 350)
    distance_mid_x = 0 #x value from mid-point
    distance_mid_y = 0 #y value from mid-point
    distance_mid_my = 0 #my distance from mid-point
    distance_mid_target = 0 #target's distance from mid-point


    
    your_position.each do |your| #check targets' position that gathered.(3~7 or 2 or 1(not gathered))
       g_count = 1

       your_position.each do |your_team| #compare with other stone
          g_x_distance = (your[0] - your_team[0]).abs
          g_y_distance = (your[1] - your_team[1]).abs
          g_distance = Math.sqrt(
             g_x_distance*g_x_distance + g_y_distance*g_y_distance)
          unless g_distance == 0 #not same stone
             if g_distance < 110 #stone-stone distance
                g_count += 1
                g_plus_distance += g_distance
                
                if max_gathered < g_count
                   max_gathered = g_count
                end
             end
          end

          if g_count >= 3 #gathered stone : 3 or more
             g_plus_distance = (g_plus_distance / g_count) + (g_plus_distance % g_count)
             if min_distance > g_plus_distance
                min_distance = g_plus_distance
                is_gathered = g_count
                target_x = your[0]
                target_y = your[1]
             end
          elsif g_count >= 2 and max_gathered == 2 and g_distance > 0 #gathered stone : 2
             if g_distance <= 90 #very close
                if min_2_distance > g_distance #attack stone-stone's gap
                   min_2_distance = g_distance

                   target_x = (your[0] + your_team[0])/2 + (your[0] + your_team[0])%2
                   target_y = (your[1] + your_team[1])/2 + (your[1] + your_team[1])%2
                end
            else #not very close -> attack linear. calculate target_x,  target_y 
                #code here
                if min_2_distance > g_distance #attack stone-stone
                   min_2_distance = g_distance

                   target_x = (your[0] + your_team[0])/2 + (your[0] + your_team[0])%2
                   target_y = (your[1] + your_team[1])/2 + (your[1] + your_team[1])%2


                   target_x = (target_x + your[0])/2 + (target_x + your[0])%2
                   target_y = (target_y + your[1])/2 + (target_y + your[1])%2
                end

             end
          else
          end
       end

    end
  
    if max_gathered >= 3 #case 1 : gatered stone is 3 or more, calculate x_length, y_length, distance from mid-point
      my_position.each do |my|
      x_distance = (my[0] - target_x).abs
      y_distance = (my[1] - target_y).abs

      current_distance = Math.sqrt(x_distance * x_distance + y_distance * y_distance)

      if min_length > current_distance
          current_stone_number = index
         min_length = current_distance 
         x_length =target_x - my[0]
         y_length = target_y - my[1]
         
         #my/target's distance from mid-point
         distance_mid_x = 350 - my[0]
         distance_mid_y = 350 - my[1]
           distance_mid_my = Math.sqrt(distance_mid_x*distance_mid_x + distance_mid_y*distance_mid_y)

           distance_mid_x = 350 - target_x
           distance_mid_y = 350 - target_y
           distance_mid_target = Math.sqrt(distance_mid_x*distance_mid_x + distance_mid_y*distance_mid_y)
      end
      index = index + 1
     end 
   

   elsif max_gathered == 2 #case 2 : gathered stone is 2
      my_position.each do |my|
      x_distance = (my[0] - target_x).abs
      y_distance = (my[1] - target_y).abs

      current_distance = Math.sqrt(x_distance * x_distance + y_distance * y_distance)

      if min_length > current_distance
          current_stone_number = index
         min_length = current_distance 
         x_length =target_x - my[0]
         y_length = target_y - my[1]
         
         #my/target's distance from mid-point
         distance_mid_x = 350 - my[0]
         distance_mid_y = 350 - my[1]
           distance_mid_my = Math.sqrt(distance_mid_x*distance_mid_x + distance_mid_y*distance_mid_y)

           distance_mid_x = 350 - target_x
           distance_mid_y = 350 - target_y
           distance_mid_target = Math.sqrt(distance_mid_x*distance_mid_x + distance_mid_y*distance_mid_y)
      end
      index = index + 1
      end

   else #case 3: gathered stone isn't exist.


    my_position.each do |my|
      your_position.each do |your|

        x_distance = (my[0] - your[0]).abs
        y_distance = (my[1] - your[1]).abs
        
        current_distance = Math.sqrt(x_distance * x_distance + y_distance * y_distance)

        if min_length > current_distance
          current_stone_number = index
          min_length = current_distance
          x_length = your[0] - my[0]
          y_length = your[1] - my[1]

     #my/target's distance from mid-point
     distance_mid_x = 350 - my[0]
     distance_mid_y = 350 - my[1]
     distance_mid_my = Math.sqrt(distance_mid_x*distance_mid_x + distance_mid_y*distance_mid_y)

     distance_mid_x = 350 - your[0]
     distance_mid_y = 350 - your[1]
     distance_mid_target = Math.sqrt(distance_mid_x*distance_mid_x + distance_mid_y*distance_mid_y)
        end
      end
      index = index + 1
    end


   end

   is_gathered = max_gathered

    #Return values
    #message = positions.size
    message = is_gathered
     
    stone_number = current_stone_number



    if max_gathered >= 3
       if (
       min_length < 100 and
       distance_mid_my >= distance_mid_target 
       )
          #when my position is farther than target's position from mid-point(my position is more outer), 
          #and distance from each other is too short -> attack more powerful.
          stone_x_strength = (x_length +10) * MAX_NUMBER * MAX_NUMBER * MAX_NUMBER * is_gathered * is_gethered * 400
          stone_y_strength = (y_length + 10) * MAX_NUMBER * MAX_NUMBER * MAX_NUMBER * is_gathered * is_gathered * 400
       else
      stone_x_strength = (x_length + 10) * MAX_NUMBER * MAX_NUMBER * MAX_NUMBER * is_gathered * is_gathered * 100
      stone_y_strength = (y_length + 10) * MAX_NUMBER * MAX_NUMBER * MAX_NUMBER * is_gathered * is_gathered * 100
       end

    elsif max_gathered == 2
       if (
       min_length < 100 and
       distance_mid_my >= distance_mid_target
       )
          stone_x_strength = (x_length) * MAX_NUMBER * MAX_NUMBER * is_gathered * 200
          stone_y_strength = (y_length) * MAX_NUMBER * MAX_NUMBER * is_gathered * 200
       else
         stone_x_strength = (x_length) * MAX_NUMBER * is_gathered * 100
         stone_y_strength = (y_length) * MAX_NUMBER * is_gathered * 100
       end

    else
      if (
         min_length < 100 and
         distance_mid_my >= distance_mid_target
        )
           stone_x_strength = (x_length) * 100
           stone_y_strength = (y_length) * 100

           if distance_mid_target > 330
              stone_x_strength *= 0.7
              stone_y_strength *= 0.7
           end
      else
         stone_x_strength = x_length * 5
         stone_y_strength = y_length * 5
      
      end


    end

    return [stone_number, stone_x_strength, stone_y_strength, message]

    #Codes end
  end

  def get_name
    "adogen"
  end
end

s.add_handler("alggago", MyAlggago.new)
s.serve