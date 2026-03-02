// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_exercise_search.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCachedExerciseSearchCollection on Isar {
  IsarCollection<CachedExerciseSearch> get cachedExerciseSearchs =>
      this.collection();
}

const CachedExerciseSearchSchema = CollectionSchema(
  name: r'CachedExerciseSearch',
  id: 2266359399747757061,
  properties: {
    r'cachedAt': PropertySchema(
      id: 0,
      name: r'cachedAt',
      type: IsarType.dateTime,
    ),
    r'exerciseIds': PropertySchema(
      id: 1,
      name: r'exerciseIds',
      type: IsarType.stringList,
    ),
    r'muscleFilter': PropertySchema(
      id: 2,
      name: r'muscleFilter',
      type: IsarType.string,
    ),
    r'searchQuery': PropertySchema(
      id: 3,
      name: r'searchQuery',
      type: IsarType.string,
    ),
    r'totalCount': PropertySchema(
      id: 4,
      name: r'totalCount',
      type: IsarType.long,
    )
  },
  estimateSize: _cachedExerciseSearchEstimateSize,
  serialize: _cachedExerciseSearchSerialize,
  deserialize: _cachedExerciseSearchDeserialize,
  deserializeProp: _cachedExerciseSearchDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'searchQuery_muscleFilter': IndexSchema(
      id: 4625786457020464306,
      name: r'searchQuery_muscleFilter',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'searchQuery',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'muscleFilter',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _cachedExerciseSearchGetId,
  getLinks: _cachedExerciseSearchGetLinks,
  attach: _cachedExerciseSearchAttach,
  version: '3.1.0+1',
);

int _cachedExerciseSearchEstimateSize(
  CachedExerciseSearch object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.exerciseIds.length * 3;
  {
    for (var i = 0; i < object.exerciseIds.length; i++) {
      final value = object.exerciseIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.muscleFilter.length * 3;
  bytesCount += 3 + object.searchQuery.length * 3;
  return bytesCount;
}

void _cachedExerciseSearchSerialize(
  CachedExerciseSearch object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.cachedAt);
  writer.writeStringList(offsets[1], object.exerciseIds);
  writer.writeString(offsets[2], object.muscleFilter);
  writer.writeString(offsets[3], object.searchQuery);
  writer.writeLong(offsets[4], object.totalCount);
}

CachedExerciseSearch _cachedExerciseSearchDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CachedExerciseSearch();
  object.cachedAt = reader.readDateTime(offsets[0]);
  object.exerciseIds = reader.readStringList(offsets[1]) ?? [];
  object.isarId = id;
  object.muscleFilter = reader.readString(offsets[2]);
  object.searchQuery = reader.readString(offsets[3]);
  object.totalCount = reader.readLong(offsets[4]);
  return object;
}

P _cachedExerciseSearchDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cachedExerciseSearchGetId(CachedExerciseSearch object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _cachedExerciseSearchGetLinks(
    CachedExerciseSearch object) {
  return [];
}

void _cachedExerciseSearchAttach(
    IsarCollection<dynamic> col, Id id, CachedExerciseSearch object) {
  object.isarId = id;
}

extension CachedExerciseSearchByIndex on IsarCollection<CachedExerciseSearch> {
  Future<CachedExerciseSearch?> getBySearchQueryMuscleFilter(
      String searchQuery, String muscleFilter) {
    return getByIndex(r'searchQuery_muscleFilter', [searchQuery, muscleFilter]);
  }

  CachedExerciseSearch? getBySearchQueryMuscleFilterSync(
      String searchQuery, String muscleFilter) {
    return getByIndexSync(
        r'searchQuery_muscleFilter', [searchQuery, muscleFilter]);
  }

  Future<bool> deleteBySearchQueryMuscleFilter(
      String searchQuery, String muscleFilter) {
    return deleteByIndex(
        r'searchQuery_muscleFilter', [searchQuery, muscleFilter]);
  }

  bool deleteBySearchQueryMuscleFilterSync(
      String searchQuery, String muscleFilter) {
    return deleteByIndexSync(
        r'searchQuery_muscleFilter', [searchQuery, muscleFilter]);
  }

  Future<List<CachedExerciseSearch?>> getAllBySearchQueryMuscleFilter(
      List<String> searchQueryValues, List<String> muscleFilterValues) {
    final len = searchQueryValues.length;
    assert(muscleFilterValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([searchQueryValues[i], muscleFilterValues[i]]);
    }

    return getAllByIndex(r'searchQuery_muscleFilter', values);
  }

  List<CachedExerciseSearch?> getAllBySearchQueryMuscleFilterSync(
      List<String> searchQueryValues, List<String> muscleFilterValues) {
    final len = searchQueryValues.length;
    assert(muscleFilterValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([searchQueryValues[i], muscleFilterValues[i]]);
    }

    return getAllByIndexSync(r'searchQuery_muscleFilter', values);
  }

  Future<int> deleteAllBySearchQueryMuscleFilter(
      List<String> searchQueryValues, List<String> muscleFilterValues) {
    final len = searchQueryValues.length;
    assert(muscleFilterValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([searchQueryValues[i], muscleFilterValues[i]]);
    }

    return deleteAllByIndex(r'searchQuery_muscleFilter', values);
  }

  int deleteAllBySearchQueryMuscleFilterSync(
      List<String> searchQueryValues, List<String> muscleFilterValues) {
    final len = searchQueryValues.length;
    assert(muscleFilterValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([searchQueryValues[i], muscleFilterValues[i]]);
    }

    return deleteAllByIndexSync(r'searchQuery_muscleFilter', values);
  }

  Future<Id> putBySearchQueryMuscleFilter(CachedExerciseSearch object) {
    return putByIndex(r'searchQuery_muscleFilter', object);
  }

  Id putBySearchQueryMuscleFilterSync(CachedExerciseSearch object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'searchQuery_muscleFilter', object,
        saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySearchQueryMuscleFilter(
      List<CachedExerciseSearch> objects) {
    return putAllByIndex(r'searchQuery_muscleFilter', objects);
  }

  List<Id> putAllBySearchQueryMuscleFilterSync(
      List<CachedExerciseSearch> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'searchQuery_muscleFilter', objects,
        saveLinks: saveLinks);
  }
}

extension CachedExerciseSearchQueryWhereSort
    on QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QWhere> {
  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CachedExerciseSearchQueryWhere
    on QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QWhereClause> {
  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterWhereClause>
      searchQueryEqualToAnyMuscleFilter(String searchQuery) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'searchQuery_muscleFilter',
        value: [searchQuery],
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterWhereClause>
      searchQueryNotEqualToAnyMuscleFilter(String searchQuery) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchQuery_muscleFilter',
              lower: [],
              upper: [searchQuery],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchQuery_muscleFilter',
              lower: [searchQuery],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchQuery_muscleFilter',
              lower: [searchQuery],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchQuery_muscleFilter',
              lower: [],
              upper: [searchQuery],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterWhereClause>
      searchQueryMuscleFilterEqualTo(String searchQuery, String muscleFilter) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'searchQuery_muscleFilter',
        value: [searchQuery, muscleFilter],
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterWhereClause>
      searchQueryEqualToMuscleFilterNotEqualTo(
          String searchQuery, String muscleFilter) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchQuery_muscleFilter',
              lower: [searchQuery],
              upper: [searchQuery, muscleFilter],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchQuery_muscleFilter',
              lower: [searchQuery, muscleFilter],
              includeLower: false,
              upper: [searchQuery],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchQuery_muscleFilter',
              lower: [searchQuery, muscleFilter],
              includeLower: false,
              upper: [searchQuery],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchQuery_muscleFilter',
              lower: [searchQuery],
              upper: [searchQuery, muscleFilter],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CachedExerciseSearchQueryFilter on QueryBuilder<CachedExerciseSearch,
    CachedExerciseSearch, QFilterCondition> {
  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> cachedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cachedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> cachedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cachedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> cachedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cachedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> cachedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cachedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> exerciseIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> exerciseIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> exerciseIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> exerciseIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> exerciseIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exerciseIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> exerciseIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exerciseIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
          QAfterFilterCondition>
      exerciseIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exerciseIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
          QAfterFilterCondition>
      exerciseIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exerciseIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> exerciseIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseIds',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> exerciseIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exerciseIds',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> exerciseIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exerciseIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> exerciseIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exerciseIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> exerciseIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exerciseIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> exerciseIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exerciseIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> exerciseIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exerciseIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> exerciseIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exerciseIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> muscleFilterEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'muscleFilter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> muscleFilterGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'muscleFilter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> muscleFilterLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'muscleFilter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> muscleFilterBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'muscleFilter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> muscleFilterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'muscleFilter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> muscleFilterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'muscleFilter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
          QAfterFilterCondition>
      muscleFilterContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'muscleFilter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
          QAfterFilterCondition>
      muscleFilterMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'muscleFilter',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> muscleFilterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'muscleFilter',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> muscleFilterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'muscleFilter',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> searchQueryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'searchQuery',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> searchQueryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'searchQuery',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> searchQueryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'searchQuery',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> searchQueryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'searchQuery',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> searchQueryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'searchQuery',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> searchQueryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'searchQuery',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
          QAfterFilterCondition>
      searchQueryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'searchQuery',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
          QAfterFilterCondition>
      searchQueryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'searchQuery',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> searchQueryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'searchQuery',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> searchQueryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'searchQuery',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> totalCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> totalCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> totalCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch,
      QAfterFilterCondition> totalCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CachedExerciseSearchQueryObject on QueryBuilder<CachedExerciseSearch,
    CachedExerciseSearch, QFilterCondition> {}

extension CachedExerciseSearchQueryLinks on QueryBuilder<CachedExerciseSearch,
    CachedExerciseSearch, QFilterCondition> {}

extension CachedExerciseSearchQuerySortBy
    on QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QSortBy> {
  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      sortByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      sortByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      sortByMuscleFilter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleFilter', Sort.asc);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      sortByMuscleFilterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleFilter', Sort.desc);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      sortBySearchQuery() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchQuery', Sort.asc);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      sortBySearchQueryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchQuery', Sort.desc);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      sortByTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.asc);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      sortByTotalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.desc);
    });
  }
}

