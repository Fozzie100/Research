select top 100 * from bi.FDSF_TDTAAccLinkingFactDataDelta (nolock)
where LogicalAccountKeyNo = 4929995876212
and getdate() between EffectiveFromDateTime and EffectiveToDateTime

select top 100 * from bi.FDSF_TDTAAccLinkingFactData
where RunId=43 and LogicalAccountKeyNo = 4929995876212

select x.* 
from bi.FDSF_TDTAAccLinkingFactDataDelta x (nolock)
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey
where not exists (select top 1 1 from 
					bi.FDSF_TDTAAccLinkingFactData (nolock) z 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
					where z.RunId=43 and z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL))
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL))
				 )



				 select x.* 
from bi.FDSF_TDTAAccLinkingFactDataDelta x (nolock)
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey
where not exists (select top 1 1 from 
					bi.FDSF_TDTAAccLinkingFactData (nolock) z 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
					where z.RunId=1804 and z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL))
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL))
				 )
and '30 Jun 2015' between x.EffectiveFromDateTime and x.EffectiveToDateTime and x.IsDeleted = 0

select z.* 
from bi.FDSF_TDTAAccLinkingFactData (nolock) z 
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
where z.RunId=1804 
and not exists (select top 1 1 
					from bi.FDSF_TDTAAccLinkingFactDataDelta x 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey

					where z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					-- and z.Latest_Account_Number = x.Latest_Account_Number
					and  '30 Jun 2015' between EffectiveFromDateTime and EffectiveToDateTime 
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL))
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL))
				)




select x.* 
-- into #missedaccounts
from bi.FDSF_TDTAAccLinkingFactDataDelta x (nolock)
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey
where not exists (select top 1 1 from 
					bi.FDSF_TDTAAccLinkingFactData (nolock) z 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
					where z.RunId=5093 and z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL))
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL))
				 )
and '31 Jul 2015' between x.EffectiveFromDateTime and x.EffectiveToDateTime and x.IsDeleted = 0

select z.* 
from bi.FDSF_TDTAAccLinkingFactData (nolock) z 
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
where z.RunId=5093 
and not exists (select top 1 1 
					from bi.FDSF_TDTAAccLinkingFactDataDelta x 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey

					where z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					-- and z.Latest_Account_Number = x.Latest_Account_Number
					and  '31 Jul 2015' between EffectiveFromDateTime and EffectiveToDateTime 
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL))
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL))
				)



select x.* 
-- into #missedaccounts
from bi.FDSF_TDTAAccLinkingFactDataDelta x (nolock)
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey
where not exists (select top 1 1 from 
					bi.FDSF_TDTAAccLinkingFactData (nolock) z 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
					where z.RunId=5409 and z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) 
					--- OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL)  may have to uncomment
						)
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL) OR (unx.UniDate IS NOT NULL and  un.UniDate IS NULL)) -- required cause of bugs in prod. un.UniDate is somrtimes null when it should not be
				 )
and '30 Sep 2015' between x.EffectiveFromDateTime and x.EffectiveToDateTime and x.IsDeleted = 0

select z.* 
from bi.FDSF_TDTAAccLinkingFactData (nolock) z 
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
where z.RunId=5409 
and not exists (select top 1 1 
					from bi.FDSF_TDTAAccLinkingFactDataDelta x 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey

					where z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					-- and z.Latest_Account_Number = x.Latest_Account_Number
					and  '30 Sep 2015' between EffectiveFromDateTime and EffectiveToDateTime 
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) 
						--- OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL) may have to uncomment
						)
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL) OR (unx.UniDate IS NULL and  un.UniDate IS NOT NULL))
				)



select x.* 
-- into #missedaccounts
from bi.FDSF_TDTAAccLinkingFactDataDelta x (nolock)
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey
where not exists (select top 1 1 from 
					bi.FDSF_TDTAAccLinkingFactData (nolock) z 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
					where z.RunId=5454 and z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) 
					--- OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL)  may have to uncomment
						)
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL) OR (unx.UniDate IS NOT NULL and  un.UniDate IS NULL)) -- required cause of bugs in prod. un.UniDate is somrtimes null when it should not be
				 )
and '31 Oct 2015' between x.EffectiveFromDateTime and x.EffectiveToDateTime and x.IsDeleted = 0

