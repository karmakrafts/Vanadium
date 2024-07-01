import com.strumenta.antlrkotlin.gradle.AntlrKotlinTask
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.antlr)
}

group = "io.karma.vanadium"
version = "${libs.versions.vanadium.get()}.${System.getenv("CI_PIPELINE_IID") ?: 0}"

repositories {
    mavenCentral()
    google()
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