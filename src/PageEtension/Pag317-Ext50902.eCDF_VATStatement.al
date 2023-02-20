/// <summary>
/// PageExtension VAT Statement_Ext (ID 50902) extends Record VAT Statement.
/// </summary>
pageextension 50902 "VAT Statement_Ext" extends "VAT Statement"
{
    Caption = 'VAT Statement_Ext';
    layout
    {
        modify(Control1)
        {
            FreezeColumn = "Row No.";
        }
        addfirst(Control1)
        {
            field("Line No."; rec."Line No.")
            {
                ApplicationArea = All;

            }
        }
        addafter("Calculate with")
        {
            field(Print58833; rec.Print)
            {
                ApplicationArea = All;

            }
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = false;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = false;
        }
        addafter("VAT Bus. Posting Group")
        {
            field("VAT Lux. Bus. Posting Group"; rec."VAT Lux. Bus. Posting Group")
            {
                ApplicationArea = All;

            }
        }
        addafter("VAT Prod. Posting Group")
        {
            field("VAT Lux. Prod. Posting Group"; rec."VAT Lux. Prod. Posting Group")
            {
                ApplicationArea = All;

            }
        }
    }
}