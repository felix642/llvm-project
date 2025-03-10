//===-- examples/ExternalHelloWorld/external-hello.cpp ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "flang/Runtime/io-api.h"
#include "flang/Runtime/main.h"
#include "flang/Runtime/stop.h"
#include <cstring>
#include <limits>

using namespace Fortran::runtime::io;

void output1() {
  auto io{IONAME(BeginExternalListOutput)()};
  const char str[]{"Hello, world!"};
  IONAME(OutputAscii)(io, str, std::strlen(str));
  IONAME(OutputInteger64)(io, 678);
  IONAME(OutputReal64)(io, 0.0);
  IONAME(OutputReal64)(io, 2.0 / 3.0);
  IONAME(OutputReal64)(io, 1.0e99);
  IONAME(OutputReal64)(io, std::numeric_limits<double>::infinity());
  IONAME(OutputReal64)(io, -std::numeric_limits<double>::infinity());
  IONAME(OutputReal64)(io, std::numeric_limits<double>::quiet_NaN());
  IONAME(OutputComplex64)(io, 123.0, -234.0);
  IONAME(OutputLogical)(io, false);
  IONAME(OutputLogical)(io, true);
  IONAME(EndIoStatement)(io);
}

void input1() {
  auto io{IONAME(BeginExternalListOutput)()};
  const char prompt[]{"Enter an integer value:"};
  IONAME(OutputAscii)(io, prompt, std::strlen(prompt));
  IONAME(EndIoStatement)(io);

  io = IONAME(BeginExternalListInput)();
  std::int64_t n{-666};
  IONAME(InputInteger)(io, n);
  IONAME(EndIoStatement)(io);

  io = IONAME(BeginExternalListOutput)();
  const char str[]{"Result:"};
  IONAME(OutputAscii)(io, str, std::strlen(str));
  IONAME(OutputInteger64)(io, n);
  IONAME(EndIoStatement)(io);
}

int main(int argc, const char *argv[], const char *envp[]) {
  RTNAME(ProgramStart)(argc, argv, envp, nullptr);
  output1();
  input1();
  RTNAME(PauseStatement)();
  RTNAME(ProgramEndStatement)();
  return 0;
}
