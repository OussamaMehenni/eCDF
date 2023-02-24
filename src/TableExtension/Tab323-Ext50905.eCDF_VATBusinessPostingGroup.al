/// <summary>
/// TableExtension VAT Business Posting Group_Ext (ID 50905) extends Record VAT Business Posting Group.
/// </summary>
tableextension 50905 "VAT Business Posting Group_Ext" extends "VAT Business Posting Group"
{
    Caption = 'VAT Business Posting Group';
    fields
    {
        field(50900; "VAT Region"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = National,EU,OutsideEU;
        }

    }
}