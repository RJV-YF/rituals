// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_summary.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMonthSummaryCollection on Isar {
  IsarCollection<MonthSummary> get monthSummarys => this.collection();
}

const MonthSummarySchema = CollectionSchema(
  name: r'MonthSummary',
  id: 5052242006163410608,
  properties: {
    r'activeDays': PropertySchema(
      id: 0,
      name: r'activeDays',
      type: IsarType.long,
    ),
    r'isSealed': PropertySchema(id: 1, name: r'isSealed', type: IsarType.bool),
    r'kept': PropertySchema(id: 2, name: r'kept', type: IsarType.long),
    r'keptByDay': PropertySchema(
      id: 3,
      name: r'keptByDay',
      type: IsarType.longList,
    ),
    r'longestStreak': PropertySchema(
      id: 4,
      name: r'longestStreak',
      type: IsarType.long,
    ),
    r'month': PropertySchema(id: 5, name: r'month', type: IsarType.long),
    r'planned': PropertySchema(id: 6, name: r'planned', type: IsarType.long),
    r'plannedByDay': PropertySchema(
      id: 7,
      name: r'plannedByDay',
      type: IsarType.longList,
    ),
    r'trackedDays': PropertySchema(
      id: 8,
      name: r'trackedDays',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'year': PropertySchema(id: 10, name: r'year', type: IsarType.long),
  },

  estimateSize: _monthSummaryEstimateSize,
  serialize: _monthSummarySerialize,
  deserialize: _monthSummaryDeserialize,
  deserializeProp: _monthSummaryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _monthSummaryGetId,
  getLinks: _monthSummaryGetLinks,
  attach: _monthSummaryAttach,
  version: '3.3.2',
);

int _monthSummaryEstimateSize(
  MonthSummary object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.keptByDay.length * 8;
  bytesCount += 3 + object.plannedByDay.length * 8;
  return bytesCount;
}

void _monthSummarySerialize(
  MonthSummary object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.activeDays);
  writer.writeBool(offsets[1], object.isSealed);
  writer.writeLong(offsets[2], object.kept);
  writer.writeLongList(offsets[3], object.keptByDay);
  writer.writeLong(offsets[4], object.longestStreak);
  writer.writeLong(offsets[5], object.month);
  writer.writeLong(offsets[6], object.planned);
  writer.writeLongList(offsets[7], object.plannedByDay);
  writer.writeLong(offsets[8], object.trackedDays);
  writer.writeDateTime(offsets[9], object.updatedAt);
  writer.writeLong(offsets[10], object.year);
}

MonthSummary _monthSummaryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MonthSummary();
  object.activeDays = reader.readLong(offsets[0]);
  object.id = id;
  object.isSealed = reader.readBool(offsets[1]);
  object.kept = reader.readLong(offsets[2]);
  object.keptByDay = reader.readLongList(offsets[3]) ?? [];
  object.longestStreak = reader.readLong(offsets[4]);
  object.month = reader.readLong(offsets[5]);
  object.planned = reader.readLong(offsets[6]);
  object.plannedByDay = reader.readLongList(offsets[7]) ?? [];
  object.trackedDays = reader.readLong(offsets[8]);
  object.updatedAt = reader.readDateTime(offsets[9]);
  object.year = reader.readLong(offsets[10]);
  return object;
}

P _monthSummaryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLongList(offset) ?? []) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLongList(offset) ?? []) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _monthSummaryGetId(MonthSummary object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _monthSummaryGetLinks(MonthSummary object) {
  return [];
}

void _monthSummaryAttach(
  IsarCollection<dynamic> col,
  Id id,
  MonthSummary object,
) {
  object.id = id;
}

extension MonthSummaryQueryWhereSort
    on QueryBuilder<MonthSummary, MonthSummary, QWhere> {
  QueryBuilder<MonthSummary, MonthSummary, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MonthSummaryQueryWhere
    on QueryBuilder<MonthSummary, MonthSummary, QWhereClause> {
  QueryBuilder<MonthSummary, MonthSummary, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension MonthSummaryQueryFilter
    on QueryBuilder<MonthSummary, MonthSummary, QFilterCondition> {
  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  activeDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'activeDays', value: value),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  activeDaysGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'activeDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  activeDaysLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'activeDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  activeDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'activeDays',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  isSealedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isSealed', value: value),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition> keptEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'kept', value: value),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  keptGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'kept',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition> keptLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'kept',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition> keptBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'kept',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  keptByDayElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'keptByDay', value: value),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  keptByDayElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'keptByDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  keptByDayElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'keptByDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  keptByDayElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'keptByDay',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  keptByDayLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'keptByDay', length, true, length, true);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  keptByDayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'keptByDay', 0, true, 0, true);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  keptByDayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'keptByDay', 0, false, 999999, true);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  keptByDayLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'keptByDay', 0, true, length, include);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  keptByDayLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'keptByDay', length, include, 999999, true);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  keptByDayLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keptByDay',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  longestStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'longestStreak', value: value),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  longestStreakGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'longestStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  longestStreakLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'longestStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  longestStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'longestStreak',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition> monthEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'month', value: value),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  monthGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'month',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition> monthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'month',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition> monthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'month',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  plannedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'planned', value: value),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  plannedGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'planned',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  plannedLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'planned',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  plannedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'planned',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  plannedByDayElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'plannedByDay', value: value),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  plannedByDayElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plannedByDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  plannedByDayElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plannedByDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  plannedByDayElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plannedByDay',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  plannedByDayLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'plannedByDay', length, true, length, true);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  plannedByDayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'plannedByDay', 0, true, 0, true);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  plannedByDayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'plannedByDay', 0, false, 999999, true);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  plannedByDayLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'plannedByDay', 0, true, length, include);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  plannedByDayLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'plannedByDay', length, include, 999999, true);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  plannedByDayLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'plannedByDay',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  trackedDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'trackedDays', value: value),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  trackedDaysGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'trackedDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  trackedDaysLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'trackedDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  trackedDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'trackedDays',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition> yearEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'year', value: value),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition>
  yearGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'year',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition> yearLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'year',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterFilterCondition> yearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'year',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension MonthSummaryQueryObject
    on QueryBuilder<MonthSummary, MonthSummary, QFilterCondition> {}