select z.* 
from bi.FDSF_TDTAAccLinkingFactData (nolock) z 
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
where z.RunId=5454
and not exists (select top 1 1 
					from bi.FDSF_TDTAAccLinkingFactDataDelta x 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey

					where z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					-- and z.Latest_Account_Number = x.Latest_Account_Number
					and  '31 Oct 2015' between EffectiveFromDateTime and EffectiveToDateTime 
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) 
						--- OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL) may have to uncomment
						)
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL) OR (unx.UniDate IS NULL and  un.UniDate IS NOT NULL))
				)






select x.* 
-- into #missedaccounts
from bi.FDSF_TDTAAccLinkingFactDataDelta x (nolock)
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey
where not exists (select top 1 1 from 
					bi.FDSF_TDTAAccLinkingFactData (nolock) z 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
					where z.RunId=5458 and z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) 
					--- OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL)  may have to uncomment
						)
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL) 
							OR (unx.UniDate IS NOT NULL and  un.UniDate IS NULL)  -- required cause of bugs in prod. un.UniDate is sometimes null when it should not be
						) 
				 )
and '30 Nov 2015' between x.EffectiveFromDateTime and x.EffectiveToDateTime and x.IsDeleted = 0

select z.* 
from bi.FDSF_TDTAAccLinkingFactData (nolock) z 
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
where z.RunId=5458
and not exists (select top 1 1 
					from bi.FDSF_TDTAAccLinkingFactDataDelta x 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey

					where z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					-- and z.Latest_Account_Number = x.Latest_Account_Number
					and  '30 Nov 2015' between EffectiveFromDateTime and EffectiveToDateTime 
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) 
						--- OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL) may have to uncomment
						)
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL) 
						OR (unx.UniDate IS NULL and  un.UniDate IS NOT NULL)  -- required cause of bugs in prod. un.UniDate is sometimes null when it should not be
					)
				)




select x.* 
-- into #missedaccounts
from bi.FDSF_TDTAAccLinkingFactDataDelta x (nolock)
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey
where not exists (select top 1 1 from 
					bi.FDSF_TDTAAccLinkingFactData (nolock) z 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
					where z.RunId=7338 and z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) 
					--- OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL)  may have to uncomment
						)
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL) 
							OR (unx.UniDate IS NOT NULL and  un.UniDate IS NULL)  -- required cause of bugs in prod. un.UniDate is sometimes null when it should not be
						) 
				 )
and '31 Dec 2015' between x.EffectiveFromDateTime and x.EffectiveToDateTime and x.IsDeleted = 0

select z.* 
from bi.FDSF_TDTAAccLinkingFactData (nolock) z 
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
where z.RunId=7338
and not exists (select top 1 1 
					from bi.FDSF_TDTAAccLinkingFactDataDelta x 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey

					where z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					-- and z.Latest_Account_Number = x.Latest_Account_Number
					and  '31 Dec 2015' between EffectiveFromDateTime and EffectiveToDateTime 
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) 
						--- OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL) may have to uncomment
						)
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL) 
						OR (unx.UniDate IS NULL and  un.UniDate IS NOT NULL)  -- required cause of bugs in prod. un.UniDate is sometimes null when it should not be
					)
				)






select x.* 
-- into #missedaccounts
from bi.FDSF_TDTAAccLinkingFactDataDelta x (nolock)
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey
where not exists (select top 1 1 from 
					bi.FDSF_TDTAAccLinkingFactData (nolock) z 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
					where z.RunId=48463 and z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) 
					--- OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL)  may have to uncomment
						)
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL) 
							OR (unx.UniDate IS NOT NULL and  un.UniDate IS NULL)  -- required cause of bugs in prod. un.UniDate is sometimes null when it should not be
						) 
				 )
and '31 Jan 2016' between x.EffectiveFromDateTime and x.EffectiveToDateTime and x.IsDeleted = 0

select z.* 
from bi.FDSF_TDTAAccLinkingFactData (nolock) z 
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
where z.RunId=48463
and not exists (select top 1 1 
					from bi.FDSF_TDTAAccLinkingFactDataDelta x 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey

					where z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					-- and z.Latest_Account_Number = x.Latest_Account_Number
					and  '31 Jan 2016' between EffectiveFromDateTime and EffectiveToDateTime 
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) 
						--- OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL) may have to uncomment
						)
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL) 
						OR (unx.UniDate IS NULL and  un.UniDate IS NOT NULL)  -- required cause of bugs in prod. un.UniDate is sometimes null when it should not be
					)
				)





