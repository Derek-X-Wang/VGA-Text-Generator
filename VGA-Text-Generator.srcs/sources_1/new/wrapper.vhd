
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- note this line.The package is compiled to this directory by default.
-- so don't forget to include this directory. 
library work;
-- this line also is must.This includes the particular package into your program.
use work.commonPak.all;

entity wrapper is
  Port (
    clk: in std_logic;
    xCoord: in std_logic_vector(11 downto 0);
    yCoord: in std_logic_vector(11 downto 0);
    pixOn: out std_logic
   );
end wrapper;

architecture Behavioral of wrapper is
	
	signal h : integer := to_integer(signed(xCoord));
	signal v : integer := to_integer(signed(yCoord));
    
    signal d1 : std_logic := '0';
    signal d2 : std_logic := '0';
    signal d3 : std_logic := '0';
    
begin


	textElement1: entity work.Pixel_On_Text
	generic map (
		textLength => 38
	)
	port map(
		clk => clk,
		displayText => "Pixel_On_Text -- test 1!@#$ at (50,50)",
		position => (50, 50),
		horzCoord => h,
		vertCoord => v,
		pixel => d1
	);
	
	textElement2: entity work.Pixel_On_Text
	generic map (
		textLength => 39
	)
	port map(
		clk => clk,
		displayText => "Pixel_On_Text -- test 2%^&* at (500,50)",
		position => (500, 50),
		horzCoord => h,
		vertCoord => v,
		pixel => d2
	);
	
	textElement3: entity work.Pixel_On_Text
	generic map (
		textLength => 41
	)
	port map(
		clk => clk,
		displayText => "Pixel_On_Text -- test 3()_+-= at (50,130)",
		position => (50, 130),
		horzCoord => h,
		vertCoord => v,
		pixel => d3
	);
	
	pixelInTextGroup: process(clk)
        begin
            
            if rising_edge(clk) then
                -- the pixel is on when one of the text matched
                pixOn <= d1 or d2 or d3;

            end if;
        end process;

end Behavioral;
