.data
intro1: .asciiz "O programa dever receber uma matriz quadrada de ordem 3\n"
intro2: .asciiz "Insira os elementos na ordem n11[ENTER],n12[ENTER] e assim por diante \n"
componentes: .asciiz "Introduza as componentes \n"
saida_L: .asciiz "Matriz L= \n"
saida_U: .asciiz "Matriz U= \n"
tab: .asciiz "\t"
enter: .asciiz "\n"
num_1: .asciiz "1.0"
num_0: .asciiz "0.0"
.text

##########   INTRO   ##########
li $v0, 4 # v0 = 4 -> print string
la $a0, intro1
syscall
la $a0, intro2
syscall


##########   PEDE COMPONENTES   ##########
li $v0, 4 # v0 = 4 -> print string
la $a0, componentes
syscall


li $v0, 7 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.d $f2,$f0 # n11 = f1 

#li $v0, 7 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.d $f4,$f0 # n12 = f2

#li $v0, 7 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.d $f6,$f0 # n13 = f3

#li $v0, 7 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.d $f8,$f0 # n21 = f4    

#li $v0, 7 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.d $f10,$f0 # n22 = f5  

#li $v0, 7 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.d $f12,$f0 # n23 = f6  

#li $v0, 7 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.d $f14,$f0 # n31 = f7  

#li $v0, 7 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.d $f16,$f0 # n32 = f8  

#li $v0, 7 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.d $f18,$f0 # n33 = f9  

# reg $f20 sera o meu temporario
# $f30 usado para comparar com 0
mtc1 $zero,$f30 #f30 = 0

##########   TESTA EXCECOES 5 (as linhas 1 e 3 sao iguais)   ##########

#	f2	f4	f6
#	f8	f10	f12
#	f14	f16	f18
c.eq.d $f2,$f14
bc1f NOT_EXFL5
c.eq.d $f8,$f14
bc1t NOT_EXFL5
c.eq.d $f4,$f16
bc1f NOT_EXFL5
c.eq.d $f10,$f16
bc1t NOT_EXFL5
c.eq.d $f6,$f18
bc1f NOT_EXFL5
c.eq.d $f12,$f18
bc1t NOT_EXFL5

j case5  #se chegou ate aqui, as linhas 1 e 3 sao iguais
##########   FIM TESTA EXCECOES 5   ##########

NOT_EXFL5:

##########   TESTA EXCECOES 4 (as 3 linhas sao iguais)   ##########

#	f2	f4	f6
#	f8	f10	f12
#	f14	f16	f18
c.eq.d $f2,$f8
bc1f NOT_EXFL4
c.eq.d $f8,$f14
bc1f NOT_EXFL4
c.eq.d $f4,$f10
bc1f NOT_EXFL4
c.eq.d $f10,$f16
bc1f NOT_EXFL4
c.eq.d $f6,$f12
bc1f NOT_EXFL4
c.eq.d $f12,$f18
bc1f NOT_EXFL4

j case4  #se chegou ate aqui, as linhas sao iguais
##########   FIM TESTA EXCECOES 4   ##########



NOT_EXFL4:

##########   TESTA EXCECOES E ATIVA FLAGS   ##########
##########   SITUACOES EXCECOES, n11 = O; n11 * n22 = n12 * n21  ##########

# n11 = O ?
c.eq.d $f2,$f30 #resultado em $fcc0, condition flag 0
bc1f FLAG_0__0

li $s0,1  #$s0 e a flag0 = 1
j CONT_FLAG_0

FLAG_0__0: li $s0,0

CONT_FLAG_0:

# n11 * n22 = n12 * n21 ?
mul.d $f26,$f2,$f10
mul.d $f28,$f4,$f8
c.eq.d $f26,$f28 #resultado em $fcc1, condition flag 0
bc1f FLAG_1__0

li $s1,1  #$s1 e a flag1 = 1
j CONT_FLAG_1