select x.* 
-- into #missedaccounts
from bi.FDSF_TDTAAccLinkingFactDataDelta x (nolock)
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey
where not exists (select top 1 1 from 
					bi.FDSF_TDTAAccLinkingFactData (nolock) z 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
					where z.RunId=62928 and z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) 
					--- OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL)  may have to uncomment
						)
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL) 
							OR (unx.UniDate IS NOT NULL and  un.UniDate IS NULL)  -- required cause of bugs in prod. un.UniDate is sometimes null when it should not be
						) 
				 )
and '29 Feb 2016' between x.EffectiveFromDateTime and x.EffectiveToDateTime and x.IsDeleted = 0

select z.* 
from bi.FDSF_TDTAAccLinkingFactData (nolock) z 
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
where z.RunId=62928
and not exists (select top 1 1 
					from bi.FDSF_TDTAAccLinkingFactDataDelta x 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey

					where z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					-- and z.Latest_Account_Number = x.Latest_Account_Number
					and  '29 Feb 2016' between EffectiveFromDateTime and EffectiveToDateTime 
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) 
						--- OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL) may have to uncomment
						)
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL) 
						OR (unx.UniDate IS NULL and  un.UniDate IS NOT NULL)  -- required cause of bugs in prod. un.UniDate is sometimes null when it should not be
					)
				)


--
-- Mar 2016 reconciliation
--

select x.* 
-- into #missedaccounts
from bi.FDSF_TDTAAccLinkingFactDataDelta x (nolock)
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey
where not exists (select top 1 1 from 
					bi.FDSF_TDTAAccLinkingFactData (nolock) z 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
					where z.RunId=119747 and z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) 
					--- OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL)  may have to uncomment
						)
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL) 
							OR (unx.UniDate IS NOT NULL and  un.UniDate IS NULL)  -- required cause of bugs in prod. un.UniDate is sometimes null when it should not be
						) 
				 )
and '31 Mar 2016' between x.EffectiveFromDateTime and x.EffectiveToDateTime and x.IsDeleted = 0

select z.* 
from bi.FDSF_TDTAAccLinkingFactData (nolock) z 
left join bi.ActiveAccountStartDateAttrSCD adx
on adx.ActiveAccountStartDateAttrKeyID = z.ActiveAccountStartDateKey
left join bi.OriginalAccountStartDateAttrSCD osx
on osx.OriginalAccountStartDateAttrKeyID = z.OriginalAccountStartDateIDKey
left join bi.UniDateSCD unx
on unx.UniDateAttrKeyID = z.LogicalAccountPurgeDateKey
where z.RunId=119747
and not exists (select top 1 1 
					from bi.FDSF_TDTAAccLinkingFactDataDelta x 
					left join bi.ActiveAccountStartDateAttrSCD ad
					on ad.ActiveAccountStartDateAttrKeyID = x.ActiveAccountStartDateKey
					left join bi.OriginalAccountStartDateAttrSCD os
					on os.OriginalAccountStartDateAttrKeyID = x.OriginalAccountStartDateIDKey
					left join bi.UniDateSCD un
					on un.UniDateAttrKeyID = x.LogicalAccountPurgeDateKey

					where z.LogicalAccountKeyNo = x.LogicalAccountKeyNo and z.CounterpartyIDKey=x.CounterpartyIDKey
					-- and z.Latest_Account_Number = x.Latest_Account_Number
					and  '31 Mar 2016' between EffectiveFromDateTime and EffectiveToDateTime 
					and osx.Original_Account_Start_Date = os.Original_Account_Start_Date
					and adx.Active_Account_Start_Date = ad.Active_Account_Start_Date
					and ((z.Latest_Account_Number = x.Latest_Account_Number) 
						--- OR (z.Latest_Account_Number IS NULL and  x.Latest_Account_Number IS NOT NULL) may have to uncomment
						)
					and ((unx.UniDate = un.UniDate) OR (unx.UniDate IS NULL and  un.UniDate IS NULL) 
						OR (unx.UniDate IS NULL and  un.UniDate IS NOT NULL)  -- required cause of bugs in prod. un.UniDate is sometimes null when it should not be
					)
				)



				select count(*) 
				from bi.FDSF_TDTAAccLinkingFactDataDelta(nolock) x
				where '31 JUl 2015' between x.EffectiveFromDateTime and x.EffectiveToDateTime 
				and x.IsDeleted=0


				select count(*) 
				from bi.FDSF_TDTAAccLinkingFactData(nolock) x
				where x.RunID=5093
				--where '29 Feb 2016' between x.EffectiveFromDateTime and x.EffectiveToDateTime 
				--and x.IsDeleted=0








select count(*) from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA

