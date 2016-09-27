.data
intro1: .asciiz "O programa dever receber uma matriz quadrada de ordem 3\n"
intro2: .asciiz "Insira os elementos na ordem n11[ENTER],n12[ENTER] e assim por diante \n"
componentes: .asciiz "Introduza as componentes \n"
saida_L: .asciiz "Matriz L= \n"
saida_U: .asciiz "Matriz U= \n"
tab: .asciiz "\t"
enter: .asciiz "\n"
num_1: .asciiz "1"
num_0: .asciiz "0"
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


li $v0, 6 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.s $f1,$f0 # n11 = f1 

#li $v0, 6 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.s $f2,$f0 # n12 = f2

#li $v0, 6 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.s $f3,$f0 # n13 = f3

#li $v0, 6 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.s $f4,$f0 # n21 = f4    

#li $v0, 6 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.s $f5,$f0 # n22 = f5  

#li $v0, 6 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.s $f6,$f0 # n23 = f6  

#li $v0, 6 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.s $f7,$f0 # n31 = f7  

#li $v0, 6 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.s $f8,$f0 # n32 = f8  

#li $v0, 6 # v0 = 6 -> read float
syscall #sycall com v0=6: read float
mov.s $f9,$f0 # n33 = f9  

# reg $f20 sera o meu temporario
# $f30 usado para comparar com 0
mtc1 $zero,$f30 #f30 = 0

##########   TESTA EXCECOES E ATIVA FLAGS   ##########
##########   SITUACOES EXCECOES, n11 = O; n11 * n22 = n12 * n21  ##########

# n11 = O ?
c.eq.s $f1,$f30 #resultado em $fcc0, condition flag 0
bc1f FLAG_0__0

li $s0,1  #$s0 e a flag0 = 1
j CONT_FLAG_0

FLAG_0__0: li $s0,0

CONT_FLAG_0:

# n11 * n22 = n12 * n21 ?
mul.s $f28,$f1,$f5
mul.s $f29,$f2,$f4
c.eq.s $f28,$f29 #resultado em $fcc1, condition flag 0
bc1f FLAG_1__0

li $s1,1  #$s1 e a flag1 = 1
j CONT_FLAG_1

FLAG_1__0: li $s1, 0

CONT_FLAG_1:


add $t1,$s0,$s1 #se flag0 e flag1 somarem e derem 2, significa que ambas sao 1
bne $t1,2,FLAG_2__0

li $s2,1
j CONT_FLAG_2__1

FLAG_2__0: li $s2,0
j CONT_FLAG_2__0

CONT_FLAG_2__1:
# n11 = n12 = 0 -> FLAG_2 = 1
c.eq.s $f1,$f2
bc1f CONT_FLAG_3__0

li $s3,1
j CONT_FLAG_3__1


CONT_FLAG_2__0:

CONT_FLAG_3__0: li $s3, 0

CONT_FLAG_3__1:

##########   CALCULA L e U   ##########

case0:
passo1: ##########   PRIMEIRA PARTE   ##########
# a21 = n21/n11         ->	f10 = f4 / f1
div.s $f10,$f4,$f1
# b22 = n22 - a21 * n12 ->	f13 = f5 - f10 * f2
mul.s $f20,$f10,$f2
sub.s $f13,$f5,$f20
# b23 = n23 - a21 * n13 ->	f14 = f6 - f10 * f3
mul.s $f20,$f10,$f3
sub.s $f14,$f6,$f20

passo2:##########   SEGUNDA PARTE   ##########
# a31 = n31/n11		->	f11 =  f7 / f1
div.s $f11,$f7,$f1
# c32 = n32 - a31 * n12 ->	f15 = f8 - f11 * f2
mul.s $f20,$f11,$f2
sub.s $f15,$f8,$f20
# c33 = n33 - a31 * n13 ->	f16 = f9 - f11 * f3
mul.s $f20,$f11,$f3
sub.s $f16,$f9,$f20

passo3:##########   TERCEIRA PARTE   ##########
#sera usado o f21 para a32 pq f12 sera utilizado para o print float do syscall
# a32 = c32/b22         ->	f21 = f15 / f13
div.s $f21,$f15,$f13
# b33 = c33 - a32*b23   ->	f17 = f16 - f21 * f14 
mul.s $f20,$f21,$f14
sub.s $f17,$f16,$f20

case1:
case2:
case3.1:
case3.2:


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

#print f10 = a12
li $v0,2 #print float
mov.s $f12, $f10
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

#print f11 = a13
li $v0,2 #print float
mov.s $f12, $f11
syscall

li $v0,4 #print string
la $a0, tab
syscall

#print f21 = a23
li $v0,2 #print float
mov.s $f12, $f21
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

#print f1 = n11 = b11
li $v0,2 #print float
mov.s $f12, $f1
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f2 = n12 = b12
li $v0,2 #print float
mov.s $f12, $f2
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f3 = n13 = b13
li $v0,2 #print float
mov.s $f12, $f3
syscall
li $v0,4 #print string
la $a0, enter
syscall

#print 0
la $a0, num_0
syscall
la $a0, tab
syscall

#print f13 = b22
li $v0,2 #print float
mov.s $f12, $f13
syscall
li $v0,4 #print string
la $a0, tab
syscall

#print f14 = b23
li $v0,2 #print float
mov.s $f12, $f14
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
li $v0,2 #print float
mov.s $f12, $f17
syscall
li $v0,4 #print string
la $a0, enter
syscall


########  EXIT  ###########
li $v0,10
syscall #exit
