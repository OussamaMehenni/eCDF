/// <summary>
/// TableExtension VAT Entry_Ext (ID 50901) extends Record VAT Entry.
/// </summary>
tableextension 50901 "VAT Entry_Ext" extends "VAT Entry"
{
    Caption = 'VAT Entry_Ext';
    fields
    {
        field(50900; "EU Goods"; Option)
        {
            Editable = false;
            Caption = 'EU Goods';
            OptionMembers = Investement,Good,Service;
            OptionCaption = 'Investement,Good,Service';
        }
    }
}