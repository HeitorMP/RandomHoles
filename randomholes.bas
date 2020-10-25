
  rem teste jogo 1
  rem por Heitor Maciel

  set kernel_options no_blank_lines
  const pfscore = 1
  
  dim _Ch0_Sound = a
  ; b - Livre
  ; c - usada para o buraco
  ; d - usada para o buraco
  dim _cont_escudo = e
  dim _duracao_som0 = f
  dim _duracao_som1 = g
  dim musicPointer = h
  ; i - Livre
  dim _bit_supressores = j  
  ; {0} - reset
  ; {1} - 
  ; {2} - vai e vem dos inimigos
  ; {3} - som
  ; {4} - escudo
  ; {5} -  ativa transicao de tela
  ; {6} - ativa nave fora da barreira
  ; {7} - ativa item na tela
  dim musicTimer = k
  dim _dificuldade = l
  dim _Ch1_Sound = m
  dim _animacao = n
  dim _SC_Back = o
  ; p - Livre
  dim _fases = q
  dim _cont_anima_morte = r
  dim _cont_telas = s
  ; t = Livre
  ; v = Livre no main, usada na transicao
  ; x = Livre   
  dim rand16 = z

 
__reset_game


  a = 0 : d = 0 : e = 0 : f = 0 : g = 0 : h = 0
  j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0 : r = 0
  s = 0 : t = 0 : u = 0 : v = 0 : w = 0 : x = 0 : y = 0

  rem DESLIGA O SOM
  AUDV0 = 0 : AUDV1 = 0

  score = 0
  scorecolor = $00
  missile1y = 0
  COLUP1 = 00

  player1x = 75 : player1y = 85
  player0x = 20 : player0y = 1

  pfscore1=%00010101 : pfscorecolor = $40
  pfscore2=%00010101
  missile1height=5
 

  gosub __playfield_transicao
 
__title_screen
   COLUPF = $00 : COLUBK = $8A
  AUDC0 = 12
  AUDC1 = 1
  
  if joy0fire then e = 1
  if e = 0 then goto __skip_sound_title
  if musicTimer = 0 then goto changeMusicNoteTitle

__volta_trilha_title
  musicTimer = musicTimer - 1
__skip_sound_title

  pfscore1 = 0 : scorecolor = $00
  gosub __nave
  _animacao = 10
  drawscreen
  COLUBK=$00
  COLUPF=$06
  player0y = 0
  COLUP1 = $0E
  player1y = 85
  player1x = 75

  if joy0fire then e = 1
  if e = 1 then pfscroll down
   ; COR DA BARRA DO SCORE
  _SC_Back = $70
  if !pfread(0,11) then goto __prepara_main
  goto __title_screen

__prepara_main
  AUDV0 = 0
  AUDV1 = 0
  a = 0 : d = 0 : e = 0 : f = 0 : g = 0 : h = 0
  j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0 : r = 0
  s = 0 : t = 0 : u = 0 : v = 0 : w = 0 : x = 0 : y = 0
    pfscore1=%00010101 : pfscorecolor = $40
  pfscore2=%00010101
  missile1height=5
  
 ; COR DA BARRA DO SCORE
  _SC_Back = $70

__Main_Loop

  ; COR DO SCORE
   scorecolor = 14

  ; ATIVA NAVE FORA DA BARREIRA
  if player1x < 20 || player1x > 133 then _bit_supressores{6} = 1 else _bit_supressores{6} = 0

  ;cSOMA PONTO AO ACELERAR
  if _bit_supressores{6} then goto __skip_aceletarion_point 
  if joy0up then pfscroll down : score = score + 1
__skip_aceletarion_point
  ; MOVIMENTO LATERAL
     
  if joy0left && player1x > 1 then player1x = player1x - 1 : goto __skip_joy
  if joy0right && player1x < 150 then player1x = player1x + 1 : goto __skip_joy

__skip_joy


  ; ESCUDO *******
  if !_bit_supressores{4} then gosub __nave
  if _bit_supressores{4} then goto __skip_escudo
  if pfscore1 = 0  then _bit_supressores{4} = 0 : goto __skip_escudo
  if joy0down then _bit_supressores{4} = 1 : e = 40 : goto __escudo
