package com.sinhro.meteorological_service.controller

import com.sinhro.meteorological_service.dto.AdministrativeAreaDTO
import com.sinhro.meteorological_service.service.AdministrativeAreaService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/administrativeArea")
class AdministrativeAreaController(
        @Autowired
        private val administrativeAreaService: AdministrativeAreaService
) {

    @GetMapping("/usingParentAndQuery")
    fun getAdministrativeAreaChildForQuery(
            @RequestPart administrativeAreaDTO: AdministrativeAreaDTO?,
            @RequestPart queryForChild:String?
    ): List<AdministrativeAreaDTO> {
        return administrativeAreaService.getChilds(
                administrativeAreaDTO,
                queryForChild
        )
    }

    @GetMapping("/all")
    fun getAllAdministrativeAreas(): List<AdministrativeAreaDTO> {
        return administrativeAreaService.getAllData()
    }

    @PutMapping
    fun updateAdministrativeArea(
            @RequestBody administrativeAreaDTO: AdministrativeAreaDTO
    ){
        administrativeAreaService.updateData(administrativeAreaDTO)
    }

    @PostMapping
    fun insertAdministrativeArea(
            @RequestBody administrativeAreaDTO: AdministrativeAreaDTO
    ){
        administrativeAreaService.insertData(administrativeAreaDTO)
    }
}