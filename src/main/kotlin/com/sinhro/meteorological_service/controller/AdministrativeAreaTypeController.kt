package com.sinhro.meteorological_service.controller

import com.sinhro.meteorological_service.dto.AdministrativeAreaTypeDTO
import com.sinhro.meteorological_service.service.AdministrativeAreaTypeService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/administrativeAreaType")
class AdministrativeAreaTypeController(
        @Autowired private val administrativeAreaTypeService: AdministrativeAreaTypeService
) {

    @GetMapping
    fun getAreaTypes(): List<AdministrativeAreaTypeDTO> {
        return administrativeAreaTypeService.getAllData()
    }

    @PostMapping
    fun insertAreaType(
            @RequestBody administrativeAreaTypeDTO: AdministrativeAreaTypeDTO
    ): String {
        administrativeAreaTypeService.insertData(administrativeAreaTypeDTO)
        return "done"
    }

    @PutMapping
    fun changeAreaType(
            @RequestBody administrativeAreaTypeDTO: AdministrativeAreaTypeDTO
    ): String {
        administrativeAreaTypeService.changeData(administrativeAreaTypeDTO)
        return "done"
    }

    @DeleteMapping
    fun deleteAreaType(
            @RequestBody administrativeAreaTypeDTO: AdministrativeAreaTypeDTO
    ): String {
        administrativeAreaTypeService.deleteData(administrativeAreaTypeDTO)
        return "done"
    }
}