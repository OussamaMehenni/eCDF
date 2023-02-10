/// <summary>
/// Page Luxembourg VAT Data Card (ID 50).
/// </summary>
page 50902 "Luxembourg VAT Data Card"
{
    Caption = 'Luxembourg VAT Data Card';
    PageType = WorkSheet;
    SourceTable = "Luxembourg VAT Data";
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
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
                    ApplicationArea = All;
                    Caption = 'Statement Name';
                    Tooltip = 'Specifies the VAT Statement Name.';
                    Lookup = true;
                    //ApplicationAre = #Basic,#Suite
                }
            }

            group(Control2)
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

            group(Control3)
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
                }

            }

            group(Control4)
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
                    begin
                        // CLEAR(VATStatementLine);
                        // VATStatementLine.SETRANGE("Statement Template Name", Rec."Statement Template Name");
                        // VATStatementLine.SETRANGE("Statement Name", Rec."Statement Name");
                        // VATStatementLine.SETRANGE("Line No.", Rec."Line No.");
                        // VATStatementLine.FINDSET(FALSE, FALSE);

                        // CASE VATStatementLine.Type OF
                        // VATStatementLine.Type::"Account Totaling":
                        //     BEGIN
                        //     GLEntry.SETCURRENTKEY("Journal Template Name","G/L Account No.","Posting Date","Document Type");
                        //     GLEntry.SETFILTER("G/L Account No.", VATStatementLine."Account Totaling");
                        //     //COPYFILTER(VATStatementLine."Date Filter",GLEntry."Posting Date");
                        //     GLEntry.SETRANGE("Posting Date",Rec."Starting Date",Rec."Ending Date");
                        //     IF VATStatementLine."Document Type" = VATStatementLine."Document Type"::"All except Credit Memo" THEN
                        //         GLEntry.SETFILTER("Document Type",'<>%1',VATStatementLine."Document Type"::"Credit Memo")
                        //     ELSE
                        //         GLEntry.SETRANGE("Document Type",VATStatementLine."Document Type");
                        //     //EK-LU-1
                        //     IF VATStatementLine."Document Type" = VATStatementLine."Document Type"::" " THEN
                        //         GLEntry.SETRANGE("Document Type");
                        //     //EK-LU-1
                        //     PAGE.RUN(PAGE::"General Ledger Entries",GLEntry);
                        //     END;
                        // VATStatementLine.Type::"VAT Entry Totaling":
                        //     BEGIN
                        //     VATEntry.RESET;
                        //     VATEntry.SETCURRENTKEY(
                        //         "Journal Template Name",Type,Closed,"VAT Bus. Posting Group","VAT Prod. Posting Group","Document Type","Posting Date");
                        //     VATEntry.SETRANGE(Type,VATStatementLine."Gen. Posting Type");
                        //     //EK-LU-1 VATEntry.SETRANGE("VAT Bus. Posting Group","VAT Bus. Posting Group");
                        //     //EK-LU-1 VATEntry.SETRANGE("VAT Prod. Posting Group","VAT Prod. Posting Group");
                        //     VATEntry.SETFILTER("VAT Bus. Posting Group",VATStatementLine."VAT Bus. Posting Group");//EK-LU-1 
                        //     VATEntry.SETFILTER("VAT Prod. Posting Group",VATStatementLine."VAT Prod. Posting Group");//EK-LU-1 
                        //     VATEntry.SETRANGE("Tax Jurisdiction Code",VATStatementLine."Tax Jurisdiction Code");
                        //     VATEntry.SETRANGE("Use Tax",VATStatementLine."Use Tax");
                        //     IF VATStatementLine."Document Type" = VATStatementLine."Document Type"::"All except Credit Memo" THEN
                        //         VATEntry.SETFILTER("Document Type",'<>%1',VATStatementLine."Document Type"::"Credit Memo")
                        //     ELSE
                        //         VATEntry.SETRANGE("Document Type",VATStatementLine."Document Type");
                        //     //EK-LU-1
                        //     IF VATStatementLine."Document Type" = VATStatementLine."Document Type"::" " THEN
                        //         VATEntry.SETRANGE("Document Type");
                        //     //EK-LU-1
                        //     {IF GETFILTER("Date Filter") <> '' THEN
                        //         IF PeriodSelection = PeriodSelection::"Before and Within Period" THEN
                        //         VATEntry.SETRANGE("Posting Date",0D,GETRANGEMAX("Date Filter"))
                        //         ELSE
                        //         COPYFILTER("Date Filter",VATEntry."Posting Date");}
                        //     VATEntry.SETRANGE("Posting Date",Rec."Starting Date",Rec."Ending Date");
                        //     CASE Selection OF
                        //         Selection::Open:
                        //         VATEntry.SETRANGE(Closed,FALSE);
                        //         Selection::Closed:
                        //         VATEntry.SETRANGE(Closed,TRUE);
                        //         Selection::"Open and Closed":
                        //         VATEntry.SETRANGE(Closed);
                        //     END;
                        //     PAGE.RUN(PAGE::"VAT Entries",VATEntry);
                        //     END;
                        // VATStatementLine.Type::"Row Totaling",
                        // VATStatementLine.Type::Description:
                        //     ERROR(Text000,'Type',VATStatementLine.Type);
                        // END;

                    end;
                }

                field("Correction Amount"; Rec."Correction Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Correction Amount';
                    Tooltip = 'Specifies the Correction Amount.';
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

                // field("Sender"; Rec."Sender") 
                // {
                //     ApplicationArea = All;
                //     //Caption = 'Sender';
                //     Tooltip = 'Specifies the Sender.';
                // }

                // field("Time Stamp Send"; "Time Stamp Send") 
                // {
                //     ApplicationArea = All;
                //     //Caption = 'Time Stamp Send';
                //     Tooltip = 'Specifies the Time Stamp Send.';
                // }

                // field("Filename"; "Filename") 
                // {
                //     ApplicationArea = All;
                //     //Caption = 'Filename';
                //     Tooltip = 'Specifies the Filename.';
                // }

                // field("Balance Type"; "Balance Type") 
                // {
                //     ApplicationArea = All;
                //     //Caption = 'Balance Type';
                //     Tooltip = 'Specifies the Balance Type.';
                // }

                // field("Calc Total Deb. Balance Sheet"; "Calc Total Deb. Balance Sheet") 
                // {
                //     ApplicationArea = All;
                //     //Caption = 'Calc Total Deb. Balance Sheet';
                //     Tooltip = 'Specifies the Calc Total Deb. Balance Sheet.';
                // }

                // field("Calc Total Cre. Balance Sheet"; "Calc Total Cre. Balance Sheet") 
                // {
                //     ApplicationArea = All;
                //     //Caption = 'Calc Total Cre. Balance Sheet';
                //     Tooltip = 'Specifies the Calc Total Cre. Balance Sheet.';
                // }

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
        CurrentStmtTemplateName := Rec.GETFILTER("Statement Template Name");
        CurrentStmtName := Rec.GETFILTER("Statement Name");
        EVALUATE(CurrentStartingDate, Rec.GETFILTER("Starting Date"));
        EVALUATE(CurrentEndingDate, Rec.GETFILTER("Ending Date"));
        EVALUATE(CurrentStmtVersion, Rec.GETFILTER(Version));
        //Setting Header >>
        CurrentDeclarationType := CurrentDeclarationType::VAT;
        //?????
        Rec.SETRANGE("Declaration Type", CurrentDeclarationType);
        //?????
    end;

    trigger OnAfterGetRecord()
    begin

        // IF "Data Type" = "Data Type"::A THEN
        //     FinalValueEDITABLE := TRUE
        // ELSE
        //     FinalValueEDITABLE := FALSE;

    end;
}