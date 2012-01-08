
local fontSpecs = {
  srcFile  = [[FreeSansBold.ttf]],
  family   = [[FreeSans]],
  style    = [[Bold]],
  yStep    = 13,
  height   = 12,
  xTexSize = 512,
  yTexSize = 256,
  outlineRadius = 2,
  outlineWeight = 100,
}

local glyphs = {}

glyphs[32] = { --' '--
  num = 32,
  adv = 3,
  oxn =   -2, oyn =   -3, oxp =    3, oyp =    2,
  txn =    1, tyn =    1, txp =    6, typ =    6,
}
glyphs[33] = { --'!'--
  num = 33,
  adv = 4,
  oxn =   -1, oyn =   -2, oxp =    6, oyp =   11,
  txn =   19, tyn =    1, txp =   26, typ =   14,
}
glyphs[34] = { --'"'--
  num = 34,
  adv = 6,
  oxn =   -2, oyn =    3, oxp =    8, oyp =   11,
  txn =   37, tyn =    1, txp =   47, typ =    9,
}
glyphs[35] = { --'#'--
  num = 35,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =   55, tyn =    1, txp =   66, typ =   15,
}
glyphs[36] = { --'$'--
  num = 36,
  adv = 7,
  oxn =   -2, oyn =   -4, oxp =    9, oyp =   12,
  txn =   73, tyn =    1, txp =   84, typ =   17,
}
glyphs[37] = { --'%'--
  num = 37,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   11,
  txn =   91, tyn =    1, txp =  106, typ =   15,
}
glyphs[38] = { --'&'--
  num = 38,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   11, oyp =   11,
  txn =  109, tyn =    1, txp =  122, typ =   15,
}
glyphs[39] = { --'''--
  num = 39,
  adv = 3,
  oxn =   -2, oyn =    3, oxp =    5, oyp =   11,
  txn =  127, tyn =    1, txp =  134, typ =    9,
}
glyphs[40] = { --'('--
  num = 40,
  adv = 4,
  oxn =   -2, oyn =   -5, oxp =    6, oyp =   11,
  txn =  145, tyn =    1, txp =  153, typ =   17,
}
glyphs[41] = { --')'--
  num = 41,
  adv = 4,
  oxn =   -2, oyn =   -5, oxp =    6, oyp =   11,
  txn =  163, tyn =    1, txp =  171, typ =   17,
}
glyphs[42] = { --'*'--
  num = 42,
  adv = 5,
  oxn =   -2, oyn =    2, oxp =    7, oyp =   11,
  txn =  181, tyn =    1, txp =  190, typ =   10,
}
glyphs[43] = { --'+'--
  num = 43,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =    8,
  txn =  199, tyn =    1, txp =  210, typ =   12,
}
glyphs[44] = { --','--
  num = 44,
  adv = 3,
  oxn =   -2, oyn =   -5, oxp =    5, oyp =    4,
  txn =  217, tyn =    1, txp =  224, typ =   10,
}
glyphs[45] = { --'-'--
  num = 45,
  adv = 4,
  oxn =   -2, oyn =    0, oxp =    6, oyp =    7,
  txn =  235, tyn =    1, txp =  243, typ =    8,
}
glyphs[46] = { --'.'--
  num = 46,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    4,
  txn =  253, tyn =    1, txp =  260, typ =    7,
}
glyphs[47] = { --'/'--
  num = 47,
  adv = 3,
  oxn =   -2, oyn =   -3, oxp =    6, oyp =   11,
  txn =  271, tyn =    1, txp =  279, typ =   15,
}
glyphs[48] = { --'0'--
  num = 48,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =  289, tyn =    1, txp =  300, typ =   15,
}
glyphs[49] = { --'1'--
  num = 49,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  307, tyn =    1, txp =  316, typ =   14,
}
glyphs[50] = { --'2'--
  num = 50,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   11,
  txn =  325, tyn =    1, txp =  336, typ =   14,
}
glyphs[51] = { --'3'--
  num = 51,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =  343, tyn =    1, txp =  354, typ =   15,
}
glyphs[52] = { --'4'--
  num = 52,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   11,
  txn =  361, tyn =    1, txp =  372, typ =   14,
}
glyphs[53] = { --'5'--
  num = 53,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =  379, tyn =    1, txp =  390, typ =   15,
}
glyphs[54] = { --'6'--
  num = 54,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =  397, tyn =    1, txp =  408, typ =   15,
}
glyphs[55] = { --'7'--
  num = 55,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   11,
  txn =  415, tyn =    1, txp =  426, typ =   14,
}
glyphs[56] = { --'8'--
  num = 56,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =  433, tyn =    1, txp =  444, typ =   15,
}
glyphs[57] = { --'9'--
  num = 57,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =  451, tyn =    1, txp =  462, typ =   15,
}
glyphs[58] = { --':'--
  num = 58,
  adv = 4,
  oxn =   -1, oyn =   -2, oxp =    6, oyp =    9,
  txn =  469, tyn =    1, txp =  476, typ =   12,
}
glyphs[59] = { --';'--
  num = 59,
  adv = 4,
  oxn =   -1, oyn =   -5, oxp =    6, oyp =    9,
  txn =  487, tyn =    1, txp =  494, typ =   15,
}
glyphs[60] = { --'<'--
  num = 60,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =    8,
  txn =    1, tyn =   20, txp =   12, typ =   31,
}
glyphs[61] = { --'='--
  num = 61,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =    7,
  txn =   19, tyn =   20, txp =   30, typ =   29,
}
glyphs[62] = { --'>'--
  num = 62,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =    8,
  txn =   37, tyn =   20, txp =   48, typ =   31,
}
glyphs[63] = { --'?'--
  num = 63,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   11,
  txn =   55, tyn =   20, txp =   66, typ =   33,
}
glyphs[64] = { --'@'--
  num = 64,
  adv = 12,
  oxn =   -2, oyn =   -4, oxp =   14, oyp =   11,
  txn =   73, tyn =   20, txp =   89, typ =   35,
}
glyphs[65] = { --'A'--
  num = 65,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   11, oyp =   11,
  txn =   91, tyn =   20, txp =  104, typ =   33,
}
glyphs[66] = { --'B'--
  num = 66,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   11,
  txn =  109, tyn =   20, txp =  121, typ =   33,
}
glyphs[67] = { --'C'--
  num = 67,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   11, oyp =   11,
  txn =  127, tyn =   20, txp =  140, typ =   34,
}
glyphs[68] = { --'D'--
  num = 68,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   11, oyp =   11,
  txn =  145, tyn =   20, txp =  158, typ =   33,
}
glyphs[69] = { --'E'--
  num = 69,
  adv = 8,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   11,
  txn =  163, tyn =   20, txp =  175, typ =   33,
}
glyphs[70] = { --'F'--
  num = 70,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   11,
  txn =  181, tyn =   20, txp =  193, typ =   33,
}
glyphs[71] = { --'G'--
  num = 71,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   11, oyp =   11,
  txn =  199, tyn =   20, txp =  212, typ =   34,
}
glyphs[72] = { --'H'--
  num = 72,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   11,
  txn =  217, tyn =   20, txp =  229, typ =   33,
}
glyphs[73] = { --'I'--
  num = 73,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =   11,
  txn =  235, tyn =   20, txp =  242, typ =   33,
}
glyphs[74] = { --'J'--
  num = 74,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   11,
  txn =  253, tyn =   20, txp =  263, typ =   34,
}
glyphs[75] = { --'K'--
  num = 75,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   11, oyp =   11,
  txn =  271, tyn =   20, txp =  284, typ =   33,
}
glyphs[76] = { --'L'--
  num = 76,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   11,
  txn =  289, tyn =   20, txp =  300, typ =   33,
}
glyphs[77] = { --'M'--
  num = 77,
  adv = 10,
  oxn =   -2, oyn =   -2, oxp =   12, oyp =   11,
  txn =  307, tyn =   20, txp =  321, typ =   33,
}
glyphs[78] = { --'N'--
  num = 78,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   11,
  txn =  325, tyn =   20, txp =  337, typ =   33,
}
glyphs[79] = { --'O'--
  num = 79,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   11, oyp =   11,
  txn =  343, tyn =   20, txp =  356, typ =   34,
}
glyphs[80] = { --'P'--
  num = 80,
  adv = 8,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   11,
  txn =  361, tyn =   20, txp =  373, typ =   33,
}
glyphs[81] = { --'Q'--
  num = 81,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   11, oyp =   11,
  txn =  379, tyn =   20, txp =  392, typ =   34,
}
glyphs[82] = { --'R'--
  num = 82,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   11, oyp =   11,
  txn =  397, tyn =   20, txp =  410, typ =   33,
}
glyphs[83] = { --'S'--
  num = 83,
  adv = 8,
  oxn =   -2, oyn =   -3, oxp =   10, oyp =   11,
  txn =  415, tyn =   20, txp =  427, typ =   34,
}
glyphs[84] = { --'T'--
  num = 84,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   11,
  txn =  433, tyn =   20, txp =  445, typ =   33,
}
glyphs[85] = { --'U'--
  num = 85,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   10, oyp =   11,
  txn =  451, tyn =   20, txp =  463, typ =   34,
}
glyphs[86] = { --'V'--
  num = 86,
  adv = 8,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   11,
  txn =  469, tyn =   20, txp =  481, typ =   33,
}
glyphs[87] = { --'W'--
  num = 87,
  adv = 11,
  oxn =   -2, oyn =   -2, oxp =   14, oyp =   11,
  txn =  487, tyn =   20, txp =  503, typ =   33,
}
glyphs[88] = { --'X'--
  num = 88,
  adv = 8,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   11,
  txn =    1, tyn =   39, txp =   13, typ =   52,
}
glyphs[89] = { --'Y'--
  num = 89,
  adv = 8,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   11,
  txn =   19, tyn =   39, txp =   31, typ =   52,
}
glyphs[90] = { --'Z'--
  num = 90,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   11,
  txn =   37, tyn =   39, txp =   48, typ =   52,
}
glyphs[91] = { --'['--
  num = 91,
  adv = 4,
  oxn =   -2, oyn =   -5, oxp =    6, oyp =   11,
  txn =   55, tyn =   39, txp =   63, typ =   55,
}
glyphs[92] = { --'\'--
  num = 92,
  adv = 3,
  oxn =   -3, oyn =   -3, oxp =    6, oyp =   11,
  txn =   73, tyn =   39, txp =   82, typ =   53,
}
glyphs[93] = { --']'--
  num = 93,
  adv = 4,
  oxn =   -2, oyn =   -5, oxp =    6, oyp =   11,
  txn =   91, tyn =   39, txp =   99, typ =   55,
}
glyphs[94] = { --'^'--
  num = 94,
  adv = 7,
  oxn =   -2, oyn =    1, oxp =    9, oyp =   11,
  txn =  109, tyn =   39, txp =  120, typ =   49,
}
glyphs[95] = { --'_'--
  num = 95,
  adv = 7,
  oxn =   -3, oyn =   -5, oxp =    9, oyp =    1,
  txn =  127, tyn =   39, txp =  139, typ =   45,
}
glyphs[96] = { --'`'--
  num = 96,
  adv = 4,
  oxn =   -2, oyn =    5, oxp =    5, oyp =   12,
  txn =  145, tyn =   39, txp =  152, typ =   46,
}
glyphs[97] = { --'a'--
  num = 97,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =    9,
  txn =  163, tyn =   39, txp =  174, typ =   51,
}
glyphs[98] = { --'b'--
  num = 98,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =  181, tyn =   39, txp =  192, typ =   53,
}
glyphs[99] = { --'c'--
  num = 99,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =    9,
  txn =  199, tyn =   39, txp =  210, typ =   51,
}
glyphs[100] = { --'d'--
  num = 100,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =  217, tyn =   39, txp =  228, typ =   53,
}
glyphs[101] = { --'e'--
  num = 101,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =    9,
  txn =  235, tyn =   39, txp =  246, typ =   51,
}
glyphs[102] = { --'f'--
  num = 102,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =   11,
  txn =  253, tyn =   39, txp =  261, typ =   52,
}
glyphs[103] = { --'g'--
  num = 103,
  adv = 7,
  oxn =   -2, oyn =   -5, oxp =    9, oyp =    9,
  txn =  271, tyn =   39, txp =  282, typ =   53,
}
glyphs[104] = { --'h'--
  num = 104,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   11,
  txn =  289, tyn =   39, txp =  300, typ =   52,
}
glyphs[105] = { --'i'--
  num = 105,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =   11,
  txn =  307, tyn =   39, txp =  314, typ =   52,
}
glyphs[106] = { --'j'--
  num = 106,
  adv = 3,
  oxn =   -2, oyn =   -5, oxp =    5, oyp =   11,
  txn =  325, tyn =   39, txp =  332, typ =   55,
}
glyphs[107] = { --'k'--
  num = 107,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   11,
  txn =  343, tyn =   39, txp =  354, typ =   52,
}
glyphs[108] = { --'l'--
  num = 108,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =   11,
  txn =  361, tyn =   39, txp =  368, typ =   52,
}
glyphs[109] = { --'m'--
  num = 109,
  adv = 11,
  oxn =   -2, oyn =   -2, oxp =   12, oyp =    9,
  txn =  379, tyn =   39, txp =  393, typ =   50,
}
glyphs[110] = { --'n'--
  num = 110,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =    9,
  txn =  397, tyn =   39, txp =  408, typ =   50,
}
glyphs[111] = { --'o'--
  num = 111,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =    9,
  txn =  415, tyn =   39, txp =  426, typ =   51,
}
glyphs[112] = { --'p'--
  num = 112,
  adv = 7,
  oxn =   -2, oyn =   -5, oxp =    9, oyp =    9,
  txn =  433, tyn =   39, txp =  444, typ =   53,
}
glyphs[113] = { --'q'--
  num = 113,
  adv = 7,
  oxn =   -2, oyn =   -5, oxp =    9, oyp =    9,
  txn =  451, tyn =   39, txp =  462, typ =   53,
}
glyphs[114] = { --'r'--
  num = 114,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    9,
  txn =  469, tyn =   39, txp =  478, typ =   50,
}
glyphs[115] = { --'s'--
  num = 115,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =    9,
  txn =  487, tyn =   39, txp =  498, typ =   51,
}
glyphs[116] = { --'t'--
  num = 116,
  adv = 4,
  oxn =   -2, oyn =   -3, oxp =    6, oyp =   11,
  txn =    1, tyn =   58, txp =    9, typ =   72,
}
glyphs[117] = { --'u'--
  num = 117,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =    9,
  txn =   19, tyn =   58, txp =   30, typ =   70,
}
glyphs[118] = { --'v'--
  num = 118,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =    9,
  txn =   37, tyn =   58, txp =   48, typ =   69,
}
glyphs[119] = { --'w'--
  num = 119,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   12, oyp =    9,
  txn =   55, tyn =   58, txp =   69, typ =   69,
}
glyphs[120] = { --'x'--
  num = 120,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =    9,
  txn =   73, tyn =   58, txp =   84, typ =   69,
}
glyphs[121] = { --'y'--
  num = 121,
  adv = 7,
  oxn =   -2, oyn =   -5, oxp =    9, oyp =    9,
  txn =   91, tyn =   58, txp =  102, typ =   72,
}
glyphs[122] = { --'z'--
  num = 122,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    9,
  txn =  109, tyn =   58, txp =  119, typ =   69,
}
glyphs[123] = { --'{'--
  num = 123,
  adv = 5,
  oxn =   -2, oyn =   -5, oxp =    6, oyp =   11,
  txn =  127, tyn =   58, txp =  135, typ =   74,
}
glyphs[124] = { --'|'--
  num = 124,
  adv = 3,
  oxn =   -1, oyn =   -5, oxp =    5, oyp =   11,
  txn =  145, tyn =   58, txp =  151, typ =   74,
}
glyphs[125] = { --'}'--
  num = 125,
  adv = 5,
  oxn =   -2, oyn =   -5, oxp =    7, oyp =   11,
  txn =  163, tyn =   58, txp =  172, typ =   74,
}
glyphs[126] = { --'~'--
  num = 126,
  adv = 7,
  oxn =   -2, oyn =   -1, oxp =    9, oyp =    6,
  txn =  181, tyn =   58, txp =  192, typ =   65,
}
glyphs[127] = { --''--
  num = 127,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  199, tyn =   58, txp =  208, typ =   71,
}
glyphs[128] = { --'Ä'--
  num = 128,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  217, tyn =   58, txp =  226, typ =   71,
}
glyphs[129] = { --'Å'--
  num = 129,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  235, tyn =   58, txp =  244, typ =   71,
}
glyphs[130] = { --'Ç'--
  num = 130,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  253, tyn =   58, txp =  262, typ =   71,
}
glyphs[131] = { --'É'--
  num = 131,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  271, tyn =   58, txp =  280, typ =   71,
}
glyphs[132] = { --'Ñ'--
  num = 132,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  289, tyn =   58, txp =  298, typ =   71,
}
glyphs[133] = { --'Ö'--
  num = 133,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  307, tyn =   58, txp =  316, typ =   71,
}
glyphs[134] = { --'Ü'--
  num = 134,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  325, tyn =   58, txp =  334, typ =   71,
}
glyphs[135] = { --'á'--
  num = 135,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  343, tyn =   58, txp =  352, typ =   71,
}
glyphs[136] = { --'à'--
  num = 136,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  361, tyn =   58, txp =  370, typ =   71,
}
glyphs[137] = { --'â'--
  num = 137,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  379, tyn =   58, txp =  388, typ =   71,
}
glyphs[138] = { --'ä'--
  num = 138,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  397, tyn =   58, txp =  406, typ =   71,
}
glyphs[139] = { --'ã'--
  num = 139,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  415, tyn =   58, txp =  424, typ =   71,
}
glyphs[140] = { --'å'--
  num = 140,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  433, tyn =   58, txp =  442, typ =   71,
}
glyphs[141] = { --'ç'--
  num = 141,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  451, tyn =   58, txp =  460, typ =   71,
}
glyphs[142] = { --'é'--
  num = 142,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  469, tyn =   58, txp =  478, typ =   71,
}
glyphs[143] = { --'è'--
  num = 143,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  487, tyn =   58, txp =  496, typ =   71,
}
glyphs[144] = { --'ê'--
  num = 144,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =    1, tyn =   77, txp =   10, typ =   90,
}
glyphs[145] = { --'ë'--
  num = 145,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =   19, tyn =   77, txp =   28, typ =   90,
}
glyphs[146] = { --'í'--
  num = 146,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =   37, tyn =   77, txp =   46, typ =   90,
}
glyphs[147] = { --'ì'--
  num = 147,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =   55, tyn =   77, txp =   64, typ =   90,
}
glyphs[148] = { --'î'--
  num = 148,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =   73, tyn =   77, txp =   82, typ =   90,
}
glyphs[149] = { --'ï'--
  num = 149,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =   91, tyn =   77, txp =  100, typ =   90,
}
glyphs[150] = { --'ñ'--
  num = 150,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  109, tyn =   77, txp =  118, typ =   90,
}
glyphs[151] = { --'ó'--
  num = 151,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  127, tyn =   77, txp =  136, typ =   90,
}
glyphs[152] = { --'ò'--
  num = 152,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  145, tyn =   77, txp =  154, typ =   90,
}
glyphs[153] = { --'ô'--
  num = 153,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  163, tyn =   77, txp =  172, typ =   90,
}
glyphs[154] = { --'ö'--
  num = 154,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  181, tyn =   77, txp =  190, typ =   90,
}
glyphs[155] = { --'õ'--
  num = 155,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  199, tyn =   77, txp =  208, typ =   90,
}
glyphs[156] = { --'ú'--
  num = 156,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  217, tyn =   77, txp =  226, typ =   90,
}
glyphs[157] = { --'ù'--
  num = 157,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  235, tyn =   77, txp =  244, typ =   90,
}
glyphs[158] = { --'û'--
  num = 158,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  253, tyn =   77, txp =  262, typ =   90,
}
glyphs[159] = { --'ü'--
  num = 159,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  271, tyn =   77, txp =  280, typ =   90,
}
glyphs[160] = { --'†'--
  num = 160,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =  289, tyn =   77, txp =  298, typ =   90,
}
glyphs[161] = { --'°'--
  num = 161,
  adv = 4,
  oxn =   -2, oyn =   -5, oxp =    5, oyp =    9,
  txn =  307, tyn =   77, txp =  314, typ =   91,
}
glyphs[162] = { --'¢'--
  num = 162,
  adv = 7,
  oxn =   -2, oyn =   -4, oxp =    9, oyp =   10,
  txn =  325, tyn =   77, txp =  336, typ =   91,
}
glyphs[163] = { --'£'--
  num = 163,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =  343, tyn =   77, txp =  354, typ =   91,
}
glyphs[164] = { --'§'--
  num = 164,
  adv = 7,
  oxn =   -2, oyn =   -1, oxp =    9, oyp =   10,
  txn =  361, tyn =   77, txp =  372, typ =   88,
}
glyphs[165] = { --'•'--
  num = 165,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   11,
  txn =  379, tyn =   77, txp =  390, typ =   90,
}
glyphs[166] = { --'¶'--
  num = 166,
  adv = 3,
  oxn =   -1, oyn =   -5, oxp =    5, oyp =   11,
  txn =  397, tyn =   77, txp =  403, typ =   93,
}
glyphs[167] = { --'ß'--
  num = 167,
  adv = 7,
  oxn =   -2, oyn =   -5, oxp =    9, oyp =   11,
  txn =  415, tyn =   77, txp =  426, typ =   93,
}
glyphs[168] = { --'®'--
  num = 168,
  adv = 4,
  oxn =   -2, oyn =    5, oxp =    6, oyp =   11,
  txn =  433, tyn =   77, txp =  441, typ =   83,
}
glyphs[169] = { --'©'--
  num = 169,
  adv = 9,
  oxn =   -3, oyn =   -3, oxp =   12, oyp =   11,
  txn =  451, tyn =   77, txp =  466, typ =   91,
}
glyphs[170] = { --'™'--
  num = 170,
  adv = 4,
  oxn =   -2, oyn =    1, oxp =    6, oyp =   11,
  txn =  469, tyn =   77, txp =  477, typ =   87,
}
glyphs[171] = { --'´'--
  num = 171,
  adv = 7,
  oxn =   -1, oyn =   -2, oxp =    8, oyp =    8,
  txn =  487, tyn =   77, txp =  496, typ =   87,
}
glyphs[172] = { --'¨'--
  num = 172,
  adv = 7,
  oxn =   -2, oyn =   -1, oxp =    9, oyp =    7,
  txn =    1, tyn =   96, txp =   12, typ =  104,
}
glyphs[173] = { --'≠'--
  num = 173,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =   11,
  txn =   19, tyn =   96, txp =   28, typ =  109,
}
glyphs[174] = { --'Æ'--
  num = 174,
  adv = 9,
  oxn =   -3, oyn =   -3, oxp =   12, oyp =   11,
  txn =   37, tyn =   96, txp =   52, typ =  110,
}
glyphs[175] = { --'Ø'--
  num = 175,
  adv = 4,
  oxn =   -2, oyn =    5, oxp =    6, oyp =   11,
  txn =   55, tyn =   96, txp =   63, typ =  102,
}
glyphs[176] = { --'∞'--
  num = 176,
  adv = 7,
  oxn =   -1, oyn =    2, oxp =    8, oyp =   11,
  txn =   73, tyn =   96, txp =   82, typ =  105,
}
glyphs[177] = { --'±'--
  num = 177,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   10,
  txn =   91, tyn =   96, txp =  102, typ =  109,
}
glyphs[178] = { --'≤'--
  num = 178,
  adv = 4,
  oxn =   -2, oyn =    1, oxp =    6, oyp =   11,
  txn =  109, tyn =   96, txp =  117, typ =  106,
}
glyphs[179] = { --'≥'--
  num = 179,
  adv = 4,
  oxn =   -2, oyn =    1, oxp =    6, oyp =   11,
  txn =  127, tyn =   96, txp =  135, typ =  106,
}
glyphs[180] = { --'¥'--
  num = 180,
  adv = 4,
  oxn =   -1, oyn =    5, oxp =    6, oyp =   12,
  txn =  145, tyn =   96, txp =  152, typ =  103,
}
glyphs[181] = { --'µ'--
  num = 181,
  adv = 7,
  oxn =   -2, oyn =   -5, oxp =    9, oyp =    9,
  txn =  163, tyn =   96, txp =  174, typ =  110,
}
glyphs[182] = { --'∂'--
  num = 182,
  adv = 7,
  oxn =   -2, oyn =   -5, oxp =    9, oyp =   11,
  txn =  181, tyn =   96, txp =  192, typ =  112,
}
glyphs[183] = { --'∑'--
  num = 183,
  adv = 3,
  oxn =   -2, oyn =    0, oxp =    5, oyp =    6,
  txn =  199, tyn =   96, txp =  206, typ =  102,
}
glyphs[184] = { --'∏'--
  num = 184,
  adv = 4,
  oxn =   -2, oyn =   -5, oxp =    6, oyp =    2,
  txn =  217, tyn =   96, txp =  225, typ =  103,
}
glyphs[185] = { --'π'--
  num = 185,
  adv = 4,
  oxn =   -2, oyn =    1, oxp =    5, oyp =   11,
  txn =  235, tyn =   96, txp =  242, typ =  106,
}
glyphs[186] = { --'∫'--
  num = 186,
  adv = 4,
  oxn =   -2, oyn =    1, oxp =    7, oyp =   11,
  txn =  253, tyn =   96, txp =  262, typ =  106,
}
glyphs[187] = { --'ª'--
  num = 187,
  adv = 7,
  oxn =   -1, oyn =   -2, oxp =    8, oyp =    8,
  txn =  271, tyn =   96, txp =  280, typ =  106,
}
glyphs[188] = { --'º'--
  num = 188,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   11,
  txn =  289, tyn =   96, txp =  304, typ =  110,
}
glyphs[189] = { --'Ω'--
  num = 189,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   11,
  txn =  307, tyn =   96, txp =  322, typ =  110,
}
glyphs[190] = { --'æ'--
  num = 190,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   11,
  txn =  325, tyn =   96, txp =  340, typ =  110,
}
glyphs[191] = { --'ø'--
  num = 191,
  adv = 7,
  oxn =   -2, oyn =   -5, oxp =    9, oyp =    9,
  txn =  343, tyn =   96, txp =  354, typ =  110,
}
glyphs[192] = { --'¿'--
  num = 192,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   11, oyp =   14,
  txn =  361, tyn =   96, txp =  374, typ =  112,
}
glyphs[193] = { --'¡'--
  num = 193,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   11, oyp =   14,
  txn =  379, tyn =   96, txp =  392, typ =  112,
}
glyphs[194] = { --'¬'--
  num = 194,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   11, oyp =   14,
  txn =  397, tyn =   96, txp =  410, typ =  112,
}
glyphs[195] = { --'√'--
  num = 195,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   11, oyp =   13,
  txn =  415, tyn =   96, txp =  428, typ =  111,
}
glyphs[196] = { --'ƒ'--
  num = 196,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   11, oyp =   13,
  txn =  433, tyn =   96, txp =  446, typ =  111,
}
glyphs[197] = { --'≈'--
  num = 197,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   11, oyp =   14,
  txn =  451, tyn =   96, txp =  464, typ =  112,
}
glyphs[198] = { --'∆'--
  num = 198,
  adv = 12,
  oxn =   -2, oyn =   -2, oxp =   14, oyp =   11,
  txn =  469, tyn =   96, txp =  485, typ =  109,
}
glyphs[199] = { --'«'--
  num = 199,
  adv = 9,
  oxn =   -2, oyn =   -5, oxp =   11, oyp =   11,
  txn =  487, tyn =   96, txp =  500, typ =  112,
}
glyphs[200] = { --'»'--
  num = 200,
  adv = 8,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   14,
  txn =    1, tyn =  115, txp =   13, typ =  131,
}
glyphs[201] = { --'…'--
  num = 201,
  adv = 8,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   14,
  txn =   19, tyn =  115, txp =   31, typ =  131,
}
glyphs[202] = { --' '--
  num = 202,
  adv = 8,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   14,
  txn =   37, tyn =  115, txp =   49, typ =  131,
}
glyphs[203] = { --'À'--
  num = 203,
  adv = 8,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   13,
  txn =   55, tyn =  115, txp =   67, typ =  130,
}
glyphs[204] = { --'Ã'--
  num = 204,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =   14,
  txn =   73, tyn =  115, txp =   80, typ =  131,
}
glyphs[205] = { --'Õ'--
  num = 205,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =   14,
  txn =   91, tyn =  115, txp =   99, typ =  131,
}
glyphs[206] = { --'Œ'--
  num = 206,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =   14,
  txn =  109, tyn =  115, txp =  117, typ =  131,
}
glyphs[207] = { --'œ'--
  num = 207,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =   13,
  txn =  127, tyn =  115, txp =  135, typ =  130,
}
glyphs[208] = { --'–'--
  num = 208,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   11, oyp =   11,
  txn =  145, tyn =  115, txp =  158, typ =  128,
}
glyphs[209] = { --'—'--
  num = 209,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   13,
  txn =  163, tyn =  115, txp =  175, typ =  130,
}
glyphs[210] = { --'“'--
  num = 210,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   11, oyp =   14,
  txn =  181, tyn =  115, txp =  194, typ =  132,
}
glyphs[211] = { --'”'--
  num = 211,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   11, oyp =   14,
  txn =  199, tyn =  115, txp =  212, typ =  132,
}
glyphs[212] = { --'‘'--
  num = 212,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   11, oyp =   14,
  txn =  217, tyn =  115, txp =  230, typ =  132,
}
glyphs[213] = { --'’'--
  num = 213,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   11, oyp =   13,
  txn =  235, tyn =  115, txp =  248, typ =  131,
}
glyphs[214] = { --'÷'--
  num = 214,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   11, oyp =   13,
  txn =  253, tyn =  115, txp =  266, typ =  131,
}
glyphs[215] = { --'◊'--
  num = 215,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =    8,
  txn =  271, tyn =  115, txp =  282, typ =  125,
}
glyphs[216] = { --'ÿ'--
  num = 216,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   11,
  txn =  289, tyn =  115, txp =  303, typ =  129,
}
glyphs[217] = { --'Ÿ'--
  num = 217,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   10, oyp =   14,
  txn =  307, tyn =  115, txp =  319, typ =  132,
}
glyphs[218] = { --'⁄'--
  num = 218,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   10, oyp =   14,
  txn =  325, tyn =  115, txp =  337, typ =  132,
}
glyphs[219] = { --'€'--
  num = 219,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   10, oyp =   14,
  txn =  343, tyn =  115, txp =  355, typ =  132,
}
glyphs[220] = { --'‹'--
  num = 220,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   10, oyp =   13,
  txn =  361, tyn =  115, txp =  373, typ =  131,
}
glyphs[221] = { --'›'--
  num = 221,
  adv = 8,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   14,
  txn =  379, tyn =  115, txp =  391, typ =  131,
}
glyphs[222] = { --'ﬁ'--
  num = 222,
  adv = 8,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   11,
  txn =  397, tyn =  115, txp =  409, typ =  128,
}
glyphs[223] = { --'ﬂ'--
  num = 223,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =  415, tyn =  115, txp =  426, typ =  129,
}
glyphs[224] = { --'‡'--
  num = 224,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   12,
  txn =  433, tyn =  115, txp =  444, typ =  130,
}
glyphs[225] = { --'·'--
  num = 225,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   12,
  txn =  451, tyn =  115, txp =  462, typ =  130,
}
glyphs[226] = { --'‚'--
  num = 226,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   12,
  txn =  469, tyn =  115, txp =  480, typ =  130,
}
glyphs[227] = { --'„'--
  num = 227,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =  487, tyn =  115, txp =  498, typ =  129,
}
glyphs[228] = { --'‰'--
  num = 228,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =    1, tyn =  134, txp =   12, typ =  148,
}
glyphs[229] = { --'Â'--
  num = 229,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   12,
  txn =   19, tyn =  134, txp =   30, typ =  149,
}
glyphs[230] = { --'Ê'--
  num = 230,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =    9,
  txn =   37, tyn =  134, txp =   52, typ =  146,
}
glyphs[231] = { --'Á'--
  num = 231,
  adv = 7,
  oxn =   -2, oyn =   -5, oxp =    9, oyp =    9,
  txn =   55, tyn =  134, txp =   66, typ =  148,
}
glyphs[232] = { --'Ë'--
  num = 232,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   12,
  txn =   73, tyn =  134, txp =   84, typ =  149,
}
glyphs[233] = { --'È'--
  num = 233,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   12,
  txn =   91, tyn =  134, txp =  102, typ =  149,
}
glyphs[234] = { --'Í'--
  num = 234,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   12,
  txn =  109, tyn =  134, txp =  120, typ =  149,
}
glyphs[235] = { --'Î'--
  num = 235,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =  127, tyn =  134, txp =  138, typ =  148,
}
glyphs[236] = { --'Ï'--
  num = 236,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =   12,
  txn =  145, tyn =  134, txp =  152, typ =  148,
}
glyphs[237] = { --'Ì'--
  num = 237,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =   12,
  txn =  163, tyn =  134, txp =  171, typ =  148,
}
glyphs[238] = { --'Ó'--
  num = 238,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =   12,
  txn =  181, tyn =  134, txp =  189, typ =  148,
}
glyphs[239] = { --'Ô'--
  num = 239,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =   11,
  txn =  199, tyn =  134, txp =  207, typ =  147,
}
glyphs[240] = { --''--
  num = 240,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =  217, tyn =  134, txp =  228, typ =  148,
}
glyphs[241] = { --'Ò'--
  num = 241,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   11,
  txn =  235, tyn =  134, txp =  246, typ =  147,
}
glyphs[242] = { --'Ú'--
  num = 242,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   12,
  txn =  253, tyn =  134, txp =  264, typ =  149,
}
glyphs[243] = { --'Û'--
  num = 243,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   12,
  txn =  271, tyn =  134, txp =  282, typ =  149,
}
glyphs[244] = { --'Ù'--
  num = 244,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   12,
  txn =  289, tyn =  134, txp =  300, typ =  149,
}
glyphs[245] = { --'ı'--
  num = 245,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =  307, tyn =  134, txp =  318, typ =  148,
}
glyphs[246] = { --'ˆ'--
  num = 246,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =  325, tyn =  134, txp =  336, typ =  148,
}
glyphs[247] = { --'˜'--
  num = 247,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =    8,
  txn =  343, tyn =  134, txp =  354, typ =  145,
}
glyphs[248] = { --'¯'--
  num = 248,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =   10, oyp =    9,
  txn =  361, tyn =  134, txp =  373, typ =  146,
}
glyphs[249] = { --'˘'--
  num = 249,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   12,
  txn =  379, tyn =  134, txp =  390, typ =  149,
}
glyphs[250] = { --'˙'--
  num = 250,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   12,
  txn =  397, tyn =  134, txp =  408, typ =  149,
}
glyphs[251] = { --'˚'--
  num = 251,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   12,
  txn =  415, tyn =  134, txp =  426, typ =  149,
}
glyphs[252] = { --'¸'--
  num = 252,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   11,
  txn =  433, tyn =  134, txp =  444, typ =  148,
}
glyphs[253] = { --'˝'--
  num = 253,
  adv = 7,
  oxn =   -2, oyn =   -5, oxp =    9, oyp =   12,
  txn =  451, tyn =  134, txp =  462, typ =  151,
}
glyphs[254] = { --'˛'--
  num = 254,
  adv = 7,
  oxn =   -2, oyn =   -5, oxp =    9, oyp =   11,
  txn =  469, tyn =  134, txp =  480, typ =  150,
}
glyphs[255] = { --'ˇ'--
  num = 255,
  adv = 7,
  oxn =   -2, oyn =   -5, oxp =    9, oyp =   11,
  txn =  487, tyn =  134, txp =  498, typ =  150,
}

fontSpecs.glyphs = glyphs

return fontSpecs

