// RUN: not clang-tidy %s -- -fnot-an-option | FileCheck %s -check-prefix=INVALID-A
// RUN: clang-tidy %s --config="{RemovedArgs: ['-fnot-an-option']}" -- -fnot-an-option
// RUN: clang-tidy %s --config="{RemovedArgs: ['-fnot-another-option', '-fnot-an-option']}" -- -fnot-an-option -fnot-another-option

// INVALID-A: error: unknown argument: '-fnot-an-option' [clang-diagnostic-error]