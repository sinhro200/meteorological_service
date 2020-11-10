package com.sinhro.meteorological_service

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class MeteorologicalServiceApplication

fun main(args: Array<String>) {
	runApplication<MeteorologicalServiceApplication>(*args)
}
