// Copyright (c) 2012, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Author: Paul Brauner (polux@google.com)

library common;

import 'package:enumerators/enumerators.dart';
import 'package:test/test.dart';

Enumeration listToEnum(List<List> list) {
  return new Enumeration(
      new Thunk(
          () => _listToLazyList(list.map(_listToFinite).toList())));
}

Finite _listToFinite(List list) {
  var result = new Finite.empty();
  for (final e in list) {
    result = result + new Finite.singleton(e);
  }
  return result;
}

LazyList _listToLazyList(List list) {
  LazyList aux(int i) =>
    (i >= list.length)
        ? new LazyList.empty()
        : new LazyList.cons(list[i], () => aux(i+1));
  return aux(0);
}


void checkPrefixEquals(Enumeration enumeration, List<List> prefix) {
  final enumPrefix =
      enumeration.parts.take(prefix.length).map(_finiteToList).toList();
  expect(enumPrefix, equals(prefix));
}

void checkEquals(Enumeration enumeration, List<List> list) {
  final expanded = enumeration.parts.map(_finiteToList).toList();
  expect(expanded, equals(list));
}

void checkSame(Enumeration actual, Enumeration expected) {
  final expanded1 = actual.parts.map(_finiteToList).toList();
  final expanded2 = expected.parts.map(_finiteToList).toList();
  expect(expanded1, equals(expanded2));
}

List _finiteToList(Finite finite) => finite.toLazyList().toList();