FLAG_1__0: li $s1, 0

CONT_FLAG_1:


add $t1,$s0,$s1 #se flag0 e flag1 somarem e derem 2, significa que ambas sao 1
bne $t1,2,FLAG_2__0 #FLAG2 verifica se ambos os FLAG1 E FLAG0 sao 1 ao mesmo tempo

li $s2,1
j CONT_FLAG_2__1

FLAG_2__0: li $s2,0
j CONT_FLAG_2__0

CONT_FLAG_2__1:
# n11 = n12 = 0 -> FLAG_2 = 1
c.eq.d $f2,$f4
bc1f CONT_FLAG_3__0

li $s3,1 #flag 3 define o caso 3, se flag3 = 0 -> 3.1, se flag3 = 1 -> 3.2
j CONT_FLAG_3__1


CONT_FLAG_2__0:

CONT_FLAG_3__0: li $s3, 0

CONT_FLAG_3__1:

AVALIA_FLAG_3: bne $s3, 1, AVALIA_FLAG_2 #se nao for o caso 3.2 (FLAG 3 = 1) testa se FL2=1,
# pois se FL2= 1 o caso sera 3.1, se nao, FL0 != FL1 e (p/ FL3= 1 -> FL0=1 E FL1= 1 obrigatoriamente)
j case3_2

AVALIA_FLAG_2: bne $s2, 1, AVALIA_FLAG_1 #se nao for o caso 3.1 (FLAG 3 = 0 e FLAG2 = 1) testa proximo (p/ FL3= 0 -> FL0=1 E FL1= 1 obrigatoriamente
j case3_1

# se nao for nenhum dos acima, entao FLAG2=0, logo FLAG_0 e FLAG_1 nao sao 1 ao mesmo tempo
AVALIA_FLAG_1: bne $s1, 1, AVALIA_FLAG_0 #se nao for o caso 2 (FLAG_1 = 1), testa-se se FLAG_0
j case2

AVALIA_FLAG_0: bne $s0, 1, case_padrao #se nao for o caso 1 (FLAG_0 = 1), entao nao entra na questao da execao e utiliza-se o caso padrao
j case1

case_padrao:##########   CASE PADRAO / CASE 0  ##########

##########   CALCULA L e U   ##########


passo1: ##########   PRIMEIRA PARTE   ##########
# a21 = n21/n11         ->	f20 = f8 / f2
div.d $f20,$f8,$f2
# b22 = n22 - a21 * n12 ->	f24 = f10 - f20 * f4
mul.d $f22,$f20,$f4
sub.d $f24,$f10,$f22
# b23 = n23 - a21 * n13 ->	f26 = f12 - f20 * f6
mul.d $f22,$f20,$f6
sub.d $f26,$f12,$f22

passo2:##########   SEGUNDA PARTE   ##########
# a31 = n31/n11		->	f28 =  f14 / f2
div.d $f28,$f14,$f2
# c32 = n32 - a31 * n12 ->	f30 = f16 - f28 * f4
mul.d $f22,$f28,$f4
sub.d $f30,$f16,$f22
# c33 = n33 - a31 * n13 ->	f8 = f18 - f28 * f6
mul.d $f22,$f28,$f6
sub.d $f8,$f18,$f22

passo3:##########   TERCEIRA PARTE   ##########
#sera usado o f21 para a32 pq f12 sera utilizado para o print float do syscall
# a32 = c32/b22         ->	f10 = f30 / f24
div.d $f10,$f30,$f24
# b33 = c33 - a32*b23   ->	f14 = f8 - f10 * f26 
mul.d $f22,$f10,$f26
sub.d $f14,$f8,$f22


##########   SAIDA L   ##########
li $v0,4 #print string
la $a0, saida_L
syscall #print saida_L

la $a0, num_1
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, enter
syscall

#print f20 = a12
li $v0,3 #print float
mov.d $f12, $f20
syscall

li $v0,4 #print string
la $a0, tab
syscall

