/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import PIOBuild._

name := "apache-predictionio-data-elasticsearch1"

elasticsearchVersion := "1.7.3"

libraryDependencies ++= Seq(
  "org.apache.predictionio" %% "apache-predictionio-core" % version.value % "provided",
  "org.apache.predictionio" %% "apache-predictionio-data" % version.value % "provided",
  "org.elasticsearch"        % "elasticsearch"  % elasticsearchVersion.value,
  "org.scalatest"           %% "scalatest"      % "2.1.7" % "test",
  "org.specs2"              %% "specs2"         % "2.3.13" % "test")

parallelExecution in Test := false

pomExtra := childrenPomExtra.value

assemblyOption in assembly := (assemblyOption in assembly).value.copy(includeScala = false, includeDependency = true)

assemblyMergeStrategy in assembly := {
  case PathList("META-INF", "LICENSE.txt") => MergeStrategy.concat
  case PathList("META-INF", "NOTICE.txt")  => MergeStrategy.concat
  case x =>
    val oldStrategy = (assemblyMergeStrategy in assembly).value
    oldStrategy(x)
}

// skip test in assembly
test in assembly := {}

assemblyOutputPath in assembly := baseDirectory.value.getAbsoluteFile.getParentFile.getParentFile / "assembly" / "spark" / ("pio-data-elasticsearch1-assembly-" + version.value + ".jar")
