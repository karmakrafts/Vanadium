import com.strumenta.antlrkotlin.gradle.AntlrKotlinTask
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.antlr)
    `maven-publish`
}

group = "io.karma.vanadium"
version = "${libs.versions.vanadium.get()}.${System.getenv("CI_PIPELINE_IID") ?: 0}"

repositories {
    mavenCentral()
    google()
    mavenLocal()
    maven("https://git.karmakrafts.dev/api/v4/projects/136/packages/maven")
}

kotlin {
    linuxX64 {
        binaries {
            sharedLib()
        }
    }
    macosX64 {
        binaries {
            framework {
                baseName = rootProject.name // settings.gradle
            }
        }
    }
    mingwX64 {
        binaries {
            sharedLib()
        }
    }
    sourceSets {
        commonMain {
            kotlin {
                srcDir(layout.buildDirectory.dir("generatedAntlr"))
            }
            dependencies {
                implementation(libs.antlrRuntime)
            }
        }
    }
}

val generateKotlinGrammarSource = tasks.register<AntlrKotlinTask>("generateKotlinGrammarSource") {
    dependsOn("cleanGenerateKotlinGrammarSource")
    source = fileTree(layout.projectDirectory.dir("src/main/antlr")) {
        include("*.g4")
    }
    packageName = "io.karma.vanadium"
    arguments = listOf("-visitor")
    val outDir = "generatedAntlr/${packageName!!.replace(".", "/")}"
    outputDirectory = layout.buildDirectory.dir(outDir).get().asFile
}

tasks.withType<KotlinCompile> {
    dependsOn(generateKotlinGrammarSource)
}

System.getenv("CI_API_V4_URL")?.let { apiUrl ->
    publishing {
        repositories {
            maven {
                url = uri("${apiUrl.replace("http://", "https://")}/projects/136/packages/maven")
                name = "GitLab"
                credentials(HttpHeaderCredentials::class) {
                    name = "Job-Token"
                    value = System.getenv("CI_JOB_TOKEN")
                }
                authentication {
                    create("header", HttpHeaderAuthentication::class)
                }
            }
        }
        publications.configureEach {
            if (this is MavenPublication) {
                pom {
                    name.set(project.name)
                    description.set("Lexer-parser frontend for the Ferrous compiler toolchain.")
                    url.set("https://git.karmakrafts.dev/kk/ferrous-project/vanadium")
                    licenses {
                        license {
                            name.set("Apache License 2.0")
                            url.set("https://www.apache.org/licenses/LICENSE-2.0")
                        }
                    }
                    developers {
                        developer {
                            id.set("KitsuneAlex")
                        }
                    }
                    scm {
                        url.set("https://git.karmakrafts.dev/kk/ferrous-project/vanadium")
                    }
                }
            }
        }
    }
}
