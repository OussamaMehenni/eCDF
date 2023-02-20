pageextension 50904 "VAT Statement Names_Ext" extends "VAT Statement Names"
{
    Caption = 'VAT Statement Names_Ext';

    layout
    {
        addlast(Control1)
        {
            field("Statement eCDF Type"; Rec."Statement eCDF Type")
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