default: APP.ABS
	C:/SiLabs/MCU/IDEfiles/C51/BIN/oh51.exe app.ABS

APP.ABS: app.asm
	C:/SiLabs/MCU/IDEfiles/C51/BIN/a51.exe "app.asm" XR GEN DB EP NOMOD51
	C:/SiLabs/MCU/IDEfiles/C51/BIN/bl51.exe app.OBJ TO app.ABS

clean:
	rm app.hex app.OBJ app.lst APP.M51 APP.ABS