extension MonthSummaryQueryLinks
    on QueryBuilder<MonthSummary, MonthSummary, QFilterCondition> {}

extension MonthSummaryQuerySortBy
    on QueryBuilder<MonthSummary, MonthSummary, QSortBy> {
  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> sortByActiveDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeDays', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy>
  sortByActiveDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeDays', Sort.desc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> sortByIsSealed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSealed', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> sortByIsSealedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSealed', Sort.desc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> sortByKept() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kept', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> sortByKeptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kept', Sort.desc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> sortByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy>
  sortByLongestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.desc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> sortByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> sortByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> sortByPlanned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planned', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> sortByPlannedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planned', Sort.desc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> sortByTrackedDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackedDays', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy>
  sortByTrackedDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackedDays', Sort.desc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension MonthSummaryQuerySortThenBy
    on QueryBuilder<MonthSummary, MonthSummary, QSortThenBy> {
  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> thenByActiveDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeDays', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy>
  thenByActiveDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeDays', Sort.desc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> thenByIsSealed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSealed', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> thenByIsSealedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSealed', Sort.desc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> thenByKept() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kept', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> thenByKeptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kept', Sort.desc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> thenByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy>
  thenByLongestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.desc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> thenByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> thenByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> thenByPlanned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planned', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> thenByPlannedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planned', Sort.desc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> thenByTrackedDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackedDays', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy>
  thenByTrackedDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackedDays', Sort.desc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QAfterSortBy> thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension MonthSummaryQueryWhereDistinct
    on QueryBuilder<MonthSummary, MonthSummary, QDistinct> {
  QueryBuilder<MonthSummary, MonthSummary, QDistinct> distinctByActiveDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activeDays');
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QDistinct> distinctByIsSealed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSealed');
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QDistinct> distinctByKept() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kept');
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QDistinct> distinctByKeptByDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'keptByDay');
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QDistinct>
  distinctByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longestStreak');
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QDistinct> distinctByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'month');
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QDistinct> distinctByPlanned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planned');
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QDistinct> distinctByPlannedByDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedByDay');
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QDistinct> distinctByTrackedDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trackedDays');
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<MonthSummary, MonthSummary, QDistinct> distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year');
    });
  }
}

extension MonthSummaryQueryProperty
    on QueryBuilder<MonthSummary, MonthSummary, QQueryProperty> {
  QueryBuilder<MonthSummary, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MonthSummary, int, QQueryOperations> activeDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeDays');
    });
  }

  QueryBuilder<MonthSummary, bool, QQueryOperations> isSealedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSealed');
    });
  }

  QueryBuilder<MonthSummary, int, QQueryOperations> keptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kept');
    });
  }

  QueryBuilder<MonthSummary, List<int>, QQueryOperations> keptByDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'keptByDay');
    });
  }

  QueryBuilder<MonthSummary, int, QQueryOperations> longestStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longestStreak');
    });
  }

  QueryBuilder<MonthSummary, int, QQueryOperations> monthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'month');
    });
  }

  QueryBuilder<MonthSummary, int, QQueryOperations> plannedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planned');
    });
  }

  QueryBuilder<MonthSummary, List<int>, QQueryOperations>
  plannedByDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedByDay');
    });
  }

  QueryBuilder<MonthSummary, int, QQueryOperations> trackedDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trackedDays');
    });
  }

  QueryBuilder<MonthSummary, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<MonthSummary, int, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }
}
