package com.sinhro.meteorological_service.controller

import com.sinhro.meteorogical_service.tables.AdministrativeArea
import com.sinhro.meteorogical_service.tables.Location
import com.sinhro.meteorogical_service.tables.Weather
import org.jooq.DSLContext
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController


@RestController
class TestController(
        @Autowired private val dsl: DSLContext) {

    private val administrativeAreaTable = AdministrativeArea.ADMINISTRATIVE_AREA

    @GetMapping("/test")
    fun test(): String {
        return "test"
    }

    @GetMapping("/api/location")
    fun location(): String {
        return dsl.select(
                administrativeAreaTable.ADMINISTRATIVE_AREA_ID,
                administrativeAreaTable.TITLE
        )
                .from(administrativeAreaTable)
                .fetch()
                .toString()
    }

}