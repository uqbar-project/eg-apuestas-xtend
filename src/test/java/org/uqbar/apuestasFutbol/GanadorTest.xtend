package org.uqbar.apuestasFutbol

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

import static org.junit.jupiter.api.Assertions.assertEquals

@DisplayName("Dadas unas apuestas por ganador para un partido")
class GanadorTest {	

	Partido partido
	Apostador ganador
	Apostador perdedor
	
	@BeforeEach
	def void init() {
		ganador = new Apostador()
		perdedor = new Apostador()
		partido = new Partido("Argentina", "Uruguay") => [
			apuestas = #[
				new Ganador(ganador, 10, "Argentina", "Uruguay"),
				new Ganador(perdedor, 20, "Uruguay", "Argentina")
			]
			gol("Uruguay", "Suarez")
			gol("Argentina", "Palacio")
			gol("Argentina", "Messi")
		]
	}

	@Test
	@DisplayName("mientras el partido está jugándose las apuestas están sin definición")
	def void testNoHayApuestaGanadoraHastaQueNoTermina() {
		assertEquals(100, ganador.saldo)
		assertEquals(100, perdedor.saldo)
	}	

	@Test
	@DisplayName("al finalizar el partido se pagan y cobran las apuestas")
	def void testGanador() {
		partido.finalizar()
		assertEquals(110, ganador.saldo) // Ahora sí ganó
		assertEquals(80, perdedor.saldo) // Vuelve a chequear, no debería haber cambiado
	}

}