la $a0, num_1
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, enter
syscall

#print f28 = a13
li $v0,3 #print float
mov.d $f12, $f28
syscall

li $v0,4 #print string
la $a0, tab
syscall

#print f21 = a23
li $v0,3 #print float
mov.d $f12, $f10
syscall
li $v0,4 #print string
la $a0, tab
syscall

la $a0, num_1
syscall
la $a0, enter
syscall



##########   SAIDA U   ##########

li $v0,4 #print string
la $a0, enter
syscall
la $a0, saida_U
syscall

#print f2 = n11 = b11
li $v0,3 #print float
mov.d $f12, $f2
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f4 = n12 = b12
li $v0,3 #print float
mov.d $f12, $f4
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f6 = n13 = b13
li $v0,3 #print float
mov.d $f12, $f6
syscall
li $v0,4 #print string
la $a0, enter
syscall

#print 0
la $a0, num_0
syscall
la $a0, tab
syscall

#print f24 = b22
li $v0,3 #print float
mov.d $f12, $f24
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f26 = b23
li $v0,3 #print float
mov.d $f12, $f26
syscall
li $v0,4 #print string
la $a0, enter
syscall

#print 0
la $a0, num_0
syscall
la $a0, tab
syscall

#print 0
la $a0, num_0
syscall
la $a0, tab
syscall

#print f17 = b33
li $v0,3 #print float
mov.d $f12, $f14
syscall
li $v0,4 #print string
la $a0, enter
syscall

j exit
########  FIM CASE PADRAO ###########

case3_2:########  INICIO CASE 3.2 ###########

##########   CALCULA L e U   ##########

##########   PRIMEIRA PARTE   ##########

##########   swapping row2 with row1   ##########
#primeira row f8 f10 f12
#             f2 f4 f6
#             f14 f16 f18

##########   SEGUNDA PARTE   ##########
##########   mantem o procedimento normal   ##########

# 	a31 = f22 =  f14 / f8
div.d $f22,$f14,$f8
# 	b32 = f24 = f16 - f22 * f10
mul.d $f20,$f22,$f10
sub.d $f24,$f16,$f20
# 	b33 = f26 = f18 - f22 * f12
mul.d $f20,$f22,$f12
sub.d $f26,$f18,$f20

mov.d $f30,$f12 #passa o valor de f12 para f30 pois f12 sera usado para o print

##########   TERCEIRA PARTE   ##########
##########   swapping row3 with row2  ##########
#	f8 f10 f30
#	0 f24 f26
#	f2 f4 f6


##########   SAIDA L   ##########
li $v0,4 #print string
la $a0, saida_L
syscall #print saida_L

la $a0, num_0
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, tab
syscall

la $a0, num_1
syscall
la $a0, enter
syscall

la $a0, num_1
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, enter
syscall

li $v0,3 #print float
mov.d $f12, $f22
syscall
li $v0,4 #print string
la $a0, tab
syscall

la $a0, num_1
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, enter
syscall



##########   SAIDA U   ##########

li $v0,4 #print string
la $a0, enter
syscall
la $a0, saida_U
syscall


li $v0,3 #print float
mov.d $f12, $f8
syscall
li $v0,4 #print string
la $a0, tab
syscall


li $v0,3 #print float
mov.d $f12, $f10
syscall
li $v0,4 #print string
la $a0, tab
syscall


li $v0,3 #print float
mov.d $f12, $f30
syscall
li $v0,4 #print string
la $a0, enter
syscall

#print 0
la $a0, num_0
syscall
la $a0, tab
syscall


li $v0,3 #print float
mov.d $f12, $f24
syscall
li $v0,4 #print string
la $a0, tab
syscall


li $v0,3 #print float
mov.d $f12, $f26
syscall
li $v0,4 #print string
la $a0, enter
syscall

#print 0
la $a0, num_0 # == f1
syscall
la $a0, tab
syscall