__skip_escudo

 ; MISSILE *****
  if missile1y > 240 then _bit_supressores{1} = 0 : goto __skip_missile1
  missile1y = missile1y - 2
__skip_missile1
  if _bit_supressores{1} then __skip_fire
  if joy0fire then AUDV0 = 0 : _duracao_som0 = 10 : _bit_supressores{1} = 1 : _bit_supressores{3} = 1 : missile1y = player1y - 3:missile1x = player1x + 5
__skip_fire

  gosub __regular
; Fases
__fases
  if _cont_telas >= 10 && !_bit_supressores{5} then _cont_telas = 10 : _bit_supressores{5} = 1
  if _bit_supressores{5} then goto __transicao
 
__skip_transicao
  if _fases > 200 then _fases = 0

  if _fases = 0 then COLUPF = $00 : COLUBK = $8A : gosub __inimigo_bomba : goto __skip_fase_inimigo
  
  if _fases >= 1 then goto __fase1_inimigo
__fase1_inimigo
  COLUPF = $04
  COLUBK = $00
  COLUP1 = 14
  if !_bit_supressores{7} then gosub __inimigo_tie else gosub __item_shield

__skip_fase_inimigo
  ; CONTADORES
  _animacao = _animacao + 1
  if _animacao =  21 then _animacao = 0

  _cont_escudo = _cont_escudo - 1
  if _cont_escudo = 0 && _bit_supressores{4} then pfscore1 = pfscore1/4 : _bit_supressores{4} = 0

  if _fases < 4 then c = d + 8 : goto __skip_dificuldade
  if _fases < 8 then goto __randomicos
  if _fases < 100 then c = d + 2 : goto __skip_dificuldade

__randomicos
  ; TAMANHO DO BURACO RANDOMICO - VALOR DE _dificuldade E GERADO EM REDESENHA
  if _dificuldade = 0 then c = d + 8 : goto __skip_dificuldade
  if _dificuldade = 1 then c = d + 6 : goto __skip_dificuldade
  if _dificuldade = 2 then c = d + 4 : goto __skip_dificuldade
  if _dificuldade = 3 then c = d + 2 : goto __skip_dificuldade

__skip_dificuldade

  
 ; ABRE O BURACO NA TELA DE ACORO COM OS VALORES DE D E C
  pfhline d 1 c off

  
  ballx = 80
  bally = 5
   ;if joy0up then bally = bally + 1
  CTRLPF = $31
  goto __pfscroll

__skip_scroll

__skip_perde_vida
 
; COLISOES E COLISOES POR FASE
   if _bit_supressores{4} then goto __skip_collision : rem se escudo on pula as colisoes

   if collision(ball,player1) then _duracao_som0 = 80 :  pfscore2 = pfscore2/4 : goto __perde_vida
   if collision(ball,missile1) then bally = 100 : missile1y = 0
   if collision(player1,playfield) then _duracao_som0 = 80 :  pfscore2 = pfscore2/4 : goto __perde_vida
   if collision(missile1,playfield) then missile1y = 1
   

__skip_collision


   if _fases = 0 then goto __fase0
   if _fases >= 1 then goto __fase1


__fase0
   if collision(missile1,player0) then missile1y = 0 : _bit_supressores{3} = 0 : _duracao_som0 = 10 : score = score + 100 : player0y = 0
   if collision(player0,player1) then _duracao_som0 = 80 : pfscore2 = pfscore2/4 : goto __perde_vida
   goto __skip_collision_fases
__fase1
  if _bit_supressores{7} then goto __collision_itemshield
  
  if collision(missile1,player0) then missile1y = 0 : _bit_supressores{3} = 0 : _duracao_som0 = 10 : score = score + 100 : _bit_supressores{7} = 1
  if collision(player0,player1) then _duracao_som0 = 80 : pfscore2 = pfscore2/4 : goto __perde_vida
  goto __skip_collision_fases

__collision_itemshield
  if collision(missile1,player0) then missile1y = 0 : _bit_supressores{3} = 0 : _duracao_som0 = 10 : _bit_supressores{7} = 0 : player0y = 0
  if collision(player0,player1) then player0y = 0 : _bit_supressores{7} = 0 : pfscore1 = %00010101

