
-- delete script
-- to remove two different  atoms which have AtomTypeCode crested the wrong way round
-- i.e created wrong way round in the AtomisationConfig script.  i'e 'DecDateAttr-AccountEntityAttr'
-- But then the atomisation will re-create some of the config the correct way i.e 'AccountEntityAttr-DecDateAttr'
-- for AtomTypeCode on ref.AtomTypeTable
-- 

-- specific entity and SCD table here
drop table #rowstodelete
begin tran
	delete from entity.IncomeMonth_Attr
	

	delete entity.History where EntityTypeID = 225

	select ChangeListID into #rowstodelete from bi.IncomeMonthAttrSCD

	
	delete from bi.IncomeMonthAttrSCD

	-- can only delete if ChangeListID is not used on any other SCD table
	-- try uncommenting out tranaction and deletes blelow and running to rollback.
	--  if foreign key violation then cannot run the deletes
	--
	delete [bi].[ChangeListItem] where ChangeListId in (select ChangeListId from #rowstodelete)
	delete [bi].[ChangeList] where ChangeListId in (select ChangeListId from #rowstodelete)
	
	
	
	-- rollback
	
	-- select * from entity.EntityType where EntityTypeCode like '%AccountEntityAttr%'  (get the entityTypeID from here, all deletes flow from related keys )

	-- select top 100 * from ref.AtomType where AtomTypeCode like '%AccountEntityAttr%'  (get the AtomTypeID from here, all deletes flow from related keys
	 delete from mapping.MappingValue where entityTypeid = 225
  delete from mapping.Mapping where entityTypeid = 225
 

 delete from ref.AtomValue where  AtomTypeId in (346)
 
 delete from ref.AtomTypeParticleType where AtomTypeiD in (346,344)

 delete ref.AtomParticle where  AtomTypeID in (344)
 delete from ref.Atom where  AtomTypeID in (344)
delete from ref.AtomType where AtomTypeiD = 344



-- select * from 
delete from ref.AtomParticle where  ParticleTYpeID IN (-5)
delete from ref.ParticleType where ParticleTYpeID IN (-9)



-- select * from ref.AtomTypeParticleType where AtomTYpeID = 344
-- select * from 

--select * from entity.AccountEntity_Attr

--select * from entity.History where historykey in (756512,756659)

rollback

commit
-- select * from bi.DimensionType order by code