#print 0
la $a0, num_0 # == f2
syscall
la $a0, tab
syscall

li $v0,3 #print float
mov.d $f12, $f6
syscall
li $v0,4 #print string
la $a0, enter
syscall

j exit
########  FIM CASE 3.2 ###########


case3_1:########  INICIO CASE 3.1 ###########
##########   CALCULA L e U   ##########


##########   PRIMEIRA PARTE   ##########
#swap row 3 w/ row 1
#	f14 f16 f18
#	f8 f10 f12
#	f2 f4 f6

##########   SEGUNDA PARTE   ##########
# 	a21= f22 = f4/f10 
div.d $f22,$f4,$f10

# b33 =	f24 = f6 - f22 * f12
mul.d $f20,$f22,$f12
sub.d $f24,$f6,$f20

mov.d $f30,$f12
##########   TERCEIRA PARTE   ##########
# ja finalizado


##########   SAIDA L   ##########
#	0 f22 1
#	0  1  0
#	1  0  0

li $v0,4 #print string
la $a0, saida_L
syscall #print saida_L

la $a0, num_0
syscall
la $a0, tab
syscall

#print f10 = a21
li $v0,3 #print float
mov.d $f12, $f22
syscall
li $v0,4 #print string
la $a0, tab
syscall

la $a0, num_1
syscall
la $a0, enter
syscall

la $a0, num_0
syscall
la $a0, tab
syscall

la $a0, num_1
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, enter
syscall

la $a0, num_1
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, enter
syscall



##########   SAIDA U   ##########
#	f14	f16	f18
#	f8	f10	f30
#	0	0	f24

li $v0,4 #print string
la $a0, enter
syscall
la $a0, saida_U
syscall

#print f7
li $v0,3 #print float
mov.d $f12, $f14
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f8
li $v0,3 #print float
mov.d $f12, $f16
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f9
li $v0,3 #print float
mov.d $f12, $f18
syscall
li $v0,4 #print string
la $a0, enter
syscall

#print f4
li $v0,3 #print float
mov.d $f12, $f8
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f5
li $v0,3 #print float
mov.d $f12, $f10
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f6
li $v0,3 #print float
mov.d $f12, $f30
syscall
li $v0,4 #print string
la $a0, enter
syscall

#print 0
la $a0, num_0
syscall
la $a0, tab
syscall

#print 0
la $a0, num_0
syscall
la $a0, tab
syscall

#print f14
li $v0,3 #print float
mov.d $f12, $f24
syscall
li $v0,4 #print string
la $a0, enter
syscall

j exit
########  FIM CASE 3.1 ###########

case2:########  INICIO CASE 2 ###########
##########   CALCULA L e U   ##########


##########   PRIMEIRA PARTE   ##########
# a21 = n21/n11         ->	f22 = f8 / f2
div.d $f22,$f8,$f2
# b22 = 0
# b23 = n23 - a21 * n13 ->	f24 = f12 - f22 * f6
mul.d $f20,$f22,$f6
sub.d $f24,$f12,$f20

##########   SEGUNDA PARTE   ##########
# a31 = n31/n11		->	f26 =  f14 / f2
div.d $f26,$f14,$f2
# b31 = 0
# b32 = n32 - a31 * n12 ->	f28 = f16 - f26 * f4
mul.d $f20,$f26,$f4
sub.d $f28,$f16,$f20
# b33 = n33 - a31 * n13 ->	f30 = f18 - f26 * f6
mul.d $f20,$f26,$f6
sub.d $f30,$f18,$f20

##########   TERCEIRA PARTE   ##########
#swap row 3 with row 2
#	f2	f4	f6
#	0	f28	f30	
#	0	0	f24

##########   SAIDA L   ##########
#	1	0	0
#	f10	0	1	
#	f11	1	0
li $v0,4 #print string
la $a0, saida_L
syscall #print saida_L

la $a0, num_1
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, enter
syscall

