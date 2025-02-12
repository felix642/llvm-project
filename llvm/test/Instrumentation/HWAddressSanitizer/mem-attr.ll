; Test that HWASan remove writeonly and memory(*) attributes from instrumented functions.
; RUN: opt -S -passes=hwasan %s | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-android30"

; CHECK: define dso_local void @test_writeonly(ptr noundef captures(none) %p) local_unnamed_addr #0
define dso_local void @test_writeonly(ptr noundef writeonly captures(none) %p) local_unnamed_addr #0 {
entry:
  store i32 42, ptr %p, align 4
  ret void
}

; CHECK: define dso_local void @test_readonly(ptr noundef readonly captures(none) %p) local_unnamed_addr #0
define dso_local void @test_readonly(ptr noundef readonly captures(none) %p) local_unnamed_addr #1 {
entry:
  store i32 42, ptr %p, align 4
  ret void
}

; CHECK: attributes #0 = { nobuiltin sanitize_hwaddress uwtable }
attributes #0 = { sanitize_hwaddress memory(argmem: write) uwtable }
attributes #1 = { sanitize_hwaddress memory(argmem: read) uwtable }
