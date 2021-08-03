library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.VGA_pkg.all;

entity UART_to_VGA is
  generic (
    g_VIDEO_WIDTH : integer := 3;
    g_TOTAL_COLS  : integer := 800;
    g_TOTAL_ROWS  : integer := 525;
    g_ACTIVE_COLS : integer := 640;
    g_ACTIVE_ROWS : integer := 480;
    g_x_pos       : integer := 50;
    g_y_pos       : integer := 50
    );
  port (
    i_Clk     : in std_logic;
    i_HSync   : in std_logic;
    i_VSync   : in std_logic;
    i_char  : in string(1 to 1);
    --
    o_HSync     : out std_logic := '0';
    o_VSync     : out std_logic := '0';
    o_Red_Video : out std_logic_vector(g_VIDEO_WIDTH-1 downto 0);
    o_Grn_Video : out std_logic_vector(g_VIDEO_WIDTH-1 downto 0);
    o_Blu_Video : out std_logic_vector(g_VIDEO_WIDTH-1 downto 0)
    );
end entity UART_to_VGA;

architecture RTL of UART_to_VGA is

  component Sync_To_Count is
    generic (
      g_TOTAL_COLS : integer;
      g_TOTAL_ROWS : integer
      );
    port (
      i_Clk   : in std_logic;
      i_HSync : in std_logic;
      i_VSync : in std_logic;

      o_HSync     : out std_logic;
      o_VSync     : out std_logic;
      o_Col_Count : out std_logic_vector(9 downto 0);
      o_Row_Count : out std_logic_vector(9 downto 0)
      );
  end component Sync_To_Count;

  signal w_VSync : std_logic;
  signal w_HSync : std_logic;

  
  -- Create a type that contains all Test Patterns.
  -- Patterns have 16 indexes (0 to 15) and can be g_VIDEO_WIDTH bits wide
  --type t_Patterns is array (0 to 15) of std_logic_vector(g_VIDEO_WIDTH-1 downto 0);
  signal Pattern_Red : std_logic_vector(g_VIDEO_WIDTH-1 downto 0);
  signal Pattern_Grn : std_logic_vector(g_VIDEO_WIDTH-1 downto 0);
  signal Pattern_Blu : std_logic_vector(g_VIDEO_WIDTH-1 downto 0);

  
  
  -- Make these unsigned counters (always positive)
  --Col_Count is x position
  --Row_Count is y position
  signal w_Col_Count : std_logic_vector(9 downto 0);
  signal w_Row_Count : std_logic_vector(9 downto 0);

    --output pixel for the VGA text generation
    signal pixel : std_logic;
    --counter to increment through the string array "stringmap"
    signal r_string_counter : integer range 0 to stringmap'high := 0;
    --connects the stringmap array to the input of Pixel On Text
    signal w_string : string (1 to i_char'length);
    --connects x and y position arrays to input of Pixel On Text
    signal w_x_pos_text : integer range 0 to 2**w_Col_Count'length;
    signal w_y_pos_text : integer range 0 to 2**w_Row_Count'length;


  
begin
  
    --grab the input character to display
    w_string <= i_char;

  
  
  --sets output pixel for text generator
  --pixel is HIGH when the row/col count matcher to the character map
  textElement1: entity work.Pixel_On_Text
        generic map (
        	textLength => i_char'length,
            x_pos => g_x_pos,
            y_pos => g_y_pos
        )
        port map(
        	clk => i_Clk,
        	displayText => w_string,
        	horzCoord => to_integer(unsigned(w_Col_Count)),
        	vertCoord => to_integer(unsigned(w_Row_Count)),
        	pixel => pixel -- result
        );
  
  
  
  
  
  
  Sync_To_Count_inst : Sync_To_Count
    generic map (
      g_TOTAL_COLS => g_TOTAL_COLS,
      g_TOTAL_ROWS => g_TOTAL_ROWS
      )
    port map (
      i_Clk       => i_Clk,
      i_HSync     => i_HSync,
      i_VSync     => i_VSync,
      o_HSync     => w_HSync,
      o_VSync     => w_VSync,
      o_Col_Count => w_Col_Count,
      o_Row_Count => w_Row_Count
      );

  
  -- Register syncs to align with output data.
  p_Reg_Syncs : process (i_Clk) is
  begin
    if rising_edge(i_Clk) then
      o_VSync <= w_VSync;
      o_HSync <= w_HSync;
    end if;
  end process p_Reg_Syncs; 

  


  Pattern_Red <= (others => '1') when pixel = '1' else (others => '0');

                                          

  Pattern_Grn <= Pattern_Red;
  Pattern_Blu <= Pattern_Red;

  


  -----------------------------------------------------------------------------
  -- set output
  -----------------------------------------------------------------------------
  
          o_Red_Video <= Pattern_Red;
          o_Grn_Video <= Pattern_Grn;
          o_Blu_Video <= Pattern_Blu;
        
  

  
end architecture RTL;