#print f10 = a21
li $v0,3 #print float
mov.d $f12, $f22
syscall
li $v0,4 #print string
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, tab
syscall

la $a0, num_1
syscall
la $a0, enter
syscall

#print f11 = a31
li $v0,3 #print float
mov.d $f12, $f26
syscall
li $v0,4 #print string
la $a0, tab
syscall

la $a0, num_1
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, enter
syscall



##########   SAIDA U   ##########
#	f2	f4	f6
#	0	f28	f30	
#	0	0	f24

li $v0,4 #print string
la $a0, enter
syscall
la $a0, saida_U
syscall

#print f1 
li $v0,3 #print float
mov.d $f12, $f2
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f2 
li $v0,3 #print float
mov.d $f12, $f4
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f3
li $v0,3 #print float
mov.d $f12, $f6
syscall
li $v0,4 #print string
la $a0, enter
syscall

#print 0
la $a0, num_0
syscall
la $a0, tab
syscall

#print f15
li $v0,3 #print float
mov.d $f12, $f28
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f16
li $v0,3 #print float
mov.d $f12, $f30
syscall
li $v0,4 #print string
la $a0, enter
syscall

#print 0
la $a0, num_0
syscall
la $a0, tab
syscall

#print 0
la $a0, num_0
syscall
la $a0, tab
syscall

#print f14
li $v0,3 #print float
mov.d $f12, $f24
syscall
li $v0,4 #print string
la $a0, enter
syscall

j exit
########  FIM CASE 2 ###########

case1:########  INICIO CASE 1 ###########

##########   CALCULA L e U   ##########

##########   PRIMEIRA PARTE   ##########
#swap row 2 with row 1
#	f8	f10	f12
#	f2	f4	f6
#	f14	f16	f18

##########   SEGUNDA PARTE   ##########
# a31 = f22 =  f14 / f8
div.d $f22,$f14,$f8
#b31 = 0
# c32 =	f24 = f16 - f22 * f10
mul.d $f20,$f22,$f10
sub.d $f24,$f16,$f20
# c33 = f26 = f18 - f22 * f12
mul.d $f20,$f22,$f12
sub.d $f26,$f18,$f20

##########   TERCEIRA PARTE   ##########
#sera usado o f21 para a32 pq f12 sera utilizado para o print float do syscall
# a32 = f28 = f24 / f4
div.d $f28,$f24,$f4
#b32 = 0
# b33 = f17 = f16 - f28 * f6 
mul.d $f20,$f28,$f6
sub.d $f26,$f26,$f20

mov.d $f30,$f12
##########   SAIDA L   ##########
#	0	1	0
#	1	0	0
#	f22	f28	1

li $v0,4 #print string
la $a0, saida_L
syscall #print saida_L

la $a0, num_0
syscall
la $a0, tab
syscall

la $a0, num_1
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, enter
syscall

la $a0, num_1
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, enter
syscall

#print f22 = a31
li $v0,3 #print float
mov.d $f12, $f22
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f28 = a32
li $v0,3 #print float
mov.d $f12, $f28
syscall
li $v0,4 #print string
la $a0, tab
syscall

la $a0, num_1
syscall
la $a0, enter
syscall



##########   SAIDA U   ##########
#	f8	f10	f30
#	f2	f4	f6
#	0	0	f26

li $v0,4 #print string
la $a0, enter
syscall
la $a0, saida_U
syscall

#print f8
li $v0,3 #print float
mov.d $f12, $f8
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f10
li $v0,3 #print float
mov.d $f12, $f10
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f30
li $v0,3 #print float
mov.d $f12, $f30
syscall
li $v0,4 #print string
la $a0, enter
syscall

#print f2
li $v0,3 #print float
mov.d $f12, $f2
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f4
li $v0,3 #print float
mov.d $f12, $f4
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f6
li $v0,3 #print float
mov.d $f12, $f6
syscall
li $v0,4 #print string
la $a0, enter
syscall

