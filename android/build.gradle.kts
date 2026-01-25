import org.gradle.api.tasks.Delete

rootProject.buildDir = file("../build")
subprojects {
    buildDir = file("${rootProject.buildDir}/$name")
}
subprojects {
    tasks.withType<Test>().configureEach {
        enabled = false
    }
}
tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
