package com.sinhro.meteorological_service

import javax.persistence.Column


class SourcePOJO(
        @Column(name = "source_id")
        val id: Int,
        val title: String
)

class WindDirectionPOJO(
        @Column(name = "wind_direction_id")
        val id: Int,
        val title: String
)