#print 0
la $a0, num_0
syscall
la $a0, tab
syscall

#print 0
la $a0, num_0
syscall
la $a0, tab
syscall

#print f26 = b33
li $v0,3 #print float
mov.d $f12, $f26
syscall
li $v0,4 #print string
la $a0, enter
syscall

j exit
########  FIM CASE 1 ###########

case4:########  INICIO CASE 4 ###########

##########   SAIDA L   ##########
li $v0,4 #print string
la $a0, saida_L
syscall #print saida_L


la $a0, num_1
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, enter
syscall

la $a0, num_1
syscall
la $a0, tab
syscall

la $a0, num_1
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, enter
syscall

la $a0, num_1
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, tab
syscall

la $a0, num_1
syscall
la $a0, enter
syscall


##########   SAIDA U   ##########

li $v0,4 #print string
la $a0, enter
syscall
la $a0, saida_U
syscall

#print f1
li $v0,3 #print float
mov.d $f12, $f2
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f2
li $v0,3 #print float
mov.d $f12, $f4
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f3
li $v0,3 #print float
mov.d $f12, $f6
syscall
li $v0,4 #print string
la $a0, enter
syscall

#print 0
la $a0, num_0
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, enter
syscall

la $a0, num_0
syscall
la $a0, tab
syscall

#print 0
la $a0, num_0
syscall
la $a0, tab
syscall

#print 0
la $a0, num_0
syscall
la $a0, enter
syscall

j exit

########  FIM CASE 4 ###########

case5:##########   CASE 5  ##########

##########   CALCULA L e U   ##########


##########   PRIMEIRA PARTE   ##########
# a21 = n21/n11         ->	f22 = f8 / f2
div.d $f22,$f8,$f2
# b22 = n22 - a21 * n12 ->	f24 = f10 - f20 * f4
mul.d $f20,$f22,$f4
sub.d $f24,$f10,$f20
# b23 = n23 - a21 * n13 ->	f26 = f12 - f20 * f6
mul.d $f20,$f22,$f6
sub.d $f26,$f12,$f20

##########   SEGUNDA PARTE   ##########


##########   TERCEIRA PARTE   ##########



##########   SAIDA L   ##########
#	1	0	0
#	f22	1	0
#	1	0	1

li $v0,4 #print string
la $a0, saida_L
syscall #print saida_L

la $a0, num_1
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, enter
syscall

#print f20 = a12
li $v0,3 #print float
mov.d $f12, $f22
syscall

li $v0,4 #print string
la $a0, tab
syscall

la $a0, num_1
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, enter
syscall

la $a0, num_1
syscall
la $a0, tab
syscall


la $a0, num_0
syscall
la $a0, tab
syscall

la $a0, num_1
syscall
la $a0, enter
syscall



##########   SAIDA U   ##########
#	f2	f4	f6
#	0	f24	f26
#	0	0	0
li $v0,4 #print string
la $a0, enter
syscall
la $a0, saida_U
syscall

#print f2 = n11 = b11
li $v0,3 #print float
mov.d $f12, $f2
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f4 = n12 = b12
li $v0,3 #print float
mov.d $f12, $f4
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f6 = n13 = b13
li $v0,3 #print float
mov.d $f12, $f6
syscall
li $v0,4 #print string
la $a0, enter
syscall

#print 0
la $a0, num_0
syscall
la $a0, tab
syscall

#print f24 = b22
li $v0,3 #print float
mov.d $f12, $f24
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f26 = b23
li $v0,3 #print float
mov.d $f12, $f26
syscall
li $v0,4 #print string
la $a0, enter
syscall

#print 0
la $a0, num_0
syscall
la $a0, tab
syscall

#print 0
la $a0, num_0
syscall
la $a0, tab
syscall

la $a0, num_0
syscall
la $a0, enter
syscall

j exit
########  FIM CASE 5 ###########


exit: ########  EXIT  ###########
li $v0,10
syscall #exit
