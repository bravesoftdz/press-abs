(*
  AbstractClasses, Custom Classes and Routines
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit CustomClasses;

{$I abs.inc}

interface

uses
  SysUtils;

type
  ECustomException = class(Exception)
  end;

{ unit uExtenso; }
{ Autor.....: Eug�nio Reis }

function Extenso( Numero : extended ) : string;

implementation

{ unit uExtenso; }

{ Autor.....: Eug�nio Reis
  Proposito.: Rotina desenvolvida para dar apoio a treinamentos de Delphi.
              Recebe um valor num�rico e devolve uma string com seu valor por
              extenso, em reais. O limite se encerra na casa dos trilh�es.
              � uma rotina escrita com uma inten��o muito "Pascalista" de
              explorar bem os recursos da linguagem (n�o das bibliotecas, mas
              da linguagem em si).
  Data......: 12/09/95, revisada em 27/09/02.
  Obs.......: Existem detalhes sutis da l�ngua portuguesa que aumentam muito
              o trabalho de implementa��o deste tipo de rotina. Em caso de
              sugest�es para o melhoramento da rotina ou bugs encontrados,
              favor escrever para o endere�o ebrire@yahoo.com.
              Pe�o a gentileza de sempre distribuir o c�digo exatamente como no
              original, com todos os coment�rios (inclusive este, obviamente).
}

{
  Como esta rotina visa a ser compat�vel tamb�m com Delphi 1 e Turbo Pascal,
  optei por manipular strings usando apenas o b�sico do b�sico (sem recorrer �
  SysUtils) e por usar tipos n�mericos simples. Lembre-se que o tipo extended
  pode apresentar ligeiras imprecis�es em n�meros na casa das centenas de
  trilh�o.
  A fun��o ReplaceSubstring poderia ser facilmente substitu�da com recursos do
  Delphi, mas, como j� disse, optei por usar uma implementa��o mais pascalista
  mesmo, e portanto menos sujeita a problemas de vers�o do Pascal (Turbo Pascal,
  Think Pascal, Borland Pascal, Delphi 1-7, Kylix, etc).
}
function ReplaceSubstring( StringAntiga, StringNova, s : string ) : string;
  var p : word;
begin
   repeat
     p := Pos( StringAntiga, s );
     if p > 0 then begin
        Delete( s, p, Length( StringAntiga ) );
        Insert( StringNova, s, p );
     end;
   until p = 0;
   ReplaceSubstring := s;
end;


{ Esta � a fun��o que gera os blocos de extenso que depois ser�o montados }
function Extenso3em3( Numero : Word ) : string;
  const Valores : array[1..36] of word = ( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
                       13, 14, 15, 16, 17, 18, 19, 20, 30, 40, 50, 60, 70, 80, 90,
                       100, 200, 300, 400, 500, 600, 700, 800, 900 );
        Nomes : array[0..36] of string[12] = ( '', 'UM', 'DOIS', 'TR�S', 'QUATRO',
                       'CINCO', 'SEIS', 'SETE', 'OITO', 'NOVE', 'DEZ', 'ONZE',
                       'DOZE', 'TREZE', 'QUATORZE', 'QUINZE', 'DEZESSEIS',
                       'DEZESSETE', 'DEZOITO', 'DEZENOVE', 'VINTE', 'TRINTA',
                       'QUARENTA', 'CINQ�ENTA', 'SESSENTA', 'SETENTA', 'OITENTA',
                       'NOVENTA', 'CENTO', 'DUZENTOS', 'TREZENTOS', 'QUATROCENTOS',
                       'QUINHENTOS', 'SEISCENTOS', 'SETECENTOS', 'OITOCENTOS',
                       'NOVECENTOS' );
  var i         : byte;
      Resposta  : string;
      Inteiro   : word;
      Resto     : word;
begin
  Inteiro   := Numero;
  Resposta  := '';

  for i := 36 downto 1 do begin
      Resto := ( Inteiro div valores[i] ) * valores[i];
      if ( Resto = valores[i] ) and ( Inteiro >= Resto ) then begin
         Resposta := Resposta + Nomes[i] + ' E ';
         Inteiro  := Inteiro - Valores[i];
      end;
  end;

  { Corta o 'E' excedente do final da string }
  Extenso3em3 := Copy( Resposta, 1, Length( Resposta ) - 3 );
end;


{
  A fun��o extenso divide os n�meros em grupos de tr�s e chama a fun��o
  extenso3em3 para o obter extenso de cada parte e armazen�-los no vetor
  Resposta.
}
function Extenso( Numero : extended ) : string;
  const NoSingular : array[1..6] of string = ( 'TRILH�O', 'BILH�O', 'MILH�O', 'MIL',
                                               'REAL', 'CENTAVO' );
        NoPlural   : array[1..6] of string = ( 'TRILH�ES', 'BILH�ES', 'MILH�ES', 'MIL',
                                               'REAIS', 'CENTAVOS' );
        {
          Estas constantes facilitam o entendimento do c�digo.
          Como os valores de singular e plural s�o armazenados em um vetor,
          cada posicao indica a grandeza do n�mero armazenado (leia-se sempre
          da esquerda para a direita).
        }
        CasaDosTrilhoes = 1;
        CasaDosBilhoes  = CasaDosTrilhoes + 1;
        CasaDosMilhoes  = CasaDosBilhoes  + 1;
        CasaDosMilhares = CasaDosMilhoes  + 1;
        CasaDasCentenas = CasaDosMilhares + 1;
        CasaDosCentavos = CasaDasCentenas + 1;

  var TrioAtual,
      TrioPosterior : byte;
      v             : integer; { usada apenas com o Val }
      Resposta      : array[CasaDosTrilhoes..CasaDosCentavos] of string;
      RespostaN     : array[CasaDosTrilhoes..CasaDosCentavos] of word;
      Plural        : array[CasaDosTrilhoes..CasaDosCentavos] of boolean;
      Inteiro       : extended;
      NumStr        : string;
      TriosUsados   : set of CasaDosTrilhoes..CasaDosCentavos;
      NumTriosInt   : byte;

  { Para os n�o pascalistas de tradi��o, observe o uso de uma fun��o
    encapsulada na outra. }
  function ProximoTrio( i : byte ) : byte;
  begin
     repeat
       Inc( i );
     until ( i in TriosUsados ) or ( i >= CasaDosCentavos );
     ProximoTrio := i;
  end;

begin
  Inteiro  := Round( Numero * 100 );

  { Inicializa os vetores }
  for TrioAtual := CasaDosTrilhoes to CasaDosCentavos do begin
       Resposta[TrioAtual] := '';
       Plural[TrioAtual]   := False;
  end;

  {
    O n�mero � quebrado em partes distintas, agrupadas de tr�s em tr�s casas:
    centenas, milhares, milh�es, bilh�es e trilh�es. A �ltima parte (a sexta)
    cont�m apenas os centavos, com duas casas
  }
  Str( Inteiro : 17 : 0, NumStr );
  TrioAtual    := 1;
  Inteiro      := Int( Inteiro / 100 ); { remove os centavos }

  { Preenche os espa�os vazios com zeros para evitar erros de convers�o }
  while NumStr[TrioAtual] = ' ' do begin
     NumStr[TrioAtual] := '0';
     Inc( TrioAtual );
  end;

  { Inicializa o conjunto como vazio }
  TriosUsados := [];
  NumTriosInt := 0; { N�meros de trios da parte inteira (sem os centavos) } 

  { Este loop gera os extensos de cada parte do n�mero }
  for TrioAtual := CasaDosTrilhoes to CasaDosCentavos do begin
      Val( Copy( NumStr, 3 * TrioAtual - 2, 3 ), RespostaN[TrioAtual], v );
      if RespostaN[TrioAtual] <> 0 then begin
         Resposta[TrioAtual] := Resposta[TrioAtual] +
                                Extenso3em3( RespostaN[TrioAtual] );
         TriosUsados := TriosUsados + [ TrioAtual ];
         Inc( NumTriosInt );
         if RespostaN[TrioAtual] > 1 then begin
            Plural[TrioAtual] := True;
         end;
      end;
  end;

  if CasaDosCentavos in TriosUsados then
     Dec( NumTriosInt );

  { Gerar a resposta propriamente dita }
  NumStr := '';

  {
    Este trecho obriga que o nome da moeda seja sempre impresso no caso de
    haver uma parte inteira, qualquer que seja o valor.
  }
  if (Resposta[CasaDasCentenas]='') and ( Inteiro > 0 ) then begin
      Resposta[CasaDasCentenas] := ' ';
      Plural[CasaDasCentenas]   := True;
      TriosUsados := TriosUsados + [ CasaDasCentenas ];
  end;


  { Basta ser maior que um para que a palavra "real" seja escrita no plural }
  if Inteiro > 1 then
     Plural[CasaDasCentenas] := True;

  { Localiza o primeiro elemento }
  TrioAtual     := 0;
  TrioPosterior := ProximoTrio( TrioAtual );

  { Localiza o segundo elemento }
  TrioAtual     := TrioPosterior;
  TrioPosterior := ProximoTrio( TrioAtual );

  { Este loop vai percorrer apenas os trios preenchidos e saltar os vazios. }
  while TrioAtual <= CasaDosCentavos do begin
     { se for apenas cem, n�o escrever 'cento' }
     if Resposta[TrioAtual] = 'CENTO' then
        Resposta[TrioAtual] := 'CEM';

     { Verifica se a resposta deve ser no plural ou no singular }
     if Resposta[TrioAtual] <> '' then begin
        NumStr := NumStr + Resposta[TrioAtual] + ' ';
        if plural[TrioAtual] then
           NumStr := NumStr + NoPlural[TrioAtual] + ' '
        else
           NumStr := NumStr + NoSingular[TrioAtual] + ' ';

        { Verifica a necessidade da particula 'e' para os n�meros }
        if ( TrioAtual < CasaDosCentavos ) and ( Resposta[TrioPosterior] <> '' )
           and ( Resposta[TrioPosterior] <> ' ' ) then begin
           {
             Este trecho analisa diversos fatores e decide entre usar uma
             v�rgula ou um "E", em fun��o de uma peculiaridade da l�ngua. Veja
             os exemplos para compreender:
             - DOIS MIL, QUINHENTOS E CINQ�ENTA REAIS
             - DOIS MIL E QUINHENTOS REAIS
             - DOIS MIL E UM REAIS
             - TR�S MIL E NOVENTA E CINCO REAIS
             - QUATRO MIL, CENTO E UM REAIS
             - UM MILH�O E DUZENTOS MIL REAIS
             - UM MILH�O, DUZENTOS MIL E UM REAIS
             - UM MILH�O, OITOCENTOS E NOVENTA REAIS
             Obs.: Fiz o m�ximo esfor�o pra que o extenso soasse o mais natural
                   poss�vel em rela��o � lingua falada, mas se aparecer alguma
                   situa��o em que algo soe esquisito, pe�o a gentileza de me
                   avisar.
           }
           if ( TrioAtual < CasaDosCentavos ) and
              ( ( NumTriosInt = 2 ) or ( TrioAtual = CasaDosMilhares ) ) and
              ( ( RespostaN[TrioPosterior] <= 100 ) or
                ( RespostaN[TrioPosterior] mod 100 = 0 ) ) then
              NumStr := NumStr + 'E '
           else
              NumStr := NumStr + ', ';
        end;
     end;

     { se for apenas trilh�es, bilh�es ou milh�es, acrescenta o 'de' }
     if ( NumTriosInt = 1 ) and ( Inteiro > 0 ) and ( TrioAtual <= CasaDosMilhoes ) then begin
        NumStr := NumStr + ' DE ';
     end;

     { se tiver centavos, acrescenta a part�cula 'e', mas somente se houver
       qualquer valor na parte inteira }
     if ( TrioAtual = CasaDasCentenas ) and ( Resposta[CasaDosCentavos] <> '' )
        and ( inteiro > 0 ) then begin
        NumStr := Copy( NumStr, 1, Length( NumStr ) - 2 ) + ' E ';
     end;

     TrioAtual     := ProximoTrio( TrioAtual );
     TrioPosterior := ProximoTrio( TrioAtual );
  end;

  { Eliminar algumas situa��es em que o extenso gera excessos de espa�os
    da resposta. Mero perfeccionismo... }
  NumStr := ReplaceSubstring( '  ', ' ', NumStr );
  NumStr := ReplaceSubstring( ' ,', ',', NumStr );

  Extenso := NumStr;
end;

end.
