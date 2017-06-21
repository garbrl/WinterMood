#!/usr/bin/ruby


=begin

HELLO ALL!

This is a simple program to provide a survey of the primary
ruby syntax. This program will provide examples of some
of the syntaxical structures which will be neccessary
for the project.

=end






##########################################################
# 1. Comments                                            #
##########################################################

# As you've probably noticed, lines which start
# with a '#' character are commented. Also, any
# characters after a '#' on a line will be
# ignored by the ruby interpreter

=begin

The less well-known type of comments are those
which begin with the '=begin' marker and
which end with the '=end' marker. These
markers must be at the begining of the line,
and all lines in-between them will be ignored

=end












##########################################################
# 2. Methods                                             #
##########################################################

# methods can be defined without any enclosing scope
# such that they are in the 'global' scope. for
# example:

def my_method_1()
  printf("Hello from 'my_method_1'\n")
end

# this defines a method in the global scope
# called 'my_method_1'

# function parameters / arguments are fairly strait forward:

def my_method_2(a, b)
  printf("Hello from 'my_method_2'. My parameters are '%s' and '%s'\n", a, b)
end

# optional arguments with default values are also allowed. For example:

def my_method_3(a, b = 4)
  printf("Hello from 'my_method_3'. My parameters are '%s' and '%s'\n", a, b)
end

# In the case of 'my_method_3', it may be called either with a single
# argument passed, making the parameter 'b' default to '4', as
# may it also be called with two arguments, making the parameters
# 'b' take the value of the 2nd argument passed to the method

# Ruby also allows for methods of variable length argument
# specification. 'Vary-arg' or 'Variadic' functions of this sort take
# the form:

def my_var_method_1 (*a)
  printf("Hello from 'my_var_method_1'. I received the following %d variadic parameters:\n", a.size)
  a.each do |e|
    printf("  %s", e)
  end
end

# This vary-arg formatting can be mixed with the other types of
# argument specification like so:

def my_var_method_2 (a, b, c, *d)
  printf("Hello from 'my_var_method_2'. I received '%s', '%s, and '%s' as non variadic. I also received the following %d variadic parameters:\n", a, b, c, d.size)
  d.each do |e|
    printf("  %s", e)
  end
end



# invoking methods may be done with either of the following
# syntaxes

my_method_2(4, 2)
my_method_2 4, 2



##########################################################
# 3. Variables and Constants                             #
##########################################################

# local variables are written as a regular tokens
# whose only constraint is that they must begin with
# a lower case letter. For example:

my_variable = 8.234

# defines 'my_variable' to be 8.234 in the local scope

# constants are declared in the same way as are local
# variables, however they must begin with an upper
# case character:

My_constant = 2.4324

# will be consntant. It is technically capable of being
# changed via some interpreters, however, most will
# either cause a warning, or exit when a constant
# is changed

# global variables are defined with a leading '$'
# character. These variables are accessable from
# any scope:

$my_global_variable = 1234

# access to this global variable from any scope
# must include the preceeding '$' of the token


# Class and instances variables work a bit differently
# but we'll go into that on the section labelled
# 'Classes'



##########################################################
# 5. Literals                                            #
##########################################################

# For integer and floating point values, the following
# are acceptable:

my_integer_1 = 123
my_integer_2 = 1_000  # the underscore will be ignored and the integer
                      # will be interpreted as '1000'

my_integer_3 = 0xFA2E # interpreted as a hexadecimal number 'FA2E'

my_integer_4 = 0443   # interpreted as an octal number
                      # use of this form is discouraged
                      # as it is easy to mistake for a
                      # decimal value

my_integer_5 = 0b1001 # interpreted as binary '1001'

my_float_1 = 1.234
my_float_2 = 0.43e-2  # interpreted as 0.43 * 10^(-2)


# You're likely aware of the standard escape sequences
# for string literals but I'll enumerate some anyways:

#   \n    'new line' character,   hex:0x0A
#   \r    'carriage return',      hex:0x0D
#   \t    'tab',                  hex:0x09
#   \b    'backspace',            hex:0x08
#   \"    'quotation',            hex:0x22
#   \\    'backslash',            hex:0x5C

my_escaped_string = "this is \"escaped\"\nsee above"

# as well there are Octal escapes such as
# \ddd where each 'd' is a digit between
# 0-7 (inclusive). The 'ddd' portion is
# interpreted as an octal value and
# the resulting character is the ascii
# character with the associated code

