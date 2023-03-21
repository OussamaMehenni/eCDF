/// <summary>
/// Report Print VAT Declaration (ID 50903).
/// </summary>
report 50903 "Print VAT Declaration"
{
    ApplicationArea = All;
    Caption = 'Print VAT Declaration';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Word;
    WordMergeDataItem = eCDFData;
    dataset
    {
        dataitem(eCDFData; "eCDF Data")
        {
            DataItemTableView = SORTING("Statement Template Name", "Statement Name", "Starting Date", "Ending Date", Version, "Line No.");

            trigger OnPreDataItem()

            var
                lInt: Integer;
            begin
                if "Data Type" = eCDFData."Data Type"::Percent then begin
                    if EVALUATE(lInt, COPYSTR("Row No.", 2)) then begin
                        TotalAmount := "Calculated Value" + "Correction Amount";
                        if TotalAmount <> 0 then
                            EVALUATE(lTableau[lInt], FORMAT(TotalAmount, 0, '<Sign><Integer><Decimals,3>'))
                        else
                            lTableau[lInt] := '';
                    end;
                end;
            end;

            trigger OnAfterGetRecord()
            var
                lInt: Integer;
            begin
                if "Data Type" = eCDFData."Data Type"::Percent then begin
                    if EVALUATE(lInt, COPYSTR("Row No.", 2)) then begin
                        TotalAmount := "Calculated Value" + "Correction Amount";
                        if TotalAmount <> 0 then
                            EVALUATE(lTableau[lInt], FORMAT(TotalAmount, 0, '<Sign><Integer><Decimals,3>'))
                        else
                            lTableau[lInt] := '';
                    end;
                end;

                if "Data Type" = eCDFData."Data Type"::Numeric then begin
                    if EVALUATE(lInt, COPYSTR("Row No.", 2)) then begin
                        TotalAmount := "Calculated Value" + "Correction Amount";
                        if TotalAmount <> 0 then
                            EVALUATE(lTableau[lInt], FORMAT(TotalAmount, 0, '<Sign><Integer><Decimals,3>'))
                        else
                            lTableau[lInt] := '';
                    end;

                    //<<BEGIN: Appendix to Operational expenditures - C411/C412/C413 lines with C414/C415 total process
                    if ("Row No." = 'C411') then begin
                        gAppendixOpExpIdx := (gAppendixOpExpLine * 10) + 1;
                        EVALUATE(lTableau_C411_C412_C413[gAppendixOpExpIdx], FORMAT("Final Value"))
                    end else

                        if ("Row No." = 'C412') then begin
                            TotalAmount := "Calculated Value" + "Correction Amount";
                            gAppendixOpExpIdx := (gAppendixOpExpLine * 10) + 2;
                            if TotalAmount <> 0 then
                                EVALUATE(lTableau_C411_C412_C413[gAppendixOpExpIdx], FORMAT(TotalAmount, 0, '<Sign><Integer><Decimals,3>'))
                            ELSE
                                lTableau_C411_C412_C413[gAppendixOpExpIdx] := '';
                            gAppendixOpExpTotalC414 := gAppendixOpExpTotalC414 + TotalAmount;
                        end else
                            if ("Row No." = 'C413') then begin
                                TotalAmount := "Calculated Value" + "Correction Amount";
                                gAppendixOpExpIdx := (gAppendixOpExpLine * 10) + 3;
                                if TotalAmount <> 0 then
                                    EVALUATE(lTableau_C411_C412_C413[gAppendixOpExpIdx], FORMAT(TotalAmount, 0, '<Sign><Integer><Decimals,3>'))
                                else
                                    lTableau_C411_C412_C413[gAppendixOpExpIdx] := '';
                                gAppendixOpExpLine := gAppendixOpExpLine + 1;
                                gAppendixOpExpTotalC415 := gAppendixOpExpTotalC415 + TotalAmount;
                            end else
                                if ("Row No." = 'C414') then begin
                                    if EVALUATE(lInt, COPYSTR("Row No.", 2)) then begin
                                        if gAppendixOpExpTotalC414 <> 0 then
                                            EVALUATE(lTableau[lInt], FORMAT(gAppendixOpExpTotalC414, 0, '<Sign><Integer><Decimals,3>'))
                                        else
                                            lTableau[lInt] := '';
                                    end;
                                end else
                                    if ("Row No." = 'C415') then begin
                                        if EVALUATE(lInt, COPYSTR("Row No.", 2)) then begin
                                            if gAppendixOpExpTotalC415 <> 0 then
                                                EVALUATE(lTableau[lInt], FORMAT(gAppendixOpExpTotalC415, 0, '<Sign><Integer><Decimals,3>'))
                                            ELSE
                                                lTableau[lInt] := '';
                                        end;
                                    end;
                    //END: Appendix to Operational expenditures>>
                end;

                if "Data Type" = eCDFData."Data Type"::Integer then begin
                    if EVALUATE(lInt, COPYSTR("Row No.", 2)) then begin
                        TotalAmount := "Calculated Value" + "Correction Amount";
                        EVALUATE(lTableau[lInt], FORMAT(TotalAmount, 0, '<Sign><Integer><Decimals,3>'));
                    end;
                end;

                if "Data Type" = eCDFData."Data Type"::Boolean then begin
                    if EVALUATE(lInt, COPYSTR("Row No.", 2)) then
                        if (eCDFData."Row No." = 'C204') AND (eCDFData."Final Value" = '1') then
                            EVALUATE(lTableau[204], 'X');
                    if (eCDFData."Row No." = 'C205') AND (eCDFData."Final Value" = '1') then
                        EVALUATE(lTableau[205], 'X');
                    if (eCDFData."Row No." = 'C998') AND (eCDFData."Final Value" = '1') then
                        EVALUATE(lTableau[998], 'X');
                    if (eCDFData."Row No." = 'C999') AND (eCDFData."Final Value" = '1') then
                        EVALUATE(lTableau[999], 'X');
                end;

                if "Data Type" = eCDFData."Data Type"::Alphanumeric then begin
                    if (("Row No." = 'C397') OR ("Row No." = 'C398') OR ("Row No." = 'C399') OR ("Row No." = 'C400') OR ("Row No." = 'C401') OR ("Row No." = 'C402')) THEN BEGIN
                        if EVALUATE(lInt, COPYSTR("Row No.", 2)) then
                            EVALUATE(lTableau[lInt], FORMAT(eCDFData."Final Value"));
                    end;
                end;
            end;

        }

        dataitem("Integer"; 2000000026)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(C012; lTableau[12])
            {
            }
            column(C204; lTableau[204])
            {
            }
            column(C205; lTableau[205])
            {
            }
            column(C454; lTableau[454])
            {
            }
            column(C455; lTableau[455])
            {
            }
            column(C456; lTableau[456])
            {
            }
            column(C021; lTableau[21])
            {
            }
            column(C457; lTableau[457])
            {
            }
            column(C014; lTableau[14])
            {
            }
            column(C015; lTableau[15])
            {
            }
            column(C016; lTableau[16])
            {
            }
            column(C017; lTableau[17])
            {
            }
            column(C018; lTableau[18])
            {
            }
            column(C423; lTableau[423])
            {
            }
            column(C424; lTableau[424])
            {
            }
            column(C226; lTableau[226])
            {
            }
            column(C019; lTableau[19])
            {
            }
            column(C419; lTableau[419])
            {
            }
            column(C022; lTableau[22])
            {
            }
            column(C037; lTableau[37])
            {
            }
            column(C046; lTableau[46])
            {
            }
            column(C701; lTableau[701])
            {
            }
            column(C702; lTableau[702])
            {
            }
            column(C029; lTableau[29])
            {
            }
            column(C038; lTableau[38])
            {
            }
            column(C703; lTableau[703])
            {
            }
            column(C704; lTableau[704])
            {
            }
            column(C032; lTableau[32])
            {
            }
            column(C041; lTableau[41])
            {
            }
            column(C705; lTableau[705])
            {
            }
            column(C706; lTableau[706])
            {
            }
            column(C030; lTableau[30])
            {
            }
            column(C039; lTableau[39])
            {
            }
            column(C031; lTableau[31])
            {
            }
            column(C040; lTableau[40])
            {
            }
            column(C403; lTableau[403])
            {
            }
            column(C033; lTableau[33])
            {
            }
            column(C042; lTableau[42])
            {
            }
            column(C418; lTableau[418])
            {
            }
            column(C416; lTableau[416])
            {
            }
            column(C417; lTableau[417])
            {
            }
            column(C453; lTableau[453])
            {
            }
            column(C451; lTableau[451])
            {
            }
            column(C452; lTableau[452])
            {
            }
            column(C051; lTableau[51])
            {
            }
            column(C056; lTableau[56])
            {
            }
            column(C711; lTableau[711])
            {
            }
            column(C712; lTableau[712])
            {
            }
            column(C047; lTableau[47])
            {
            }
            column(C052; lTableau[52])
            {
            }
            column(C713; lTableau[713])
            {
            }
            column(C714; lTableau[714])
            {
            }
            column(C050; lTableau[50])
            {
            }
            column(C055; lTableau[55])
            {
            }
            column(C715; lTableau[715])
            {
            }
            column(C716; lTableau[716])
            {
            }
            column(C048; lTableau[48])
            {
            }
            column(C053; lTableau[53])
            {
            }
            column(C049; lTableau[49])
            {
            }
            column(C054; lTableau[54])
            {
            }
            column(C194; lTableau[194])
            {
            }
            column(C152; lTableau[152])
            {
            }
            column(C065; lTableau[65])
            {
            }
            column(C407; lTableau[407])
            {
            }
            column(C721; lTableau[721])
            {
            }
            column(C722; lTableau[722])
            {
            }
            column(C057; lTableau[57])
            {
            }
            column(C066; lTableau[66])
            {
            }
            column(C723; lTableau[723])
            {
            }
            column(C724; lTableau[724])
            {
            }
            column(C060; lTableau[60])
            {
            }
            column(C069; lTableau[69])
            {
            }
            column(C725; lTableau[725])
            {
            }
            column(C726; lTableau[726])
            {
            }
            column(C058; lTableau[58])
            {
            }
            column(C067; lTableau[67])
            {
            }
            column(C059; lTableau[59])
            {
            }
            column(C068; lTableau[68])
            {
            }
            column(C195; lTableau[195])
            {
            }
            column(C731; lTableau[731])
            {
            }
            column(C732; lTableau[732])
            {
            }
            column(C061; lTableau[61])
            {
            }
            column(C071; lTableau[71])
            {
            }
            column(C733; lTableau[733])
            {
            }
            column(C734; lTableau[734])
            {
            }
            column(C064; lTableau[64])
            {
            }
            column(C074; lTableau[74])
            {
            }
            column(C735; lTableau[735])
            {
            }
            column(C736; lTableau[736])
            {
            }
            column(C062; lTableau[62])
            {
            }
            column(C072; lTableau[72])
            {
            }
            column(C063; lTableau[63])
            {
            }
            column(C073; lTableau[73])
            {
            }
            column(C196; lTableau[196])
            {
            }
            column(C409; lTableau[409])
            {
            }
            column(C410; lTableau[410])
            {
            }
            column(C436; lTableau[436])
            {
            }
            column(C462; lTableau[462])
            {
            }
            column(C741; lTableau[741])
            {
            }
            column(C742; lTableau[742])
            {
            }
            column(C427; lTableau[427])
            {
            }
            column(C428; lTableau[428])
            {
            }
            column(C743; lTableau[743])
            {
            }
            column(C744; lTableau[744])
            {
            }
            column(C433; lTableau[433])
            {
            }
            column(C434; lTableau[434])
            {
            }
            column(C745; lTableau[745])
            {
            }
            column(C746; lTableau[746])
            {
            }
            column(C429; lTableau[429])
            {
            }
            column(C430; lTableau[430])
            {
            }
            column(C431; lTableau[431])
            {
            }
            column(C432; lTableau[432])
            {
            }
            column(C435; lTableau[435])
            {
            }
            column(C463; lTableau[463])
            {
            }
            column(C464; lTableau[464])
            {
            }
            column(C751; lTableau[751])
            {
            }
            column(C752; lTableau[752])
            {
            }
            column(C437; lTableau[437])
            {
            }
            column(C438; lTableau[438])
            {
            }
            column(C753; lTableau[753])
            {
            }
            column(C754; lTableau[754])
            {
            }
            column(C443; lTableau[443])
            {
            }
            column(C444; lTableau[444])
            {
            }
            column(C755; lTableau[755])
            {
            }
            column(C756; lTableau[756])
            {
            }
            column(C439; lTableau[439])
            {
            }
            column(C440; lTableau[440])
            {
            }
            column(C441; lTableau[441])
            {
            }
            column(C442; lTableau[442])
            {
            }
            column(C445; lTableau[445])
            {
            }
            column(C765; lTableau[765])
            {
            }
            column(C766; lTableau[766])
            {
            }
            column(C761; lTableau[761])
            {
            }
            column(C762; lTableau[762])
            {
            }
            column(C420; lTableau[420])
            {
            }
            column(C421; lTableau[421])
            {
            }
            column(C767; lTableau[767])
            {
            }
            column(C768; lTableau[768])
            {
            }
            column(C763; lTableau[763])
            {
            }
            column(C764; lTableau[764])
            {
            }
            column(C222; lTableau[222])
            {
            }
            column(C223; lTableau[223])
            {
            }
            column(C227; lTableau[227])
            {
            }
            column(C076; lTableau[76])
            {
            }
            column(C093; lTableau[93])
            {
            }
            column(C458; lTableau[458])
            {
            }
            column(C459; lTableau[459])
            {
            }
            column(C460; lTableau[460])
            {
            }
            column(C090; lTableau[90])
            {
            }
            column(C461; lTableau[461])
            {
            }
            column(C092; lTableau[92])
            {
            }
            column(C228; lTableau[228])
            {
            }
            column(C097; lTableau[97])
            {
            }
            column(C094; lTableau[94])
            {
            }
            column(C095; lTableau[95])
            {
            }
            column(C102; lTableau[102])
            {
            }
            column(C103; lTableau[103])
            {
            }
            column(C104; lTableau[104])
            {
            }
            column(C105; lTableau[105])
            {
            }
            column(C237; lTableau[237])
            {
            }
            column(C110; lTableau[110])
            {
            }
            column(C108; lTableau[108])
            {
            }
            column(C109; lTableau[109])
            {
            }
            column(C192; lTableau[192])
            {
            }
            column(C193; lTableau[193])
            {
            }
            column(C239; lTableau[239])
            {
            }
            column(C240; lTableau[240])
            {
            }
            column(C114; lTableau[114])
            {
            }
            column(C241; lTableau[241])
            {
            }
            column(C242; lTableau[242])
            {
            }
            column(C243; lTableau[243])
            {
            }
            column(C244; lTableau[244])
            {
            }
            column(C245; lTableau[245])
            {
            }
            column(C246; lTableau[246])
            {
            }
            column(C247; lTableau[247])
            {
            }
            column(C248; lTableau[248])
            {
            }
            column(C249; lTableau[249])
            {
            }
            column(C250; lTableau[250])
            {
            }
            column(C251; lTableau[251])
            {
            }
            column(C252; lTableau[252])
            {
            }
            column(C253; lTableau[253])
            {
            }
            column(C254; lTableau[254])
            {
            }
            column(C255; lTableau[255])
            {
            }
            column(C256; lTableau[256])
            {
            }
            column(C257; lTableau[257])
            {
            }
            column(C258; lTableau[258])
            {
            }
            column(C259; lTableau[259])
            {
            }
            column(C260; lTableau[260])
            {
            }
            column(C261; lTableau[261])
            {
            }
            column(C262; lTableau[262])
            {
            }
            column(C263; lTableau[263])
            {
            }
            column(C264; lTableau[264])
            {
            }
            column(C265; lTableau[265])
            {
            }
            column(C266; lTableau[266])
            {
            }
            column(C267; lTableau[267])
            {
            }
            column(C268; lTableau[268])
            {
            }
            column(C269; lTableau[269])
            {
            }
            column(C270; lTableau[270])
            {
            }
            column(C271; lTableau[271])
            {
            }
            column(C272; lTableau[272])
            {
            }
            column(C273; lTableau[273])
            {
            }
            column(C274; lTableau[274])
            {
            }
            column(C275; lTableau[275])
            {
            }
            column(C276; lTableau[276])
            {
            }
            column(C277; lTableau[277])
            {
            }
            column(C278; lTableau[278])
            {
            }
            column(C279; lTableau[279])
            {
            }
            column(C280; lTableau[280])
            {
            }
            column(C281; lTableau[281])
            {
            }
            column(C282; lTableau[282])
            {
            }
            column(C283; lTableau[283])
            {
            }
            column(C284; lTableau[284])
            {
            }
            column(C183; lTableau[183])
            {
            }
            column(C184; lTableau[184])
            {
            }
            column(C285; lTableau[285])
            {
            }
            column(C286; lTableau[286])
            {
            }
            column(C287; lTableau[287])
            {
            }
            column(C288; lTableau[288])
            {
            }
            column(C289; lTableau[289])
            {
            }
            column(C290; lTableau[290])
            {
            }
            column(C291; lTableau[291])
            {
            }
            column(C292; lTableau[292])
            {
            }
            column(C293; lTableau[293])
            {
            }
            column(C294; lTableau[294])
            {
            }
            column(C295; lTableau[295])
            {
            }
            column(C296; lTableau[296])
            {
            }
            column(C297; lTableau[297])
            {
            }
            column(C298; lTableau[298])
            {
            }
            column(C299; lTableau[299])
            {
            }
            column(C300; lTableau[300])
            {
            }
            column(C301; lTableau[301])
            {
            }
            column(C302; lTableau[302])
            {
            }
            column(C303; lTableau[303])
            {
            }
            column(C304; lTableau[304])
            {
            }
            column(C305; lTableau[305])
            {
            }
            column(C306; lTableau[306])
            {
            }
            column(C185; lTableau[185])
            {
            }
            column(C186; lTableau[186])
            {
            }
            column(C307; lTableau[307])
            {
            }
            column(C308; lTableau[308])
            {
            }
            column(C309; lTableau[309])
            {
            }
            column(C310; lTableau[310])
            {
            }
            column(C311; lTableau[311])
            {
            }
            column(C312; lTableau[312])
            {
            }
            column(C313; lTableau[313])
            {
            }
            column(C314; lTableau[314])
            {
            }
            column(C315; lTableau[315])
            {
            }
            column(C316; lTableau[316])
            {
            }
            column(C317; lTableau[317])
            {
            }
            column(C318; lTableau[318])
            {
            }
            column(C319; lTableau[319])
            {
            }
            column(C320; lTableau[320])
            {
            }
            column(C321; lTableau[321])
            {
            }
            column(C322; lTableau[322])
            {
            }
            column(C323; lTableau[323])
            {
            }
            column(C324; lTableau[324])
            {
            }
            column(C325; lTableau[325])
            {
            }
            column(C326; lTableau[326])
            {
            }
            column(C327; lTableau[327])
            {
            }
            column(C328; lTableau[328])
            {
            }
            column(C329; lTableau[329])
            {
            }
            column(C330; lTableau[330])
            {
            }
            column(C331; lTableau[331])
            {
            }
            column(C332; lTableau[332])
            {
            }
            column(C333; lTableau[333])
            {
            }
            column(C334; lTableau[334])
            {
            }
            column(C335; lTableau[335])
            {
            }
            column(C336; lTableau[336])
            {
            }
            column(C337; lTableau[337])
            {
            }
            column(C338; lTableau[338])
            {
            }
            column(C115; lTableau[115])
            {
            }
            column(C187; lTableau[187])
            {
            }
            column(C188; lTableau[188])
            {
            }
            column(C189; lTableau[189])
            {
            }
            column(C343; lTableau[343])
            {
            }
            column(C344; lTableau[344])
            {
            }
            column(C345; lTableau[345])
            {
            }
            column(C346; lTableau[346])
            {
            }
            column(C347; lTableau[347])
            {
            }
            column(C348; lTableau[348])
            {
            }
            column(C349; lTableau[349])
            {
            }
            column(C350; lTableau[350])
            {
            }
            column(C351; lTableau[351])
            {
            }
            column(C352; lTableau[352])
            {
            }
            column(C353; lTableau[353])
            {
            }
            column(C354; lTableau[354])
            {
            }
            column(C355; lTableau[355])
            {
            }
            column(C356; lTableau[356])
            {
            }
            column(C357; lTableau[357])
            {
            }
            column(C358; lTableau[358])
            {
            }
            column(C359; lTableau[359])
            {
            }
            column(C361; lTableau[361])
            {
            }
            column(C362; lTableau[362])
            {
            }
            column(C190; lTableau[190])
            {
            }
            column(C191; lTableau[191])
            {
            }
            column(C389; lTableau[389])
            {
            }
            column(C363; lTableau[363])
            {
            }
            column(C364; lTableau[364])
            {
            }
            column(C365; lTableau[365])
            {
            }
            column(C367; lTableau[367])
            {
            }
            column(C381; lTableau[381])
            {
            }
            column(C382; lTableau[382])
            {
            }
            column(C368; lTableau[368])
            {
            }
            column(C369; lTableau[369])
            {
            }
            column(C372; lTableau[372])
            {
            }
            column(C373; lTableau[373])
            {
            }
            column(C374; lTableau[374])
            {
            }
            column(C375; lTableau[375])
            {
            }
            column(C376; lTableau[376])
            {
            }
            column(C377; lTableau[377])
            {
            }
            column(C378; lTableau[378])
            {
            }
            column(C379; lTableau[379])
            {
            }
            column(C380; lTableau[380])
            {
            }
            column(C383; lTableau[383])
            {
            }
            column(C384; lTableau[384])
            {
            }
            column(C385; lTableau[385])
            {
            }
            column(C386; lTableau[386])
            {
            }
            column(C387; lTableau[387])
            {
            }
            column(C388; lTableau[388])
            {
            }
            column(C166; lTableau[166])
            {
            }
            column(C106; lTableau[106])
            {
            }
            column(C107; lTableau[107])
            {
            }
            column(C154; lTableau[154])
            {
            }
            column(C155; lTableau[155])
            {
            }
            column(C148; lTableau[148])
            {
            }
            column(C131; lTableau[131])
            {
            }
            column(C129; lTableau[129])
            {
            }
            column(C771; lTableau[771])
            {
            }
            column(C122; lTableau[122])
            {
            }
            column(C772; lTableau[772])
            {
            }
            column(C125; lTableau[125])
            {
            }
            column(C774; lTableau[774])
            {
            }
            column(C773; lTableau[773])
            {
            }
            column(C123; lTableau[123])
            {
            }
            column(C126; lTableau[126])
            {
            }
            column(C124; lTableau[124])
            {
            }
            column(C128; lTableau[128])
            {
            }
            column(C197; lTableau[197])
            {
            }
            column(C130; lTableau[130])
            {
            }
            column(C139; lTableau[139])
            {
            }
            column(C137; lTableau[137])
            {
            }
            column(C776; lTableau[776])
            {
            }
            column(C132; lTableau[132])
            {
            }
            column(C777; lTableau[777])
            {
            }
            column(C135; lTableau[135])
            {
            }
            column(C778; lTableau[778])
            {
            }
            column(C133; lTableau[133])
            {
            }
            column(C134; lTableau[134])
            {
            }
            column(C153; lTableau[153])
            {
            }
            column(C136; lTableau[136])
            {
            }
            column(C198; lTableau[198])
            {
            }
            column(C138; lTableau[138])
            {
            }
            column(C147; lTableau[147])
            {
            }
            column(C145; lTableau[145])
            {
            }
            column(C781; lTableau[781])
            {
            }
            column(C140; lTableau[140])
            {
            }
            column(C782; lTableau[782])
            {
            }
            column(C783; lTableau[783])
            {
            }
            column(C143; lTableau[143])
            {
            }
            column(C141; lTableau[141])
            {
            }
            column(C142; lTableau[142])
            {
            }
            column(C149; lTableau[149])
            {
            }
            column(C144; lTableau[144])
            {
            }
            column(C199; lTableau[199])
            {
            }
            column(C146; lTableau[146])
            {
            }
            column(C150; lTableau[150])
            {
            }
            column(C151; lTableau[151])
            {
            }
            column(C168; lTableau[168])
            {
            }
            column(C181; lTableau[181])
            {
            }
            column(C163; lTableau[163])
            {
            }
            column(C176; lTableau[176])
            {
            }
            column(C791; lTableau[791])
            {
            }
            column(C792; lTableau[792])
            {
            }
            column(C156; lTableau[156])
            {
            }
            column(C169; lTableau[169])
            {
            }
            column(C793; lTableau[793])
            {
            }
            column(C794; lTableau[794])
            {
            }
            column(C159; lTableau[159])
            {
            }
            column(C172; lTableau[172])
            {
            }
            column(C161; lTableau[161])
            {
            }
            column(C174; lTableau[174])
            {
            }
            column(C795; lTableau[795])
            {
            }
            column(C796; lTableau[796])
            {
            }
            column(C157; lTableau[157])
            {
            }
            column(C170; lTableau[170])
            {
            }
            column(C160; lTableau[160])
            {
            }
            column(C173; lTableau[173])
            {
            }
            column(C158; lTableau[158])
            {
            }
            column(C171; lTableau[171])
            {
            }
            column(C396; lTableau[396])
            {
            }
            column(C162; lTableau[162])
            {
            }
            column(C175; lTableau[175])
            {
            }
            column(C201; lTableau[200])
            {
            }
            column(C164; lTableau[164])
            {
            }
            column(C177; lTableau[177])
            {
            }
            column(C165; lTableau[165])
            {
            }
            column(C178; lTableau[178])
            {
            }
            column(C167; lTableau[167])
            {
            }
            column(C180; lTableau[180])
            {
            }
            column(C117; lTableau[117])
            {
            }
            column(C118; lTableau[118])
            {
            }
            column(C119; lTableau[119])
            {
            }
            column(C120; lTableau[120])
            {
            }
            column(C121; lTableau[121])
            {
            }
            column(C397; lTableau[397])
            {
            }
            column(C398; lTableau[398])
            {
            }
            column(C399; lTableau[399])
            {
            }
            column(C400; lTableau[400])
            {
            }
            column(C401; lTableau[401])
            {
            }
            column(C402; lTableau[402])
            {
            }
            column(C998; lTableau[998])
            {
            }
            column(C999; lTableau[999])
            {
            }
            column(C001; lTableau[1])
            {
            }
            column(C002; lTableau[2])
            {
            }
            column(C003; lTableau[3])
            {
            }
            column(C004; lTableau[4])
            {
            }
            column(C005; lTableau[5])
            {
            }
            column(C006; lTableau[6])
            {
            }
            column(C007; lTableau[7])
            {
            }
            column(C008; lTableau[8])
            {
            }
            column(C009; lTableau[9])
            {
            }
            column(C010; lTableau[10])
            {
            }
            column(C011; lTableau[11])
            {
            }
            column(C013; lTableau[13])
            {
            }
            column(C202; lTableau[202])
            {
            }
            column(C206; lTableau[206])
            {
            }
            column(C203; lTableau[203])
            {
            }
            column(C080; lTableau[80])
            {
            }
            column(C077; lTableau[77])
            {
            }
            column(C078; lTableau[78])
            {
            }
            column(C079; lTableau[79])
            {
            }
            column(C404; lTableau[404])
            {
            }
            column(C084; lTableau[84])
            {
            }
            column(C081; lTableau[81])
            {
            }
            column(C082; lTableau[82])
            {
            }
            column(C083; lTableau[83])
            {
            }
            column(C405; lTableau[405])
            {
            }
            column(C088; lTableau[88])
            {
            }
            column(C085; lTableau[85])
            {
            }
            column(C086; lTableau[86])
            {
            }
            column(C087; lTableau[87])
            {
            }
            column(C406; lTableau[406])
            {
            }
            column(C179; lTableau[179])
            {
            }
            column(C096; lTableau[96])
            {
            }
            column(C101; lTableau[101])
            {
            }
            column(C098; lTableau[98])
            {
            }
            column(C099; lTableau[99])
            {
            }
            column(C100; lTableau[100])
            {
            }
            column(C366; lTableau[366])
            {
            }
            column(C394; lTableau[394])
            {
            }
            column(C200; lTableau[200])
            {
            }
            column(C116; lTableau[116])
            {
            }
            column(C229; lTableau[229])
            {
            }
            column(C238; lTableau[238])
            {
            }
            column(C719; lTableau[719])
            {
            }
            column(C729; lTableau[729])
            {
            }
            column(C471; lTableau[471])
            {
            }
            column(C472; lTableau[472])
            {
            }
            column(C414; lTableau[414])
            {
            }
            column(C415; lTableau[415])
            {
            }
        }
        dataitem(C411_C412_C413; 2000000026)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            column(L01_C411; lTableau_C411_C412_C413[11])
            {
            }
            column(L01_C412; lTableau_C411_C412_C413[12])
            {
            }
            column(L01_C413; lTableau_C411_C412_C413[13])
            {
            }
            column(L02_C411; lTableau_C411_C412_C413[21])
            {
            }
            column(L02_C412; lTableau_C411_C412_C413[22])
            {
            }
            column(L02_C413; lTableau_C411_C412_C413[23])
            {
            }
            column(L03_C411; lTableau_C411_C412_C413[31])
            {
            }
            column(L03_C412; lTableau_C411_C412_C413[32])
            {
            }
            column(L03_C413; lTableau_C411_C412_C413[33])
            {
            }
            column(L04_C411; lTableau_C411_C412_C413[41])
            {
            }
            column(L04_C412; lTableau_C411_C412_C413[42])
            {
            }
            column(L04_C413; lTableau_C411_C412_C413[43])
            {
            }
            column(L05_C411; lTableau_C411_C412_C413[51])
            {
            }
            column(L05_C412; lTableau_C411_C412_C413[52])
            {
            }
            column(L05_C413; lTableau_C411_C412_C413[53])
            {
            }
            column(L06_C411; lTableau_C411_C412_C413[61])
            {
            }
            column(L06_C412; lTableau_C411_C412_C413[62])
            {
            }
            column(L06_C413; lTableau_C411_C412_C413[63])
            {
            }
            column(L07_C411; lTableau_C411_C412_C413[71])
            {
            }
            column(L07_C412; lTableau_C411_C412_C413[72])
            {
            }
            column(L07_C413; lTableau_C411_C412_C413[73])
            {
            }
            column(L08_C411; lTableau_C411_C412_C413[81])
            {
            }
            column(L08_C412; lTableau_C411_C412_C413[82])
            {
            }
            column(L08_C413; lTableau_C411_C412_C413[83])
            {
            }
            column(L09_C411; lTableau_C411_C412_C413[91])
            {
            }
            column(L09_C412; lTableau_C411_C412_C413[92])
            {
            }
            column(L09_C413; lTableau_C411_C412_C413[93])
            {
            }
            column(L10_C411; lTableau_C411_C412_C413[101])
            {
            }
            column(L10_C412; lTableau_C411_C412_C413[102])
            {
            }
            column(L10_C413; lTableau_C411_C412_C413[103])
            {
            }
            column(L11_C411; lTableau_C411_C412_C413[111])
            {
            }
            column(L11_C412; lTableau_C411_C412_C413[112])
            {
            }
            column(L11_C413; lTableau_C411_C412_C413[113])
            {
            }
            column(L12_C411; lTableau_C411_C412_C413[121])
            {
            }
            column(L12_C412; lTableau_C411_C412_C413[122])
            {
            }
            column(L12_C413; lTableau_C411_C412_C413[123])
            {
            }
            column(L13_C411; lTableau_C411_C412_C413[131])
            {
            }
            column(L13_C412; lTableau_C411_C412_C413[132])
            {
            }
            column(L13_C413; lTableau_C411_C412_C413[133])
            {
            }
            column(L14_C411; lTableau_C411_C412_C413[141])
            {
            }
            column(L14_C412; lTableau_C411_C412_C413[142])
            {
            }
            column(L14_C413; lTableau_C411_C412_C413[143])
            {
            }
            column(L15_C411; lTableau_C411_C412_C413[151])
            {
            }
            column(L15_C412; lTableau_C411_C412_C413[152])
            {
            }
            column(L15_C413; lTableau_C411_C412_C413[153])
            {
            }
            column(L16_C411; lTableau_C411_C412_C413[161])
            {
            }
            column(L16_C412; lTableau_C411_C412_C413[162])
            {
            }
            column(L16_C413; lTableau_C411_C412_C413[163])
            {
            }
        }

    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    trigger OnInitReport()
    begin
        gAppendixOpExpLine := 1;
        gAppendixOpExpTotalC414 := 0;
        gAppendixOpExpTotalC415 := 0;
    end;

    var
        lTableau: array[99999] of Text[250];
        TotalAmount: Decimal;
        lTableau_C411_C412_C413: array[99999] of Text[250];
        gAppendixOpExpLine: Integer;
        gAppendixOpExpIdx: Integer;
        gAppendixOpExpTotalC414: Decimal;
        gAppendixOpExpTotalC415: Decimal;
}
