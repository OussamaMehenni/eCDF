/// <summary>
/// Report VAT Declaration Corrections (ID 50904).
/// </summary>
report 50904 "VAT Declaration Corrections"
{
    ApplicationArea = All;
    Caption = 'VAT Declaration Corrections';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field("Declaration Type"; gRequestParamDeclarationType)
                    {
                        Caption = 'Declaration Type';
                        Editable = false;
                        Enabled = false;
                    }
                    field("Country code"; gRequestParamCountryCode)
                    {
                        Caption = 'Country/Region Code';
                        ShowMandatory = true;
                        TableRelation = "Country/Region" WHERE("EU Country/Region Code" = FILTER(<> ''));

                        trigger OnValidate()
                        begin
                            if (gRequestParamCountryCode = '') then
                                ERROR(Text50000, TextCountry);
                        end;
                    }
                    field(VATRegistrationNo; gRequestParamVATRegistrationNo)
                    {
                        Caption = 'VAT Registration No.';
                        ShowMandatory = true;

                        trigger OnValidate()
                        begin
                            IF (gRequestParamVATRegistrationNo = '') THEN
                                ERROR(Text50000, TextVATNO);
                        end;
                    }
                    field(Year; gRequestParamYear)
                    {
                        Caption = 'Year';
                        NotBlank = true;
                        ShowMandatory = true;

                        trigger OnValidate()
                        begin
                            IF (gRequestParamYear = 0) THEN
                                ERROR(Text50000, TextYear);
                        end;
                    }
                    field(Quarter; gRequestParamQuarter)
                    {
                        Caption = 'Quarter (1-4)';
                        //ValuesAllowed = 0;1;2;3;4;
                    }
                    field(Month; gRequestParamMonth)
                    {
                        Caption = 'Month (1-12)';
                        //ValuesAllowed = 0;1;2;3;4;5;6;7;8;9;10;11;12;
                    }
                    field(Correction; gRequestParamCorrAmount)
                    {
                        Caption = 'Correction by a +/- amount';
                        ShowMandatory = true;
                    }
                    field("Triangular operations"; gRequestParamTriangularOp)
                    {
                        Caption = 'Triangular operations';
                        Visible = gShowTriangularOp;
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

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        var
            lCustomer: Record 18;
            lVendor: Record 23;
            lTierFound: Boolean;
            lDateFromQuarter: Integer;
        begin
            IF (CloseAction = ACTION::OK) THEN BEGIN

                //BEGIN - Check tiers
                lTierFound := TRUE;

                CLEAR(lCustomer);
                lCustomer.SETRANGE("VAT Registration No.", gRequestParamVATRegistrationNo);
                IF (lCustomer.FINDFIRST = FALSE) THEN
                    lTierFound := FALSE;

                CLEAR(lVendor);
                lVendor.SETRANGE("VAT Registration No.", gRequestParamVATRegistrationNo);
                IF (lVendor.FINDFIRST = FALSE) THEN
                    lTierFound := FALSE;

                //IF (lTierFound = FALSE) THEN
                //ERROR(TextVATNOCheck, TextVATNO);
                //END - Check tiers

                IF (gRequestParamCountryCode = '') THEN
                    ERROR(Text50000, TextCountry);

                IF (gRequestParamVATRegistrationNo = '') THEN
                    ERROR(Text50000, TextVATNO);

                IF (gRequestParamYear = 0) THEN
                    ERROR(Text50000, TextYear);

                IF ((gRequestParamQuarter = 0) AND (gRequestParamMonth = 0)) THEN
                    ERROR(Text50001, TextQuarter, TextMonth);

                IF ((gRequestParamQuarter <> 0) AND (gRequestParamMonth <> 0)) THEN
                    ERROR(Text50001, TextQuarter, TextMonth);

                IF (gRequestParamMonth = 0) THEN BEGIN

                    IF ((gRequestParamQuarter < 1) OR (gRequestParamQuarter > 4)) THEN
                        ERROR(Text50002, TextQuarter);

                END;

                IF (gRequestParamQuarter = 0) THEN BEGIN

                    IF ((gRequestParamMonth < 1) OR (gRequestParamMonth > 12)) THEN
                        ERROR(Text50002, TextMonth);

                END;

                IF (gRequestParamCorrAmount = 0) THEN
                    ERROR(Text50000, TextCorrAmout);

                IF (gRequestParamQuarter <> 0) THEN BEGIN

                    IF (CALCDATE('<CM>', DMY2DATE(1, gRequestParamQuarter * 3, gRequestParamYear)) >= gStartingDate) THEN
                        ERROR(TextComparePeriod + Text50002, TextYear + ', ' + TextQuarter);

                END;

                IF (gRequestParamMonth <> 0) THEN BEGIN

                    IF (DMY2DATE(1, gRequestParamMonth, gRequestParamYear) >= gStartingDate) THEN
                        ERROR(TextComparePeriod + Text50002, TextYear + ', ' + TextMonth);

                END;

            END;
        end;

    }

    labels
    {
    }

    trigger OnPostReport()
    var
        leCDFData: Record "eCDF Data";
    begin
        //Set header
        leCDFData.VALIDATE("Statement Template Name", gStatementTemplateName);
        leCDFData.VALIDATE("Statement Name", gStatementName);
        leCDFData.VALIDATE("Starting Date", gStartingDate);
        leCDFData.VALIDATE("Ending Date", gEndingDate);
        leCDFData.VALIDATE(Version, gVersion);
        leCDFData.VALIDATE("Declaration Type", gDeclarationType);
        leCDFData.VALIDATE("Line No.", gLineNo);

        //Set parameters
        leCDFData.VALIDATE("IntraComm Country/Region Code", gRequestParamCountryCode);
        leCDFData.VALIDATE("IntraComm VAT Registration No.", gRequestParamVATRegistrationNo);
        leCDFData.VALIDATE("Correction Year", gRequestParamYear);
        leCDFData.VALIDATE("Correction Quarter", gRequestParamQuarter);
        leCDFData.VALIDATE("Correction Month", gRequestParamMonth);
        leCDFData.VALIDATE("Correction Amount", gRequestParamCorrAmount);
        leCDFData.VALIDATE("Correction Triang. Op.", gRequestParamTriangularOp);

        leCDFData.INSERT(TRUE);
    end;

    var
        gRequestParamDeclarationType: Text[20];
        gRequestParamCountryCode: Code[10];
        gRequestParamVATRegistrationNo: Text[50];
        gRequestParamYear: Integer;
        gRequestParamQuarter: Integer;
        gRequestParamMonth: Integer;
        gRequestParamCorrAmount: Decimal;
        gRequestParamTriangularOp: Boolean;
        gStatementTemplateName: Code[10];
        gStatementName: Code[10];
        gStartingDate: Date;
        gEndingDate: Date;
        gVersion: Integer;
        gDeclarationType: Option VAT,INTRAG,INTRAS;
        gLineNo: Integer;
        Text50000: Label 'Please complete the following field: ''%1''';
        Text50001: Label 'Please complete one of the following fields: ''%1'' or ''%2''';
        Text50002: Label 'Please check the following field(s): ''%1''';
        TextCountry: Label 'Country/Region Code';
        TextVATNO: Label 'VAT Registration No.';
        TextYear: Label 'Year';
        TextQuarter: Label 'Quarter';
        TextMonth: Label 'Month';
        TextComparePeriod: Label 'The period must be lower than starting date of declaration. ';
        TextCorrAmout: Label 'Correction Amount';
        TextVATNOCheck: Label '''%1'' not found in database!';
        TextDeclarationTypeINTRAG: Label 'Intra. Goods';
        TextDeclarationTypeINTRAS: Label 'Intra. Services';
        [InDataSet]
        gShowTriangularOp: Boolean;

    /// <summary>
    /// InitParameters.
    /// </summary>
    /// <param name="Statement Template Name">Code[10].</param>
    /// <param name="Statement Name">Code[10].</param>
    /// <param name="Starting Date">Date.</param>
    /// <param name="Ending Date">Date.</param>
    /// <param name="Version">Integer.</param>
    /// <param name="Declaration_Type">Option VAT,INTRAG,INTRAS.</param>
    /// <param name="Line No.">Integer.</param>
    procedure InitParameters("Statement Template Name": Code[10]; "Statement Name": Code[10]; "Starting Date": Date; "Ending Date": Date; Version: Integer; Declaration_Type: Option VAT,INTRAG,INTRAS; "Line No.": Integer)
    var
        lLuxembourgVATData: Record 50901;
    begin
        gStatementTemplateName := "Statement Template Name";
        gStatementName := "Statement Name";
        gStartingDate := "Starting Date";
        gEndingDate := "Ending Date";
        gVersion := Version;

        gDeclarationType := Declaration_Type;
        gShowTriangularOp := TRUE;
        IF (Declaration_Type = Declaration_Type::INTRAG) THEN
            gRequestParamDeclarationType := TextDeclarationTypeINTRAG
        ELSE BEGIN
            gRequestParamDeclarationType := TextDeclarationTypeINTRAS;
            gShowTriangularOp := FALSE;
        END;

        gLineNo := "Line No."
    end;
}
