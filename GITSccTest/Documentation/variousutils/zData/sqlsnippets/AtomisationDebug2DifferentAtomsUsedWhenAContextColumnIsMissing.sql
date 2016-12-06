drop table #refAtomValue

CREATE TABLE #refAtomValue(
			AtomValueID int  NOT NULL,
			AtomID int NOT NULL,
			AtomTypeID smallint NULL,
			AtomValueTypeID int NOT NULL,
			AtomValueCategoryID int NOT NULL,
			AtomValueExtentID int NOT NULL,
			EffectiveFromDateTime datetime NULL,
			AppliedFromDateTime datetime NOT NULL,
			CurrencyCode char(3) NOT NULL,
			Value decimal(28, 8) NOT NULL,
			Run int NOT NULL,
			SourceRowID int NOT NULL)

		INSERT INTO #refAtomValue
		SELECT av.*
		FROM ref.atomvalue av (NOLOCK)
		WHERE av.Run = 5000011
		AND SourceRowID BETWEEN 576400 AND 576429



DECLARE @DesiredParticles TABLE (ParticleTypeId int,EntityTypeId int, PRIMARY KEY (ParticleTypeID ASC, EntityTypeID ASC))

		INSERT INTO @DesiredParticles
		SELECT ParticleTypeID,EntityTypeID
		FROM ref.ParticleType pt (NOLOCK)
		WHERE pt.ParticleTypeCode in ('ECGoodBadFlagAttr', 'PortfolioIdAttr','ReportingPeriodAttr')

		DECLARE @DesiredAtoms TABLE (AtomValueTypeId INT PRIMARY KEY,AtomValueTypeCode VARCHAR(100))

		INSERT INTO @DesiredAtoms(AtomValueTypeId,AtomValueTypeCode)
		SELECT AtomValueTypeId,AtomValueTypeCode
		FROM ref.AtomValueType (NOLOCK)
		WHERE AtomValueTypeCode in ('EconomicCapitalGroupC')

		IF object_id(N'tempdb.dbo.#Atomtemp') is NOT NULL
		DROP TABLE #Atomtemp

		CREATE TABLE #AtomTemp
		(
			EntityTypeName	VARCHAR(64)
			,value  DECIMAL(18,5)
			,CurrencyCode CHAR(3)
			,AtomValueTypeCode VARCHAR(256)
			,Run	INT
			,SourceRowID	INT
			,ParticleKey	INT
		)

		

		SELECT EntityTypeName
			   ,value
			   ,CurrencyCode
			   ,avt.AtomValueTypeCode
			   ,av.Run
			   ,SourceRowID
			   ,ParticleKey
			   ,av.AtomID
			   ,ap.ParticleTypeID
			   ,refpt.*
			   ,refat.*
		FROM #refAtomValue av 
			   INNER JOIN ref.AtomParticle ap (NOLOCK)
			   ON av.AtomID = ap.AtomID
			   INNER JOIN @DesiredParticles pt 
			   ON pt.ParticleTypeID = ap.ParticleTypeID 
			   INNER JOIN entity.EntityType et (NOLOCK)
			   ON et.EntityTypeID = pt.EntityTypeID
			   INNER JOIN @DesiredAtoms avt 
			   ON avt.AtomValueTypeID = av.AtomValueTypeID 
			   inner join ref.ParticleType refpt
			   on refpt.ParticleTypeId = ap.ParticleTypeID
			   inner join ref.AtomType refat
			   on refat.AtomTypeID  = av.AtomTypeID
		WHERE EntityTypeName = 'ECGoodBadFlagAttr'