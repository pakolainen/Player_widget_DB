
local fontSpecs = {
  srcFile  = [[FreeSansBold.ttf]],
  family   = [[FreeSans]],
  style    = [[Bold]],
  yStep    = 8,
  height   = 8,
  xTexSize = 512,
  yTexSize = 128,
  outlineRadius = 2,
  outlineWeight = 100,
}

local glyphs = {}

glyphs[32] = { --' '--
  num = 32,
  adv = 2,
  oxn =   -2, oyn =   -3, oxp =    3, oyp =    2,
  txn =    1, tyn =    1, txp =    6, typ =    6,
}
glyphs[33] = { --'!'--
  num = 33,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =   15, tyn =    1, txp =   22, typ =   11,
}
glyphs[34] = { --'"'--
  num = 34,
  adv = 4,
  oxn =   -2, oyn =    1, oxp =    6, oyp =    8,
  txn =   29, tyn =    1, txp =   37, typ =    8,
}
glyphs[35] = { --'#'--
  num = 35,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =   43, tyn =    1, txp =   52, typ =   12,
}
glyphs[36] = { --'$'--
  num = 36,
  adv = 4,
  oxn =   -2, oyn =   -4, oxp =    7, oyp =    9,
  txn =   57, tyn =    1, txp =   66, typ =   14,
}
glyphs[37] = { --'%'--
  num = 37,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =    8,
  txn =   71, tyn =    1, txp =   82, typ =   12,
}
glyphs[38] = { --'&'--
  num = 38,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    8,
  txn =   85, tyn =    1, txp =   95, typ =   12,
}
glyphs[39] = { --'''--
  num = 39,
  adv = 2,
  oxn =   -2, oyn =    1, oxp =    4, oyp =    8,
  txn =   99, tyn =    1, txp =  105, typ =    8,
}
glyphs[40] = { --'('--
  num = 40,
  adv = 3,
  oxn =   -2, oyn =   -4, oxp =    5, oyp =    8,
  txn =  113, tyn =    1, txp =  120, typ =   13,
}
glyphs[41] = { --')'--
  num = 41,
  adv = 3,
  oxn =   -2, oyn =   -4, oxp =    5, oyp =    8,
  txn =  127, tyn =    1, txp =  134, typ =   13,
}
glyphs[42] = { --'*'--
  num = 42,
  adv = 3,
  oxn =   -2, oyn =    1, oxp =    5, oyp =    8,
  txn =  141, tyn =    1, txp =  148, typ =    8,
}
glyphs[43] = { --'+'--
  num = 43,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    6,
  txn =  155, tyn =    1, txp =  164, typ =   10,
}
glyphs[44] = { --','--
  num = 44,
  adv = 2,
  oxn =   -2, oyn =   -4, oxp =    4, oyp =    4,
  txn =  169, tyn =    1, txp =  175, typ =    9,
}
glyphs[45] = { --'-'--
  num = 45,
  adv = 3,
  oxn =   -2, oyn =   -1, oxp =    5, oyp =    5,
  txn =  183, tyn =    1, txp =  190, typ =    7,
}
glyphs[46] = { --'.'--
  num = 46,
  adv = 2,
  oxn =   -2, oyn =   -2, oxp =    4, oyp =    4,
  txn =  197, tyn =    1, txp =  203, typ =    7,
}
glyphs[47] = { --'/'--
  num = 47,
  adv = 2,
  oxn =   -2, oyn =   -3, oxp =    5, oyp =    8,
  txn =  211, tyn =    1, txp =  218, typ =   12,
}
glyphs[48] = { --'0'--
  num = 48,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =  225, tyn =    1, txp =  234, typ =   12,
}
glyphs[49] = { --'1'--
  num = 49,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    8,
  txn =  239, tyn =    1, txp =  247, typ =   11,
}
glyphs[50] = { --'2'--
  num = 50,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    8,
  txn =  253, tyn =    1, txp =  262, typ =   11,
}
glyphs[51] = { --'3'--
  num = 51,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =  267, tyn =    1, txp =  276, typ =   12,
}
glyphs[52] = { --'4'--
  num = 52,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    8,
  txn =  281, tyn =    1, txp =  290, typ =   11,
}
glyphs[53] = { --'5'--
  num = 53,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =  295, tyn =    1, txp =  304, typ =   12,
}
glyphs[54] = { --'6'--
  num = 54,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =  309, tyn =    1, txp =  318, typ =   12,
}
glyphs[55] = { --'7'--
  num = 55,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    8,
  txn =  323, tyn =    1, txp =  332, typ =   11,
}
glyphs[56] = { --'8'--
  num = 56,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =  337, tyn =    1, txp =  346, typ =   12,
}
glyphs[57] = { --'9'--
  num = 57,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =  351, tyn =    1, txp =  360, typ =   12,
}
glyphs[58] = { --':'--
  num = 58,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    7,
  txn =  365, tyn =    1, txp =  372, typ =   10,
}
glyphs[59] = { --';'--
  num = 59,
  adv = 3,
  oxn =   -2, oyn =   -4, oxp =    5, oyp =    7,
  txn =  379, tyn =    1, txp =  386, typ =   12,
}
glyphs[60] = { --'<'--
  num = 60,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    6,
  txn =  393, tyn =    1, txp =  402, typ =   10,
}
glyphs[61] = { --'='--
  num = 61,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    6,
  txn =  407, tyn =    1, txp =  416, typ =    9,
}
glyphs[62] = { --'>'--
  num = 62,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    6,
  txn =  421, tyn =    1, txp =  430, typ =   10,
}
glyphs[63] = { --'?'--
  num = 63,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    8,
  txn =  435, tyn =    1, txp =  444, typ =   11,
}
glyphs[64] = { --'@'--
  num = 64,
  adv = 8,
  oxn =   -2, oyn =   -4, oxp =   10, oyp =    8,
  txn =  449, tyn =    1, txp =  461, typ =   13,
}
glyphs[65] = { --'A'--
  num = 65,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    8,
  txn =  463, tyn =    1, txp =  473, typ =   11,
}
glyphs[66] = { --'B'--
  num = 66,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    8,
  txn =  477, tyn =    1, txp =  487, typ =   11,
}
glyphs[67] = { --'C'--
  num = 67,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    8,
  txn =  491, tyn =    1, txp =  501, typ =   12,
}
glyphs[68] = { --'D'--
  num = 68,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    8,
  txn =    1, tyn =   16, txp =   11, typ =   26,
}
glyphs[69] = { --'E'--
  num = 69,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    8,
  txn =   15, tyn =   16, txp =   24, typ =   26,
}
glyphs[70] = { --'F'--
  num = 70,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    8,
  txn =   29, tyn =   16, txp =   38, typ =   26,
}
glyphs[71] = { --'G'--
  num = 71,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    8,
  txn =   43, tyn =   16, txp =   53, typ =   27,
}
glyphs[72] = { --'H'--
  num = 72,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    8,
  txn =   57, tyn =   16, txp =   67, typ =   26,
}
glyphs[73] = { --'I'--
  num = 73,
  adv = 2,
  oxn =   -2, oyn =   -2, oxp =    4, oyp =    8,
  txn =   71, tyn =   16, txp =   77, typ =   26,
}
glyphs[74] = { --'J'--
  num = 74,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    6, oyp =    8,
  txn =   85, tyn =   16, txp =   93, typ =   27,
}
glyphs[75] = { --'K'--
  num = 75,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    8,
  txn =   99, tyn =   16, txp =  109, typ =   26,
}
glyphs[76] = { --'L'--
  num = 76,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    8,
  txn =  113, tyn =   16, txp =  122, typ =   26,
}
glyphs[77] = { --'M'--
  num = 77,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =    8,
  txn =  127, tyn =   16, txp =  138, typ =   26,
}
glyphs[78] = { --'N'--
  num = 78,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    8,
  txn =  141, tyn =   16, txp =  151, typ =   26,
}
glyphs[79] = { --'O'--
  num = 79,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    8,
  txn =  155, tyn =   16, txp =  165, typ =   27,
}
glyphs[80] = { --'P'--
  num = 80,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    8,
  txn =  169, tyn =   16, txp =  179, typ =   26,
}
glyphs[81] = { --'Q'--
  num = 81,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    8,
  txn =  183, tyn =   16, txp =  193, typ =   27,
}
glyphs[82] = { --'R'--
  num = 82,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    8,
  txn =  197, tyn =   16, txp =  207, typ =   26,
}
glyphs[83] = { --'S'--
  num = 83,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    8,
  txn =  211, tyn =   16, txp =  221, typ =   27,
}
glyphs[84] = { --'T'--
  num = 84,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    8,
  txn =  225, tyn =   16, txp =  234, typ =   26,
}
glyphs[85] = { --'U'--
  num = 85,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    8,
  txn =  239, tyn =   16, txp =  249, typ =   27,
}
glyphs[86] = { --'V'--
  num = 86,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    8,
  txn =  253, tyn =   16, txp =  263, typ =   26,
}
glyphs[87] = { --'W'--
  num = 87,
  adv = 8,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =    8,
  txn =  267, tyn =   16, txp =  279, typ =   26,
}
glyphs[88] = { --'X'--
  num = 88,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    8,
  txn =  281, tyn =   16, txp =  291, typ =   26,
}
glyphs[89] = { --'Y'--
  num = 89,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    8,
  txn =  295, tyn =   16, txp =  305, typ =   26,
}
glyphs[90] = { --'Z'--
  num = 90,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    8,
  txn =  309, tyn =   16, txp =  318, typ =   26,
}
glyphs[91] = { --'['--
  num = 91,
  adv = 3,
  oxn =   -2, oyn =   -4, oxp =    5, oyp =    8,
  txn =  323, tyn =   16, txp =  330, typ =   28,
}
glyphs[92] = { --'\'--
  num = 92,
  adv = 2,
  oxn =   -3, oyn =   -3, oxp =    5, oyp =    8,
  txn =  337, tyn =   16, txp =  345, typ =   27,
}
glyphs[93] = { --']'--
  num = 93,
  adv = 3,
  oxn =   -2, oyn =   -4, oxp =    5, oyp =    8,
  txn =  351, tyn =   16, txp =  358, typ =   28,
}
glyphs[94] = { --'^'--
  num = 94,
  adv = 5,
  oxn =   -2, oyn =    0, oxp =    7, oyp =    8,
  txn =  365, tyn =   16, txp =  374, typ =   24,
}
glyphs[95] = { --'_'--
  num = 95,
  adv = 4,
  oxn =   -3, oyn =   -4, oxp =    7, oyp =    2,
  txn =  379, tyn =   16, txp =  389, typ =   22,
}
glyphs[96] = { --'`'--
  num = 96,
  adv = 3,
  oxn =   -2, oyn =    2, oxp =    4, oyp =    9,
  txn =  393, tyn =   16, txp =  399, typ =   23,
}
glyphs[97] = { --'a'--
  num = 97,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    7,
  txn =  407, tyn =   16, txp =  416, typ =   26,
}
glyphs[98] = { --'b'--
  num = 98,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =  421, tyn =   16, txp =  430, typ =   27,
}
glyphs[99] = { --'c'--
  num = 99,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    7,
  txn =  435, tyn =   16, txp =  444, typ =   26,
}
glyphs[100] = { --'d'--
  num = 100,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =  449, tyn =   16, txp =  458, typ =   27,
}
glyphs[101] = { --'e'--
  num = 101,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    7,
  txn =  463, tyn =   16, txp =  472, typ =   26,
}
glyphs[102] = { --'f'--
  num = 102,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  477, tyn =   16, txp =  484, typ =   26,
}
glyphs[103] = { --'g'--
  num = 103,
  adv = 5,
  oxn =   -2, oyn =   -4, oxp =    7, oyp =    7,
  txn =  491, tyn =   16, txp =  500, typ =   27,
}
glyphs[104] = { --'h'--
  num = 104,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    8,
  txn =    1, tyn =   31, txp =   10, typ =   41,
}
glyphs[105] = { --'i'--
  num = 105,
  adv = 2,
  oxn =   -2, oyn =   -2, oxp =    4, oyp =    8,
  txn =   15, tyn =   31, txp =   21, typ =   41,
}
glyphs[106] = { --'j'--
  num = 106,
  adv = 2,
  oxn =   -2, oyn =   -4, oxp =    4, oyp =    8,
  txn =   29, tyn =   31, txp =   35, typ =   43,
}
glyphs[107] = { --'k'--
  num = 107,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    8,
  txn =   43, tyn =   31, txp =   52, typ =   41,
}
glyphs[108] = { --'l'--
  num = 108,
  adv = 2,
  oxn =   -2, oyn =   -2, oxp =    4, oyp =    8,
  txn =   57, tyn =   31, txp =   63, typ =   41,
}
glyphs[109] = { --'m'--
  num = 109,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =    7,
  txn =   71, tyn =   31, txp =   82, typ =   40,
}
glyphs[110] = { --'n'--
  num = 110,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    7,
  txn =   85, tyn =   31, txp =   94, typ =   40,
}
glyphs[111] = { --'o'--
  num = 111,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    7,
  txn =   99, tyn =   31, txp =  108, typ =   41,
}
glyphs[112] = { --'p'--
  num = 112,
  adv = 5,
  oxn =   -2, oyn =   -4, oxp =    7, oyp =    7,
  txn =  113, tyn =   31, txp =  122, typ =   42,
}
glyphs[113] = { --'q'--
  num = 113,
  adv = 5,
  oxn =   -2, oyn =   -4, oxp =    7, oyp =    7,
  txn =  127, tyn =   31, txp =  136, typ =   42,
}
glyphs[114] = { --'r'--
  num = 114,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    7,
  txn =  141, tyn =   31, txp =  148, typ =   40,
}
glyphs[115] = { --'s'--
  num = 115,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    7,
  txn =  155, tyn =   31, txp =  164, typ =   41,
}
glyphs[116] = { --'t'--
  num = 116,
  adv = 3,
  oxn =   -2, oyn =   -3, oxp =    5, oyp =    8,
  txn =  169, tyn =   31, txp =  176, typ =   42,
}
glyphs[117] = { --'u'--
  num = 117,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    7,
  txn =  183, tyn =   31, txp =  192, typ =   41,
}
glyphs[118] = { --'v'--
  num = 118,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    7,
  txn =  197, tyn =   31, txp =  206, typ =   40,
}
glyphs[119] = { --'w'--
  num = 119,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =    7,
  txn =  211, tyn =   31, txp =  222, typ =   40,
}
glyphs[120] = { --'x'--
  num = 120,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    7,
  txn =  225, tyn =   31, txp =  234, typ =   40,
}
glyphs[121] = { --'y'--
  num = 121,
  adv = 4,
  oxn =   -2, oyn =   -4, oxp =    7, oyp =    7,
  txn =  239, tyn =   31, txp =  248, typ =   42,
}
glyphs[122] = { --'z'--
  num = 122,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    7,
  txn =  253, tyn =   31, txp =  261, typ =   40,
}
glyphs[123] = { --'{'--
  num = 123,
  adv = 3,
  oxn =   -2, oyn =   -4, oxp =    5, oyp =    8,
  txn =  267, tyn =   31, txp =  274, typ =   43,
}
glyphs[124] = { --'|'--
  num = 124,
  adv = 2,
  oxn =   -2, oyn =   -4, oxp =    4, oyp =    8,
  txn =  281, tyn =   31, txp =  287, typ =   43,
}
glyphs[125] = { --'}'--
  num = 125,
  adv = 3,
  oxn =   -2, oyn =   -4, oxp =    5, oyp =    8,
  txn =  295, tyn =   31, txp =  302, typ =   43,
}
glyphs[126] = { --'~'--
  num = 126,
  adv = 5,
  oxn =   -2, oyn =   -1, oxp =    7, oyp =    5,
  txn =  309, tyn =   31, txp =  318, typ =   37,
}
glyphs[127] = { --''--
  num = 127,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  323, tyn =   31, txp =  330, typ =   41,
}
glyphs[128] = { --'Ä'--
  num = 128,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  337, tyn =   31, txp =  344, typ =   41,
}
glyphs[129] = { --'Å'--
  num = 129,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  351, tyn =   31, txp =  358, typ =   41,
}
glyphs[130] = { --'Ç'--
  num = 130,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  365, tyn =   31, txp =  372, typ =   41,
}
glyphs[131] = { --'É'--
  num = 131,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  379, tyn =   31, txp =  386, typ =   41,
}
glyphs[132] = { --'Ñ'--
  num = 132,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  393, tyn =   31, txp =  400, typ =   41,
}
glyphs[133] = { --'Ö'--
  num = 133,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  407, tyn =   31, txp =  414, typ =   41,
}
glyphs[134] = { --'Ü'--
  num = 134,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  421, tyn =   31, txp =  428, typ =   41,
}
glyphs[135] = { --'á'--
  num = 135,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  435, tyn =   31, txp =  442, typ =   41,
}
glyphs[136] = { --'à'--
  num = 136,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  449, tyn =   31, txp =  456, typ =   41,
}
glyphs[137] = { --'â'--
  num = 137,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  463, tyn =   31, txp =  470, typ =   41,
}
glyphs[138] = { --'ä'--
  num = 138,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  477, tyn =   31, txp =  484, typ =   41,
}
glyphs[139] = { --'ã'--
  num = 139,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  491, tyn =   31, txp =  498, typ =   41,
}
glyphs[140] = { --'å'--
  num = 140,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =    1, tyn =   46, txp =    8, typ =   56,
}
glyphs[141] = { --'ç'--
  num = 141,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =   15, tyn =   46, txp =   22, typ =   56,
}
glyphs[142] = { --'é'--
  num = 142,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =   29, tyn =   46, txp =   36, typ =   56,
}
glyphs[143] = { --'è'--
  num = 143,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =   43, tyn =   46, txp =   50, typ =   56,
}
glyphs[144] = { --'ê'--
  num = 144,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =   57, tyn =   46, txp =   64, typ =   56,
}
glyphs[145] = { --'ë'--
  num = 145,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =   71, tyn =   46, txp =   78, typ =   56,
}
glyphs[146] = { --'í'--
  num = 146,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =   85, tyn =   46, txp =   92, typ =   56,
}
glyphs[147] = { --'ì'--
  num = 147,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =   99, tyn =   46, txp =  106, typ =   56,
}
glyphs[148] = { --'î'--
  num = 148,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  113, tyn =   46, txp =  120, typ =   56,
}
glyphs[149] = { --'ï'--
  num = 149,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  127, tyn =   46, txp =  134, typ =   56,
}
glyphs[150] = { --'ñ'--
  num = 150,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  141, tyn =   46, txp =  148, typ =   56,
}
glyphs[151] = { --'ó'--
  num = 151,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  155, tyn =   46, txp =  162, typ =   56,
}
glyphs[152] = { --'ò'--
  num = 152,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  169, tyn =   46, txp =  176, typ =   56,
}
glyphs[153] = { --'ô'--
  num = 153,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  183, tyn =   46, txp =  190, typ =   56,
}
glyphs[154] = { --'ö'--
  num = 154,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  197, tyn =   46, txp =  204, typ =   56,
}
glyphs[155] = { --'õ'--
  num = 155,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  211, tyn =   46, txp =  218, typ =   56,
}
glyphs[156] = { --'ú'--
  num = 156,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  225, tyn =   46, txp =  232, typ =   56,
}
glyphs[157] = { --'ù'--
  num = 157,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  239, tyn =   46, txp =  246, typ =   56,
}
glyphs[158] = { --'û'--
  num = 158,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  253, tyn =   46, txp =  260, typ =   56,
}
glyphs[159] = { --'ü'--
  num = 159,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  267, tyn =   46, txp =  274, typ =   56,
}
glyphs[160] = { --'†'--
  num = 160,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  281, tyn =   46, txp =  288, typ =   56,
}
glyphs[161] = { --'°'--
  num = 161,
  adv = 3,
  oxn =   -2, oyn =   -4, oxp =    4, oyp =    7,
  txn =  295, tyn =   46, txp =  301, typ =   57,
}
glyphs[162] = { --'¢'--
  num = 162,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =  309, tyn =   46, txp =  318, typ =   57,
}
glyphs[163] = { --'£'--
  num = 163,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =  323, tyn =   46, txp =  332, typ =   57,
}
glyphs[164] = { --'§'--
  num = 164,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    7,
  txn =  337, tyn =   46, txp =  346, typ =   55,
}
glyphs[165] = { --'•'--
  num = 165,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    8,
  txn =  351, tyn =   46, txp =  360, typ =   56,
}
glyphs[166] = { --'¶'--
  num = 166,
  adv = 2,
  oxn =   -2, oyn =   -4, oxp =    4, oyp =    8,
  txn =  365, tyn =   46, txp =  371, typ =   58,
}
glyphs[167] = { --'ß'--
  num = 167,
  adv = 4,
  oxn =   -2, oyn =   -4, oxp =    7, oyp =    8,
  txn =  379, tyn =   46, txp =  388, typ =   58,
}
glyphs[168] = { --'®'--
  num = 168,
  adv = 3,
  oxn =   -2, oyn =    2, oxp =    5, oyp =    8,
  txn =  393, tyn =   46, txp =  400, typ =   52,
}
glyphs[169] = { --'©'--
  num = 169,
  adv = 6,
  oxn =   -3, oyn =   -3, oxp =    9, oyp =    8,
  txn =  407, tyn =   46, txp =  419, typ =   57,
}
glyphs[170] = { --'™'--
  num = 170,
  adv = 3,
  oxn =   -2, oyn =    0, oxp =    5, oyp =    8,
  txn =  421, tyn =   46, txp =  428, typ =   54,
}
glyphs[171] = { --'´'--
  num = 171,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    6,
  txn =  435, tyn =   46, txp =  443, typ =   54,
}
glyphs[172] = { --'¨'--
  num = 172,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    5,
  txn =  449, tyn =   46, txp =  458, typ =   53,
}
glyphs[173] = { --'≠'--
  num = 173,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  463, tyn =   46, txp =  470, typ =   56,
}
glyphs[174] = { --'Æ'--
  num = 174,
  adv = 6,
  oxn =   -3, oyn =   -3, oxp =    9, oyp =    8,
  txn =  477, tyn =   46, txp =  489, typ =   57,
}
glyphs[175] = { --'Ø'--
  num = 175,
  adv = 3,
  oxn =   -2, oyn =    3, oxp =    5, oyp =    8,
  txn =  491, tyn =   46, txp =  498, typ =   51,
}
glyphs[176] = { --'∞'--
  num = 176,
  adv = 5,
  oxn =   -1, oyn =    1, oxp =    6, oyp =    8,
  txn =    1, tyn =   61, txp =    8, typ =   68,
}
glyphs[177] = { --'±'--
  num = 177,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    7,
  txn =   15, tyn =   61, txp =   24, typ =   71,
}
glyphs[178] = { --'≤'--
  num = 178,
  adv = 3,
  oxn =   -2, oyn =    0, oxp =    5, oyp =    8,
  txn =   29, tyn =   61, txp =   36, typ =   69,
}
glyphs[179] = { --'≥'--
  num = 179,
  adv = 3,
  oxn =   -2, oyn =    0, oxp =    5, oyp =    8,
  txn =   43, tyn =   61, txp =   50, typ =   69,
}
glyphs[180] = { --'¥'--
  num = 180,
  adv = 3,
  oxn =   -2, oyn =    2, oxp =    5, oyp =    9,
  txn =   57, tyn =   61, txp =   64, typ =   68,
}
glyphs[181] = { --'µ'--
  num = 181,
  adv = 5,
  oxn =   -2, oyn =   -4, oxp =    7, oyp =    7,
  txn =   71, tyn =   61, txp =   80, typ =   72,
}
glyphs[182] = { --'∂'--
  num = 182,
  adv = 4,
  oxn =   -2, oyn =   -4, oxp =    7, oyp =    8,
  txn =   85, tyn =   61, txp =   94, typ =   73,
}
glyphs[183] = { --'∑'--
  num = 183,
  adv = 2,
  oxn =   -2, oyn =   -1, oxp =    4, oyp =    5,
  txn =   99, tyn =   61, txp =  105, typ =   67,
}
glyphs[184] = { --'∏'--
  num = 184,
  adv = 3,
  oxn =   -2, oyn =   -4, oxp =    5, oyp =    2,
  txn =  113, tyn =   61, txp =  120, typ =   67,
}
glyphs[185] = { --'π'--
  num = 185,
  adv = 3,
  oxn =   -2, oyn =    0, oxp =    4, oyp =    8,
  txn =  127, tyn =   61, txp =  133, typ =   69,
}
glyphs[186] = { --'∫'--
  num = 186,
  adv = 3,
  oxn =   -2, oyn =    0, oxp =    5, oyp =    8,
  txn =  141, tyn =   61, txp =  148, typ =   69,
}
glyphs[187] = { --'ª'--
  num = 187,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    6,
  txn =  155, tyn =   61, txp =  163, typ =   69,
}
glyphs[188] = { --'º'--
  num = 188,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =    8,
  txn =  169, tyn =   61, txp =  180, typ =   72,
}
glyphs[189] = { --'Ω'--
  num = 189,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =    8,
  txn =  183, tyn =   61, txp =  194, typ =   72,
}
glyphs[190] = { --'æ'--
  num = 190,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =    8,
  txn =  197, tyn =   61, txp =  208, typ =   72,
}
glyphs[191] = { --'ø'--
  num = 191,
  adv = 5,
  oxn =   -2, oyn =   -4, oxp =    7, oyp =    7,
  txn =  211, tyn =   61, txp =  220, typ =   72,
}
glyphs[192] = { --'¿'--
  num = 192,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   10,
  txn =  225, tyn =   61, txp =  235, typ =   73,
}
glyphs[193] = { --'¡'--
  num = 193,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   10,
  txn =  239, tyn =   61, txp =  249, typ =   73,
}
glyphs[194] = { --'¬'--
  num = 194,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   10,
  txn =  253, tyn =   61, txp =  263, typ =   73,
}
glyphs[195] = { --'√'--
  num = 195,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    9,
  txn =  267, tyn =   61, txp =  277, typ =   72,
}
glyphs[196] = { --'ƒ'--
  num = 196,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    9,
  txn =  281, tyn =   61, txp =  291, typ =   72,
}
glyphs[197] = { --'≈'--
  num = 197,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   10,
  txn =  295, tyn =   61, txp =  305, typ =   73,
}
glyphs[198] = { --'∆'--
  num = 198,
  adv = 8,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =    8,
  txn =  309, tyn =   61, txp =  321, typ =   71,
}
glyphs[199] = { --'«'--
  num = 199,
  adv = 6,
  oxn =   -2, oyn =   -4, oxp =    8, oyp =    8,
  txn =  323, tyn =   61, txp =  333, typ =   73,
}
glyphs[200] = { --'»'--
  num = 200,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   10,
  txn =  337, tyn =   61, txp =  346, typ =   73,
}
glyphs[201] = { --'…'--
  num = 201,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   10,
  txn =  351, tyn =   61, txp =  360, typ =   73,
}
glyphs[202] = { --' '--
  num = 202,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   10,
  txn =  365, tyn =   61, txp =  374, typ =   73,
}
glyphs[203] = { --'À'--
  num = 203,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    9,
  txn =  379, tyn =   61, txp =  388, typ =   72,
}
glyphs[204] = { --'Ã'--
  num = 204,
  adv = 2,
  oxn =   -2, oyn =   -2, oxp =    4, oyp =   10,
  txn =  393, tyn =   61, txp =  399, typ =   73,
}
glyphs[205] = { --'Õ'--
  num = 205,
  adv = 2,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =   10,
  txn =  407, tyn =   61, txp =  414, typ =   73,
}
glyphs[206] = { --'Œ'--
  num = 206,
  adv = 2,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =   10,
  txn =  421, tyn =   61, txp =  428, typ =   73,
}
glyphs[207] = { --'œ'--
  num = 207,
  adv = 2,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    9,
  txn =  435, tyn =   61, txp =  442, typ =   72,
}
glyphs[208] = { --'–'--
  num = 208,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    8,
  txn =  449, tyn =   61, txp =  459, typ =   71,
}
glyphs[209] = { --'—'--
  num = 209,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    9,
  txn =  463, tyn =   61, txp =  473, typ =   72,
}
glyphs[210] = { --'“'--
  num = 210,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  477, tyn =   61, txp =  487, typ =   74,
}
glyphs[211] = { --'”'--
  num = 211,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  491, tyn =   61, txp =  501, typ =   74,
}
glyphs[212] = { --'‘'--
  num = 212,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =    1, tyn =   76, txp =   11, typ =   89,
}
glyphs[213] = { --'’'--
  num = 213,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    9,
  txn =   15, tyn =   76, txp =   25, typ =   88,
}
glyphs[214] = { --'÷'--
  num = 214,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    9,
  txn =   29, tyn =   76, txp =   39, typ =   88,
}
glyphs[215] = { --'◊'--
  num = 215,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    6,
  txn =   43, tyn =   76, txp =   52, typ =   84,
}
glyphs[216] = { --'ÿ'--
  num = 216,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =    8,
  txn =   57, tyn =   76, txp =   68, typ =   87,
}
glyphs[217] = { --'Ÿ'--
  num = 217,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =   71, tyn =   76, txp =   81, typ =   89,
}
glyphs[218] = { --'⁄'--
  num = 218,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =   85, tyn =   76, txp =   95, typ =   89,
}
glyphs[219] = { --'€'--
  num = 219,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =   99, tyn =   76, txp =  109, typ =   89,
}
glyphs[220] = { --'‹'--
  num = 220,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    9,
  txn =  113, tyn =   76, txp =  123, typ =   88,
}
glyphs[221] = { --'›'--
  num = 221,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   10,
  txn =  127, tyn =   76, txp =  137, typ =   88,
}
glyphs[222] = { --'ﬁ'--
  num = 222,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    8,
  txn =  141, tyn =   76, txp =  151, typ =   86,
}
glyphs[223] = { --'ﬂ'--
  num = 223,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =  155, tyn =   76, txp =  164, typ =   87,
}
glyphs[224] = { --'‡'--
  num = 224,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    9,
  txn =  169, tyn =   76, txp =  178, typ =   88,
}
glyphs[225] = { --'·'--
  num = 225,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    9,
  txn =  183, tyn =   76, txp =  192, typ =   88,
}
glyphs[226] = { --'‚'--
  num = 226,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    9,
  txn =  197, tyn =   76, txp =  206, typ =   88,
}
glyphs[227] = { --'„'--
  num = 227,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =  211, tyn =   76, txp =  220, typ =   87,
}
glyphs[228] = { --'‰'--
  num = 228,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =  225, tyn =   76, txp =  234, typ =   87,
}
glyphs[229] = { --'Â'--
  num = 229,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    9,
  txn =  239, tyn =   76, txp =  248, typ =   88,
}
glyphs[230] = { --'Ê'--
  num = 230,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =    7,
  txn =  253, tyn =   76, txp =  264, typ =   86,
}
glyphs[231] = { --'Á'--
  num = 231,
  adv = 4,
  oxn =   -2, oyn =   -4, oxp =    7, oyp =    7,
  txn =  267, tyn =   76, txp =  276, typ =   87,
}
glyphs[232] = { --'Ë'--
  num = 232,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    9,
  txn =  281, tyn =   76, txp =  290, typ =   88,
}
glyphs[233] = { --'È'--
  num = 233,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    9,
  txn =  295, tyn =   76, txp =  304, typ =   88,
}
glyphs[234] = { --'Í'--
  num = 234,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    9,
  txn =  309, tyn =   76, txp =  318, typ =   88,
}
glyphs[235] = { --'Î'--
  num = 235,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =  323, tyn =   76, txp =  332, typ =   87,
}
glyphs[236] = { --'Ï'--
  num = 236,
  adv = 2,
  oxn =   -2, oyn =   -2, oxp =    4, oyp =    9,
  txn =  337, tyn =   76, txp =  343, typ =   87,
}
glyphs[237] = { --'Ì'--
  num = 237,
  adv = 2,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    9,
  txn =  351, tyn =   76, txp =  358, typ =   87,
}
glyphs[238] = { --'Ó'--
  num = 238,
  adv = 2,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    9,
  txn =  365, tyn =   76, txp =  372, typ =   87,
}
glyphs[239] = { --'Ô'--
  num = 239,
  adv = 2,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    8,
  txn =  379, tyn =   76, txp =  386, typ =   86,
}
glyphs[240] = { --''--
  num = 240,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =  393, tyn =   76, txp =  402, typ =   87,
}
glyphs[241] = { --'Ò'--
  num = 241,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    8,
  txn =  407, tyn =   76, txp =  416, typ =   86,
}
glyphs[242] = { --'Ú'--
  num = 242,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    9,
  txn =  421, tyn =   76, txp =  430, typ =   88,
}
glyphs[243] = { --'Û'--
  num = 243,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    9,
  txn =  435, tyn =   76, txp =  444, typ =   88,
}
glyphs[244] = { --'Ù'--
  num = 244,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    9,
  txn =  449, tyn =   76, txp =  458, typ =   88,
}
glyphs[245] = { --'ı'--
  num = 245,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =  463, tyn =   76, txp =  472, typ =   87,
}
glyphs[246] = { --'ˆ'--
  num = 246,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =  477, tyn =   76, txp =  486, typ =   87,
}
glyphs[247] = { --'˜'--
  num = 247,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    6,
  txn =  491, tyn =   76, txp =  500, typ =   85,
}
glyphs[248] = { --'¯'--
  num = 248,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    7,
  txn =    1, tyn =   91, txp =   10, typ =  101,
}
glyphs[249] = { --'˘'--
  num = 249,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    9,
  txn =   15, tyn =   91, txp =   24, typ =  103,
}
glyphs[250] = { --'˙'--
  num = 250,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    9,
  txn =   29, tyn =   91, txp =   38, typ =  103,
}
glyphs[251] = { --'˚'--
  num = 251,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    9,
  txn =   43, tyn =   91, txp =   52, typ =  103,
}
glyphs[252] = { --'¸'--
  num = 252,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =    8,
  txn =   57, tyn =   91, txp =   66, typ =  102,
}
glyphs[253] = { --'˝'--
  num = 253,
  adv = 4,
  oxn =   -2, oyn =   -4, oxp =    7, oyp =    9,
  txn =   71, tyn =   91, txp =   80, typ =  104,
}
glyphs[254] = { --'˛'--
  num = 254,
  adv = 5,
  oxn =   -2, oyn =   -4, oxp =    7, oyp =    8,
  txn =   85, tyn =   91, txp =   94, typ =  103,
}
glyphs[255] = { --'ˇ'--
  num = 255,
  adv = 4,
  oxn =   -2, oyn =   -4, oxp =    7, oyp =    8,
  txn =   99, tyn =   91, txp =  108, typ =  103,
}

fontSpecs.glyphs = glyphs

return fontSpecs

