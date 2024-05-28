(let [{: add-language-snippets : text} (require :utils.snippets)]
  (add-language-snippets :sbt
                         [[:__project
                           (text "lazy val root = project"
                                  "\t.in(file(\".\"))" "\t.settings("
                                  "\t\tname := \"someName\","
                                  "\t\tversion := \"0.0.1\","
                                  "\t\tscalaVersion := \"3.3.1\","
                                  "\t\tassembly / assemblyJarName := \"JarName.jar\","
                                  "\t\tlibraryDependencies ++= Seq("
                                  "\t\t\t\"ch.qos.logback\" % \"logback-classic\" % \"1.2.10\","
                                  "\t\t\t\"com.typesafe.scala-logging\" %% \"scala-logging\" % \"3.9.4\","
                                  "\t\t)" ")")]]))
{}