select top 100 * from bi.FDSF_TDTAAccLinkingFactDataDelta where EffectiveFromDateTime > = '31 Jul 2015'
select top 100 * from bi.FDSF_TDTAAccLinkingFactDataDelta where RunIDUpdated =  95258
select * from bi.FDSF_TDTAAccLinkingFactDataDelta where LogicalAccountKeyNo = 4929535174938

--Thread 5 - Msg 2627, Level 14, State 1, Procedure [bi].[uspLoadFDSF_TDTAAccLinkingFactDataDeltaChunk], Line 433 Violation of PRIMARY KEY constraint 'PK_bi_FDSF_TDTAAccLinkingFactDataDeltax'. Cannot insert duplicate key in object 'bi.FDSF_TDTAAccLinkingFactDataDelta'. The duplicate key value is (4929734346899, 30190918, 60124).
--PROC.ERROR: Msg 2627, Level 14, State 1, Procedure [bi].[uspLoadFDSF_TDTAAccLinkingFactDataDeltaChunk], Line 433 Violation of PRIMARY KEY constraint 'PK_bi_FDSF_TDTAAccLinkingFactDataDeltax'. Cannot insert duplicate key in object 'bi.FDSF_TDTAAccLinkingFactDataDelta'. The duplicate key value is (4929734346899, 30190918, 60124).
--TRANSACTION.ACTION: FULL ROLLBACK: Msg 2627, Level 14, State 1, Procedure [bi].[uspLoadFDSF_TDTAAccLinkingFactDataDeltaChunk], Line 433 Violation of PRIMARY KEY constraint 'PK_bi_FDSF_TDTAAccLinkingFactDataDeltax'. Cannot insert duplicate key in object 'bi.FDSF_TDTAAccLinkingFactDataDelta'. The duplicate key value is (4929734346899, 30190918, 60124).

select top 199 * from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA
where Logical_Account_Key_Num = '4929995876212'
select top 100 * from bi.CounterpartyIDAttrSCD where CounterpartyIDAttrKeyID = 19119243
select top 100 * from bi.CounterpartyIDAttrSCD where CounterPartyID in ( '4929102440318008')

-- select top 199 * from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA where RowID=32633947

-- duplicate atoms
select * from ref.AtomValue
where Run=60124
and SourceRowID in (32633947,32329497, 39083105, 34898164)


-- ok no duplicates
select * from ref.AtomValue
where Run=60124
and SourceRowID in (24319210, 1182303)





select * from  stg.BARCLAYCARD_ACCOUNT_LINKING mast where Run=5093 and Logical_Account_Key_Num = 4929808754309
and not exists
( select top 1  1 from
		(
		SELECT  x.LogicalAccountKeyNo, x.CounterpartyID, x.Original_Account_Start_Date, x.Active_Account_Start_Date,
		x.Latest_Account_Number, x.Logical_Account_Purge_Date, x.Active_Account_End_Date, x.SourceRowID,
		x.RunID         ----- 10 minutes
		FROM stg.vwFDSF_TDTAAccLinkingFactDataDelta x
		WHERE '31 Jul 2015' BETWEEN x.EffectiveFromDateTime AND x.EffectiveToDateTime
		and LogicalAccountKeyNo=4929808754309
		) child
		where (child.Logical_Account_Purge_Date = mast.Logical_Account_Purge_Date 
						OR child.Logical_Account_Purge_Date IS NULL AND IIF(LEN(LTRIM(RTRIM(mast.Logical_Account_Purge_Date))) = 0, NULL, mast.Logical_Account_Purge_Date) IS NULL
					  )

)


