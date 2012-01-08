local components = {}

local vsx, vsy = widgetHandler:GetViewSizes()

local offsetx, offsety


components[1] = { --"Metal penis"--
name='metal' ,

left = 80
top  = 9 --11 for E bar

tx1 = 0 --TL
ty1 = 400 

tx2 = 360 --BR
ty2 = 377

alpha = 1
}


components[2] = { --"Furnace shadow, bottom most layer"--
name='furnace_shadow' ,

left = 0
top  = 0

tx1 = 0 --TL
ty1 = 375 

tx2 = 100 --BR
ty2 = 320

alpha = 1
}


components[3] = { --"Share mark, position at 10 percent, put this behind bars and base"--
name='share' ,

left = 108
top  = 9

tx1 = 108 --TL
ty1 = 366 

tx2 = 122 --BR
ty2 = 335

alpha = 1
}


components[4] = { --"Warning bars, glowing, fade them over bars"--
name='bars_glow' ,

left = 78
top  = 0

tx1 = 128 --TL
ty1 = 365 

tx2 = 171 --BR
ty2 = 327

alpha = 1
}


components[5] = { --"Warning bars, fade away when bars_glow are completely on"--
name='bars' ,

left = 78
top  = 0

tx1 = 178 --TL
ty1 = 365 

tx2 = 221 --BR
ty2 = 327

alpha = 1
}


components[6] = { --"Fire tray, move 5px down on animation"--
name='fire_tray' ,

left = 0
top  = 40

tx1 = 370 --TL
ty1 = 405 

tx2 = 444 --BR
ty2 = 381

alpha = 1
}


components[7] = { --"Fire, base, move 5px down on animation"--
name='fire' ,

left = 5
top  = 40

tx1 = 225 --TL
ty1 = 365 

tx2 = 285 --BR
ty2 = 350

alpha = 1
}


components[8] = { --"Fire, fadeaway, fade this over base fire to make it burn, move 5px down on animation"--
name='fire_fade' ,

left = 5
top  = 40

tx1 = 225 --TL
ty1 = 345 

tx2 = 285 --BR
ty2 = 330

alpha = 1
}


components[9] = { --"Exhaust glow, fades away when tray opens, needs to be below base"--
name='exhaust_glow' ,

left = 0
top  = 0

tx1 = 450 --TL
ty1 = 405 

tx2 = 462 --BR
ty2 = 375

alpha = 1
}


components[10] = { --"Grill glow, fades away when tray opens"--
name='grill_glow' ,

left = 10
top  = 25

tx1 = 290 --TL
ty1 = 370 

tx2 = 308 --BR
ty2 = 353

alpha = 1
}


components[11] = { --"M on, fades away when tray opens"--
name='M_on' ,

left = 0
top  = 0

tx1 = 320 --TL
ty1 = 375 

tx2 = 365 --BR
ty2 = 330

alpha = 1
}


components[12] = { --"M glow,fades away when tray opens, fade this over M_on to make it glow randomly"--
name='M_glow' ,

left = 0
top  = 0

tx1 = 370 --TL
ty1 = 375 

tx2 = 415 --BR
ty2 = 330

alpha = 1
}


components[13] = { --"base"--
name='base' ,

left = 0
top  = 0

tx1 = 0 --TL
ty1 = 465 

tx2 = 465 --BR
ty2 = 405

alpha = 1
}
