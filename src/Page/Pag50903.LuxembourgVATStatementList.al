/// <summary>
/// Page Luxembourg VAT Data List (ID 50903).
/// </summary>
page 50903 "Luxembourg VAT Statement List"
{
    Caption = 'Luxembourg VAT Data List';
    PageType = List;
    SourceTable = "Luxembourg VAT Data";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {

        area(content)
        {
            repeater(Group)
            {

                field("Statement Template Name"; Rec."Statement Template Name")
                {
                    ApplicationArea = All;
                    Caption = 'Statement Template Name';
                    Tooltip = 'Specifies the Statement Template Name.';
                    Lookup = false;
                }

                field("Statement Name"; Rec."Statement Name")
                {
                    ApplicationArea = All;
                    Caption = 'Statement Name';
                    Tooltip = 'Specifies the Statement Name.';
                    Lookup = false;
                }

                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Starting Date';
                    Tooltip = 'Specifies the Starting Date.';
                }

                field("ending Date"; Rec."ending Date")
                {
                    ApplicationArea = All;
                    Caption = 'ending Date';
                    Tooltip = 'Specifies the ending Date.';
                }

                field("Version"; Rec."Version")
                {
                    ApplicationArea = All;
                    Caption = 'Version';
                    Tooltip = 'Specifies the Version.';
                }
            }
        }
    }

    trigger OnInit()
    var
    begin
        LoadData();
    end;

    local procedure LoadData()
    var
        lLuxVATData: Record "Luxembourg VAT Data";
        lLuxVATDataToDisplay: Record "Luxembourg VAT Data";
        i: Integer;

    begin
        if (lLuxVATData.FINDSET(FALSE, FALSE)) then begin
            repeat

                if (lLuxVATDataToDisplay.GET(lLuxVATData."Statement Template Name", lLuxVATData."Statement Name", lLuxVATData."Starting Date", lLuxVATData."ending Date", lLuxVATData.Version, 1) = FALSE) THEN begin

                    lLuxVATDataToDisplay."Statement Template Name" := lLuxVATData."Statement Template Name";
                    lLuxVATDataToDisplay."Statement Name" := lLuxVATData."Statement Name";
                    lLuxVATDataToDisplay."Starting Date" := lLuxVATData."Starting Date";
                    lLuxVATDataToDisplay."Ending Date" := lLuxVATData."Ending Date";
                    lLuxVATDataToDisplay.Version := lLuxVATData.Version;
                    lLuxVATDataToDisplay."Status Header" := lLuxVATData."Status Header";
                    lLuxVATDataToDisplay.Filename := lLuxVATData.Filename;
                    lLuxVATDataToDisplay."Line No." := 1;
                    lLuxVATDataToDisplay.INSERT();

                end;

            until lLuxVATData.NEXT = 0;
        end;

        CLEARALL;
        Rec.DELETEALL(TRUE);
        if (lLuxVATDataToDisplay.FINDSET(FALSE, FALSE)) then begin
            repeat

                Rec."Statement Template Name" := lLuxVATDataToDisplay."Statement Template Name";
                Rec."Statement Name" := lLuxVATDataToDisplay."Statement Name";
                Rec."Starting Date" := lLuxVATDataToDisplay."Starting Date";
                Rec."ending Date" := lLuxVATDataToDisplay."ending Date";
                Rec.Version := lLuxVATDataToDisplay.Version;
                Rec."Status Header" := lLuxVATDataToDisplay."Status Header";
                Rec.Filename := lLuxVATDataToDisplay.Filename;
                Rec."Line No." := 1;
                Rec.INSERT();

            until lLuxVATDataToDisplay.NEXT = 0;
        end;

    end;
}