/// <summary>
/// Report Create eCDF Statement (ID 50900).
/// </summary>
report 50900 "Create eCDF Statement"
{
    Caption = 'Create eCDF Statement';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem("VAT Statement Name"; "VAT Statement Name")
        {
            DataItemTableView = SORTING("Statement Template Name", Name);
            PrintOnlyIfDetail = true;

            dataitem("VAT Statement Line"; "VAT Statement Line")
            {
                DataItemTableView = SORTING("Statement Template Name", "Statement Name") WHERE(Print = CONST(true));
                DataItemLink = "Statement Template Name" = FIELD("Statement Template Name"), "Statement Name" = FIELD(Name);

                trigger OnAfterGetRecord()
                var
                    eCDFData: Record "eCDF Data";
                    TotalAmount: Decimal;
                    CorrectionAmount: Decimal;
                    GLAccount: Record "G/L Account";
                    lSAVStartDate: Date;
                    lSAVEndDateReq: Date;
                    lGLEntry: Record "G/L Entry";
                    lTotDeb: Decimal;
                    lTotCre: Decimal;
                begin
                    CalcLineTotal("VAT Statement Line", TotalAmount, CorrectionAmount, NetAmountLCY, '', 0);

                    IF PrintInIntegers THEN BEGIN
                        TotalAmount := ROUND(TotalAmount, 1, '<');
                        CorrectionAmount := ROUND(CorrectionAmount, 1, '<');
                    END;
                    TotalAmount := TotalAmount + CorrectionAmount;
                    IF "Print with" = "Print with"::"Opposite Sign" THEN
                        TotalAmount := -TotalAmount;

                    CLEAR(eCDFData);
                    eCDFData.VALIDATE("Statement Template Name", "VAT Statement Name"."Statement Template Name");
                    eCDFData.VALIDATE("Statement Name", "VAT Statement Name".Name);
                    eCDFData.VALIDATE("Starting Date", pStartingDate);
                    eCDFData.VALIDATE("Ending Date", pEndingDate);
                    eCDFData.VALIDATE(Version, Version);
                    eCDFData.VALIDATE("Line No.", "VAT Statement Line"."Line No.");
                    eCDFData.VALIDATE("Row No.", "VAT Statement Line"."Row No.");
                    eCDFData.VALIDATE(Type, "VAT Statement Line".Type);
                    eCDFData.VALIDATE("Amount Type", "VAT Statement Line"."Amount Type");
                    eCDFData.VALIDATE("Gen. Posting Type", "VAT Statement Line"."Gen. Posting Type");
                    eCDFData.VALIDATE("VAT Bus. Posting Group", "VAT Statement Line"."VAT Lux. Bus. Posting Group");
                    eCDFData.VALIDATE("VAT Prod. Posting Group", "VAT Statement Line"."VAT Lux. Prod. Posting Group");
                    eCDFData.VALIDATE("Row Totaling", "VAT Statement Line"."Row Totaling");
                    eCDFData.VALIDATE("Account Totaling", "VAT Statement Line"."Account Totaling");
                    eCDFData.VALIDATE("Calculate with", "VAT Statement Line"."Calculate with");
                    eCDFData.VALIDATE(Description, "VAT Statement Line".Description);
                    eCDFData.VALIDATE("Calculated Value", TotalAmount);
                    eCDFData.INSERT(TRUE);
                end;

                trigger OnPostDataItem()
                var
                    VATEntry: Record "VAT Entry";
                    eCDFData: Record "eCDF Data";
                begin
                    IF (pIntracommGoods) THEN BEGIN

                        CLEAR(VATEntry);
                        VATEntry.SETRANGE("Posting Date", pStartingDate, pEndingDate);
                        VATEntry.SETRANGE(Type, VATEntry.Type::Sale);
                        VATEntry.SETRANGE("EU Goods", VATEntry."EU Goods"::Good);
                        IF (VATEntry.FINDSET(FALSE, FALSE)) THEN
                            InsertIntracomData(VATEntry, eCDFData."Declaration Type"::INTRAG);

                    END;

                    IF (pIntracommServices) THEN BEGIN

                        CLEAR(VATEntry);
                        VATEntry.SETRANGE("Posting Date", pStartingDate, pEndingDate);
                        VATEntry.SETRANGE(Type, VATEntry.Type::Sale);
                        VATEntry.SETRANGE("EU Service", TRUE);
                        IF (VATEntry.FINDSET(FALSE, FALSE)) THEN
                            InsertIntracomData(VATEntry, eCDFData."Declaration Type"::INTRAS);

                    END;

                    IF (pEU3PartyTrade) THEN BEGIN

                        CLEAR(VATEntry);
                        VATEntry.SETRANGE("Posting Date", pStartingDate, pEndingDate);
                        VATEntry.SETRANGE(Type, VATEntry.Type::Sale);
                        VATEntry.SETRANGE("VAT Bus. Posting Group", 'TRI');
                        IF (VATEntry.FINDSET(FALSE, FALSE)) THEN
                            InsertIntracomData(VATEntry, eCDFData."Declaration Type"::INTRAT);

                    END;
                end;
            }

            dataitem("eCDF Rules"; "eCDF Rules")
            {
                DataItemTableView = SORTING("Statement Template Name", "Statement Name", "Row No.", "Rule Number");

                trigger OnPreDataItem()
                begin
                    SETRANGE("Statement Template Name", "VAT Statement Name"."Statement Template Name");
                    SETRANGE("Statement Name", "VAT Statement Name".Name);
                    SETRANGE("Start Date Validity", 0D, pStartingDate);
                    SETFILTER("End Date Validity", '%1|>=%2', 0D, pStartingDate);
                end;

                trigger OnAfterGetRecord()
                var
                    eCDFData: Record "eCDF Data";
                begin
                    IF "Row No." <> '' THEN BEGIN
                        eCDFData.SETRANGE("Statement Template Name", "VAT Statement Name"."Statement Template Name");
                        eCDFData.SETRANGE("Statement Name", "VAT Statement Name".Name);
                        eCDFData.SETFILTER("Row No.", "Row No.");
                        eCDFData.SETRANGE(Version, Version);
                        IF eCDFData.FINDSET THEN BEGIN
                            REPEAT
                                eCDFData."Data Type" := "eCDF Rules"."Data Type" + 1;
                                eCDFData.MODIFY;
                            UNTIL eCDFData.NEXT = 0;
                        END;
                    END;
                end;
            }

            trigger OnPreDataItem()
            var
                eCDFData: Record "eCDF Data";
            begin
                SETRANGE("Statement Template Name", pStatementTemplate);
                SETRANGE(Name, pStatementName);
                FINDSET(FALSE, FALSE);

                EndDate := pEndingDate;

                //Search the next version <<
                CLEAR(eCDFData);
                eCDFData.SETRANGE("Statement Template Name", "VAT Statement Name"."Statement Template Name");
                eCDFData.SETRANGE("Statement Name", "VAT Statement Name".Name);
                eCDFData.SETRANGE("Starting Date", pStartingDate);
                eCDFData.SETRANGE("Ending Date", pEndingDate);
                IF eCDFData.FINDLAST THEN BEGIN
                    Version := eCDFData.Version + 1;
                END ELSE BEGIN
                    Version := 1;
                END;
                //Search the next version >>
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group("Create eCDF Statement")
                {
                    Caption = 'Create eCDF Statement';
                    group(Statement)
                    {
                        Caption = 'Statement';
                        field(StatementTemplate; pStatementTemplate)
                        {
                            Caption = 'Statement Template';
                            ShowMandatory = true;
                            TableRelation = "VAT Statement Template";

                            trigger OnValidate()
                            begin
                                pStatementName := '';
                                pStartingDate := 0D;
                                pEndingDate := 0D;
                            end;
                        }
                        field(StatementName; pStatementName)
                        {
                            Caption = 'Statement Name';
                            ShowMandatory = true;

                            trigger OnDrillDown()
                            var
                                VATStatementName: Record 257;
                            begin
                                pStartingDate := 0D;
                                pEndingDate := 0D;

                                CLEAR(VATStatementName);
                                VATStatementName.SETRANGE("Statement Template Name", pStatementTemplate);
                                IF (PAGE.RUNMODAL(320, VATStatementName) = ACTION::LookupOK) THEN BEGIN
                                    pStatementName := VATStatementName.Name;
                                    IntracommVISIBLE := IsIntracommVisible();
                                END;
                            end;
                        }
                    }
                    group(Period)
                    {
                        Caption = 'Period';
                        field(StartingDate; pStartingDate)
                        {
                            Caption = 'Starting Date';
                            ShowMandatory = true;
                            ToolTip = 'Specifies the date from which the report or batch job processes information.';

                            // --> BEFORE
                            // trigger OnLookup(var Text: Text): Boolean
                            // var
                            //     AccountingPeriod: Record 50;
                            // begin
                            //     pEndingDate := 0D;
                            //     CLEAR(AccountingPeriod);

                            //     IF (IsAnnualPeriod()) THEN
                            //         AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);

                            //     IF (PAGE.RUNMODAL(0, AccountingPeriod) = ACTION::LookupOK) THEN BEGIN

                            //         pStartingDate := AccountingPeriod."Starting Date";
                            //         IF (IsAnnualPeriod()) THEN BEGIN
                            //             pEndingDate := AccountingPeriod.GetFiscalYearEndDate(pStartingDate);
                            //             IF (pEndingDate = 0D) THEN
                            //                 pEndingDate := CALCDATE('<CY>', pStartingDate)
                            //         END ELSE
                            //             IF (IsTrimestrialPeriod()) THEN
                            //                 pEndingDate := CALCDATE('<CQ>', pStartingDate)
                            //             ELSE
                            //                 IF (IsMensualPeriod()) THEN
                            //                     pEndingDate := CALCDATE('<CM>', pStartingDate);

                            //     END;
                            // end;
                            // <-- AFTER

                            trigger OnLookup(var Text: Text): Boolean
                            var
                                AccountingPeriod: Record 50;
                                VATStatementName: Record "VAT Statement Name";
                            begin
                                pEndingDate := 0D;
                                CLEAR(AccountingPeriod);
                                CLEAR(VATStatementName);
                                VATStatementName.GET(pStatementTemplate, pStatementName);

                                IF (VATStatementName.Periodicity = "VAT Statement Name".Periodicity::Yearly) THEN
                                    AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);

                                IF (PAGE.RUNMODAL(0, AccountingPeriod) = ACTION::LookupOK) THEN BEGIN

                                    pStartingDate := AccountingPeriod."Starting Date";
                                    IF (VATStatementName.Periodicity = "VAT Statement Name".Periodicity::Yearly) THEN BEGIN
                                        pEndingDate := AccountingPeriod.GetFiscalYearEndDate(pStartingDate);
                                        IF (pEndingDate = 0D) THEN
                                            pEndingDate := CALCDATE('<CY>', pStartingDate)
                                    END ELSE
                                        IF (VATStatementName.Periodicity = "VAT Statement Name".Periodicity::Quaterly) THEN
                                            pEndingDate := CALCDATE('<CQ>', pStartingDate)
                                        ELSE
                                            IF (VATStatementName.Periodicity = "VAT Statement Name".Periodicity::Monthly) THEN
                                                pEndingDate := CALCDATE('<CM>', pStartingDate);

                                END;
                            end;
                        }
                        field(EndingDate; pEndingDate)
                        {
                            Caption = 'Ending Date';
                            ShowMandatory = true;
                            ToolTip = 'Specifies the end date for the time interval for VAT statement lines in the report.';
                        }
                    }
                    group(Type)
                    {
                        Caption = 'Recapitulative Statements';
                        Visible = IntracommVISIBLE;
                        field(IntracommGoods; pIntracommGoods)
                        {
                            Caption = 'Intracommunity of Goods';
                        }
                        field(IntracommServices; pIntracommServices)
                        {
                            Caption = 'Intracommunity of Services';
                        }
                        field(EU3PartyTrade; pEU3PartyTrade)
                        {
                            Caption = 'EU 3-Party Trade';
                            Importance = Additional;
                            Visible = false;
                        }
                    }
                    group(Various)
                    {
                        Caption = 'Various';
                        field(Selection; Selection)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include VAT Entries';
                            Importance = Additional;
                            OptionCaption = 'Open,Closed,Open and Closed';
                            ToolTip = 'Specifies if you want to include open VAT entries in the report.';
                        }
                        field(PeriodSelection; PeriodSelection)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include VAT Entries';
                            Importance = Additional;
                            OptionCaption = 'Before and Within Period,Within Period';
                            ToolTip = 'Specifies if you want to include VAT entries from before the specified time period in the report.';
                        }
                        field(RoundToWholeNumbers; PrintInIntegers)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Round to Whole Numbers';
                            Importance = Additional;
                            ToolTip = 'Specifies if you want the amounts in the report to be rounded to whole numbers.';
                        }
                    }
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
    var
        pStatementTemplate: Code[10];
        pStatementName: Code[10];
        pStartingDate: Date;
        pEndingDate: Date;
        [InDataSet]
        IntracommVISIBLE: Boolean;
        pIntracommGoods: Boolean;
        pIntracommServices: Boolean;
        pEU3PartyTrade: Boolean;
        Version: Integer;
        EndDate: Date;
        Amount: Decimal;
        Amount2: Decimal;
        NetAmountLCY: Decimal;
        Selection: Option Open,Closed,"Open and Closed";
        PeriodSelection: Option "Before and Within Period","Within Period";
        PrintInIntegers: Boolean;
        UseAmtsInAddCurr: Boolean;

    // DEACTIVED PROCEDURES DUE TO 

    // local procedure IsAnnualPeriod() lb_Return: Boolean
    // var
    //     VATStatementName: Record "VAT Statement Name";
    // begin
    //     CLEAR(VATStatementName);
    //     VATStatementName.GET(pStatementTemplate, pStatementName);
    //     IF ((COPYSTR(FORMAT(VATStatementName."Statement eCDF Type"), 1, 3) = 'CA_')
    //         OR (COPYSTR(FORMAT(VATStatementName."Statement eCDF Type"), 1, 8) = 'TVA_DECA')) THEN
    //         lb_Return := TRUE
    //     ELSE
    //         lb_Return := FALSE;
    // end;

    // local procedure IsTrimestrialPeriod() lb_Return: Boolean
    // var
    //     VATStatementName: Record "VAT Statement Name";
    // begin
    //     CLEAR(VATStatementName);
    //     VATStatementName.GET(pStatementTemplate, pStatementName);
    //     IF ((COPYSTR(FORMAT(VATStatementName."Statement eCDF Type"), 1, 8) = 'TVA_DECT')
    //         OR (COPYSTR(FORMAT(VATStatementName."Statement eCDF Type"), 1, 8) = 'TVA_LICT')
    //         OR (COPYSTR(FORMAT(VATStatementName."Statement eCDF Type"), 1, 8) = 'TVA_PSIT')) THEN
    //         lb_Return := TRUE
    //     ELSE
    //         lb_Return := FALSE;
    // end;

    // local procedure IsMensualPeriod() lb_Return: Boolean
    // var
    //     VATStatementName: Record "VAT Statement Name";
    // begin
    //     CLEAR(VATStatementName);
    //     VATStatementName.GET(pStatementTemplate, pStatementName);
    //     IF ((COPYSTR(FORMAT(VATStatementName."Statement eCDF Type"), 1, 8) = 'TVA_DECM')
    //         OR (COPYSTR(FORMAT(VATStatementName."Statement eCDF Type"), 1, 8) = 'TVA_LICM')
    //         OR (COPYSTR(FORMAT(VATStatementName."Statement eCDF Type"), 1, 8) = 'TVA_PSIM')) THEN
    //         lb_Return := TRUE
    //     ELSE
    //         lb_Return := FALSE;
    // end;

    local procedure IsIntracommVisible() lb_Return: Boolean
    var
        VATStatementName: Record "VAT Statement Name";
    begin
        CLEAR(VATStatementName);
        VATStatementName.GET(pStatementTemplate, pStatementName);
        IF ((COPYSTR(FORMAT(VATStatementName."Statement eCDF Type"), 1, 8) = 'TVA_DECM')
            OR (COPYSTR(FORMAT(VATStatementName."Statement eCDF Type"), 1, 8) = 'TVA_DECT')) THEN
            lb_Return := TRUE
        ELSE
            lb_Return := FALSE;
    end;

    local procedure InsertIntracomData(var VATEntry: Record "VAT Entry"; DeclarationType: Option VAT,INTRAG,INTRAS,INTRAT)
    var
        lCountry: Code[10];
        lVATRegistration: Text[50];
        lCustomer: Code[20];
        EntryNo: Integer;
        eCDFData: Record "eCDF Data";
    begin
        CLEAR(eCDFData);
        eCDFData.SETRANGE("Statement Template Name", "VAT Statement Name"."Statement Template Name");
        eCDFData.SETRANGE("Statement Name", "VAT Statement Name".Name);
        eCDFData.SETRANGE("Starting Date", pStartingDate);
        eCDFData.SETRANGE("Ending Date", pEndingDate);
        eCDFData.SETRANGE(Version, Version);
        IF eCDFData.FINDLAST THEN BEGIN
            EntryNo := eCDFData."Line No.";
        END;

        REPEAT

            lCustomer := '';
            lCountry := '';
            lVATRegistration := '';
            lCustomer := FindCustomer(VATEntry, lCountry, lVATRegistration);
            EntryNo := EntryNo + 10000;

            CLEAR(eCDFData);
            eCDFData.SETRANGE("Statement Template Name", "VAT Statement Name"."Statement Template Name");
            eCDFData.SETRANGE("Statement Name", "VAT Statement Name".Name);
            eCDFData.SETRANGE("Starting Date", pStartingDate);
            eCDFData.SETRANGE("Ending Date", pEndingDate);
            eCDFData.SETRANGE(Version, Version);
            eCDFData.SETRANGE("Declaration Type", DeclarationType);
            eCDFData.SETRANGE("IntraComm Country/Region Code", lCountry);
            eCDFData.SETRANGE("IntraComm VAT Registration No.", lVATRegistration);
            IF (eCDFData.FINDSET(TRUE, FALSE) = FALSE) THEN BEGIN

                CLEAR(eCDFData);
                eCDFData.VALIDATE("Statement Template Name", "VAT Statement Name"."Statement Template Name");
                eCDFData.VALIDATE("Statement Name", "VAT Statement Name".Name);
                eCDFData.VALIDATE("Starting Date", pStartingDate);
                eCDFData.VALIDATE("Ending Date", pEndingDate);
                eCDFData.VALIDATE(Version, Version);
                eCDFData.VALIDATE("Line No.", "VAT Statement Line"."Line No." + EntryNo);
                eCDFData.VALIDATE("Row No.", '');
                eCDFData.VALIDATE(Description, '');
                eCDFData."Declaration Type" := DeclarationType;
                eCDFData."IntraComm Country/Region Code" := lCountry;
                eCDFData."IntraComm VAT Registration No." := lVATRegistration;
                IF (lCountry = '') OR (lVATRegistration = '') THEN BEGIN
                    eCDFData.VALIDATE(Status, eCDFData.Status::NOK);
                END;

                eCDFData.VALIDATE("IntraComm Customer No.", lCustomer);
                eCDFData.INSERT(TRUE);

            END;

            eCDFData.VALIDATE("Calculated Value", eCDFData."Calculated Value" - VATEntry.Base);
            eCDFData.MODIFY(TRUE);

        UNTIL (VATEntry.NEXT = 0);
    end;

    /// <summary>
    /// CalcLineTotal.
    /// </summary>
    /// <param name="VATStmtLine2">Record 256.</param>
    /// <param name="TotalAmount">VAR Decimal.</param>
    /// <param name="CorrectionAmount">VAR Decimal.</param>
    /// <param name="NetAmountLCY">VAR Decimal.</param>
    /// <param name="JournalTempl">Code[10].</param>
    /// <param name="Level">Integer.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure CalcLineTotal(VATStmtLine2: Record 256; var TotalAmount: Decimal; var CorrectionAmount: Decimal; var NetAmountLCY: Decimal; JournalTempl: Code[10]; Level: Integer): Boolean
    var
        GLAcc: Record "G/L Account";
        VATEntry: Record "VAT Entry";
        GLEntry: Record "G/L Entry";
        RowNo: array[6] of Code[10];
        ErrorText: Text[80];
        i: Integer;
    begin
        // << This function exists in Report 12 >>
        IF Level = 0 THEN BEGIN
            TotalAmount := 0;
            NetAmountLCY := 0;
            CorrectionAmount := 0;
        END;

        CalcCorrection(VATStmtLine2, CorrectionAmount);
        CASE VATStmtLine2.Type OF
            VATStmtLine2.Type::"Account Totaling":
                BEGIN
                    GLAcc.SETFILTER("No.", VATStmtLine2."Account Totaling");
                    IF pEndingDate = 0D THEN
                        EndDate := DMY2DATE(31, 12, 9999)
                    ELSE
                        EndDate := pEndingDate;
                    GLEntry.SETCURRENTKEY("Journal Templ. Name", "G/L Account No.", "Posting Date", "Document Type");
                    GLEntry.SETRANGE("Posting Date", GetPeriodStartDate, EndDate);
                    IF JournalTempl <> '' THEN
                        GLEntry.SETRANGE("Journal Templ. Name", JournalTempl);

                    IF VATStmtLine2."Document Type" = VATStmtLine2."Document Type"::"All except Credit Memo" THEN
                        GLEntry.SETFILTER("Document Type", '<>%1', VATStmtLine2."Document Type"::"Credit Memo")
                    ELSE
                        GLEntry.SETRANGE("Document Type", VATStmtLine2."Document Type");
                    //EK-LU-1
                    IF VATStmtLine2."Document Type" = VATStmtLine2."Document Type"::" " THEN
                        GLEntry.SETRANGE("Document Type");
                    //EK-LU-1
                    Amount := 0;
                    Amount2 := 0;
                    IF GLAcc.FIND('-') AND (VATStmtLine2."Account Totaling" <> '') THEN
                        REPEAT
                            GLEntry.SETRANGE("G/L Account No.", GLAcc."No.");
                            GLEntry.CALCSUMS(Amount, GLEntry."Additional-Currency Amount");
                            Amount := ConditionalAdd(Amount, GLEntry.Amount, GLEntry."Additional-Currency Amount");
                            Amount2 := Amount;
                        UNTIL GLAcc.NEXT = 0;
                    CalcTotalAmount(VATStmtLine2, TotalAmount, NetAmountLCY);
                END;
            VATStmtLine2.Type::"VAT Entry Totaling":
                BEGIN
                    VATEntry.RESET;
                    VATEntry.SETCURRENTKEY(
                      "Journal Templ. Name", Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Document Type", "Posting Date");
                    //EK-LU-1 VATEntry.SETRANGE("VAT Bus. Posting Group",VATStmtLine2."VAT Bus. Posting Group");
                    //EK-LU-1 VATEntry.SETRANGE("VAT Prod. Posting Group",VATStmtLine2."VAT Prod. Posting Group");
                    //VATEntry.SETFILTER("VAT Bus. Posting Group", VATStmtLine2."VAT Bus. Posting Group");  //EK-LU
                    //VATEntry.SETFILTER("VAT Prod. Posting Group", VATStmtLine2."VAT Prod. Posting Group");//EK-LU
                    VATEntry.SETFILTER("VAT Bus. Posting Group", VATStmtLine2."VAT Lux. Bus. Posting Group");  //EK-LU
                    VATEntry.SETFILTER("VAT Prod. Posting Group", VATStmtLine2."VAT Lux. Prod. Posting Group");//EK-LU

                    IF JournalTempl <> '' THEN
                        VATEntry.SETRANGE("Journal Templ. Name", JournalTempl);
                    VATEntry.SETRANGE(Type, VATStmtLine2."Gen. Posting Type");
                    IF VATStmtLine2."Document Type" = VATStmtLine2."Document Type"::"All except Credit Memo" THEN
                        VATEntry.SETFILTER("Document Type", '<>%1', VATStmtLine2."Document Type"::"Credit Memo")
                    ELSE
                        VATEntry.SETRANGE("Document Type", VATStmtLine2."Document Type");
                    //EK-LU-1
                    IF VATStmtLine2."Document Type" = VATStmtLine2."Document Type"::" " THEN
                        VATEntry.SETRANGE("Document Type");
                    //EK-LU-1
                    IF (pEndingDate <> 0D) OR (pStartingDate <> 0D) THEN
                        VATEntry.SETRANGE("Posting Date", GetPeriodStartDate, EndDate);
                    CASE Selection OF
                        Selection::Open:
                            VATEntry.SETRANGE(Closed, FALSE);
                        Selection::Closed:
                            VATEntry.SETRANGE(Closed, TRUE);
                        ELSE
                            VATEntry.SETRANGE(Closed);
                    END;
                    CASE VATStmtLine2."Amount Type" OF
                        VATStmtLine2."Amount Type"::Amount:
                            BEGIN
                                VATEntry.CALCSUMS(Amount, "Additional-Currency Amount");
                                Amount := ConditionalAdd(0, VATEntry.Amount, VATEntry."Additional-Currency Amount");
                                IF NOT VATStmtLine2."Incl. Non Deductible VAT" THEN BEGIN
                                    VATEntry.CALCSUMS("Non Ded. VAT Amount", "Non Ded. Source Curr. VAT Amt.");
                                    Amount := ConditionalAdd(Amount, VATEntry."Non Ded. VAT Amount", VATEntry."Non Ded. Source Curr. VAT Amt.");
                                END;
                                //EK-LU-1
                                /*IF VATStmtLine2."Only Non Deductible VAT" THEN BEGIN
                                    VATEntry.CALCSUMS("Non Ded. VAT Amount", "Non Ded. Source Curr. VAT Amt.");
                                    Amount := ConditionalAdd(0, VATEntry."Non Ded. VAT Amount", VATEntry."Non Ded. Source Curr. VAT Amt.");
                                END;*/
                                //EK-LU-1
                                Amount2 := Amount;
                            END;
                        VATStmtLine2."Amount Type"::Base:
                            BEGIN
                                VATEntry.CALCSUMS(Base, "Additional-Currency Base", "Base Before Pmt. Disc.");
                                Amount := ConditionalAdd(0, VATEntry.Base, VATEntry."Additional-Currency Base");
                                IF NOT VATStmtLine2."Incl. Non Deductible VAT" THEN BEGIN
                                    VATEntry.CALCSUMS("Non Ded. VAT Amount", "Non Ded. Source Curr. VAT Amt.");
                                    Amount := ConditionalAdd(Amount, -VATEntry."Non Ded. VAT Amount", -VATEntry."Non Ded. Source Curr. VAT Amt.");
                                END;
                                Amount2 := ConditionalAdd(0, VATEntry."Base Before Pmt. Disc.", 0);
                            END;
                        VATStmtLine2."Amount Type"::"Unrealized Amount":
                            BEGIN
                                VATEntry.CALCSUMS("Remaining Unrealized Amount", "Add.-Curr. Rem. Unreal. Amount");
                                Amount := ConditionalAdd(0, VATEntry."Remaining Unrealized Amount", VATEntry."Add.-Curr. Rem. Unreal. Amount");
                                Amount2 := Amount;
                            END;
                        VATStmtLine2."Amount Type"::"Unrealized Base":
                            BEGIN
                                VATEntry.CALCSUMS("Remaining Unrealized Base", "Add.-Curr. Rem. Unreal. Base");
                                Amount := ConditionalAdd(0, VATEntry."Remaining Unrealized Base", VATEntry."Add.-Curr. Rem. Unreal. Base");
                                Amount2 := Amount;
                            END;
                    END;
                    CalcTotalAmount(VATStmtLine2, TotalAmount, NetAmountLCY);
                END;
            VATStmtLine2.Type::"Row Totaling":
                BEGIN
                    IF Level >= ARRAYLEN(RowNo) THEN
                        EXIT(FALSE);
                    Level := Level + 1;
                    RowNo[Level] := VATStmtLine2."Row No.";

                    IF VATStmtLine2."Row Totaling" = '' THEN
                        EXIT(TRUE);
                    VATStmtLine2.SETRANGE("Statement Template Name", VATStmtLine2."Statement Template Name");
                    VATStmtLine2.SETRANGE("Statement Name", VATStmtLine2."Statement Name");
                    VATStmtLine2.SETFILTER("Row No.", VATStmtLine2."Row Totaling");
                    IF VATStmtLine2.FIND('-') THEN
                        REPEAT
                            IF NOT CalcLineTotal(VATStmtLine2, TotalAmount, CorrectionAmount, NetAmountLCY, JournalTempl, Level) THEN BEGIN
                                IF Level > 1 THEN
                                    EXIT(FALSE);
                                FOR i := 1 TO ARRAYLEN(RowNo) DO
                                    ErrorText := ErrorText + RowNo[i] + ' => ';
                                ErrorText := ErrorText + '...';
                                VATStmtLine2.FIELDERROR("Row No.", ErrorText);
                            END;
                        UNTIL VATStmtLine2.NEXT = 0;
                END;
        END;

        EXIT(TRUE);
    end;

    local procedure CalcCorrection(VATStmtLine2: Record "VAT Statement Line"; var CorrectionAmount: Decimal)
    var
        ManualVATCorrection: Record "Manual VAT Correction";
    begin
        // << This function exists in Report 12 >>
        CalcManualVATCorrectionSums(VATStmtLine2, ManualVATCorrection);
        Amount := ConditionalAdd(0, ManualVATCorrection.Amount, ManualVATCorrection."Additional-Currency Amount");
        IF VATStmtLine2."Calculate with" = VATStmtLine2."Calculate with"::"Opposite Sign" THEN
            Amount := -Amount;
        IF PrintInIntegers AND VATStmtLine2.Print THEN
            Amount := ROUND(Amount, 1, '<');
        CorrectionAmount := CorrectionAmount + Amount;
    end;

    local procedure CalcTotalAmount(VATStmtLine2: Record "VAT Statement Line"; var TotalAmount: Decimal; var NetAmountLCY: Decimal)
    begin
        // << This function exists in Report 12 >>
        IF VATStmtLine2."Calculate with" = 1 THEN BEGIN
            Amount := -Amount;
            Amount2 := -Amount2;
        END;
        IF PrintInIntegers AND VATStmtLine2.Print THEN BEGIN
            Amount := ROUND(Amount, 1, '<');
            Amount2 := ROUND(Amount2, 1, '<');
        END;
        TotalAmount := TotalAmount + Amount;
        NetAmountLCY := NetAmountLCY + Amount2;
    end;

    local procedure CalcManualVATCorrectionSums(VATStmtLine2: Record "VAT Statement Line"; var ManualVATCorrection: Record 11301)
    begin
        // << This function exists in Report 12 >>
        ManualVATCorrection.RESET;
        ManualVATCorrection.SETRANGE("Statement Template Name", VATStmtLine2."Statement Template Name");
        ManualVATCorrection.SETRANGE("Statement Name", VATStmtLine2."Statement Name");
        ManualVATCorrection.SETRANGE("Statement Line No.", VATStmtLine2."Line No.");
        ManualVATCorrection.SETRANGE("Posting Date", GetPeriodStartDate, EndDate);
        ManualVATCorrection.CALCSUMS(Amount, "Additional-Currency Amount");
    end;

    local procedure ConditionalAdd(Amount: Decimal; AmountToAdd: Decimal; AddCurrAmountToAdd: Decimal): Decimal
    begin
        // << This function exists in Report 12 >>
        IF UseAmtsInAddCurr THEN
            EXIT(Amount + AddCurrAmountToAdd);

        EXIT(Amount + AmountToAdd);
    end;

    local procedure GetPeriodStartDate(): Date
    begin
        // << This function exists in Report 12 >>
        IF PeriodSelection = PeriodSelection::"Before and Within Period" THEN
            EXIT(19000101D);//EK-LU 0D to 01010002D
        EXIT(pStartingDate);
    end;

    local procedure FindCustomer(PVATEntry: Record "VAT Entry"; var pCountry: Code[20]; var pVATRegistrationNo: Text[50]) pCustomer: Code[20]
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        lCustomer: Record Customer;
    begin
        pCountry := COPYSTR(PVATEntry."Country/Region Code", 1, 2);
        IF (PVATEntry."VAT Registration No." <> '') THEN
            pVATRegistrationNo := PVATEntry."VAT Registration No."
        ELSE
            IF (PVATEntry."Enterprise No." <> '') THEN
                pVATRegistrationNo := PVATEntry."Enterprise No.";

        IF PVATEntry."Document Type" = PVATEntry."Document Type"::Invoice THEN BEGIN

            IF SalesInvoiceHeader.GET(PVATEntry."Document No.") THEN
                pCustomer := SalesInvoiceHeader."Bill-to Customer No.";

        END ELSE
            IF PVATEntry."Document Type" = PVATEntry."Document Type"::"Credit Memo" THEN BEGIN

                IF SalesCrMemoHeader.GET(PVATEntry."Document No.") THEN
                    pCustomer := SalesCrMemoHeader."Bill-to Customer No.";

            END;

        IF lCustomer.GET(pCustomer) THEN BEGIN

            IF (pCountry = '') THEN
                pCountry := lCustomer."Country/Region Code";

            IF (pVATRegistrationNo = '') THEN BEGIN

                IF (lCustomer."VAT Registration No." <> '') THEN
                    pVATRegistrationNo := lCustomer."VAT Registration No."
                ELSE
                    IF (lCustomer."Enterprise No." <> '') THEN
                        pVATRegistrationNo := lCustomer."Enterprise No.";
            END;

        END;

    end;
}
