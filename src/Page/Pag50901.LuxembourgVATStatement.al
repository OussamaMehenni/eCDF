/// <summary>
/// Page Luxembourg VAT Data Card (ID 50).
/// </summary>
page 50901 "Luxembourg VAT Statement"
{
    Caption = 'Luxembourg VAT Statement';
    PageType = WorkSheet;
    SourceTable = "Luxembourg VAT Data";
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {

        area(content)
        {

            group(Statement)
            {

                field(CurrentStmtTemplateName; CurrentStmtTemplateName)
                {
                    ApplicationArea = All;
                    Caption = 'Statement Template Name';
                    Tooltip = 'Specifies the Statement Template Name.';
                    Editable = false;
                    Lookup = true;
                    LookupPageId = "VAT Statement Templates";
                }

                field(CurrentStmtName; CurrentStmtName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Statement Name';
                    Tooltip = 'Specifies the VAT Statement Name.';
                    Lookup = true;

                }
            }

            group(Date)
            {

                field(CurrentStartingDate; CurrentStartingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Starting Date';
                    Tooltip = 'Specifies the Starting Date.';
                }

                field(CurrentEndingDate; CurrentEndingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Ending Date';
                    Tooltip = 'Specifies the Ending Date.';
                }
            }

            group(Versioning)
            {

                field(CurrentStmtVersion; CurrentStmtVersion)
                {
                    ApplicationArea = All;
                    Caption = 'Version';
                    Tooltip = 'Specifies the Version.';
                    BlankZero = true;
                }

                field(CurrentDeclarationType; CurrentDeclarationType)
                {
                    ApplicationArea = All;
                    Caption = 'Declaration Type';
                    Tooltip = 'Specifies the Declaration Type.';
                    trigger OnValidate()
                    var
                    begin
                        Rec.SETFILTER("Declaration Type", '%1', CurrentDeclarationType);
                        IsIntracommMode := false;

                        //Display/hide correction button
                        IsCorrectionsENABLE := false;
                        if ((CurrentDeclarationType = Rec."Declaration Type"::INTRAG) or
                                (CurrentDeclarationType = Rec."Declaration Type"::INTRAS)) then begin
                            IsCorrectionsENABLE := true;
                            IsIntracommMode := true;
                        end;
                        CurrPage.UPDATE;
                    end;
                }

            }

            group(Data)
            {
                field("Status Header"; Rec."Status Header")
                {
                    ApplicationArea = All;
                    Caption = 'General Status';
                    Tooltip = 'Specifies the Status Header.';
                    Editable = false;
                }
            }

            Repeater(Control)
            {

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Line No.';
                    Tooltip = 'Specifies the Line No..';
                    Editable = false;
                    Visible = false;
                }

                field("Row No."; Rec."Row No.")
                {
                    ApplicationArea = All;
                    Caption = 'Row No.';
                    Tooltip = 'Specifies the Row No..';
                }

                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Tooltip = 'Specifies the Description.';
                }

                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    Tooltip = 'Specifies the Type.';
                }

                field("Amount Type"; Rec."Amount Type")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Type';
                    Tooltip = 'Specifies the Amount Type.';
                    Editable = false;
                    Visible = NOT (IsIntracommMode);
                }

                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    ApplicationArea = All;
                    Caption = 'Gen. Posting Type';
                    Tooltip = 'Specifies the Gen. Posting Type.';
                    Editable = false;
                    Visible = NOT (IsIntracommMode);
                }

                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Bus. Posting Group';
                    Tooltip = 'Specifies the VAT Bus. Posting Group.';
                    Editable = false;
                    Visible = NOT (IsIntracommMode);
                }

                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Prod. Posting Group';
                    Tooltip = 'Specifies the VAT Prod. Posting Group.';
                    Editable = false;
                    Visible = NOT (IsIntracommMode);
                }

                field("Row Totaling"; Rec."Row Totaling")
                {
                    ApplicationArea = All;
                    Caption = 'Row Totaling';
                    Tooltip = 'Specifies the Row Totaling.';
                    Editable = false;
                    Visible = NOT (IsIntracommMode);
                }

                field("Account Totaling"; Rec."Account Totaling")
                {
                    ApplicationArea = All;
                    Caption = 'Account Totaling';
                    Tooltip = 'Specifies the Account Totaling.';
                    Editable = false;
                    Visible = NOT (IsIntracommMode);
                }

                field("Calculate with"; Rec."Calculate with")
                {
                    ApplicationArea = All;
                    Caption = 'Calculate with';
                    Tooltip = 'Specifies the Calculate with.';
                    Editable = false;
                    Visible = NOT (IsIntracommMode);
                }

                field("Calculated Value"; Rec."Calculated Value")
                {
                    ApplicationArea = All;
                    Caption = 'Calculated Value';
                    Tooltip = 'Specifies the Calculated Value.';
                    Editable = false;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        VATStatementLine: Record "VAT Statement Line";
                        GLEntry: Record "G/L Entry";
                        VATEntry: Record "VAT Entry";
                        VATStmtName: Record "VAT Statement Name";
                        VATStatement: Report "VAT Statement";
                        ColumnValue: Decimal;
                        Selection: Option Open,Closed,"Open and Closed";
                        PeriodSelection: Option "Before and Within Period","Within Period";
                        UseAmtsInAddCurr: Boolean;
                        CorrectionValue: Decimal;
                        NetAmountLCY: Decimal;
                        LText50900: TextConst ENU = 'Drilldown is not possible when %1 is %2.';

                    begin
                        Clear(VATStatementLine);
                        VATStatementLine.SETRANGE("Statement Template Name", Rec."Statement Template Name");
                        VATStatementLine.SETRANGE("Statement Name", Rec."Statement Name");
                        VATStatementLine.SETRANGE("Line No.", Rec."Line No.");
                        VATStatementLine.FINDSET(FALSE, FALSE);

                        CASE VATStatementLine.Type OF
                            VATStatementLine.Type::"Account Totaling":
                                BEGIN
                                    GLEntry.SETCURRENTKEY("Journal Templ. Name", "G/L Account No.", "Posting Date", "Document Type");
                                    GLEntry.SETFILTER("G/L Account No.", VATStatementLine."Account Totaling");
                                    GLEntry.SETRANGE("Posting Date", Rec."Starting Date", Rec."Ending Date");
                                    IF VATStatementLine."Document Type" = VATStatementLine."Document Type"::"All except Credit Memo" THEN
                                        GLEntry.SETFILTER("Document Type", '<>%1', VATStatementLine."Document Type"::"Credit Memo")
                                    ELSE
                                        GLEntry.SETRANGE("Document Type", VATStatementLine."Document Type");

                                    IF VATStatementLine."Document Type" = VATStatementLine."Document Type"::" " THEN
                                        GLEntry.SETRANGE("Document Type");

                                    PAGE.RUN(PAGE::"General Ledger Entries", GLEntry);
                                END;
                            VATStatementLine.Type::"VAT Entry Totaling":
                                BEGIN
                                    VATEntry.RESET;
                                    VATEntry.SETCURRENTKEY("Journal Templ. Name", Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Document Type", "Posting Date");
                                    VATEntry.SETRANGE(Type, VATStatementLine."Gen. Posting Type");
                                    VATEntry.SETFILTER("VAT Bus. Posting Group", VATStatementLine."VAT Bus. Posting Group");
                                    VATEntry.SETFILTER("VAT Prod. Posting Group", VATStatementLine."VAT Prod. Posting Group");
                                    VATEntry.SETRANGE("Tax Jurisdiction Code", VATStatementLine."Tax Jurisdiction Code");
                                    VATEntry.SETRANGE("Use Tax", VATStatementLine."Use Tax");
                                    IF VATStatementLine."Document Type" = VATStatementLine."Document Type"::"All except Credit Memo" THEN
                                        VATEntry.SETFILTER("Document Type", '<>%1', VATStatementLine."Document Type"::"Credit Memo")
                                    ELSE
                                        VATEntry.SETRANGE("Document Type", VATStatementLine."Document Type");
                                    IF VATStatementLine."Document Type" = VATStatementLine."Document Type"::" " THEN
                                        VATEntry.SETRANGE("Document Type");
                                    VATEntry.SETRANGE("Posting Date", Rec."Starting Date", Rec."Ending Date");
                                    CASE Selection OF
                                        Selection::Open:
                                            VATEntry.SETRANGE(Closed, FALSE);
                                        Selection::Closed:
                                            VATEntry.SETRANGE(Closed, TRUE);
                                        Selection::"Open and Closed":
                                            VATEntry.SETRANGE(Closed);
                                    END;
                                    PAGE.RUN(PAGE::"VAT Entries", VATEntry);
                                END;
                            VATStatementLine.Type::"Row Totaling",
                            VATStatementLine.Type::Description:
                                ERROR(LText50900, 'Type', VATStatementLine.Type);
                        END;

                    end;
                }

                field("Correction Amount"; Rec."Correction Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Correction Amount';
                    Tooltip = 'Specifies the Correction Amount.';
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }

                field("Final Value"; Rec."Final Value")
                {
                    ApplicationArea = All;
                    Caption = 'Final Value';
                    Tooltip = 'Specifies the Final Value.';
                }

                field("Data Type"; Rec."Data Type")
                {
                    ApplicationArea = All;
                    Caption = 'Data Type';
                    Tooltip = 'Specifies the Data Type.';
                }

                field("Comment"; Rec."Comment")
                {
                    ApplicationArea = All;
                    Caption = 'Comment';
                    Tooltip = 'Specifies the Comment.';
                }

                field("IntraComm Country/Region Code"; Rec."IntraComm Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'IntraComm Country/Region Code';
                    Tooltip = 'Specifies the IntraComm Country/Region Code.';
                    Editable = false;
                    Visible = NOT (IsIntracommMode);
                }

                field("IntraComm VAT Registration No."; Rec."IntraComm VAT Registration No.")
                {
                    ApplicationArea = All;
                    Caption = 'IntraComm VAT Registration No.';
                    Tooltip = 'Specifies the IntraComm VAT Registration No..';
                    Editable = false;
                    Visible = NOT (IsIntracommMode);
                }

                field("IntraComm Customer No."; Rec."IntraComm Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'IntraComm Customer No.';
                    Tooltip = 'Specifies the IntraComm Customer No..';
                    Editable = false;
                    Visible = NOT (IsIntracommMode);
                }

                field("Correction Year"; Rec."Correction Year")
                {
                    ApplicationArea = All;
                    Caption = 'Correction Year';
                    Tooltip = 'Specifies the Correction Year.';
                    Editable = false;
                    Visible = NOT (IsIntracommMode);
                }

                field("Correction Quarter"; Rec."Correction Quarter")
                {
                    ApplicationArea = All;
                    Caption = 'Correction Quarter';
                    Tooltip = 'Specifies the Correction Quarter.';
                    Editable = false;
                    Visible = NOT (IsIntracommMode);
                }

                field("Correction Month"; Rec."Correction Month")
                {
                    ApplicationArea = All;
                    Caption = 'Correction Month';
                    Tooltip = 'Specifies the Correction Month.';
                    Editable = false;
                    Visible = NOT (IsIntracommMode);
                }

                field("Correction Triang. Op."; Rec."Correction Triang. Op.")
                {
                    ApplicationArea = All;
                    Caption = 'Correction Triang. Op.';
                    Tooltip = 'Specifies the Correction Triang. Op..';
                    Editable = false;
                    Visible = NOT (IsIntracommMode);
                }

                field("XML Tag"; Rec."XML Tag")
                {
                    ApplicationArea = All;
                    Caption = 'XML Tag';
                    Tooltip = 'Specifies the XML Tag.';
                    Editable = false;
                    Visible = false;
                }

                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    Tooltip = 'Specifies the Status.';
                    Editable = false;
                }

                field("Last Error Message"; Rec."Last Error Message")
                {
                    ApplicationArea = All;
                    Caption = 'Last Error Message';
                    Tooltip = 'Specifies the Last Error Message.';
                    Editable = false;
                }

                field("Declaration Type"; Rec."Declaration Type")
                {
                    ApplicationArea = All;
                    Caption = 'Declaration Type';
                    Tooltip = 'Specifies the Declaration Type.';
                    Editable = false;
                }

                field("Declaration Sub Type"; Rec."Declaration Sub Type")
                {
                    ApplicationArea = All;
                    Caption = 'Declaration Sub Type';
                    Tooltip = 'Specifies the Declaration Sub Type.';
                    Editable = false;

                }

                field("Statement Template Name"; Rec."Statement Template Name")
                {
                    ApplicationArea = All;
                    Caption = 'Statement Template Name';
                    Tooltip = 'Specifies the Statement Template Name.';
                    Editable = false;
                    Visible = false;
                }

                field("Statement Name"; Rec."Statement Name")
                {
                    ApplicationArea = All;
                    Caption = 'Statement Name';
                    Tooltip = 'Specifies the Statement Name.';
                    Editable = false;
                    Visible = false;
                }

                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Starting Date';
                    Tooltip = 'Specifies the Starting Date.';
                    Editable = false;
                    Visible = false;
                }

                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    Caption = 'Ending Date';
                    Tooltip = 'Specifies the Ending Date.';
                    Editable = false;
                    Visible = false;
                }

                field("Version"; Rec."Version")
                {
                    ApplicationArea = All;
                    Caption = 'Version';
                    Tooltip = 'Specifies the Version.';
                    Editable = false;
                    Visible = false;
                }
            }
        }

        area(FactBoxes)
        {
            systempart(RecordLinks; Links)
            {
                Caption = 'RecordLinks';
            }

            systempart(Notes; Notes)
            {
                Caption = 'Notes';
            }
        }
    }
    var
        CurrentStmtTemplateName: Code[20];
        CurrentStmtName: Code[10];
        CurrentStmtVersion: Integer;
        CurrentStartingDate: Date;
        CurrentEndingDate: Date;
        CurrentDeclarationType: Option VAT,INTRAG,INTRAS,INTRAT;
        IsCorrectionsENABLE: Boolean;
        IsCorrectionAmountEditable: Boolean;
        FinalValueEDITABLE: Boolean;
        IsIntracommMode: Boolean;
        TextStatus: TextConst ENU = 'Invalid Status : %1';

    trigger OnOpenPage()
    begin
        //Setting Header <<
        CurrentStmtVersion := 1;
        CurrentStmtTemplateName := Rec.GETFILTER("Statement Template Name");
        CurrentStmtName := Rec.GETFILTER("Statement Name");
        EVALUATE(CurrentStartingDate, Rec.GETFILTER("Starting Date"));
        EVALUATE(CurrentEndingDate, Rec.GETFILTER("Ending Date"));
        EVALUATE(CurrentStmtVersion, Rec.GETFILTER(Version));
        //Setting Header >>
        CurrentDeclarationType := CurrentDeclarationType::VAT;
        Rec.SETRANGE("Declaration Type", CurrentDeclarationType);
    end;

    trigger OnAfterGetRecord()
    begin
        if rec."Data Type" = rec."Data Type"::A then
            FinalValueEDITABLE := true
        else
            FinalValueEDITABLE := false;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.VALIDATE(Status, Rec.Status::B);
        Rec.CALCFIELDS("Status Header");
    end;
}