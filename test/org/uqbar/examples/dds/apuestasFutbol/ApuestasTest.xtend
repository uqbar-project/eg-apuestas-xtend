package org.uqbar.examples.dds.apuestasFutbol;

import org.junit.Before
import org.junit.Test

import static org.junit.Assert.*

class ApuestasTest {
		val partido = new Partido("Argentina", "Uruguay")
		val nico = new Apostador()
		val pepe = new Apostador()

	@Before
	def void crearApuestas() {
		partido.apuestas += new ResultadoExacto(nico, 10, #{"Argentina" -> 1, "Uruguay" -> 1})
		partido.apuestas += new ResultadoExacto(pepe, 20, #{"Argentina" -> 1, "Uruguay" -> 0})
	}

	@Test
	def void saldosIniciales() {
		assertEquals(100, nico.saldo)
		assertEquals(100, pepe.saldo)
	}

	@Test
	def void apuestaPerdidaPorResultadoImposible() {
		partido.gol("Uruguay", "Suarez")
		assertEquals(100, nico.saldo) // Resultado posible, no pasa nada todavía
		assertEquals(80, pepe.saldo) // Resultado imposible, perdio
	}

	@Test
	def void apuestasEnJuego() {
		partido.gol("Argentina", "Messi")
		assertEquals(100, nico.saldo)
		assertEquals(100, pepe.saldo) // Ambos pueden ganar
	}

	@Test
	def void resultadoFinal() {
		partido.gol("Uruguay", "Suarez")
		partido.gol("Argentina", "Messi")
		partido.finalizar()		
		assertEquals(110, nico.saldo)
		assertEquals(80, pepe.saldo)
	}

}
