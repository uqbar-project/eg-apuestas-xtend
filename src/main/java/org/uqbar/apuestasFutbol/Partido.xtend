package org.uqbar.apuestasFutbol

import java.util.List
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.Data

@Accessors
class Partido {
	List<Apuesta> apuestas = newArrayList
	Map<String, List<String>> goles // Mapa de equipo a lista de los jugadores que hicieron los goles

	new(String equipo1, String equipo2) {
		// Se inicializa un mapa con cada equipo y listas vacías de goles
		goles = #{equipo1 -> sinGoles, equipo2 -> sinGoles}
	}

	def gol(String equipo, String jugador) {
		goles.get(equipo) += jugador // Agrega el jugador a la lista de goles del equipo
	}

	def finalizar() {
		apuestas.forEach[ apuesta |
			var boolean gano
			switch apuesta {
				ResultadoExacto: {
					gano = equipos.forall[ equipo | cantGoles(equipo) == apuesta.cantGoles(equipo)]
				}
				Ganador: {
					gano = cantGoles(apuesta.ganador) > cantGoles(apuesta.perdedor)
				}
			}
			apuesta.apostador.pagar(if (gano) apuesta.monto else -apuesta.monto)
		]
	}

	// *********************************
	// * Auxiliares
	def List<String> sinGoles() { newArrayList }
	def cantGoles(String equipo) { goles.get(equipo).size }
	def equipos() { goles.keySet }
}

@Data
class Apuesta {
	Apostador apostador
	int monto
}

class ResultadoExacto extends Apuesta {
	Map<String, Integer> resultado

	new(Apostador apostador, int monto, Map<String, Integer> resultado) {
		super(apostador, monto)
		this.resultado = resultado
	}

	def cantGoles(String equipo) {
		resultado.get(equipo)
	}
}

@Accessors
class Ganador extends Apuesta {
	String ganador
	String perdedor
	
	new(Apostador apostador, int monto, String ganador, String perdedor) {
		super(apostador, monto)
		this.ganador = ganador
		this.perdedor = perdedor
	}
}

class Apostador {
	@Accessors(PUBLIC_GETTER) var saldo = 100

	def void pagar(int monto) {
		saldo = saldo + monto
	}
	
}