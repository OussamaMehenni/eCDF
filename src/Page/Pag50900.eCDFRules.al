/// <summary>
/// Page id.
/// </summary>
page 50900 "eCDF Rules"
{
    Caption = 'eCDF Rules';
    PageType = List;
    SourceTable = "eCDF Rules";
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    layout
    {

        area(content)
        {

            field(CurrentStmtTemplate; CurrentStmtTemplate)
            {
                ApplicationArea = All;
                Caption = 'Statement Template Name';
                Tooltip = 'Specifies the Statement Template Name.';
                Editable = false;
            }

            field(CurrentStmtName; CurrentStmtName)
            {
                ApplicationArea = All;
                Caption = 'Statement Name';
                Tooltip = 'Specifies the Statement Name.';
                Editable = false;
            }

            repeater(Group)
            {

                field("Statement Template Name"; Rec."Statement Template Name")
                {
                    ApplicationArea = All;
                    Caption = 'Statement Template Name';
                    Tooltip = 'Specifies the Statement Template Name.';
                    //Editable = false;
                }

                field("Statement Name"; Rec."Statement Name")
                {
                    ApplicationArea = All;
                    Caption = 'Statement Name';
                    Tooltip = 'Specifies the Statement Name.';
                    //Editable = false;
                }

                field("Row No."; Rec."Row No.")
                {
                    ApplicationArea = All;
                    Caption = 'Row No.';
                    Tooltip = 'Specifies the Row No..';
                }

                field("Rule Number"; Rec."Rule Number")
                {
                    ApplicationArea = All;
                    Caption = 'Rule Number';
                    Tooltip = 'Specifies the Rule Number.';
                }

                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Tooltip = 'Specifies the Description.';
                }

                field("Data Type"; Rec."Data Type")
                {
                    ApplicationArea = All;
                    Caption = 'Data Type';
                    Tooltip = 'Specifies the Data Type.';
                }

                field("Rule Type"; Rec."Rule Type")
                {
                    ApplicationArea = All;
                    Caption = 'Rule Type';
                    Tooltip = 'Specifies the Rule Type.';
                }

                field("Control"; Rec."Control")
                {
                    ApplicationArea = All;
                    Caption = 'Control';
                    Tooltip = 'Specifies the Control.';
                }

                field("Min. Value"; Rec."Min. Value")
                {
                    ApplicationArea = All;
                    Caption = 'Min. Value';
                    Tooltip = 'Specifies the Min. Value.';
                }

                field("Max. Value"; Rec."Max. Value")
                {
                    ApplicationArea = All;
                    Caption = 'Max. Value';
                    Tooltip = 'Specifies the Max. Value.';
                }

                field("Day1"; Rec."Day1")
                {
                    ApplicationArea = All;
                    Caption = 'Day1';
                    Tooltip = 'Specifies the Day1.';
                }

                field("Month1"; Rec."Month1")
                {
                    ApplicationArea = All;
                    Caption = 'Month1';
                    Tooltip = 'Specifies the Month1.';
                }

                field("Sign"; Rec."Sign")
                {
                    ApplicationArea = All;
                    Caption = 'Sign';
                    Tooltip = 'Specifies the Sign.';
                }

                field("Day2"; Rec."Day2")
                {
                    ApplicationArea = All;
                    Caption = 'Day2';
                    Tooltip = 'Specifies the Day2.';
                }

                field("Month2"; Rec."Month2")
                {
                    ApplicationArea = All;
                    Caption = 'Month2';
                    Tooltip = 'Specifies the Month2.';
                }

                field("Start Date Validity"; Rec."Start Date Validity")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date Validity';
                    Tooltip = 'Specifies the Start Date Validity.';
                }

                field("End Date Validity"; Rec."End Date Validity")
                {
                    ApplicationArea = All;
                    Caption = 'End Date Validity';
                    Tooltip = 'Specifies the End Date Validity.';
                }

                field("Test"; Rec."Test")
                {
                    ApplicationArea = All;
                    Caption = 'Test';
                    Tooltip = 'Specifies the Test.';
                }

            }
        }

    }

    actions
    {
        // Nothing to handle
    }

    trigger OnOpenPage()

    begin

        CurrentStmtTemplate := Rec.GetFilter("Statement Template Name");
        CurrentStmtName := Rec.GetFilter("Statement Name");

    end;

    var
        CurrentStmtTemplate: Code[10];
        CurrentStmtName: Code[10];
}