__skip_collision_fases
  drawscreen
  ; SOMS
  if _bit_supressores{3} then goto __skip_som_morte_inimigo
  if _duracao_som0 = 0 then AUDV0 = 0 : goto __skip_som_morte_inimigo

  AUDV0 = 15 : rem volume
  AUDC0 = 12 : rem tom
  AUDF0 = 10 : rem distorcao
  _duracao_som0 = _duracao_som0 - 1
__skip_som_morte_inimigo

  ; Som do tiro
  if !_bit_supressores{3} then goto __skip_som_tiro
  if _duracao_som0 = 0 then AUDV0 = 0 : _bit_supressores{3} = 0 : goto __skip_som_tiro
  AUDV0=15 : rem volume
  AUDC0 = 8 : rem tom
  AUDF0 = 8 : rem distorcao
  _duracao_som0 = _duracao_som0 - 1
__skip_som_tiro

  ; FIM DO MAIN LOOP
  if switchreset then goto __reset_game
  goto __Main_Loop
  ; FIM DO MAIN LOOP


__game_over
  gosub __playfield_regular
  drawscreen
  if !switchreset then goto __game_over
  goto __reset_game

__pfscroll
  pfscroll down
  goto __skip_scroll

  ; CENA PRINCIPAL ONDE HA BURACOS
__regular
 
  if !pfread(0,11) then _dificuldade = (rand&3) : goto __redesenha else return thisbank

__redesenha
  if player1x > 19 && player1x < 134 then _cont_telas = _cont_telas + 1
  d = (rand/16) + 1
  d = d + 2
  gosub __playfield_regular

  return thisbank


__perde_vida
  gosub __playfield_regular
  bally = 0
  missile1y = 0
  COLUPF = 10
  COLUBK = 25
  COLUP1 = $40
  player0y = 0
  _cont_anima_morte = _cont_anima_morte + 1

  if _cont_anima_morte = 20 then player1:
  %0101000
  %0010010
  %1001000
  %0010101
  %1000000
  %0010100
end
  if _cont_anima_morte = 40 then player1:
  %0001000
  %0010100
  %0101010
  %0010100
  %0001000
  %0000000
end
  drawscreen

  if _cont_anima_morte = 40 then _cont_anima_morte = 0


  if _duracao_som0 = 0 then AUDV0 = 0 : goto __skip_som_explosao
  _duracao_som0  = _duracao_som0 - 1
  AUDV0 = 8 : rem volume
  AUDC0 = 8: rem tom
  AUDF0 = 25 : rem distorcao
__skip_som_explosao
  if pfscore2 = %00000000 then goto __skip_reinicia_joy
  if joy0fire then _animacao = 10 : _duracao_som0 = 0 : player1x = 80 : goto __skip_perde_vida
__skip_reinicia_joy
  if !switchreset then goto __perde_vida
  goto __reset_game

 ; INIMIGOS
__inimigo_bomba
  COLUP0 = $40
  player0:
  %00011000
  %00111100
  %01111110
  %01100110
  %01011010
  %01111110
  %01011010
  %00011000
  %00111100
end  
  
  player0y = player0y+2
  if joy0up then player0y = player0y + 2

  if player0y <= 2 then player0x = (rand&63) + (rand&31) + (rand&15) + (rand&1) + 21
  return thisbank

__inimigo_carga
  COLUP0 = $04
  NUSIZ0 = $05
  player0x = player0x - 1
  player0y = 30
  player0:
  %00000100
  %00001010
  %00010100
  %11101111
  %01111111
  %00111111
  %00000001
end
  return thisbank


__inimigo_tie
  COLUP0 = $04
  player0:
  %10000001
  %10000001
  %10011001
  %11111111
  %10011001
  %10000001
  %10000001
end
 
  if player0y > 10 then goto __skip_tie

  if _bit_supressores{2}  then goto __volta else goto __vai

__volta
  player0x = player0x - 1
  if player0x <= 30 then player0y = player0y + 5 : _bit_supressores{2} = 0
  goto __skip_vai_volta_tie
__vai
  player0x = player0x + 1
  if player0x >= 120 then player0y = player0y + 5 : _bit_supressores{2} = 1
  goto __skip_vai_volta_tie
