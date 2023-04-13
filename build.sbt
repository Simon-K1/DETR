// scalaVersion := "2.11.12"

// libraryDependencies ++= Seq(
//     "com.github.spinalhdl" % "spinalhdl-core_2.11" % "1.7.0",
//     "com.github.spinalhdl" % "spinalhdl-lib_2.11" % "1.7.0",
//     compilerPlugin("com.github.spinalhdl" % "spinalhdl-idsl-plugin_2.11" % "1.7.0"),
//     "com.google.code.gson" % "gson" % "2.7"
// )
ThisBuild / version := "1.0"
ThisBuild / scalaVersion := "2.12.16"
ThisBuild / organization := "org.example"

val spinalVersion = "1.8.1"
val spinalCore = "com.github.spinalhdl" %% "spinalhdl-core" % spinalVersion
val spinalLib = "com.github.spinalhdl" %% "spinalhdl-lib" % spinalVersion
val spinalIdslPlugin = compilerPlugin("com.github.spinalhdl" %% "spinalhdl-idsl-plugin" % spinalVersion)

lazy val projectname = (project in file("."))
  .settings(
    Compile / scalaSource := baseDirectory.value / "hw" / "spinal",
    libraryDependencies ++= Seq(spinalCore, spinalLib, spinalIdslPlugin)
  )

fork := true