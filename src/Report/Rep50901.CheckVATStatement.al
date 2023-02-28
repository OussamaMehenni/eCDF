/// <summary>
/// Report CheckVAT Statement (ID "eCDF Rules").
/// </summary>
report 50901 "Check VAT Statement"
{
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'CheckVAT Statement';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("eCDF Data"; "eCDF Data")
        {


            trigger OnAfterGetRecord()
            var
                eCDFRules: Record "eCDF Rules";
                CalculateAmount: Decimal;
                ldec: Decimal;
                eCDFData: Record "eCDF Data";
                lDay1: Integer;
                lDay2: Integer;
                lMonth1: Integer;
                lMonth2: Integer;
                lErrorMessage: Text[250];
                lCustomer: Record 18;
                CalculateAmountC1212: Decimal;
                CalculateAmountD1212: Decimal;
                CheckTotaleCDFData: Record "eCDF Data";
                CheckTotalBalance: Decimal;
                FinalValueeCDFDataLine: Decimal;
            begin
                RecNo := RecNo + 1;
                Window.UPDATE(1, ROUND(RecNo / TotalRecNo * 10000, 1));

                VALIDATE("Last Error Message", '');
                VALIDATE(Status, "eCDF Data".Status::OK);
                MODIFY(TRUE);

                IF "eCDF Data"."Declaration Type" = "eCDF Data"."Declaration Type"::VAT THEN BEGIN
                    eCDFRules.SETRANGE("Statement Template Name", "Statement Template Name");
                    eCDFRules.SETRANGE("Statement Name", "Statement Name");
                    eCDFRules.SETRANGE("Start Date Validity", 0D, "eCDF Data"."Starting Date");
                    eCDFRules.SETFILTER("End Date Validity", '%1|>=%2', 0D, "eCDF Data"."Starting Date");
                    eCDFRules.SETRANGE("Row No.", "Row No.");
                    IF eCDFRules.FINDSET THEN
                        REPEAT
                            CASE eCDFRules."Rule Type" OF

                                // Mandatory
                                //OK;
                                // Mandatory if
                                //OK;

                                // Equal, "Equal if Positive", "Equal if Positive or 0"
                                eCDFRules."Rule Type"::Equal,
                                eCDFRules."Rule Type"::"Equal if Positive",
                                eCDFRules."Rule Type"::"Equal if Positive or 0":
                                    BEGIN
                                        IF eCDFRules."Data Type" IN [eCDFRules."Data Type"::Integer, eCDFRules."Data Type"::Numeric] THEN BEGIN

                                            CalculateAmount := EvaluateExpression(eCDFData, eCDFRules, eCDFRules.Control);

                                            IF NOT (EVALUATE(ldec, "Final Value")) THEN BEGIN
                                                VALIDATE("Last Error Message", STRSUBSTNO(TextnonEqual, CalculateAmount, eCDFRules.Control));
                                                VALIDATE(Status, eCDFData.Status::NOK);
                                                MODIFY(TRUE);
                                            END;

                                            IF ((eCDFRules."Rule Type" = eCDFRules."Rule Type"::"Equal if Positive") AND (CalculateAmount <= 0)) OR
                                                ((eCDFRules."Rule Type" = eCDFRules."Rule Type"::"Equal if Positive or 0") AND (CalculateAmount < 0)) THEN BEGIN
                                                //nothing to do as the condition for the equality is not valid
                                            END

                                            ELSE
                                                IF ldec <> CalculateAmount THEN BEGIN
                                                    VALIDATE("Last Error Message", STRSUBSTNO(TextnonEqual, CalculateAmount, eCDFRules.Control));
                                                    VALIDATE(Status, eCDFData.Status::NOK);
                                                    MODIFY(TRUE);
                                                END;
                                        END;
                                    END;

                                // Not equal
                                eCDFRules."Rule Type"::"Not equal":
                                    BEGIN
                                        IF eCDFRules."Data Type" IN [eCDFRules."Data Type"::Integer, eCDFRules."Data Type"::Numeric, eCDFRules."Data Type"] THEN BEGIN
                                            CalculateAmount := EvaluateExpression("eCDF Data", eCDFRules, eCDFRules.Control);
                                            IF NOT (EVALUATE(ldec, "Final Value")) THEN BEGIN
                                                VALIDATE("Last Error Message", STRSUBSTNO(TextnonEqual, CalculateAmount, eCDFRules.Control));
                                                VALIDATE(Status, eCDFData.Status::NOK);
                                                MODIFY(TRUE);
                                            END;
                                            IF ldec = CalculateAmount THEN BEGIN
                                                VALIDATE("Last Error Message", STRSUBSTNO(TextnonEqual, CalculateAmount, eCDFRules.Control));
                                                VALIDATE(Status, eCDFData.Status::NOK);
                                                MODIFY(TRUE);
                                            END;
                                        END;
                                    END;

                                //less than
                                eCDFRules."Rule Type"::"Less Than":
                                    BEGIN
                                        IF eCDFRules."Data Type" IN [eCDFRules."Data Type"::Integer, eCDFRules."Data Type"::Numeric] THEN BEGIN
                                            CalculateAmount := EvaluateExpression("eCDF Data", eCDFRules, eCDFRules.Control);
                                            IF NOT (EVALUATE(ldec, "Final Value")) THEN BEGIN
                                                VALIDATE("Last Error Message", STRSUBSTNO(TextnonEqual, CalculateAmount, eCDFRules.Control));
                                                VALIDATE(Status, eCDFData.Status::NOK);
                                                MODIFY(TRUE);
                                            END;
                                            IF ldec > CalculateAmount THEN BEGIN
                                                VALIDATE("Last Error Message", STRSUBSTNO(Textless, CalculateAmount, eCDFRules.Control));
                                                VALIDATE(Status, eCDFData.Status::NOK);
                                                MODIFY(TRUE);
                                            END;
                                        END;
                                    END;

                                //better than
                                eCDFRules."Rule Type"::"Better Than":
                                    BEGIN
                                        IF eCDFRules."Data Type" IN [eCDFRules."Data Type"::Integer, eCDFRules."Data Type"::Numeric] THEN BEGIN
                                            CalculateAmount := EvaluateExpression("eCDF Data", eCDFRules, eCDFRules.Control);
                                            IF NOT (EVALUATE(ldec, "Final Value")) THEN BEGIN
                                                VALIDATE("Last Error Message", STRSUBSTNO(TextnonEqual, CalculateAmount, eCDFRules.Control));
                                                VALIDATE(Status, eCDFData.Status::NOK);
                                                MODIFY(TRUE);
                                            END;
                                            IF ldec < CalculateAmount THEN BEGIN
                                                VALIDATE("Last Error Message", STRSUBSTNO(TextBetter, CalculateAmount, eCDFRules.Control));
                                                VALIDATE(Status, eCDFData.Status::NOK);
                                                MODIFY(TRUE);
                                            END;
                                        END;
                                    END;
                                //interval

                                eCDFRules."Rule Type"::Interval:
                                    BEGIN
                                        IF eCDFRules."Data Type" IN [eCDFRules."Data Type"::Integer, eCDFRules."Data Type"::Numeric, eCDFRules."Data Type"::Percent, eCDFRules."Data Type"::Boolean] THEN BEGIN
                                            IF "Final Value" <> '' THEN BEGIN
                                                IF NOT (EVALUATE(ldec, "Final Value")) THEN BEGIN
                                                    VALIDATE("Last Error Message", STRSUBSTNO(TextInterval, eCDFRules."Min. Value", eCDFRules."Max. Value"));
                                                    VALIDATE(Status, eCDFData.Status::NOK);
                                                    MODIFY(TRUE);
                                                END;
                                                IF (ldec > eCDFRules."Max. Value") OR (ldec < eCDFRules."Min. Value") THEN BEGIN
                                                    VALIDATE("Last Error Message", STRSUBSTNO(TextInterval, eCDFRules."Min. Value", eCDFRules."Max. Value"));
                                                    VALIDATE(Status, eCDFData.Status::NOK);
                                                    MODIFY(TRUE);
                                                END;
                                            END;
                                        END ELSE BEGIN
                                            IF "Final Value" <> '' THEN BEGIN
                                                VALIDATE("Last Error Message", STRSUBSTNO(TextInterval, eCDFRules."Min. Value", eCDFRules."Max. Value"));
                                                VALIDATE(Status, eCDFData.Status::NOK);
                                                MODIFY(TRUE);
                                            END;
                                        END;
                                    END;

                                //Length
                                eCDFRules."Rule Type"::Length:
                                    BEGIN
                                        IF (STRLEN("Final Value") < eCDFRules."Min. Value") OR (STRLEN("Final Value") > eCDFRules."Max. Value") THEN BEGIN
                                            VALIDATE("Last Error Message", TextLenght);
                                            VALIDATE(Status, eCDFData.Status::NOK);
                                            MODIFY(TRUE);
                                        END;
                                    END;

                                //Date
                                eCDFRules."Rule Type"::Date:
                                    BEGIN
                                        IF NOT (EvaluateDate("eCDF Data", eCDFRules.Day1, eCDFRules.Month1, eCDFRules.Sign, eCDFRules.Day2, eCDFRules.Month2, lErrorMessage)) THEN BEGIN
                                            VALIDATE("Last Error Message", lErrorMessage);
                                            VALIDATE(Status, eCDFData.Status::NOK);
                                            MODIFY(TRUE);
                                        END;
                                    END;

                            END;
                        UNTIL eCDFRules.NEXT = 0;

                END ELSE BEGIN
                    // <> vat
                    IF ("IntraComm Country/Region Code" = '') OR ("IntraComm VAT Registration No." = '') THEN BEGIN
                        IF lCustomer.GET("IntraComm Customer No.") THEN BEGIN
                            VALIDATE("IntraComm Country/Region Code", lCustomer."Country/Region Code");
                            VALIDATE("IntraComm VAT Registration No.", lCustomer."VAT Registration No." + lCustomer."Enterprise No.");
                            MODIFY(TRUE);
                            IF ("IntraComm Country/Region Code" = '') OR ("IntraComm VAT Registration No." = '') THEN BEGIN
                                VALIDATE(Status, eCDFData.Status::NOK);
                            END ELSE BEGIN
                                VALIDATE(Status, eCDFData.Status::OK);
                            END;
                            MODIFY(TRUE);
                        END;
                    END;

                END;

                IF ("eCDF Data"."Row No." = 'C1112') THEN BEGIN
                    CheckTotalBalance := 0;
                    FinalValueeCDFDataLine := 0;

                    CheckTotaleCDFData.RESET;
                    CheckTotaleCDFData.SETRANGE("Statement Template Name", "eCDF Data"."Statement Template Name");
                    CheckTotaleCDFData.SETRANGE("Statement Name", "eCDF Data"."Statement Name");
                    CheckTotaleCDFData.SETRANGE("Starting Date", "eCDF Data"."Starting Date");
                    CheckTotaleCDFData.SETRANGE("Ending Date", "eCDF Data"."Ending Date");
                    CheckTotaleCDFData.SETRANGE(Version, "eCDF Data".Version);

                    // Compute Total debit balance account
                    //CheckTotaleCDFData.SETRANGE("Calc Total Deb. Balance Sheet", TRUE);  //TO DEFINE
                    IF CheckTotaleCDFData.FINDFIRST THEN
                        REPEAT
                            EVALUATE(FinalValueeCDFDataLine, CheckTotaleCDFData."Final Value");
                            CheckTotalBalance := CheckTotalBalance + FinalValueeCDFDataLine;
                        UNTIL CheckTotaleCDFData.NEXT = 0;

                    // Compute Total credit balance account
                    //CheckTotaleCDFData.SETRANGE("Calc Total Deb. Balance Sheet");    //TO DEFINE

                    //CheckTotaleCDFData.SETRANGE("Calc Total Cre. Balance Sheet", TRUE);  //TO DEFINE
                    IF CheckTotaleCDFData.FINDFIRST THEN
                        REPEAT
                            EVALUATE(FinalValueeCDFDataLine, CheckTotaleCDFData."Final Value");
                            CheckTotalBalance := CheckTotalBalance - FinalValueeCDFDataLine;
                        UNTIL CheckTotaleCDFData.NEXT = 0;

                    // Check Total Deb - Total Cre -> 0
                    IF CheckTotalBalance <> 0 THEN BEGIN
                        VALIDATE("Last Error Message", TextTotalBalanceNot0);
                        VALIDATE(Status, eCDFData.Status::NOK);
                        MODIFY(TRUE);
                    END;

                END;

            end;

            trigger OnPreDataItem()
            var
                Text50000: Label 'Loading:\';
            begin
                Window.OPEN(Text50000
                            + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\'
                            + '@2@@@@@@@@@@@@@@@@@@@@@@@@@\');
                Window.UPDATE(1, 0);
                TotalRecNo := COUNT;
            end;

        }

        dataitem("eCDF Rules"; "eCDF Rules")
        {

            DataItemTableView = SORTING("Statement Template Name", "Statement Name", "Row No.", "Rule Number");

            trigger OnAfterGetRecord()
            var
                eCDFData: Record "eCDF Data";
                eCDFData2: Record "eCDF Data";
            begin
                RecNo2 := RecNo2 + 1;
                Window.UPDATE(2, ROUND(RecNo2 / TotalRecNo2 * 10000, 1));


                IF "eCDF Rules"."Rule Type" = "eCDF Rules"."Rule Type"::Mandatory THEN BEGIN
                    eCDFData.SETRANGE("Statement Template Name", "eCDF Data"."Statement Template Name");
                    eCDFData.SETRANGE("Statement Name", "eCDF Data"."Statement Name");
                    eCDFData.SETRANGE("Row No.", "eCDF Rules"."Row No.");
                    eCDFData.SETRANGE(Version, "eCDF Data".Version);
                    IF NOT (eCDFData.FINDFIRST) THEN
                        ERROR(TextMandatory, "Row No.");
                END ELSE BEGIN
                    "eCDF Rules".Control := CONVERTSTR("eCDF Rules".Control, '+', '|');
                    eCDFData.SETRANGE("Statement Template Name", "eCDF Data"."Statement Template Name");
                    eCDFData.SETRANGE("Statement Name", "eCDF Data"."Statement Name");
                    eCDFData.SETFILTER("Row No.", "eCDF Rules".Control);
                    eCDFData.SETRANGE(Version, "eCDF Data".Version);
                    IF eCDFData.FINDSET THEN
                        REPEAT
                            IF eCDFData."Final Value" <> '' THEN BEGIN
                                eCDFData2.SETRANGE("Statement Template Name", eCDFData."Statement Template Name");
                                eCDFData2.SETRANGE("Statement Name", eCDFData."Statement Name");
                                eCDFData2.SETRANGE("Row No.", "eCDF Rules"."Row No.");
                                eCDFData2.SETRANGE(Version, "eCDF Data".Version);
                                IF NOT (eCDFData2.FINDFIRST) THEN
                                    ERROR(TextMandatoryif, "Row No.", "eCDF Rules"."Row No." + ' : ' + FORMAT("eCDF Rules"."Rule Number"));
                            END;
                        UNTIL eCDFData.NEXT = 0;
                END;
            end;

            trigger OnPreDataItem()
            begin
                TotalRecNo2 := COUNT;

                SETRANGE("Statement Template Name", "eCDF Data"."Statement Template Name");
                SETRANGE("Statement Name", "eCDF Data"."Statement Name");
                SETRANGE("Start Date Validity", 0D, "eCDF Data"."Starting Date");
                SETFILTER("End Date Validity", '%1|>=%2', 0D, "eCDF Data"."Starting Date");
                SETRANGE("Rule Type", "eCDF Rules"."Rule Type"::Mandatory, "eCDF Rules"."Rule Type"::"Mandatory if");
            end;

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

    var
        TextMandatory: Label 'This Row Number  %1 is mandatory';
        TextMandatoryif: Label 'This Row Number  %1 is mandatory';
        TextnonEqual: Label 'The total amount is not equal to %1 : %2';
        TextLenght: Label 'Incorrect length';
        TextInterval: Label 'Value not included between %1 and %2';
        TextRowNumbernotfind: Label 'Totalization line not found: %1';
        TextErrorValue: Label 'Invalid value %1 : %2';
        TextErrorDate: Label 'Invalid date Control';
        Window: Dialog;
        TotalRecNo: Integer;
        RecNo: Integer;
        TotalRecNo2: Integer;
        RecNo2: Integer;
        Textless: Label 'The total amount is not less to %1 : %2';
        TextBetter: Label 'The total amount is not better to %1 : %2';
        TextTotalBalanceNot0: Label 'The total balance C1112 is not equal to 0';

    /// <summary>
    /// EvaluateExpression.
    /// </summary>
    /// <param name="eCDFData">Record "eCDF Data".</param>
    /// <param name="eCDFRules">Record 50901.</param>
    /// <param name="Expression">Text.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure EvaluateExpression(eCDFData: Record "eCDF Data"; eCDFRules: Record "eCDF Rules"; Expression: Text): Decimal
    var
        Result: Decimal;
        Parantheses: Integer;
        Operator: Char;
        LeftOperand: Text;
        RightOperand: Text;
        LeftResult: Decimal;
        RightResult: Decimal;
        i: Integer;
        IsExpression: Boolean;
        IsFilter: Boolean;
        Operators: Text[8];
        OperatorNo: Integer;
        AccSchedLineID: Integer;
        CallLevel: Integer;
        Text020: Label 'Because of circular references, the program cannot calculate a formula.';
        DivisionError: Boolean;
        Text012: Label 'You have entered an illegal value or a nonexistent row number.';
        Text013: Label 'You have entered an illegal value or a nonexistent column number.';
        eCDFData2: Record "eCDF Data";
        ldec: Decimal;
    begin
        Result := 0;

        CallLevel := CallLevel + 1;
        IF CallLevel > 25 THEN
            ERROR(Text020);

        Expression := DELCHR(Expression, '<>', ' ');
        IF STRLEN(Expression) > 0 THEN BEGIN
            Parantheses := 0;
            IsExpression := FALSE;
            Operators := '+-*/^%';
            OperatorNo := 1;
            REPEAT
                i := STRLEN(Expression);
                REPEAT
                    IF Expression[i] = '(' THEN
                        Parantheses := Parantheses + 1
                    ELSE
                        IF Expression[i] = ')' THEN
                            Parantheses := Parantheses - 1;
                    IF (Parantheses = 0) AND (Expression[i] = Operators[OperatorNo]) THEN
                        IsExpression := TRUE
                    ELSE
                        i := i - 1;
                UNTIL IsExpression OR (i <= 0);
                IF NOT IsExpression THEN
                    OperatorNo := OperatorNo + 1;
            UNTIL (OperatorNo > STRLEN(Operators)) OR IsExpression;
            IF IsExpression THEN BEGIN
                IF i > 1 THEN
                    LeftOperand := COPYSTR(Expression, 1, i - 1)
                ELSE
                    LeftOperand := '';
                IF i < STRLEN(Expression) THEN
                    RightOperand := COPYSTR(Expression, i + 1)
                ELSE
                    RightOperand := '';
                Operator := Expression[i];
                LeftResult :=
                  EvaluateExpression(
                    eCDFData, eCDFRules, LeftOperand);
                IF (RightOperand = '') AND (Operator = '%')
                THEN BEGIN
                    RightResult :=
                      EvaluateExpression(
                        eCDFData, eCDFRules, LeftOperand);
                END ELSE
                    RightResult :=
                      EvaluateExpression(
                        eCDFData, eCDFRules, RightOperand);
                CASE Operator OF
                    '^':
                        Result := POWER(LeftResult, RightResult);
                    '%':
                        IF RightResult = 0 THEN BEGIN
                            Result := 0;
                            DivisionError := TRUE;
                        END ELSE
                            Result := 100 * LeftResult / RightResult;
                    '*':
                        Result := LeftResult * RightResult;
                    '/':
                        IF RightResult = 0 THEN BEGIN
                            Result := 0;
                            DivisionError := TRUE;
                        END ELSE
                            Result := LeftResult / RightResult;
                    '+':
                        Result := LeftResult + RightResult;
                    '-':
                        Result := LeftResult - RightResult;
                END;
            END ELSE
                IF (Expression[1] = '(') AND (Expression[STRLEN(Expression)] = ')') THEN
                    Result :=
                      EvaluateExpression(
                        eCDFData, eCDFRules, COPYSTR(Expression, 2, STRLEN(Expression) - 2))
                ELSE BEGIN
                    IF NOT (EVALUATE(Result, Expression)) THEN BEGIN
                        eCDFData2.SETRANGE("Statement Template Name", eCDFData."Statement Template Name");
                        eCDFData2.SETRANGE("Statement Name", eCDFData."Statement Name");
                        eCDFData2.SETRANGE("Starting Date", eCDFData."Starting Date");
                        eCDFData2.SETRANGE("Ending Date", eCDFData."Ending Date");
                        eCDFData2.SETRANGE(Version, eCDFData.Version);
                        eCDFData2.SETRANGE("Row No.", Expression);
                        IF eCDFData2.FINDFIRST THEN BEGIN
                            ldec := 0;
                            IF eCDFData2."Final Value" <> '' THEN
                                EVALUATE(ldec, eCDFData2."Final Value");
                            Result := Result + ldec;
                        END;
                    END;
                END;
        END;
        CallLevel := CallLevel - 1;
        EXIT(Result);
    end;





    local procedure EvaluateDate(PeCDFData: Record "eCDF Data"; pDay1: Code[20]; pMonth1: Code[20]; Psign: Option " ",">=","<="; pDay2: Code[20]; pMonth2: Code[20]; var PMessageText: Text[250]): Boolean
    var
        eCDFDataD1: Record "eCDF Data";
        lDate1: Date;
        lDate2: Date;
        eCDFDataD2: Record "eCDF Data";
        eCDFDataM1: Record "eCDF Data";
        eCDFDataM2: Record "eCDF Data";
        lIntD1: Integer;
        lIntD2: Integer;
        lIntM1: Integer;
        lIntM2: Integer;
        lYears: Integer;
    begin
        eCDFDataD1.RESET;
        eCDFDataD1.COPYFILTERS("eCDF Data");
        eCDFDataD1.SETRANGE("Row No.", pDay1);
        IF NOT (eCDFDataD1.FINDFIRST) THEN BEGIN
            IF pDay1 = 'TODAY' THEN
                eCDFDataD1."Final Value" := FORMAT(DATE2DMY(TODAY, 1))
            ELSE
                PMessageText := STRSUBSTNO(TextRowNumbernotfind, pDay1);
        END ELSE BEGIN
            IF NOT (EVALUATE(lIntD1, eCDFDataD1."Final Value")) THEN
                PMessageText := STRSUBSTNO(TextErrorValue, pDay1, eCDFDataD1."Final Value");
        END;

        IF PMessageText <> '' THEN
            EXIT(FALSE);

        eCDFDataD2.RESET;
        eCDFDataD2.COPYFILTERS("eCDF Data");
        eCDFDataD2.SETRANGE("Row No.", pDay2);
        IF NOT (eCDFDataD2.FINDFIRST) THEN BEGIN
            IF pDay2 = 'TODAY' THEN
                eCDFDataD2."Final Value" := FORMAT(DATE2DMY(TODAY, 1))
            ELSE
                PMessageText := STRSUBSTNO(TextRowNumbernotfind, pDay2);
        END ELSE BEGIN
            IF NOT (EVALUATE(lIntD2, eCDFDataD2."Final Value")) THEN
                PMessageText := STRSUBSTNO(TextErrorValue, pDay2, eCDFDataD2."Final Value");
        END;

        IF PMessageText <> '' THEN
            EXIT(FALSE);

        eCDFDataM1.RESET;
        eCDFDataM1.COPYFILTERS("eCDF Data");
        eCDFDataM1.SETRANGE("Row No.", pMonth1);
        IF NOT (eCDFDataM1.FINDFIRST) THEN BEGIN
            IF pMonth1 = 'TODAY' THEN
                eCDFDataM1."Final Value" := FORMAT(DATE2DMY(TODAY, 2))
            ELSE
                PMessageText := STRSUBSTNO(TextRowNumbernotfind, pMonth1);
        END ELSE BEGIN
            IF NOT (EVALUATE(lIntM1, eCDFDataM1."Final Value")) THEN
                PMessageText := STRSUBSTNO(TextErrorValue, pMonth1, eCDFDataM1."Final Value");
        END;

        IF PMessageText <> '' THEN
            EXIT(FALSE);

        eCDFDataM2.RESET;
        eCDFDataM2.COPYFILTERS("eCDF Data");
        eCDFDataM2.SETRANGE("Row No.", pMonth2);
        IF NOT (eCDFDataM2.FINDFIRST) THEN BEGIN
            IF pMonth2 = 'TODAY' THEN
                eCDFDataM2."Final Value" := FORMAT(DATE2DMY(TODAY, 2))
            ELSE
                PMessageText := STRSUBSTNO(TextRowNumbernotfind, pMonth2);
        END ELSE BEGIN
            IF NOT (EVALUATE(lIntM2, eCDFDataM2."Final Value")) THEN
                PMessageText := STRSUBSTNO(TextErrorValue, pMonth2, eCDFDataM2."Final Value");
        END;

        IF PMessageText <> '' THEN
            EXIT(FALSE);


        IF STRLEN(eCDFDataD1."Final Value") = 1 THEN
            eCDFDataD1."Final Value" := '0' + eCDFDataD1."Final Value";
        IF STRLEN(eCDFDataM1."Final Value") = 1 THEN
            eCDFDataM1."Final Value" := '0' + eCDFDataM1."Final Value";
        IF STRLEN(eCDFDataD2."Final Value") = 1 THEN
            eCDFDataD2."Final Value" := '0' + eCDFDataD2."Final Value";
        IF STRLEN(eCDFDataM2."Final Value") = 1 THEN
            eCDFDataM2."Final Value" := '0' + eCDFDataM2."Final Value";

        IF eCDFDataM1."Starting Date" = 0D THEN
            eCDFDataM1."Starting Date" := TODAY;
        IF eCDFDataM2."Starting Date" = 0D THEN
            eCDFDataM2."Starting Date" := TODAY;

        //<<AL09
        IF (COPYSTR(FORMAT(CALCDATE('<CY>', TODAY)), 1, 2)) = '31' THEN BEGIN

            //Date = DD/MM

            IF NOT EVALUATE(lDate1, eCDFDataD1."Final Value" + eCDFDataM1."Final Value" + FORMAT(DATE2DMY(eCDFDataM1."Starting Date", 3))) THEN BEGIN
                PMessageText := STRSUBSTNO(TextErrorValue, pDay1 + ' + ' + pMonth1, eCDFDataD1."Final Value" + eCDFDataM1."Final Value" + FORMAT(DATE2DMY(eCDFDataM1."Starting Date", 3)));
                EXIT(FALSE);
            END;

            IF NOT EVALUATE(lDate2, eCDFDataD2."Final Value" + eCDFDataM2."Final Value" + FORMAT(DATE2DMY(eCDFDataM2."Starting Date", 3))) THEN BEGIN
                PMessageText := STRSUBSTNO(TextErrorValue, pDay2 + ' + ' + pMonth2, eCDFDataD2."Final Value" + eCDFDataM2."Final Value" + FORMAT(DATE2DMY(eCDFDataM2."Starting Date", 3)));
                EXIT(FALSE);
            END;

        END ELSE BEGIN

            //Date = MM/DD

            IF NOT EVALUATE(lDate1, eCDFDataM1."Final Value" + eCDFDataD1."Final Value" + FORMAT(DATE2DMY(eCDFDataM1."Starting Date", 3))) THEN BEGIN
                PMessageText := STRSUBSTNO(TextErrorValue, pMonth1 + ' + ' + pDay1, eCDFDataM1."Final Value" + eCDFDataD1."Final Value" + FORMAT(DATE2DMY(eCDFDataM1."Starting Date", 3)));
                EXIT(FALSE);
            END;

            IF NOT EVALUATE(lDate2, eCDFDataM2."Final Value" + eCDFDataD2."Final Value" + FORMAT(DATE2DMY(eCDFDataM2."Starting Date", 3))) THEN BEGIN
                PMessageText := STRSUBSTNO(TextErrorValue, pMonth2 + ' + ' + pDay2, eCDFDataM2."Final Value" + eCDFDataD2."Final Value" + FORMAT(DATE2DMY(eCDFDataM2."Starting Date", 3)));
                EXIT(FALSE);
            END;

        END;
        //AL09>>

        IF Psign = Psign::" " THEN BEGIN
            PMessageText := TextErrorDate;
        END;

        IF Psign = Psign::"<=" THEN BEGIN
            IF lDate1 > lDate2 THEN
                PMessageText := TextErrorDate;
        END;

        IF Psign = Psign::">=" THEN BEGIN
            IF lDate1 < lDate2 THEN
                PMessageText := TextErrorDate;
        END;

        IF PMessageText <> '' THEN
            EXIT(FALSE)
        ELSE
            EXIT(TRUE);
    end;
}
