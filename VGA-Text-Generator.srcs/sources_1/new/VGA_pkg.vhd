-- Package file containing all Constants and Components used for VGA synthesis

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package VGA_pkg is

  -----------------------------------------------------------------------------
  -- Constants and bit patterns
  -----------------------------------------------------------------------------
   --array to test output of bit pattern. should output "test!" on the VGA
  type bitmap_type is array (0 to 14) of std_logic_vector(0 to 49);
	constant bitmap : bitmap_type := 
    (
        ("00000000000000000000000000000000000000000000000000"),
        ("00000000000000000000000000000000000000000000000000"),
        ("00000000000000000000000000000000000000000000000000"),
        ("00000000000000000000000000000000000000000000000000"),
        ("00000100000000000000000000000000001000000000110000"),
        ("00000100000000000000000000000000001000000000110000"),
        ("00001111000001111000000111100000011110000000110000"),
        ("00000100000011001100001000010000001000000000110000"),
        ("00000100000011111100001000000000001000000000110000"),
        ("00000100000010000000001111110000001000000000110000"),
        ("00000100000010000000000000010000001000000000000000"),
        ("00000100000010000000000000010000001000000000110000"),
        ("00000111000011111100001111100000001110000000110000"),
        ("00000000000000000000000000000000000000000000000000"),
        ("00000000000000000000000000000000000000000000000000")
    );
  
  type t_stringmap is array (0 to 4) of string(1 to 10);
  constant stringmap : t_stringmap :=
  (
    ("Empty     "),
    ("Test      "),
    ("Text      "),
    ("Generation"),
    ("On the VGA")
  );

  type t_x_pos_map is array (0 to 4) of integer;
  constant c_x_pos_map : t_x_pos_map :=
  (
    (50),
    (100),
    (300),
    (400),
    (500)
  );

  type t_y_pos_map is array (0 to 4) of integer;
  constant c_y_pos_map : t_y_pos_map :=
  (
    (50),
    (100),
    (200),
    (300),
    (400)
  );
  

  -----------------------------------------------------------------------------
  -- Numeric bit patterns for output to VGA for scorekeeping
  -----------------------------------------------------------------------------
  


  -----------------------------------------------------------------------------
  -- Component Declarations
  -----------------------------------------------------------------------------
  

  -----------------------------------------------------------------------------
  -- Function Declarations
  -----------------------------------------------------------------------------
    function int_to_str (
        int : in integer) 
        return string;

    function char_to_str (
        char : in character) 
        return string;    

    

  
end package VGA_pkg;  

package body VGA_pkg is

    --accepts a single character and returns it as a string
    function char_to_str (
        char : in std_logic_vector(7 downto 0)) 
        return string is 

        variable a : std_logic_vector(7 downto 0);
        variable r : string( 1 to 1);
    begin

        a := char;

        case a is
            when X"30"      => r := "0";
            when X"31"      => r := "1";
            when X"32"      => r := "2";
            when X"33"      => r := "3";
            when X"34"      => r := "4";
            when X"35"      => r := "5";
            when X"36"      => r := "6";
            when X"37"      => r := "7";
            when X"38"      => r := "8";
            when X"39"      => r := "9";
            when others     => r := "?";
        end case;

        return r;
    --accepts an integer 0 through 9 and returns it as a string value
    end char_to_str;        

    
    function int_to_str (
        int : in integer) 
        return string is

        variable a : natural := 0;
        variable r : string(1 to 1);

    begin
        a := abs (int);

        case a is
            when 0    => r := "0";
            when 1    => r := "1";
            when 2    => r := "2";
            when 3    => r := "3";
            when 4    => r := "4";
            when 5    => r := "5";
            when 6    => r := "6";
            when 7    => r := "7";
            when 8    => r := "8";
            when 9    => r := "9";
            when others => r := "?";
        end case;

        --if (int < 0) then
        --    r := '-' & r(1 to 1);
        --end if;

        return r;
    end int_to_str;
    
end package body VGA_pkg;




