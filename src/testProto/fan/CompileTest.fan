//
// Copyright (c) 2022, Brian Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   19 Jul 2022  Brian Frank  Creation
//

using proto

**
** Compile tests
**
class CompileTest : Test
{

  Void testBasics()
  {
    ps := ProtoEnv.cur.compile(["sys"])
    ps.root.dump

    sys := verifyLib(ps, "sys", "0.9.1")
    verifyEq(ps.libs.size, 1)
    verifySame(ps.libs[0], sys)
    verifySame(ps.root->sys, sys)

    obj    := verifyProto(ps, "sys.Obj",    null,   null)
    marker := verifyProto(ps, "sys.Marker", obj,    null)
    val    := verifyProto(ps, "sys.Val",    obj,    null)
    scalar := verifyProto(ps, "sys.Scalar", val,    null)
    bool   := verifyProto(ps, "sys.Bool",   scalar, null)
    boolT  := verifyProto(ps, "sys.True",   bool,   "true")
    boolF  := verifyProto(ps, "sys.False",  bool,   "false")
    str    := verifyProto(ps, "sys.Str",    scalar, null)

    objDoc    := verifyProto(ps, "sys.Obj._doc", str, "Root type for all objects")
    objDocDoc := verifyProto(ps, "sys.Obj._doc._doc", str, "Documentation for object")
    valDoc    := verifyProto(ps, "sys.Val._doc", objDoc, "Data value type")
    scalarDoc := verifyProto(ps, "sys.Scalar._doc", objDoc, "Scalar is an atomic value kind")

    verifySame(sys->Obj, obj)
    verifySame(obj->_doc, objDoc)
    verifyErr(UnknownProtoErr#) { sys->Foo }
    verifyErr(UnknownProtoErr#) { obj->foo }
  }

  ProtoLib verifyLib(ProtoSpace ps, Str name, Str version)
  {
    path := Path(name)
    lib := ps.lib(name)
    verifySame(lib, ps.get(Path(name)))
    verifyProto(ps, name, ps.sys->Lib, null)
    verifyProto(ps, name+"._version", ps.sys->Lib->_version, version)
    verifyEq(lib.version, Version(version))
    return lib
  }

  Proto verifyProto(ProtoSpace ps, Str path, Proto? type, Obj? val)
  {
    p := ps.get(Path(path))
    verifyEq(p.name, path.split('.').last)
    verifyEq(p.path.toStr, path)
    verifySame(p.type, type)
    verifyEq(p.toStr, path)
    if (val != null)
    {
      verifyEq(p.val, val)
    }
    else
    {
      verifyEq(p.val(false), null)
      verifyErr(ProtoMissingValErr#) { p.val }
      verifyErr(ProtoMissingValErr#) { p.val(true) }
    }
    return p
  }
}

