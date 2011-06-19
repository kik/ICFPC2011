Axiom intl : Set.
Axiom arr : Type -> Type.

Axiom intl_max : intl.
Axiom intl_of_nat : nat -> intl.
Axiom intl_add : intl -> intl -> intl.
Axiom intl_sub : intl -> intl -> intl.
Axiom intl_mul : intl -> intl -> intl.
Axiom intl_div : intl -> intl -> intl.
Axiom intl_eq_dec : forall x y: intl, { x = y } + { x <> y }.
Axiom intl_eq : intl -> intl -> bool.
Axiom intl_le : intl -> intl -> bool.
Axiom intl_ge : intl -> intl -> bool.
Axiom intl_lt : intl -> intl -> bool.
Axiom intl_gt : intl -> intl -> bool.

Axiom make_arr : forall {T}, intl -> (intl -> T) -> arr T.
Axiom aref : forall {T}, arr T -> intl -> T.

Delimit Scope intl_scope with i.
Bind Scope intl_scope with intl.

Infix "+" := intl_add : intl_scope.
Infix "-" := intl_sub : intl_scope.
Infix "*" := intl_mul : intl_scope.
Infix "/" := intl_div : intl_scope.
Infix "==" := intl_eq (at level 70, no associativity) : bool_scope.
Infix "<=" := intl_le : bool_scope.
Infix ">=" := intl_ge : bool_scope.
Infix "<"  := intl_lt : bool_scope.
Infix ">"  := intl_gt : bool_scope.

