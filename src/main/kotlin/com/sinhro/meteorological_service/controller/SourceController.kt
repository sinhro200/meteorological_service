package com.sinhro.meteorological_service.controller

import com.sinhro.meteorogical_service.tables.Source
import com.sinhro.meteorological_service.SourcePOJO
import org.jooq.DSLContext
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*

@RestController
class SourceController(
        @Autowired private val dsl: DSLContext
){

    @GetMapping("/api/source")
    fun getSources(): List<SourcePOJO> {
        val sources = dsl.select(Source.SOURCE.SOURCE_ID,Source.SOURCE.TITLE)
                .from(Source.SOURCE)
                .fetchInto(SourcePOJO::class.java)
        return sources
    }

    @PostMapping("/api/source")
    fun postSources(
            @RequestBody source : SourcePOJO
    ): String {
        val sources = dsl.insertInto(Source.SOURCE)
                .columns(Source.SOURCE.SOURCE_ID,Source.SOURCE.TITLE)
                .values(source.id,source.title)
                .execute()
        return "success"
    }
}