// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_search_result.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCachedSearchResultCollection on Isar {
  IsarCollection<CachedSearchResult> get cachedSearchResults =>
      this.collection();
}

const CachedSearchResultSchema = CollectionSchema(
  name: r'CachedSearchResult',
  id: -1175092088283525901,
  properties: {
    r'cachedAt': PropertySchema(
      id: 0,
      name: r'cachedAt',
      type: IsarType.dateTime,
    ),
    r'category': PropertySchema(
      id: 1,
      name: r'category',
      type: IsarType.string,
    ),
    r'ingredientIds': PropertySchema(
      id: 2,
      name: r'ingredientIds',
      type: IsarType.stringList,
    ),
    r'ingredientNames': PropertySchema(
      id: 3,
      name: r'ingredientNames',
      type: IsarType.stringList,
    ),
    r'query': PropertySchema(
      id: 4,
      name: r'query',
      type: IsarType.string,
    )
  },
  estimateSize: _cachedSearchResultEstimateSize,
  serialize: _cachedSearchResultSerialize,
  deserialize: _cachedSearchResultDeserialize,
  deserializeProp: _cachedSearchResultDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'query_category': IndexSchema(
      id: -3659620762113639421,
      name: r'query_category',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'query',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'category',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _cachedSearchResultGetId,
  getLinks: _cachedSearchResultGetLinks,
  attach: _cachedSearchResultAttach,
  version: '3.1.0+1',
);

int _cachedSearchResultEstimateSize(
  CachedSearchResult object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.ingredientIds.length * 3;
  {
    for (var i = 0; i < object.ingredientIds.length; i++) {
      final value = object.ingredientIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.ingredientNames.length * 3;
  {
    for (var i = 0; i < object.ingredientNames.length; i++) {
      final value = object.ingredientNames[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.query.length * 3;
  return bytesCount;
}

void _cachedSearchResultSerialize(
  CachedSearchResult object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.cachedAt);
  writer.writeString(offsets[1], object.category);
  writer.writeStringList(offsets[2], object.ingredientIds);
  writer.writeStringList(offsets[3], object.ingredientNames);
  writer.writeString(offsets[4], object.query);
}

CachedSearchResult _cachedSearchResultDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CachedSearchResult();
  object.cachedAt = reader.readDateTime(offsets[0]);
  object.category = reader.readString(offsets[1]);
  object.ingredientIds = reader.readStringList(offsets[2]) ?? [];
  object.ingredientNames = reader.readStringList(offsets[3]) ?? [];
  object.isarId = id;
  object.query = reader.readString(offsets[4]);
  return object;
}

P _cachedSearchResultDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cachedSearchResultGetId(CachedSearchResult object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _cachedSearchResultGetLinks(
    CachedSearchResult object) {
  return [];
}

void _cachedSearchResultAttach(
    IsarCollection<dynamic> col, Id id, CachedSearchResult object) {
  object.isarId = id;
}

extension CachedSearchResultByIndex on IsarCollection<CachedSearchResult> {
  Future<CachedSearchResult?> getByQueryCategory(
      String query, String category) {
    return getByIndex(r'query_category', [query, category]);
  }

  CachedSearchResult? getByQueryCategorySync(String query, String category) {
    return getByIndexSync(r'query_category', [query, category]);
  }

  Future<bool> deleteByQueryCategory(String query, String category) {
    return deleteByIndex(r'query_category', [query, category]);
  }

  bool deleteByQueryCategorySync(String query, String category) {
    return deleteByIndexSync(r'query_category', [query, category]);
  }

  Future<List<CachedSearchResult?>> getAllByQueryCategory(
      List<String> queryValues, List<String> categoryValues) {
    final len = queryValues.length;
    assert(categoryValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([queryValues[i], categoryValues[i]]);
    }

    return getAllByIndex(r'query_category', values);
  }

  List<CachedSearchResult?> getAllByQueryCategorySync(
      List<String> queryValues, List<String> categoryValues) {
    final len = queryValues.length;
    assert(categoryValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([queryValues[i], categoryValues[i]]);
    }

    return getAllByIndexSync(r'query_category', values);
  }

  Future<int> deleteAllByQueryCategory(
      List<String> queryValues, List<String> categoryValues) {
    final len = queryValues.length;
    assert(categoryValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([queryValues[i], categoryValues[i]]);
    }

    return deleteAllByIndex(r'query_category', values);
  }

  int deleteAllByQueryCategorySync(
      List<String> queryValues, List<String> categoryValues) {
    final len = queryValues.length;
    assert(categoryValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([queryValues[i], categoryValues[i]]);
    }

    return deleteAllByIndexSync(r'query_category', values);
  }

  Future<Id> putByQueryCategory(CachedSearchResult object) {
    return putByIndex(r'query_category', object);
  }

  Id putByQueryCategorySync(CachedSearchResult object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'query_category', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByQueryCategory(List<CachedSearchResult> objects) {
    return putAllByIndex(r'query_category', objects);
  }

  List<Id> putAllByQueryCategorySync(List<CachedSearchResult> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'query_category', objects, saveLinks: saveLinks);
  }
}

extension CachedSearchResultQueryWhereSort
    on QueryBuilder<CachedSearchResult, CachedSearchResult, QWhere> {
  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CachedSearchResultQueryWhere
    on QueryBuilder<CachedSearchResult, CachedSearchResult, QWhereClause> {
  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterWhereClause>
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

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterWhereClause>
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

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterWhereClause>
      queryEqualToAnyCategory(String query) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'query_category',
        value: [query],
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterWhereClause>
      queryNotEqualToAnyCategory(String query) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'query_category',
              lower: [],
              upper: [query],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'query_category',
              lower: [query],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'query_category',
              lower: [query],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'query_category',
              lower: [],
              upper: [query],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterWhereClause>
      queryCategoryEqualTo(String query, String category) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'query_category',
        value: [query, category],
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterWhereClause>
      queryEqualToCategoryNotEqualTo(String query, String category) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'query_category',
              lower: [query],
              upper: [query, category],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'query_category',
              lower: [query, category],
              includeLower: false,
              upper: [query],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'query_category',
              lower: [query, category],
              includeLower: false,
              upper: [query],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'query_category',
              lower: [query],
              upper: [query, category],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CachedSearchResultQueryFilter
    on QueryBuilder<CachedSearchResult, CachedSearchResult, QFilterCondition> {
  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      cachedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cachedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      cachedAtGreaterThan(
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

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      cachedAtLessThan(
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

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      cachedAtBetween(
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

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ingredientIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ingredientIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ingredientIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ingredientIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ingredientIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ingredientIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ingredientIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ingredientIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ingredientIds',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ingredientIds',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredientIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredientIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredientIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredientIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredientIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredientIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientNamesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ingredientNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientNamesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ingredientNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientNamesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ingredientNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientNamesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ingredientNames',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientNamesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ingredientNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientNamesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ingredientNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientNamesElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ingredientNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientNamesElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ingredientNames',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientNamesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ingredientNames',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientNamesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ingredientNames',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientNamesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredientNames',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientNamesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredientNames',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientNamesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredientNames',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientNamesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredientNames',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientNamesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredientNames',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      ingredientNamesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredientNames',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      isarIdGreaterThan(
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

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      isarIdLessThan(
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

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      isarIdBetween(
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

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      queryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      queryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      queryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      queryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'query',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      queryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      queryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      queryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      queryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'query',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      queryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'query',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterFilterCondition>
      queryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'query',
        value: '',
      ));
    });
  }
}

extension CachedSearchResultQueryObject
    on QueryBuilder<CachedSearchResult, CachedSearchResult, QFilterCondition> {}

extension CachedSearchResultQueryLinks
    on QueryBuilder<CachedSearchResult, CachedSearchResult, QFilterCondition> {}

extension CachedSearchResultQuerySortBy
    on QueryBuilder<CachedSearchResult, CachedSearchResult, QSortBy> {
  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterSortBy>
      sortByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterSortBy>
      sortByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterSortBy>
      sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterSortBy>
      sortByQuery() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'query', Sort.asc);
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterSortBy>
      sortByQueryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'query', Sort.desc);
    });
  }
}

extension CachedSearchResultQuerySortThenBy
    on QueryBuilder<CachedSearchResult, CachedSearchResult, QSortThenBy> {
  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterSortBy>
      thenByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterSortBy>
      thenByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterSortBy>
      thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterSortBy>
      thenByQuery() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'query', Sort.asc);
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QAfterSortBy>
      thenByQueryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'query', Sort.desc);
    });
  }
}

