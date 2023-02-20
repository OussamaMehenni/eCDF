tableextension 50904 "VAT Posting Setup_Ext" extends "VAT Posting Setup"
{
    Caption = 'VAT Posting Setup_Ext';

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