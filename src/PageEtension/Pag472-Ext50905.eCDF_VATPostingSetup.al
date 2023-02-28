/// <summary>
/// PageExtension VAT Posting Setup_Ext (ID 50905) extends Record VAT Posting Setup.
/// </summary>
pageextension 50905 "VAT Posting Setup" extends "VAT Posting Setup"
{
    Caption = 'VAT Posting Setup';

    layout
    {
        addafter("EU Service")
        {
            field("EU Goods"; rec."EU Goods")
            {
                ApplicationArea = All;

            }
        }
    }
}