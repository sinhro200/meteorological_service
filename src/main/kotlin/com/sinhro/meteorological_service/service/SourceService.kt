package com.sinhro.meteorological_service.service

import com.sinhro.meteorogical_service.tables.Source
import com.sinhro.meteorological_service.dto.SourceDTO
import org.jooq.DSLContext
import org.springframework.beans.factory.annotation.Autowired

class SourceService(
        @Autowired
        private val dsl: DSLContext
) {
    private val tableSource = Source.SOURCE

    fun getAllData(): MutableList<SourceDTO> {
        val sources = dsl.select(tableSource.SOURCE_ID, Source.SOURCE.TITLE)
                .from(tableSource)
                .fetchInto(SourceDTO::class.java)
        return sources
    }

    fun insertData(
            source: SourceDTO
    ) {
        dsl.insertInto(tableSource)
                .columns(tableSource.TITLE)
                .values(source.title)
                .execute()
    }

    fun updateData(
            source: SourceDTO
    ) {
        dsl.update(tableSource)
                .set(tableSource.TITLE, source.title)
                .where(tableSource.SOURCE_ID.eq(source.source_id))
                .execute()
    }

    fun deleteData(
            source: SourceDTO
    ){
        dsl.deleteFrom(tableSource)
                .where(tableSource.SOURCE_ID.eq(source.source_id))
                .execute()
    }
}