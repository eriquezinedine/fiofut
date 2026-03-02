// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_schedule.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPendingScheduleCollection on Isar {
  IsarCollection<PendingSchedule> get pendingSchedules => this.collection();
}

const PendingScheduleSchema = CollectionSchema(
  name: r'PendingSchedule',
  id: -6333924905734527643,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dateStr': PropertySchema(
      id: 1,
      name: r'dateStr',
      type: IsarType.string,
    ),
    r'daysOfWeek': PropertySchema(
      id: 2,
      name: r'daysOfWeek',
      type: IsarType.string,
    ),
    r'endDateStr': PropertySchema(
      id: 3,
      name: r'endDateStr',
      type: IsarType.string,
    ),
    r'exerciseDescription': PropertySchema(
      id: 4,
      name: r'exerciseDescription',
      type: IsarType.string,
    ),
    r'exerciseId': PropertySchema(
      id: 5,
      name: r'exerciseId',
      type: IsarType.string,
    ),
    r'exerciseImageUrl': PropertySchema(
      id: 6,
      name: r'exerciseImageUrl',
      type: IsarType.string,
    ),
    r'exerciseName': PropertySchema(
      id: 7,
      name: r'exerciseName',
      type: IsarType.string,
    ),
    r'exerciseType': PropertySchema(
      id: 8,
      name: r'exerciseType',
      type: IsarType.string,
    ),
    r'exerciseVideoUrl': PropertySchema(
      id: 9,
      name: r'exerciseVideoUrl',
      type: IsarType.string,
    ),
    r'retryCount': PropertySchema(
      id: 10,
      name: r'retryCount',
      type: IsarType.long,
    ),
    r'scheduleType': PropertySchema(
      id: 11,
      name: r'scheduleType',
      type: IsarType.string,
    ),
    r'startDateStr': PropertySchema(
      id: 12,
      name: r'startDateStr',
      type: IsarType.string,
    ),
    r'tempId': PropertySchema(
      id: 13,
      name: r'tempId',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(
      id: 14,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _pendingScheduleEstimateSize,
  serialize: _pendingScheduleSerialize,
  deserialize: _pendingScheduleDeserialize,
  deserializeProp: _pendingScheduleDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'tempId': IndexSchema(
      id: 2461988663639479411,
      name: r'tempId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'tempId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _pendingScheduleGetId,
  getLinks: _pendingScheduleGetLinks,
  attach: _pendingScheduleAttach,
  version: '3.1.0+1',
);

int _pendingScheduleEstimateSize(
  PendingSchedule object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dateStr.length * 3;
  {
    final value = object.daysOfWeek;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.endDateStr;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.exerciseDescription;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.exerciseId.length * 3;
  {
    final value = object.exerciseImageUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.exerciseName.length * 3;
  bytesCount += 3 + object.exerciseType.length * 3;
  {
    final value = object.exerciseVideoUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.scheduleType.length * 3;
  {
    final value = object.startDateStr;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.tempId.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _pendingScheduleSerialize(
  PendingSchedule object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.dateStr);
  writer.writeString(offsets[2], object.daysOfWeek);
  writer.writeString(offsets[3], object.endDateStr);
  writer.writeString(offsets[4], object.exerciseDescription);
  writer.writeString(offsets[5], object.exerciseId);
  writer.writeString(offsets[6], object.exerciseImageUrl);
  writer.writeString(offsets[7], object.exerciseName);
  writer.writeString(offsets[8], object.exerciseType);
  writer.writeString(offsets[9], object.exerciseVideoUrl);
  writer.writeLong(offsets[10], object.retryCount);
  writer.writeString(offsets[11], object.scheduleType);
  writer.writeString(offsets[12], object.startDateStr);
  writer.writeString(offsets[13], object.tempId);
  writer.writeString(offsets[14], object.userId);
}

PendingSchedule _pendingScheduleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PendingSchedule();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.dateStr = reader.readString(offsets[1]);
  object.daysOfWeek = reader.readStringOrNull(offsets[2]);
  object.endDateStr = reader.readStringOrNull(offsets[3]);
  object.exerciseDescription = reader.readStringOrNull(offsets[4]);
  object.exerciseId = reader.readString(offsets[5]);
  object.exerciseImageUrl = reader.readStringOrNull(offsets[6]);
  object.exerciseName = reader.readString(offsets[7]);
  object.exerciseType = reader.readString(offsets[8]);
  object.exerciseVideoUrl = reader.readStringOrNull(offsets[9]);
  object.isarId = id;
  object.retryCount = reader.readLong(offsets[10]);
  object.scheduleType = reader.readString(offsets[11]);
  object.startDateStr = reader.readStringOrNull(offsets[12]);
  object.tempId = reader.readString(offsets[13]);
  object.userId = reader.readString(offsets[14]);
  return object;
}

P _pendingScheduleDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pendingScheduleGetId(PendingSchedule object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _pendingScheduleGetLinks(PendingSchedule object) {
  return [];
}

void _pendingScheduleAttach(
    IsarCollection<dynamic> col, Id id, PendingSchedule object) {
  object.isarId = id;
}

extension PendingScheduleByIndex on IsarCollection<PendingSchedule> {
  Future<PendingSchedule?> getByTempId(String tempId) {
    return getByIndex(r'tempId', [tempId]);
  }

  PendingSchedule? getByTempIdSync(String tempId) {
    return getByIndexSync(r'tempId', [tempId]);
  }

  Future<bool> deleteByTempId(String tempId) {
    return deleteByIndex(r'tempId', [tempId]);
  }

  bool deleteByTempIdSync(String tempId) {
    return deleteByIndexSync(r'tempId', [tempId]);
  }

  Future<List<PendingSchedule?>> getAllByTempId(List<String> tempIdValues) {
    final values = tempIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'tempId', values);
  }

  List<PendingSchedule?> getAllByTempIdSync(List<String> tempIdValues) {
    final values = tempIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'tempId', values);
  }

  Future<int> deleteAllByTempId(List<String> tempIdValues) {
    final values = tempIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'tempId', values);
  }

  int deleteAllByTempIdSync(List<String> tempIdValues) {
    final values = tempIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'tempId', values);
  }

  Future<Id> putByTempId(PendingSchedule object) {
    return putByIndex(r'tempId', object);
  }

  Id putByTempIdSync(PendingSchedule object, {bool saveLinks = true}) {
    return putByIndexSync(r'tempId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTempId(List<PendingSchedule> objects) {
    return putAllByIndex(r'tempId', objects);
  }

  List<Id> putAllByTempIdSync(List<PendingSchedule> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'tempId', objects, saveLinks: saveLinks);
  }
}

extension PendingScheduleQueryWhereSort
    on QueryBuilder<PendingSchedule, PendingSchedule, QWhere> {
  QueryBuilder<PendingSchedule, PendingSchedule, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PendingScheduleQueryWhere
    on QueryBuilder<PendingSchedule, PendingSchedule, QWhereClause> {
  QueryBuilder<PendingSchedule, PendingSchedule, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterWhereClause>
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

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterWhereClause>
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

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterWhereClause>
      tempIdEqualTo(String tempId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tempId',
        value: [tempId],
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterWhereClause>
      tempIdNotEqualTo(String tempId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tempId',
              lower: [],
              upper: [tempId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tempId',
              lower: [tempId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tempId',
              lower: [tempId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tempId',
              lower: [],
              upper: [tempId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PendingScheduleQueryFilter
    on QueryBuilder<PendingSchedule, PendingSchedule, QFilterCondition> {
  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      dateStrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      dateStrGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      dateStrLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      dateStrBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateStr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      dateStrStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      dateStrEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      dateStrContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      dateStrMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dateStr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      dateStrIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateStr',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      dateStrIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateStr',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      daysOfWeekIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'daysOfWeek',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      daysOfWeekIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'daysOfWeek',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      daysOfWeekEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'daysOfWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      daysOfWeekGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'daysOfWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      daysOfWeekLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'daysOfWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      daysOfWeekBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'daysOfWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      daysOfWeekStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'daysOfWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      daysOfWeekEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'daysOfWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      daysOfWeekContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'daysOfWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      daysOfWeekMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'daysOfWeek',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      daysOfWeekIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'daysOfWeek',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      daysOfWeekIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'daysOfWeek',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      endDateStrIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endDateStr',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      endDateStrIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endDateStr',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      endDateStrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      endDateStrGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      endDateStrLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      endDateStrBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endDateStr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      endDateStrStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'endDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      endDateStrEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'endDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      endDateStrContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'endDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      endDateStrMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'endDateStr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      endDateStrIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDateStr',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      endDateStrIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'endDateStr',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseDescriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exerciseDescription',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseDescriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exerciseDescription',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseDescriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseDescriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseDescriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseDescriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exerciseDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exerciseDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseDescriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exerciseDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseDescriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exerciseDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exerciseDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exerciseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exerciseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exerciseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exerciseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseId',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exerciseId',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseImageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exerciseImageUrl',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseImageUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exerciseImageUrl',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseImageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseImageUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseImageUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseImageUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseImageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseImageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exerciseImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseImageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exerciseImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseImageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exerciseImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseImageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exerciseImageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseImageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseImageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exerciseImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exerciseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exerciseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exerciseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exerciseName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseName',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exerciseName',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exerciseType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exerciseType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exerciseType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exerciseType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseType',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exerciseType',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseVideoUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exerciseVideoUrl',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseVideoUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exerciseVideoUrl',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseVideoUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseVideoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseVideoUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseVideoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseVideoUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseVideoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseVideoUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseVideoUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseVideoUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exerciseVideoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseVideoUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exerciseVideoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseVideoUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exerciseVideoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseVideoUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exerciseVideoUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseVideoUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseVideoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      exerciseVideoUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exerciseVideoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
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

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
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

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
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

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      retryCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
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

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
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

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
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

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      scheduleTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      scheduleTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      scheduleTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      scheduleTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduleType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      scheduleTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'scheduleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      scheduleTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'scheduleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      scheduleTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'scheduleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      scheduleTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'scheduleType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      scheduleTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduleType',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      scheduleTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'scheduleType',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      startDateStrIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startDateStr',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      startDateStrIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startDateStr',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      startDateStrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      startDateStrGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      startDateStrLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      startDateStrBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDateStr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      startDateStrStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'startDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      startDateStrEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'startDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      startDateStrContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'startDateStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      startDateStrMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'startDateStr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      startDateStrIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDateStr',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      startDateStrIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'startDateStr',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      tempIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tempId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      tempIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tempId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      tempIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tempId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      tempIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tempId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      tempIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tempId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      tempIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tempId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      tempIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tempId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      tempIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tempId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      tempIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tempId',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      tempIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tempId',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension PendingScheduleQueryObject
    on QueryBuilder<PendingSchedule, PendingSchedule, QFilterCondition> {}

extension PendingScheduleQueryLinks
    on QueryBuilder<PendingSchedule, PendingSchedule, QFilterCondition> {}

extension PendingScheduleQuerySortBy
    on QueryBuilder<PendingSchedule, PendingSchedule, QSortBy> {
  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy> sortByDateStr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateStr', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByDateStrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateStr', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByDaysOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysOfWeek', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByDaysOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysOfWeek', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByEndDateStr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateStr', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByEndDateStrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateStr', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByExerciseDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseDescription', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByExerciseDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseDescription', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByExerciseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseId', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByExerciseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseId', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByExerciseImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseImageUrl', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByExerciseImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseImageUrl', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByExerciseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseName', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByExerciseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseName', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByExerciseType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseType', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByExerciseTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseType', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByExerciseVideoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseVideoUrl', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByExerciseVideoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseVideoUrl', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByScheduleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleType', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByScheduleTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleType', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByStartDateStr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDateStr', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByStartDateStrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDateStr', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy> sortByTempId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tempId', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByTempIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tempId', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension PendingScheduleQuerySortThenBy
    on QueryBuilder<PendingSchedule, PendingSchedule, QSortThenBy> {
  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy> thenByDateStr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateStr', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByDateStrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateStr', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByDaysOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysOfWeek', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByDaysOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysOfWeek', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByEndDateStr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateStr', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByEndDateStrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateStr', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByExerciseDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseDescription', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByExerciseDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseDescription', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByExerciseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseId', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByExerciseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseId', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByExerciseImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseImageUrl', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByExerciseImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseImageUrl', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByExerciseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseName', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByExerciseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseName', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByExerciseType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseType', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByExerciseTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseType', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByExerciseVideoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseVideoUrl', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByExerciseVideoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseVideoUrl', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByScheduleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleType', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByScheduleTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleType', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByStartDateStr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDateStr', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByStartDateStrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDateStr', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy> thenByTempId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tempId', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByTempIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tempId', Sort.desc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension PendingScheduleQueryWhereDistinct
    on QueryBuilder<PendingSchedule, PendingSchedule, QDistinct> {
  QueryBuilder<PendingSchedule, PendingSchedule, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QDistinct> distinctByDateStr(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateStr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QDistinct>
      distinctByDaysOfWeek({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'daysOfWeek', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QDistinct>
      distinctByEndDateStr({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDateStr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QDistinct>
      distinctByExerciseDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseDescription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QDistinct>
      distinctByExerciseId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QDistinct>
      distinctByExerciseImageUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseImageUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QDistinct>
      distinctByExerciseName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QDistinct>
      distinctByExerciseType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QDistinct>
      distinctByExerciseVideoUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseVideoUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QDistinct>
      distinctByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retryCount');
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QDistinct>
      distinctByScheduleType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduleType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QDistinct>
      distinctByStartDateStr({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDateStr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QDistinct> distinctByTempId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tempId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSchedule, PendingSchedule, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension PendingScheduleQueryProperty
    on QueryBuilder<PendingSchedule, PendingSchedule, QQueryProperty> {
  QueryBuilder<PendingSchedule, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<PendingSchedule, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PendingSchedule, String, QQueryOperations> dateStrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateStr');
    });
  }

  QueryBuilder<PendingSchedule, String?, QQueryOperations>
      daysOfWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'daysOfWeek');
    });
  }

  QueryBuilder<PendingSchedule, String?, QQueryOperations>
      endDateStrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDateStr');
    });
  }

  QueryBuilder<PendingSchedule, String?, QQueryOperations>
      exerciseDescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseDescription');
    });
  }

  QueryBuilder<PendingSchedule, String, QQueryOperations> exerciseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseId');
    });
  }

  QueryBuilder<PendingSchedule, String?, QQueryOperations>
      exerciseImageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseImageUrl');
    });
  }

  QueryBuilder<PendingSchedule, String, QQueryOperations>
      exerciseNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseName');
    });
  }

  QueryBuilder<PendingSchedule, String, QQueryOperations>
      exerciseTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseType');
    });
  }

  QueryBuilder<PendingSchedule, String?, QQueryOperations>
      exerciseVideoUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseVideoUrl');
    });
  }

  QueryBuilder<PendingSchedule, int, QQueryOperations> retryCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retryCount');
    });
  }

  QueryBuilder<PendingSchedule, String, QQueryOperations>
      scheduleTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduleType');
    });
  }

  QueryBuilder<PendingSchedule, String?, QQueryOperations>
      startDateStrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDateStr');
    });
  }

  QueryBuilder<PendingSchedule, String, QQueryOperations> tempIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tempId');
    });
  }

  QueryBuilder<PendingSchedule, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
