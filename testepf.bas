
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


main
    COLUBK = 12
    COLUPF = 44

    drawscreen

end

    if joy0up then missile1y = missile1y - 1
    if joy0down then missile1y = missile1y + 1
    if joy0left then missile1x = missile1x - 1
    if joy0right then missile1x = missile1x + 1

    ; Se nao colidir bypass pra skip limpa tijolo e nao faz nada relacionado a isso
    if !collision(playfield,missile1) then goto __skip_limpa_tijolo 
    ; se colidir ele faz as linhas abaixo

    ; armazena nas variaveis x e y a posicao do missile ao colidir


    missile1x=(missile1x-18)/4
    missile1y=((missile1y-1)/8)
    pfpixel missile1x missile1y off

    ; zera a posicao do missile - isso eh apenas nesse exemplo no jogo real isso ja acontece no sistema que usamos nos misseis.
    ; para nao criar aquiilo tudo de novo fiz este simples so pra tirar o missile de cima do pf 
    missile1x = 50
    missile1y = 80

__skip_limpa_tijolo


    goto main