and (child.Logical_Account_Purge_Date = mast.Logical_Account_Purge_Date 
						OR child.Logical_Account_Purge_Date IS NULL AND IIF(LEN(LTRIM(RTRIM(mast.Logical_Account_Purge_Date))) = 0, NULL, mast.Logical_Account_Purge_Date) IS NULL
					  )



					  select top 1000 * from ref.AtomValue (nolock) where Run=95258 and AtomValueTYpeID=519
					  and Value=24187062
					  AtomValueID	AtomID	AtomTypeID	AtomValueTypeID	AtomValueCategoryID	AtomValueExtentID	EffectiveFromDateTime	AppliedFromDateTime	CurrencyCode	Value	Run	SourceRowID
					  7402206569	576765023	553	519	1	1	2015-07-31 00:00:00.000	2016-03-22 14:21:28.907	GBP	24187062.00000000	95258	7500001


					  select top 1000 * from ref.AtomValue (nolock) where Run=95258 and AtomID= 576765023
					  and SourceRowID = 7500001

					  select * from ref.Atom  where AtomID=576765023
					  select * from ref.Atom  where AtomID=576765023

					  'ActiveAccountStartDateAttr-CounterPartyIdAttr-LogicalAccountPurgeDateAttr-OriginalAccountStartDateAttr'
					   select top 1000 * from ref.AtomTYpe (nolock) where AtomTypeID=553
					  sp_help 'ref.AtomValue'


					  select top 100 * from ref.AtomValueType where AtomValueTypeCode like '%Original%'

					  select top 100 * from #missedaccounts where LogicalAccountKeyNo = 4929811522842

					  select * from bi.FDSF_TDTAAccLinkingFactDataDelta where LogicalAccountKeyNo = 4929811522842

					  select * from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA where Logical_Account_Key_Num = 4929811522842
					  and Run=95258

					  
					   select top 100 m.*, d.RowID 
					   from #missedaccounts m
					   inner join stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA d
					   on d.Logical_Account_Key_Num = m.LogicalAccountKeyNo
					   where d.Run=95258
					   and not d.RowID between 7500001 and 8000000

					   select x.* from bi.FDSF_TDTAAccLinkingFactDataDelta x
					   where EffectiveFromDateTime = '30 Apr 2015' 
					   and LogicalAccountKeyNo=4929836797452

					   select d.* from 
					   stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA d
					   where d.Logical_Account_Key_Num in ( 4929836797452 )
					   and d.Run=95258

					   -- 8000001 EndRow : 8500000
					   -- StartRow : 7500001 EndRow : 8000000

					   -- check in any rows in 7500001 to  8000000 updated successfully
					  select d.RowID , x.*
					  from bi.FDSF_TDTAAccLinkingFactDataDelta x
					  inner join  stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA d
					  on d.Logical_Account_Key_Num = x.LogicalAccountKeyNo
					  and d.Run=95258 and d.RowID between 7500001 and 8000000
					  where x.EffectiveFromDateTime =  '31 Jul 2015'

					  select x.* from bi.FDSF_TDTAAccLinkingFactDataDelta x
					  where LogicalAccountKeyNo=4929836797452 and EffectiveFromDateTime = '31 Jul 2015'

					  select * from  #missedaccounts where LogicalAccountKeyNo = 4929836797452
					  select * from mapping.Mapping where EntityKey = 41047942
					  select d.* from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA d
					  where d.Run=95258 and RowID between 8000000 and 8000002

					  select count(*) from Phil.FDSF_TDTAAccLinkingFactDataDelta_Jul2015
					  select count(*) from bi.FDSF_TDTAAccLinkingFactDataDelta

select top 100 x.*
from
(
					   SELECT av.AtomValueID, av.value, av.SourceRowID, av.Run, av.CurrencyCode, av.AtomValueTypeID, av.EffectiveFromDateTime, av.AppliedFromDateTime, av.AtomID,
av.AtomtypeID, av.AtomValueCategoryID, av.AtomValueExtentID,
-- ROW_NUMBER() OVER ( PARTITION BY av.value, av.SourceRowID, av.Run, av.CurrencyCode, av.AtomValueTypeID, av.EffectiveFromDateTime order by av.AtomID asc) as cnt  16 minutes
ROW_NUMBER() OVER ( PARTITION BY av.Run, av.SourceRowID, av.AtomValueTypeID, av.AtomValueExtentID, av.value,  av.CurrencyCode, av.EffectiveFromDateTime, av.AtomTypeID, av.AtomValueCategoryID order by av.AtomID asc) as cnt -- 15 mins, ?? mins excluding certain atomvaluetypes with
FROM ref.atomvalue av
INNER JOIN ref.AtomValueType avt
ON avt.AtomValueTypeID = av.AtomValueTypeID
WHERE av.Run = 95258 and ( avt.AtomValueTypeCode != 'RunFullOriginal' and  avt.AtomValueTypeCode != 'RowIDFullOriginal' )
AND SourceRowID BETWEEN 8000001 AND 8500000 -- 32633947
) x
where x.cnt = 1
and x.SourceRowID in (8000001,8000002, 8000020)

select * from bi.FDSF_TDTAAccLinkingFactDataDElta where LogicalAccountKeyNo = 4929836797783


select d.* 
from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA d
where d.Run= 95258
and RowID between 7700001 and 7800005


select d.* 
from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA d
where d.Run= 95258
and Logical_Account_Key_Num = 4929808754309


select * from bi.FDSF_TDTAAccLinkingFactDataDElta
where LogicalAccountKeyNo = 4929808754309