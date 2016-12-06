
select top 100 * from entity.ApplicationBPFAttr
select top 100 * from [bi].[ApplicationBPFAttrSCD]

into #temp   (IndustryType, RequestedLoanAmt, AccountOpened) 
	select @RunSetId as RunSetID, 
@p_Run as RunID, 
@SourceRowId as SourceRowId, 
c.IndustryType as Portfolio, 
	@CategoryConstant as Category, 
	ic.IndustryType as Product, 
aba.CCNReferenceNumber, 
'New Bookings: amount' as Metric, 
'£        Flow' as Unit, 
RequestedLoanAmt as Value, 
1 as AccountOpened, 
@CobDate as COBDate, 
@DetailedGroupingID as GroupingID, 
ad.AccountNumber 
from entity.ApplicationBPFAttr aba 
inner join entity.History h on h.HistoryKey = aba.HistoryKey 
and h.EntityTypeID = @EntityTypeID 
and h.EffectiveFromDateTime <= @CobDate 
h.EffectiveToDateTime > @CobDate 
inner join entity.Association a on a.EntityKey = h.EntityKey 
and a.EntityTypeID = @EntityTypeID 
and a.RelatedEntityTypeID = @RelatedEntityTypeID 
and a.EffectiveFromDateTime <= @CobDate 
and a.EffectiveToDateTime > @CobDate 
inner join entity.History rh on rh.EntityKey = a.RelatedEntityKey 
and rh.EntityTypeID = @RelatedEntityTypeID 
and rh.EffectiveFromDateTime <= @CobDate 
and rh.EffectiveToDateTime > @CobDate 
inner join entity.BPFVintageAccountDetailsBookAttr ad on ad.HistoryKey = rh.HistoryKey 
inner join @IndustryCodelookupTable as ic on ic.IndustryCode = aba.IndustryCode 
where ad.AccountOpenMonth = dateadd(month, datediff(month, 0, @CobDate), 0) 
and aba.BusinessDecision='ACCEPT'