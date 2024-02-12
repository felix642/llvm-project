//===--- ArraySizeCheck.cpp - clang-tidy ----------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "ArraySizeCheck.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/ExprCXX.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"
#include "clang/ASTMatchers/ASTMatchers.h"

using namespace clang::ast_matchers;

namespace clang::tidy::bugprone {

void ArraySizeCheck::registerMatchers(MatchFinder *Finder) {
 Finder->addMatcher(
      cxxMemberCallExpr(
          callee(cxxMethodDecl(hasName("empty"))),
          on(expr(hasType(hasUnqualifiedDesugaredType(
                  recordType(hasDeclaration(recordDecl(hasName("::std::array")))))))))
          .bind("empty"),
      this);
}

void ArraySizeCheck::check(const MatchFinder::MatchResult &Result) {
  const auto *MatchedDecl = Result.Nodes.getNodeAs<CXXMemberCallExpr>("empty");
  diag(MatchedDecl->getBeginLoc(), "Calling .empty() on std::array is prohibited");
  }

} // namespace clang::tidy::bugprone
