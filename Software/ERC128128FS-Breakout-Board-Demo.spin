CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 6_000_000


        LCD_RST = 5
        LCD_BLT = 6 
        LCD_SCL = 7
        LCD_SDA = 8

        ERC128128FS = %01111110


        
VAR
  byte ACK

   
OBJ

  I2C : "Basic_I2C_Driver_1.spin"
  PST : "Parallax Serial Terminal.spin"

  
PUB MAIN

  PST.Start(115200)
  I2C.Initialize(LCD_SCL, LCD_SDA)

  DIRA[LCD_BLT]~~
  DIRA[LCD_RST]~~

  OUTA[LCD_RST] := 0
  waitcnt(cnt+clkfreq)

  OUTA[LCD_BLT] := 0
  OUTA[LCD_RST] := 1


  'I2C.WriteByte(ERC128128FS, %0000_0000 | I2C#OneAddr, %0000_0000)

  I2C.WritePage(ERC128128FS, %0000_0000 | I2C#OneAddr, @LCD_INIT, 33)


  repeat 2048
    I2C.WriteWord(ERC128128FS, %0100_0000 | I2C#OneAddr, $FFFF)
    
  repeat 2048
    I2C.WriteWord(ERC128128FS, %0100_0000 | I2C#OneAddr, $0000)

  I2C.WritePage(ERC128128FS, %0100_0000 | I2C#OneAddr, @LCD_DATA_TEST, 20)               

  repeat

DAT

        LCD_INIT        byte    $38, $54, $AB, $66, $57, $48, $80, $27, $81, $1D, $2C, $2E, $2F, $93, $88, $00, $89, $00, $8A, $DD, $8B, $DD, $8C, $AA, $8D, $AA, $8E, $FF, $8F, $FF, $C8, %10100001, $AF

        LCD_DATA_TEST   byte    $00, %00100110, %00100110, %01001001, %01001001, %01001001, %01001001, %01001001, %01001001, %00110010, %00110010, %00000000, %00000000, %01000001, %01000001, %01111111, %01111111, %01000001, %01000001

