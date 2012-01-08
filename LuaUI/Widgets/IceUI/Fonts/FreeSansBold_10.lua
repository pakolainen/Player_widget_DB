
local fontSpecs = {
  srcFile  = [[FreeSansBold.ttf]],
  family   = [[FreeSans]],
  style    = [[Bold]],
  yStep    = 10,
  height   = 10,
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
  adv = 3,
  oxn =   -1, oyn =   -2, oxp =    5, oyp =   10,
  txn =   17, tyn =    1, txp =   23, typ =   13,
}
glyphs[34] = { --'"'--
  num = 34,
  adv = 5,
  oxn =   -2, oyn =    2, oxp =    7, oyp =   10,
  txn =   33, tyn =    1, txp =   42, typ =    9,
}
glyphs[35] = { --'#'--
  num = 35,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    9,
  txn =   49, tyn =    1, txp =   59, typ =   13,
}
glyphs[36] = { --'$'--
  num = 36,
  adv = 6,
  oxn =   -2, oyn =   -4, oxp =    8, oyp =   10,
  txn =   65, tyn =    1, txp =   75, typ =   15,
}
glyphs[37] = { --'%'--
  num = 37,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   11, oyp =   10,
  txn =   81, tyn =    1, txp =   94, typ =   14,
}
glyphs[38] = { --'&'--
  num = 38,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   10,
  txn =   97, tyn =    1, txp =  108, typ =   14,
}
glyphs[39] = { --'''--
  num = 39,
  adv = 2,
  oxn =   -2, oyn =    2, oxp =    4, oyp =   10,
  txn =  113, tyn =    1, txp =  119, typ =    9,
}
glyphs[40] = { --'('--
  num = 40,
  adv = 3,
  oxn =   -2, oyn =   -4, oxp =    6, oyp =   10,
  txn =  129, tyn =    1, txp =  137, typ =   15,
}
glyphs[41] = { --')'--
  num = 41,
  adv = 3,
  oxn =   -2, oyn =   -4, oxp =    5, oyp =   10,
  txn =  145, tyn =    1, txp =  152, typ =   15,
}
glyphs[42] = { --'*'--
  num = 42,
  adv = 4,
  oxn =   -2, oyn =    2, oxp =    6, oyp =   10,
  txn =  161, tyn =    1, txp =  169, typ =    9,
}
glyphs[43] = { --'+'--
  num = 43,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    7,
  txn =  177, tyn =    1, txp =  187, typ =   11,
}
glyphs[44] = { --','--
  num = 44,
  adv = 3,
  oxn =   -2, oyn =   -4, oxp =    5, oyp =    4,
  txn =  193, tyn =    1, txp =  200, typ =    9,
}
glyphs[45] = { --'-'--
  num = 45,
  adv = 3,
  oxn =   -2, oyn =    0, oxp =    5, oyp =    6,
  txn =  209, tyn =    1, txp =  216, typ =    7,
}
glyphs[46] = { --'.'--
  num = 46,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =    4,
  txn =  225, tyn =    1, txp =  232, typ =    7,
}
glyphs[47] = { --'/'--
  num = 47,
  adv = 3,
  oxn =   -2, oyn =   -3, oxp =    5, oyp =   10,
  txn =  241, tyn =    1, txp =  248, typ =   14,
}
glyphs[48] = { --'0'--
  num = 48,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  257, tyn =    1, txp =  267, typ =   14,
}
glyphs[49] = { --'1'--
  num = 49,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =   10,
  txn =  273, tyn =    1, txp =  281, typ =   13,
}
glyphs[50] = { --'2'--
  num = 50,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   10,
  txn =  289, tyn =    1, txp =  299, typ =   13,
}
glyphs[51] = { --'3'--
  num = 51,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  305, tyn =    1, txp =  315, typ =   14,
}
glyphs[52] = { --'4'--
  num = 52,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   10,
  txn =  321, tyn =    1, txp =  331, typ =   13,
}
glyphs[53] = { --'5'--
  num = 53,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  337, tyn =    1, txp =  347, typ =   14,
}
glyphs[54] = { --'6'--
  num = 54,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  353, tyn =    1, txp =  363, typ =   14,
}
glyphs[55] = { --'7'--
  num = 55,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   10,
  txn =  369, tyn =    1, txp =  379, typ =   13,
}
glyphs[56] = { --'8'--
  num = 56,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  385, tyn =    1, txp =  395, typ =   14,
}
glyphs[57] = { --'9'--
  num = 57,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  401, tyn =    1, txp =  411, typ =   14,
}
glyphs[58] = { --':'--
  num = 58,
  adv = 3,
  oxn =   -1, oyn =   -2, oxp =    5, oyp =    8,
  txn =  417, tyn =    1, txp =  423, typ =   11,
}
glyphs[59] = { --';'--
  num = 59,
  adv = 3,
  oxn =   -1, oyn =   -4, oxp =    5, oyp =    8,
  txn =  433, tyn =    1, txp =  439, typ =   13,
}
glyphs[60] = { --'<'--
  num = 60,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    7,
  txn =  449, tyn =    1, txp =  459, typ =   11,
}
glyphs[61] = { --'='--
  num = 61,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    7,
  txn =  465, tyn =    1, txp =  475, typ =   10,
}
glyphs[62] = { --'>'--
  num = 62,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    7,
  txn =  481, tyn =    1, txp =  491, typ =   11,
}
glyphs[63] = { --'?'--
  num = 63,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   10,
  txn =  497, tyn =    1, txp =  507, typ =   13,
}
glyphs[64] = { --'@'--
  num = 64,
  adv = 10,
  oxn =   -2, oyn =   -4, oxp =   12, oyp =   10,
  txn =    1, tyn =   18, txp =   15, typ =   32,
}
glyphs[65] = { --'A'--
  num = 65,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   10,
  txn =   17, tyn =   18, txp =   29, typ =   30,
}
glyphs[66] = { --'B'--
  num = 66,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   10,
  txn =   33, tyn =   18, txp =   44, typ =   30,
}
glyphs[67] = { --'C'--
  num = 67,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   10,
  txn =   49, tyn =   18, txp =   60, typ =   31,
}
glyphs[68] = { --'D'--
  num = 68,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   10,
  txn =   65, tyn =   18, txp =   76, typ =   30,
}
glyphs[69] = { --'E'--
  num = 69,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   10,
  txn =   81, tyn =   18, txp =   92, typ =   30,
}
glyphs[70] = { --'F'--
  num = 70,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   10,
  txn =   97, tyn =   18, txp =  107, typ =   30,
}
glyphs[71] = { --'G'--
  num = 71,
  adv = 8,
  oxn =   -2, oyn =   -3, oxp =   10, oyp =   10,
  txn =  113, tyn =   18, txp =  125, typ =   31,
}
glyphs[72] = { --'H'--
  num = 72,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   10,
  txn =  129, tyn =   18, txp =  140, typ =   30,
}
glyphs[73] = { --'I'--
  num = 73,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =   10,
  txn =  145, tyn =   18, txp =  152, typ =   30,
}
glyphs[74] = { --'J'--
  num = 74,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =   10,
  txn =  161, tyn =   18, txp =  170, typ =   31,
}
glyphs[75] = { --'K'--
  num = 75,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   10,
  txn =  177, tyn =   18, txp =  189, typ =   30,
}
glyphs[76] = { --'L'--
  num = 76,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   10,
  txn =  193, tyn =   18, txp =  203, typ =   30,
}
glyphs[77] = { --'M'--
  num = 77,
  adv = 8,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   10,
  txn =  209, tyn =   18, txp =  221, typ =   30,
}
glyphs[78] = { --'N'--
  num = 78,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   10,
  txn =  225, tyn =   18, txp =  236, typ =   30,
}
glyphs[79] = { --'O'--
  num = 79,
  adv = 8,
  oxn =   -2, oyn =   -3, oxp =   10, oyp =   10,
  txn =  241, tyn =   18, txp =  253, typ =   31,
}
glyphs[80] = { --'P'--
  num = 80,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   10,
  txn =  257, tyn =   18, txp =  268, typ =   30,
}
glyphs[81] = { --'Q'--
  num = 81,
  adv = 8,
  oxn =   -2, oyn =   -3, oxp =   10, oyp =   10,
  txn =  273, tyn =   18, txp =  285, typ =   31,
}
glyphs[82] = { --'R'--
  num = 82,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   10,
  txn =  289, tyn =   18, txp =  300, typ =   30,
}
glyphs[83] = { --'S'--
  num = 83,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   10,
  txn =  305, tyn =   18, txp =  316, typ =   31,
}
glyphs[84] = { --'T'--
  num = 84,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   10,
  txn =  321, tyn =   18, txp =  331, typ =   30,
}
glyphs[85] = { --'U'--
  num = 85,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   10,
  txn =  337, tyn =   18, txp =  348, typ =   31,
}
glyphs[86] = { --'V'--
  num = 86,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   10,
  txn =  353, tyn =   18, txp =  364, typ =   30,
}
glyphs[87] = { --'W'--
  num = 87,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   12, oyp =   10,
  txn =  369, tyn =   18, txp =  383, typ =   30,
}
glyphs[88] = { --'X'--
  num = 88,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   10,
  txn =  385, tyn =   18, txp =  396, typ =   30,
}
glyphs[89] = { --'Y'--
  num = 89,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   10,
  txn =  401, tyn =   18, txp =  412, typ =   30,
}
glyphs[90] = { --'Z'--
  num = 90,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   10,
  txn =  417, tyn =   18, txp =  427, typ =   30,
}
glyphs[91] = { --'['--
  num = 91,
  adv = 3,
  oxn =   -2, oyn =   -4, oxp =    6, oyp =   10,
  txn =  433, tyn =   18, txp =  441, typ =   32,
}
glyphs[92] = { --'\'--
  num = 92,
  adv = 3,
  oxn =   -3, oyn =   -3, oxp =    5, oyp =   10,
  txn =  449, tyn =   18, txp =  457, typ =   31,
}
glyphs[93] = { --']'--
  num = 93,
  adv = 3,
  oxn =   -2, oyn =   -4, oxp =    5, oyp =   10,
  txn =  465, tyn =   18, txp =  472, typ =   32,
}
glyphs[94] = { --'^'--
  num = 94,
  adv = 6,
  oxn =   -2, oyn =    0, oxp =    8, oyp =    9,
  txn =  481, tyn =   18, txp =  491, typ =   27,
}
glyphs[95] = { --'_'--
  num = 95,
  adv = 6,
  oxn =   -3, oyn =   -4, oxp =    8, oyp =    1,
  txn =  497, tyn =   18, txp =  508, typ =   23,
}
glyphs[96] = { --'`'--
  num = 96,
  adv = 3,
  oxn =   -2, oyn =    4, oxp =    5, oyp =   10,
  txn =    1, tyn =   35, txp =    8, typ =   41,
}
glyphs[97] = { --'a'--
  num = 97,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    8,
  txn =   17, tyn =   35, txp =   27, typ =   46,
}
glyphs[98] = { --'b'--
  num = 98,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =   33, tyn =   35, txp =   43, typ =   48,
}
glyphs[99] = { --'c'--
  num = 99,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    8,
  txn =   49, tyn =   35, txp =   59, typ =   46,
}
glyphs[100] = { --'d'--
  num = 100,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =   65, tyn =   35, txp =   75, typ =   48,
}
glyphs[101] = { --'e'--
  num = 101,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    8,
  txn =   81, tyn =   35, txp =   91, typ =   46,
}
glyphs[102] = { --'f'--
  num = 102,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =   10,
  txn =   97, tyn =   35, txp =  105, typ =   47,
}
glyphs[103] = { --'g'--
  num = 103,
  adv = 6,
  oxn =   -2, oyn =   -5, oxp =    8, oyp =    8,
  txn =  113, tyn =   35, txp =  123, typ =   48,
}
glyphs[104] = { --'h'--
  num = 104,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   10,
  txn =  129, tyn =   35, txp =  139, typ =   47,
}
glyphs[105] = { --'i'--
  num = 105,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =   10,
  txn =  145, tyn =   35, txp =  152, typ =   47,
}
glyphs[106] = { --'j'--
  num = 106,
  adv = 3,
  oxn =   -2, oyn =   -5, oxp =    5, oyp =   10,
  txn =  161, tyn =   35, txp =  168, typ =   50,
}
glyphs[107] = { --'k'--
  num = 107,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   10,
  txn =  177, tyn =   35, txp =  187, typ =   47,
}
glyphs[108] = { --'l'--
  num = 108,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =   10,
  txn =  193, tyn =   35, txp =  200, typ =   47,
}
glyphs[109] = { --'m'--
  num = 109,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   11, oyp =    8,
  txn =  209, tyn =   35, txp =  222, typ =   45,
}
glyphs[110] = { --'n'--
  num = 110,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    8,
  txn =  225, tyn =   35, txp =  235, typ =   45,
}
glyphs[111] = { --'o'--
  num = 111,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    8,
  txn =  241, tyn =   35, txp =  251, typ =   46,
}
glyphs[112] = { --'p'--
  num = 112,
  adv = 6,
  oxn =   -2, oyn =   -5, oxp =    8, oyp =    8,
  txn =  257, tyn =   35, txp =  267, typ =   48,
}
glyphs[113] = { --'q'--
  num = 113,
  adv = 6,
  oxn =   -2, oyn =   -5, oxp =    8, oyp =    8,
  txn =  273, tyn =   35, txp =  283, typ =   48,
}
glyphs[114] = { --'r'--
  num = 114,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    8,
  txn =  289, tyn =   35, txp =  297, typ =   45,
}
glyphs[115] = { --'s'--
  num = 115,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    8,
  txn =  305, tyn =   35, txp =  315, typ =   46,
}
glyphs[116] = { --'t'--
  num = 116,
  adv = 3,
  oxn =   -2, oyn =   -3, oxp =    6, oyp =    9,
  txn =  321, tyn =   35, txp =  329, typ =   47,
}
glyphs[117] = { --'u'--
  num = 117,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    8,
  txn =  337, tyn =   35, txp =  347, typ =   46,
}
glyphs[118] = { --'v'--
  num = 118,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    8,
  txn =  353, tyn =   35, txp =  363, typ =   45,
}
glyphs[119] = { --'w'--
  num = 119,
  adv = 8,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =    8,
  txn =  369, tyn =   35, txp =  381, typ =   45,
}
glyphs[120] = { --'x'--
  num = 120,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    8,
  txn =  385, tyn =   35, txp =  395, typ =   45,
}
glyphs[121] = { --'y'--
  num = 121,
  adv = 6,
  oxn =   -2, oyn =   -5, oxp =    8, oyp =    8,
  txn =  401, tyn =   35, txp =  411, typ =   48,
}
glyphs[122] = { --'z'--
  num = 122,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    8,
  txn =  417, tyn =   35, txp =  426, typ =   45,
}
glyphs[123] = { --'{'--
  num = 123,
  adv = 4,
  oxn =   -2, oyn =   -4, oxp =    6, oyp =   10,
  txn =  433, tyn =   35, txp =  441, typ =   49,
}
glyphs[124] = { --'|'--
  num = 124,
  adv = 3,
  oxn =   -1, oyn =   -4, oxp =    4, oyp =   10,
  txn =  449, tyn =   35, txp =  454, typ =   49,
}
glyphs[125] = { --'}'--
  num = 125,
  adv = 4,
  oxn =   -2, oyn =   -4, oxp =    6, oyp =   10,
  txn =  465, tyn =   35, txp =  473, typ =   49,
}
glyphs[126] = { --'~'--
  num = 126,
  adv = 6,
  oxn =   -2, oyn =   -1, oxp =    8, oyp =    6,
  txn =  481, tyn =   35, txp =  491, typ =   42,
}
glyphs[127] = { --''--
  num = 127,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  497, tyn =   35, txp =  505, typ =   46,
}
glyphs[128] = { --'Ä'--
  num = 128,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =    1, tyn =   52, txp =    9, typ =   63,
}
glyphs[129] = { --'Å'--
  num = 129,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =   17, tyn =   52, txp =   25, typ =   63,
}
glyphs[130] = { --'Ç'--
  num = 130,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =   33, tyn =   52, txp =   41, typ =   63,
}
glyphs[131] = { --'É'--
  num = 131,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =   49, tyn =   52, txp =   57, typ =   63,
}
glyphs[132] = { --'Ñ'--
  num = 132,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =   65, tyn =   52, txp =   73, typ =   63,
}
glyphs[133] = { --'Ö'--
  num = 133,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =   81, tyn =   52, txp =   89, typ =   63,
}
glyphs[134] = { --'Ü'--
  num = 134,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =   97, tyn =   52, txp =  105, typ =   63,
}
glyphs[135] = { --'á'--
  num = 135,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  113, tyn =   52, txp =  121, typ =   63,
}
glyphs[136] = { --'à'--
  num = 136,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  129, tyn =   52, txp =  137, typ =   63,
}
glyphs[137] = { --'â'--
  num = 137,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  145, tyn =   52, txp =  153, typ =   63,
}
glyphs[138] = { --'ä'--
  num = 138,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  161, tyn =   52, txp =  169, typ =   63,
}
glyphs[139] = { --'ã'--
  num = 139,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  177, tyn =   52, txp =  185, typ =   63,
}
glyphs[140] = { --'å'--
  num = 140,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  193, tyn =   52, txp =  201, typ =   63,
}
glyphs[141] = { --'ç'--
  num = 141,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  209, tyn =   52, txp =  217, typ =   63,
}
glyphs[142] = { --'é'--
  num = 142,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  225, tyn =   52, txp =  233, typ =   63,
}
glyphs[143] = { --'è'--
  num = 143,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  241, tyn =   52, txp =  249, typ =   63,
}
glyphs[144] = { --'ê'--
  num = 144,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  257, tyn =   52, txp =  265, typ =   63,
}
glyphs[145] = { --'ë'--
  num = 145,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  273, tyn =   52, txp =  281, typ =   63,
}
glyphs[146] = { --'í'--
  num = 146,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  289, tyn =   52, txp =  297, typ =   63,
}
glyphs[147] = { --'ì'--
  num = 147,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  305, tyn =   52, txp =  313, typ =   63,
}
glyphs[148] = { --'î'--
  num = 148,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  321, tyn =   52, txp =  329, typ =   63,
}
glyphs[149] = { --'ï'--
  num = 149,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  337, tyn =   52, txp =  345, typ =   63,
}
glyphs[150] = { --'ñ'--
  num = 150,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  353, tyn =   52, txp =  361, typ =   63,
}
glyphs[151] = { --'ó'--
  num = 151,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  369, tyn =   52, txp =  377, typ =   63,
}
glyphs[152] = { --'ò'--
  num = 152,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  385, tyn =   52, txp =  393, typ =   63,
}
glyphs[153] = { --'ô'--
  num = 153,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  401, tyn =   52, txp =  409, typ =   63,
}
glyphs[154] = { --'ö'--
  num = 154,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  417, tyn =   52, txp =  425, typ =   63,
}
glyphs[155] = { --'õ'--
  num = 155,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  433, tyn =   52, txp =  441, typ =   63,
}
glyphs[156] = { --'ú'--
  num = 156,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  449, tyn =   52, txp =  457, typ =   63,
}
glyphs[157] = { --'ù'--
  num = 157,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  465, tyn =   52, txp =  473, typ =   63,
}
glyphs[158] = { --'û'--
  num = 158,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  481, tyn =   52, txp =  489, typ =   63,
}
glyphs[159] = { --'ü'--
  num = 159,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  497, tyn =   52, txp =  505, typ =   63,
}
glyphs[160] = { --'†'--
  num = 160,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =    1, tyn =   69, txp =    9, typ =   80,
}
glyphs[161] = { --'°'--
  num = 161,
  adv = 3,
  oxn =   -2, oyn =   -4, oxp =    5, oyp =    8,
  txn =   17, tyn =   69, txp =   24, typ =   81,
}
glyphs[162] = { --'¢'--
  num = 162,
  adv = 6,
  oxn =   -2, oyn =   -4, oxp =    8, oyp =    9,
  txn =   33, tyn =   69, txp =   43, typ =   82,
}
glyphs[163] = { --'£'--
  num = 163,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =   49, tyn =   69, txp =   59, typ =   82,
}
glyphs[164] = { --'§'--
  num = 164,
  adv = 6,
  oxn =   -2, oyn =   -1, oxp =    8, oyp =    9,
  txn =   65, tyn =   69, txp =   75, typ =   79,
}
glyphs[165] = { --'•'--
  num = 165,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   10,
  txn =   81, tyn =   69, txp =   91, typ =   81,
}
glyphs[166] = { --'¶'--
  num = 166,
  adv = 3,
  oxn =   -1, oyn =   -4, oxp =    4, oyp =   10,
  txn =   97, tyn =   69, txp =  102, typ =   83,
}
glyphs[167] = { --'ß'--
  num = 167,
  adv = 6,
  oxn =   -2, oyn =   -5, oxp =    8, oyp =   10,
  txn =  113, tyn =   69, txp =  123, typ =   84,
}
glyphs[168] = { --'®'--
  num = 168,
  adv = 3,
  oxn =   -2, oyn =    4, oxp =    6, oyp =   10,
  txn =  129, tyn =   69, txp =  137, typ =   75,
}
glyphs[169] = { --'©'--
  num = 169,
  adv = 7,
  oxn =   -3, oyn =   -3, oxp =   10, oyp =   10,
  txn =  145, tyn =   69, txp =  158, typ =   82,
}
glyphs[170] = { --'™'--
  num = 170,
  adv = 4,
  oxn =   -2, oyn =    0, oxp =    6, oyp =   10,
  txn =  161, tyn =   69, txp =  169, typ =   79,
}
glyphs[171] = { --'´'--
  num = 171,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    7,
  txn =  177, tyn =   69, txp =  186, typ =   78,
}
glyphs[172] = { --'¨'--
  num = 172,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    6,
  txn =  193, tyn =   69, txp =  203, typ =   77,
}
glyphs[173] = { --'≠'--
  num = 173,
  adv = 4,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =    9,
  txn =  209, tyn =   69, txp =  217, typ =   80,
}
glyphs[174] = { --'Æ'--
  num = 174,
  adv = 7,
  oxn =   -3, oyn =   -3, oxp =   10, oyp =   10,
  txn =  225, tyn =   69, txp =  238, typ =   82,
}
glyphs[175] = { --'Ø'--
  num = 175,
  adv = 3,
  oxn =   -2, oyn =    4, oxp =    6, oyp =   10,
  txn =  241, tyn =   69, txp =  249, typ =   75,
}
glyphs[176] = { --'∞'--
  num = 176,
  adv = 6,
  oxn =   -1, oyn =    1, oxp =    7, oyp =    9,
  txn =  257, tyn =   69, txp =  265, typ =   77,
}
glyphs[177] = { --'±'--
  num = 177,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    9,
  txn =  273, tyn =   69, txp =  283, typ =   81,
}
glyphs[178] = { --'≤'--
  num = 178,
  adv = 4,
  oxn =   -2, oyn =    0, oxp =    6, oyp =   10,
  txn =  289, tyn =   69, txp =  297, typ =   79,
}
glyphs[179] = { --'≥'--
  num = 179,
  adv = 4,
  oxn =   -2, oyn =    0, oxp =    6, oyp =   10,
  txn =  305, tyn =   69, txp =  313, typ =   79,
}
glyphs[180] = { --'¥'--
  num = 180,
  adv = 3,
  oxn =   -1, oyn =    4, oxp =    6, oyp =   10,
  txn =  321, tyn =   69, txp =  328, typ =   75,
}
glyphs[181] = { --'µ'--
  num = 181,
  adv = 6,
  oxn =   -2, oyn =   -5, oxp =    8, oyp =    8,
  txn =  337, tyn =   69, txp =  347, typ =   82,
}
glyphs[182] = { --'∂'--
  num = 182,
  adv = 6,
  oxn =   -2, oyn =   -4, oxp =    8, oyp =   10,
  txn =  353, tyn =   69, txp =  363, typ =   83,
}
glyphs[183] = { --'∑'--
  num = 183,
  adv = 3,
  oxn =   -2, oyn =   -1, oxp =    4, oyp =    5,
  txn =  369, tyn =   69, txp =  375, typ =   75,
}
glyphs[184] = { --'∏'--
  num = 184,
  adv = 3,
  oxn =   -2, oyn =   -5, oxp =    5, oyp =    2,
  txn =  385, tyn =   69, txp =  392, typ =   76,
}
glyphs[185] = { --'π'--
  num = 185,
  adv = 4,
  oxn =   -2, oyn =    0, oxp =    5, oyp =   10,
  txn =  401, tyn =   69, txp =  408, typ =   79,
}
glyphs[186] = { --'∫'--
  num = 186,
  adv = 4,
  oxn =   -2, oyn =    0, oxp =    6, oyp =   10,
  txn =  417, tyn =   69, txp =  425, typ =   79,
}
glyphs[187] = { --'ª'--
  num = 187,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    7, oyp =    7,
  txn =  433, tyn =   69, txp =  442, typ =   78,
}
glyphs[188] = { --'º'--
  num = 188,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   11, oyp =   10,
  txn =  449, tyn =   69, txp =  462, typ =   82,
}
glyphs[189] = { --'Ω'--
  num = 189,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   11, oyp =   10,
  txn =  465, tyn =   69, txp =  478, typ =   82,
}
glyphs[190] = { --'æ'--
  num = 190,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   11, oyp =   10,
  txn =  481, tyn =   69, txp =  494, typ =   82,
}
glyphs[191] = { --'ø'--
  num = 191,
  adv = 6,
  oxn =   -2, oyn =   -5, oxp =    8, oyp =    8,
  txn =  497, tyn =   69, txp =  507, typ =   82,
}
glyphs[192] = { --'¿'--
  num = 192,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   12,
  txn =    1, tyn =   86, txp =   13, typ =  100,
}
glyphs[193] = { --'¡'--
  num = 193,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   12,
  txn =   17, tyn =   86, txp =   29, typ =  100,
}
glyphs[194] = { --'¬'--
  num = 194,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   12,
  txn =   33, tyn =   86, txp =   45, typ =  100,
}
glyphs[195] = { --'√'--
  num = 195,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   12,
  txn =   49, tyn =   86, txp =   61, typ =  100,
}
glyphs[196] = { --'ƒ'--
  num = 196,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   12,
  txn =   65, tyn =   86, txp =   77, typ =  100,
}
glyphs[197] = { --'≈'--
  num = 197,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   12,
  txn =   81, tyn =   86, txp =   93, typ =  100,
}
glyphs[198] = { --'∆'--
  num = 198,
  adv = 10,
  oxn =   -2, oyn =   -2, oxp =   12, oyp =   10,
  txn =   97, tyn =   86, txp =  111, typ =   98,
}
glyphs[199] = { --'«'--
  num = 199,
  adv = 7,
  oxn =   -2, oyn =   -5, oxp =    9, oyp =   10,
  txn =  113, tyn =   86, txp =  124, typ =  101,
}
glyphs[200] = { --'»'--
  num = 200,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   12,
  txn =  129, tyn =   86, txp =  140, typ =  100,
}
glyphs[201] = { --'…'--
  num = 201,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   12,
  txn =  145, tyn =   86, txp =  156, typ =  100,
}
glyphs[202] = { --' '--
  num = 202,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   12,
  txn =  161, tyn =   86, txp =  172, typ =  100,
}
glyphs[203] = { --'À'--
  num = 203,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   12,
  txn =  177, tyn =   86, txp =  188, typ =  100,
}
glyphs[204] = { --'Ã'--
  num = 204,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =   12,
  txn =  193, tyn =   86, txp =  200, typ =  100,
}
glyphs[205] = { --'Õ'--
  num = 205,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =   12,
  txn =  209, tyn =   86, txp =  217, typ =  100,
}
glyphs[206] = { --'Œ'--
  num = 206,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =   12,
  txn =  225, tyn =   86, txp =  233, typ =  100,
}
glyphs[207] = { --'œ'--
  num = 207,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =   12,
  txn =  241, tyn =   86, txp =  249, typ =  100,
}
glyphs[208] = { --'–'--
  num = 208,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   10,
  txn =  257, tyn =   86, txp =  268, typ =   98,
}
glyphs[209] = { --'—'--
  num = 209,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   12,
  txn =  273, tyn =   86, txp =  284, typ =  100,
}
glyphs[210] = { --'“'--
  num = 210,
  adv = 8,
  oxn =   -2, oyn =   -3, oxp =   10, oyp =   12,
  txn =  289, tyn =   86, txp =  301, typ =  101,
}
glyphs[211] = { --'”'--
  num = 211,
  adv = 8,
  oxn =   -2, oyn =   -3, oxp =   10, oyp =   12,
  txn =  305, tyn =   86, txp =  317, typ =  101,
}
glyphs[212] = { --'‘'--
  num = 212,
  adv = 8,
  oxn =   -2, oyn =   -3, oxp =   10, oyp =   12,
  txn =  321, tyn =   86, txp =  333, typ =  101,
}
glyphs[213] = { --'’'--
  num = 213,
  adv = 8,
  oxn =   -2, oyn =   -3, oxp =   10, oyp =   12,
  txn =  337, tyn =   86, txp =  349, typ =  101,
}
glyphs[214] = { --'÷'--
  num = 214,
  adv = 8,
  oxn =   -2, oyn =   -3, oxp =   10, oyp =   12,
  txn =  353, tyn =   86, txp =  365, typ =  101,
}
glyphs[215] = { --'◊'--
  num = 215,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =    7,
  txn =  369, tyn =   86, txp =  379, typ =   95,
}
glyphs[216] = { --'ÿ'--
  num = 216,
  adv = 8,
  oxn =   -2, oyn =   -3, oxp =   10, oyp =   10,
  txn =  385, tyn =   86, txp =  397, typ =   99,
}
glyphs[217] = { --'Ÿ'--
  num = 217,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   12,
  txn =  401, tyn =   86, txp =  412, typ =  101,
}
glyphs[218] = { --'⁄'--
  num = 218,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   12,
  txn =  417, tyn =   86, txp =  428, typ =  101,
}
glyphs[219] = { --'€'--
  num = 219,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   12,
  txn =  433, tyn =   86, txp =  444, typ =  101,
}
glyphs[220] = { --'‹'--
  num = 220,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   12,
  txn =  449, tyn =   86, txp =  460, typ =  101,
}
glyphs[221] = { --'›'--
  num = 221,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   12,
  txn =  465, tyn =   86, txp =  476, typ =  100,
}
glyphs[222] = { --'ﬁ'--
  num = 222,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   10,
  txn =  481, tyn =   86, txp =  492, typ =   98,
}
glyphs[223] = { --'ﬂ'--
  num = 223,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  497, tyn =   86, txp =  507, typ =   99,
}
glyphs[224] = { --'‡'--
  num = 224,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =    1, tyn =  103, txp =   11, typ =  116,
}
glyphs[225] = { --'·'--
  num = 225,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =   17, tyn =  103, txp =   27, typ =  116,
}
glyphs[226] = { --'‚'--
  num = 226,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =   33, tyn =  103, txp =   43, typ =  116,
}
glyphs[227] = { --'„'--
  num = 227,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =   49, tyn =  103, txp =   59, typ =  116,
}
glyphs[228] = { --'‰'--
  num = 228,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =   65, tyn =  103, txp =   75, typ =  116,
}
glyphs[229] = { --'Â'--
  num = 229,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =   81, tyn =  103, txp =   91, typ =  116,
}
glyphs[230] = { --'Ê'--
  num = 230,
  adv = 9,
  oxn =   -2, oyn =   -3, oxp =   11, oyp =    8,
  txn =   97, tyn =  103, txp =  110, typ =  114,
}
glyphs[231] = { --'Á'--
  num = 231,
  adv = 6,
  oxn =   -2, oyn =   -5, oxp =    8, oyp =    8,
  txn =  113, tyn =  103, txp =  123, typ =  116,
}
glyphs[232] = { --'Ë'--
  num = 232,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  129, tyn =  103, txp =  139, typ =  116,
}
glyphs[233] = { --'È'--
  num = 233,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  145, tyn =  103, txp =  155, typ =  116,
}
glyphs[234] = { --'Í'--
  num = 234,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  161, tyn =  103, txp =  171, typ =  116,
}
glyphs[235] = { --'Î'--
  num = 235,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  177, tyn =  103, txp =  187, typ =  116,
}
glyphs[236] = { --'Ï'--
  num = 236,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    5, oyp =   10,
  txn =  193, tyn =  103, txp =  200, typ =  115,
}
glyphs[237] = { --'Ì'--
  num = 237,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =   10,
  txn =  209, tyn =  103, txp =  217, typ =  115,
}
glyphs[238] = { --'Ó'--
  num = 238,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =   10,
  txn =  225, tyn =  103, txp =  233, typ =  115,
}
glyphs[239] = { --'Ô'--
  num = 239,
  adv = 3,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =   10,
  txn =  241, tyn =  103, txp =  249, typ =  115,
}
glyphs[240] = { --''--
  num = 240,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  257, tyn =  103, txp =  267, typ =  116,
}
glyphs[241] = { --'Ò'--
  num = 241,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   10,
  txn =  273, tyn =  103, txp =  283, typ =  115,
}
glyphs[242] = { --'Ú'--
  num = 242,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  289, tyn =  103, txp =  299, typ =  116,
}
glyphs[243] = { --'Û'--
  num = 243,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  305, tyn =  103, txp =  315, typ =  116,
}
glyphs[244] = { --'Ù'--
  num = 244,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  321, tyn =  103, txp =  331, typ =  116,
}
glyphs[245] = { --'ı'--
  num = 245,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  337, tyn =  103, txp =  347, typ =  116,
}
glyphs[246] = { --'ˆ'--
  num = 246,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  353, tyn =  103, txp =  363, typ =  116,
}
glyphs[247] = { --'˜'--
  num = 247,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    7,
  txn =  369, tyn =  103, txp =  379, typ =  113,
}
glyphs[248] = { --'¯'--
  num = 248,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =    8,
  txn =  385, tyn =  103, txp =  395, typ =  114,
}
glyphs[249] = { --'˘'--
  num = 249,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  401, tyn =  103, txp =  411, typ =  116,
}
glyphs[250] = { --'˙'--
  num = 250,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  417, tyn =  103, txp =  427, typ =  116,
}
glyphs[251] = { --'˚'--
  num = 251,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  433, tyn =  103, txp =  443, typ =  116,
}
glyphs[252] = { --'¸'--
  num = 252,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   10,
  txn =  449, tyn =  103, txp =  459, typ =  116,
}
glyphs[253] = { --'˝'--
  num = 253,
  adv = 6,
  oxn =   -2, oyn =   -5, oxp =    8, oyp =   10,
  txn =  465, tyn =  103, txp =  475, typ =  118,
}
glyphs[254] = { --'˛'--
  num = 254,
  adv = 6,
  oxn =   -2, oyn =   -5, oxp =    8, oyp =   10,
  txn =  481, tyn =  103, txp =  491, typ =  118,
}
glyphs[255] = { --'ˇ'--
  num = 255,
  adv = 6,
  oxn =   -2, oyn =   -5, oxp =    8, oyp =   10,
  txn =  497, tyn =  103, txp =  507, typ =  118,
}

fontSpecs.glyphs = glyphs

return fontSpecs

