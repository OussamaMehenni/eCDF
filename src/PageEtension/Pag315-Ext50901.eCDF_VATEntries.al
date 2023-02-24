/// <summary>
/// PageExtension VAT Entries_Ext (ID 50901) extends Record VAT Entries.
/// </summary>
pageextension 50901 "VAT Entries" extends "VAT Entries"
{
    //Caption = 'VAT Entries_Ext';
    layout
    {
        addafter("EU Service")
        {
            field("EU Goods"; Rec."EU Goods")
            {
                ApplicationArea = All;

            }
        }
    }
}