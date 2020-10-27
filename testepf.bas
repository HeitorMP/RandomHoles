
    rem teste jogo tipo breakout 1
    rem por Heitor Maciel

    set kernel_options no_blank_lines


    a = 0 : d = 0 : e = 0 : f = 0 : g = 0 : h = 0
    j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0 : r = 0
    s = 0 : t = 0 : u = 0 : v = 0 : w = 0 : x = 0 : y = 0

    missile1x = 50
    missile1y = 80
    player0x = 50
    player0y = 80
    COLUP0 = 00

        playfield:
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXX.X.X.X.X.X.X.X..X
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
    player0x = 40
    player0y = 50

main
    COLUBK = 12
    COLUPF = 44

    drawscreen

end

    player0:
    %00111100
end

    if joy0up then player0y = player0y - 1
    if joy0down then player0y = player0y + 1
    if joy0left then player0x = player0x - 1
    if joy0right then player0x = player0x + 1

    ; Se nao colidir bypass pra skip limpa tijolo e nao faz nada relacionado a isso
    if !collision(playfield,player0) then goto __skip_limpa_tijolo 
    ; se colidir ele faz as linhas abaixo

    ; armazena nas variaveis x e y a posicao do missile ao colidir

    player0x=((player0x-15)/4)
    player0y=(player0y-1)/8
    if pfread(player0x, player0y) then goto __colisao_normal else goto __colisao_corrigida
__colisao_normal
    pfpixel player0x player0y off
    goto __skip_colisao_normal
__colisao_corrigida
    player0x = player0x + 1
    pfpixel player0x player0y off
__skip_colisao_normal

    ; zera a posicao do missile - isso eh apenas nesse exemplo no jogo real isso ja acontece no sistema que usamos nos misseis.
    ; para nao criar aquiilo tudo de novo fiz este simples so pra tirar o missile de cima do pf 
    player0x = 40
    player0y = 80

__skip_limpa_tijolo


    goto main