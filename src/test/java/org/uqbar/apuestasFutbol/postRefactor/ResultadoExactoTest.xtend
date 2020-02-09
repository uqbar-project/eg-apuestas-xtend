package org.uqbar.apuestasFutbol.postRefactor

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import static org.junit.jupiter.api.Assertions.assertEquals

@DisplayName("Dadas unas apuestas por resultado exacto para un partido")
class ResultadoExactoTest {
	
	Partido partido
	Apostador ganador
	Apostador perdedor
	
	@BeforeEach
	def void init() {
		partido = new Partido("Argentina", "Uruguay")
		ganador = new Apostador()
		perdedor = new Apostador()

		partido.apuestas += new ResultadoExacto(ganador, 10, #{"Argentina" -> 1, "Uruguay" -> 1})
		partido.apuestas += new ResultadoExacto(perdedor, 20, #{"Argentina" -> 1, "Uruguay" -> 0})
	}
	
	@Test
	@DisplayName("inicialmente los dos apostadores tienen su saldo intacto")
	def void testSaldoInicial() {
		assertEquals(100, ganador.saldo)
		assertEquals(100, perdedor.saldo)
	}

	@Test
	@DisplayName("cuando un equipo hace un gol, los que apostaron que no hacía goles pierden")
	def void testEquipoHaceGolPierdenLosApostaronPorqueNoLoHacia() {
		partido.gol("Uruguay", "Suarez")
		assertEquals(80, perdedor.saldo) // Resultado imposible, ya perdio
		assertEquals(100, ganador.saldo) // Todavía no se sabe cómo sale esta apuesta
	}

	@Test
	@DisplayName("cuando el partido no terminó, todavía no se pagan las apuestas")
	def void testResultadoExactoPartidoSinFinalizar() {
		partido.gol("Uruguay", "Suarez")
		partido.gol("Argentina", "Messi")
		assertEquals(100, ganador.saldo) // Todavía nada, hasta que termine el partido
	}

	@Test
	@DisplayName("cuando el partido termina, se pagan y se cobran todas las apuestas")
	def void testResultadoExacto() {
		partido.gol("Uruguay", "Suarez")
		partido.gol("Argentina", "Messi")
		partido.finalizar()		
		assertEquals(110, ganador.saldo) // Ahora sí ganó
		assertEquals(80, perdedor.saldo) // Vuelve a chequear, no debería haber cambiado
	}

}
