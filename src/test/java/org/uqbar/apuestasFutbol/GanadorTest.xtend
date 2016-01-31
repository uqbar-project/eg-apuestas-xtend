package org.uqbar.apuestasFutbol

import org.junit.Test

import static org.junit.Assert.*

class GanadorTest {
	@Test
	def void testGanador() {
		val partido = new Partido("Argentina", "Uruguay")
		val nico = new Apostador()
		val pepe = new Apostador()

		partido.apuestas += new Ganador(nico, 10, "Argentina", "Uruguay")
		partido.apuestas += new Ganador(pepe, 20, "Uruguay", "Argentina")

		// saldosIniciales
		assertEquals(100, nico.saldo)
		assertEquals(100, pepe.saldo)

		partido.gol("Uruguay", "Suarez")
		assertEquals(100, nico.saldo) // Todavía no se sabe cómo sale esta apuesta

		partido.gol("Argentina", "Palacio")
		partido.gol("Argentina", "Messi")
		assertEquals(100, nico.saldo) // Todavía nada, hasta que termine el partido

		partido.finalizar()		
		assertEquals(110, nico.saldo) // Ahora sí ganó
		assertEquals(80, pepe.saldo) // Vuelve a chequear, no debería haber cambiado
	}

}
