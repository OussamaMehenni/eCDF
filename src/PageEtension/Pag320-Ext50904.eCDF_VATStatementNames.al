/// <summary>
/// PageExtension VAT Statement Names_Ext (ID 50904) extends Record VAT Statement Names.
/// </summary>
pageextension 50904 "VAT Statement Names" extends "VAT Statement Names"
{
    Caption = 'VAT Statement Names';

    layout
    {
        addlast(Control1)
        {
            field("Statement eCDF Type"; Rec."Statement eCDF Type")
            {
                ApplicationArea = All;
            }

            field(Periodicity; Rec.Periodicity)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        modify("Edit VAT Statement")
        {
            Caption = 'Edit eCDF Statement';
        }

        addafter("Edit VAT Statement")
        {
            action("Edit eCDF Rules")
            {
                Caption = 'Edit eCDF Rules';
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    lLuxVatRules: Record 50901;
                begin
                    CLEAR(lLuxVatRules);
                    lLuxVatRules.SetRange("Statement Template Name", Rec."Statement Template Name");
                    lLuxVatRules.SetRange("Statement Name", Rec.Name);
                    Page.Run(50902, lLuxVatRules);
                end;
            }
        }
    }
}