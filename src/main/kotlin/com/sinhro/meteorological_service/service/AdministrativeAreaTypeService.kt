package com.sinhro.meteorological_service.service

import com.sinhro.meteorogical_service.tables.AdministrativeAreaType
import com.sinhro.meteorological_service.dto.AdministrativeAreaTypeDTO
import org.jooq.DSLContext
import org.springframework.beans.factory.annotation.Autowired


class AdministrativeAreaTypeService(
        private val dsl: DSLContext
) {
    private val tableAdministrativeAreaType: AdministrativeAreaType =
            AdministrativeAreaType.ADMINISTRATIVE_AREA_TYPE

    fun insertData(
            administrativeAreaTypeDTO: AdministrativeAreaTypeDTO
    ){
        dsl.insertInto(tableAdministrativeAreaType)
                .columns(tableAdministrativeAreaType.TITLE)
                .values(administrativeAreaTypeDTO.title)
                .execute()
    }

    fun deleteData(
            administrativeAreaTypeDTO: AdministrativeAreaTypeDTO
    ){
        dsl.deleteFrom(tableAdministrativeAreaType)
                .where(tableAdministrativeAreaType.ADMINISTRATIVE_AREA_TYPE_ID.eq(
                        administrativeAreaTypeDTO.administrative_area_type_id
                ))
                .execute()
    }

    fun changeData(
            administrativeAreaTypeDTO: AdministrativeAreaTypeDTO
    ){
        dsl.update(tableAdministrativeAreaType)
                .set(tableAdministrativeAreaType.TITLE, administrativeAreaTypeDTO.title)
                .where(tableAdministrativeAreaType.ADMINISTRATIVE_AREA_TYPE_ID
                        .eq(administrativeAreaTypeDTO.administrative_area_type_id)
                )
                .execute()
    }

    fun getAllData(): List<AdministrativeAreaTypeDTO> {
        return dsl.select(
                tableAdministrativeAreaType.ADMINISTRATIVE_AREA_TYPE_ID,
                tableAdministrativeAreaType.TITLE)
                .from(tableAdministrativeAreaType)
                .fetchInto(AdministrativeAreaTypeDTO::class.java)
    }
}