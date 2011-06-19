type nat = O | S of nat

type intl = int

let intl_max = 65535

let intl_limit n =
  if n < 0 then 0 else if n > intl_max then intl_max else n

(** val intl_of_nat : Ax.nat -> intl **)

let rec intl_of_nat n =
  match n with
    | O -> 0
    | S m -> intl_of_nat m + 1

(** val intl_add : intl -> intl -> intl **)

let intl_add x y = intl_limit (x + y)

(** val intl_sub : intl -> intl -> intl **)

let intl_sub x y = intl_limit (x - y)

(** val intl_mul : intl -> intl -> intl **)

let intl_mul x y = intl_limit (x * y)

(** val intl_div : intl -> intl -> intl **)

let intl_div x y = intl_limit (x / y)

(** val intl_eq : intl -> intl -> bool **)

let intl_eq (x : intl) (y : intl) = x = y
let intl_eq_dec = intl_eq

(** val intl_lt : intl -> intl -> bool **)

let intl_lt (x : intl) (y : intl) = x < y

(** val intl_gt : intl -> intl -> bool **)

let intl_gt (x : intl) (y : intl) = x > y


let intl_0 = 0
let intl_1 = 1
let intl_2 = 2
let intl_3 = 3
let intl_4 = 4
let intl_5 = 5
let intl_6 = 6
let intl_7 = 7
let intl_8 = 8
let intl_9 = 9
let intl_10 = 10
let intl_11 = 11
let intl_12 = 12
let intl_13 = 13
let intl_14 = 14
let intl_15 = 15
let intl_16 = 16
let intl_17 = 17
let intl_18 = 18
let intl_19 = 19
let intl_20 = 20
let intl_21 = 21
let intl_22 = 22
let intl_23 = 23
let intl_24 = 24
let intl_25 = 25
let intl_26 = 26
let intl_27 = 27
let intl_28 = 28
let intl_29 = 29
let intl_30 = 30
let intl_31 = 31
let intl_32 = 32
let intl_33 = 33
let intl_34 = 34
let intl_35 = 35
let intl_36 = 36
let intl_37 = 37
let intl_38 = 38
let intl_39 = 39
let intl_40 = 40
let intl_41 = 41
let intl_42 = 42
let intl_43 = 43
let intl_44 = 44
let intl_45 = 45
let intl_46 = 46
let intl_47 = 47
let intl_48 = 48
let intl_49 = 49
let intl_50 = 50
let intl_51 = 51
let intl_52 = 52
let intl_53 = 53
let intl_54 = 54
let intl_55 = 55
let intl_56 = 56
let intl_57 = 57
let intl_58 = 58
let intl_59 = 59
let intl_60 = 60
let intl_61 = 61
let intl_62 = 62
let intl_63 = 63
let intl_64 = 64
let intl_65 = 65
let intl_66 = 66
let intl_67 = 67
let intl_68 = 68
let intl_69 = 69
let intl_70 = 70
let intl_71 = 71
let intl_72 = 72
let intl_73 = 73
let intl_74 = 74
let intl_75 = 75
let intl_76 = 76
let intl_77 = 77
let intl_78 = 78
let intl_79 = 79
let intl_80 = 80
let intl_81 = 81
let intl_82 = 82
let intl_83 = 83
let intl_84 = 84
let intl_85 = 85
let intl_86 = 86
let intl_87 = 87
let intl_88 = 88
let intl_89 = 89
let intl_90 = 90
let intl_91 = 91
let intl_92 = 92
let intl_93 = 93
let intl_94 = 94
let intl_95 = 95
let intl_96 = 96
let intl_97 = 97
let intl_98 = 98
let intl_99 = 99
let intl_100 = 100
let intl_101 = 101
let intl_102 = 102
let intl_103 = 103
let intl_104 = 104
let intl_105 = 105
let intl_106 = 106
let intl_107 = 107
let intl_108 = 108
let intl_109 = 109
let intl_110 = 110
let intl_111 = 111
let intl_112 = 112
let intl_113 = 113
let intl_114 = 114
let intl_115 = 115
let intl_116 = 116
let intl_117 = 117
let intl_118 = 118
let intl_119 = 119
let intl_120 = 120
let intl_121 = 121
let intl_122 = 122
let intl_123 = 123
let intl_124 = 124
let intl_125 = 125
let intl_126 = 126
let intl_127 = 127
let intl_128 = 128
let intl_129 = 129
let intl_130 = 130
let intl_131 = 131
let intl_132 = 132
let intl_133 = 133
let intl_134 = 134
let intl_135 = 135
let intl_136 = 136
let intl_137 = 137
let intl_138 = 138
let intl_139 = 139
let intl_140 = 140
let intl_141 = 141
let intl_142 = 142
let intl_143 = 143
let intl_144 = 144
let intl_145 = 145
let intl_146 = 146
let intl_147 = 147
let intl_148 = 148
let intl_149 = 149
let intl_150 = 150
let intl_151 = 151
let intl_152 = 152
let intl_153 = 153
let intl_154 = 154
let intl_155 = 155
let intl_156 = 156
let intl_157 = 157
let intl_158 = 158
let intl_159 = 159
let intl_160 = 160
let intl_161 = 161
let intl_162 = 162
let intl_163 = 163
let intl_164 = 164
let intl_165 = 165
let intl_166 = 166
let intl_167 = 167
let intl_168 = 168
let intl_169 = 169
let intl_170 = 170
let intl_171 = 171
let intl_172 = 172
let intl_173 = 173
let intl_174 = 174
let intl_175 = 175
let intl_176 = 176
let intl_177 = 177
let intl_178 = 178
let intl_179 = 179
let intl_180 = 180
let intl_181 = 181
let intl_182 = 182
let intl_183 = 183
let intl_184 = 184
let intl_185 = 185
let intl_186 = 186
let intl_187 = 187
let intl_188 = 188
let intl_189 = 189
let intl_190 = 190
let intl_191 = 191
let intl_192 = 192
let intl_193 = 193
let intl_194 = 194
let intl_195 = 195
let intl_196 = 196
let intl_197 = 197
let intl_198 = 198
let intl_199 = 199
let intl_200 = 200
let intl_201 = 201
let intl_202 = 202
let intl_203 = 203
let intl_204 = 204
let intl_205 = 205
let intl_206 = 206
let intl_207 = 207
let intl_208 = 208
let intl_209 = 209
let intl_210 = 210
let intl_211 = 211
let intl_212 = 212
let intl_213 = 213
let intl_214 = 214
let intl_215 = 215
let intl_216 = 216
let intl_217 = 217
let intl_218 = 218
let intl_219 = 219
let intl_220 = 220
let intl_221 = 221
let intl_222 = 222
let intl_223 = 223
let intl_224 = 224
let intl_225 = 225
let intl_226 = 226
let intl_227 = 227
let intl_228 = 228
let intl_229 = 229
let intl_230 = 230
let intl_231 = 231
let intl_232 = 232
let intl_233 = 233
let intl_234 = 234
let intl_235 = 235
let intl_236 = 236
let intl_237 = 237
let intl_238 = 238
let intl_239 = 239
let intl_240 = 240
let intl_241 = 241
let intl_242 = 242
let intl_243 = 243
let intl_244 = 244
let intl_245 = 245
let intl_246 = 246
let intl_247 = 247
let intl_248 = 248
let intl_249 = 249
let intl_250 = 250
let intl_251 = 251
let intl_252 = 252
let intl_253 = 253
let intl_254 = 254
let intl_255 = 255
let intl_256 = 256
