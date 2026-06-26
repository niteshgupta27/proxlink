import org.gradle.api.tasks.compile.JavaCompile
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import com.android.build.gradle.BaseExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Apply configuration immediately to avoid afterEvaluate issues
subprojects {
    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = "17"
        targetCompatibility = "17"
    }
    tasks.withType<KotlinCompile>().configureEach {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_17)
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

// Handle android extension safely for projects that have it
subprojects {
    val subproject = this
    subproject.plugins.withId("com.android.application") { configureAndroidExtension(subproject) }
    subproject.plugins.withId("com.android.library") { configureAndroidExtension(subproject) }
}

fun configureAndroidExtension(project: Project) {
    val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
    android.compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
