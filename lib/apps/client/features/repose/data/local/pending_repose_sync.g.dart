// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_repose_sync.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPendingReposeSyncCollection on Isar {
  IsarCollection<PendingReposeSync> get pendingReposeSyncs => this.collection();
}

const PendingReposeSyncSchema = CollectionSchema(
  name: r'PendingReposeSync',
  id: -4751510904360366602,
  properties: {
    r'muscleGroup': PropertySchema(
      id: 0,
      name: r'muscleGroup',
      type: IsarType.string,
    ),
    r'operationType': PropertySchema(
      id: 1,
      name: r'operationType',
      type: IsarType.string,
    ),
    r'percentage': PropertySchema(
      id: 2,
      name: r'percentage',
      type: IsarType.long,
    ),
    r'retryCount': PropertySchema(
      id: 3,
      name: r'retryCount',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 4,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _pendingReposeSyncEstimateSize,
  serialize: _pendingReposeSyncSerialize,
  deserialize: _pendingReposeSyncDeserialize,
  deserializeProp: _pendingReposeSyncDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'muscleGroup': IndexSchema(
      id: 9219781228009971960,
      name: r'muscleGroup',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'muscleGroup',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _pendingReposeSyncGetId,
  getLinks: _pendingReposeSyncGetLinks,
  attach: _pendingReposeSyncAttach,
  version: '3.1.0+1',
);

int _pendingReposeSyncEstimateSize(
  PendingReposeSync object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.muscleGroup.length * 3;
  bytesCount += 3 + object.operationType.length * 3;
  return bytesCount;
}

void _pendingReposeSyncSerialize(
  PendingReposeSync object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.muscleGroup);
  writer.writeString(offsets[1], object.operationType);
  writer.writeLong(offsets[2], object.percentage);
  writer.writeLong(offsets[3], object.retryCount);
  writer.writeDateTime(offsets[4], object.updatedAt);
}

PendingReposeSync _pendingReposeSyncDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PendingReposeSync();
  object.isarId = id;
  object.muscleGroup = reader.readString(offsets[0]);
  object.operationType = reader.readString(offsets[1]);
  object.percentage = reader.readLongOrNull(offsets[2]);
  object.retryCount = reader.readLong(offsets[3]);
  object.updatedAt = reader.readDateTime(offsets[4]);
  return object;
}

P _pendingReposeSyncDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pendingReposeSyncGetId(PendingReposeSync object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _pendingReposeSyncGetLinks(
    PendingReposeSync object) {
  return [];
}

void _pendingReposeSyncAttach(
    IsarCollection<dynamic> col, Id id, PendingReposeSync object) {
  object.isarId = id;
}

extension PendingReposeSyncByIndex on IsarCollection<PendingReposeSync> {
  Future<PendingReposeSync?> getByMuscleGroup(String muscleGroup) {
    return getByIndex(r'muscleGroup', [muscleGroup]);
  }

  PendingReposeSync? getByMuscleGroupSync(String muscleGroup) {
    return getByIndexSync(r'muscleGroup', [muscleGroup]);
  }

  Future<bool> deleteByMuscleGroup(String muscleGroup) {
    return deleteByIndex(r'muscleGroup', [muscleGroup]);
  }

  bool deleteByMuscleGroupSync(String muscleGroup) {
    return deleteByIndexSync(r'muscleGroup', [muscleGroup]);
  }

  Future<List<PendingReposeSync?>> getAllByMuscleGroup(
      List<String> muscleGroupValues) {
    final values = muscleGroupValues.map((e) => [e]).toList();
    return getAllByIndex(r'muscleGroup', values);
  }

  List<PendingReposeSync?> getAllByMuscleGroupSync(
      List<String> muscleGroupValues) {
    final values = muscleGroupValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'muscleGroup', values);
  }

  Future<int> deleteAllByMuscleGroup(List<String> muscleGroupValues) {
    final values = muscleGroupValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'muscleGroup', values);
  }

  int deleteAllByMuscleGroupSync(List<String> muscleGroupValues) {
    final values = muscleGroupValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'muscleGroup', values);
  }

  Future<Id> putByMuscleGroup(PendingReposeSync object) {
    return putByIndex(r'muscleGroup', object);
  }

  Id putByMuscleGroupSync(PendingReposeSync object, {bool saveLinks = true}) {
    return putByIndexSync(r'muscleGroup', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMuscleGroup(List<PendingReposeSync> objects) {
    return putAllByIndex(r'muscleGroup', objects);
  }

  List<Id> putAllByMuscleGroupSync(List<PendingReposeSync> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'muscleGroup', objects, saveLinks: saveLinks);
  }
}

