package org.uqbar.apuestasFutbol.postRefactor

import java.util.List
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors

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
		
		apuestas.clone.forEach [ apuesta |
			switch apuesta {
				ResultadoExacto:
					if (cantGoles(equipo) > apuesta.cantGoles(equipo)) {
						apuesta.apostador.pagar(-apuesta.monto)
						apuestas.remove(apuesta)
					}
			}
		]
	}

	def finalizar() {
		apuestas.forEach[ apuesta |
			switch apuesta {
				ResultadoExacto: {
					val gano = equipos.forall[ equipo | cantGoles(equipo) == apuesta.cantGoles(equipo)]
					apuesta.apostador.pagar(if (gano) apuesta.monto else -apuesta.monto)
				}
			}
		]
	}

	// *********************************
	// * Auxiliares
	def List<String> sinGoles() { newArrayList }
	def cantGoles(String equipo) { goles.get(equipo).size }
	def equipos() { goles.keySet }
}

@Accessors
class Apuesta {
	Apostador apostador
	int monto

	new(Apostador apostador, int monto) {
		this.apostador = apostador
		this.monto = monto
	}
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

class Ganador extends Apuesta {
	String ganador
	
	new(Apostador apostador, int monto, String ganador) {
		super(apostador, monto)
		this.ganador = ganador
	}
}

class Apostador {
	var saldo = 100

	def void pagar(int monto) {
		saldo = saldo + monto
	}
	
	def getSaldo() { saldo }
}