Axiom intl_0 : intl.
Axiom intl_1 : intl.
Axiom intl_2 : intl.
Axiom intl_3 : intl.
Axiom intl_4 : intl.
Axiom intl_5 : intl.
Axiom intl_6 : intl.
Axiom intl_7 : intl.
Axiom intl_8 : intl.
Axiom intl_9 : intl.
Axiom intl_10 : intl.
Axiom intl_11 : intl.
Axiom intl_12 : intl.
Axiom intl_13 : intl.
Axiom intl_14 : intl.
Axiom intl_15 : intl.
Axiom intl_16 : intl.
Axiom intl_17 : intl.
Axiom intl_18 : intl.
Axiom intl_19 : intl.
Axiom intl_20 : intl.
Axiom intl_21 : intl.
Axiom intl_22 : intl.
Axiom intl_23 : intl.
Axiom intl_24 : intl.
Axiom intl_25 : intl.
Axiom intl_26 : intl.
Axiom intl_27 : intl.
Axiom intl_28 : intl.
Axiom intl_29 : intl.
Axiom intl_30 : intl.
Axiom intl_31 : intl.
Axiom intl_32 : intl.
Axiom intl_33 : intl.
Axiom intl_34 : intl.
Axiom intl_35 : intl.
Axiom intl_36 : intl.
Axiom intl_37 : intl.
Axiom intl_38 : intl.
Axiom intl_39 : intl.
Axiom intl_40 : intl.
Axiom intl_41 : intl.
Axiom intl_42 : intl.
Axiom intl_43 : intl.
Axiom intl_44 : intl.
Axiom intl_45 : intl.
Axiom intl_46 : intl.
Axiom intl_47 : intl.
Axiom intl_48 : intl.
Axiom intl_49 : intl.
Axiom intl_50 : intl.
Axiom intl_51 : intl.
Axiom intl_52 : intl.
Axiom intl_53 : intl.
Axiom intl_54 : intl.
Axiom intl_55 : intl.
Axiom intl_56 : intl.
Axiom intl_57 : intl.
Axiom intl_58 : intl.
Axiom intl_59 : intl.
Axiom intl_60 : intl.
Axiom intl_61 : intl.
Axiom intl_62 : intl.
Axiom intl_63 : intl.
Axiom intl_64 : intl.
Axiom intl_65 : intl.
Axiom intl_66 : intl.
Axiom intl_67 : intl.
Axiom intl_68 : intl.
Axiom intl_69 : intl.
Axiom intl_70 : intl.
Axiom intl_71 : intl.
Axiom intl_72 : intl.
Axiom intl_73 : intl.
Axiom intl_74 : intl.
Axiom intl_75 : intl.
Axiom intl_76 : intl.
Axiom intl_77 : intl.
Axiom intl_78 : intl.
Axiom intl_79 : intl.
Axiom intl_80 : intl.
Axiom intl_81 : intl.
Axiom intl_82 : intl.
Axiom intl_83 : intl.
Axiom intl_84 : intl.
Axiom intl_85 : intl.
Axiom intl_86 : intl.
Axiom intl_87 : intl.
Axiom intl_88 : intl.
Axiom intl_89 : intl.
Axiom intl_90 : intl.
Axiom intl_91 : intl.
Axiom intl_92 : intl.
Axiom intl_93 : intl.
Axiom intl_94 : intl.
Axiom intl_95 : intl.
Axiom intl_96 : intl.
Axiom intl_97 : intl.
Axiom intl_98 : intl.
Axiom intl_99 : intl.
Axiom intl_100 : intl.
Axiom intl_101 : intl.
Axiom intl_102 : intl.
Axiom intl_103 : intl.
Axiom intl_104 : intl.
Axiom intl_105 : intl.
Axiom intl_106 : intl.
Axiom intl_107 : intl.
Axiom intl_108 : intl.
Axiom intl_109 : intl.
Axiom intl_110 : intl.
Axiom intl_111 : intl.
Axiom intl_112 : intl.
Axiom intl_113 : intl.
Axiom intl_114 : intl.
Axiom intl_115 : intl.
Axiom intl_116 : intl.
Axiom intl_117 : intl.
Axiom intl_118 : intl.
Axiom intl_119 : intl.
Axiom intl_120 : intl.
Axiom intl_121 : intl.
Axiom intl_122 : intl.
Axiom intl_123 : intl.
Axiom intl_124 : intl.
Axiom intl_125 : intl.
Axiom intl_126 : intl.
Axiom intl_127 : intl.
Axiom intl_128 : intl.
Axiom intl_129 : intl.
Axiom intl_130 : intl.
Axiom intl_131 : intl.
Axiom intl_132 : intl.
Axiom intl_133 : intl.
Axiom intl_134 : intl.
Axiom intl_135 : intl.
Axiom intl_136 : intl.
Axiom intl_137 : intl.
Axiom intl_138 : intl.
Axiom intl_139 : intl.
Axiom intl_140 : intl.
Axiom intl_141 : intl.
Axiom intl_142 : intl.
Axiom intl_143 : intl.
Axiom intl_144 : intl.
Axiom intl_145 : intl.
Axiom intl_146 : intl.
Axiom intl_147 : intl.
Axiom intl_148 : intl.
Axiom intl_149 : intl.
Axiom intl_150 : intl.
Axiom intl_151 : intl.
Axiom intl_152 : intl.
Axiom intl_153 : intl.
Axiom intl_154 : intl.
Axiom intl_155 : intl.
Axiom intl_156 : intl.
Axiom intl_157 : intl.
Axiom intl_158 : intl.
Axiom intl_159 : intl.
Axiom intl_160 : intl.
Axiom intl_161 : intl.
Axiom intl_162 : intl.
Axiom intl_163 : intl.
Axiom intl_164 : intl.
Axiom intl_165 : intl.
Axiom intl_166 : intl.
Axiom intl_167 : intl.
Axiom intl_168 : intl.
Axiom intl_169 : intl.
Axiom intl_170 : intl.
Axiom intl_171 : intl.
Axiom intl_172 : intl.
Axiom intl_173 : intl.
Axiom intl_174 : intl.
Axiom intl_175 : intl.
Axiom intl_176 : intl.
Axiom intl_177 : intl.
Axiom intl_178 : intl.
Axiom intl_179 : intl.
Axiom intl_180 : intl.
Axiom intl_181 : intl.
Axiom intl_182 : intl.
Axiom intl_183 : intl.
Axiom intl_184 : intl.
Axiom intl_185 : intl.
Axiom intl_186 : intl.
Axiom intl_187 : intl.
Axiom intl_188 : intl.
Axiom intl_189 : intl.
Axiom intl_190 : intl.
Axiom intl_191 : intl.
Axiom intl_192 : intl.
Axiom intl_193 : intl.
Axiom intl_194 : intl.
Axiom intl_195 : intl.
Axiom intl_196 : intl.
Axiom intl_197 : intl.
Axiom intl_198 : intl.
Axiom intl_199 : intl.
Axiom intl_200 : intl.
Axiom intl_201 : intl.
Axiom intl_202 : intl.
Axiom intl_203 : intl.
Axiom intl_204 : intl.
Axiom intl_205 : intl.
Axiom intl_206 : intl.
Axiom intl_207 : intl.
Axiom intl_208 : intl.
Axiom intl_209 : intl.
Axiom intl_210 : intl.
Axiom intl_211 : intl.
Axiom intl_212 : intl.
Axiom intl_213 : intl.
Axiom intl_214 : intl.
Axiom intl_215 : intl.
Axiom intl_216 : intl.
Axiom intl_217 : intl.
Axiom intl_218 : intl.
Axiom intl_219 : intl.
Axiom intl_220 : intl.
Axiom intl_221 : intl.
Axiom intl_222 : intl.
Axiom intl_223 : intl.
Axiom intl_224 : intl.
Axiom intl_225 : intl.
Axiom intl_226 : intl.
Axiom intl_227 : intl.
Axiom intl_228 : intl.
Axiom intl_229 : intl.
Axiom intl_230 : intl.
Axiom intl_231 : intl.
Axiom intl_232 : intl.
Axiom intl_233 : intl.
Axiom intl_234 : intl.
Axiom intl_235 : intl.
Axiom intl_236 : intl.
Axiom intl_237 : intl.
Axiom intl_238 : intl.
Axiom intl_239 : intl.
Axiom intl_240 : intl.
Axiom intl_241 : intl.
Axiom intl_242 : intl.
Axiom intl_243 : intl.
Axiom intl_244 : intl.
Axiom intl_245 : intl.
Axiom intl_246 : intl.
Axiom intl_247 : intl.
Axiom intl_248 : intl.
Axiom intl_249 : intl.
Axiom intl_250 : intl.
Axiom intl_251 : intl.
Axiom intl_252 : intl.
Axiom intl_253 : intl.
Axiom intl_254 : intl.
Axiom intl_255 : intl.
Axiom intl_256 : intl.

