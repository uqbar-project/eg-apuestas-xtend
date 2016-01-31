package org.uqbar.apuestasFutbol.postRefactor

import org.junit.Test

import static org.junit.Assert.*

class ResultadoExactoTest {
	@Test
	def void testResultadoExacto() {
		val partido = new Partido("Argentina", "Uruguay")
		val nico = new Apostador()
		val pepe = new Apostador()

		partido.apuestas += new ResultadoExacto(nico, 10, #{"Argentina" -> 1, "Uruguay" -> 1})
		partido.apuestas += new ResultadoExacto(pepe, 20, #{"Argentina" -> 1, "Uruguay" -> 0})

		// saldosIniciales
		assertEquals(100, nico.saldo)
		assertEquals(100, pepe.saldo)

		partido.gol("Uruguay", "Suarez")
		assertEquals(80, pepe.saldo) // Resultado imposible, ya perdio
		assertEquals(100, nico.saldo) // Todavía no se sabe cómo sale esta apuesta

		partido.gol("Argentina", "Messi")
		assertEquals(100, nico.saldo) // Todavía nada, hasta que termine el partido

		partido.finalizar()		
		assertEquals(110, nico.saldo) // Ahora sí ganó
		assertEquals(80, pepe.saldo) // Vuelve a chequear, no debería haber cambiado
	}

}
