package com.sinhro.meteorological_service.config

import com.sinhro.meteorological_service.service.AdministrativeAreaService
import com.sinhro.meteorological_service.service.AdministrativeAreaTypeService
import com.sinhro.meteorological_service.service.SourceService
import org.jooq.DSLContext
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class DataServicesConfiguration(
        @Autowired private val dslContext: DSLContext
){


    @Bean
    fun administrativeAreaTypeService(): AdministrativeAreaTypeService {
        return AdministrativeAreaTypeService(dslContext)
    }

    @Bean
    fun sourceService(): SourceService {
        return SourceService(dslContext)
    }

    @Bean
    fun administrativeAreaService(): AdministrativeAreaService {
        return AdministrativeAreaService(dslContext)
    }
}