__skip_tie

  if player1x > player0x then player0x = player0x + 1
  if player1x < player0x then player0x = player0x - 1 
  player0y = player0y + 1


__skip_vai_volta_tie
 

  return thisbank

 ; ESCUDO
__escudo
  player1:
  %1001001
  %1111111
  %1011101
  %0001000
  %0001000
  %1001001
  %0100010
  %0010100
  %0001000
end
 goto __skip_escudo

__nave
  if _animacao = 10 || joy0up then player1:
  %1001001
  %1111111
  %1011101
  %0001000
  %0001000
  %0001000
end

  if _animacao = 20 then player1:
  %1000001
  %1111111
  %1011101
  %0001000
  %0001000
  %0001000
end

  return thisbank

 ;ITEM SHIELD
__item_shield
 COLUP0 = 12
  if joy0up then player0y = player0y + 1
  player0y = player0y + 1
  player0:
  %00111100
  %01000010
  %10111101
  %10000101
  %10000101
  %10111101
  %10100001
  %10111101
  %01000010
  %00111100
end
  if player0y < 2 then _bit_supressores{7} = 0
  return thisbank

 ; TRANSICAO ENTRE AS FASES
__transicao
 v = 0 ; para poder usar a variavel v no main tambem.
__main_transicao
  missile1y = 0
  ;bally = 100

  AUDC0 = 12
  AUDC1 = 1

  if musicTimer = 0 then goto changeMusicNoteTransicao 
__volta_trilha_transicao
  musicTimer = musicTimer - 1
  

  player0y = 0
  gosub __playfield_transicao
  drawscreen

  if player1x = 75 then goto __move_up
  if player1x > 75 then goto __move_esquerda
  
  player1x = player1x + 1 : goto __skip_move
__move_esquerda
  player1x = player1x - 1 : goto __skip_move
__move_up
  if player1y = 0 then goto __skip_move
  player1y = player1y - 1 
__skip_move

  v = v + 1
  if v = 250 then v = 0 : _fases = _fases + 1 : _bit_supressores{5} = 0 : _cont_telas = 0 : AUDV0 = 0 : AUDV1 = 0 :  musicPointer = 0 : player1y = 85 : goto __skip_transicao
  goto __main_transicao


__playfield_regular
  playfield:
  .XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.
  X.X.X.X.X.X.X.X.X.X.X.X.X.X.X..X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
end
  return thisbank

; PLAYFIELD USADO NO TITLE E NA TRANSICAO
__playfield_transicao
  playfield:
  .XXXXXXXXXXXX.....XXXXXXXXXXXXX.
  X.X.X.X.X.X.X.....X.X.X.X.X.X..X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
end
  return thisbank

changeMusicNoteTransicao
  AUDF0 = musicData1[musicPointer]
  AUDF1 = musicData2[musicPointer]
  if musicData1[musicPointer] = 255 then AUDV1 = 0 else AUDV1 = 6
  if musicData2[musicPointer] = 255 then AUDV0 = 0 else AUDV0 = 4
  musicTimer = 10
  musicPointer = musicPointer + 1
  if musicPointer > 22 then musicPointer = 0
  goto __volta_trilha_transicao

changeMusicNoteTitle
  AUDF0 = musicData1[musicPointer]
  AUDF1 = musicData2[musicPointer]
  if musicData1[musicPointer] = 255 then AUDV1 = 0 else AUDV1 = 6
  if musicData2[musicPointer] = 255 then AUDV0 = 0 else AUDV0 = 4
  musicTimer = 10
  musicPointer = musicPointer + 1
  if musicPointer > 22 then musicPointer = 0
  goto __volta_trilha_title
; DATA SOM

  data musicData1
    29, -1, 29, -1, 29, -1,
    26, -1, 26, -1, 26, -1,
    24, -1, 24, -1, 24, -1,
    19, 19, 19, 19,
    255,
end

  data musicData2
    23, -1, 23, -1, 23, -1,
    26, -1, 26, -1, 26, -1, 
    29, -1, 29, -1, 29, -1,
    23, 23, 23, 23,
    255,
end

   asm
minikernel
   sta WSYNC
   lda _SC_Back
   sta COLUBK
   rts
end
