import com.strumenta.antlrkotlin.gradle.AntlrKotlinTask
import org.gradle.jvm.tasks.Jar
import org.jetbrains.kotlin.gradle.tasks.AbstractKotlinCompile
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.jetbrains.kotlin.gradle.tasks.KotlinCompileCommon
import org.jetbrains.kotlin.gradle.tasks.KotlinNativeCompile

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
    jvm()
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
    applyDefaultHierarchyTemplate()
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

// This needs to be run manually or by CI
val generateKotlinGrammarSource = tasks.register<AntlrKotlinTask>("generateKotlinGrammarSource") {
    dependsOn("cleanGenerateKotlinGrammarSource")
    source = fileTree(layout.projectDirectory.dir("src/main/antlr")) {
        include("*.g4")
    }
    packageName = project.group.toString()
    arguments = listOf("-visitor")
    outputDirectory =
        layout.buildDirectory.dir("generatedAntlr/${project.group.toString().replace('.', '/')}").get().asFile
}

tasks.withType<AbstractKotlinCompile<*>> {
    dependsOn(generateKotlinGrammarSource)
}

tasks.withType<KotlinNativeCompile> {
    dependsOn(generateKotlinGrammarSource)
}

tasks.withType<Jar> {
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
                    name = project.name
                    description = "Lexer-parser frontend for the Ferrous compiler toolchain"
                    url = "https://git.karmakrafts.dev/kk/ferrous-project/vanadium"
                    licenses {
                        license {
                            name = "Apache License 2.0"
                            url = "https://www.apache.org/licenses/LICENSE-2.0"
                        }
                    }
                    developers {
                        developer {
                            id = "kitsunealex"
                            name = "KitsuneAlex"
                            url = "https://git.karmakrafts.dev/KitsuneAlex"
                        }
                    }
                    scm {
                        url = "https://git.karmakrafts.dev/kk/ferrous-project/vanadium"
                    }
                }
            }
        }
    }
}
