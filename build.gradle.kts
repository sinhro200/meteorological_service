import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("org.springframework.boot") version "2.3.5.RELEASE"
    id("io.spring.dependency-management") version "1.0.10.RELEASE"
    id("org.flywaydb.flyway") version "7.2.0"
    kotlin("jvm") version "1.3.72"
    kotlin("plugin.spring") version "1.3.72"
    id("nu.studer.jooq") version "5.2"
}
var jdbc_url = "jdbc:mysql://localhost:3306/meteoservice?serverTimezone=UTC&useSSL=false"
var jdbc_username = "meteoservice_root"
var jdbc_password = "12457800"
var jdbc_driverClassName = "com.mysql.cj.jdbc.Driver"


System.getenv("jdbc.url")?.let {
    jdbc_url = it
}
System.getenv("jdbc.jdbc_username")?.let {
    jdbc_username = it
}
System.getenv("jdbc.password")?.let {
    jdbc_password = it
}
System.getenv("jdbc.driver_class_name")?.let {
    jdbc_driverClassName = it
}

flyway {
    url = jdbc_url
    user = jdbc_username
    password = jdbc_password
}

jooq {
    version.set("3.14.1")  // default (can be omitted)
    edition.set(nu.studer.gradle.jooq.JooqEdition.OSS)  // default (can be omitted)

    configurations {
        create("main") {  // name of the jOOQ configuration
            generateSchemaSourceOnCompilation.set(true)  // default (can be omitted)

            jooqConfiguration.apply {
                logging = org.jooq.meta.jaxb.Logging.WARN
                jdbc.apply {
//					driver = "org.postgresql.Driver"
                    driver = jdbc_driverClassName
//					url = "jdbc:postgresql://localhost:5432/sample"
                    url = jdbc_url
                    user = jdbc_username
                    password = jdbc_password
                    properties.add(
                            org.jooq.meta.jaxb.Property()
                                    .withKey("ssl")
//									.withValue("true")
                                    .withValue("false")
                    )
                }
                generator.apply {
                    name = "org.jooq.codegen.DefaultGenerator"
                    database.apply {
//						name = "org.jooq.util.mysql.MySQLDatabase"
                        name = "org.jooq.meta.mysql.MySQLDatabase"
                        inputSchema = "meteoservice"
                        forcedTypes.addAll(arrayOf(
                                org.jooq.meta.jaxb.ForcedType()
                                        .withName("varchar")
                                        .withIncludeExpression(".*")
                                        .withIncludeTypes("JSONB?"),
                                org.jooq.meta.jaxb.ForcedType()
                                        .withName("varchar")
                                        .withIncludeExpression(".*")
                                        .withIncludeTypes("INET")
                        ).toList())
                    }
                    generate.apply {
                        isDeprecated = false
                        isRecords = true
                        isImmutablePojos = true
                        isFluentSetters = true
                    }
                    target.apply {
//						packageName = "nu.studer.sample"
//						directory = "build/generated-src/jooq/main"  // default (can be omitted)
                        packageName = "com.sinhro.meteorogical_service"
                        directory = "build/generated-src/jooq/main"
                        /*
                        packageName('us.klingman.codeParser.db')
                        directory('src/main/java')
                         */
                    }
                    strategy.name = "org.jooq.codegen.DefaultGeneratorStrategy"
                }
            }
        }
    }
}

group = "com.sinhro"
version = "0.0.1-SNAPSHOT"
java.sourceCompatibility = JavaVersion.VERSION_11

repositories {
    mavenCentral()
}

dependencies {
//	jooqGenerator("org.postgresql:postgresql:42.2.14")
    jooqGenerator("mysql:mysql-connector-java:8.0.11")
//	jooqRuntime("postgresql:postgresql:9.1-901.jdbc4")

    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
    implementation("org.flywaydb:flyway-core")
//	implementation("mysql:mysql-connector-java:8.0.11")
//	implementation("mysql:mysql-connector-java:5.1.45")
    runtimeOnly("mysql:mysql-connector-java:8.0.11")
//	compile ("mysql:mysql-connector-java:6.0.+")
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
    testImplementation("org.springframework.boot:spring-boot-starter-test") {
        exclude(group = "org.junit.vintage", module = "junit-vintage-engine")
    }
    implementation("org.jooq:jooq:3.7.4")
    implementation("org.springframework.boot:spring-boot-starter-data-jdbc")
//    compile("javax.persistence:javax.persistence-api:jar:2.2")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
}


tasks.withType<Test> {
    useJUnitPlatform()
}

tasks.withType<KotlinCompile> {
    kotlinOptions {
        freeCompilerArgs = listOf("-Xjsr305=strict")
        jvmTarget = "11"
    }
}

