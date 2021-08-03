--GOAL: accept input from UART and display it on the VGA

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.VGA_pkg.all;
 
entity UART_to_VGA_Top is
  port (
    -- Main Clock (25 MHz)
    i_Clk         : in std_logic;
 
    -- UART Data
    i_UART_RX : in  std_logic;
    --o_UART_TX : out std_logic;
     
    -- VGA
    o_VGA_HSync : out std_logic;
    o_VGA_VSync : out std_logic;
    o_VGA_Red_0 : out std_logic;
    o_VGA_Red_1 : out std_logic;
    o_VGA_Red_2 : out std_logic;
    o_VGA_Grn_0 : out std_logic;
    o_VGA_Grn_1 : out std_logic;
    o_VGA_Grn_2 : out std_logic;
    o_VGA_Blu_0 : out std_logic;
    o_VGA_Blu_1 : out std_logic;
    o_VGA_Blu_2 : out std_logic
    );
end entity UART_to_VGA_Top;
 
architecture RTL of UART_to_VGA_Top is
 
  signal w_RX_DV     : std_logic;
  signal w_RX_Byte   : std_logic_vector(7 downto 0);
  --signal w_TX_Active : std_logic;
  --signal w_TX_Serial : std_logic;
  
   
 
  -- VGA Constants to set Frame Size
  constant c_VIDEO_WIDTH : integer := 3;
  constant c_TOTAL_COLS  : integer := 800;
  constant c_TOTAL_ROWS  : integer := 525;
  constant c_ACTIVE_COLS : integer := 640;
  constant c_ACTIVE_ROWS : integer := 480;

  --constants to set starting position of text
  constant c_x_pos : integer := 50;
  constant c_y_pos : integer := 50;
   
  --signal r_TP_Index        : std_logic_vector(3 downto 0) := (others => '0');
 
  -- Common VGA Signals
  signal w_HSync_VGA       : std_logic;
  signal w_VSync_VGA       : std_logic;
  signal w_HSync_Porch     : std_logic;
  signal w_VSync_Porch     : std_logic;
  signal w_Red_Video_Porch : std_logic_vector(c_VIDEO_WIDTH-1 downto 0);
  signal w_Grn_Video_Porch : std_logic_vector(c_VIDEO_WIDTH-1 downto 0);
  signal w_Blu_Video_Porch : std_logic_vector(c_VIDEO_WIDTH-1 downto 0);
 
  -- VGA Test Pattern Signals
  signal w_HSync_TP     : std_logic;
  signal w_VSync_TP     : std_logic;
  signal w_Red_Video_TP : std_logic_vector(c_VIDEO_WIDTH-1 downto 0);
  signal w_Grn_Video_TP : std_logic_vector(c_VIDEO_WIDTH-1 downto 0);
  signal w_Blu_Video_TP : std_logic_vector(c_VIDEO_WIDTH-1 downto 0);  

  --signal w_pixel  : std_logic;
  signal tmp_char : string(1 to 1);
   
begin

  --instantiate the UART receiver
  UART_RX_Inst : entity work.UART_RX
    generic map (
      g_CLKS_PER_BIT => 217)            -- 25,000,000 / 115,200
    port map (
      i_Clk       => i_Clk,
      i_RX_Serial => i_UART_RX,
      o_RX_DV     => w_RX_DV,
      o_RX_Byte   => w_RX_Byte);

    --convert the output byte to a char
    tmp_char <= char_to_str(w_RX_Byte);
  
   
  
  
  ------------------------------------------------------------------------------
  -- VGA 
  ------------------------------------------------------------------------------
  
   
  VGA_Sync_Pulses_inst : entity work.VGA_Sync_Pulses
    generic map (
      g_TOTAL_COLS  => c_TOTAL_COLS,
      g_TOTAL_ROWS  => c_TOTAL_ROWS,
      g_ACTIVE_COLS => c_ACTIVE_COLS,
      g_ACTIVE_ROWS => c_ACTIVE_ROWS
      )
    port map (
      i_Clk       => i_Clk,
      o_HSync     => w_HSync_VGA,
      o_VSync     => w_VSync_VGA,
      o_Col_Count => open,
      o_Row_Count => open
      );
 
  UART_to_VGA_inst : entity work.UART_to_VGA
    generic map (
      g_Video_Width => c_VIDEO_WIDTH,
      g_TOTAL_COLS  => c_TOTAL_COLS,
      g_TOTAL_ROWS  => c_TOTAL_ROWS,
      g_ACTIVE_COLS => c_ACTIVE_COLS,
      g_ACTIVE_ROWS => c_ACTIVE_ROWS,
      g_x_pos => c_x_pos,
      g_y_pos => c_y_pos
      )
    port map (
      i_Clk       => i_Clk,
      i_HSync     => w_HSync_VGA,
      i_VSync     => w_VSync_VGA,
      i_char     => tmp_char,
      --
      o_HSync     => w_HSync_TP,
      o_VSync     => w_VSync_TP,
      o_Red_Video => w_Red_Video_TP,
      o_Blu_Video => w_Blu_Video_TP,
      o_Grn_Video => w_Grn_Video_TP
      );

    
   
  VGA_Sync_Porch_Inst : entity work.VGA_Sync_Porch
    generic map (
      g_Video_Width => c_VIDEO_WIDTH,
      g_TOTAL_COLS  => c_TOTAL_COLS,
      g_TOTAL_ROWS  => c_TOTAL_ROWS,
      g_ACTIVE_COLS => c_ACTIVE_COLS,
      g_ACTIVE_ROWS => c_ACTIVE_ROWS 
      )
    port map (
      i_Clk       => i_Clk,
      i_HSync     => w_HSync_VGA,
      i_VSync     => w_VSync_VGA,
      i_Red_Video => w_Red_Video_TP,
      i_Grn_Video => w_Blu_Video_TP,
      i_Blu_Video => w_Grn_Video_TP,
      --
      o_HSync     => w_HSync_Porch,
      o_VSync     => w_VSync_Porch,
      o_Red_Video => w_Red_Video_Porch,
      o_Grn_Video => w_Blu_Video_Porch,
      o_Blu_Video => w_Grn_Video_Porch
      );
       
  o_VGA_HSync <= w_HSync_Porch;
  o_VGA_VSync <= w_VSync_Porch;
       
  o_VGA_Red_0 <= w_Red_Video_Porch(0);
  o_VGA_Red_1 <= w_Red_Video_Porch(1);
  o_VGA_Red_2 <= w_Red_Video_Porch(2);
   
  o_VGA_Grn_0 <= w_Grn_Video_Porch(0);
  o_VGA_Grn_1 <= w_Grn_Video_Porch(1);
  o_VGA_Grn_2 <= w_Grn_Video_Porch(2);
 
  o_VGA_Blu_0 <= w_Blu_Video_Porch(0);
  o_VGA_Blu_1 <= w_Blu_Video_Porch(1);
  o_VGA_Blu_2 <= w_Blu_Video_Porch(2);
   
end architecture RTL;