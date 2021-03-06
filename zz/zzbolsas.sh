# ----------------------------------------------------------------------------
# http://br.finance.yahoo.com
# Pesquisa índices de bolsas e cotações de ações.
# Sem parâmetros mostra a lista de bolsas disponíveis (códigos).
# Com 1 parâmetro:
#  -l: apenas mostra as bolsas disponíveis e seus nomes.
#  commodities: produtos de origem primária nas bolsas.
#  taxas_fixas ou moedas: exibe tabela de comparação de câmbio (pricipais).
#  taxas_cruzadas: exibe a tabela cartesiana do câmbio.
#  nome_moedas ou moedas_nome: lista códigos e nomes das moedas usadas.
#  servicos, economia ou politica: mostra notícias relativas a esse assuntos.
#  noticias: junta as notícias de servicos e economia.
#  volume: lista ações líderes em volume de negócios na Bovespa.
#  alta ou baixa: lista as ações nessa condição na BMFBovespa.
#  "código de bolsa ou ação": mostra sua última cotação.
#
# Com 2 parâmetros:
#  -l e código de bolsa: lista as ações (códigos).
#  --lista e "código de bolsa": lista as ações com nome e última cotação.
#  taxas_fixas ou moedas <principais|europa|asia|latina>: exibe tabela de
#   comparação de câmbio dessas regiões.
#  "código de bolsa" e um texto: pesquisa-o no nome ou código das ações
#    disponíveis na bolsa citada.
#  "código de bolsa ou ação" e data: pesquisa a cotação no dia.
#  noticias e "código de ação": Noticias relativas a essa ação (só Bovespa)
#
# Com 3 parâmetros ou mais:
#  "código de bolsa ou ação" e 2 datas: pesquisa as cotações nos dias com
#    comparações entre datas e variações da ação ou bolsa pesquisada.
#  vs (ou comp) e 2 códigos de bolsas ou ações: faz a comparação entre as duas
#   ações ou bolsas. Se houver um quarto parametro como uma data faz essa
#   comparaçao na data especificada. Mas não compara ações com bolsas.
#
# Uso: zzbolsas [-l|--lista] [bolsa|ação] [data1|pesquisa] [data2]
# Ex.: zzbolsas                  # Lista das bolsas (códigos)
#      zzbolsas -l               # Lista das bolsas (nomes)
#      zzbolsas -l ^BVSP         # Lista as ações do índice Bovespa (código)
#      zzbolsas --lista ^BVSP    # Lista as ações do índice Bovespa (nomes)
#      zzbolsas ^BVSP loja       # Procura ações com "loja" no nome ou código
#      zzbolsas ^BVSP            # Cotação do índice Bovespa
#      zzbolsas PETR4.SA         # Cotação das ações da Petrobrás
#      zzbolsas PETR4.SA 21/12/2010  # Cotação da Petrobrás nesta data
#      zzbolsas commodities      # Tabela de commodities
#      zzbolsas altas            # Lista ações em altas na Bovespa
#      zzbolsas volume           # Lista ações em alta em volume de negócios
#      zzbolsas taxas_fixas
#      zzbolsas taxas_cruzadas
#      zzbolsas noticias         # Noticias recentes do mercado financeiro
#      zzbolsas vs petr3.sa vale5.sa # Compara ambas cotações
#
# Autor: Itamar <itamarnet (a) yahoo com br>
# Desde: 2009-10-04
# Versão: 13
# Licença: GPL
# Requisitos: zzmaiusculas zzsemacento zzdatafmt zzuniq
# ----------------------------------------------------------------------------
zzbolsas ()
{
	zzzz -h bolsas "$1" && return

	local url='http://br.finance.yahoo.com'
	local dj='^DWC'
	local new_york='^NYA ^NYI ^NYY ^NY ^NYL'
	local nasdaq='^IXIC ^IXBK ^NBI ^IXK ^IXF ^IXID ^IXIS ^IXFN ^IXUT ^IXTR ^NDX'
	local sp='^GSPC ^OEX ^MID ^SPSUPX ^SML'
	local amex='^XAX ^IIX ^NWX ^XMI'
	local ind_nac='^IBX50 ^IVBX ^IGCX ^IEE ^ITEL INDX.SA'
	local bolsa pag pags pag_atual data1 data2 vartemp

	case $# in
		0)
			# Lista apenas os códigos das bolsas disponíveis
			for bolsa in americas europe asia africa
			do
				zztool eco "\n$bolsa :"
				$ZZWWWDUMP "$url/intlindices?e=$bolsa"|
					sed -n '/Última/,/_/p'|sed '/Componentes,/!d'|
					awk '{ printf "%s ", $1}';echo
			done

			zztool eco "\nDow Jones :"
			$ZZWWWDUMP "$url/usindices"|
				sed -n '/Última/,/_/p'|sed '/Componentes,/!d'|
				awk '{ printf "%s ", $1}'
				printf "%s " "$dj";echo

			zztool eco "\nNYSE :"
			for bolsa in $new_york; do printf "%s " "$bolsa"; done;echo

			zztool eco "\nNasdaq :"
			for bolsa in $nasdaq; do printf "%s " "$bolsa"; done;echo

			zztool eco "\nStandard & Poors :"
			for bolsa in $sp; do printf "%s " "$bolsa"; done;echo

			zztool eco "\nAmex :"
			for bolsa in $amex; do printf "%s " "$bolsa"; done;echo

			zztool eco "\nOutros Índices Nacionais :"
			for bolsa in $ind_nac; do printf "%s " "$bolsa"; done;echo
		;;
		1)
			# Lista os códigos da bolsas e seus nomes
			case "$1" in
			-l | --lista)
				for bolsa in americas europe asia africa
				do
					zztool eco "\n$bolsa :"
					$ZZWWWDUMP "$url/intlindices?e=$bolsa"|
						sed -n '/Última/,/_/p'|sed '/Componentes,/!d'|
						sed 's/[0-9]*\.*[0-9]*,[0-9].*//g'|
						awk '{ printf " %-10s ", $1; for(i=2; i<=NF-1; i++) printf "%s ",$i; print $NF}'
				done

				zztool eco "\nDow Jones :"
				$ZZWWWDUMP "$url/usindices"|
					sed -n '/Última/,/_/p'|sed '/Componentes,/!d'|
					sed 's/[0-9]*\.*[0-9]*,[0-9].*//g'|
					awk '{ printf " %-10s ", $1; for(i=2; i<=NF-1; i++) printf "%s ",$i; print $NF}'
					printf " %-10s " "$dj";$ZZWWWDUMP "$url/q?s=$dj"|
					sed -n "/($dj)/{p;q;}"|sed "s/^ *//;s/ *($dj)//"

				zztool eco "\nNYSE :"
				for bolsa in $new_york;
				do
					printf " %-10s " "$bolsa";$ZZWWWDUMP "$url/q?s=$bolsa"|
					sed -n "/($bolsa)/{p;q;}"|sed "s/^ *//;s/ *($bolsa)//"
				done

				zztool eco "\nNasdaq :"
				for bolsa in $nasdaq;
				do
					printf " %-10s " "$bolsa";$ZZWWWDUMP "$url/q?s=$bolsa"|
					sed -n "/($bolsa)/{p;q;}"|sed "s/^ *//;s/ *($bolsa)//"
				done

				zztool eco "\nStandard & Poors :"
				for bolsa in $sp;
				do
					printf " %-10s " "$bolsa";$ZZWWWDUMP "$url/q?s=$bolsa"|
					sed -n "/($bolsa)/{p;q;}"|sed "s/^ *//;s/ *($bolsa)//"
				done

				zztool eco "\nAmex :"
				for bolsa in $amex;
				do
					printf " %-10s " "$bolsa";$ZZWWWDUMP "$url/q?s=$bolsa"|
					sed -n "/($bolsa)/{p;q;}"|sed "s/^ *//;s/ *($bolsa)//"
				done

				zztool eco "\nOutros Índices Nacionais :"
				for bolsa in $ind_nac;
				do
					printf " %-10s " "$bolsa";$ZZWWWDUMP "$url/q?s=$bolsa"|
					sed -n "/($bolsa)/{p;q;}"|sed "s/^ *//;s/ *($bolsa)//;s/ *-$//"
				done
			;;
			commodities)
				zztool eco  "  Commodities"
				$ZZWWWDUMP "$url/moedas/mercado.html" |
				sed -n '/^Commodities/,/Mais commodities/p' |
				sed '1d;$d;/^ *$/d;s/CAPTION: //g;s/ *Metais/\n&/'
			;;
			taxas_fixas|moedas)
				zzbolsas $1 principais
			;;
			taxas_cruzadas)
				zztool eco " Taxas Cruzadas"
				$ZZWWWDUMP "$url/moedas/principais" |
				sed -n '/CAPTION: Taxas cruzadas/,/Not.cias e coment.rios/p' |
				sed '1d;/^[[:space:]]*$/d;$d;s/ .ltima transação /                  /g'
			;;
			moedas_nome|nome_moedas)
				zztool eco " BRL - Real
 USD - Dolar Americano
 EUR - Euro
 GBP - Libra Esterlina
 CHF - Franco Suico
 CNH - Yuan Chines
 HKD - Dolar decHong Kong
 SGD - Dolar de Singapura
 MXN - Peso Mexicano
 ARS - Peso Argentino
 UYU - Peso Uruguaio
 CLP - Peso Chileno
 PEN - Nuevo Sol (Peru)"
			;;
			noticias | economia | politica | servicos)
				case "$1" in
				economia | politica) vartemp=$($ZZWWWDUMP "$url/noticias/categoria-economia-politica-governo") ;;
				servicos) vartemp=$($ZZWWWDUMP "$url/noticias/setor-servicos") ;;
				noticias)
					zztool eco "Economia - Política - Governo"
					zzbolsas economia
					zztool eco "Setor de Serviços"
					zzbolsas servicos
					return
				;;
				esac
				echo "$vartemp" |
				sed -n '/^[[:space:]]\+.*\(atrás\|BRT\)[[:space:]]*$/p' |
				sed 's/^[[:space:]]\+/ /g'| zzuniq
			;;
			volume|alta|baixa)
				case "$1" in
					volume) pag='actives';;
					alta)	pag='gainers';;
					baixa)	pag='losers';;
				esac
				zztool eco  " Maiores ${1}s"
				$ZZWWWDUMP "$url/${pag}?e=sa" |
				sed -n '/Informações relacionadas/,/^[[:space:]]*$/p' |
				sed '1d;s/\(Down \| de \)/-/g;s/Up /+/g;s/Gráfico, .*//g' |
				awk 'BEGIN {
							printf " %-10s  %-21s  %-20s  %-16s  %-10s\n","Símbolo","Nome","Última Transação","Variação","Volume"
						}
					{
						if (NF > 6) {
							nome = ""
							printf " %-10s ", $1;
							for(i=2; i<=NF-5; i++) {nome = nome sprintf( "%s ", $i)};
							printf " %-22s ", nome;
							for(i=NF-4; i<=NF-3; i++) printf " %-6s ", $i;
							printf "  "
							printf " %-6s ", $(NF-2); printf " %-9s ", $(NF-1);
							printf " %10s", $NF
							print ""
						}
					}'
			;;
			*)
				bolsa=$(echo "$1"|zzmaiusculas)
				# Último índice da bolsa citada ou cotação da ação
				vartemp=$($ZZWWWDUMP "$url/q?s=$bolsa"|
				sed -n "/($bolsa)/,/Cotações atrasadas, salvo indicação/p"|
				sed '{
						/^[[:space:]]*$/d
						/IFRAME:/d;
						/^[[:space:]]*-/d
						/Adicionar ao portfólio/d
						/As pessoas que viram/d
						/Cotações atrasadas, salvo indicação/,$d
					}' |
				zzsemacento)
				paste -d"|" <(echo "$vartemp"|cut -f1 -d:|sed 's/^[[:space:]]\+//g;s/[[:space:]]\+$//g') <(echo "$vartemp"|cut -f2- -d:|sed 's/^[[:space:]]\+//g')|
				awk -F"|" '{if ( $1 != $2 ) {printf " %-20s %s\n", $1 ":", $2} else { print $1 } }'
			;;
			esac
		;;
		2 | 3 | 4)
			# Lista as ações de uma bolsa especificada
			bolsa=$(echo "$2"|zzmaiusculas)
			if [ "$1" = "-l" -o "$1" = "--lista" ] && (zztool grep_var "$bolsa" "$dj $new_york $nasdaq $sp $amex $ind_nac" || zztool grep_var "^" "$bolsa")
			then
				pag_final=$($ZZWWWDUMP "$url/q/cp?s=$bolsa"|sed -n '/Primeira/p;/Primeira/q'|sed "s/^ *//g;s/.* \(of\|de\) *\([0-9]\+\) .*/\2/")
				pags=$(echo "scale=0;($pag_final - 1) / 50"|bc)

				for ((pag=0;pag<=$pags;pag++))
				do
					if test "$1" = "--lista"
					then
						# Listar as ações com descrição e suas últimas posições
						$ZZWWWDUMP "$url/q/cp?s=$bolsa&c=$pag"|
						sed -n 's/^ *//g;/Símbolo /,/^Tudo /p'|
						sed '/Símbolo /d;/^Tudo /d;/^[ ]*$/d'
					else
						# Lista apenas os códigos das ações
						$ZZWWWDUMP "$url/q/cp?s=$bolsa&c=$pag"|
						sed -n 's/^ *//g;/Símbolo /,/^Tudo /p'|
						sed '/Símbolo /d;/^Tudo /d;/^[ ]*$/d'|
						awk '{printf "%s  ",$1}'

						if test "$pag" = "$pags";then echo;fi
					fi
				done

			# Valores de uma bolsa ou ação em uma data especificada (histórico)
			elif zztool testa_data $(zzdatafmt "$2")
			then
				read dd mm yyyy data1 < <(zzdatafmt -f "DD MM AAAA DD/MM/AAAA" "$2")
				mm=$(echo "scale=0;${mm}-1"|bc)
				bolsa=$(echo "$1"|zzmaiusculas)
					# Emprestando as variaves pag, pags e pag_atual efeito estético apenas
					pag=$($ZZWWWDUMP "$url/q/hp?s=$bolsa&a=${mm}&b=${dd}&c=${yyyy}&d=${mm}&e=${dd}&f=${yyyy}&g=d"|
					sed -n "/($bolsa)/p;/Abertura/,/* Preço/p"|sed 's/Data/    /;/* Preço/d'|
					sed 's/^ */ /g')
					pags=$(echo "$pag" | sed -n '2p' | sed 's/ [A-Z]/\n\t&/g;s/Enc ajustado/Ajustado/'| sed '/^ *$/d' | awk '{printf "  %-12s\n", $1}')
					pag_atual=$(echo "$pag" | sed -n '3p' | cut -f7- -d" " | sed 's/ [0-9]/\n&/g' | sed '/^ *$/d' |  awk '{printf " %14s\n", $1}')
					echo "$pag" | sed -n '1p'

					if [ "$3" ] && zztool testa_data $(zzdatafmt "$3")
					then
						read dd mm yyyy data2 < <(zzdatafmt -f "DD MM AAAA DD/MM/AAAA" "$3")
						mm=$(echo "scale=0;${mm}-1"|bc)
						pag=$($ZZWWWDUMP "$url/q/hp?s=$bolsa&a=${mm}&b=${dd}&c=${yyyy}&d=${mm}&e=${dd}&f=${yyyy}&g=d"|
						sed -n "/($bolsa)/p;/Abertura/,/* Preço/p"|sed 's/Data/    /;/* Preço/d'|
						sed 's/^ */ /g' | sed -n '3p' | cut -f7- -d" " |sed 's/ [0-9]/\n&/g' |
						sed '/^ *$/d' | awk '{printf " %14s\n", $1}')
						paste <(printf "  %-12s" "Data") <(echo "     $data1") <(echo "     $data2") <(echo "       Variação") <(echo " Var (%)")

						vartemp=$(while read data1 data2
						do
							echo "$data1 $data2" | tr -d '.' | tr ',' '.' |
							awk '{ printf "%15.2f\t", $2-$1; if ($1 != 0) {printf "%7.2f%", (($2-$1)/$1)*100}}' 2>/dev/null
							echo
						done < <(paste <(echo "$pag_atual") <(echo "$pag")))

						paste <(echo "$pags") <(echo "$pag_atual") <(echo "$pag") <(echo "$vartemp")
					else
						paste <(printf "  %-12s" "Data") <(echo "     $data1")
						paste <(echo "$pags") <(echo "$pag_atual")
					fi
			# Compara duas ações ou bolsas diferentes
			elif ([ "$1" = "vs" -o "$1" = "comp" ])
			then
				if (zztool grep_var "^" "$2" && zztool grep_var "^" "$3")
				then
					vartemp="0"
				elif (! zztool grep_var "^" "$2" && ! zztool grep_var "^" "$3")
				then
					vartemp="0"
				fi
				if [ "$vartemp" ]
				then
					# Compara numa data especifica as ações ou bolsas
					if ([ "$4" ] && zztool testa_data $(zzdatafmt "$4"))
					then
						pag=$(zzbolsas "$2" "$4" | sed '/Proxima data de anuncio/d')
						pags=$(zzbolsas "$3" "$4" |
						sed '/Proxima data de anuncio/d;s/^[[:space:]]*//g;s/[[:space:]]*$//g' |
						sed '2,$s/[^[:space:]]*[[:space:]]\+//g')
					# Ultima cotaçao das açoes ou bolsas comparadas
					else
						pag=$(zzbolsas "$2" | sed '/Proxima data de anuncio/d')
						pags=$(zzbolsas "$3" | sed '/Proxima data de anuncio/d' |
						sed 's/^[[:space:]]*//g;3,$s/.*:[[:space:]]*//g')
					fi
					# Imprime efetivamente a comparação
					if [ $(echo "$pag"|awk 'END {print NR}') -ge 4 -a $(echo "$pags"|awk 'END {print NR}') -ge 4 ]
					then
						echo
						while read data1
						do
							let vartemp++
							printf " %-45s " "$data1"
							sed -n "${vartemp}p" <(echo "$pags")
						done < <(echo "$pag")
						echo
					fi
				fi
			# Noticias relacionadas a uma ação especifica
			elif ([ "$1" = "noticias" ] && ! zztool grep_var "^" "$2")
			then
				$ZZWWWDUMP "$url/q/h?s=$bolsa" |
				sed -n '/^[[:blank:]]\+\*.*\(Agencia\|at noodls\).*)$/p' |
				sed 's/^[[:blank:]]*/ /g;s/\(Agencia\|at noodls\)/ &/g'
			elif ([ "$1" = "taxas_fixas" ] || [ "$1" = "moedas" ])
			then
				case $2 in
				asia)
					url="$url/moedas/asia-pacifico"
					zztool eco  "   $(echo $1 | sed 'y/tfm_/TFM /') - Ásia-Pacífico"
				;;
				latina)
					url="$url/moedas/america-latina"
					zztool eco  "   $(echo $1 | sed 'y/tfm_/TFM /') - América Latina"
				;;
				europa)
					url="$url/moedas/europa"
					zztool eco  "   $(echo $1 | sed 'y/tfm_/TFM /') - Europa"
				;;
				principais|*)
					url="$url/moedas/principais"
					zztool eco  "   $(echo $1 | sed 'y/tfm_/TFM /') - Principais"
				;;
				esac
				
				$ZZWWWDUMP "$url" |
				sed -n '/CAPTION: Taxas fixas/,/CAPTION: Taxas cruzadas/p' |
				sed '
						/CAPTION: /d
						/^[[:space:]]\{5\}/d
						/^[[:space:]]*$/d
						s/ *Visualização do gráfico//g
						s/ *Par cambial/\n&/g
						s/ Inverter pares /                /g
					'|sed '3,$s/Par cambial          /Par cambial invertido/;1d'
			else
				bolsa=$(echo "$1"|zzmaiusculas)
				pag_final=$($ZZWWWDUMP "$url/q/cp?s=$bolsa"|sed -n '/Primeira/p;/Primeira/q'|sed 's/^ *//g;s/.* \(of\|de\) *\([0-9]\+\) .*/\2/')
				pags=$(echo "scale=0;($pag_final - 1) / 50"|bc)
				for ((pag=0;pag<=$pags;pag++))
				do
					$ZZWWWDUMP "$url/q/cp?s=$bolsa&c=$pag"|
					sed -n 's/^ *//g;/Símbolo /,/Primeira/p'|
					sed '/Símbolo /d;/Primeira/d;/^[ ]*$/d'|
					grep -i "$2"
				done
			fi
		;;
	esac
}