my_octal_escaped_string = "\110\105\114\114\117"

# Also, we have hex escapes of the for
# hexadecimal values of the form \xdd
# where each 'd' is a digit between
# 0-F (inclusive). The 'dd' portion is
# interpreted as a hexadecimal value and
# the resulting character is the ascii
# character with the associated code

my_hex_escaped_string = "\x48\x45\x4C\xFC\x4F"

# There are also several ways of using
# the '%' character to represent string
# and the available options get rather
# complicated. But the simplest few examples
# are as follows

my_special_escaped_string_1 = %{contents of the string which may contain " unescaped}
my_special_escaped_string_2 = %~contents of the tilda string~
my_special_escaped_string_3 = %(These types of escapes are often called "perl" escapes)

# Strings may also contain expressions bounded by
# the '#{' characters starting and the '}' character
# terminating. These expressions will be evaluated
# and the result will be represented in the string
# in place of the entire '#{expression}' statement

my_formatted_string = "the value of 'my_variable' is #{my_variable}"

# if printed, this string will state:
# "the value of 'my_variable' is 8.234"


# Empty arrays may be formed with any
# of the following:

my_array_1 = Array.new
my_array_2 = Array.new()
my_array_3 = Array::new
my_array_4 = Array::new()
my_array_5 = []

# all of which will be exactly the
# same. Each will form a totally
# empty array


# Creating a non-empty array may be done using
# the following formatting

my_array_6 = ["x", "y", "z"]

# Which will create an array of the 3 string values


# Arrays may also be created using the format:

my_array_7 = %w[a b c d]

# which would be equivelant to creating the array
# with ["a", "b", "c", "d"]



# Associative arrays, (which are refered to in ruby
# as 'Hashes') can be created using any of the
# following:

my_hash_1 = Hash.new
my_hash_2 = Hash.new()
my_hash_3 = Hash::new
my_hash_4 = Hash::new()
my_hash_2 = {}

# all of which create empty hashes
# or created with values already assigned
# like so:

my_hash_5 = { :a => 1, :b => 2, :c => 3 }
my_hash_6 = { "a" => 1, "b" => 2, "c" => 3 }
my_hash_7 = { a: 1, b: 2, c: 3}

# all of which create the same hash / associative array


# Values within those hashes may be accessed with the
# following syntax:

a_value_of_my_hash_5 = my_hash_5[:a]

# Note that the hash may not be accessed
# using the 'string' notation as seen with
# the creation of 'my_hash_6'


# Ranges can be created using either
# a double or triple repeated '.' character.
# For example:

my_range_1 = 0..5  # from 0 to 5 (inclusive)
my_range_2 = 0...5 # from 0 to 5 (exclusive)

# One can also check whether or not a value is
# within a given range using the '===' operator

my_range_1_contains_2 = my_range_1 === 2    # is true
my_range_1_contains_10 = my_range_1 === 10  # is false





##########################################################
# 7. Control Structures                                  #
##########################################################

# The control structures in Ruby are fairly
# straightforward, but here's a quick overview:


# if statements execute if the statement evaluates
# to 'true'

if true
  # executed
end

# unless statements execute if the statement
# evaluates to 'false'

unless false
  # executed
end

# else statements go inbetwen the 'if' and
# its 'end' and are executed if the
# conditional is false

if false
  # not executed
else
  # executed
end

# elsif statements allow for the
# creation of an 'if-else' tree

if false
  # not executed
elsif true
  # executed
else
  # not executed
end

# 'case' blocks may be formed in place
# of if-elsif-else trees


case
when false then
  # not executed
when true then
  # executed
when true then
  # not executed
else
  # not executed
end


# 'while' loops are the same as with every
# other lanuage ever (except maybe Fortran)

while false
  # loop is never entered
end

while_loop_var_1 = 0

while (while_loop_var_1 < 5)
  while_loop_var_1 += 1
end

# 'until' loops are equivelant to taking
# the negative of the condition of a while
# loop. For example:

until_loop_var_1 = 0

while (until_loop_var_1 >= 5)
  until_loop_var_1 += 1
end

# is the equivelant of the above while loop
# example


# 'for' loops iterate over a collection of
# objects or a range

for k in 0...5
  # iterates from 0 to 4
end

for k in [0, 2, 4]
  # iterates over the 3 values
end

# 'each' loops may be called upon
# any collection of objects and
# act in much the same way
# as for loops do

(0...5).each do |k|
  # iterates from 0 to 4
end

# note that the iteration value is specified by
# whatever token is provided between the '|' characters
# after the 'do' statement



# Loops have several control statements
# which will do various things:

# 'retry' statements will start the loop from the begining of iteration
# 'redo' statements will start the loop from the last value of iteration
# 'next' statements function in the same way 'continue' statements function in C
# 'break' statements function in the same way they do in C



##########################################################
# 7.1 Exceptions                                         #
##########################################################

# Exceptions may be thrown and caught using the 'raise',
# and 'rescue' statements respectively. For example:

begin

  # executed
  raise Exception::new("Exception message")
  # not executed

rescue Exception => e
  # executed. Scope variable 'e' provided
  # as the raised exception
else
  # not executed. Would be if no
  # exception were raised
ensure
  # executed. Is executed no
  # matter what
end

# the 'rescue' statement may also be
# devoid of a scope token



begin

  # executed
  raise Exception::new("Exception Message")
  # not executed

rescue Exception
  # executed
end



# One may also raise strings directy


begin

  # executed
  raise "Exception Message"
  # not executed

rescue Exception
  # executed
end



##########################################################
# 8. Classes                                             #
##########################################################


# classes can be declared in the global scope, or
# within a module. Class names must begin with a
# capital letter


# A class which extends by Object by default
class MyClassA

  # a variable of the class
  # inaccessable externally without
  # calling a method to get/set it's value
  @@class_variable = "hi"

  # constants within a class
  # are accessable externally
  # using the '::' operator
  # referencing the class name
  My_constant = 3.11


  # a 'static' or 'class' method. This method
  # can be called by referencing
  # the class name as the scope
  def self.my_class_method()
    printf("Hello from 'MyClassA::my_class_method'\n")
  end

  # an 'instance' method. This method
  # must be called upon an instance
  # of the encapsulating class
  def my_instance_method()
    printf("Hello from 'MyClassA.my_instance_method'\n")
  end

  # the initializer method. This method
  # is called when creating a new object,
  # and values passed to the 'new' method
  # are passed into this method.
  def initialize(param_1, param_2)
    # variables begining with '@' are instance variables of the object
    @val_1 = param_1
    @val_2 = param_2

  end

  # defines an instance accessor method for '@val_1'
  def val_1
    return @val_1
  end

  # defines an instance accessor method for '@val_2'
  # this would be equivelant to defining the above
  attr_reader :val_2


  # overrides 'to_s' method. The value of this
  # method will be retrieved whenever this object
  # is formatted into a string
  def to_s()
    return "val1: #{@val_1}, val2: #{@val_2}"
  end

end


# A class extending MyClassA
class MyClassB < MyClassA

  # Overrides base initializer in 'MyClassA'
  def initialize(param_1, param_2, param_3)
    super(param_1, param_2)
    @val_3 = param_3
  end

  attr_reader :val_3

  # overrides val-2 attr_reader method in the
  # superclass
  def val_2
    return @val_2 + 1
  end

end



# The above classes may be initialized as follows

my_object_1 = MyClassA::new(1, 2)
my_object_2 = MyClassA.new(9, 8)
my_object_3 = MyClassB::new(4, 5, 6)


# One may invoke the an instance method with
# the following syntax:

my_object_1.my_instance_method()

# As with inheritence in other OO languages,
# extending class instances may invoke
# instance methods previously declared
# in the super-class(es)

my_object_3.my_instance_method()

# Class methods must refer to the class
# not an instance of the class

MyClassA::my_class_method()

# or an extending class

MyClassB::my_class_method()


##########################################################
# 9. Modules                                             #
##########################################################

# modules are declared for the purposes of
# scoping and organizing. Access to internal
# objects / tokens within modules is provided
# by the '::' operator. Module names must
# begin with a capital letter.

# Modules function effectively as
# 'static only' classes


module MyModule

  # a module-scope field
  @@module_value = 4

  # class within the module.
  class MyClass

    def my_method
      printf("Hello from 'MyModue::MyClass::my_method'\n")
    end

  end

end

# instantiates an object of
# the class MyModule::MyClass
my_in_module_object = MyModule::MyClass::new()

my_in_module_object.my_method()





##########################################################
# 10. Importing / Requiring                              #
##########################################################

# To 'import' or 'include' another file, we use the
# 'require' method, which takes a single string

require 'json'

# To require something relative to the current path,
# one may either replace 'require' with' 'require_relative'
# or append './' to the provided string



def main()


end
