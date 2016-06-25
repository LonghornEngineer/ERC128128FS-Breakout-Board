CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 6_000_000


        LCD_RST = 5
        LCD_BLT = 6 
        LCD_SCL = 7
        LCD_SDA = 8

        ERC128128FS = %01111110


        
VAR
  byte LCD_X
  byte LCD_Y


OBJ

  I2C : "Basic_I2C_Driver_1.spin"
  PST : "Parallax Serial Terminal.spin"

PUB MAIN

  I2C.Initialize(LCD_SCL, LCD_SDA)
  PST.Start(115200)

  DIRA[LCD_BLT]~~
  DIRA[LCD_RST]~~

  OUTA[LCD_RST] := 0

  OUTA[LCD_BLT] := 0
  OUTA[LCD_RST] := 1


  'I2C.WriteByte(ERC128128FS, %0000_0000 | I2C#OneAddr, %0000_0000)

  I2C.WritePage(ERC128128FS, %0000_0000 | I2C#OneAddr, @LCD_INIT, 33)
  LCD_FILL
  LCD_CLEAR

  LCD_MOVE(20, 4)           
  repeat
    I2C.WritePage(ERC128128FS, %0100_0000 | I2C#OneAddr, @LCD_DATA_TEST, 12)               
    I2C.WritePage(ERC128128FS, %0100_0000 | I2C#OneAddr, @LCD_DATA_TEST, 12)
    I2C.WritePage(ERC128128FS, %0100_0000 | I2C#OneAddr, @LCD_DATA_TEST, 12)
  
  repeat

PUB LCD_MOVE(X,Y)
                                    
  LCD_X := X
  LCD_Y := Y

  LCD_MOVEDAT[0] := %10110000 | (Y & %00001111)
  LCD_MOVEDAT[1] := %00010000 | (((1 + (X * 6)) & %11110000 ) >> 4)
  LCD_MOVEDAT[2] := %00000000 | ((1 + (X * 6)) & %00001111 )

  I2C.WritePage(ERC128128FS, %0000_0000 | I2C#OneAddr, @LCD_MOVEDAT, 3)

  return

PUB LCD_CLEAR

  I2C.Start
  I2C.Write(ERC128128FS)
  I2C.Write(%0100_0000)

  repeat 4096
    I2C.Write(%0000_0000)

  I2C.Stop

  return

PUB LCD_FILL

  I2C.Start
  I2C.Write(ERC128128FS)
  I2C.Write(%0100_0000)

  repeat 4096
    I2C.Write(%1111_1111)

  I2C.Stop

  return
  
DAT

        LCD_INIT        byte    $38, $54, $AB, $66, $57, $48, $80, $27, $81, $1D, $2C, $2E, $2F, $93, $88, $00, $89, $00, $8A, $DD, $8B, $DD, $8C, $AA, $8D, $AA, $8E, $FF, $8F, $FF, $C8, %10100001, $AF

        LCD_DATA_TEST   byte    %00100110, %00100110, %01001001, %01001001, %01001001, %01001001, %01001001, %01001001, %00110010, %00110010, %00000000, %00000000, %01000001, %01000001, %01111111, %01111111, %01000001, %01000001

        LCD_MOVEDAT     byte    %00000000, %00000000, %00000000

        'http://mil.ufl.edu/4744/docs/lcdmanual/characterset.html
        
        LCD_CHAR        byte    %00000000, %00000000, %00000000, %00000000, %00000000,{                 SPACE
                        }       %00000000, %00000000, %01111001, %00000000, %00000000,{                 !
                        }       %00000000, %01110000, %00000000, %01110000, %00000000,{                 "
                        }       %00010100, %01111111, %00010100, %01111111, %00010100,{                 #
                        }       %00010010, %00101010, %01111111, %00101010, %00100100,{                 $
                        }       %01100010, %01100100, %00001000, %00010011, %00100011,{                 %
                        }       %00110110, %01001001, %01010101, %00100010, %00000101,{                 &
                        }       %00000000, %01010000, %01100000, %00000000, %00000000,{                 '
                        }       %00000000, %00011100, %00100010, %01000001, %00000000,{                 (
                        }       %00000000, %01000001, %00100010, %00011100, %00000000,{                 )
                        }       %00010100, %00001000, %00111110, %00001000, %00010100,{                 *
                        }       %00001000, %00001000, %00111110, %00001000, %00001000,{                 +
                        }       %00000000, %00000101, %00000110, %00000000, %00000000,{                 ,
                        }       %00001000, %00001000, %00001000, %00001000, %00001000,{                 -
                        }       %00000000, %00000011, %00000011, %00000000, %00000000,{                 .
                        }       %00000010, %00000100, %00001000, %00010000, %00100000,{                 /
                        }       %00111110, %01000101, %01001001, %01010001, %00111110,{                 0
                        }       %00000000, %00100001, %01111111, %00000001, %00000000,{                 1
                        }       %00100001, %01000011, %01000101, %01001001, %00110001,{                 2
                        }       %01000010, %01000001, %01010001, %01101001, %01000110,{                 3
                        }       %00001100, %00010100, %00100100, %01111111, %00000100,{                 4
                        }       %01110010, %01010001, %01010001, %01010001, %01001110,{                 5
                        }       %00011110, %00101001, %01001001, %01001001, %00000110,{                 6
                        }       %01000000, %01000111, %01001000, %01010000, %01100000,{                 7
                        }       %00110110, %01001001, %01001001, %01001001, %00110110,{                 8
                        }       %00110000, %01001001, %01001001, %01001010, %00111100,{                 9
                        }       %00000000, %00110110, %00110110, %00000000, %00000000,{                 :
                        }       %00000000, %00110101, %00110110, %00000000, %00000000,{                 ;
                        }       %00001000, %00010100, %00100010, %01000001, %00000000,{                 <
                        }       %00010100, %00010100, %00010100, %00010100, %00010100,{                 =
                        }       %00000000, %01000001, %00100010, %00010100, %00001000,{                 >
                        }       %00100000, %01000000, %01000101, %01001000, %00110000,{                 ?
                        }       %00100110, %01001001, %01001111, %01000001, %00111110,{                 @
                        }       %00111111, %01000100, %01000100, %01000100, %00111111,{                 A
                        }       %01111111, %01001001, %01001001, %01001001, %00110110,{                 B
                        }       %00111110, %01000001, %01000001, %01000001, %00100010,{                 C
                        }       %01111111, %01000001, %01000001, %00100010, %00011100,{                 D
                        }       %01111111, %01001001, %01001001, %01001001, %01000001,{                 E
                        }       %01111111, %01001000, %01001000, %01001000, %01000000,{                 F
                        }       %00111110, %01000001, %01001001, %01001001, %00101111,{                 G
                        }       %01111111, %00001000, %00001000, %00001000, %01111111,{                 H
                        }       %00000000, %01000001, %01111111, %01000001, %00000000,{                 I
                        }       %00000010, %00000001, %01000001, %01111110, %01000000,{                 J
                        }       %01111111, %00001000, %00010100, %00100010, %01000001,{                 K
                        }       %01111111, %00000001, %00000001, %00000001, %00000001,{                 L
                        }       %01111111, %00100000, %00011000, %00100000, %01111111,{                 M
                        }       %01111111, %00010000, %00001000, %00000100, %01111111,{                 N
                        }       %00111110, %01000001, %01000001, %01000001, %01111110,{                 O
                        }       %01111111, %01001000, %01001000, %01001000, %01100000,{                 P
                        }       %00111110, %01000001, %01000101, %01000010, %00111101,{                 Q
                        }       %01111111, %01001000, %01001100, %01001010, %00110001,{                 R
                        }       %00110001, %01001001, %01001001, %01001001, %01000110,{                 S
                        }       %01000000, %01000000, %01111111, %01000000, %01000000,{                 T
                        }       %01111110, %00000001, %00000001, %00000001, %01111110,{                 U
                        }       %01111100, %00000010, %00000001, %00000010, %01111100,{                 V
                        }       %01111110, %00000001, %00001110, %00000001, %01111110,{                 W
                        }       %01100011, %00010100, %00001000, %00010100, %01100011,{                 X
                        }       %01110000, %00001000, %00000111, %00001000, %01110000,{                 Y
                        }       %01000011, %01000101, %01001001, %01010001, %01100001,{                 Z
                        }
                        
                        