###
@namespace scoping into the CQL_QDM namespace
###
@CQL_QDM ||= {}

###
Data elements that meet criteria using this datatype should document a request
for the laboratory test indicated by the QDM category and its corresponding
value set.
###
class CQL_QDM.LaboratoryTestOrder extends CQL_QDM.QDMDatatype
  constructor: (@entry) ->
    super @entry
    @_method = @entry.method
    @_negationRationale = @entry.negationReason
    @_reason = @entry.reason
    @_authorDatetime = CQL_QDM.Helpers.convertDateTime(@entry.start_time)

  ###
  @returns {Code}
  ###
  method: ->
    new cql.Code(@_method?.code, @_method?.code_system)

  ###
  @returns {Code}
  ###
  negationRationale: ->
    new cql.Code(@_negationRationale?.code, @_negationRationale?.code_system)

  ###
  @returns {Code}
  ###
  reason: ->
    new cql.Code(@_reason?.code, @_reason?.code_system)

  ###
  @returns {Date}
  ###
  authorDatetime: ->
    cql.DateTime.fromDate(@_authorDatetime)


###
Data elements that meet criteria using this datatype should document the
laboratory test indicated by the QDM category and its corresponding value set
was performed.
###
class CQL_QDM.LaboratoryTestPerformed extends CQL_QDM.QDMDatatype
  constructor: (@entry) ->
    super @entry
    @_method = @entry.method
    @_negationRationale = @entry.negationReason
    @_reason = @entry.reason
    @_referenceRangeLow = @entry.referenceRangeLow
    @_referenceRangeHigh = @entry.referenceRangeHigh
    @_relevantPeriodLow = CQL_QDM.Helpers.convertDateTime(@entry.start_time)
    if @entry.end_time
      @_relevantPeriodHigh = CQL_QDM.Helpers.convertDateTime(@entry.end_time)
    else
      # No end time; high is set to infinity
      @_relevantPeriodHigh = CQL_QDM.Helpers.convertDateTime('12/31/2999 12:59 PM')
    if @entry.values? && @entry.values.length > 0
      @_result = @entry.values?[0]
    @_resultDatetime = CQL_QDM.Helpers.convertDateTime(@entry.result_date_time)
    @_status = @entry.status

  ###
  @returns {Code}
  ###
  method: ->
    new cql.Code(@_method?.code, @_method?.code_system)

  ###
  @returns {Code}
  ###
  negationRationale: ->
    new cql.Code(@_negationRationale?.code, @_negationRationale?.code_system)

  ###
  @returns {Code}
  ###
  reason: ->
    new cql.Code(@_reason?.code, @_reason?.code_system)

  ###
  @returns {Interval}
  ###
  referenceRange: ->
    # According to documentation, this is assumed to be a 'Quantity'
    high = null
    low = null
    if @_referenceRangeHigh?['unit']?
      high = new Quantity({unit: @_referenceRangeHigh['unit'], value: @_referenceRangeHigh['value']})
    if @_referenceRangeLow?['unit']?
      low = new Quantity({unit: @_referenceRangeLow['unit'], value: @_referenceRangeLow['value']})
    new cql.Interval(low, high)

  ###
  @returns {Interval<Date>}
  ###
  relevantPeriod: ->
    low = cql.DateTime.fromDate(@_relevantPeriodLow)
    high = cql.DateTime.fromDate(@_relevantPeriodHigh)
    new cql.Interval(low, high)

  ###
  @returns {Code|Int}
  ###
  result: ->
    if @_result
      if @_result.codes?
        code_system = @_result.codes[Object.keys(@_result.codes)[0]]
        code = @_result.codes[code_system]
        new cql.Code(code, code_system)
      else
        parseInt(@_result.scalar)

  ###
  @returns {Date}
  ###
  resultDatetime: ->
    cql.DateTime.fromDate(@_resultDatetime)

  ###
  @returns {Code}
  ###
  status: ->
    new cql.Code(@_status?.code, @_status?.code_system)


###
Data elements that meet criteria using this datatype should document a
recommendation for the laboratory test indicated by the QDM category and its
corresponding value set.
###
class CQL_QDM.LaboratoryTestRecommended extends CQL_QDM.QDMDatatype
  constructor: (@entry) ->
    super @entry
    @_authorDatetime = CQL_QDM.Helpers.convertDateTime(@entry.start_time)
    @_method = @entry.method
    @_negationRationale = @entry.negationReason
    @_reason = @entry.reason

  ###
  @returns {Date}
  ###
  authorDatetime: ->
    cql.DateTime.fromDate(@_authorDatetime)

  ###
  @returns {Code}
  ###
  method: ->
    new cql.Code(@_method?.code, @_method?.code_system)

  ###
  @returns {Code}
  ###
  negationRationale: ->
    new cql.Code(@_negationRationale?.code, @_negationRationale?.code_system)

  ###
  @returns {Code}
  ###
  reason: ->
    new cql.Code(@_reason?.code, @_reason?.code_system)
