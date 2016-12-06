


 CREATE TABLE #NewIntoForbearance
            (
                RowId   BIGINT     NOT NULL,
                Run     BIGINT     NOT NULL,
                Account_Number  VARCHAR(255) NULL,
                Division        VARCHAR(255) NULL,
                [Account_Open_Month]    VARCHAR(255) NULL,
                [Account_Open_Balance]  VARCHAR(255) NULL
            )
            
            INSERT INTO #NewIntoForbearance
            SELECT      base.SourceRowIdBase, 
                        base.RunId,
                        cpt.CounterpartyID AccountNo,
                        CASE WHEN pg.product_grp IN ('1', '4') THEN 'Motor' 
                             WHEN pg.product_grp IN ('2', '3') THEN 'Retail' 
                             ELSE 'Unknown' END Division,
                        CONCAT(UPPER(LEFT(DATENAME(MM, CAST(pcd.[PlanCreateDate] AS DATE)),3)),RIGHT(DATENAME(YY, CAST(pcd.[PlanCreateDate] AS DATE)),2)) Account_Open_Month,
                        CAST(base.netbalance_finance AS DECIMAL(28, 8)) [Account_Open_Balance]
            FROM        bi.GRCR_ImpairmentFactData base INNER JOIN
                        [bi].[ProductCodeSCD] pc ON pc.ProductCodeAttrKeyID = base.ProductCodeAttrKey AND pc.ChangeListId = base.ProductCodeAttrChangeListId INNER JOIN
                        bi.G1DebtpStatusAttrSCD g1 ON g1.G1DebtpStatusAttrKeyID = base.G1DebtpStatusAttrKey AND g1.ChangeListId = base.G1DebtpStatusAttrChangeListId INNER JOIN
                        bi.FipTypeAttrSCD fp ON fp.[FipTypeAttrKeyID] = base.FipTypeAttrKey AND fp.ChangeListId = base.FipTypeAttrChangeListId INNER JOIN
                        bi.BrokenInstallmentsAttrSCD bins ON bins.BrokenInstallmentsAttrKeyID = base.BrokenInstallmentsAttrKey AND bins.ChangeListId = base.BrokenInstallmentsAttrChangeListId INNER JOIN
                        bi.ChargeoffFlagAttrSCD co ON co.ChargeoffFlagAttrKeyID = base.ChargeoffFlagAttrKey AND co.ChangeListId = base.ChargeoffFlagAttrChangeListId INNER JOIN
                        [bi].[ImpairFlagAttrSCD] ifg ON ifg.ChangeListId = base.ImpairFlagAttrChangeListId AND ifg.ImpairFlagAttrKeyID = base.ImpairFlagAttrKey INNER JOIN
                        [bi].[ProductGrpAttrSCD] pg ON pg.ChangeListId = base.ProductGrpAttrChangeListId AND pg.ProductGrpAttrKeyID = base.ProductGrpAttrKey INNER JOIN
                        --[bi].[GripArrearsLevelAttrSCD] gr ON gr.GripArrearsLevelAttrKeyID = base.GripArrearsLevelAttrKey AND gr.ChangeListId = base.GripArrearsLevelAttrChangeListId INNER JOIN
                        bi.CounterpartyIDAttrSCD cpt ON cpt.CounterpartyIDAttrKeyID = base.CounterPartyIdAttrKey AND cpt.ChangeListId = base.CounterPartyIdAttrChangeListId INNER JOIN
                        bi.PlanCreateDateAttrSCD pcd ON pcd.PlanCreateDateAttrKeyID = base.PlanCreateDateAttrKey AND pcd.ChangeListId = base.PlanCreateDateAttrChangeListId INNER JOIN
                        loader.JobRun JR ON base.RunId = Jr.run INNER JOIN
                        loader.Job J ON JR.JobId = J.JobID
            WHERE      base.netbalance_finance IS NOT NULL 
                AND pc.[ProductCode] IS NOT NULL 
                AND g1.[G1DebtpStatus] = 'L' 
                AND fp.FipType = 'BSR' 
                AND bins.BrokenInstallments = '0' 
                AND co.coff_flag <> '1' 
                AND ifg.impair_flag IN ('Core Non-repayment', 'Core Repayment', 'Out-of_scope-other') 
                AND MONTH(CAST(pcd.[PlanCreateDate] AS DATE)) = MONTH(J.CobDate) 
                AND YEAR(CAST(pcd.[PlanCreateDate] AS DATE)) = YEAR(J.CobDate)
                AND base.RunID = @p_Run