package com.sinhro.meteorological_service.service

import com.sinhro.meteorogical_service.tables.AdministrativeArea
import com.sinhro.meteorological_service.dto.AdministrativeAreaDTO
import org.jooq.Condition
import org.jooq.DSLContext
import org.jooq.Row4
import org.jooq.impl.DSL.position
import org.jooq.impl.DSL.row
import org.springframework.beans.factory.annotation.Autowired

class AdministrativeAreaService(
        @Autowired private val dsl: DSLContext
) {
    private val tableAdministrativeArea =
            AdministrativeArea.ADMINISTRATIVE_AREA

    fun getChilds(
            administrativeAreaDTO: AdministrativeAreaDTO?,
            queryForChilds: String? = null
    ): List<AdministrativeAreaDTO> {
        var whereCondition: Condition
        if (administrativeAreaDTO == null)
            whereCondition = tableAdministrativeArea.INCLUDED_IN_ID.isNull
        else
            whereCondition = tableAdministrativeArea.INCLUDED_IN_ID.eq(
                    administrativeAreaDTO.administrative_area_id
            )

        queryForChilds?.let {
            whereCondition = whereCondition
                    .and(tableAdministrativeArea.TITLE.like(
                            "%${queryForChilds}%"
                    ))
        }

        val result = dsl.select(
                tableAdministrativeArea.ADMINISTRATIVE_AREA_ID,
                tableAdministrativeArea.INCLUDED_IN_ID,
                tableAdministrativeArea.TYPE_ID,
                tableAdministrativeArea.TITLE)
                .from(tableAdministrativeArea)
                .where(whereCondition)
                .orderBy(position(tableAdministrativeArea.TITLE, queryForChilds))
                .fetchInto(AdministrativeAreaDTO::class.java)
        return result
    }

    fun getAllData(): List<AdministrativeAreaDTO> {
        return dsl.select(tableAdministrativeArea.ADMINISTRATIVE_AREA_ID,
                tableAdministrativeArea.INCLUDED_IN_ID,
                tableAdministrativeArea.TYPE_ID,
                tableAdministrativeArea.TITLE)
                .from(tableAdministrativeArea)
                .fetchInto(AdministrativeAreaDTO::class.java)
    }

    fun updateData(
            administrativeAreaDTO: AdministrativeAreaDTO
    ){
        dsl.update(tableAdministrativeArea)
                .set(
                        row(
                                tableAdministrativeArea.INCLUDED_IN_ID,
                                tableAdministrativeArea.TITLE,
                                tableAdministrativeArea.TYPE_ID
                        ),
                        row(
                                administrativeAreaDTO.included_in_id,
                                administrativeAreaDTO.title,
                                administrativeAreaDTO.type_id
                        )
                )
                .where(
                        tableAdministrativeArea.ADMINISTRATIVE_AREA_ID.eq(
                                administrativeAreaDTO.administrative_area_id
                        )
                )
                .execute()
    }

    fun deleteData(
            administrativeAreaDTO: AdministrativeAreaDTO
    ){
        dsl.deleteFrom(tableAdministrativeArea)
                .where(tableAdministrativeArea.ADMINISTRATIVE_AREA_ID.eq(
                        administrativeAreaDTO.administrative_area_id))
                .execute()
    }

    fun insertData(administrativeAreaDTO: AdministrativeAreaDTO) {
        dsl.insertInto(tableAdministrativeArea)
                .columns(
                        tableAdministrativeArea.ADMINISTRATIVE_AREA_ID,
                        tableAdministrativeArea.INCLUDED_IN_ID,
                        tableAdministrativeArea.TYPE_ID,
                        tableAdministrativeArea.TITLE
                )
                .values(
                        administrativeAreaDTO.administrative_area_id,
                        administrativeAreaDTO.included_in_id,
                        administrativeAreaDTO.type_id,
                        administrativeAreaDTO.title
                )
                .execute()
    }
}