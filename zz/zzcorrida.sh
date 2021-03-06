# ----------------------------------------------------------------------------
# Mostra a classificação dos pilotos em várias corridas (F1, Indy, GP, ...).
#
#  Use as seguintes combinações para as corridas
#   Fórmula 1: f1 ou formula1
#   Fórmula Indy: indy ou formula_indy
#   GP2: gp2
#   Fórmula Truck: truck ou formula_truck
#   Fórmula Truck Sul-Americana: truck_sul
#   Stock Car: stock ou stock_car
#   Moto GP: moto ou moto_gp
#   Moto 2: moto2
#   Moto 3: moto3
#   Rali: rali
#   Sprint Cup (Nascar): nascar ou nascar1 ou sprint ou sprint_cup
#   Truck Series (Nascar): nascar2 ou truck_series
#
# Uso: zzcorrida <f1|indy|gp2|truck|truck_sul|stock|rali>
# Uso: zzcorrida <moto|moto_gp|moto2|moto3>
# Uso: zzcorrida <nascar|nascar1|sprint|nascar2|truck_series>
# Ex.: zzcorrida truck
#
# Autor: Itamar <itamarnet (a) yahoo com br>
# Desde: 2011-11-02
# Versão: 5
# Licença: GPL
# Requisitos: zzmaiusculas
# ----------------------------------------------------------------------------
zzcorrida ()
{
	zzzz -h corrida "$1" && return

	# Verificação dos parâmetros
	[ "$1" ] || { zztool uso corrida; return 1; }

	local corridas
	local url="http://tazio.uol.com.br/classificacoes"

	case "$1" in
		f1|formula1)			corridas="f1";;
		indy|formula_indy)		corridas="indy";;
		gp2)				corridas="gp2";;
		nascar|nascar1|nascar2)		corridas="nascar";;
		sprint|sprint_cup|truck_series)	corridas="nascar";;
		truck|formula_truck|truck_sul)	corridas="formula-truck";;
		rali)				corridas="rali";;
		stock|stock_car)		corridas="stock-car";;
		moto|moto_gp|moto2|moto3)	corridas="moto";;
		*)				zztool uso corrida; return 1;;
	esac

	echo "$1"|sed 's/_/ /'|zzmaiusculas

	case "$1" in
		nascar|nascar1|sprint|sprint_cup)
			$ZZWWWDUMP "$url/$corridas" | sed -n '/Pos.*Piloto/,/Data/p' |
			sed '1,/Data/!d;s/ Pontos/Pontos/' | sed 's/\[.*\]/        /;$d'
		;;
		nascar2|truck_series)
			$ZZWWWDUMP "$url/$corridas" | sed -n '/Pos.*Piloto/,/Data/p' |
			sed '1,/Data/d;s/ Pontos/Pontos/' | sed 's/\[.*\]/        /;$d'
		;;
		truck|formula_truck)
			$ZZWWWDUMP "$url/$corridas" | sed -n '/Pos.*Piloto/,/Pos.*Piloto/p' |
			sed 's/ Pontos/Pontos/;$d' | sed 's/\[.*\]/        /'
		;;
		truck_sul)
			$ZZWWWDUMP "$url/$corridas" | sed -n '/Pos.*Piloto/,/Data/p' |
			sed '2,/Pos.*Piloto/d;s/ Pontos/Pontos/;$d' | sed 's/\[.*\]/        /'
		;;
		moto|moto_gp)
			$ZZWWWDUMP "$url/$corridas" | sed -n '/Pos.*Piloto/,/^ *$/p' |
			sed '1p;2,/Pos.*Piloto/!d' | sed 's/ Pontos/Pontos/;$d' | sed 's/\[.*\]/        /'
		;;
		moto2)
			$ZZWWWDUMP "$url/$corridas" | sed '1,/Pos.*Piloto/ d' |
			sed -n '/Pos.*Piloto/,/Pos.*Piloto/ p' |
			sed 's/ Pontos/Pontos/;$d' | sed 's/\[.*\]/        /'
		;;
		moto3)
			$ZZWWWDUMP "$url/$corridas" | sed '1,/Pos.*Piloto/ d' | sed '1,/Pos.*Piloto/ d' |
			sed -n '/Pos.*Piloto/,/^ *$/ p' |
			sed 's/ Pontos/Pontos/;$d' | sed 's/\[.*\]/        /'
		;;
		*)
			$ZZWWWDUMP "$url/$corridas" | sed -n '/Pos.*Piloto/,$ p' |
			sed '/^ *Data/ q' | sed '/^ *Pos\. *Equipe/ q' |
			sed 's/ Pontos/Pontos/;$d' | sed 's/\[.*\]/        /'
		;;
	esac
}