extension CachedSearchResultQueryWhereDistinct
    on QueryBuilder<CachedSearchResult, CachedSearchResult, QDistinct> {
  QueryBuilder<CachedSearchResult, CachedSearchResult, QDistinct>
      distinctByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAt');
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QDistinct>
      distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QDistinct>
      distinctByIngredientIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ingredientIds');
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QDistinct>
      distinctByIngredientNames() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ingredientNames');
    });
  }

  QueryBuilder<CachedSearchResult, CachedSearchResult, QDistinct>
      distinctByQuery({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'query', caseSensitive: caseSensitive);
    });
  }
}

extension CachedSearchResultQueryProperty
    on QueryBuilder<CachedSearchResult, CachedSearchResult, QQueryProperty> {
  QueryBuilder<CachedSearchResult, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<CachedSearchResult, DateTime, QQueryOperations>
      cachedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAt');
    });
  }

  QueryBuilder<CachedSearchResult, String, QQueryOperations>
      categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<CachedSearchResult, List<String>, QQueryOperations>
      ingredientIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ingredientIds');
    });
  }

  QueryBuilder<CachedSearchResult, List<String>, QQueryOperations>
      ingredientNamesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ingredientNames');
    });
  }

  QueryBuilder<CachedSearchResult, String, QQueryOperations> queryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'query');
    });
  }
}
