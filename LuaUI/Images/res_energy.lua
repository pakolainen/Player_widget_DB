local components = {}

local vsx, vsy = widgetHandler:GetViewSizes()

local offsetx, offsety


components[1] = { --"Energy bar, yellow"--
name='energy' ,

left = 81
top  = 12

tx1 = 81 --TL
ty1 = 393 

tx2 = 437 --BR
ty2 = 377

alpha = 1
}


components[2] = { --"Warning bar, dark red, should start to fade in sync with falling energy, starts from 10 percent. Or maybe make it blink faster and faster with glow on stall"--
name='warning' ,

left = 81
top  = 12

tx1 = 81 --TL
ty1 = 373 

tx2 = 437 --BR
ty2 = 357

alpha = 1
}


components[3] = { --"Share, postioned over first column"--
name='share' ,

left = 81
top  = 12

tx1 = 71 --TL
ty1 = 393 

tx2 = 76 --BR
ty2 = 377

alpha = 1
}


components[4] = { --"Surge 1"--
name='surge_1' ,

left = 0
top  = 0

tx1 = 0 --TL
ty1 = 345 

tx2 = 35 --BR
ty2 = 295

alpha = 1
}


components[5] = { --"Surge 2"--
name='surge_2' ,

left = 0
top  = 0

tx1 = 50 --TL
ty1 = 345

tx2 = 85 --BR
ty2 = 295

alpha = 1
}


components[6] = { --"Surge 3"--
name='surge_3' ,

left = 0
top  = 0

tx1 = 100 --TL
ty1 = 345 

tx2 = 135 --BR
ty2 = 295

alpha = 1
}


components[7] = { --"Surge 4"--
name='surge_4' ,

left = 0
top  = 0

tx1 = 150 --TL
ty1 = 345 

tx2 = 185 --BR
ty2 = 295

alpha = 1
}


components[8] = { --"base"--
name='base' ,

left = 0
top  = 0

tx1 = 0 --TL
ty1 = 465 

tx2 = 465 --BR
ty2 = 0

alpha = 1
}

