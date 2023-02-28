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
                            EVALUATE(Ltableau[lInt], FORMAT(TotalAmount, 0, '<Sign><Integer><Decimals,3>'))
                        else
                            Ltableau[lInt] := '';
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
                            EVALUATE(Ltableau[lInt], FORMAT(TotalAmount, 0, '<Sign><Integer><Decimals,3>'))
                        else
                            Ltableau[lInt] := '';
                    end;
                end;

                if "Data Type" = eCDFData."Data Type"::Numeric then begin
                    if EVALUATE(lInt, COPYSTR("Row No.", 2)) then begin
                        TotalAmount := "Calculated Value" + "Correction Amount";
                        if TotalAmount <> 0 then
                            EVALUATE(Ltableau[lInt], FORMAT(TotalAmount, 0, '<Sign><Integer><Decimals,3>'))
                        else
                            Ltableau[lInt] := '';
                    end;

                    //<<BEGIN: Appendix to Operational expenditures - C411/C412/C413 lines with C414/C415 total process
                    if ("Row No." = 'C411') then begin
                        gAppendixOpExpIdx := (gAppendixOpExpLine * 10) + 1;
                        EVALUATE(Ltableau_C411_C412_C413[gAppendixOpExpIdx], FORMAT("Final Value"))
                    end else

                        if ("Row No." = 'C412') then begin
                            TotalAmount := "Calculated Value" + "Correction Amount";
                            gAppendixOpExpIdx := (gAppendixOpExpLine * 10) + 2;
                            if TotalAmount <> 0 then
                                EVALUATE(Ltableau_C411_C412_C413[gAppendixOpExpIdx], FORMAT(TotalAmount, 0, '<Sign><Integer><Decimals,3>'))
                            ELSE
                                Ltableau_C411_C412_C413[gAppendixOpExpIdx] := '';
                            gAppendixOpExpTotalC414 := gAppendixOpExpTotalC414 + TotalAmount;
                        end else
                            if ("Row No." = 'C413') then begin
                                TotalAmount := "Calculated Value" + "Correction Amount";
                                gAppendixOpExpIdx := (gAppendixOpExpLine * 10) + 3;
                                if TotalAmount <> 0 then
                                    EVALUATE(Ltableau_C411_C412_C413[gAppendixOpExpIdx], FORMAT(TotalAmount, 0, '<Sign><Integer><Decimals,3>'))
                                else
                                    Ltableau_C411_C412_C413[gAppendixOpExpIdx] := '';
                                gAppendixOpExpLine := gAppendixOpExpLine + 1;
                                gAppendixOpExpTotalC415 := gAppendixOpExpTotalC415 + TotalAmount;
                            end else
                                if ("Row No." = 'C414') then begin
                                    if EVALUATE(lInt, COPYSTR("Row No.", 2)) then begin
                                        if gAppendixOpExpTotalC414 <> 0 then
                                            EVALUATE(Ltableau[lInt], FORMAT(gAppendixOpExpTotalC414, 0, '<Sign><Integer><Decimals,3>'))
                                        else
                                            Ltableau[lInt] := '';
                                    end;
                                end else
                                    if ("Row No." = 'C415') then begin
                                        if EVALUATE(lInt, COPYSTR("Row No.", 2)) then begin
                                            if gAppendixOpExpTotalC415 <> 0 then
                                                EVALUATE(Ltableau[lInt], FORMAT(gAppendixOpExpTotalC415, 0, '<Sign><Integer><Decimals,3>'))
                                            ELSE
                                                Ltableau[lInt] := '';
                                        end;
                                    end;
                    //END: Appendix to Operational expenditures>>
                end;

                if "Data Type" = eCDFData."Data Type"::Integer then begin
                    if EVALUATE(lInt, COPYSTR("Row No.", 2)) then begin
                        TotalAmount := "Calculated Value" + "Correction Amount";
                        EVALUATE(Ltableau[lInt], FORMAT(TotalAmount, 0, '<Sign><Integer><Decimals,3>'));
                    end;
                end;

                if "Data Type" = eCDFData."Data Type"::Boolean then begin
                    if EVALUATE(lInt, COPYSTR("Row No.", 2)) then
                        if (eCDFData."Row No." = 'C204') AND (eCDFData."Final Value" = '1') then
                            EVALUATE(Ltableau[204], 'X');
                    if (eCDFData."Row No." = 'C205') AND (eCDFData."Final Value" = '1') then
                        EVALUATE(Ltableau[205], 'X');
                    if (eCDFData."Row No." = 'C998') AND (eCDFData."Final Value" = '1') then
                        EVALUATE(Ltableau[998], 'X');
                    if (eCDFData."Row No." = 'C999') AND (eCDFData."Final Value" = '1') then
                        EVALUATE(Ltableau[999], 'X');
                end;

                if "Data Type" = eCDFData."Data Type"::Alphanumeric then begin
                    if (("Row No." = 'C397') OR ("Row No." = 'C398') OR ("Row No." = 'C399') OR ("Row No." = 'C400') OR ("Row No." = 'C401') OR ("Row No." = 'C402')) THEN BEGIN
                        if EVALUATE(lInt, COPYSTR("Row No.", 2)) then
                            EVALUATE(Ltableau[lInt], FORMAT(eCDFData."Final Value"));
                    end;
                end;
            end;

        }

        dataitem("Integer"; 2000000026)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(C012; Ltableau[12])
            {
            }
            column(C204; Ltableau[204])
            {
            }
            column(C205; Ltableau[205])
            {
            }
            column(C454; Ltableau[454])
            {
            }
            column(C455; Ltableau[455])
            {
            }
            column(C456; Ltableau[456])
            {
            }
            column(C021; Ltableau[21])
            {
            }
            column(C457; Ltableau[457])
            {
            }
            column(C014; Ltableau[14])
            {
            }
            column(C015; Ltableau[15])
            {
            }
            column(C016; Ltableau[16])
            {
            }
            column(C017; Ltableau[17])
            {
            }
            column(C018; Ltableau[18])
            {
            }
            column(C423; Ltableau[423])
            {
            }
            column(C424; Ltableau[424])
            {
            }
            column(C226; Ltableau[226])
            {
            }
            column(C019; Ltableau[19])
            {
            }
            column(C419; Ltableau[419])
            {
            }
            column(C022; Ltableau[22])
            {
            }
            column(C037; Ltableau[37])
            {
            }
            column(C046; Ltableau[46])
            {
            }
            column(C701; Ltableau[701])
            {
            }
            column(C702; Ltableau[702])
            {
            }
            column(C029; Ltableau[29])
            {
            }
            column(C038; Ltableau[38])
            {
            }
            column(C703; Ltableau[703])
            {
            }
            column(C704; Ltableau[704])
            {
            }
            column(C032; Ltableau[32])
            {
            }
            column(C041; Ltableau[41])
            {
            }
            column(C705; Ltableau[705])
            {
            }
            column(C706; Ltableau[706])
            {
            }
            column(C030; Ltableau[30])
            {
            }
            column(C039; Ltableau[39])
            {
            }
            column(C031; Ltableau[31])
            {
            }
            column(C040; Ltableau[40])
            {
            }
            column(C403; Ltableau[403])
            {
            }
            column(C033; Ltableau[33])
            {
            }
            column(C042; Ltableau[42])
            {
            }
            column(C418; Ltableau[418])
            {
            }
            column(C416; Ltableau[416])
            {
            }
            column(C417; Ltableau[417])
            {
            }
            column(C453; Ltableau[453])
            {
            }
            column(C451; Ltableau[451])
            {
            }
            column(C452; Ltableau[452])
            {
            }
            column(C051; Ltableau[51])
            {
            }
            column(C056; Ltableau[56])
            {
            }
            column(C711; Ltableau[711])
            {
            }
            column(C712; Ltableau[712])
            {
            }
            column(C047; Ltableau[47])
            {
            }
            column(C052; Ltableau[52])
            {
            }
            column(C713; Ltableau[713])
            {
            }
            column(C714; Ltableau[714])
            {
            }
            column(C050; Ltableau[50])
            {
            }
            column(C055; Ltableau[55])
            {
            }
            column(C715; Ltableau[715])
            {
            }
            column(C716; Ltableau[716])
            {
            }
            column(C048; Ltableau[48])
            {
            }
            column(C053; Ltableau[53])
            {
            }
            column(C049; Ltableau[49])
            {
            }
            column(C054; Ltableau[54])
            {
            }
            column(C194; Ltableau[194])
            {
            }
            column(C152; Ltableau[152])
            {
            }
            column(C065; Ltableau[65])
            {
            }
            column(C407; Ltableau[407])
            {
            }
            column(C721; Ltableau[721])
            {
            }
            column(C722; Ltableau[722])
            {
            }
            column(C057; Ltableau[57])
            {
            }
            column(C066; Ltableau[66])
            {
            }
            column(C723; Ltableau[723])
            {
            }
            column(C724; Ltableau[724])
            {
            }
            column(C060; Ltableau[60])
            {
            }
            column(C069; Ltableau[69])
            {
            }
            column(C725; Ltableau[725])
            {
            }
            column(C726; Ltableau[726])
            {
            }
            column(C058; Ltableau[58])
            {
            }
            column(C067; Ltableau[67])
            {
            }
            column(C059; Ltableau[59])
            {
            }
            column(C068; Ltableau[68])
            {
            }
            column(C195; Ltableau[195])
            {
            }
            column(C731; Ltableau[731])
            {
            }
            column(C732; Ltableau[732])
            {
            }
            column(C061; Ltableau[61])
            {
            }
            column(C071; Ltableau[71])
            {
            }
            column(C733; Ltableau[733])
            {
            }
            column(C734; Ltableau[734])
            {
            }
            column(C064; Ltableau[64])
            {
            }
            column(C074; Ltableau[74])
            {
            }
            column(C735; Ltableau[735])
            {
            }
            column(C736; Ltableau[736])
            {
            }
            column(C062; Ltableau[62])
            {
            }
            column(C072; Ltableau[72])
            {
            }
            column(C063; Ltableau[63])
            {
            }
            column(C073; Ltableau[73])
            {
            }
            column(C196; Ltableau[196])
            {
            }
            column(C409; Ltableau[409])
            {
            }
            column(C410; Ltableau[410])
            {
            }
            column(C436; Ltableau[436])
            {
            }
            column(C462; Ltableau[462])
            {
            }
            column(C741; Ltableau[741])
            {
            }
            column(C742; Ltableau[742])
            {
            }
            column(C427; Ltableau[427])
            {
            }
            column(C428; Ltableau[428])
            {
            }
            column(C743; Ltableau[743])
            {
            }
            column(C744; Ltableau[744])
            {
            }
            column(C433; Ltableau[433])
            {
            }
            column(C434; Ltableau[434])
            {
            }
            column(C745; Ltableau[745])
            {
            }
            column(C746; Ltableau[746])
            {
            }
            column(C429; Ltableau[429])
            {
            }
            column(C430; Ltableau[430])
            {
            }
            column(C431; Ltableau[431])
            {
            }
            column(C432; Ltableau[432])
            {
            }
            column(C435; Ltableau[435])
            {
            }
            column(C463; Ltableau[463])
            {
            }
            column(C464; Ltableau[464])
            {
            }
            column(C751; Ltableau[751])
            {
            }
            column(C752; Ltableau[752])
            {
            }
            column(C437; Ltableau[437])
            {
            }
            column(C438; Ltableau[438])
            {
            }
            column(C753; Ltableau[753])
            {
            }
            column(C754; Ltableau[754])
            {
            }
            column(C443; Ltableau[443])
            {
            }
            column(C444; Ltableau[444])
            {
            }
            column(C755; Ltableau[755])
            {
            }
            column(C756; Ltableau[756])
            {
            }
            column(C439; Ltableau[439])
            {
            }
            column(C440; Ltableau[440])
            {
            }
            column(C441; Ltableau[441])
            {
            }
            column(C442; Ltableau[442])
            {
            }
            column(C445; Ltableau[445])
            {
            }
            column(C765; Ltableau[765])
            {
            }
            column(C766; Ltableau[766])
            {
            }
            column(C761; Ltableau[761])
            {
            }
            column(C762; Ltableau[762])
            {
            }
            column(C420; Ltableau[420])
            {
            }
            column(C421; Ltableau[421])
            {
            }
            column(C767; Ltableau[767])
            {
            }
            column(C768; Ltableau[768])
            {
            }
            column(C763; Ltableau[763])
            {
            }
            column(C764; Ltableau[764])
            {
            }
            column(C222; Ltableau[222])
            {
            }
            column(C223; Ltableau[223])
            {
            }
            column(C227; Ltableau[227])
            {
            }
            column(C076; Ltableau[76])
            {
            }
            column(C093; Ltableau[93])
            {
            }
            column(C458; Ltableau[458])
            {
            }
            column(C459; Ltableau[459])
            {
            }
            column(C460; Ltableau[460])
            {
            }
            column(C090; Ltableau[90])
            {
            }
            column(C461; Ltableau[461])
            {
            }
            column(C092; Ltableau[92])
            {
            }
            column(C228; Ltableau[228])
            {
            }
            column(C097; Ltableau[97])
            {
            }
            column(C094; Ltableau[94])
            {
            }
            column(C095; Ltableau[95])
            {
            }
            column(C102; Ltableau[102])
            {
            }
            column(C103; Ltableau[103])
            {
            }
            column(C104; Ltableau[104])
            {
            }
            column(C105; Ltableau[105])
            {
            }
            column(C237; Ltableau[237])
            {
            }
            column(C110; Ltableau[110])
            {
            }
            column(C108; Ltableau[108])
            {
            }
            column(C109; Ltableau[109])
            {
            }
            column(C192; Ltableau[192])
            {
            }
            column(C193; Ltableau[193])
            {
            }
            column(C239; Ltableau[239])
            {
            }
            column(C240; Ltableau[240])
            {
            }
            column(C114; Ltableau[114])
            {
            }
            column(C241; Ltableau[241])
            {
            }
            column(C242; Ltableau[242])
            {
            }
            column(C243; Ltableau[243])
            {
            }
            column(C244; Ltableau[244])
            {
            }
            column(C245; Ltableau[245])
            {
            }
            column(C246; Ltableau[246])
            {
            }
            column(C247; Ltableau[247])
            {
            }
            column(C248; Ltableau[248])
            {
            }
            column(C249; Ltableau[249])
            {
            }
            column(C250; Ltableau[250])
            {
            }
            column(C251; Ltableau[251])
            {
            }
            column(C252; Ltableau[252])
            {
            }
            column(C253; Ltableau[253])
            {
            }
            column(C254; Ltableau[254])
            {
            }
            column(C255; Ltableau[255])
            {
            }
            column(C256; Ltableau[256])
            {
            }
            column(C257; Ltableau[257])
            {
            }
            column(C258; Ltableau[258])
            {
            }
            column(C259; Ltableau[259])
            {
            }
            column(C260; Ltableau[260])
            {
            }
            column(C261; Ltableau[261])
            {
            }
            column(C262; Ltableau[262])
            {
            }
            column(C263; Ltableau[263])
            {
            }
            column(C264; Ltableau[264])
            {
            }
            column(C265; Ltableau[265])
            {
            }
            column(C266; Ltableau[266])
            {
            }
            column(C267; Ltableau[267])
            {
            }
            column(C268; Ltableau[268])
            {
            }
            column(C269; Ltableau[269])
            {
            }
            column(C270; Ltableau[270])
            {
            }
            column(C271; Ltableau[271])
            {
            }
            column(C272; Ltableau[272])
            {
            }
            column(C273; Ltableau[273])
            {
            }
            column(C274; Ltableau[274])
            {
            }
            column(C275; Ltableau[275])
            {
            }
            column(C276; Ltableau[276])
            {
            }
            column(C277; Ltableau[277])
            {
            }
            column(C278; Ltableau[278])
            {
            }
            column(C279; Ltableau[279])
            {
            }
            column(C280; Ltableau[280])
            {
            }
            column(C281; Ltableau[281])
            {
            }
            column(C282; Ltableau[282])
            {
            }
            column(C283; Ltableau[283])
            {
            }
            column(C284; Ltableau[284])
            {
            }
            column(C183; Ltableau[183])
            {
            }
            column(C184; Ltableau[184])
            {
            }
            column(C285; Ltableau[285])
            {
            }
            column(C286; Ltableau[286])
            {
            }
            column(C287; Ltableau[287])
            {
            }
            column(C288; Ltableau[288])
            {
            }
            column(C289; Ltableau[289])
            {
            }
            column(C290; Ltableau[290])
            {
            }
            column(C291; Ltableau[291])
            {
            }
            column(C292; Ltableau[292])
            {
            }
            column(C293; Ltableau[293])
            {
            }
            column(C294; Ltableau[294])
            {
            }
            column(C295; Ltableau[295])
            {
            }
            column(C296; Ltableau[296])
            {
            }
            column(C297; Ltableau[297])
            {
            }
            column(C298; Ltableau[298])
            {
            }
            column(C299; Ltableau[299])
            {
            }
            column(C300; Ltableau[300])
            {
            }
            column(C301; Ltableau[301])
            {
            }
            column(C302; Ltableau[302])
            {
            }
            column(C303; Ltableau[303])
            {
            }
            column(C304; Ltableau[304])
            {
            }
            column(C305; Ltableau[305])
            {
            }
            column(C306; Ltableau[306])
            {
            }
            column(C185; Ltableau[185])
            {
            }
            column(C186; Ltableau[186])
            {
            }
            column(C307; Ltableau[307])
            {
            }
            column(C308; Ltableau[308])
            {
            }
            column(C309; Ltableau[309])
            {
            }
            column(C310; Ltableau[310])
            {
            }
            column(C311; Ltableau[311])
            {
            }
            column(C312; Ltableau[312])
            {
            }
            column(C313; Ltableau[313])
            {
            }
            column(C314; Ltableau[314])
            {
            }
            column(C315; Ltableau[315])
            {
            }
            column(C316; Ltableau[316])
            {
            }
            column(C317; Ltableau[317])
            {
            }
            column(C318; Ltableau[318])
            {
            }
            column(C319; Ltableau[319])
            {
            }
            column(C320; Ltableau[320])
            {
            }
            column(C321; Ltableau[321])
            {
            }
            column(C322; Ltableau[322])
            {
            }
            column(C323; Ltableau[323])
            {
            }
            column(C324; Ltableau[324])
            {
            }
            column(C325; Ltableau[325])
            {
            }
            column(C326; Ltableau[326])
            {
            }
            column(C327; Ltableau[327])
            {
            }
            column(C328; Ltableau[328])
            {
            }
            column(C329; Ltableau[329])
            {
            }
            column(C330; Ltableau[330])
            {
            }
            column(C331; Ltableau[331])
            {
            }
            column(C332; Ltableau[332])
            {
            }
            column(C333; Ltableau[333])
            {
            }
            column(C334; Ltableau[334])
            {
            }
            column(C335; Ltableau[335])
            {
            }
            column(C336; Ltableau[336])
            {
            }
            column(C337; Ltableau[337])
            {
            }
            column(C338; Ltableau[338])
            {
            }
            column(C115; Ltableau[115])
            {
            }
            column(C187; Ltableau[187])
            {
            }
            column(C188; Ltableau[188])
            {
            }
            column(C189; Ltableau[189])
            {
            }
            column(C343; Ltableau[343])
            {
            }
            column(C344; Ltableau[344])
            {
            }
            column(C345; Ltableau[345])
            {
            }
            column(C346; Ltableau[346])
            {
            }
            column(C347; Ltableau[347])
            {
            }
            column(C348; Ltableau[348])
            {
            }
            column(C349; Ltableau[349])
            {
            }
            column(C350; Ltableau[350])
            {
            }
            column(C351; Ltableau[351])
            {
            }
            column(C352; Ltableau[352])
            {
            }
            column(C353; Ltableau[353])
            {
            }
            column(C354; Ltableau[354])
            {
            }
            column(C355; Ltableau[355])
            {
            }
            column(C356; Ltableau[356])
            {
            }
            column(C357; Ltableau[357])
            {
            }
            column(C358; Ltableau[358])
            {
            }
            column(C359; Ltableau[359])
            {
            }
            column(C361; Ltableau[361])
            {
            }
            column(C362; Ltableau[362])
            {
            }
            column(C190; Ltableau[190])
            {
            }
            column(C191; Ltableau[191])
            {
            }
            column(C389; Ltableau[389])
            {
            }
            column(C363; Ltableau[363])
            {
            }
            column(C364; Ltableau[364])
            {
            }
            column(C365; Ltableau[365])
            {
            }
            column(C367; Ltableau[367])
            {
            }
            column(C381; Ltableau[381])
            {
            }
            column(C382; Ltableau[382])
            {
            }
            column(C368; Ltableau[368])
            {
            }
            column(C369; Ltableau[369])
            {
            }
            column(C372; Ltableau[372])
            {
            }
            column(C373; Ltableau[373])
            {
            }
            column(C374; Ltableau[374])
            {
            }
            column(C375; Ltableau[375])
            {
            }
            column(C376; Ltableau[376])
            {
            }
            column(C377; Ltableau[377])
            {
            }
            column(C378; Ltableau[378])
            {
            }
            column(C379; Ltableau[379])
            {
            }
            column(C380; Ltableau[380])
            {
            }
            column(C383; Ltableau[383])
            {
            }
            column(C384; Ltableau[384])
            {
            }
            column(C385; Ltableau[385])
            {
            }
            column(C386; Ltableau[386])
            {
            }
            column(C387; Ltableau[387])
            {
            }
            column(C388; Ltableau[388])
            {
            }
            column(C166; Ltableau[166])
            {
            }
            column(C106; Ltableau[106])
            {
            }
            column(C107; Ltableau[107])
            {
            }
            column(C154; Ltableau[154])
            {
            }
            column(C155; Ltableau[155])
            {
            }
            column(C148; Ltableau[148])
            {
            }
            column(C131; Ltableau[131])
            {
            }
            column(C129; Ltableau[129])
            {
            }
            column(C771; Ltableau[771])
            {
            }
            column(C122; Ltableau[122])
            {
            }
            column(C772; Ltableau[772])
            {
            }
            column(C125; Ltableau[125])
            {
            }
            column(C774; Ltableau[774])
            {
            }
            column(C773; Ltableau[773])
            {
            }
            column(C123; Ltableau[123])
            {
            }
            column(C126; Ltableau[126])
            {
            }
            column(C124; Ltableau[124])
            {
            }
            column(C128; Ltableau[128])
            {
            }
            column(C197; Ltableau[197])
            {
            }
            column(C130; Ltableau[130])
            {
            }
            column(C139; Ltableau[139])
            {
            }
            column(C137; Ltableau[137])
            {
            }
            column(C776; Ltableau[776])
            {
            }
            column(C132; Ltableau[132])
            {
            }
            column(C777; Ltableau[777])
            {
            }
            column(C135; Ltableau[135])
            {
            }
            column(C778; Ltableau[778])
            {
            }
            column(C133; Ltableau[133])
            {
            }
            column(C134; Ltableau[134])
            {
            }
            column(C153; Ltableau[153])
            {
            }
            column(C136; Ltableau[136])
            {
            }
            column(C198; Ltableau[198])
            {
            }
            column(C138; Ltableau[138])
            {
            }
            column(C147; Ltableau[147])
            {
            }
            column(C145; Ltableau[145])
            {
            }
            column(C781; Ltableau[781])
            {
            }
            column(C140; Ltableau[140])
            {
            }
            column(C782; Ltableau[782])
            {
            }
            column(C783; Ltableau[783])
            {
            }
            column(C143; Ltableau[143])
            {
            }
            column(C141; Ltableau[141])
            {
            }
            column(C142; Ltableau[142])
            {
            }
            column(C149; Ltableau[149])
            {
            }
            column(C144; Ltableau[144])
            {
            }
            column(C199; Ltableau[199])
            {
            }
            column(C146; Ltableau[146])
            {
            }
            column(C150; Ltableau[150])
            {
            }
            column(C151; Ltableau[151])
            {
            }
            column(C168; Ltableau[168])
            {
            }
            column(C181; Ltableau[181])
            {
            }
            column(C163; Ltableau[163])
            {
            }
            column(C176; Ltableau[176])
            {
            }
            column(C791; Ltableau[791])
            {
            }
            column(C792; Ltableau[792])
            {
            }
            column(C156; Ltableau[156])
            {
            }
            column(C169; Ltableau[169])
            {
            }
            column(C793; Ltableau[793])
            {
            }
            column(C794; Ltableau[794])
            {
            }
            column(C159; Ltableau[159])
            {
            }
            column(C172; Ltableau[172])
            {
            }
            column(C161; Ltableau[161])
            {
            }
            column(C174; Ltableau[174])
            {
            }
            column(C795; Ltableau[795])
            {
            }
            column(C796; Ltableau[796])
            {
            }
            column(C157; Ltableau[157])
            {
            }
            column(C170; Ltableau[170])
            {
            }
            column(C160; Ltableau[160])
            {
            }
            column(C173; Ltableau[173])
            {
            }
            column(C158; Ltableau[158])
            {
            }
            column(C171; Ltableau[171])
            {
            }
            column(C396; Ltableau[396])
            {
            }
            column(C162; Ltableau[162])
            {
            }
            column(C175; Ltableau[175])
            {
            }
            column(C201; Ltableau[200])
            {
            }
            column(C164; Ltableau[164])
            {
            }
            column(C177; Ltableau[177])
            {
            }
            column(C165; Ltableau[165])
            {
            }
            column(C178; Ltableau[178])
            {
            }
            column(C167; Ltableau[167])
            {
            }
            column(C180; Ltableau[180])
            {
            }
            column(C117; Ltableau[117])
            {
            }
            column(C118; Ltableau[118])
            {
            }
            column(C119; Ltableau[119])
            {
            }
            column(C120; Ltableau[120])
            {
            }
            column(C121; Ltableau[121])
            {
            }
            column(C397; Ltableau[397])
            {
            }
            column(C398; Ltableau[398])
            {
            }
            column(C399; Ltableau[399])
            {
            }
            column(C400; Ltableau[400])
            {
            }
            column(C401; Ltableau[401])
            {
            }
            column(C402; Ltableau[402])
            {
            }
            column(C998; Ltableau[998])
            {
            }
            column(C999; Ltableau[999])
            {
            }
            column(C001; Ltableau[1])
            {
            }
            column(C002; Ltableau[2])
            {
            }
            column(C003; Ltableau[3])
            {
            }
            column(C004; Ltableau[4])
            {
            }
            column(C005; Ltableau[5])
            {
            }
            column(C006; Ltableau[6])
            {
            }
            column(C007; Ltableau[7])
            {
            }
            column(C008; Ltableau[8])
            {
            }
            column(C009; Ltableau[9])
            {
            }
            column(C010; Ltableau[10])
            {
            }
            column(C011; Ltableau[11])
            {
            }
            column(C013; Ltableau[13])
            {
            }
            column(C202; Ltableau[202])
            {
            }
            column(C206; Ltableau[206])
            {
            }
            column(C203; Ltableau[203])
            {
            }
            column(C080; Ltableau[80])
            {
            }
            column(C077; Ltableau[77])
            {
            }
            column(C078; Ltableau[78])
            {
            }
            column(C079; Ltableau[79])
            {
            }
            column(C404; Ltableau[404])
            {
            }
            column(C084; Ltableau[84])
            {
            }
            column(C081; Ltableau[81])
            {
            }
            column(C082; Ltableau[82])
            {
            }
            column(C083; Ltableau[83])
            {
            }
            column(C405; Ltableau[405])
            {
            }
            column(C088; Ltableau[88])
            {
            }
            column(C085; Ltableau[85])
            {
            }
            column(C086; Ltableau[86])
            {
            }
            column(C087; Ltableau[87])
            {
            }
            column(C406; Ltableau[406])
            {
            }
            column(C179; Ltableau[179])
            {
            }
            column(C096; Ltableau[96])
            {
            }
            column(C101; Ltableau[101])
            {
            }
            column(C098; Ltableau[98])
            {
            }
            column(C099; Ltableau[99])
            {
            }
            column(C100; Ltableau[100])
            {
            }
            column(C366; Ltableau[366])
            {
            }
            column(C394; Ltableau[394])
            {
            }
            column(C200; Ltableau[200])
            {
            }
            column(C116; Ltableau[116])
            {
            }
            column(C229; Ltableau[229])
            {
            }
            column(C238; Ltableau[238])
            {
            }
            column(C719; Ltableau[719])
            {
            }
            column(C729; Ltableau[729])
            {
            }
            column(C471; Ltableau[471])
            {
            }
            column(C472; Ltableau[472])
            {
            }
            column(C414; Ltableau[414])
            {
            }
            column(C415; Ltableau[415])
            {
            }
        }
        dataitem(C411_C412_C413; 2000000026)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            column(L01_C411; Ltableau_C411_C412_C413[11])
            {
            }
            column(L01_C412; Ltableau_C411_C412_C413[12])
            {
            }
            column(L01_C413; Ltableau_C411_C412_C413[13])
            {
            }
            column(L02_C411; Ltableau_C411_C412_C413[21])
            {
            }
            column(L02_C412; Ltableau_C411_C412_C413[22])
            {
            }
            column(L02_C413; Ltableau_C411_C412_C413[23])
            {
            }
            column(L03_C411; Ltableau_C411_C412_C413[31])
            {
            }
            column(L03_C412; Ltableau_C411_C412_C413[32])
            {
            }
            column(L03_C413; Ltableau_C411_C412_C413[33])
            {
            }
            column(L04_C411; Ltableau_C411_C412_C413[41])
            {
            }
            column(L04_C412; Ltableau_C411_C412_C413[42])
            {
            }
            column(L04_C413; Ltableau_C411_C412_C413[43])
            {
            }
            column(L05_C411; Ltableau_C411_C412_C413[51])
            {
            }
            column(L05_C412; Ltableau_C411_C412_C413[52])
            {
            }
            column(L05_C413; Ltableau_C411_C412_C413[53])
            {
            }
            column(L06_C411; Ltableau_C411_C412_C413[61])
            {
            }
            column(L06_C412; Ltableau_C411_C412_C413[62])
            {
            }
            column(L06_C413; Ltableau_C411_C412_C413[63])
            {
            }
            column(L07_C411; Ltableau_C411_C412_C413[71])
            {
            }
            column(L07_C412; Ltableau_C411_C412_C413[72])
            {
            }
            column(L07_C413; Ltableau_C411_C412_C413[73])
            {
            }
            column(L08_C411; Ltableau_C411_C412_C413[81])
            {
            }
            column(L08_C412; Ltableau_C411_C412_C413[82])
            {
            }
            column(L08_C413; Ltableau_C411_C412_C413[83])
            {
            }
            column(L09_C411; Ltableau_C411_C412_C413[91])
            {
            }
            column(L09_C412; Ltableau_C411_C412_C413[92])
            {
            }
            column(L09_C413; Ltableau_C411_C412_C413[93])
            {
            }
            column(L10_C411; Ltableau_C411_C412_C413[101])
            {
            }
            column(L10_C412; Ltableau_C411_C412_C413[102])
            {
            }
            column(L10_C413; Ltableau_C411_C412_C413[103])
            {
            }
            column(L11_C411; Ltableau_C411_C412_C413[111])
            {
            }
            column(L11_C412; Ltableau_C411_C412_C413[112])
            {
            }
            column(L11_C413; Ltableau_C411_C412_C413[113])
            {
            }
            column(L12_C411; Ltableau_C411_C412_C413[121])
            {
            }
            column(L12_C412; Ltableau_C411_C412_C413[122])
            {
            }
            column(L12_C413; Ltableau_C411_C412_C413[123])
            {
            }
            column(L13_C411; Ltableau_C411_C412_C413[131])
            {
            }
            column(L13_C412; Ltableau_C411_C412_C413[132])
            {
            }
            column(L13_C413; Ltableau_C411_C412_C413[133])
            {
            }
            column(L14_C411; Ltableau_C411_C412_C413[141])
            {
            }
            column(L14_C412; Ltableau_C411_C412_C413[142])
            {
            }
            column(L14_C413; Ltableau_C411_C412_C413[143])
            {
            }
            column(L15_C411; Ltableau_C411_C412_C413[151])
            {
            }
            column(L15_C412; Ltableau_C411_C412_C413[152])
            {
            }
            column(L15_C413; Ltableau_C411_C412_C413[153])
            {
            }
            column(L16_C411; Ltableau_C411_C412_C413[161])
            {
            }
            column(L16_C412; Ltableau_C411_C412_C413[162])
            {
            }
            column(L16_C413; Ltableau_C411_C412_C413[163])
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
        Ltableau: array[99999] of Text[250];
        TotalAmount: Decimal;
        Ltableau_C411_C412_C413: array[99999] of Text[250];
        gAppendixOpExpLine: Integer;
        gAppendixOpExpIdx: Integer;
        gAppendixOpExpTotalC414: Decimal;
        gAppendixOpExpTotalC415: Decimal;
}