extension CachedExerciseSearchQuerySortThenBy
    on QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QSortThenBy> {
  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      thenByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      thenByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      thenByMuscleFilter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleFilter', Sort.asc);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      thenByMuscleFilterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleFilter', Sort.desc);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      thenBySearchQuery() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchQuery', Sort.asc);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      thenBySearchQueryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchQuery', Sort.desc);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      thenByTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.asc);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QAfterSortBy>
      thenByTotalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.desc);
    });
  }
}

extension CachedExerciseSearchQueryWhereDistinct
    on QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QDistinct> {
  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QDistinct>
      distinctByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAt');
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QDistinct>
      distinctByExerciseIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseIds');
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QDistinct>
      distinctByMuscleFilter({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'muscleFilter', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QDistinct>
      distinctBySearchQuery({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'searchQuery', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedExerciseSearch, CachedExerciseSearch, QDistinct>
      distinctByTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCount');
    });
  }
}

extension CachedExerciseSearchQueryProperty on QueryBuilder<
    CachedExerciseSearch, CachedExerciseSearch, QQueryProperty> {
  QueryBuilder<CachedExerciseSearch, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<CachedExerciseSearch, DateTime, QQueryOperations>
      cachedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAt');
    });
  }

  QueryBuilder<CachedExerciseSearch, List<String>, QQueryOperations>
      exerciseIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseIds');
    });
  }

  QueryBuilder<CachedExerciseSearch, String, QQueryOperations>
      muscleFilterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'muscleFilter');
    });
  }

  QueryBuilder<CachedExerciseSearch, String, QQueryOperations>
      searchQueryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'searchQuery');
    });
  }

  QueryBuilder<CachedExerciseSearch, int, QQueryOperations>
      totalCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCount');
    });
  }
}
