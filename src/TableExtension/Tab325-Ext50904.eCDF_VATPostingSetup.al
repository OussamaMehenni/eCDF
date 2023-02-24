/// <summary>
/// TableExtension VAT Posting Setup_Ext (ID 50904) extends Record VAT Posting Setup.
/// </summary>
tableextension 50904 "VAT Posting Setup" extends "VAT Posting Setup"
{
    Caption = 'VAT Posting Setup';

    fields
    {
        field(50900; "EU Goods"; Option)
        {
            Editable = true;
            Caption = 'EU Goods';
            OptionMembers = ,Investement,Good,Service;
            OptionCaption = ',Investement,Good,Service';
        }
    }
}