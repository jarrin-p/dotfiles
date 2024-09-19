(let [{: add-language-snippets : text : indent : text-array } (require :utils.snippets)]
  (add-language-snippets :sbt
                         [[:__task (text-array ["lazy val newTask = taskKey[Unit](\"description\")"
                                                "newTask := {"
                                                (indent 1 "// your task")
                                                "}"
                                                ])]
                          [:__sysprocess (text "import scala.sys.process.*")]
                          [:__project
                           (text "lazy val root = project"
                                 (indent 1 ".in(file(\".\"))")
                                 (indent 1 ".settings(")
                                 (indent 2 "name := \"someName\",")
                                 (indent 2 "version := \"0.0.1\",")
                                 (indent 2 "scalaVersion := \"3.3.1\",")
                                 (indent 2
                                         "// add project/plugins.sbt with '__assembly' import to enable this.")
                                 (indent 2
                                         "// assembly / assemblyJarName := \"JarName.jar\",")
                                 (indent 2 "libraryDependencies ++= Seq(")
                                 (indent 3
                                         "\"ch.qos.logback\" % \"logback-classic\" % \"1.2.10\",")
                                 (indent 3
                                         "\"com.typesafe.scala-logging\" %% \"scala-logging\" % \"3.9.4\",")
                                 (indent 2 ")") (indent 1 ")"))]
                          [:__assembly
                           (text "addSbtPlugin(\"com.eed3si9n\" % \"sbt-assembly\" % \"2.1.5\")")]]))

{}
