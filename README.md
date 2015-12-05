# VGA-Text-Generator
<img src="https://cloud.githubusercontent.com/assets/6364170/11562333/5b6374c0-9a08-11e5-8af7-0967f38a6901.jpg" width="700">

A basic VGA text generator for printing text from FPGA to Monitor via VGA. The module is written in VHDL but it can work with Verilog and I'll show some usages below.  

# Environment
I'm using Vivado Webpack 2015.3 and Basys3 FPGA Dev Board for this project.

# Supported Characters
ASCII code 0 - 127

# Disclosure
- This little text generator is originally a part of my school projects. Unfortunately, the other parts such as how to handle vga and etc are exclude from this project since those files are wrriten by the school staffs and I don't have their consent. However, the code is relatively easy and short. You will be able to apply it after you understand the logic.
- This project is inspired by [MadLittleMods/FP-V-GA-Text](https://github.com/MadLittleMods/FP-V-GA-Text).
- I'm totally a newbie in Verilog and VHDL(couples week of school class for Verilog and learn VHDL by study MadLittleMods' code line by line). And this is why I'm trying to keep this project as simple as possible. A lot of the existing vga text module is too good/complex(sometimes due to optimisation) for me to understand and none of them fits my need.
- This project is just a generator without any(well, still has a bit of opt but easy to understand) optimisation. I hope this project will give you a quick start on printing text via vga. However, you may need to work a bit more to get some advance features such as dynamic text(I include a hint in wrapper.vhd), font size changing, font color changing and etc.

# Files
Most files are based on [MadLittleMods/FP-V-GA-Text](https://github.com/MadLittleMods/FP-V-GA-Text).
- **Font_Rom.vhd:** This module stores all the data of characters from ASCII 0 - 127. Basically, it is a long array contains all the characters. Each charactors contains 8 * 16 pixels. The module returns a row of character based on input address. See the file's comments for more detail.
- **Pixel_On_Text.vhd:** This module check if the input position is on the text pixel.
- **Pixel_On_Text2.vhd:** This module works the same as Pixel_On_Text.vhd and make it easy to be called from Verilog.
- **commonPak.vhd:** This file contains many constants for the project such as FONT_WIDTH, FONT_HEIGHT and some data structure such as point_2d.
- **wrapper.vhd:** This is a wrapper for using Pixel_On_Text.vhd in Verilog. It also contains a simple dynamic text sample.


# Usages
The idea of the text generator is simple. When the system updates each pixel on the screen, using Pixel_On_Text or Pixel_On_Text2 to know if this is a pixel on the text. Showing the text color when it's true and showing the background color when it's false.
Therefore, for the inputs, you need:

        1. VGA clock that update the screen
        2. text that you want to display
        3. position of the text(top left corner)
        4. current position

### Verilog
If you would like to call this generator's modules from Verilog, you can use:
- **Case 1:** Using Pixel_On_Text2.vhd (***Recommended***)
```verilog
        Pixel_On_Text2 #(.displayText("Pixel_On_Text2 -- test1 at (200,200)")) t1(
                CLK_VGA,
                200, // text position.x (top left)
                200, // text position.y (top left)
                VGA_horzCoord, // current position.x
                VGA_vertCoord, // current position.y
                res  // result, 1 if current pixel is on text, 0 otherwise
            );
```
- **Case 2:** Using Pixel_On_Text2.vhd by wrapper.vhd, display text and its position is defined in wrapper.vhd
```verilog
        wrapper tes(
                CLK_VGA,
                VGA_horzCoord, // current position.x
                VGA_vertCoord, // current position.y
                res // result, 1 if current pixel is on text, 0 otherwise
        );
```
### VHDL
If you would like to call this generator's modules from VHDL, you can use:
- **Case 1:** Using Pixel_On_Text.vhd
```vhdl
        textElement1: entity work.Pixel_On_Text
        generic map (
        	textLength => 38
        )
        port map(
        	clk => clk,
        	displayText => "Pixel_On_Text -- test 1!@#$ at (50,50)",
        	position => (50, 50), -- text position (top left)
        	horzCoord => h,
        	vertCoord => v,
        	pixel => d1 -- result
        );
```
- **Case 2:** Using Pixel_On_Text2.vhd
```vhdl
        textElement2: entity work.Pixel_On_Text2
        generic map (
        	displayText => "Pixel_On_Text -- test 2 at (600,600)"
        )
        port map(
        	clk => clk,
        	positionX => 600, -- text position.x (top left)
        	positionY => 600, -- text position.x (top left)
        	horzCoord => h,
        	vertCoord => v,
        	pixel => d1 -- result
        );
```

# Credit
[MadLittleMods/FP-V-GA-Text](https://github.com/MadLittleMods/FP-V-GA-Text)


License
-------
    The MIT License (MIT)
    
    Copyright (c) 2015 Derek Wang
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
