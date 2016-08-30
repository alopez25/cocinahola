require 'io/console'

class Menu
  def initialize(name)
    @name = name
    @items = Array.new
  end

  @@display_menu_times = 0

  def self.display_menu_times
    puts @@display_menu_times
  end

  def introduction
    puts "\n\n\nSalivate with #{@name.upcase}'s Menu in 3 steps:\n\n\n"
    puts "\nA. Choose a dish\n"
    puts "\nB. Guess the price\n"
    puts "\nC. Get it right and eat free!\n\n\n\n"
    continue_story
    system "cls"
  end

  def display_menu
    puts "\n\n\n\n"
    @items.each_with_index { |x,y| puts "#{y+1}.- #{x.dish}" }; print "#{items.size+1}.- Exit"
    puts "\n\nSELECT A DISH CHOOSING A NUMBER FROM 1 to #{items.size+1}"
    @@display_menu_times += 1
  end

  def highlight(dish_selection)
    @dish_selection = dish_selection
    puts "\n\n\n\n"
    @items.each_with_index do |x,y|
      if dish_selection != y
      puts "#{y+1}.- #{x.dish}"
      else
      puts "#{y+1}.- #{x.dish} ...... Take a guess at #{x.dish}'s price"
      end
    end
  end

  def display_price(dish_selection)
    @dish_selection = dish_selection
    puts "\n"
    @items.each_with_index do |x,y|
      if dish_selection != y
      puts "#{y+1}.- #{x.dish}"
      else
      puts "#{y+1}.- #{x.dish}.........................#{x.price}"
      end
    end
    # puts "\n\n"
    # puts continue_story
  end

  def win?(dish_selection, guessed_price)
    @dish_selection = dish_selection
    @guessed_price = guessed_price
    return @guessed_price == @items[dish_selection].price
  end

  def randomize_prices
   @items.each { |x| x.price = rand(30..40)}
  end

  def cooking
    puts "\n\n\n\n"
    print "= = Starting cooking"
    4.times { sleep(1); print " = "  }
    print " The cook just took a toilet break "
    5.times { sleep(1); print " = "  }
    print "#{@items[dish_selection].dish} READY!!"
    puts "\n\n\n"
  end

  attr_accessor :name, :items, :dish_selection, :display_menu_times

end

class Dish
  def initialize(dish, price)
    @dish = dish
    @price = price
  end

  attr_accessor :dish, :price
end

def continue_story
  print "Press any key to continue"
  STDIN.getch
  print "            \r" # extra space to overwrite in case next sentence is short
end

str = nil

menu1 = Menu.new("Cocina Hola")

dish1 = Dish.new("Chilaquiles", rand(30..40))
dish2 = Dish.new("Huevos Rancheros", rand(30..40))
dish3 = Dish.new("Tamales", rand(30..40))
dish4 = Dish.new("Tacos de camaron", rand(30..40))
dish5 = Dish.new("Birria", rand(30..40))

menu1.items = [dish1, dish2, dish3, dish4, dish5]

begin
  puts "\n\n\n\nPress any key to START!"
  system("stty raw -echo")
  str = STDIN.getc
  ensure
  system("stty -raw echo")
end

system "cls"
menu1.introduction

dish_selection = 0
previous_picks = []
guessed_price = 1
pay = nil

until menu1.win?(dish_selection - 1, guessed_price)  do

menu1.display_menu
dish_selection = gets.chomp.to_i

until (1..menu1.items.size + 1).include? dish_selection do
  system "cls"
  puts "\n\n\n\n PAY ATTENTION! I ONLY TAKE NUMBERS BETWEEN 1 to #{menu1.items.size+1}"
  sleep(2.5)
  system "cls"
  menu1.display_menu
  dish_selection = gets.chomp.to_i
end

if dish_selection == menu1.items.size + 1; system "cls"; puts "\n\n\n\n gracias por visitar cocina hola".upcase; sleep(2.5); system "cls"; exit; end

system "cls"
menu1.highlight(dish_selection - 1)

if str == "c"; puts "\n\n Pssst... this is the price --> $#{menu1.items[dish_selection - 1].price}" end

puts "\n Type a price here" #ADD TO HIGHLIGH METHOD
puts "          ↓         " #ADD TO HIGHLIGH METHOD

guessed_price = gets.chomp.to_i
print "\r"

puts menu1.win?(dish_selection - 1, guessed_price)
if menu1.win?(dish_selection - 1, guessed_price) == true
   system "cls"
   puts "\n\n\nyou won a delicious #{menu1.items[dish_selection-1].dish} dish".upcase
   puts "\n\n#{menu1.items[dish_selection-1].dish} are $#{menu1.items[dish_selection-1].price}\n"
   menu1.cooking
   continue_story
   system "cls"
   previous_picks << dish_selection
   #add image
 else
   system "cls"
   if  previous_picks.include?(dish_selection); puts "\n\n Ohhh tortillas' prices went crazy and had to do a last minute change of prices".upcase end
   puts "\nSorry... please pay for the #{menu1.items[dish_selection-1].dish} as below or keep trying\n\n".upcase
   menu1.display_price(dish_selection-1)
   previous_picks << dish_selection
   puts "\n\n\nWould you like to pay for #{menu1.items[dish_selection-1].dish} ?"
   puts "1. YES      2.NO"
   pay = gets.chomp.to_i
    if pay == 1; menu1.cooking; sleep(2); system "cls" else system "cls" end
 end

menu1.randomize_prices
end