Notation "0" := intl_0 : intl_scope.
Notation "1" := intl_1 : intl_scope.
Notation "2" := intl_2 : intl_scope.
Notation "3" := intl_3 : intl_scope.
Notation "4" := intl_4 : intl_scope.
Notation "5" := intl_5 : intl_scope.
Notation "6" := intl_6 : intl_scope.
Notation "7" := intl_7 : intl_scope.
Notation "8" := intl_8 : intl_scope.
Notation "9" := intl_9 : intl_scope.
Notation "10" := intl_10 : intl_scope.
Notation "11" := intl_11 : intl_scope.
Notation "12" := intl_12 : intl_scope.
Notation "13" := intl_13 : intl_scope.
Notation "14" := intl_14 : intl_scope.
Notation "15" := intl_15 : intl_scope.
Notation "16" := intl_16 : intl_scope.
Notation "17" := intl_17 : intl_scope.
Notation "18" := intl_18 : intl_scope.
Notation "19" := intl_19 : intl_scope.
Notation "20" := intl_20 : intl_scope.
Notation "21" := intl_21 : intl_scope.
Notation "22" := intl_22 : intl_scope.
Notation "23" := intl_23 : intl_scope.
Notation "24" := intl_24 : intl_scope.
Notation "25" := intl_25 : intl_scope.
Notation "26" := intl_26 : intl_scope.
Notation "27" := intl_27 : intl_scope.
Notation "28" := intl_28 : intl_scope.
Notation "29" := intl_29 : intl_scope.
Notation "30" := intl_30 : intl_scope.
Notation "31" := intl_31 : intl_scope.
Notation "32" := intl_32 : intl_scope.
Notation "33" := intl_33 : intl_scope.
Notation "34" := intl_34 : intl_scope.
Notation "35" := intl_35 : intl_scope.
Notation "36" := intl_36 : intl_scope.
Notation "37" := intl_37 : intl_scope.
Notation "38" := intl_38 : intl_scope.
Notation "39" := intl_39 : intl_scope.
Notation "40" := intl_40 : intl_scope.
Notation "41" := intl_41 : intl_scope.
Notation "42" := intl_42 : intl_scope.
Notation "43" := intl_43 : intl_scope.
Notation "44" := intl_44 : intl_scope.
Notation "45" := intl_45 : intl_scope.
Notation "46" := intl_46 : intl_scope.
Notation "47" := intl_47 : intl_scope.
Notation "48" := intl_48 : intl_scope.
Notation "49" := intl_49 : intl_scope.
Notation "50" := intl_50 : intl_scope.
Notation "51" := intl_51 : intl_scope.
Notation "52" := intl_52 : intl_scope.
Notation "53" := intl_53 : intl_scope.
Notation "54" := intl_54 : intl_scope.
Notation "55" := intl_55 : intl_scope.
Notation "56" := intl_56 : intl_scope.
Notation "57" := intl_57 : intl_scope.
Notation "58" := intl_58 : intl_scope.
Notation "59" := intl_59 : intl_scope.
Notation "60" := intl_60 : intl_scope.
Notation "61" := intl_61 : intl_scope.
Notation "62" := intl_62 : intl_scope.
Notation "63" := intl_63 : intl_scope.
Notation "64" := intl_64 : intl_scope.
Notation "65" := intl_65 : intl_scope.
Notation "66" := intl_66 : intl_scope.
Notation "67" := intl_67 : intl_scope.
Notation "68" := intl_68 : intl_scope.
Notation "69" := intl_69 : intl_scope.
Notation "70" := intl_70 : intl_scope.
Notation "71" := intl_71 : intl_scope.
Notation "72" := intl_72 : intl_scope.
Notation "73" := intl_73 : intl_scope.
Notation "74" := intl_74 : intl_scope.
Notation "75" := intl_75 : intl_scope.
Notation "76" := intl_76 : intl_scope.
Notation "77" := intl_77 : intl_scope.
Notation "78" := intl_78 : intl_scope.
Notation "79" := intl_79 : intl_scope.
Notation "80" := intl_80 : intl_scope.
Notation "81" := intl_81 : intl_scope.
Notation "82" := intl_82 : intl_scope.
Notation "83" := intl_83 : intl_scope.
Notation "84" := intl_84 : intl_scope.
Notation "85" := intl_85 : intl_scope.
Notation "86" := intl_86 : intl_scope.
Notation "87" := intl_87 : intl_scope.
Notation "88" := intl_88 : intl_scope.
Notation "89" := intl_89 : intl_scope.
Notation "90" := intl_90 : intl_scope.
Notation "91" := intl_91 : intl_scope.
Notation "92" := intl_92 : intl_scope.
Notation "93" := intl_93 : intl_scope.
Notation "94" := intl_94 : intl_scope.
Notation "95" := intl_95 : intl_scope.
Notation "96" := intl_96 : intl_scope.
Notation "97" := intl_97 : intl_scope.
Notation "98" := intl_98 : intl_scope.
Notation "99" := intl_99 : intl_scope.
Notation "100" := intl_100 : intl_scope.
Notation "101" := intl_101 : intl_scope.
Notation "102" := intl_102 : intl_scope.
Notation "103" := intl_103 : intl_scope.
Notation "104" := intl_104 : intl_scope.
Notation "105" := intl_105 : intl_scope.
Notation "106" := intl_106 : intl_scope.
Notation "107" := intl_107 : intl_scope.
Notation "108" := intl_108 : intl_scope.
Notation "109" := intl_109 : intl_scope.
Notation "110" := intl_110 : intl_scope.
Notation "111" := intl_111 : intl_scope.
Notation "112" := intl_112 : intl_scope.
Notation "113" := intl_113 : intl_scope.
Notation "114" := intl_114 : intl_scope.
Notation "115" := intl_115 : intl_scope.
Notation "116" := intl_116 : intl_scope.
Notation "117" := intl_117 : intl_scope.
Notation "118" := intl_118 : intl_scope.
Notation "119" := intl_119 : intl_scope.
Notation "120" := intl_120 : intl_scope.
Notation "121" := intl_121 : intl_scope.
Notation "122" := intl_122 : intl_scope.
Notation "123" := intl_123 : intl_scope.
Notation "124" := intl_124 : intl_scope.
Notation "125" := intl_125 : intl_scope.
Notation "126" := intl_126 : intl_scope.
Notation "127" := intl_127 : intl_scope.
Notation "128" := intl_128 : intl_scope.
Notation "129" := intl_129 : intl_scope.
Notation "130" := intl_130 : intl_scope.
Notation "131" := intl_131 : intl_scope.
Notation "132" := intl_132 : intl_scope.
Notation "133" := intl_133 : intl_scope.
Notation "134" := intl_134 : intl_scope.
Notation "135" := intl_135 : intl_scope.
Notation "136" := intl_136 : intl_scope.
Notation "137" := intl_137 : intl_scope.
Notation "138" := intl_138 : intl_scope.
Notation "139" := intl_139 : intl_scope.
Notation "140" := intl_140 : intl_scope.
Notation "141" := intl_141 : intl_scope.
Notation "142" := intl_142 : intl_scope.
Notation "143" := intl_143 : intl_scope.
Notation "144" := intl_144 : intl_scope.
Notation "145" := intl_145 : intl_scope.
Notation "146" := intl_146 : intl_scope.
Notation "147" := intl_147 : intl_scope.
Notation "148" := intl_148 : intl_scope.
Notation "149" := intl_149 : intl_scope.
Notation "150" := intl_150 : intl_scope.
Notation "151" := intl_151 : intl_scope.
Notation "152" := intl_152 : intl_scope.
Notation "153" := intl_153 : intl_scope.
Notation "154" := intl_154 : intl_scope.
Notation "155" := intl_155 : intl_scope.
Notation "156" := intl_156 : intl_scope.
Notation "157" := intl_157 : intl_scope.
Notation "158" := intl_158 : intl_scope.
Notation "159" := intl_159 : intl_scope.
Notation "160" := intl_160 : intl_scope.
Notation "161" := intl_161 : intl_scope.
Notation "162" := intl_162 : intl_scope.
Notation "163" := intl_163 : intl_scope.
Notation "164" := intl_164 : intl_scope.
Notation "165" := intl_165 : intl_scope.
Notation "166" := intl_166 : intl_scope.
Notation "167" := intl_167 : intl_scope.
Notation "168" := intl_168 : intl_scope.
Notation "169" := intl_169 : intl_scope.
Notation "170" := intl_170 : intl_scope.
Notation "171" := intl_171 : intl_scope.
Notation "172" := intl_172 : intl_scope.
Notation "173" := intl_173 : intl_scope.
Notation "174" := intl_174 : intl_scope.
Notation "175" := intl_175 : intl_scope.
Notation "176" := intl_176 : intl_scope.
Notation "177" := intl_177 : intl_scope.
Notation "178" := intl_178 : intl_scope.
Notation "179" := intl_179 : intl_scope.
Notation "180" := intl_180 : intl_scope.
Notation "181" := intl_181 : intl_scope.
Notation "182" := intl_182 : intl_scope.
Notation "183" := intl_183 : intl_scope.
Notation "184" := intl_184 : intl_scope.
Notation "185" := intl_185 : intl_scope.
Notation "186" := intl_186 : intl_scope.
Notation "187" := intl_187 : intl_scope.
Notation "188" := intl_188 : intl_scope.
Notation "189" := intl_189 : intl_scope.
Notation "190" := intl_190 : intl_scope.
Notation "191" := intl_191 : intl_scope.
Notation "192" := intl_192 : intl_scope.
Notation "193" := intl_193 : intl_scope.
Notation "194" := intl_194 : intl_scope.
Notation "195" := intl_195 : intl_scope.
Notation "196" := intl_196 : intl_scope.
Notation "197" := intl_197 : intl_scope.
Notation "198" := intl_198 : intl_scope.
Notation "199" := intl_199 : intl_scope.
Notation "200" := intl_200 : intl_scope.
Notation "201" := intl_201 : intl_scope.
Notation "202" := intl_202 : intl_scope.
Notation "203" := intl_203 : intl_scope.
Notation "204" := intl_204 : intl_scope.
Notation "205" := intl_205 : intl_scope.
Notation "206" := intl_206 : intl_scope.
Notation "207" := intl_207 : intl_scope.
Notation "208" := intl_208 : intl_scope.
Notation "209" := intl_209 : intl_scope.
Notation "210" := intl_210 : intl_scope.
Notation "211" := intl_211 : intl_scope.
Notation "212" := intl_212 : intl_scope.
Notation "213" := intl_213 : intl_scope.
Notation "214" := intl_214 : intl_scope.
Notation "215" := intl_215 : intl_scope.
Notation "216" := intl_216 : intl_scope.
Notation "217" := intl_217 : intl_scope.
Notation "218" := intl_218 : intl_scope.
Notation "219" := intl_219 : intl_scope.
Notation "220" := intl_220 : intl_scope.
Notation "221" := intl_221 : intl_scope.
Notation "222" := intl_222 : intl_scope.
Notation "223" := intl_223 : intl_scope.
Notation "224" := intl_224 : intl_scope.
Notation "225" := intl_225 : intl_scope.
Notation "226" := intl_226 : intl_scope.
Notation "227" := intl_227 : intl_scope.
Notation "228" := intl_228 : intl_scope.
Notation "229" := intl_229 : intl_scope.
Notation "230" := intl_230 : intl_scope.
Notation "231" := intl_231 : intl_scope.
Notation "232" := intl_232 : intl_scope.
Notation "233" := intl_233 : intl_scope.
Notation "234" := intl_234 : intl_scope.
Notation "235" := intl_235 : intl_scope.
Notation "236" := intl_236 : intl_scope.
Notation "237" := intl_237 : intl_scope.
Notation "238" := intl_238 : intl_scope.
Notation "239" := intl_239 : intl_scope.
Notation "240" := intl_240 : intl_scope.
Notation "241" := intl_241 : intl_scope.
Notation "242" := intl_242 : intl_scope.
Notation "243" := intl_243 : intl_scope.
Notation "244" := intl_244 : intl_scope.
Notation "245" := intl_245 : intl_scope.
Notation "246" := intl_246 : intl_scope.
Notation "247" := intl_247 : intl_scope.
Notation "248" := intl_248 : intl_scope.
Notation "249" := intl_249 : intl_scope.
Notation "250" := intl_250 : intl_scope.
Notation "251" := intl_251 : intl_scope.
Notation "252" := intl_252 : intl_scope.
Notation "253" := intl_253 : intl_scope.
Notation "254" := intl_254 : intl_scope.
Notation "255" := intl_255 : intl_scope.
Notation "256" := intl_256 : intl_scope.
