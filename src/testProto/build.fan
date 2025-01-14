#! /usr/bin/env fan
//
// Copyright (c) 2022, Brian Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   11 May 2022  Brian Frank  Creation
//

using build

**
** Build: testProto
**
class Build : BuildPod
{
  new make()
  {
    podName = "testProto"
    summary = "Proto test harness"
    meta    = ["org.name":     "SkyFoundry",
               "org.uri":      "https://skyfoundry.com/",
               "proj.name":    "Haxall",
               "proj.uri":     "https://haxall.io/",
               "license.name": "Academic Free License 3.0",
               "vcs.name":     "Git",
               "vcs.uri":      "https://github.com//briansfrank/proto"]
    depends = ["sys @{fan.depend}",
               "concurrent @{fan.depend}",
               "proto @{proto.depend}",
               "protoc @{proto.depend}"]
    srcDirs = [`fan/`]
  }
}