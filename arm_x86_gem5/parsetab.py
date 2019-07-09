
# parsetab.py
# This file is automatically generated. Do not edit.
_tabversion = '3.2'

_lr_method = 'LALR'

_lr_signature = '@\xbcf_\xec\xc3E\xd1\x93\x8fn7C\xf6V\xda'
    
_lr_action_items = {'LBRACE':([9,13,],[11,11,]),'RPAREN':([40,],[44,]),'ROM':([6,],[9,]),'SEMI':([11,12,14,15,18,19,21,22,25,27,28,31,33,34,35,37,38,41,43,44,],[-17,24,-17,-16,-15,-12,34,-21,39,-11,-13,-20,-18,-19,-14,-23,-29,-22,-30,45,]),'NEWLINE':([11,14,15,16,17,18,19,21,22,28,29,30,31,33,34,35,36,37,38,41,42,43,],[-17,-17,-16,29,-24,-15,-12,33,-21,-13,-26,-25,-20,-18,-19,-14,-27,-23,-29,-22,-28,-30,]),'LPAREN':([13,],[26,]),'RBRACE':([14,19,28,33,34,35,],[27,-12,-13,-18,-19,-14,]),'COLON':([22,31,32,],[36,36,42,]),'DOT':([11,14,19,28,33,34,35,],[23,23,-12,-13,-18,-19,-14,]),'MACROOP':([6,],[10,]),'EXTERN':([11,14,16,17,19,28,29,30,33,34,35,36,42,],[20,20,20,-24,-12,-13,-26,-25,-18,-19,-14,-27,-28,]),'PARAMS':([22,31,38,],[37,41,43,]),'ID':([10,11,14,16,17,19,20,23,26,28,29,30,33,34,35,36,42,],[13,22,22,31,-24,-12,32,38,40,-13,-26,-25,-18,-19,-14,-27,-28,]),'DEF':([0,1,2,3,7,8,24,39,45,],[6,-7,6,-6,-4,-5,-8,-10,-9,]),'$end':([0,1,2,3,4,5,7,8,24,39,45,],[-2,-7,-3,-6,0,-1,-4,-5,-8,-10,-9,]),}

_lr_action = { }
for _k, _v in _lr_action_items.items():
   for _x,_y in zip(_v[0],_v[1]):
      if not _x in _lr_action:  _lr_action[_x] = { }
      _lr_action[_x][_k] = _y
del _lr_action_items

_lr_goto_items = {'macroop_def':([0,2,],[1,1,]),'statements':([11,],[14,]),'statement':([11,14,],[19,28,]),'directive':([11,14,],[15,15,]),'rom_or_macros':([0,],[2,]),'labels':([11,14,],[16,16,]),'end_of_statement':([21,],[35,]),'microop':([11,14,],[18,18,]),'label':([11,14,16,],[17,17,30,]),'rom_block':([0,2,],[3,3,]),'file':([0,],[4,]),'content_of_statement':([11,14,],[21,21,]),'opt_rom_or_macros':([0,],[5,]),'block':([9,13,],[12,25,]),'rom_or_macro':([0,2,],[7,8,]),}

_lr_goto = { }
for _k, _v in _lr_goto_items.items():
   for _x,_y in zip(_v[0],_v[1]):
       if not _x in _lr_goto: _lr_goto[_x] = { }
       _lr_goto[_x][_k] = _y
del _lr_goto_items
_lr_productions = [
  ("S' -> file","S'",1,None,None,None),
  ('file -> opt_rom_or_macros','file',1,'p_file','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',313),
  ('opt_rom_or_macros -> <empty>','opt_rom_or_macros',0,'p_opt_rom_or_macros_0','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',316),
  ('opt_rom_or_macros -> rom_or_macros','opt_rom_or_macros',1,'p_opt_rom_or_macros_1','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',319),
  ('rom_or_macros -> rom_or_macro','rom_or_macros',1,'p_rom_or_macros_0','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',322),
  ('rom_or_macros -> rom_or_macros rom_or_macro','rom_or_macros',2,'p_rom_or_macros_1','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',325),
  ('rom_or_macro -> rom_block','rom_or_macro',1,'p_rom_or_macro_0','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',328),
  ('rom_or_macro -> macroop_def','rom_or_macro',1,'p_rom_or_macro_0','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',329),
  ('rom_block -> DEF ROM block SEMI','rom_block',4,'p_rom_block','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',333),
  ('macroop_def -> DEF MACROOP ID LPAREN ID RPAREN SEMI','macroop_def',7,'p_macroop_def_0','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',343),
  ('macroop_def -> DEF MACROOP ID block SEMI','macroop_def',5,'p_macroop_def_1','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',353),
  ('block -> LBRACE statements RBRACE','block',3,'p_block','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',365),
  ('statements -> statement','statements',1,'p_statements_0','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',371),
  ('statements -> statements statement','statements',2,'p_statements_1','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',378),
  ('statement -> content_of_statement end_of_statement','statement',2,'p_statement','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',384),
  ('content_of_statement -> microop','content_of_statement',1,'p_content_of_statement_0','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',389),
  ('content_of_statement -> directive','content_of_statement',1,'p_content_of_statement_0','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',390),
  ('content_of_statement -> <empty>','content_of_statement',0,'p_content_of_statement_1','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',395),
  ('end_of_statement -> NEWLINE','end_of_statement',1,'p_end_of_statement','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',400),
  ('end_of_statement -> SEMI','end_of_statement',1,'p_end_of_statement','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',401),
  ('microop -> labels ID','microop',2,'p_microop_0','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',406),
  ('microop -> ID','microop',1,'p_microop_1','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',413),
  ('microop -> labels ID PARAMS','microop',3,'p_microop_2','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',419),
  ('microop -> ID PARAMS','microop',2,'p_microop_3','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',427),
  ('labels -> label','labels',1,'p_labels_0','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',435),
  ('labels -> labels label','labels',2,'p_labels_1','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',439),
  ('labels -> labels NEWLINE','labels',2,'p_labels_2','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',445),
  ('label -> ID COLON','label',2,'p_label_0','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',449),
  ('label -> EXTERN ID COLON','label',3,'p_label_1','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',456),
  ('directive -> DOT ID','directive',2,'p_directive_0','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',464),
  ('directive -> DOT ID PARAMS','directive',3,'p_directive_1','/home/cuihongwei/experiment/experiment-gem5/raw-gem5/build/X86_MESI_Two_Level/arch/micro_asm.py',470),
]
