// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_sync_operation.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPendingSyncOperationCollection on Isar {
  IsarCollection<PendingSyncOperation> get pendingSyncOperations =>
      this.collection();
}

const PendingSyncOperationSchema = CollectionSchema(
  name: r'PendingSyncOperation',
  id: -5164231583145156559,
  properties: {
    r'batchSetIds': PropertySchema(
      id: 0,
      name: r'batchSetIds',
      type: IsarType.string,
    ),
    r'distance': PropertySchema(
      id: 1,
      name: r'distance',
      type: IsarType.double,
    ),
    r'isCompleted': PropertySchema(
      id: 2,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'minutes': PropertySchema(
      id: 3,
      name: r'minutes',
      type: IsarType.long,
    ),
    r'operationType': PropertySchema(
      id: 4,
      name: r'operationType',
      type: IsarType.string,
    ),
    r'repetitions': PropertySchema(
      id: 5,
      name: r'repetitions',
      type: IsarType.long,
    ),
    r'retryCount': PropertySchema(
      id: 6,
      name: r'retryCount',
      type: IsarType.long,
    ),
    r'scheduleId': PropertySchema(
      id: 7,
      name: r'scheduleId',
      type: IsarType.string,
    ),
    r'seconds': PropertySchema(
      id: 8,
      name: r'seconds',
      type: IsarType.long,
    ),
    r'sessionDateStr': PropertySchema(
      id: 9,
      name: r'sessionDateStr',
      type: IsarType.string,
    ),
    r'setId': PropertySchema(
      id: 10,
      name: r'setId',
      type: IsarType.string,
    ),
    r'setNumber': PropertySchema(
      id: 11,
      name: r'setNumber',
      type: IsarType.long,
    ),
    r'setType': PropertySchema(
      id: 12,
      name: r'setType',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 13,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'weight': PropertySchema(
      id: 14,
      name: r'weight',
      type: IsarType.double,
    )
  },
  estimateSize: _pendingSyncOperationEstimateSize,
  serialize: _pendingSyncOperationSerialize,
  deserialize: _pendingSyncOperationDeserialize,
  deserializeProp: _pendingSyncOperationDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'setId': IndexSchema(
      id: 2535400842924879452,
      name: r'setId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'setId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _pendingSyncOperationGetId,
  getLinks: _pendingSyncOperationGetLinks,
  attach: _pendingSyncOperationAttach,
  version: '3.1.0+1',
);

int _pendingSyncOperationEstimateSize(
  PendingSyncOperation object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.batchSetIds;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.operationType.length * 3;
  {
    final value = object.scheduleId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sessionDateStr;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.setId.length * 3;
  {
    final value = object.setType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _pendingSyncOperationSerialize(
  PendingSyncOperation object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.batchSetIds);
  writer.writeDouble(offsets[1], object.distance);
  writer.writeBool(offsets[2], object.isCompleted);
  writer.writeLong(offsets[3], object.minutes);
  writer.writeString(offsets[4], object.operationType);
  writer.writeLong(offsets[5], object.repetitions);
  writer.writeLong(offsets[6], object.retryCount);
  writer.writeString(offsets[7], object.scheduleId);
  writer.writeLong(offsets[8], object.seconds);
  writer.writeString(offsets[9], object.sessionDateStr);
  writer.writeString(offsets[10], object.setId);
  writer.writeLong(offsets[11], object.setNumber);
  writer.writeString(offsets[12], object.setType);
  writer.writeDateTime(offsets[13], object.updatedAt);
  writer.writeDouble(offsets[14], object.weight);
}

PendingSyncOperation _pendingSyncOperationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PendingSyncOperation();
  object.batchSetIds = reader.readStringOrNull(offsets[0]);
  object.distance = reader.readDoubleOrNull(offsets[1]);
  object.isCompleted = reader.readBoolOrNull(offsets[2]);
  object.isarId = id;
  object.minutes = reader.readLongOrNull(offsets[3]);
  object.operationType = reader.readString(offsets[4]);
  object.repetitions = reader.readLongOrNull(offsets[5]);
  object.retryCount = reader.readLong(offsets[6]);
  object.scheduleId = reader.readStringOrNull(offsets[7]);
  object.seconds = reader.readLongOrNull(offsets[8]);
  object.sessionDateStr = reader.readStringOrNull(offsets[9]);
  object.setId = reader.readString(offsets[10]);
  object.setNumber = reader.readLongOrNull(offsets[11]);
  object.setType = reader.readStringOrNull(offsets[12]);
  object.updatedAt = reader.readDateTime(offsets[13]);
  object.weight = reader.readDoubleOrNull(offsets[14]);
  return object;
}

P _pendingSyncOperationDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    case 14:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pendingSyncOperationGetId(PendingSyncOperation object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _pendingSyncOperationGetLinks(
    PendingSyncOperation object) {
  return [];
}

void _pendingSyncOperationAttach(
    IsarCollection<dynamic> col, Id id, PendingSyncOperation object) {
  object.isarId = id;
}

extension PendingSyncOperationByIndex on IsarCollection<PendingSyncOperation> {
  Future<PendingSyncOperation?> getBySetId(String setId) {
    return getByIndex(r'setId', [setId]);
  }

  PendingSyncOperation? getBySetIdSync(String setId) {
    return getByIndexSync(r'setId', [setId]);
  }

  Future<bool> deleteBySetId(String setId) {
    return deleteByIndex(r'setId', [setId]);
  }

  bool deleteBySetIdSync(String setId) {
    return deleteByIndexSync(r'setId', [setId]);
  }

  Future<List<PendingSyncOperation?>> getAllBySetId(List<String> setIdValues) {
    final values = setIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'setId', values);
  }

  List<PendingSyncOperation?> getAllBySetIdSync(List<String> setIdValues) {
    final values = setIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'setId', values);
  }

  Future<int> deleteAllBySetId(List<String> setIdValues) {
    final values = setIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'setId', values);
  }

  int deleteAllBySetIdSync(List<String> setIdValues) {
    final values = setIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'setId', values);
  }

  Future<Id> putBySetId(PendingSyncOperation object) {
    return putByIndex(r'setId', object);
  }

  Id putBySetIdSync(PendingSyncOperation object, {bool saveLinks = true}) {
    return putByIndexSync(r'setId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySetId(List<PendingSyncOperation> objects) {
    return putAllByIndex(r'setId', objects);
  }

  List<Id> putAllBySetIdSync(List<PendingSyncOperation> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'setId', objects, saveLinks: saveLinks);
  }
}

extension PendingSyncOperationQueryWhereSort
    on QueryBuilder<PendingSyncOperation, PendingSyncOperation, QWhere> {
  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PendingSyncOperationQueryWhere
    on QueryBuilder<PendingSyncOperation, PendingSyncOperation, QWhereClause> {
  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterWhereClause>
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

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterWhereClause>
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

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterWhereClause>
      setIdEqualTo(String setId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'setId',
        value: [setId],
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterWhereClause>
      setIdNotEqualTo(String setId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'setId',
              lower: [],
              upper: [setId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'setId',
              lower: [setId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'setId',
              lower: [setId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'setId',
              lower: [],
              upper: [setId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PendingSyncOperationQueryFilter on QueryBuilder<PendingSyncOperation,
    PendingSyncOperation, QFilterCondition> {
  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> batchSetIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'batchSetIds',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> batchSetIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'batchSetIds',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> batchSetIdsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'batchSetIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> batchSetIdsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'batchSetIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> batchSetIdsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'batchSetIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> batchSetIdsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'batchSetIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> batchSetIdsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'batchSetIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> batchSetIdsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'batchSetIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
          QAfterFilterCondition>
      batchSetIdsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'batchSetIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
          QAfterFilterCondition>
      batchSetIdsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'batchSetIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> batchSetIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'batchSetIds',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> batchSetIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'batchSetIds',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> distanceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'distance',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> distanceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'distance',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> distanceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'distance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> distanceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'distance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> distanceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'distance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> distanceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'distance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> isCompletedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isCompleted',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> isCompletedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isCompleted',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> isCompletedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
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

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
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

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
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

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> minutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'minutes',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> minutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'minutes',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> minutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minutes',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> minutesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minutes',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> minutesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minutes',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> minutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> operationTypeEqualTo(
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

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> operationTypeGreaterThan(
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

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> operationTypeLessThan(
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

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> operationTypeBetween(
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

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> operationTypeStartsWith(
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

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> operationTypeEndsWith(
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

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
          QAfterFilterCondition>
      operationTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'operationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
          QAfterFilterCondition>
      operationTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'operationType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> operationTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'operationType',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> operationTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'operationType',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> repetitionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'repetitions',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> repetitionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'repetitions',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> repetitionsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repetitions',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> repetitionsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repetitions',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> repetitionsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repetitions',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> repetitionsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repetitions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> retryCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> retryCountGreaterThan(
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

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> retryCountLessThan(
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

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> retryCountBetween(
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

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> scheduleIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'scheduleId',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> scheduleIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'scheduleId',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> scheduleIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> scheduleIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> scheduleIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> scheduleIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduleId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> scheduleIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> scheduleIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
          QAfterFilterCondition>
      scheduleIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
          QAfterFilterCondition>
      scheduleIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'scheduleId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> scheduleIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduleId',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> scheduleIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'scheduleId',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> secondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'seconds',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> secondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'seconds',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> secondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> secondsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> secondsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> secondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> sessionDateStrIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sessionDateStr',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> sessionDateStrIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sessionDateStr',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> sessionDateStrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> sessionDateStrGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> sessionDateStrLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> sessionDateStrBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionDateStr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> sessionDateStrStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sessionDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> sessionDateStrEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sessionDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
          QAfterFilterCondition>
      sessionDateStrContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sessionDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
          QAfterFilterCondition>
      sessionDateStrMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sessionDateStr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> sessionDateStrIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionDateStr',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> sessionDateStrIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sessionDateStr',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'setId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'setId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'setId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'setId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'setId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
          QAfterFilterCondition>
      setIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'setId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
          QAfterFilterCondition>
      setIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'setId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setId',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'setId',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'setNumber',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'setNumber',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setNumberEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setNumberGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'setNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setNumberLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'setNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setNumberBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'setNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'setType',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'setType',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'setType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'setType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'setType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'setType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'setType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
          QAfterFilterCondition>
      setTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'setType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
          QAfterFilterCondition>
      setTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'setType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setType',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> setTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'setType',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> weightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weight',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> weightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weight',
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> weightEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> weightGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> weightLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation,
      QAfterFilterCondition> weightBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension PendingSyncOperationQueryObject on QueryBuilder<PendingSyncOperation,
    PendingSyncOperation, QFilterCondition> {}

extension PendingSyncOperationQueryLinks on QueryBuilder<PendingSyncOperation,
    PendingSyncOperation, QFilterCondition> {}

extension PendingSyncOperationQuerySortBy
    on QueryBuilder<PendingSyncOperation, PendingSyncOperation, QSortBy> {
  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByBatchSetIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchSetIds', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByBatchSetIdsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchSetIds', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByDistance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distance', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByDistanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distance', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutes', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutes', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByOperationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationType', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByOperationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationType', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByRepetitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repetitions', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByRepetitionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repetitions', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByScheduleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByScheduleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortBySeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seconds', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortBySecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seconds', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortBySessionDateStr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDateStr', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortBySessionDateStrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDateStr', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortBySetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setId', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortBySetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setId', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortBySetNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setNumber', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortBySetNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setNumber', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortBySetType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setType', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortBySetTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setType', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      sortByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }
}

extension PendingSyncOperationQuerySortThenBy
    on QueryBuilder<PendingSyncOperation, PendingSyncOperation, QSortThenBy> {
  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByBatchSetIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchSetIds', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByBatchSetIdsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchSetIds', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByDistance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distance', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByDistanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distance', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutes', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutes', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByOperationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationType', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByOperationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationType', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByRepetitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repetitions', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByRepetitionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repetitions', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByScheduleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByScheduleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenBySeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seconds', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenBySecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seconds', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenBySessionDateStr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDateStr', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenBySessionDateStrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDateStr', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenBySetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setId', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenBySetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setId', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenBySetNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setNumber', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenBySetNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setNumber', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenBySetType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setType', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenBySetTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setType', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QAfterSortBy>
      thenByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }
}

extension PendingSyncOperationQueryWhereDistinct
    on QueryBuilder<PendingSyncOperation, PendingSyncOperation, QDistinct> {
  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QDistinct>
      distinctByBatchSetIds({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'batchSetIds', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QDistinct>
      distinctByDistance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'distance');
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QDistinct>
      distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QDistinct>
      distinctByMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minutes');
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QDistinct>
      distinctByOperationType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'operationType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QDistinct>
      distinctByRepetitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repetitions');
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QDistinct>
      distinctByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retryCount');
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QDistinct>
      distinctByScheduleId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduleId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QDistinct>
      distinctBySeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seconds');
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QDistinct>
      distinctBySessionDateStr({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionDateStr',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QDistinct>
      distinctBySetId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'setId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QDistinct>
      distinctBySetNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'setNumber');
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QDistinct>
      distinctBySetType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'setType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<PendingSyncOperation, PendingSyncOperation, QDistinct>
      distinctByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weight');
    });
  }
}

extension PendingSyncOperationQueryProperty on QueryBuilder<
    PendingSyncOperation, PendingSyncOperation, QQueryProperty> {
  QueryBuilder<PendingSyncOperation, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<PendingSyncOperation, String?, QQueryOperations>
      batchSetIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'batchSetIds');
    });
  }

  QueryBuilder<PendingSyncOperation, double?, QQueryOperations>
      distanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'distance');
    });
  }

  QueryBuilder<PendingSyncOperation, bool?, QQueryOperations>
      isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<PendingSyncOperation, int?, QQueryOperations> minutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minutes');
    });
  }

  QueryBuilder<PendingSyncOperation, String, QQueryOperations>
      operationTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'operationType');
    });
  }

  QueryBuilder<PendingSyncOperation, int?, QQueryOperations>
      repetitionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repetitions');
    });
  }

  QueryBuilder<PendingSyncOperation, int, QQueryOperations>
      retryCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retryCount');
    });
  }

  QueryBuilder<PendingSyncOperation, String?, QQueryOperations>
      scheduleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduleId');
    });
  }

  QueryBuilder<PendingSyncOperation, int?, QQueryOperations> secondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seconds');
    });
  }

  QueryBuilder<PendingSyncOperation, String?, QQueryOperations>
      sessionDateStrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionDateStr');
    });
  }

  QueryBuilder<PendingSyncOperation, String, QQueryOperations> setIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'setId');
    });
  }

  QueryBuilder<PendingSyncOperation, int?, QQueryOperations>
      setNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'setNumber');
    });
  }

  QueryBuilder<PendingSyncOperation, String?, QQueryOperations>
      setTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'setType');
    });
  }

  QueryBuilder<PendingSyncOperation, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<PendingSyncOperation, double?, QQueryOperations>
      weightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weight');
    });
  }
}