extension PendingReposeSyncQueryWhereSort
    on QueryBuilder<PendingReposeSync, PendingReposeSync, QWhere> {
  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PendingReposeSyncQueryWhere
    on QueryBuilder<PendingReposeSync, PendingReposeSync, QWhereClause> {
  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterWhereClause>
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

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterWhereClause>
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

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterWhereClause>
      muscleGroupEqualTo(String muscleGroup) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'muscleGroup',
        value: [muscleGroup],
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterWhereClause>
      muscleGroupNotEqualTo(String muscleGroup) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'muscleGroup',
              lower: [],
              upper: [muscleGroup],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'muscleGroup',
              lower: [muscleGroup],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'muscleGroup',
              lower: [muscleGroup],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'muscleGroup',
              lower: [],
              upper: [muscleGroup],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PendingReposeSyncQueryFilter
    on QueryBuilder<PendingReposeSync, PendingReposeSync, QFilterCondition> {
  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
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

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
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

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
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

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      muscleGroupEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'muscleGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      muscleGroupGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'muscleGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      muscleGroupLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'muscleGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      muscleGroupBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'muscleGroup',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      muscleGroupStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'muscleGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      muscleGroupEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'muscleGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      muscleGroupContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'muscleGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      muscleGroupMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'muscleGroup',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      muscleGroupIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'muscleGroup',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      muscleGroupIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'muscleGroup',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      operationTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'operationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      operationTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'operationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      operationTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'operationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      operationTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'operationType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      operationTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'operationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      operationTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'operationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      operationTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'operationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      operationTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'operationType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      operationTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'operationType',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      operationTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'operationType',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      percentageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'percentage',
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      percentageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'percentage',
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      percentageEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'percentage',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      percentageGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'percentage',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      percentageLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'percentage',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      percentageBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'percentage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      retryCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      retryCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      retryCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      retryCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'retryCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PendingReposeSyncQueryObject
    on QueryBuilder<PendingReposeSync, PendingReposeSync, QFilterCondition> {}

extension PendingReposeSyncQueryLinks
    on QueryBuilder<PendingReposeSync, PendingReposeSync, QFilterCondition> {}

extension PendingReposeSyncQuerySortBy
    on QueryBuilder<PendingReposeSync, PendingReposeSync, QSortBy> {
  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      sortByMuscleGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.asc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      sortByMuscleGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.desc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      sortByOperationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationType', Sort.asc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      sortByOperationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationType', Sort.desc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      sortByPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentage', Sort.asc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      sortByPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentage', Sort.desc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      sortByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      sortByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PendingReposeSyncQuerySortThenBy
    on QueryBuilder<PendingReposeSync, PendingReposeSync, QSortThenBy> {
  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      thenByMuscleGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.asc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      thenByMuscleGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.desc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      thenByOperationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationType', Sort.asc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      thenByOperationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationType', Sort.desc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      thenByPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentage', Sort.asc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      thenByPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentage', Sort.desc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      thenByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      thenByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PendingReposeSyncQueryWhereDistinct
    on QueryBuilder<PendingReposeSync, PendingReposeSync, QDistinct> {
  QueryBuilder<PendingReposeSync, PendingReposeSync, QDistinct>
      distinctByMuscleGroup({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'muscleGroup', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QDistinct>
      distinctByOperationType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'operationType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QDistinct>
      distinctByPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'percentage');
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QDistinct>
      distinctByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retryCount');
    });
  }

  QueryBuilder<PendingReposeSync, PendingReposeSync, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension PendingReposeSyncQueryProperty
    on QueryBuilder<PendingReposeSync, PendingReposeSync, QQueryProperty> {
  QueryBuilder<PendingReposeSync, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<PendingReposeSync, String, QQueryOperations>
      muscleGroupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'muscleGroup');
    });
  }

  QueryBuilder<PendingReposeSync, String, QQueryOperations>
      operationTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'operationType');
    });
  }

  QueryBuilder<PendingReposeSync, int?, QQueryOperations> percentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'percentage');
    });
  }

  QueryBuilder<PendingReposeSync, int, QQueryOperations> retryCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retryCount');
    });
  }

  QueryBuilder<PendingReposeSync, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
