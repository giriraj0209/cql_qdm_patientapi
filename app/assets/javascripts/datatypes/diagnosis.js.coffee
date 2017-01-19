###
@namespace scoping into the CQL_QDM namespace
###
@CQL_QDM ||= {}


###
Data elements that meet criteria using this datatype should document the
Condition/Diagnosis/Problem and its corresponding value set. The onset
datetime corresponds to the implicit start datetime of the datatype and the
abatement datetime corresponds to the implicit stop datetime of the datatype.
If the abatement datetime is null, then the diagnosis is considered to still
be active. When this datatype is used with timing relationships, the criterion
is looking for an active diagnosis for the time frame indicated by the timing
relationships.
###
class CQL_QDM.Diagnosis extends CQL_QDM.QDMDatatype
  constructor: (@entry) ->
    super @entry
    @_prevalencePeriodLow = CQL_QDM.Helpers.convertDateTime(@entry.start_time)
    if @entry.end_time
      @_prevalencePeriodHigh = CQL_QDM.Helpers.convertDateTime(@entry.end_time)
    else
      # No end time; high is set to infinity
      @_prevalencePeriodHigh = CQL_QDM.Helpers.convertDateTime('12/31/2999 12:59 PM')
    @_anatomicalLocationSite = @entry.anatomical_location
    @_severity = @entry.severity

  ###
  @returns {Code}
  ###
  anatomicalLocationSite: ->
    new cql.Code(@_anatomicalLocationSite?.code, @_anatomicalLocationSite?.code_system)

  ###
  @returns {Interval<Date>}
  ###
  prevalencePeriod: ->
    low = cql.DateTime.fromDate(@_prevalencePeriodLow)
    high = cql.DateTime.fromDate(@_prevalencePeriodHigh)
    new cql.Interval(low, high)

  ###
  @returns {Code}
  ###
  severity: ->
    new cql.Code(@_severity?.code, @_severity?.code_system)
