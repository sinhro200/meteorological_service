package com.sinhro.meteorological_service.controller

import com.sinhro.meteorological_service.dto.SourceDTO
import com.sinhro.meteorogical_service.tables.Source
import com.sinhro.meteorological_service.service.SourceService
import org.jooq.DSLContext
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/source")
class SourceController(
        @Autowired private val sourceService: SourceService
){

    @GetMapping
    fun getSources(): List<SourceDTO> {
        return sourceService.getAllData()
    }

    @PostMapping
    fun postSource(
            @RequestBody source : SourceDTO
    ): String {
        sourceService.insertData(source)
        return "done"
    }

    @PutMapping
    fun changeSource(
            @RequestBody source : SourceDTO
    ): String {
        sourceService.updateData(source)
        return "done"
    }

    @DeleteMapping
    fun deleteSource(
            @RequestBody source: SourceDTO
    ): String {
        sourceService.deleteData(source)
        return "done"
    }
}